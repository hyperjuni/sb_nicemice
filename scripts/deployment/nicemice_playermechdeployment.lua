local _deploy = deploy

function deploy(itemSet, primaryColorIndex, secondaryColorIndex)
  if player.species() ~= "nicemice" then
    _deploy(itemSet, primaryColorIndex, secondaryColorIndex)
  else
    despawnMech()
    player.stopLounging()
    
    buildMechParameters(itemSet, primaryColorIndex, secondaryColorIndex)
    self.mechParameters.ownerEntityId = self.playerId
    self.mechParameters.startEnergyRatio = storage.inMechWithEnergyRatio
    storage.inMechWithEnergyRatio = nil
    storage.inMechWithWorldType = nil
    storage.vehicleId = world.spawnVehicle("nicemice_modularmech", spawnPosition(), self.mechParameters)
    
    player.lounge(storage.vehicleId)
  end 
end