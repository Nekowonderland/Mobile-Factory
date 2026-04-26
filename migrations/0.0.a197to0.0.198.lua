if storage.allowMigration == false then return end
for id, obj in pairs(storage.deepStorageTable or {}) do
	obj.entID = id
end
for id, obj in pairs(storage.deepTankTable or {}) do
	obj.entID = id
end
for id, obj in pairs(storage.fluidExtractorTable or {}) do
	obj.entID = id
end
for id, obj in pairs(storage.networkAccessPointTable or {}) do
	obj.entID = id
end
for id, obj in pairs(storage.oreCleanerTable or {}) do
	obj.entID = id
end