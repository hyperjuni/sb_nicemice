require "/scripts/nicemice_util.lua"

function nicemice_scriptedOutpostVisitorBehavior(args, board)
	status.setPersistentEffects("nicemice_recolorable_tail", {"nicemice_recolorable_tail"})
	return nicemice_setNPCBehavior(args.behavior)
end

local _update = update
function update(dt)
	_update(dt)
	
end