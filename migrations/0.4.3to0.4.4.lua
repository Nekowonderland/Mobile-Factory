if storage.allowMigration == false then return end

for _, obj in pairs(storage.entsTable or {}) do
  if obj.ent ~= nil and obj.ent.valid == true then
    if obj.quatronCharge ~= obj.quatronCharge then
        obj.quatronCharge = 0
    end
    if obj.quatronLevel ~= obj.quatronLevel then
        obj.quatronLevel = 1
    end
    if obj.totalConsumption ~= obj.totalConsumption then
        obj.totalConsumption = 0
    end
  end
end