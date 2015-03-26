local _, cfg = ... --export config
local addon, ns = ... --get addon namespace

if cfg.player.castbar.enable then
	local unit = "player"
	local cf = CreateFrame("StatusBar")
	cf:SetSize(unpack(cfg.player.castbar.barsize))
	cf:SetPoint("CENTER",UIParent,cfg.player.castbar.x,cfg.player.castbar.y)
	cf:SetStatusBarTexture(cfg.player.castbar.texture)
	cf:SetStatusBarColor(1, 1, cfg.player.castbar.alpha)
	cf:SetOrientation("VERTICAL")
	cf:SetBackdrop({bgFile = cfg.player.castbar.texture})
	cf:SetBackdropColor(0, 0, 0, cfg.player.castbar.alpha/2)

	local cfet = 0
	cf:SetScript("OnUpdate",
	  function(f, e)
	   cfet = cfet + e

		if cfet > 0 then
		  local spell, _, displayName, _, startTime, endTime, _, _, interrupt = UnitCastingInfo(unit)
		  
		  if not spell then
			spell, _, displayName, _, startTime, endTime, _, interrupt = UnitChannelInfo(unit)
		  end

		  if spell then
			cf:SetMinMaxValues(startTime, endTime)
			cf:SetValue(1000 * GetTime())

			if not interrupt then
			  cf:SetStatusBarColor(0, 0.9, 0, cfg.player.castbar.alpha)
			  cf:SetBackdropColor(0, 0, 0, cfg.player.castbar.alpha/2)
			else
			  cf:SetStatusBarColor(1, 0.1, 0.1, cfg.player.castbar.alpha)
			  cf:SetBackdropColor(0, 0, 0, cfg.player.castbar.alpha/2)
			end
		  else
			cf:SetStatusBarColor(0, 0, 0, 0)
			cf:SetBackdropColor(0, 0, 0, 0)
		  end
		  
		  cfet = 0
		end
	  end
	)
end

if cfg.tar.castbar.enable then
	local unit = "target"
	local cf = CreateFrame("StatusBar")
	cf:SetSize(unpack(cfg.tar.castbar.barsize))
	cf:SetPoint("CENTER",UIParent,cfg.tar.castbar.x,cfg.tar.castbar.y)
	cf:SetStatusBarTexture(cfg.tar.castbar.texture)
	cf:SetStatusBarColor(1, 1, cfg.tar.castbar.alpha)
	cf:SetOrientation("VERTICAL")
	cf:SetBackdrop({bgFile = cfg.tar.castbar.texture})
	cf:SetBackdropColor(0, 0, 0, cfg.tar.castbar.alpha/2)
	--cast text
	cft = cf:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	cft:SetPoint("BOTTOM",cf,"TOP",0,0)

	local cfet = 0
	cf:SetScript("OnUpdate",
	  function(f, e)
	   cfet = cfet + e

		if cfet > 0 then
		  local spell, _, displayName, _, startTime, endTime, _, _, interrupt = UnitCastingInfo(unit)
		  
		  if not spell then
			spell, _, displayName, _, startTime, endTime, _, interrupt = UnitChannelInfo(unit)
		  end

		  if spell then
			cft:SetText(displayName)
			cf:SetMinMaxValues(startTime, endTime)
			cf:SetValue(1000 * GetTime())

			if not interrupt then
			  cf:SetStatusBarColor(0, 0.9, 0, cfg.tar.castbar.alpha)
			  cf:SetBackdropColor(0, 0, 0, cfg.tar.castbar.alpha/2)
			  cft:SetTextColor(1, 1, 1, 1)
			else
			  cf:SetStatusBarColor(1, 0.1, 0.1, cfg.tar.castbar.alpha)
			  cf:SetBackdropColor(0, 0, 0, cfg.tar.castbar.alpha/2)
			  cft:SetTextColor(0.9, 0.9, 0.9, 1)
			end
		  else
			cf:SetStatusBarColor(0, 0, 0, 0)
			cf:SetBackdropColor(0, 0, 0, 0)
			cft:SetTextColor(0, 0, 0, 0)
		  end
		  
		  cfet = 0
		end
	  end
	)
