local _, cfg = ... --export config
local addon, ns = ... --get addon namespace

cfg.font = "Fonts\\ARIALN.ttf" --BobHUD's base font
cfg.style = "THINOUTLINE" 	--OUTLINE, MONOCHROME, or nil
cfg.text = true

cfg.transparency = {
  alpha = .7, --transparency
  OOCfade = true, --Fade out of combat
  fadeout = 0, --fade out of combat transparency
}

--player
cfg.player ={
  barsize = { 140, 200 },
  alpha = .7,
  healthx = -165,
  healthy = 0,
  powerx = 165,
  powery = 0,
  castbar = {
    enable = true,
    barsize = { 100, 130 },
    texture = "Interface\\Addons\\BobHUD\\media\\healthbar",
    alpha = .7,
    x = -108,
    y = 0,
  },
}
--pet
cfg.pet = {
	barsize = { 70, 100 },
	alpha = .7,
	healthx = -125,
	healthy = 0,
	powerx = -115,
	powery = 0,
	castbar = {
		enable = true,
		barsize = { 50, 70 },
		texture = "Interface\\Addons\\BobHUD\\media\\healthbar",
		alpha = .7,
		x = -75,
		y = 0,
	},
}
--target
cfg.tar = {
	barsize = { 140, 200 },
	alpha = .7,
	healthx = -180,
	healthy = 0,
	powerx = 180,
	powery = 0,
	castbar = {
		enable = true,
		barsize = { 100, 130 },
		texture = "Interface\\Addons\\BobHUD\\media\\powerbar",
		alpha = .7,
		x = 108,
		y = 0,
	},
}
--focus
cfg.focus = {
	barsize = { 70, 100 },
	alpha = .7,
	healthx = 125,
	healthy = 0,
	powerx = 115,
	powery = 0,
	castbar = {
		enable = true,
		barsize = { 50, 70 },
		texture = "Interface\\Addons\\BobHUD\\media\\powerbar",
		alpha = .7,
		x = 75,
		y = 0,
	},
}
--runes
cfg.runes = {
	position = { "CENTER", UIParent, 0, -132 },
	alpha = .7,
	height = 38,
	width = 10,
	padding = 3,
	order = {	-- 1,2 = Blood   3,4 = Unholy   5,6 = Frost	
		[1] = 1,
		[2] = 2,
		[3] = 3,
		[4] = 4,
		[5] = 5,
		[6] = 6,
	},
	colors  = {
		[1] = {r = 0.9, g = 0.15, b = 0.15},	-- Blood
		[2] = {r = 0.40, g = 0.9, b = 0.30},	-- Unholy
		[3] = {r = 0, g = 0.7, b = 0.9},		-- Frost
		[4] = {r = 0.50, g = 0.27, b = 0.68},	-- Death
		brightness = 0.7, --Rune cooldown brightness
	},
}

--combo points
cfg.cbp_position = {"CENTER",UIParent,"CENTER",0,-150}
cfg.cbpwidth = 25 		-- width per combo point frame (5 in total)
cfg.cbpheight = 15 			--icon height for combo points
cfg.cbpspacing = 2
-- fade
cfg.fadein = 0.5      		-- fade delay for each combo point frame
cfg.fadeout = 0.5      		-- fade delay for each combo point frame
cfg.framefadein = 0.2  		-- fade delay for entering combat
cfg.framefadeout = 0.2 		-- fade delay for leaving combat
-- colors
cfg.comboColors = {
	{ r = 1, g = 0.86, b = 0.1, a = 1 },
	{ r = 1, g = 0.86, b = 0.1, a = 1 },
	{ r = 1, g = 0.86, b = 0.1, a = 1 },
	{ r = 1, g = 0.86, b = 0.1, a = 1 },
	{ r = 1, g = 0.86, b = 0.1, a = 1 },
}
cfg.bgColor = { r = 0.3, g = 0.3, b = 0.3, a = 0.7 }
cfg.hideooc = true 			-- hide when out of combat
cfg.hidenoenergy = true 	-- Hide when no energy is available (i.e. druid out of cat form)
