local _, cfg = ... --export config
local addon, ns = ... --get addon namespace

local f = CreateFrame("Frame")
local EventsRegistered

-- Rune Data
local RUNETYPE_BLOOD = 1
local RUNETYPE_UNHOLY = 2
local RUNETYPE_FROST = 3
local RUNETYPE_DEATH = 4

-- Events
function f.OnUpdate()
	local time = GetTime()
	
	if time > f.LastTime + 0.04 then	-- Update 25 times a second
		-- Update Rune Bars
		local RuneBar
		local start, duration, runeReady
		for rune = 1, 6 do
			RuneBar = f.Frames.RuneBars[rune]
			start, duration, runeReady = GetRuneCooldown(rune)

			if RuneBar ~= nil then
				if runeReady or UnitIsDead("player") or UnitIsGhost("player") then
					RuneBar.BottomStatusBar:SetValue(1)
					RuneBar.TopStatusBar:SetValue(1)
				else
					RuneBar.BottomStatusBar:SetValue((time - start) / duration)
					RuneBar.TopStatusBar:SetValue(math.max((time - (start + duration - 1)) / 1, 0.0))
				end
			end
		end

		f.LastTime = time
	end
end

function f.RuneTextureUpdate(rune)
	RuneBar = f.Frames.RuneBars[rune]
	if not RuneBar then return end
	
	local RuneType = GetRuneType(rune)
	if RuneType then
		RuneBar.BottomStatusBar.bg:SetTexture(cfg.runes.colors[RuneType].r * cfg.runes.colors.brightness, cfg.runes.colors[RuneType].g * cfg.runes.colors.brightness, cfg.runes.colors[RuneType].b * cfg.runes.colors.brightness)
		RuneBar.TopStatusBar.bg:SetTexture(cfg.runes.colors[RuneType].r, cfg.runes.colors[RuneType].g, cfg.runes.colors[RuneType].b)
	end
end

function f.UpdateRuneTextures()
	for rune = 1, 6 do
		f.RuneTextureUpdate(rune)
	end
end

local function Rune_TypeUpdate(event, rune)
	if not rune or tonumber(rune) ~= rune or rune < 1 or rune > 6 then
		return
	end

	-- Update Rune colors
	f.RuneTextureUpdate(rune, select(3, GetRuneCooldown(rune)))
end

local function Rune_PlayerEnteringWorld()
	-- Update rune colors
	f.UpdateRuneTextures()
end

