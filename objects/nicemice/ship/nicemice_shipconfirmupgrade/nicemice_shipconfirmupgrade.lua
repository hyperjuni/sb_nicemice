require "/scripts/util.lua"

function init()
	object.setInteractive(false)
	message.setHandler
	(
		"nicemice_confirmWorldInit", 
		function(_, _, args)
			letsRock(args)
		end
	)
end
local rockNRoll = false
function letsRock(args)
	rockNRoll = true
	world.sendEntityMessage(args.senderId, "nicemice_confirmWorldInit_shipConfirmUpgrade", {})
end
local shouldSmash = false
local killTicks = 100
function update(dt)
	killTicks = killTicks - 1
	if killTicks <= 0 then
		shouldSmash = true
	end
	if shouldSmash then
		object.smash(true)
		return
	end
	if config.getParameter("deadShipRecovery") then
		rockNRoll = true
	end
	if rockNRoll then
		pcall(awa) -- testing indicates that anything blasting world.loadRegion should be inside pcall
	end
end

function awa()
	local curtier = world.getProperty("nicemice_currentShipTier")
	if not curtier then 
		curtier = "none" 
	end
	if curtier == config.getParameter("requiredTier") then
		local tier = config.getParameter("currentTier")
		world.setProperty("nicemice_currentShipTier", tier)
		shouldSmash = true
		
		-- if this goes off, fire all the dungeons
		if config.getParameter("deadShipRecovery") then
			world.setProperty("nicemice_deadShipRecovery", true)
		end
	end
end