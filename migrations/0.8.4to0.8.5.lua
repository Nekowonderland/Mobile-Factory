if storage.allowMigration == false then return end
-- Fix all Data Assembler variables --
for _, da in pairs(storage.dataAssemblerTable or {}) do
    da.energyCharge = da.quatronCharge
    da.energyLevel = da.quatronLevel
    da.quatronCharge = nil
    da.quatronLevel = nil
    da.quatronMax = nil
end