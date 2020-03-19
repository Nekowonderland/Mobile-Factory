-- Create the Mobile Factory Object --
MF = {
	ent = nil,
	player = "",
	updateTick = 1,
	lastUpdate = 0,
	lastSurface = nil,
	lastPosX = 0,
	lastPosY = 0,
	fS = nil,
	ccS = nil,
	II = nil,
	dataCenter = nil,
	entitiesAround = nil,
	internalEnergy = _mfInternalEnergy,
	maxInternalEnergy = _mfInternalEnergyMax,
	jumpTimer = _mfBaseJumpTimer,
	baseJumpTimer = _mfBaseJumpTimer,
	tpEnabled = true,
	locked = true,
	laserRadiusMultiplier = 0,
	laserDrainMultiplier = 0,
	laserNumberMultiplier = 0,
	energyLaserActivated = false,
	fluidLaserActivated = false,
	itemLaserActivated = false,
	selectedInventory = nil,
	IDModule = 0,
	internalEnergyDistributionActivated = false,
	sendQuatronActivated = false,
	selectedPowerLaserMode = "input", -- input, output
	selectedFluidLaserMode = "input", -- input, output
	syncAreaID = 0,
	syncAreaInsideID = 0,
	syncAreaEnabled = true,
	syncAreaScanned = false,
	clonedResourcesTable = nil, -- {original, cloned}
	varTable = nil
}

-- Constructor --
function MF:new()
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = MF
	t.entitiesAround = {}
	t.clonedResourcesTable = {}
	t.varTable = {}
	t.varTable.tech = {}
	t.varTable.tanks = {}
	t.varTable.jets = {}
	UpSys.addObj(t)
	return t
end

-- Constructor for a placed Mobile Factory --
function MF:construct(object)
	if object == nil then return end
	if self.fS == nil then createMFSurface(self) end
	if self.ccS == nil then createControlRoom(self) end
	self.ent = object
	self.lastSurface = object.surface
	self.lastPosX = object.position.x
	self.lastPosY = object.position.y
end

-- Reconstructor --
function MF:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = MF
	setmetatable(object, mt)
	INV:rebuild(object.II)
	DCMF:rebuild(object.dataCenter)
end

-- Destructor --
function MF:remove()
	self.ent = nil
	self.internalEnergy = 0
	self.jumpTimer = _mfBaseJumpTimer
end

-- Is valid --
function MF:valid()
	return true
end

