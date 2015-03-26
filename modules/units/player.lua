--BobHUD, an extremely simple HUD addon
local _, cfg = ... --export config
local addon, ns = ... --get addon namespace

local f = CreateFrame("Button","BobPlayerHUD",UIParent,"SecureUnitButtonTemplate")
local UnitPowerType = UnitPowerType
f.unit = "player" --change to unit you want to track
--Make the Health Bar
--background texture
f.back = f:CreateTexture(nil,"BACKGROUND")
f.back:SetSize(unpack(cfg.player.barsize))
f.back:SetPoint("CENTER",UIParent,cfg.player.healthx,cfg.player.healthy)
f.back:SetTexture("Interface\\Addons\\BobHUD\\media\\healthbar")
f.back:SetVertexColor(0,0,0,cfg.player.alpha/2)
if cfg.transparency.OOCfade then
  f.back:Hide()
end
--health bar
f.hp = CreateFrame("StatusBar",nil,f,"TextStatusBar")
f.hp:SetSize(unpack(cfg.player.barsize))
f.hp:SetPoint("CENTER",UIParent,cfg.player.healthx,cfg.player.healthy)
f.hp:SetStatusBarTexture("Interface\\Addons\\BobHUD\\media\\healthbar")
f.hp:SetStatusBarColor(0,.8,0)
f.hp:SetMinMaxValues(0,1)
f.hp:SetOrientation("VERTICAL")
f.hp:EnableMouse(false)
f.hp:SetAlpha(cfg.player.alpha)
if cfg.transparency.OOCfade then
  f.hp:Hide()
end
if cfg.text then
  --health fontstring
  f.HealthText = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  f.HealthText:SetPoint("BOTTOMRIGHT",f.hp,-23,0)
  f.HealthText:Hide()
  --percent
  f.HealthText2 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  f.HealthText2:SetPoint("BOTTOMRIGHT",f.hp,-28,12)
  f.HealthText2:Hide()
end

--Make the Mana Bar
f:SetAttribute("unit",f.unit)
f:SetAttribute("type","target")
--background texture
f.back2 = f:CreateTexture(nil,"BACKGROUND")
f.back2:SetSize(unpack(cfg.player.barsize))
f.back2:SetPoint("CENTER",UIParent,cfg.player.powerx,cfg.player.powery)
f.back2:SetTexture("Interface\\Addons\\BobHUD\\media\\powerbar")
f.back2:SetVertexColor(0,0,0,cfg.player.alpha/2)
if cfg.transparency.OOCfade then
  f.back2:Hide()
end
--mana bar
f.mp = CreateFrame("StatusBar",nil,f,"TextStatusBar")
f.mp:SetSize(unpack(cfg.player.barsize))
f.mp:SetPoint("CENTER",UIParent,cfg.player.powerx,cfg.player.powery)
f.mp:SetStatusBarTexture("Interface\\Addons\\BobHUD\\media\\powerbar")
local powercolor = PowerBarColor[select(2, UnitPowerType(f.unit))] or PowerBarColor['MANA']
f.mp:SetStatusBarColor(powercolor.r, powercolor.g, powercolor.b)
f.mp:SetMinMaxValues(0,1)
f.mp:SetOrientation("VERTICAL")
f.mp:EnableMouse(false)
f.mp:SetAlpha(cfg.player.alpha)
if cfg.transparency.OOCfade then
  f.mp:Hide()
end

if cfg.text then
  --power fontstring
  f.PowerText = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  f.PowerText:SetPoint("BOTTOMLEFT",f.mp,23,0)
  f.PowerText:Hide()
  --percent
  f.PowerText2 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  f.PowerText2:SetPoint("BOTTOMLEFT",f.mp,28,12)
  f.PowerText2:Hide()
end

--Updates the status bar to new health
f:SetScript("OnEvent", function(self, event, unit)
  if event == "UNIT_HEALTH_FREQUENT" or event == "PLAYER_ENTERING_WORLD" then
  --update health
    self.hp:SetValue(UnitHealth(f.unit)/UnitHealthMax(f.unit))
    local currentHealth, maxHealth = UnitHealth(f.unit), UnitHealthMax(f.unit)
    local percentHealth = currentHealth / maxHealth * 100
    if cfg.text then
      self.HealthText:SetFormattedText("%d/%d", currentHealth, maxHealth, percentHealth)
      self.HealthText2:SetFormattedText("%d%%", percentHealth)
    end
  end
  if event == "UNIT_POWER_FREQUENT" or event == "PLAYER_ENTERING_WORLD" then
  --update powa
    self.mp:SetValue(UnitPower(f.unit)/UnitPowerMax(f.unit))
    local currentPower, maxPower = UnitPower(f.unit), UnitPowerMax(f.unit)
    local percentPower = currentPower / maxPower * 100
    if cfg.text then
      self.PowerText:SetFormattedText("%d/%d", currentPower, maxPower, percentPower)
      self.PowerText2:SetFormattedText("%d%%", percentPower)
    end
    local powercolor = PowerBarColor[select(2, UnitPowerType(f.unit))] or PowerBarColor['MANA']
    f.mp:SetStatusBarColor(powercolor.r, powercolor.g, powercolor.b)
  end
  if cfg.transparency.OOCfade then
    if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_ENTERING_WORLD" then
      f.back:Hide()
      f.hp:Hide()
      f.back2:Hide()
      f.mp:Hide()
      f.HealthText:Hide()
      f.HealthText2:Hide()
      f.PowerText:Hide()
      f.PowerText2:Hide()
    end
    if event == "PLAYER_REGEN_DISABLED" then --maybe there's a better way to do this?
      f.back:Show()
      f.hp:Show()
      f.back2:Show()
      f.mp:Show()
      f.HealthText:Show()
      f.HealthText2:Show()
      f.PowerText:Show()
      f.PowerText2:Show()
    end
  end
end)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", f.unit)
f:RegisterUnitEvent("UNIT_POWER_FREQUENT", f.unit)
