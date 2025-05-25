require "/scripts/rect.lua"
require "/scripts/nicemice_util.lua"

function statusReply(args)

	--args will contain
	--	_senderId
	--	_requestedData : list of status properties we want
	if world.entityExists(args._senderId) then
		local data = {}
		for k in ipairs(args._requestedData) do
			data[k] = status.statusProperty(k, nil)
		end
		world.sendEntityMessage(args._senderId, "nicemice_npcStatusQueryReply", data)
	end
end

function itemsReply(args)
	--args will contain
	--  _senderId
	if world.entityExists(args._senderId) then
		local data = {}
		local slots = { "head", "headCosmetic", "chest", "chestCosmetic", "legs", "legsCosmetic", "back", "backCosmetic", "primary", "alt" }
		for i, v in ipairs(slots) do
			data[v] = npc.getItemSlot(v)
		end
		data["_senderId"] = entity.id()
		world.sendEntityMessage(args._senderId, "nicemice_npcItemsReply", data)
	end
end

function nicemice_initHooks(args, board)

	message.setHandler
	(
		"nicemice_npcStatusQuery",
		function(_, _, a)
			statusReply(a)
		end
	)
	
	message.setHandler
	(
		"nicemice_npcItemsQuery",
		function(_, _, a)
			itemsReply(a)
		end
	)
	
	--script.setUpdateDelta(1)
	--status.clearPersistentEffects("nicemice_mcontroller_hook")

	return true
end