-- Tooltip Infos --
function MF:getTooltipInfos(GUI)

	-- Create the Belongs to Label --
	local belongsToL = GUI.add{type="label", caption={"", {"gui-description.BelongsTo"}, ": ", self.player}}
	belongsToL.style.font = "LabelFont"
	belongsToL.style.font_color = _mfOrange

	if canModify(getPlayer(GUI.player_index).name, self.ent) == false then return end

	-- Create the Power laser Label --
	if technologyUnlocked("EnergyDrain1", getForce(self.player)) then


		-- Create the Power Laser label --
		local connectedL = GUI.add{type="label"}
		connectedL.style.font = "LabelFont"
		connectedL.caption = {"",{"gui-description.PowerLaser"}, ":"}
		connectedL.style.font_color = {92, 232, 54}

		local state = "left"

		if self.selectedPowerLaserMode == "output" then state = "right" end
		
		local modeSwitch = GUI.add{type="switch", name="MFPL", allow_none_state=false, switch_state=state}
		modeSwitch.left_label_caption = {"gui-description.Drain"}
		modeSwitch.left_label_tooltip = {"gui-description.DrainTT"}
		modeSwitch.right_label_caption = {"gui-description.Send"}
		modeSwitch.right_label_tooltip = {"gui-description.SendTT"}
	end

	if technologyUnlocked("FluidDrain1", getForce(self.player)) then
		-- Create the Fluid Laser Mode Selection --
		-- Create the Mode Label --
		local modeLabel = GUI.add{type="label", caption={"",{"gui-description.FluidLaser"}, ":"}}
		modeLabel.style.top_margin = 7
		modeLabel.style.font = "LabelFont"
		modeLabel.style.font_color = {92, 232, 54}

		local state = "left"

		if self.selectedFluidLaserMode == "output" then state = "right" end
		
		local modeSwitch = GUI.add{type="switch", name="MFFMode", allow_none_state=false, switch_state=state}
		modeSwitch.left_label_caption = {"gui-description.Input"}
		modeSwitch.left_label_tooltip = {"gui-description.InputTT"}
		modeSwitch.right_label_caption = {"gui-description.Output"}
		modeSwitch.right_label_tooltip = {"gui-description.OutputTT"}

		-- Create the Inventory Selection --
		-- Create the targeted Inventory label --
		local targetLabel = GUI.add{type="label", caption={"", {"gui-description.MSTarget"}, ":"}}
		targetLabel.style.top_margin = 7
		targetLabel.style.font = "LabelFont"
		targetLabel.style.font_color = {108, 114, 229}

		-- Create the List --
		local invs = {{"", {"gui-description.Any"}}}
		local selectedIndex = 1
		local i = 1
		for k, deepTank in pairs(global.deepTankTable) do
			if deepTank ~= nil and deepTank.ent ~= nil and Util.canUse(self.player, deepTank.ent) then
				i = i + 1
				local itemText = {"", " (", {"gui-description.Empty"}, " - ", deepTank.player, ")"}
				if deepTank.filter ~= nil and game.fluid_prototypes[deepTank.filter] ~= nil then
					itemText = {"", " (", game.fluid_prototypes[deepTank.filter].localised_name, " - ", deepTank.player, ")"}
				elseif deepTank.inventoryFluid ~= nil and game.fluid_prototypes[deepTank.inventoryFluid] ~= nil then
					itemText = {"", " (", game.fluid_prototypes[deepTank.inventoryFluid].localised_name, " - ", deepTank.player, ")"}
				end
				invs[k+1] = {"", {"gui-description.DT"}, " ", tostring(deepTank.ID), itemText}
				if self.selectedInv == deepTank then
					selectedIndex = i
				end
			end
		end
		if selectedIndex ~= nil and selectedIndex > table_size(invs) then selectedIndex = nil end
		local invSelection = GUI.add{type="list-box", name="MFFTarget", items=invs, selected_index=selectedIndex}
		invSelection.style.width = 100
	end
end

-- Change the Mode --
function MF:fluidLaserMode(mode)
    if mode == "left" then
        self.selectedFluidLaserMode = "input"
    elseif mode == "right" then
        self.selectedFluidLaserMode = "output"
    end
end

-- Change the Fluid Laser Targeted Inventory --
function MF:fluidLaserTarget(ID)
	-- Check the ID --
    if ID == nil then
        self.selectedInv = nil
        return
    end
	-- Select the Inventory --
	self.selectedInv = nil
	for k, deepTank in pairs(global.deepTankTable) do
		if valid(deepTank) then
			if ID == deepTank.ID then
				self.selectedInv = deepTank
			end
		end
	end
end

-- Update the Mobile Factory --
function MF:update(event)
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick
	-- Get the current tick --
	local tick = event.tick
	-- Update the Jump Drives --
	if event.tick%_eventTick60 == 0 and self.jumpTimer > 0 and self.internalEnergy > _mfJumpEnergyDrain then
		self.jumpTimer = self.jumpTimer -1
		self.internalEnergy = self.internalEnergy - _mfJumpEnergyDrain
	end
	-- Update the Internal Inventory --
	if tick%_eventTick80 == 0 then self.II:rescan() end
	--Update all lasers --
	if tick%_eventTick60 == 0 then self:updateLasers() end
	-- Update the Fuel --
	if tick%_eventTick27 == 0 then self:updateFuel() end
	-- Scan Entities Around --
	if tick%_eventTick90 == 0 then self:scanEnt() end
	-- Update the Shield --
	self:updateShield(event)
	-- Update Pollution --
	if event.tick%_eventTick1200 == 0 then self:updatePollution() end
	-- Update Teleportation Box --
	if event.tick%_eventTick5 == 0 then self:factoryTeleportBox() end
	-- Read Modules inside the Equalizer --
	if event.tick%_eventTick125 == 0 then self:scanModules() end
	-- Update accumulators --
	if event.tick%_eventTick38 == 0 then self:updateAccumulators() end
	-- Send Quatron Charge --
	if self.sendQuatronActivated == true then
		self:SendQuatronToOC(event)
		self:SendQuatronToFE(event)
	end
	-- Update the Sync Area --
	if tick%_eventTick30 == 0 then self:updateSyncArea() end
