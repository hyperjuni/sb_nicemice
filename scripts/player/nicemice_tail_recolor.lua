local _init = init
local _update = update
local _uninit = uninit

function init()
	_init()
	
end

function update(dt)
	_update(dt)
	status.setPersistentEffects("nicemice_recolorable_tail", {"nicemice_recolorable_tail"})
end

function uninit()
	_uninit()
	
end