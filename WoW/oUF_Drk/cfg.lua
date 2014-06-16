-----------------------------
-- INIT
-----------------------------

local addon, ns = ...
local cfg = CreateFrame("Frame")

local mediaFolder = "Interface\\AddOns\\oUF_Drk\\media\\"

local defaultSpacing = 6

-----------------------------
-- CONFIG
-----------------------------

-- Show/hide frames:
cfg.showTot = true -- show target of target frame
cfg.showPet = true -- show pet frame
cfg.showPetTarget = true -- show pet frame
cfg.showFocus = true -- show focus frame
cfg.showFocusTarget = true -- show focus target frame
cfg.showBossFrames = true	-- Show boss frames

cfg.showParty = true -- show party frames (shown as 5man raid)
cfg.showRaid = false -- show raid frames
cfg.raidShowSolo = true -- show raid frames even when solo
cfg.raidShowAllGroups = true -- show raid groups 6, 7 and 8 (more than 25man raid)

-- Show/hide Blizzard Stuff
cfg.hideBuffFrame = true -- hide Blizzard's default buff frame (best to keep it on until you can cancel buffs in oUF again)
cfg.hideWeaponEnchants = true -- hide Blizzard's default temporary weapon enchants frame (best to keep it on until you can cancel buffs in oUF again)
cfg.hideRaidFrame = false -- hide Blizzard's default raid frames
cfg.hideRaidFrameContainer = false -- hide Blizzard's default raid container (that frame with the role check button, colored ground marks, etc)

-- Frame positioning 
cfg.playerX = -156 -- Player frame's x-offset position from the relative point of the screen
cfg.playerY = 193 -- Player frame's y-offset position from the relative point of the screen
cfg.playerRelativePoint = "BOTTOM" -- Player frame's reference point of the screen used for X and Y offsets. Possible values are: "TOP"/"BOTTOM"/"LEFT"/"RIGHT"/"CENTER"/"TOPLEFT"/"ROPRIGHT"/"BOTTOMLEFT"/"BOTTOMRIGHT"
cfg.targetX = -cfg.playerX -- Target frame's x-offset position from the relative point of the screen
cfg.targetY = cfg.playerY -- Target frame's y-offset position from the relative point of the screen
cfg.targetRelativePoint = "BOTTOM" -- Target frame's reference point of the screen used for X and Y offsets. Possible values are: "TOP"/"BOTTOM"/"LEFT"/"RIGHT"/"CENTER"/"TOPLEFT"/"ROPRIGHT"/"BOTTOMLEFT"/"BOTTOMRIGHT"
cfg.raidX = 25 -- Raid/Party x-offset position from the relative point of the screen
cfg.raidY = -55 -- Raid/Party y-offset position from the relative point of the screen
cfg.raid40X = 80 -- 40man Raid/Party x-offset position from the relative point of the screen
cfg.raid40Y = -100 -- 40man Raid/Party y-offset position from the relative point of the screen
cfg.raidRelativePoint = "TOPLEFT" -- Raid/Party's reference point of the screen used for X and Y offsets. Possible values are: "TOP"/"BOTTOM"/"LEFT"/"RIGHT"/"CENTER"/"TOPLEFT"/"ROPRIGHT"/"BOTTOMLEFT"/"BOTTOMRIGHT"
cfg.raidAnchorPoint = "TOP" -- Defines the raid's anchor point. "BOTTOM" will make the raid groups grow upwards, "TOP" will grow downwards.
cfg.raid40RelativePoint = "TOPLEFT" -- 40man Raid/Party's reference point of the screen used for X and Y offsets. Possible values are: "TOP"/"BOTTOM"/"LEFT"/"RIGHT"/"CENTER"/"TOPLEFT"/"ROPRIGHT"/"BOTTOMLEFT"/"BOTTOMRIGHT"
cfg.raid40AnchorPoint = "TOP" -- Defines 40man raid's anchor point. "BOTTOM" will make the raid groups grow upwards, "TOP" will grow downwards.

cfg.partyX = 25
cfg.partyY = -58
cfg.partyRelativePoint = "TOPLEFT"

cfg.bossX = -30
cfg.bossY = 500

-- Misc frame settings
cfg.raidScale = 1 -- scale factor for raid frames
cfg.frameScale = 1 -- scale factor for all other frames
cfg.classBar = true	-- show player class bar
cfg.healthBarColor = {45/255, 43/255, 43/256} -- Healthbar's foreground color (r, g, b)
cfg.healthBgColor = {180/255, 30/255, 15/255} -- Healthbar's background color (r, g, b)
cfg.Castbars = true -- use built-in castbars

-- Plugins
cfg.ShowIncHeals = true	-- Show incoming heals in player and raid frames
cfg.smoothHealth = true -- Smooth healthbar updates
cfg.smoothPower = true -- Smooth powerbar updates
cfg.enableDebuffHighlight = true -- Edable Highlighting of dispellable debuffs
cfg.showAuraWatch = true -- Show specific class buffs on raid frames
cfg.showRaidDebuffs = true -- Show important debuff icons on raid frames
cfg.ThreatBar = false
cfg.Reputationbar = true
cfg.AltPowerBar = true
cfg.Experiencebar = false


-- Show ThreatBar
-- Textures
cfg.statusBarTexture = mediaFolder.."Statusbar"
cfg.powerBarTexture = mediaFolder.."Aluminium"
cfg.backdropTexture = mediaFolder.."backdrop"
cfg.highlightTexture = mediaFolder.."raidbg"
cfg.debuffHighlightTexture = mediaFolder.."perl2"
cfg.portraitBGTexture = mediaFolder.."portrait"
cfg.portraitOverlayTexture = mediaFolder.."portraitOverlay"
cfg.backdropEdgeTexture = mediaFolder.."backdrop_edge"
cfg.debuffBorderTexture = mediaFolder.."iconborder"
cfg.glowTexture = mediaFolder.."glow"