end

-- Return the Lasers radius --
function MF:getLaserRadius()
	return _mfBaseLaserRadius + (self.laserRadiusMultiplier * 2)
end

-- Return the Energy Lasers Drain --
function MF:getLaserEnergyDrain()
	return _mfEnergyDrain * (self.laserDrainMultiplier + 1)
end

-- Return the Fluid Lasers Drain --
function MF:getLaserFluidDrain()
	return _mfFluidDrain * (self.laserDrainMultiplier + 1)
end

-- Return the Logistic Lasers Drain --
function MF:getLaserItemDrain()
	return _mfItemsDrain * (self.laserDrainMultiplier + 1)
end

-- Return the number of Lasers --
function MF:getLaserNumber()
	return _mfBaseLaserNumber + self.laserNumberMultiplier
end

-- Return the Shield --
function MF:shield()
	if self.ent == nil or self.ent.valid == false or self.ent.grid == nil then return 0 end
	return self.ent.grid.shield
end

-- Return the max Shield --
function MF:maxShield()
	if self.ent == nil or self.ent.valid == false or self.ent.grid == nil then return 0 end
	return self.ent.grid.max_shield
end

-- Change the Power Laser to Drain or Send mode --
function MF:changePowerLaserMode(mode)
	if mode == "left" then
        self.selectedPowerLaserMode = "input"
    elseif mode == "right" then
        self.selectedPowerLaserMode = "output"
    end
end

-- Scan all Entities around the Mobile Factory --
function MF:scanEnt()
	-- Check the Mobile Factory --
	if self.ent == nil or self.ent.valid == false then return end
	-- Look for Entities --
	self.entitiesAround = self.ent.surface.find_entities_filtered{position=self.ent.position, radius=self:getLaserRadius()}
	-- Filter the Entities --
	for k, entity in pairs(self.entitiesAround) do
		local keep = false
		-- Keep Electric Entity --
		if entity.energy ~= nil and entity.electric_buffer_size ~= nil then
			keep = true
		end
		-- Keep Tank --
		if entity.type == "storage-tank" then
			keep = true
		end
		-- Keep Container --
		if entity.type == "container" or entity.type == "logistic-container" then
			keep = true
		end
		-- Removed not keeped Entity --
		if keep == false or Util.canUse(self.player, entity) == false then
			self.entitiesAround[k] = nil
		end
	end
end

-- Update lasers of the Mobile Factory --
function MF:updateLasers()
	-- Check the Mobile Factory --
	if self.ent == nil or self.ent.valid == false then return end
	-- Create all Lasers --
	i = 1
	for k, entity in pairs(self.entitiesAround or {}) do
		if entity ~= nil and entity.valid == true then
			local laserUsed = false
			if self:updateEnergyLaser(entity) == true then laserUsed = true end
			if self:updateFluidLaser(entity) == true then laserUsed = true end
			if self:updateLogisticLaser(entity) == true then laserUsed = true end
			if laserUsed == true then i = i + 1 end
			if i > self:getLaserNumber() then return end
		end
	end
end

