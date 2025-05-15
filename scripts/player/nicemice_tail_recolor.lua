local _init = init
local _update = update
local _uninit = uninit

function init()
	_init()
	
end

function update(dt)
	_update(dt)
	if player.species() == "nicemice" then
		if not player.getProperty("nicemice_starterTail") then
			player.giveItem("nicemice_tail_mouse")
			player.setProperty("nicemice_starterTail", true)
		end
		status.setPersistentEffects("nicemice_recolorable_tail", {"nicemice_recolorable_tail"})
	end
end

function uninit()
	_uninit()
	
end