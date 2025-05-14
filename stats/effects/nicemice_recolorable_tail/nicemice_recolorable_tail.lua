require "/scripts/nicemice_util.lua"

function init()
end

function update(dt)
	local directives = nicemice_getPlayerSkinDirectives()
	effect.setParentDirectives(directives)
end

function uninit()
end
