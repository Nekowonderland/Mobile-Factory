if storage.allowMigration == false then return end
-- Fix all Resources Collectors --
for _, rcl in pairs(storage.ResourceCollectorTable or {}) do
    rcl.resourcesTable = {}
end
-- Rebuild the Resources Collectors Table --
local tmpTable = {}
for _, rcl in pairs(storage.ResourceCollectorTable or {}) do
    table.insert(tmpTable, rcl)
end
storage.ResourceCollectorTable = tmpTable