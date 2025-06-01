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
function update(dt)
	--sb.logInfo("shipConfirm upd")
	if shouldSmash then
		object.smash(true)
		return
	end
	if rockNRoll then
		pcall(awa) -- testing indicates that anything blasting world.loadRegion should be inside pcall
	end
end
function awa()
	local tier = config.getParameter("currentTier")
	world.setProperty("nicemice_currentShipTier", tier)
	shouldSmash = true
end