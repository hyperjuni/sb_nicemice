require "/scripts/util.lua"
require "/scripts/rect.lua"
require "/scripts/nicemice_util.lua"

function init()
	object.setInteractive(false)
	--  set handlers for the two scripted objects we expect to spawn
	message.setHandler
	(
		"nicemice_confirmWorldInit_shipConfirmUpgrade", 
		function(_, _, sender)
			recvReplyUpgrade()
		end
	)
	message.setHandler
	(
		"nicemice_confirmWorldInit_shipSpaceBoundary", 
		function(_, _, sender)
			recvReplyBoundary()
		end
	)
end
--  the ship upgrade tier manager has spawned successfully
local upgradeSuccess = false
function recvReplyUpgrade()
	upgradeSuccess = true
	--sb.logInfo("upgrade is good")
end
--  the ship lower left corner boundary marker has spawned successfully
local boundarySuccess = false
function recvReplyBoundary()
	boundarySuccess = true
	--sb.logInfo("boundary is good")
end

--  whether or not we've attempted to place a dungeon
local hasSpawned = false

function update(dt)
	pcall(awa) -- testing indicates that anything blasting world.loadRegion should be inside pcall
end

function awa()
	--  keep the area we're trying to build in loaded until it's safe to despawn
	local shipArea = rect.translate({-200, -10, 150, 90}, entity.position())
	if hasSpawned then
		world.loadRegion(shipArea)
		local q = world.objectQuery(entity.position(), 5000, { name = "nicemice_shipconfirmupgrade" } )
		if q then
			for k, v in pairs(q) do
				if world.entityExists(v) then
					world.sendEntityMessage(v,"nicemice_confirmWorldInit",{senderId = entity.id()})
				end
			end
		end
		q = world.objectQuery(entity.position(), 5000, { name = "nicemice_shipspaceboundary" } )
		if q then
			for k, v in pairs(q) do
				if world.entityExists(v) then
					world.sendEntityMessage(v,"nicemice_confirmWorldInit",{senderId = entity.id()})
				end
			end
		end
	end
	
	--sb.logInfo("dungeonSpawner upd")
	local smashTier = config.getParameter("smashTier")
	if world.getProperty("nicemice_currentShipTier") == smashTier then
		if upgradeSuccess and boundarySuccess then
			object.smash(true)
		else
			world.loadRegion(shipArea) 
		end
		return
	end
	
	local requiredTier = config.getParameter("requiredTier")
	if (world.getProperty("nicemice_currentShipTier") == requiredTier) or (requiredTier == "none") then
		if not hasSpawned then
			if world.loadRegion(shipArea) then
				local p = object.toAbsolutePosition({0,0})
				if config.getParameter("enableSpaceBoundary") then
					world.setProperty("nicemice_enableSpaceBoundary", true)
				else
					boundarySuccess = true
				end
				hasSpawned = true
				if world.getProperty("nicemice_deadShipRecovery") then
					sb.logInfo("Recovering dead ship...")
					local recoveryDungeons = config.getParameter("recoveryDungeons")
					if recoveryDungeons then
						for d, v in ipairs(recoveryDungeons) do
							world.placeDungeon(recoveryDungeons[d], {p[1]-d, p[2]});
						end
					end
					world.setProperty("nicemice_deadShipRecovery",nil)
				end
				world.placeDungeon(config.getParameter("dungeon"), {p[1], p[2]});
			end
		end
	end
end