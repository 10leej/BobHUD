--pet
local _, cfg = ... --export config
local addon, ns = ... --get addon namespace

local f = CreateFrame("Button","BobPetHUD",UIParent,"SecureUnitButtonTemplate")
local UnitPowerType = UnitPowerType
f.unit = "pet" --change to unit you want to track
--Make the Health Bar
--background texture
f.back = f:CreateTexture(nil,"BACKGROUND")
f.back:SetSize(unpack(cfg.pet.barsize))
f.back:SetPoint("CENTER",UIParent,cfg.pet.healthx,cfg.pet.healthy)
f.back:SetTexture("Interface\\Addons\\BobHUD\\media\\healthbar")
f.back:SetVertexColor(0,0,0,cfg.pet.alpha)
if cfg.transparency.OOCfade then
  f.back:Hide()
end
--health bar
f.hp = CreateFrame("StatusBar",nil,f,"TextStatusBar")
f.hp:SetSize(unpack(cfg.pet.barsize))
f.hp:SetPoint("CENTER",UIParent,cfg.pet.healthx,cfg.pet.healthy)
f.hp:SetStatusBarTexture("Interface\\Addons\\BobHUD\\media\\healthbar")
f.hp:SetStatusBarColor(0,.8,0)
f.hp:SetMinMaxValues(0,1)
f.hp:SetOrientation("VERTICAL")
f.hp:EnableMouse(false)
f.hp:SetAlpha(cfg.pet.alpha)
if cfg.transparency.OOCfade then
  f.hp:Hide()
end
--Make the Mana Bar
f:SetAttribute("unit",f.unit)
--background texture
f.back = f:CreateTexture(nil,"BACKGROUND")
f.back:SetSize(unpack(cfg.pet.barsize))
f.back:SetPoint("CENTER",UIParent,cfg.pet.powerx,cfg.pet.powery)
f.back:SetTexture("Interface\\Addons\\BobHUD\\media\\healthbar")
f.back:SetVertexColor(0,0,0,cfg.pet.alpha)
if cfg.transparency.OOCfade then
  f.back:Hide()
end
--mana bar
f.mp = CreateFrame("StatusBar",nil,f,"TextStatusBar")
f.mp:SetSize(unpack(cfg.pet.barsize))
f.mp:SetPoint("CENTER",UIParent,cfg.pet.powerx,cfg.pet.powery)
f.mp:SetStatusBarTexture("Interface\\Addons\\BobHUD\\media\\healthbar")
local powercolor = PowerBarColor[select(2, UnitPowerType(f.unit))] or PowerBarColor['MANA']
f.mp:SetStatusBarColor(powercolor.r, powercolor.g, powercolor.b)
f.mp:SetMinMaxValues(0,1)
f.mp:SetOrientation("VERTICAL")
f.mp:EnableMouse(false)
f.mp:SetAlpha(cfg.pet.alpha)
if cfg.transparency.OOCfade then
  f.mp:Hide()
end

--Updates the status bar to new health
f:SetScript("OnEvent", function(self, event, unit)
  if event == "UNIT_HEALTH_FREQUENT" or event == "PLAYER_ENTERING_WORLD"  or event == "UNIT_PET" then
  --update health
    self.hp:SetValue(UnitHealth(f.unit)/UnitHealthMax(f.unit))
    local currentHealth, maxHealth = UnitHealth(f.unit), UnitHealthMax(f.unit)
    local percentHealth = currentHealth / maxHealth * 100
  end
  if event == "UNIT_POWER_FREQUENT" or event == "PLAYER_ENTERING_WORLD"  or event == "UNIT_PET" then
  --update powa
    self.mp:SetValue(UnitPower(f.unit)/UnitPowerMax(f.unit))
    local currentPower, maxPower = UnitPower(f.unit), UnitPowerMax(f.unit)
    local percentPower = currentPower / maxPower * 100
    local powercolor = PowerBarColor[select(2, UnitPowerType(f.unit))] or PowerBarColor['MANA']
    f.mp:SetStatusBarColor(powercolor.r, powercolor.g, powercolor.b)
  end
  if cfg.transparency.OOCfade then
    if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD"  or event == "UNIT_PET" then
      f.back:Hide()
      f.hp:Hide()
      f.mp:Hide()
    end
    if event == "PLAYER_REGEN_DISABLED" then
      f.back:Show()
      f.hp:Show()
      f.mp:Show()
    end
  end
end)
f:RegisterEvent("UNIT_PET")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", f.unit)
f:RegisterUnitEvent("UNIT_POWER_FREQUENT", f.unit)

RegisterUnitWatch(f) --Check to see if unit exists
