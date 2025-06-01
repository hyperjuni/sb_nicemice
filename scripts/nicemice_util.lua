function nicemice_getPlayerSkinDirectives()
	return nicemice_getEntitySkinDirectives(entity.id())
end

function nicemice_getEntitySkinDirectives(id)
	local portrait = world.entityPortrait(id, "full")
	if not portrait then return nil end
	for key, value in pairs(portrait) do
		if string.find(portrait[key].image, "body.png") then
			local body_image =  portrait[key].image
			local directive_location = string.find(body_image, "replace")
			local directives = string.sub(body_image,directive_location)
			return directives
		end
	end
	return nil
end

function nicemice_setNPCBehavior(b)
	--copypasted from npcs/bmain.lua @ line 34
	self.behavior = behavior.behavior(b, config.getParameter("behaviorConfig", {}), _ENV)
    self.board = self.behavior:blackboard()
    self.board:setPosition("spawn", storage.spawnPosition)	
	return true
end

function nicemice_initWorldId()
	if not world.getProperty("nicemice_worldId") then
		world.setProperty("nicemice_worldId", sb.makeUuid())
	end
end