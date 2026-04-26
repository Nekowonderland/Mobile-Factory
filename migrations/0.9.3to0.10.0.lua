if storage.allowMigration == false then return end
-- Tell to the Player to replace all Ore Cleaners --
if table_size(storage.oreCleanerTable or {}) > 0 then
    game.print("Mobile Factory: Because Factorio doesn't allow to modify existing Entities, all Ore Cleaners must be removed and replaced manually")
end