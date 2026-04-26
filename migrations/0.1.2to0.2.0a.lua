if storage.allowMigration == false then return end
-- Added the Name field to all Mobile Factories --
for _, MF in pairs(storage.MFTable or {}) do
    MF.name = MF.player .. "'s Mobile Factory"
end

-- Add the Data Network to all Ore Cleaners --
for _, OC in pairs(storage.oreCleanerTable or {}) do
    OC.dataNetwork = OC.MF.dataNetwork
end

-- Add the Data Network to all Fluid Extractor --
for _, FE in pairs(storage.fluidExtractorTable or {}) do
    FE.dataNetwork = FE.MF.dataNetwork
end