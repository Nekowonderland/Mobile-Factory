if storage.allowMigration == false then return end

-- Nil all unused Quatron Lasers variables --
for _, ql in pairs(storage.quatronLaserTable or {}) do
    ql.quatronCharge = nil
    ql.quatronLevel = nil
    ql.quatronMax = nil
    ql.quatronMaxInput = nil
    ql.quatronMaxOutput = nil
end

-- Nil all unused Quatron Cubes variables --
for _, qc in pairs(storage.quatronCubesTable or {}) do
    qc.energyLevel = qc.quatronLevel
    qc.quatronCharge = nil
    qc.quatronLevel = nil
    qc.quatronMax = nil
    qc.quatronMaxInput = nil
    qc.quatronMaxOutput = nil
end

-- Nil all unused Internal Quatron Cubes variables --
for _, iqc in pairs(storage.internalQuatronObj or {}) do
    iqc.energyLevel = iqc.quatronLevel
    iqc.quatronCharge = nil
    iqc.quatronLevel = nil
    iqc.quatronMax = nil
    iqc.quatronMaxInput = nil
    iqc.quatronMaxOutput = nil
end

-- Fix all Quatron Reactors variables --
for _, qr in pairs(storage.quatronReactorTable or {}) do
    qr.energyCharge = qr.quatronCharge
    qr.energyLevel = qr.quatronLevel
    qr.quatronCharge = nil
    qr.quatronLevel = nil
    qr.quatronMax = nil
    qr.quatronMaxInput = nil
    qr.quatronMaxOutput = nil
end

-- Fix all Network Access Points variables --
for _, nap in pairs(storage.networkAccessPointTable or {}) do
    nap.energyCharge = nap.quatronCharge
    nap.energyLevel = nap.quatronLevel
    nap.quatronCharge = nil
    nap.quatronLevel = nil
    nap.quatronMax = nil
    nap.quatronMaxInput = nil
    nap.quatronMaxOutput = nil
end

-- Fix all Fluid Extractors variables --
for _, fe in pairs(storage.fluidExtractorTable or {}) do
    fe.energyCharge = fe.quatronCharge
    fe.energyLevel = fe.quatronLevel
    fe.quatronCharge = nil
    fe.quatronLevel = nil
    fe.quatronMax = nil
    fe.quatronMaxInput = nil
    fe.quatronMaxOutput = nil
end

-- Fix all Ore Cleaners variables --
for _, oc in pairs(storage.fluidExtractorTable or {}) do
    oc.energyCharge = oc.quatronCharge
    oc.energyLevel = oc.quatronLevel
    oc.quatronCharge = nil
    oc.quatronLevel = nil
    oc.quatronMax = nil
    oc.quatronMaxInput = nil
    oc.quatronMaxOutput = nil
end