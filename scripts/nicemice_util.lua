function nicemice_getPlayerSkinDirectives()
	local portrait = world.entityPortrait(entity.id(), "full")
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