-------------------------------------------- Energy Laser --------------------------------------------
function MF:updateEnergyLaser(entity)
	-- Check if a laser should be created --
	if technologyUnlocked("EnergyDrain1", getForce(self.player)) == false or self.energyLaserActivated == false then return false end
	-- Create the Laser --
	local mobileFactory = false
	if string.match(entity.name, "MobileFactory") then mobileFactory = true end
	-- Exclude Mobile Factory, Character, Power Drain Pole and Entities with 0 energy --
	if mobileFactory == false and entity.type ~= "character" and entity.name ~= "PowerDrainPole" and entity.name ~= "OreCleaner" and entity.name ~= "FluidExtractor" and entity.energy ~= nil and entity.electric_buffer_size ~= nil then
		----------------------- Drain Power -------------------------
		if self.selectedPowerLaserMode == "input" and entity.energy > 0 then
			-- Missing Internal Energy or Structure Energy --
			local energyDrain = math.min(self.maxInternalEnergy - self.internalEnergy, entity.energy)
			-- EnergyDrain or LaserDrain Caparity --
			local drainedEnergy = math.min(self:getLaserEnergyDrain(), energyDrain)
			-- Test if some Energy was drained --
			if drainedEnergy > 0 then
				-- Add the Energy to the Mobile Factory Batteries --
				self.internalEnergy = self.internalEnergy + drainedEnergy
				-- Remove the Energy from the Structure --
				entity.energy = entity.energy - drainedEnergy
				-- Create the Beam --
				self.ent.surface.create_entity{name="BlueBeam", duration=60, position=self.ent.position, target_position=entity.position, source_position={self.ent.position.x,self.ent.position.y}}
				-- One less Beam to the Beam capacity --
				return true
			end
		elseif self.selectedPowerLaserMode == "output" and entity.energy < entity.electric_buffer_size then
			-- Structure missing Energy or Laser Power --
			local energySend = math.min(entity.electric_buffer_size - entity.energy , self:getLaserEnergyDrain())
			-- Energy Send or Mobile Factory Energy --
			energySend = math.min(self.internalEnergy, energySend)
			-- Check if Energy can be send --
			if energySend > 0 then
				-- Add the Energy to the Entity --
				entity.energy = entity.energy + energySend
				-- Remove the Energy from the Mobile Factory --
				self.internalEnergy = self.internalEnergy - energySend
				-- Create the Beam --
				self.ent.surface.create_entity{name="BlueBeam", duration=60, position=self.ent.position, target_position=entity.position, source_position={self.ent.position.x,self.ent.position.y}}
				-- One less Beam to the Beam capacity --
				return true
			end
		end
	end
end

-------------------------------------------- Fluid Laser --------------------------------------------
function MF:updateFluidLaser(entity)
	-- Check if a laser should be created --
	if technologyUnlocked("FluidDrain1", getForce(self.player)) == false or self.fluidLaserActivated == false then return false end
	if entity.type ~= "storage-tank" or self.selectedInv == nil then return false end

	-- Get both Tanks and their characteristics --
    local localTank = entity
    local distantTank = self.selectedInv
    local localFluid = nil
	local localAmount = nil
	
	-- Get the Fluid inside the local Tank --
    for k, i in pairs(localTank.get_fluid_contents()) do
        localFluid = k
        localAmount = i
	end
	
	-- Input mode --
    if self.selectedFluidLaserMode == "input" then
        -- Check the local and distant Tank --
        if localFluid == nil or localAmount == nil then return end
        if distantTank:canAccept(localFluid) == false then return end
        -- Send the Fluid --
        local amountAdded = distantTank:addFluid(localFluid, localAmount)
        -- Remove the local Fluid --
		localTank.remove_fluid{name=localFluid, amount=amountAdded}
		if amountAdded > 0 then
			-- Create the Laser --
			self.ent.surface.create_entity{name="PurpleBeam", duration=60, position=self.ent.position, target=localTank.position, source=self.ent.position}
			-- Drain Energy --
			self.internalEnergy = self.internalEnergy - (_mfFluidConsomption*amountAdded)
			-- One less Beam to the Beam capacity --
			return true
		end
    elseif self.selectedFluidLaserMode == "output" then
        -- Check the local and distant Tank --
        if localFluid ~= nil and localFluid ~= distantTank.inventoryFluid then return end
        if distantTank.inventoryFluid == nil or distantTank.inventoryCount == 0 then return end
        -- Get the Fluid --
        local amountAdded = localTank.insert_fluid({name=distantTank.inventoryFluid, amount=distantTank.inventoryCount})
        -- Remove the distant Fluid --
		distantTank:getFluid(distantTank.inventoryFluid, amountAdded)
		if amountAdded > 0 then
			-- Create the Laser --
			self.ent.surface.create_entity{name="PurpleBeam", duration=60, position=self.ent.position, target=localTank.position, source=self.ent.position}
			-- Drain Energy --
			self.internalEnergy = self.internalEnergy - (_mfFluidConsomption*amountAdded)
			-- One less Beam to the Beam capacity --
			return true
		end
    end