local function RuneEvents(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		Rune_PlayerEnteringWorld()
	elseif event == "RUNE_TYPE_UPDATE" then
		Rune_TypeUpdate(event, ...)
	end
end

function f.SetupEvents()
	if EventsRegistered then return end

	f.Frames.Parent:RegisterEvent("RUNE_TYPE_UPDATE")
	f.Frames.Parent:RegisterEvent("PLAYER_ENTERING_WORLD")
	f.Frames.Parent:SetScript("OnEvent", RuneEvents)
	
	-- Enable OnUpdate handler
	f.LastTime = 0
	f.Frames.Main:SetScript("OnUpdate", f.OnUpdate)
	
	EventsRegistered = true
end

-- Settings Update
function f.UpdateSettings()
	local PF = UIParent
	f.Frames.Parent:SetParent(PF)
	f.Frames.Parent:SetPoint(unpack(cfg.runes.position))
	f.Frames.Parent:SetFrameStrata("LOW")
	f.Frames.Parent:SetFrameLevel(2)
	
	f.Frames.Parent:SetHeight(cfg.runes.height + cfg.runes.padding * 2)
	f.Frames.Parent:SetWidth(cfg.runes.width * 6 + cfg.runes.padding * 7)
	
	f.Frames.Main:SetAllPoints(f.Frames.Parent)
	f.Frames.Main:SetAlpha(cfg.runes.alpha)
	
	local RuneBar
	for i = 1, 6 do
		local CurRune = cfg.runes.order[i]
		RuneBar = f.Frames.RuneBars[i]

		-- Create Rune Bar
		RuneBar.frame:SetFrameStrata("LOW")
		RuneBar.frame:SetFrameLevel(2 + 1)
		RuneBar.frame:SetHeight(cfg.runes.height)
		RuneBar.frame:SetWidth(cfg.runes.width)
		RuneBar.frame:SetPoint("TOPLEFT", f.Frames.Main, "TOPLEFT", cfg.runes.padding + (CurRune - 1) * (cfg.runes.width + cfg.runes.padding), -cfg.runes.padding)

		-- Bottom Status Bar
		RuneBar.BottomStatusBar:SetFrameStrata("LOW")
		RuneBar.BottomStatusBar:SetFrameLevel(RuneBar.frame:GetFrameLevel() + 1)
		RuneBar.BottomStatusBar.bg:SetTexture(cfg.runes.colors[RUNETYPE_BLOOD].r * cfg.runes.colors.brightness, cfg.runes.colors[RUNETYPE_BLOOD].g * cfg.runes.colors.brightness, cfg.runes.colors[RUNETYPE_BLOOD].b * cfg.runes.colors.brightness)

		-- Top Status Bar
		RuneBar.TopStatusBar:SetFrameStrata("LOW")
		RuneBar.TopStatusBar:SetFrameLevel(RuneBar.BottomStatusBar:GetFrameLevel() + 1)
		RuneBar.TopStatusBar.bg:SetTexture(cfg.runes.colors[RUNETYPE_BLOOD].r, cfg.runes.colors[RUNETYPE_BLOOD].g, cfg.runes.colors[RUNETYPE_BLOOD].b)
	end
	
	f.UpdateRuneTextures()
end

-- Frame Creation
function f.CreateFrames()
	if f.Frames then return end
	
	f.Frames = {}
	
	-- Parent frame
	f.Frames.Parent = CreateFrame("Frame", "nibRunes_RuneDisplay", UIParent)
	
	-- Create main frame
	f.Frames.Main = CreateFrame("Frame", nil, f.Frames.Parent)
	f.Frames.Main:SetParent(f.Frames.Parent)
	
	-- Rune Bars
	f.Frames.RuneBars = {}
	local RuneBar
	for i = 1, 6 do
		f.Frames.RuneBars[i] = {}
		RuneBar = f.Frames.RuneBars[i]

		-- Create Rune Bar
		RuneBar.frame = CreateFrame("Frame", nil, f.Frames.Main)

		-- Bottom Status Bar
		RuneBar.BottomStatusBar = CreateFrame("StatusBar", nil, RuneBar.frame)
		RuneBar.BottomStatusBar:SetOrientation("VERTICAL")
		RuneBar.BottomStatusBar:SetMinMaxValues(0, 1)
		RuneBar.BottomStatusBar:SetValue(1)
		RuneBar.BottomStatusBar:SetAllPoints(RuneBar.frame)

		RuneBar.BottomStatusBar.bg = RuneBar.BottomStatusBar:CreateTexture()
		RuneBar.BottomStatusBar.bg:SetAllPoints()
		RuneBar.BottomStatusBar.bg:SetTexture(cfg.runes.colors[RUNETYPE_BLOOD].r * cfg.runes.colors.brightness, cfg.runes.colors[RUNETYPE_BLOOD].g * cfg.runes.colors.brightness, cfg.runes.colors[RUNETYPE_BLOOD].b * cfg.runes.colors.brightness)
		RuneBar.BottomStatusBar:SetStatusBarTexture(RuneBar.BottomStatusBar.bg)

		-- Top Status Bar
		RuneBar.TopStatusBar = CreateFrame("StatusBar", nil, RuneBar.frame)
		RuneBar.TopStatusBar:SetOrientation("VERTICAL")
		RuneBar.TopStatusBar:SetMinMaxValues(0, 1)
		RuneBar.TopStatusBar:SetValue(1)
		RuneBar.TopStatusBar:SetAllPoints(RuneBar.frame)

		RuneBar.TopStatusBar.bg = RuneBar.TopStatusBar:CreateTexture()
		RuneBar.TopStatusBar.bg:SetAllPoints()
		RuneBar.TopStatusBar.bg:SetTexture(cfg.runes.colors[RUNETYPE_BLOOD].r, cfg.runes.colors[RUNETYPE_BLOOD].g, cfg.runes.colors[RUNETYPE_BLOOD].b)
		RuneBar.TopStatusBar:SetStatusBarTexture(RuneBar.TopStatusBar.bg)
	end
end

---- CORE
function f.RefreshMod()
	f.UpdateSettings()
end

----
function f.Enable()
	-- Refresh
	f.RefreshMod()
	
	-- Setup Events
	f.SetupEvents()
	
	-- Show RuneDisplay
	f.Frames.Parent:Show()
end

function f.PLAYER_LOGIN()
	if not (select(2, UnitClass("player")) == "DEATHKNIGHT") then return end
	f.CreateFrames()
	f.Enable()
end

local function EventHandler(self, event, ...)
	if event == "PLAYER_LOGIN" then
		f.PLAYER_LOGIN()
	end
end
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("UNIT_HEALTH")
f:SetScript("OnEvent", EventHandler)