end

if cfg.pet.castbar.enable then
	local unit = "pet"
	local cf = CreateFrame("StatusBar")
	cf:SetSize(unpack(cfg.pet.castbar.barsize))
	cf:SetPoint("CENTER",UIParent,cfg.pet.castbar.x,cfg.pet.castbar.y)
	cf:SetStatusBarTexture(cfg.pet.castbar.texture)
	cf:SetStatusBarColor(1, 1, cfg.pet.castbar.alpha)
	cf:SetOrientation("VERTICAL")
	cf:SetBackdrop({bgFile = cfg.pet.castbar.texture})
	cf:SetBackdropColor(0, 0, 0, cfg.pet.castbar.alpha/2)

	local cfet = 0
	cf:SetScript("OnUpdate",
	  function(f, e)
	   cfet = cfet + e

		if cfet > 0 then
		  local spell, _, displayName, _, startTime, endTime, _, _, interrupt = UnitCastingInfo(unit)
		  
		  if not spell then
			spell, _, displayName, _, startTime, endTime, _, interrupt = UnitChannelInfo(unit)
		  end

		  if spell then
			cf:SetMinMaxValues(startTime, endTime)
			cf:SetValue(1000 * GetTime())

			if not interrupt then
			  cf:SetStatusBarColor(0, 0.9, 0, cfg.pet.castbar.alpha)
			  cf:SetBackdropColor(0, 0, 0, cfg.pet.castbar.alpha/2)
			else
			  cf:SetStatusBarColor(1, 0.1, 0.1, cfg.pet.castbar.alpha)
			  cf:SetBackdropColor(0, 0, 0, cfg.pet.castbar.alpha/2)
			end
		  else
			cf:SetStatusBarColor(0, 0, 0, 0)
			cf:SetBackdropColor(0, 0, 0, 0)
		  end
		  
		  cfet = 0
		end
	  end
	)
end

if cfg.focus.castbar.enable then
	local unit = "focus"
	local cf = CreateFrame("StatusBar")
	cf:SetSize(unpack(cfg.focus.castbar.barsize))
	cf:SetPoint("CENTER",UIParent,cfg.focus.castbar.x,cfg.focus.castbar.y)
	cf:SetStatusBarTexture(cfg.focus.castbar.texture)
	cf:SetStatusBarColor(1, 1, cfg.focus.castbar.alpha)
	cf:SetOrientation("VERTICAL")
	cf:SetBackdrop({bgFile = cfg.focus.castbar.texture})
	cf:SetBackdropColor(0, 0, 0, cfg.focus.castbar.alpha/2)
	--cast text
	cft = cf:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	cft:SetPoint("BOTTOMRIGHT",cf,"BOTTOMLEFT",10,-12)

	local cfet = 0
	cf:SetScript("OnUpdate",
	  function(f, e)
	   cfet = cfet + e

		if cfet > 0 then
		  local spell, _, displayName, _, startTime, endTime, _, _, interrupt = UnitCastingInfo(unit)
		  
		  if not spell then
			spell, _, displayName, _, startTime, endTime, _, interrupt = UnitChannelInfo(unit)
		  end

		  if spell then
			cft:SetText(displayName)
			cf:SetMinMaxValues(startTime, endTime)
			cf:SetValue(1000 * GetTime())

			if not interrupt then
			  cf:SetStatusBarColor(0, 0.9, 0, cfg.focus.castbar.alpha)
			  cf:SetBackdropColor(0, 0, 0, cfg.focus.castbar.alpha/2)
			  cft:SetTextColor(1, 1, 1, 1)
			else
			  cf:SetStatusBarColor(1, 0.1, 0.1, cfg.focus.castbar.alpha)
			  cf:SetBackdropColor(0, 0, 0, cfg.focus.castbar.alpha/2)
			  cft:SetTextColor(0.9, 0.9, 0.9, 1)
			end
		  else
			cf:SetStatusBarColor(0, 0, 0, 0)
			cf:SetBackdropColor(0, 0, 0, 0)
			cft:SetTextColor(0, 0, 0, 0)
		  end
		  
		  cfet = 0
		end
	  end
	)
end