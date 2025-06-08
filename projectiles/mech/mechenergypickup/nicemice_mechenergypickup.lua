local _findTarget = findTarget
function findTarget()
	_findTarget()
	
	if not self.targetEntity then
		local candidates = world.entityQuery(mcontroller.position(), self.snapRange, {includedTypes = {"Vehicle"}, boundMode = "position", order = "nearest"})
		for i, eid in ipairs(candidates) do
			if world.entityName(eid) == "nicemice_modularmech" then
				self.targetEntity = eid
			end
		end
	end
end
