--target
local _, cfg = ... --export config
local addon, ns = ... --get addon namespace

local f = CreateFrame("Button","BobTargetHUD",UIParent,"SecureUnitButtonTemplate")
local UnitPowerType = UnitPowerType
f.unit = "target" --change to unit you want to track
--Make the Health Bar
--background texture
f.back = f:CreateTexture(nil,"BACKGROUND")
f.back:SetSize(unpack(cfg.tar.barsize))
f.back:SetPoint("CENTER",UIParent,cfg.tar.healthx,cfg.tar.healthy)
f.back:SetTexture("Interface\\Addons\\BobHUD\\media\\tarhealthbar")
f.back:SetVertexColor(0,0,0,cfg.tar.alpha)
if cfg.transparency.OOCfade then
  f.back:Hide()
end
--health bar
f.hp = CreateFrame("StatusBar",nil,f,"TextStatusBar")
f.hp:SetSize(unpack(cfg.tar.barsize))
f.hp:SetPoint("CENTER",UIParent,cfg.tar.healthx,cfg.tar.healthy)
f.hp:SetStatusBarTexture("Interface\\Addons\\BobHUD\\media\\tarhealthbar")
f.hp:SetStatusBarColor(0,.8,0)
f.hp:SetMinMaxValues(0,1)
f.hp:SetOrientation("VERTICAL")
f.hp:EnableMouse(false)
f.hp:SetAlpha(cfg.tar.alpha)
if cfg.transparency.OOCfade then
  f.hp:Hide()
end
--Make the Mana Bar
f:SetAttribute("unit",f.unit)
--background texture
f.back = f:CreateTexture(nil,"BACKGROUND")
f.back:SetSize(unpack(cfg.tar.barsize))
f.back:SetPoint("CENTER",UIParent,cfg.tar.powerx,cfg.tar.powery)
f.back:SetTexture("Interface\\Addons\\BobHUD\\media\\tarpowerbar")
f.back:SetVertexColor(0,0,0,cfg.tar.alpha)
if cfg.transparency.OOCfade then
  f.back:Hide()
end
--mana bar
f.mp = CreateFrame("StatusBar",nil,f,"TextStatusBar")
f.mp:SetSize(unpack(cfg.tar.barsize))
f.mp:SetPoint("CENTER",UIParent,cfg.tar.powerx,cfg.tar.powery)
f.mp:SetStatusBarTexture("Interface\\Addons\\BobHUD\\media\\tarpowerbar")
local powercolor = PowerBarColor[select(2, UnitPowerType(f.unit))] or PowerBarColor['MANA']
f.mp:SetStatusBarColor(powercolor.r, powercolor.g, powercolor.b)
f.mp:SetMinMaxValues(0,1)
f.mp:SetOrientation("VERTICAL")
f.mp:EnableMouse(false)
f.mp:SetAlpha(cfg.tar.alpha)
if cfg.transparency.OOCfade then
  f.mp:Hide()
end

--Updates the status bar to new health
f:SetScript("OnEvent", function(self, event, unit)
  if event == "PLAYER_TARGET_CHANGED" then
    --update health
    self.hp:SetValue(UnitHealth(unit)/UnitHealthMax(unit))
    --update powa
    self.mp:SetValue(UnitPower(unit)/UnitPowerMax(unit))
    local powercolor = PowerBarColor[select(2, UnitPowerType(f.unit))] or PowerBarColor['MANA']
    f.mp:SetStatusBarColor(powercolor.r, powercolor.g, powercolor.b)
  elseif event == "UNIT_HEALTH_FREQUENT" then
    --update health
    self.hp:SetValue(UnitHealth(unit)/UnitHealthMax(unit))
    elseif event == "UNIT_POWER_FREQUENT" then
    --update powa
    self.mp:SetValue(UnitPower(unit)/UnitPowerMax(unit))
    local powercolor = PowerBarColor[select(2, UnitPowerType(f.unit))] or PowerBarColor['MANA']
    f.mp:SetStatusBarColor(powercolor.r, powercolor.g, powercolor.b)
  end
end)

f:RegisterUnitEvent("PLAYER_TARGET_CHANGED", f.unit)
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", f.unit)
f:RegisterUnitEvent("UNIT_POWER_FREQUENT", f.unit)

RegisterUnitWatch(f) --Check to see if pet exists
