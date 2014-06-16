seCDhelperAnchor = {
	bDragable = false,
	Anchor = {s = "CENTER", r = "CENTER",  x = 0, y = 0},
}

RegisterCustomData("seCDhelperAnchor.Anchor")
RegisterCustomData("seCDhelperAnchor.bDragable")

function seCDhelperAnchor.OnFrameCreate()
	this:RegisterEvent("UI_SCALED")
end

function seCDhelperAnchor.OnEvent(event)
	if event == "UI_SCALED" then
		seCDhelperAnchor.UpdateAnchor(this)
		seCDhelperAnchor.UpdateDrag()
		FireEvent("seBuffTimerAnchorChanged")
	end
end

function seCDhelperAnchor.OnFrameDrag()

end

function seCDhelperAnchor.UpdateDrag()
	if seCDhelperAnchor.bDragable then
	 	Station.Lookup("Topmost/seCDhelperAnchor"):Show()
	else
		Station.Lookup("Topmost/seCDhelperAnchor"):Hide()
	end
end

function seCDhelperAnchor.OnFrameDragSetPosEnd()	
	this:CorrectPos()
	seCDhelperAnchor.Anchor = GetFrameAnchor(this)
	FireEvent("seCDhelperAnchorChanged")
end

function seCDhelperAnchor.OnFrameDragEnd()
	this:CorrectPos()
	seCDhelperAnchor.Anchor = GetFrameAnchor(this)
	FireEvent("seCDhelperAnchorChanged")
end

function seCDhelperAnchor.UpdateAnchor(frame)
	local anchor = seCDhelperAnchor.Anchor
	frame:SetPoint(anchor.s, 0, 0, anchor.r, anchor.x, anchor.y)
	frame:CorrectPos()
end

Wnd.OpenWindow("interface\\seCDhelper\\seCDhelperAnchor.ini", "seCDhelperAnchor")
