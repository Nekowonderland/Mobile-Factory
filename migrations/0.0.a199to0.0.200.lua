if storage.allowMigration == false then return end
storage.constructionTable = nil
storage.repairTable = nil
for id, obj in pairs(storage.networkAccessPointTable or {}) do
	obj.outOfQuatron = nil
end
for id, obj in pairs(storage.quatronReactorTable or {}) do
	obj.quatronCharge = obj.internalQuatron
	obj.internalQuatron = nil
end
for id, obj in pairs(storage.quatronLaserTable or {}) do
	if obj.ent and obj.ent.valid then
		obj.quatronCharge = obj.ent.energy
		obj.quatronMax = obj.ent.prototype.energy_usage
		obj.quatronMaxInput = obj.ent.prototype.energy_usage
		obj.quatronMaxOutput = obj.ent.prototype.energy_usage
	end
end
for id, obj in pairs(storage.quatronCubesTable or {}) do
	if obj.ent and obj.ent.valid then
		obj.quatronCharge = obj.ent.energy
		obj.quatronMax = obj.ent.electric_buffer_size
		obj.quatronMaxInput = obj.ent.electric_buffer_size / 10
		obj.quatronMaxOutput = obj.ent.electric_buffer_size / 10
	end
end
for id, mf in pairs(storage.MFTable or {}) do
	if mf.internalQuatronObj and mf.internalQuatronObj.ent and mf.internalQuatronObj.ent.valid then
		mf.internalQuatronObj.quatronCharge = mf.internalQuatronObj.ent.energy
		mf.internalQuatronObj.quatronMax = mf.internalQuatronObj.ent.electric_buffer_size
		mf.internalQuatronObj.quatronMaxInput = mf.internalQuatronObj.ent.electric_buffer_size / 10
		mf.internalQuatronObj.quatronMaxOutput = mf.internalQuatronObj.ent.electric_buffer_size / 10
	end
	mf.entitiesAround = nil
	mf.quatronLaserActivated = mf.sendQuatronActivated
	if mf.quatronLaserActivated then
		mf.selectedQuatronLaserMode = "output"
	end
	mf.sendQuatronActivated = nil
	mf.selectedEnergyLaserMode = mf.selectedPowerLaserMode
	mf.selectedPowerLaserMode = nil
end
for id, obj in pairs(storage.oreCleanerTable or {}) do
	obj.totalCharge = nil
	obj.quatronCharge = obj.charge
	obj.quatronLevel = obj.purity
end
for id, obj in pairs(storage.fluidExtractorTable or {}) do
	obj.totalCharge = nil
	obj.quatronCharge = obj.charge
	obj.quatronLevel = obj.purity
end
for k, MFPlayer in pairs(storage.playersTable or {}) do
	if MFPlayer.varTable then
		MFPlayer.varTable.ShowSendQuatronButton = nil
	end
	if MFPlayer.GUI and MFPlayer.GUI["MFMainGUI"] and MFPlayer.GUI["MFMainGUI"].buttonsTable then
		MFPlayer.GUI["MFMainGUI"].buttonsTable["SendQuatronButton"] = nil
	end
end