if storage.allowMigration == false then return end
-- Remove the Ore Cleaner products Cache --
for _, oc in pairs(storage.oreCleanerTable or {}) do
    for _, orePath in pairs(oc.oreTable) do
        orePath.products = nil
        if orePath.ent ~= nil and orePath.ent.valid == true then
            orePath.name = orePath.ent.prototype.name
        end
    end
end