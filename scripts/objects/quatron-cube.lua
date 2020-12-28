-- QUATRON CUBE OBJECT --

-- Create the Quatron Cube base Object --
QC = {
	ent = nil,
	player = "",
	MF = nil,
	entID = 0,
	spriteID = 0,
	lightID = 0,
	consumption = 0,
	updateTick = 60,
	lastUpdate = 0,
	dataNetwork = nil,
	quatronCharge = 0,
	quatronLevel = 1,
	quatronMax = 1,
	quatronMaxInput = 0,
	quatronMaxOutput = 0
}

-- Constructor --
function QC:new(object)
	if object == nil then return end
	local t = {}
	local mt = {}
	setmetatable(t, mt)
	mt.__index = QC
	t.ent = object
	if object.last_user == nil then return end
	t.player = object.last_user.name
	t.MF = getMF(t.player)
	t.entID = object.unit_number
	-- Get prototype data
	t.quatronCharge = object.energy
	t.quatronMax = object.electric_buffer_size
	t.quatronMaxInput = object.electric_buffer_size / 10
	t.quatronMaxOutput = object.electric_buffer_size / 10
	-- Draw the Sprite --
	t.spriteID = rendering.draw_sprite{sprite="QuatronCubeSprite0", x_scale=1/7, y_scale=1/7, target=object, surface=object.surface, target_offset={0, -0.3}, render_layer=131}
	t.lightID = rendering.draw_light{sprite="QuatronCubeSprite0", scale=1/7, target=object, surface=object.surface, target_offset={0, -0.3}, minimum_darkness=0}
	UpSys.addObj(t)
	return t
end

-- Reconstructor --
function QC:rebuild(object)
	if object == nil then return end
	local mt = {}
	mt.__index = QC
	setmetatable(object, mt)
end

-- Destructor --
function QC:remove()
	-- Destroy the Sprite --
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	-- Remove from the Update System --
	UpSys.removeObj(self)
	-- Remove from the Data Network --
	if self.dataNetwork ~= nil and getmetatable(self.dataNetwork) ~= nil then
		self.dataNetwork:removeObject(self)
	end
end

-- Is valid --
function QC:valid()
	if self.ent ~= nil and self.ent.valid then return true end
	return false
end

-- Item Tags to Content --
function QC:itemTagsToContent(tags)
	self.quatronCharge = tags.energy or 0
	self.quatronLevel = tags.purity or 1
	self.ent.energy = self.quatronCharge
end

-- Content to Item Tags --
function QC:contentToItemTags(tags)
	if self.quatronCharge <= 0 then return end
	tags.set_tag("Infos", {energy=self.quatronCharge, purity=self.quatronLevel})
	tags.custom_description = {"", tags.prototype.localised_description, {"item-description.QuatronCubeC", math.floor(self.quatronCharge), string.format("%.3f", self.quatronLevel)}}
end

-- Update --
function QC:update()
	-- Set the lastUpdate variable --
	self.lastUpdate = game.tick

	-- Check the Validity --
	if valid(self) == false then
		self:remove()
		return
	end

	-- Update the Sprite --
	local spriteNumber = math.ceil(self.quatronCharge/self.quatronMax*10)
	rendering.destroy(self.spriteID)
	rendering.destroy(self.lightID)
	self.spriteID = rendering.draw_sprite{sprite="QuatronCubeSprite" .. spriteNumber, x_scale=1/7, y_scale=1/7, target=self.ent, surface=self.ent.surface, target_offset={0, -0.3}, render_layer=131}
	self.lightID = rendering.draw_light{sprite="QuatronCubeSprite" .. spriteNumber, scale=1/7, target=self.ent, surface=self.ent.surface, target_offset={0, -0.3}, minimum_darkness=0}

	-- Balance the Quatron with neighboring Quatron Users --
	self:balance()
end


