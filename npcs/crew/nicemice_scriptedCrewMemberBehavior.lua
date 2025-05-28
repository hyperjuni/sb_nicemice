require "/scripts/nicemice_util.lua"

function nicemice_scriptedCrewMemberBehavior(args, board)
	status.setPersistentEffects("nicemice_recolorable_tail", {"nicemice_recolorable_tail"})
	return nicemice_setNPCBehavior(args.behavior)
end

local _update = update
function update(dt)
	_update(dt)
	
	avoidCaptainsChair(dt)
end

local timeSinceLastCaptainChairScan = 999
function avoidCaptainsChair(dt)
--  scan every 5 sec
	timeSinceLastCaptainChairScan = timeSinceLastCaptainChairScan + dt
	if timeSinceLastCaptainChairScan > 3 then
	
		--  reset timer
		timeSinceLastCaptainChairScan = 0
		
		--  query nearby objects
		local objects = world.objectQuery(mcontroller.position(),10)
		if objects then
		
			--  iterate results
			for _, objectId in pairs(objects) do
			
				--  check object tags
				local tags = world.getObjectParameter(objectId,"itemTags")
				if tags then
				
					-- has tags, iterate
					for _, tag in ipairs(tags) do
					
						--  if it's the captain's chair
						if tag == "captainschair" then
							
							--  get away from it
							local chairPos  = world.entityPosition(objectId)
							if chairPos ~= nil then
							
								local curPos = mcontroller.position()
								if curPos ~= nil then
									
									--  if we're to the right of the chair, run right
									if chairPos[1] < curPos[1] then
										nicemice_setNPCBehavior("nicemice_crew_avoidCaptainsChair_npcRunRight")
										
									--  otherwise run left
									else
										nicemice_setNPCBehavior("nicemice_crew_avoidCaptainsChair_npcRunLeft")
									end
									
									--  we're done with this loop now
									break
								end
							end
						end
					end
				end
			end
		end
	end
end