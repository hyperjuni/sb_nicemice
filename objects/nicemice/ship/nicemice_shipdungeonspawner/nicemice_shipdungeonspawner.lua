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
function recvReplyUpgrade()
	upgradeSuccess = true
end
--  the ship lower left corner boundary marker has spawned successfully
function recvReplyBoundary()
	boundarySuccess = true
end

--  whether or not we've attempted to place a dungeon
local hasSpawned = false

function update(dt)
	pcall(awa)
end

function awa()
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
	local shipArea = rect.translate({-200, -10, 150, 90}, entity.position())
	
	if (world.getProperty("nicemice_currentShipTier") == requiredTier) or (requiredTier == "none") then
		if not hasSpawned then
			if world.loadRegion(shipArea) then
				local p = object.toAbsolutePosition({0,0})
				if config.getParameter("enableSpaceBoundary") then
					world.setProperty("nicemice_enableSpaceBoundary", true)
				end
				hasSpawned = true
				world.placeDungeon(config.getParameter("dungeon"), {p[1], p[2]});
			end
		end
	end
	
	--  keep the area we're trying to build in loaded until it's safe to despawn
	if hasSpawned then
		world.loadRegion(shipArea)
		local q = world.objectQuery(entity.position(), 5000, { objectName = "nicemice_shipconfirmupgrade" } )
		if q then
			for k, v in pairs(q) do
				world.sendEntityMessage(v,"nicemice_confirmWorldInit",{senderId = entity.id()})
			end
		end
		q = world.objectQuery(entity.position(), 5000, { objectName = "nicemice_shipspaceboundary" } )
		if q then
			for k, v in pairs(q) do
				world.sendEntityMessage(v,"nicemice_confirmWorldInit",{senderId = entity.id()})
			end
		end
	end
end