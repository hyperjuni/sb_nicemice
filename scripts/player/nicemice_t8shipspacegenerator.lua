require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/scripts/rect.lua"
require "/scripts/nicemice_util.lua"

local _init = init
local _update = update
local _uninit = uninit

function init()
	_init()
end

CELL_SIZE = 40

function getCell(pos)
	--  get bounding box corners
	local cornerLowerLeft = world.getProperty("nicemice_spaceBoundary:lowerLeft")
	
	--  we require the lower left corner for this, should always be available
	if cornerLowerLeft then
		
		--  our lower left corner is 0, 0 for purposes of what we're doing
		local grid = vec2.sub(pos,cornerLowerLeft)
		grid[1] = math.floor(grid[1])
		grid[2] = math.floor(grid[2])
		
		local mod = (grid[1] + (CELL_SIZE * 1000)) % CELL_SIZE
		grid[1] = grid[1] - mod
		grid[1] = grid[1] / CELL_SIZE
		
		mod = (grid[2] + (CELL_SIZE * 1000)) % CELL_SIZE
		grid[2] = grid[2] - mod
		grid[2] = grid[2] / CELL_SIZE
		grid[2] = grid[2]
		
		return grid
	end
	return nil
end

avoidSpam = {}
function ignoreCell(cell)
	--sb.logInfo("processing cell: " .. tostring(cell[1]) .. ", " .. tostring(cell[2]))

	--  ignore cells that contain the T8 ship so we aren't pasting hazard blocks onto it
	if ((cell[2] >= 0) and (cell[2] <= 1)) then
		if (cell[1] >= -4) and (cell[1] <= 3) then
			return "ship"
		end
	end
	
	--  ignore any cell we have already placed a dungeon for this session (for this world id)
	if avoidSpam[world.getProperty("nicemice_worldId")] then
		for i, v in ipairs(avoidSpam[world.getProperty("nicemice_worldId")]) do
			if v[1] == cell[1] then
				if v[2] == cell[2] then
					--sb.logInfo("ignoring - spamguard")
					return "anti"
				end
			end
		end
	end
	
	--  ignore the cell if the dungeonid in it is 65525
	local cornerLowerLeft = world.getProperty("nicemice_spaceBoundary:lowerLeft")
	local approximateCellCenter = 
	{
		cornerLowerLeft[1] + (CELL_SIZE * cell[1]) + (CELL_SIZE / 2),
		cornerLowerLeft[2] + (CELL_SIZE * cell[2]) + (CELL_SIZE / 2)
	}
	local dungeonId = world.dungeonId(approximateCellCenter)
	if dungeonId then
		--  don't know if this returns a string or an int and don't care
		if tostring(dungeonId) == "65525" then
			--sb.logInfo("ignoring - dungeonId set")
			return "dungeonid"
		end
	end
	
	--  ignore the cell if it has a spawn position which would go out of bounds
	if (cornerLowerLeft[2] + (CELL_SIZE * cell[2]) + (CELL_SIZE - 1)) < 0 then
		--sb.logInfo("ignoring - below position y = 0")
		return "minheight"
	end
	
	local size = world.size()
	if (cornerLowerLeft[2] + (CELL_SIZE * cell[2])) > size[2] then
		--sb.logInfo("ignoring - above max height")
		return "maxheight"
	end
	
	return "build"
end

local timeSinceLastScan = 999.0
function update(dt)
	timeSinceLastScan = timeSinceLastScan + dt
	if timeSinceLastScan < 2 then return end
	
	--sb.logInfo("scanning")
	nicemice_initWorldId()
	--  only generate space chunks for ship worlds that are eligible for space chunks
	if world.getProperty("nicemice_enableSpaceBoundary") then
		local q = world.entityQuery(entity.position(), CELL_SIZE * 3, { includedTypes = {"stagehand"} } )
		if q then
			for k, v in pairs(q) do
				--sb.logInfo("found stagehand: " .. tostring(v) .. " -> " .. world.stagehandType(v))
				if world.stagehandType(v) == "nicemice_T8ship_spaceChunkRezzer" then
					if world.entityExists(v) then
						world.sendEntityMessage(v,"nicemice_confirmWorldInit",{senderId = entity.id()})
					end
				end
			end
		end
		--sb.logInfo("world is valid")
		--  scan in 8 directions for areas without dungeon id 65525
		local offsets = 
		{
			{-CELL_SIZE/1, CELL_SIZE/1}, {0, CELL_SIZE/1}, {CELL_SIZE/1, CELL_SIZE/1},
			{-CELL_SIZE/1,  0},          {0,0},            {CELL_SIZE/1,  0},
			{-CELL_SIZE/1,-CELL_SIZE/1}, {0,-CELL_SIZE/1}, {CELL_SIZE/1,-CELL_SIZE/1}
		}
		for i, v in ipairs(offsets) do
			local wrapped = world.xwrap(vec2.add(world.entityPosition(player.id()),v))
			local cell = getCell(wrapped)
			if cell then
				local ignore = ignoreCell(cell)
				world.debugText(ignore, vec2.add(vec2.add(entity.position(),vec2.div(v,CELL_SIZE/4)),{4,4}), { 255, 255, 0, 255 })
				if ignore == "build" then
					local cornerLowerLeft = world.getProperty("nicemice_spaceBoundary:lowerLeft")
					local cellCorner = 
					{
						cornerLowerLeft[1] + (CELL_SIZE * cell[1]),
						cornerLowerLeft[2] + (CELL_SIZE * cell[2]) + (CELL_SIZE)
					}
					cellCorner = world.xwrap(cellCorner)
					if not avoidSpam[world.getProperty("nicemice_worldId")] then
						avoidSpam[world.getProperty("nicemice_worldId")] = {}
					end
					world.spawnStagehand(cellCorner, "nicemice_T8ship_spaceChunkRezzer")
					table.insert( avoidSpam[world.getProperty("nicemice_worldId")], cell )
					sb.logInfo("Making space at cell " .. cell[1] .. ", " .. cell[2])
				end
			end
		end
	end
	_update(dt)
end

function uninit()
	_uninit()
end