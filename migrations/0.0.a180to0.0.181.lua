if storage.allowMigration == false then return end
-- Create the Jump Drive Object --
for k, mf in pairs(storage.MFTable or {}) do
    mf.jumpDriveObj = JD:new(mf)
    -- Removing old unused Variables --
    mf.jumpTimer = nil
    mf.baseJumpTimer = nil
    mf.fChest = nil
end

-- Removing old unused Variables --
storage.insertedMFInsideInventory = nil