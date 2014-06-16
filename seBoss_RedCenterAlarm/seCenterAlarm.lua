seCenterAlarm =
{
	DefaultAnchor = {s = "CENTER", r = "CENTER",  x = 0, y = -150},
	Anchor = {s = "CENTER", r = "CENTER", x = 0, y = -150}
}

function seCenterAlarm.OnFrameCreate()
	this:RegisterEvent("UI_SCALED")
	seCenterAlarm.UpdateAnchor(this)
	seCenterAlarm.UpdateAlpha(0)
end

function seCenterAlarm.OnEvent(event)
	if event == "UI_SCALED" then
		seCenterAlarm.UpdateAnchor(this)
	end
end

function seCenterAlarm.UpdateText(msg)
	Station.Lookup("Topmost1/seCenterAlarm"):Lookup("",""):Lookup("Text_CampText"):SetText(msg)
end

function seCenterAlarm.UpdateAlpha(alpha)
	Station.Lookup("Topmost1/seCenterAlarm"):Lookup("",""):SetAlpha(alpha)
end

function seCenterAlarm.UpdateAnchor(hFrame)
	hFrame:SetPoint(seCenterAlarm.Anchor.s, 0, 0, seCenterAlarm.Anchor.r, seCenterAlarm.Anchor.x, seCenterAlarm.Anchor.y)
	hFrame:CorrectPos()
end

Wnd.OpenWindow("interface\\seBoss_RedCenterAlarm\\seCenterAlarm.ini", "seCenterAlarm")