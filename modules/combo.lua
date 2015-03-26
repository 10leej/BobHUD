local _, cfg = ... --export config
local addon, ns = ... --get addon namespace

--Combo points
local incombat  = false
local visible   = true
local powertype = nil
local unit      = "player"
local points    = 0
local locked    = true
local addon = CreateFrame("Frame", "naiCombo", UIParent)

-- the allmighty
function addon:new()
	local realwidth = (cfg.cbpwidth * 5) + (0 * 4)
	self:ClearAllPoints()
	self:SetWidth(realwidth)
	self:SetHeight(cfg.cbpheight)
	self:SetPoint(unpack(cfg.cbp_position))
	self:SetMovable(true)
	self.combos = {}
	
	local cx = 0
	for i = 1, 5 do
		local combo = CreateFrame("Frame", nil, self)
		combo:ClearAllPoints()
		combo:SetPoint("TOPLEFT", self, "TOPLEFT", cx, 0)
		combo:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", cx + cfg.cbpwidth, 0)
		combo.bg = combo:CreateTexture(nil, "BACKGROUND")
		combo.bg:ClearAllPoints()
		combo.bg:SetAllPoints(combo)
		combo.bg:SetTexture('Interface\\ChatFrame\\ChatFrameBackground')
		local curColor = cfg.comboColors[i]
		combo.bg:SetVertexColor(curColor.r, curColor.g, curColor.b)
		combo.bg:SetAlpha(curColor.a)
		combo:SetAlpha(0)
		self.combos[i] = combo
		cx = cx + cfg.cbpwidth + cfg.cbpspacing
	end

	self.overlay = CreateFrame("Frame", nil, self)
	self.overlay:ClearAllPoints()
	self.overlay:SetAllPoints(self)
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("UNIT_DISPLAYPOWER")
	self:RegisterEvent("UNIT_COMBO_POINTS")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	if cfg.hideooc then
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end
	self:RegisterEvent("UNIT_ENTERED_VEHICLE")
	self:RegisterEvent("UNIT_EXITED_VEHICLE")
	self:SetScript("OnEvent", self.event)
end

function addon:toggleCombo()
	if not locked then
		return
	end
	if not cfg.hideooc and not cfg.hidenoenergy then
		return
	end
	if cfg.hidenoenergy then
		if powertype == SPELL_POWER_ENERGY then
			if cfg.hideooc then
				if not visible and points > 0 then
					UIFrameFadeIn(self, cfg.framefadein)
					visible = true
				end
			elseif not visible and points > 0 then
				UIFrameFadeIn(self, cfg.framefadein)
				visible = true
			end
		else
			if visible then
				UIFrameFadeOut(self, cfg.framefadeout)
				visible = false
			end
			return
		end
	end
	if cfg.hideooc then
		if not visible and points > 0 then
			UIFrameFadeIn(self, cfg.framefadein)
			visible = true
		elseif not incombat and points == 0 and visible then
			UIFrameFadeOut(self, cfg.framefadeout)
			visible = false
		end
	end
end

function addon:updateCombo()
	local pt = GetComboPoints(unit)
	if pt == points then
		self:toggleCombo()
		return
	end
	if pt > points then
		for i = points + 1, pt do
			UIFrameFadeIn(self.combos[i], cfg.fadein)
		end
	else
		for i = pt + 1, points do
			UIFrameFadeOut(self.combos[i], cfg.fadeout)
		end
	end
	points = pt
	self:toggleCombo()
end

function addon:event(event, ...)
	if event == "PLAYER_LOGIN" then
		if powertype ~= nil then return end
		powertype, _ = UnitPowerType("player")
		if UnitHasVehicleUI("player") then
			local powervehicle, _ = UnitPowerType("vehicle")
			if powervehicle == SPELL_POWER_ENERGY then
				unit = "vehicle"
				powertype = powervehicle
			end
		end
		if cfg.hideooc or (cfg.hidenoenergy and powertype ~= SPELL_POWER_ENERGY) then
			visible = false
			self:SetAlpha(0)
		end
	elseif event == "UNIT_COMBO_POINTS" then
		local curunit = select(1, ...)
		if curunit ~= unit then return end
		self:updateCombo()
	elseif event == "PLAYER_TARGET_CHANGED" then
		self:updateCombo()
	elseif event == "PLAYER_REGEN_DISABLED" then
		incombat = true
		self:toggleCombo()
	elseif event == "PLAYER_REGEN_ENABLED" then
		incombat = false
		self:toggleCombo()
	elseif event == "UNIT_DISPLAYPOWER" then
		local curunit = select(1, ...)
		if curunit ~= unit then return end
		powertype, _ = UnitPowerType(unit)
		self:toggleCombo()
	elseif event == "UNIT_ENTERED_VEHICLE" then
		local curunit = select(1, ...)
		if curunit ~= "player" then return end
		local powervehicle, _ = UnitPowerType("vehicle")
		if powervehicle == SPELL_POWER_ENERGY then
			unit = "vehicle"
			points = 0
			powertype = powervehicle
			self:toggleCombo()
		end
	elseif event == "UNIT_EXITED_VEHICLE" then
		local curunit = select(1, ...)
		if curunit ~= "player" then return end
		unit = "player"
		points = 0
		powertype, _ = UnitPowerType(unit)
		self:toggleCombo()
	end
end

function addon:reset()
	local realwidth = (cfg.cbpwidth * 5) + (0 * 4)

	self:SetUserPlaced(false)
	self:ClearAllPoints()
	self:SetWidth(realwidth)
	self:SetHeight(cfg.cbpheight)
	self:SetPoint(unpack(cfg.cbp_position))
end
-- and... go!
addon:new()