end

-------------------------------------------- Logistic Laser --------------------------------------------
function MF:updateLogisticLaser(entity)
	-- Check if a laser should be created --
	if technologyUnlocked("TechItemDrain", getForce(self.player)) == false or self.itemLaserActivated == false then return false end 
	-- Create the Laser --
	if self.itemLaserActivated == true and self.internalEnergy > _mfBaseItemEnergyConsumption * self:getLaserItemDrain() and (entity.type == "container" or entity.type == "logistic-container") then
		-- Get Chest Inventory --
		local inv = entity.get_inventory(defines.inventory.chest)
		-- Get the Internal Inventory --
		local dataInv = self.II
		if inv ~= nil and inv.valid == true then
			-- Create the Laser Capacity variable --
			local capItems = self:getLaserItemDrain()
			-- Get all Items --
			local invItems = inv.get_contents()
			-- Retrieve Items from the Inventory --
			for iName, iCount in pairs(invItems) do
				local added = dataInv:addItem(iName, math.min(iCount, capItems))
				-- Check if Items was added --
				if added > 0 then
					-- Remove Items from the Chest --
					local removedItems = inv.remove({name=iName, count=added})
					-- Recalcule the capItems --
					capItems = capItems - added
					-- Create the laser and remove energy --
					if added > 0 then
						self.ent.surface.create_entity{name="GreenBeam", duration=60, position=self.ent.position, target=entity.position, source=self.ent.position}
						self.internalEnergy = self.internalEnergy - _mfBaseItemEnergyConsumption * removedItems
						-- One less Beam to the Beam capacity --
						return true
					end
					-- Test if capItems is empty --
					if capItems <= 0 then
						-- Stop --
						break
					end
				end
			end
		end
	end
end

-- Update the Fuel --
function MF:updateFuel()
	-- Check if the Mobile Factory is valid --
	if self.ent == nil or self.ent.valid == false then return end
	-- Recharge the tank fuel --
	if self.internalEnergy > 0 and self.ent.get_inventory(defines.inventory.fuel).get_item_count() < 2 then
		if self.ent.burner.remaining_burning_fuel == 0 and self.ent.get_inventory(defines.inventory.fuel).is_empty() == true then
			-- Insert coal in case of the Tank is off --
			self.ent.get_inventory(defines.inventory.fuel).insert({name="coal", count=1})
		elseif self.ent.burner.remaining_burning_fuel > 0 then
			-- Calcule the missing Fuel amount --
			local missingFuelValue = math.floor((_mfMaxFuelValue - self.ent.burner.remaining_burning_fuel) /_mfFuelMultiplicator)
			if math.floor(missingFuelValue/_mfFuelMultiplicator) < self.internalEnergy then
				-- Add the missing Fuel to the Tank --
				self.ent.burner.remaining_burning_fuel = _mfMaxFuelValue
				-- Drain energy --
				self.internalEnergy = math.floor(self.internalEnergy - missingFuelValue/_mfFuelMultiplicator)
			end
		end
	end
end

-- Update the Shield --
function MF:updateShield(event)
	-- Get the current tick --
	local tick = event.tick
	-- Check if the Mobile Factory is valid --
	if self.ent == nil or self.ent.valid == false then return end
	-- Create the visual --
	if self:shield() > 0 then
		-- Calcule the shield tint --
		local tint = self:shield() / self:maxShield()
		-- Calcule the shield size --
		local mfB = self.ent.selection_box
		local size = (mfB.right_bottom.y - mfB.left_top.y) / 12
		rendering.draw_animation{animation="mfShield", target={self.ent.position.x-0.25, self.ent.position.y-0.3}, tint={1,tint,tint}, time_to_live=2, x_scale=size, y_scale=size, surface=self.ent.surface, render_layer=134}
	end
	-- Charge the Shield --
	local chargeSpeed = 10
	if tick%60 == 0 and self.internalEnergy > 0 then
		-- Get the Shield --
		for k, equipment in pairs(self.ent.grid.equipment) do
			-- Check if this is a Shield --
			if equipment.name == "mfShieldEquipment" then
				local missingCharge = equipment.max_shield - equipment.shield
				local chargeAmount = math.min(missingCharge, chargeSpeed)
				-- Check if the Shield can be charged --
				if chargeAmount > 0 and chargeAmount*_mfShieldComsuption <= self.internalEnergy then
					 -- Charge the Shield --
					 equipment.shield = equipment.shield + chargeAmount
					 -- Remove the energy --
					 self.internalEnergy = self.internalEnergy - chargeAmount*_mfShieldComsuption
				end
			end
		end
	end
