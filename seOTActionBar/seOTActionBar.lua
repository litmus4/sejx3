seOTActionBar =
{
	bOn = true,
	g_nDelay = 0,
}

RegisterCustomData("seOTActionBar.bOn")

local OTActionBar_OnEvent = OTActionBar.OnEvent
local OTActionBar_OnFrameRender = OTActionBar.OnFrameRender
local OTActionBar_PrepaireProgressBar = OTActionBar.PrepaireProgressBar

function seOTActionBar.OnEvent(event)
	seOTActionBar.g_nDelay	=	math.floor(GetPingValue()/2)
	OTActionBar_OnEvent(event)
	if event == "OT_ACTION_PROGRESS_BREAK" then
		if arg0 == GetClientPlayer().dwID then
			seOTActionBar.SetDelay(1)
		end
		return
	end;
	local nTotoal = OTActionBar.g_nEndTime - OTActionBar.g_nStartTime
	local fP_delay	=	seOTActionBar.g_nDelay / nTotoal;
	seOTActionBar.SetDelay(fP_delay)
end

function seOTActionBar.OnFrameRender()
	if not this.bShow then
		return
	end
	OTActionBar_OnFrameRender()
	Station.Lookup("Topmost/OTActionBar"):Lookup("",""):Lookup("Image_FlashF"):Show()
end

function seOTActionBar.PrepaireProgressBar(fPercentage, szName)
	OTActionBar_PrepaireProgressBar(fPercentage, szName)
	Station.Lookup("Topmost/OTActionBar"):Lookup("", ""):Lookup("Text_Name"):SetText(szName.."("..seOTActionBar.g_nDelay.."ms)")
end

function OTActionBar.OnEvent(event)
	if seOTActionBar.bOn then
		seOTActionBar.OnEvent(event)
	else
		seOTActionBar.SetDelay(1)
		OTActionBar_OnEvent(event)
	end
end

function OTActionBar.OnFrameRender()
	if seOTActionBar.bOn then
		seOTActionBar.OnFrameRender()	
	else
		OTActionBar_OnFrameRender()
	end
end

function OTActionBar.PrepaireProgressBar(fPercentage, szName)
	if seOTActionBar.bOn then
		seOTActionBar.PrepaireProgressBar(fPercentage, szName)
	else
		OTActionBar_PrepaireProgressBar(fPercentage, szName)
	end
end

function seOTActionBar.SetDelay( per )
	local image = Station.Lookup("Topmost/OTActionBar"):Lookup("",""):Lookup("Image_FlashF")
	if OTActionBar.g_nProgressType == OTActionBar.PROGRESS_TYPE_DEC then
		image:SetImageType(1)
	else
		image:SetImageType(2)
	end
	image:SetPercentage(per)
end

function seOTActionBar.GetMenu()
	local menu = {
		szOption = "seOTActionBar ∂¡Ãı—”≥Ÿ∏®÷˙",
		{
			szOption = "ø™∆Ù—”≥Ÿ±Íº«",
			bCheck = true,
			bChecked = seOTActionBar.bOn,
			fnAction = function()
				seOTActionBar.bOn = not seOTActionBar.bOn
			end,
		},
	}
	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by “∂‹∆«‡°¢“ÌÀﬁ¡Ø", bCheck = true, fnAction = function() GetPopupMenu():Hide() end,})
	return menu
end

RegisterEvent("CUSTOM_DATA_LOADED", function() if arg0 == "Role" then seOption.RegMenu(seOTActionBar.GetMenu) end end)
