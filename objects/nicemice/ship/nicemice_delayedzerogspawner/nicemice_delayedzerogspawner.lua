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
	--  if there are any spawners nearby, wait
	q = world.objectQuery(entity.position(), 5000, { name = "nicemice_shipdungeonspawner" } )
	if q then
		for k, v in pairs(q) do
			if world.entityExists(v) then
				return
			end
		end
	end
	if not hasSpawned then
		local p = object.toAbsolutePosition({0,0})
		local dungeon = config.getParameter("dungeon")
		if dungeon then
			local offset = config.getParameter("dungeonOffset")
			if offset then
				p = vec2.add(p,offset)
			end
			world.placeDungeon(dungeon, {p[1], p[2]});
		end
		hasSpawned = true
		object.smash(true)
	end
end