local _init = init
local _update = update
local _uninit = uninit

function init()
	_init()
	
end

function update(dt)
	_update(dt)	
	
	--check the player's equipment slots
	local slots = 
	{ 
		"head", 
		"headCosmetic", 
		"back", 
		"backCosmetic", 
		"chest", 
		"chestCosmetic", 
		"legs", 
		"legsCosmetic" 
	}
	for index, slot in ipairs(slots) do
	
		--get the item in the slot
		local item = player.equippedItem(slot)
		if item then
		
			local config = root.itemConfig(item.name)
			if config then
				
				--we only care about the config field returned in the config
				config = config.config
				
				--if this is an item nicemice can reasonably convert for usage
				if config.nicemice_convertForNicemice then
				
					--and the player is the correct species (there is only one correct species)
					if player.species() == "nicemice" then
					
						--get the replacement item's config/itemdescriptor
						local replacement = root.itemConfig(config.nicemice_convertForNicemice)
						
						--if the desired item exists, set it in the slot
						if replacement then
							player.setEquippedItem(slot, config.nicemice_convertForNicemice)
						end
					end
				end
				
				--if this is an item other races can reasonably convert for usage
				--we assume an item won't have both of these properties at the same time because that would be ztupid
				if config.nicemice_otherSpeciesConversion then
				
					--verify the player is a lesser species
					if player.species() ~= "nicemice" then
					
						--keep track of the item name we want in case there is a default value we need to fall back to
						local desiredItemName = ""
						
						--iterate conversion options
						for species, convertedItemName in pairs( config.nicemice_otherSpeciesConversion ) do
						
							--set default if there is one
							if species == "default" then
								if desiredItemName == "" then
									desiredItemName = convertedItemName
								end
							end
							
							--set the item name if we find a match for the species
							if player.species() == species then
								desiredItemName = convertedItemName
							end
						end
						
						--replace the item in the slot
						local replacement = root.itemConfig(desiredItemName)
						if replacement then
							player.setEquippedItem(slot, desiredItemName)
						end
					end
				end
			end
		end
	end
end

function uninit()
	_uninit()
	
end