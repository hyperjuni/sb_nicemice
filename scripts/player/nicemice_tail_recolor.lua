local _init = init
local _update = update
local _uninit = uninit

function init()
	_init()
	
end

function update(dt)
	_update(dt)
	if player.species() == "nicemice" then
		status.setPersistentEffects("nicemice_recolorable_tail", {"nicemice_recolorable_tail"})
	end
end

function uninit()
	_uninit()
	
end