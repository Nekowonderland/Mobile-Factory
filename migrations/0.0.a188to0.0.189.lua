if storage.allowMigration == false then return end
-- Print Erya Tech message --
game.print("Erya Tech and Jets was removed from the Mobile Factory base Mod")
game.print("The Erya Tech and Jets are now Extensions of Mobile Factory and must be downloaded before loading the save if you don't want to lose stuff")

-- Remove old Ery Variable and Table --
storage.eryaTable = nil
storage.eryaIndexedTable = nil

-- Remove old Jets Tables --
storage.miningJetTable = nil
storage.jetFlagTable = nil
storage.constructionJetTable = nil
storage.constructionTable = nil
storage.repairJetTable = nil
storage.repairTable = nil
storage.combatJetTable = nil