end


-- Send Quatron Charge to the Ore Cleaner --
function MF:SendQuatronToOC(event)
	-- Check if the Mobile Factory is valid --
	if self.ent == nil or self.ent.valid == false then return end
	-- Send Charge only every 10 ticks --
	if event.tick%10 ~= 0 then return end
	for k, oc in pairs(global.oreCleanerTable) do
	-- Check the Distance --
		if valid(oc) == true and oc.player == self.player and Util.distance(self.ent.position, oc.ent.position) < _mfOreCleanerMaxDistance then
			-- Test if there are space inside the Ore Cleaner for Quatron Charge --
			if oc.charge <= _mfFEMaxCharge - 100 then
				-- Get the Best Quatron Change --
				local charge = self.II:getBestQuatron()
				if charge > 0 then
					-- Add the Charge --
					oc:addQuatron(charge)
					-- Create the Laser --
					self.ent.surface.create_entity{name="GreenBeam", duration=30, position=self.ent.position, target={oc.ent.position.x, oc.ent.position.y - 2}, source=self.ent}
				end
			end
		end
	end
end

-- Send Quatron Charge to all Fluid Extractors --
function MF:SendQuatronToFE(event)
	-- Check if the Mobile Factory is valid --
	if self.ent == nil or self.ent.valid == false then return end
	-- Send Charge only every 10 ticks --
	if event.tick%10 ~= 0 then return end
	for k, fe in pairs(global.fluidExtractorTable) do
		-- Check if the Fluid Extractor is valid --
		if valid(fe) == true and fe.player == self.player and Util.distance(self.ent.position, fe.ent.position) < _mfFluidExtractorMaxDistance then
			-- Test if there are space inside the Fluid Extractor for Quatron Charge --
			if fe.charge <= _mfFEMaxCharge - 100 then
				-- Get the Best Quatron Change --
				local charge = self.II:getBestQuatron()
				if charge > 0 then
					-- Add the Charge --
					fe:addQuatron(charge)
					-- Create the Laser --
					fe.ent.surface.create_entity{name="GreenBeam", duration=30, position=self.ent.position, target={fe.ent.position.x, fe.ent.position.y - 2}, source=self.ent}
				end
			end
		end
	end
end

-- Send all Pollution outside --
function MF:updatePollution()
	-- Test if the Mobile Factory is valid --
	if self.fS == nil or self.ent == nil then return end
	if self.ent.valid == false then return end
	if self.ent.surface == nil then return end
	-- Get the total amount of Pollution --
	local totalPollution = self.fS.get_total_pollution()
	if totalPollution ~= nil then
		-- Create Pollution outside the Factory --
		self.ent.surface.pollute(self.ent.position, totalPollution)
		-- Clear the Factory Pollution --
		self.fS.clear_pollution()
	end
end

