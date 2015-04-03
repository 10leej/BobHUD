--focus
local _, cfg = ... --export config
local addon, ns = ... --get addon namespace

local f = CreateFrame("Button","BobFocusHUD",UIParent,"SecureUnitButtonTemplate")
local UnitPowerType = UnitPowerType
f.unit = "focus" --change to unit you want to track
--Make the Health Bar
--background texture
f.back = f:CreateTexture(nil,"BACKGROUND")
f.back:SetSize(unpack(cfg.focus.barsize))
f.back:SetPoint("CENTER",UIParent,cfg.focus.healthx,cfg.focus.healthy)
f.back:SetTexture("Interface\\Addons\\BobHUD\\media\\powerbar")
f.back:SetVertexColor(0,0,0,cfg.focus.alpha)
if cfg.transparency.OOCfade then
  f.back:Hide()
end
--health bar
f.hp = CreateFrame("StatusBar",nil,f,"TextStatusBar")
f.hp:SetSize(unpack(cfg.focus.barsize))
f.hp:SetPoint("CENTER",UIParent,cfg.focus.healthx,cfg.focus.healthy)
f.hp:SetStatusBarTexture("Interface\\Addons\\BobHUD\\media\\powerbar")
f.hp:SetStatusBarColor(0,.8,0)
f.hp:SetMinMaxValues(0,1)
f.hp:SetOrientation("VERTICAL")
f.hp:EnableMouse(false)
f.hp:SetAlpha(cfg.focus.alpha)
if cfg.transparency.OOCfade then
  f.hp:Hide()
end
--Make the Mana Bar
f:SetAttribute("unit",f.unit)
--background texture
f.back = f:CreateTexture(nil,"BACKGROUND")
f.back:SetSize(unpack(cfg.focus.barsize))
f.back:SetPoint("CENTER",UIParent,cfg.focus.powerx,cfg.focus.powery)
f.back:SetTexture("Interface\\Addons\\BobHUD\\media\\powerbar")
f.back:SetVertexColor(0,0,0,cfg.focus.alpha)
if cfg.transparency.OOCfade then
  f.back:Hide()
end
--mana bar
f.mp = CreateFrame("StatusBar",nil,f,"TextStatusBar")
f.mp:SetSize(unpack(cfg.focus.barsize))
f.mp:SetPoint("CENTER",UIParent,cfg.focus.powerx,cfg.focus.powery)
f.mp:SetStatusBarTexture("Interface\\Addons\\BobHUD\\media\\powerbar")
local powercolor = PowerBarColor[select(2, UnitPowerType(f.unit))] or PowerBarColor['MANA']
f.mp:SetStatusBarColor(powercolor.r, powercolor.g, powercolor.b)
f.mp:SetMinMaxValues(0,1)
f.mp:SetOrientation("VERTICAL")
f.mp:EnableMouse(false)
f.mp:SetAlpha(cfg.focus.alpha)
if cfg.transparency.OOCfade then
  f.mp:Hide()
end

--Updates the status bar to new health
f:SetScript("OnEvent", function(self, event, unit)
  if event == "FOCUS_TARGET_CHANGED" then
    --update health
    self.hp:SetValue(UnitHealth(unit)/UnitHealthMax(unit))
    --update powa
    self.mp:SetValue(UnitPower(unit)/UnitPowerMax(unit))
    local powercolor = PowerBarColor[select(2, UnitPowerType(f.unit))] or PowerBarColor['MANA']
    f.mp:SetStatusBarColor(powercolor.r, powercolor.g, powercolor.b)
  elseif event == "UNIT_HEALTH" then
    --update health
    self.hp:SetValue(UnitHealth(unit)/UnitHealthMax(unit))
    elseif event == "UNIT_POWER" then
    --update powa
    self.mp:SetValue(UnitPower(unit)/UnitPowerMax(unit))
    local powercolor = PowerBarColor[select(2, UnitPowerType(f.unit))] or PowerBarColor['MANA']
    f.mp:SetStatusBarColor(powercolor.r, powercolor.g, powercolor.b)
  end
  if cfg.transparency.OOCfade then
    if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" then
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
f:RegisterUnitEvent("FOCUS_TARGET_CHANGED", f.unit)
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterUnitEvent("UNIT_HEALTH", f.unit)
f:RegisterUnitEvent("UNIT_POWER", f.unit)

RegisterUnitWatch(f)
