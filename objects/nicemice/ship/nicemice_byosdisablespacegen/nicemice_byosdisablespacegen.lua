require "/scripts/util.lua"
require "/scripts/rect.lua"

function init()
	object.setInteractive(false)
end

function update(dt)
	pcall(awa) -- testing indicates that anything blasting world.loadRegion should be inside pcall
end

local hasSpawned = false
function awa()
	world.setProperty("nicemice_cleanSpaceBoundary", true)
	object.smash(true)
end