-- Tooltip Infos --
function QC:getTooltipInfos(GUITable, mainFrame, justCreated)

	if justCreated == true then

		-- Set the GUI Title --
		GUITable.vars.GUITitle.caption = {"gui-description.QuatronCube"}

		-- Set the Main Frame Height --
		-- mainFrame.style.height = 100
		
		-- Create the Information Frame --
		local infoFrame = GAPI.addFrame(GUITable, "InformationFrame", mainFrame, "vertical", true)
		infoFrame.style = "MFFrame1"
		infoFrame.style.vertically_stretchable = true
		infoFrame.style.minimal_width = 200
		infoFrame.style.left_margin = 3
		infoFrame.style.left_padding = 3
		infoFrame.style.right_padding = 3
	
	end

	-- Get the Frame --
	local infoFrame = GUITable.vars.InformationFrame

	-- Clear the Frame --
	infoFrame.clear()

	-- Create the Tite --
	GAPI.addSubtitle(GUITable, "", infoFrame, {"gui-description.Information"})

	-- Add the Quatron Charge --
    GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.QuatronCharge", Util.toRNumber(self.quatronCharge)}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", infoFrame, "", self.quatronCharge .. "/" .. self.quatronMax, false, _mfPurple, self.quatronCharge/self.quatronMax, 100)
	
	-- Create the Quatron Purity --
	GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.Quatronlevel", string.format("%.3f", self.quatronLevel)}, _mfOrange)
	GAPI.addProgressBar(GUITable, "", infoFrame, "", "", false, _mfPurple, self.quatronLevel/20, 100)

	-- Add the Input/Output Speed Label --
	local inputLabel = GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.QuatronInputSpeed", Util.toRNumber(self:maxInput())}, _mfOrange)
	inputLabel.style.top_margin = 10
	GAPI.addLabel(GUITable, "", infoFrame, {"gui-description.QuatronOutputSpeed", Util.toRNumber(self:maxOutput())}, _mfOrange)

end


-- Balance the Quatron with neighboring Quatron Users --
function QC:balance()
	-- Get all Accumulator arount --
	local area = {{self.ent.position.x-1.5, self.ent.position.y-1.5},{self.ent.position.x+1.5,self.ent.position.y+1.5}}
	local ents = self.ent.surface.find_entities_filtered{area=area, name=_mfQuatronShare}

	local selfMaxOutFlow = self.quatronMaxOutput
	local selfQuatron = self.quatronCharge
	local selfQuatronLevel = self.quatronLevel

	-- Check all Accumulator --
	for k, ent in pairs(ents) do
		-- Look for valid Quatron User --
		local obj = global.entsTable[ent.unit_number]
		if obj ~= nil and obj.entID ~= self.entID then
			local isAcc = ent.type == "accumulator"
			local objQuatron = obj.quatronCharge
			local objMaxQuatron = obj.quatronMax
			local objMaxInFlow = obj.quatronMaxInput
			local shareThreshold = isAcc and objQuatron or 0
			if selfQuatron > shareThreshold and objQuatron < objMaxQuatron and objMaxInFlow > 0 then
				-- Calcule max flow --
				local quatronVariance = isAcc and math.floor((selfQuatron - objQuatron) / 2) or selfQuatron
				local missingQuatron = objMaxQuatron - objQuatron
				local quatronTransfer = math.min(quatronVariance, missingQuatron, selfMaxOutFlow, objMaxInFlow)
				-- Transfer Quatron --
				quatronTransfer = obj:addQuatron(quatronTransfer, selfQuatronLevel)
				-- Remove Quatron --
				selfQuatron = selfQuatron - quatronTransfer
			end
		end
	end

	self.quatronCharge = selfQuatron
	self.ent.energy = selfQuatron
end

-- Return the amount of Quatron --
function QC:quatron()
	return self.quatronCharge
end

-- Return the Quatron Buffer size --
function QC:maxQuatron()
	return self.quatronMax
end

-- Add Quatron (Return the amount added) --
function QC:addQuatron(amount, level)
	local added = math.min(amount, self.quatronMax - self.quatronCharge)
	if self.quatronCharge > 0 then
		mixQuatron(self, added, level)
	else
		self.quatronCharge = added
		self.quatronLevel = level
	end
	return added
end

-- Remove Quatron (Return the amount removed) --
function QC:removeQuatron(amount)
	local removed = math.min(amount, self.quatronCharge)
	self.quatronCharge = self.quatronCharge - removed
	return removed
end

-- Return the max input flow --
function QC:maxInput()
	return self.quatronMaxInput
end

-- Return the max output flow --
function QC:maxOutput()
	return self.quatronMaxOutput
end