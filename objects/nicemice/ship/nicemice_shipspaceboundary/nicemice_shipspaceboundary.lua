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
	world.sendEntityMessage(args.senderId, "nicemice_confirmWorldInit_shipSpaceBoundary", {})
end
local shouldSmash = false
function update(dt)
	--sb.logInfo("shipSpaceBoundary upd")
	if shouldSmash then
		object.smash(true)
		return
	end
	if rockNRoll then
		pcall(awa) -- testing indicates that anything blasting world.loadRegion should be inside pcall
	end
end
function awa()
	if (config.getParameter("corner") ~= nil) and (config.getParameter("corner") ~= "unknown") then
		world.setProperty("nicemice_spaceBoundary:" .. config.getParameter("corner"), object.toAbsolutePosition({0,0}))
	end
	shouldSmash = true
end
