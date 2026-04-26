if storage.allowMigration == false then return end
-- Creating the Objects Table --
storage.objectsTable = {}

-- Creating the Resource Collectors Table --
storage.ResourceCollectorTable = {}
for _, oc in pairs(storage.oreCleanerTable or {}) do
    -- Check the Ore Cleaner --
    if oc.ent ~= nil and oc.ent.valid == true then
        -- Create the Resource Collector Table --
        oc.meta = "RCL"
        oc.resourcesTable = oc.oreTable
        oc.oreTable = nil
        oc.lastOreDNSend = oc.lastDNSend or 0
        oc.lastDNSend = nil
	    oc.lastFluidDNSend = 0
        oc.lastScan = oc.lastScan or 0
        oc.consumption = 0
        oc.collectOres = true
	    oc.collectFluids = true
        oc.energy = oc.energy or 0
        oc.energyLevel = oc.energyLevel or 1
        oc.energyBuffer = _mfRCLMaxCharge


        -- Get the Inventory --
	    oc.chest = oc.ent.get_inventory(defines.inventory.chest)

	    -- Create the Tank --
	    oc.tank = oc.ent.surface.create_entity{name="ResourcesCollectorTank", position=oc.ent.position, force=oc.ent.force}

        -- Save the Resource Collector --
        table.insert(storage.ResourceCollectorTable, oc)
        -- Remove the Ore Cleaner from the Entities Table --
        storage.entsTable[oc.entID] = nil
        -- Add the Resource Collector to the Object Table --
        storage.objectsTable[oc.entID] = oc
    end
end

-- Removing the Ore Cleaners Table --
storage.oreCleanerTable = nil

-- Telling peoples than the Fluid Extractor is removed --
if table_size(storage.fluidExtractorTable or {}) > 0 then
    game.print("The Fluid Extractor was removed and replaced by the Resources Collector")
end

-- Removing the Fluid Extractors Table --
storage.fluidExtractorTable = nil