-- Fonts
cfg.font = "Fonts\\ZYKai_T.TTF"
cfg.smallfont = "Fonts\\ZYKai_T.TTF"
cfg.nanofont = "Fonts\\ZYKai_T.TTF"

-- Auras
cfg.showPlayerBuffs = true
cfg.showPlayerDebuffs = true

cfg.showTargetBuffs = true
cfg.showTargetDebuffs = true

cfg.showPetBuffs = false
cfg.showPetDebuffs = true

cfg.showPartyPetDebuffs = false

cfg.showFocusBuffs = false
cfg.showFocusDebuffs = true

cfg.showBossBuffs = false

-- Aura positioning
cfg.auras = {
	spacing = defaultSpacing,
	BUFFPOSITIONS = {
		player = {
			anchorPoint = 'TOPRIGHT',
			relativeFrame = UIParent,
			relativePoint = 'TOPRIGHT',
			offsetX = -180,
			offsetY = -30,
			height = 50,
			width = 600,
			number = 50,
			size = 30,
			growthX = 'LEFT',
			growthY = 'DOWN',
			filter = false,
		},
		target = {
			anchorPoint = 'TOPLEFT',
			relativeFrame = nil, -- default to self
			relativePoint = 'BOTTOMLEFT',
			offsetX = 0,
			offsetY = -defaultSpacing,
			height = 200,
			width = 200,
			number = 30,
			size = 16,
			growthX = 'RIGHT',
			growthY = 'DOWN',
			filter = false,
		},
		pet = {
			anchorPoint = 'TOPRIGHT',
			relativeFrame = nil,
			relativePoint = 'TOPLEFT',
			offsetX = -defaultSpacing,
			offsetY = 0,
			height = 20,
			width = 110,
			number = 10,
			size = 16,
			growthX = 'LEFT',
			growthY = 'DOWN',
			filter = false,
		},
		focus = {
			anchorPoint = 'TOPLEFT',
			relativeFrame = nil, -- default to self
			relativePoint = 'TOPRIGHT',
			offsetX = defaultSpacing,
			offsetY = 0,
			height = 25,
			width = 200,
			number = 10,
			size = 16,
			growthX = 'RIGHT',
			growthY = 'DOWN',
			filter = false,
		},
		boss = {
			anchorPoint = 'TOPRIGHT',
			relativeFrame = nil, -- default to self
			relativePoint = 'TOPLEFT',
			offsetX = -defaultSpacing,
			offsetY = 0,
			height = 25,
			width = 200,
			number = 10,
			size = 16,
			growthX = 'LEFT',
			growthY = 'DOWN',
			filter = false,
		},
		party = {
			anchorPoint = 'TOPLEFT',
			relativeFrame = nil, -- default to self
			relativePoint = 'BOTTOMLEFT',
			offsetX = 0,
			offsetY = -defaultSpacing,
			height = 54,
			width = 180,
			number = 30,
			size = 14,
			growthX = 'RIGHT',
			growthY = 'DOWN',
			playerOnly = false,
			filter = false,
		},
	},

	DEBUFFPOSITIONS = {
		player = {
			anchorPoint = 'TOPRIGHT',
			relativeFrame = UIParent,
			relativePoint = 'TOPRIGHT',
			offsetX = -180,
			offsetY = -110,
			height = 50,
			width = 700,
			number = 50,
			size = 30,
			growthX = 'LEFT',
			growthY = 'DOWN',
			filter = false,
		},
		target = {
			anchorPoint = 'BOTTOMLEFT',
			relativeFrame = nil, -- default to self
			relativePoint = 'TOPLEFT',
			offsetX = 0,
			offsetY = defaultSpacing,
			height = 54,
			width = 200,
			number = 50,
			size = 16,
			growthX = 'RIGHT',
			growthY = 'UP',
			playerOnly = false,
			filter = false,
		},
		focus = {
			anchorPoint = 'BOTTOMLEFT',
			relativeFrame = nil, -- default to self
			relativePoint = 'TOPLEFT',
			offsetX = 0,
			offsetY = defaultSpacing,
			height = 16,
			width = 180,
			number = 15,
			size = 14,
			growthX = 'RIGHT',
			growthY = 'UP',
			playerOnly = false,
			filter = false,
		},
		pet = {
			anchorPoint = 'BOTTOMLEFT',
			relativeFrame = nil, -- default to self
			relativePoint = 'TOPLEFT',
			offsetX = 0,
			offsetY = defaultSpacing,
			height = 16,
			width = 110,
			number = 15,
			size = 14,
			growthX = 'RIGHT',
			growthY = 'UP',
			playerOnly = false,
			filter = false,
		},
		party = {
			anchorPoint = 'TOPLEFT',
			relativeFrame = nil, -- default to self
			relativePoint = 'TOPRIGHT',
			offsetX = defaultSpacing+2,
			offsetY = -29,
			height = 200,
			width = 100,
			number = 20,
			size = 16,
			growthX = 'RIGHT',
			growthY = 'DOWN',
			filter = false,
		},
		partypet = {
			anchorPoint = 'TOPLEFT',
			relativeFrame = nil, -- default to self
			relativePoint = 'TOPRIGHT',
			offsetX = defaultSpacing+2,
			offsetY = 0,
			height = 200,
			width = 70,
			number = 4,
			size = 16,
			growthX = 'RIGHT',
			growthY = 'DOWN',
			filter = false,
		},
	},
}

-----------------------------
-- HANDOVER
-----------------------------

ns.cfg = cfg
