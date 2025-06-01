require "/scripts/util.lua"
require "/scripts/rect.lua"
function init()
	message.setHandler
	(
		"nicemice_confirmWorldInit", 
		function(_, _, sender)
			letsRock()
		end
	)
end
local rockNRoll = false
function letsRock()
	rockNRoll = true
end
local shouldDie = false
function update(dt)
	if shouldDie then
		stagehand.die()
	end
	if rockNRoll then
		pcall(awa) -- testing indicates that anything blasting world.loadRegion should be inside pcall
	end
end
function awa()
	local region = rect.translate({-40, -40, 120, 120}, stagehand.position())
	if world.loadRegion(region) then
		world.placeDungeon("nicemice_T8ship_spaceChunk",stagehand.position())
		shouldDie = true
	end
end