-- Update teleportation box --
function MF:factoryTeleportBox()
	-- Check the Mobile Factory --
	if self.ent == nil then return end
	if self.ent.valid == false then return end
	-- Mobile Factory Vehicule --
	if self.tpEnabled == true then
		local mfB = self.ent.bounding_box
		local entities = self.ent.surface.find_entities_filtered{area={{mfB.left_top.x-0.5,mfB.left_top.y-0.5},{mfB.right_bottom.x+0.5, mfB.right_bottom.y+0.5}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerInside(entity.player, self)
		end
	end
	-- Factory to Outside --
	if self.fS ~= nil then
		local entities = self.fS.find_entities_filtered{area={{-1,-1},{1,1}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerOutside(entity.player, self)
		end
	end
	-- Factory to Control Center --
	if technologyUnlocked("ControlCenter", getForce(self.player)) == true and self.fS ~= nil and self.fS ~= nil then
		local entities = self.fS.find_entities_filtered{area={{-3,-34},{3,-32}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerToControlCenter(entity.player, self)
		end
	end
	-- Control Center to Factory --
	if technologyUnlocked("ControlCenter", getForce(self.player)) == true and self.ccS ~= nil and self.fS~= nil then
		local entities = self.ccS.find_entities_filtered{area={{-3,5},{3,8}}, type="character"}
		for k, entity in pairs(entities) do
			teleportPlayerToFactory(entity.player, self)
		end
	end
end

-- Scan modules inside the Equalizer --
function MF:scanModules()
	if technologyUnlocked("UpgradeModules", getForce(self.player)) == false then return end
	if self.ccS == nil then return end
	local equalizer = self.ccS.find_entity("Equalizer", {1, -16})
	if equalizer == nil or equalizer.valid == false then return end
	local powerMD = 0
	local efficiencyMD = 0
	local focusMD = 0
	for name, count in pairs(equalizer.get_inventory(defines.inventory.beacon_modules).get_contents()) do
		if name == "EnergyPowerModule" then powerMD = powerMD + count end
		if name == "EnergyEfficiencyModule" then efficiencyMD = efficiencyMD + count end
		if name == "EnergyFocusModule" then focusMD = focusMD + count end
	end
	self.laserRadiusMultiplier = powerMD
	self.laserDrainMultiplier = efficiencyMD
	self.laserNumberMultiplier = focusMD
end

-- Recharge inroom Dimensional Accumulator --
function MF:updateAccumulators()
	-- Factory --
	if self.fS ~= nil and self.fS.valid == true and technologyUnlocked("EnergyDistribution1", getForce(self.player)) and self.internalEnergyDistributionActivated and self.internalEnergy > 0 then
		for k, entity in pairs(global.accTable) do
			if entity == nil or entity.valid == false then global.accTable[k] = nil return end
			if self.internalEnergy > _mfBaseEnergyAccSend and entity.energy < entity.electric_buffer_size then
				entity.energy = entity.energy + _mfBaseEnergyAccSend
				self.internalEnergy = self.internalEnergy - _mfBaseEnergyAccSend
			end
		end
	end
end

-- Update the Sync Area --
function MF:updateSyncArea()
	if self.ent == nil or self.ent.valid == false then return end

	-- Check if the Mobile Factory is moving or the Sync Area is disabled --
	if self.syncAreaEnabled == false or self.ent.speed ~= 0 then
		if self.syncAreaScanned == false then return end
		rendering.destroy(self.syncAreaID)
		rendering.destroy(self.syncAreaInsideID)
		self.syncAreaID = 0
		self.syncAreaInsideID = 0
		self.syncAreaScanned = false
		self:unCloneSyncArea()
		return
	end

	-- Create the Circle --
	if self.syncAreaID == 0 then
		self.syncAreaID = rendering.draw_circle{color={108,52,131}, radius=_mfSyncAreaRadius, width=1, filled=false,target=self.ent, surface=self.ent.surface}
		self.syncAreaInsideID = rendering.draw_circle{color={108,52,131}, radius=_mfSyncAreaRadius, width=1, filled=false,target=_mfSyncAreaPosition, surface=self.fS}
	end

	-- Scan the Area if needed --
	if self.syncAreaScanned == false then
		self:syncAreaScan()
		self.syncAreaScanned = true
		return
	end

	-- Update Cloned Entity --
	for k, ent in pairs(self.clonedResourcesTable) do
		self:updateClonedEntity(ent)
	end
end

-- Scan around the Mobile Factory for the Sync Area --
function MF:syncAreaScan()
	self.clonedResourcesTable = {}

	-- Cloning Tiles --
	local radius = _mfSyncAreaRadius + 1
	local bdb = {{self.ent.position.x - radius, self.ent.position.y - radius},{self.ent.position.x + radius, self.ent.position.y + radius}}
	local clonedBdb = {{_mfSyncAreaPosition.x - radius, _mfSyncAreaPosition.y - radius},{_mfSyncAreaPosition.x + radius, _mfSyncAreaPosition.y + radius}}
	self.ent.surface.clone_area{source_area=bdb, destination_area=clonedBdb, destination_surface=self.fS, clone_entities=false, clone_decoratives=false, clear_destination_entities=false}
	createSyncAreaMFSurface(self.fS)

	-- Look for Entities around the Mobile Factory --
	local entTableOut = self.ent.surface.find_entities_filtered{position=self.ent.position, radius=_mfSyncAreaRadius}
	-- Look for Entities inside the Sync Area --
	local entTableIn = self.fS.find_entities_filtered{position=_mfSyncAreaPosition, radius=_mfSyncAreaRadius}

	-- Clone Outside Entities --
	for k, ent in pairs(entTableOut) do
		if _mfSyncAreaAllowedTypes[ent.type] == true then
			self:cloneEntity(ent, "in")
		end
	end

	-- Clone Inside Entities --
	for k, ent in pairs(entTableIn) do
		if _mfSyncAreaAllowedTypes[ent.type] == true then
			self:cloneEntity(ent, "out")
		end
	end

end

-- Clone an Entity --
function MF:cloneEntity(ent, side) -- side: in (Clone inside), out (Clone outside)
	if self.ent == nil or self.ent.valid == false then return end
	local posX = 0
	local posY = 0
	local surface = nil
	-- Calcul the position and set the Surface --
	if side == "in" then
		posX = ent.position.x - round(self.ent.position.x) + _mfSyncAreaPosition.x
		posY = ent.position.y - round(self.ent.position.y) + _mfSyncAreaPosition.y
		surface = self.fS
	end
	if side == "out" then
		posX = round(self.ent.position.x) + ent.position.x - _mfSyncAreaPosition.x
		posY = round(self.ent.position.y) + ent.position.y - _mfSyncAreaPosition.y
		surface = self.ent.surface
	end
	-- Clone the Entity --
	-- if self.ent.surface.can_place_entity{name=ent.name, position={posX, posY}} then
		local clone = ent.clone{position={posX, posY}, surface=surface}
		table.insert(self.clonedResourcesTable,  {original=ent, cloned=clone})
		if ent.type == "container" then
			clone.get_inventory(defines.inventory.chest).clear()
		end
		if ent.type == "storage-tank" then
			clone.clear_fluid_inside()
		end
		if ent.type == "accumulator" then
			ent.energy = 0
		end
	-- end
end

function MF:unCloneSyncArea()
	-- Set default Tiles --
	createSyncAreaMFSurface(self.fS, true)
	-- Remove all cloned Entities --
	for k, ents in pairs(self.clonedResourcesTable) do
		ents.cloned.destroy()
	end
	self.clonedResourcesTable = {}
end

function MF:updateClonedEntity(ents)
	-- Check the Entities --
	if ents == nil then return end
	if ents.original == nil or ents.original.valid == false then
		ents.cloned.destroy()
		return
	end
	if ents.cloned == nil or ents.cloned.valid == false then
		ents.original.destroy()
		return
	end
	-- If the Entity is a resource --
	if ents.original.type == "resource" then
		if ents.cloned.amount < ents.original.amount then
			ents.original.amount = ents.cloned.amount
		end
		if ents.cloned.amount > ents.original.amount then
			ents.cloned.amount = ents.original.amount
		end
		if ents.original.amount <= 0 then
			ents.original.destroy()
			ents.cloned.destroy()
		end
	end
	-- If the Entity is a Chest --
	if ents.original.type == "container" then
		Util.syncChest(ents.original, ents.cloned)
	end

	-- If the Entity is a Storage Tank --
	if ents.original.type == "storage-tank" then
		Util.syncTank(ents.original, ents.cloned)
	end

	-- If the Entity is an Accumulator --
	if ents.original.type == "accumulator" then
		Util.syncAccumulator(ents.original, ents.cloned)
	end
end