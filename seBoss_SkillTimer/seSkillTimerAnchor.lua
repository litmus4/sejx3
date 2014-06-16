seSkillTimerAnchor = {
	bDragable = false,
	Anchor = {
		s = "CENTER", 
		r = "CENTER", 
		x = 0, 
		y = -300,
	},
}

RegisterCustomData("seSkillTimerAnchor.Anchor")
RegisterCustomData("seSkillTimerAnchor.bDragable")

local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seSkillTimer] " .. table.concat(a, "\t").. "\n" )
end

function seSkillTimerAnchor.OnFrameCreate()
	this:RegisterEvent("UI_SCALED")
end

function seSkillTimerAnchor.OnEvent(event)
	if event == "UI_SCALED" then
		seSkillTimerAnchor.UpdateAnchor(this)
		seSkillTimerAnchor.UpdateDrag()
	end
end

function seSkillTimerAnchor.OnFrameDrag()

end

function seSkillTimerAnchor.UpdateDrag()
	if seSkillTimerAnchor.bDragable then
	 	Station.Lookup("Normal/seSkillTimerAnchor"):Show()
	else
		Station.Lookup("Normal/seSkillTimerAnchor"):Hide()
	end
end

function seSkillTimerAnchor.OnFrameDragSetPosEnd()	
	this:CorrectPos()
	seSkillTimerAnchor.Anchor = GetFrameAnchor(this)
end

function seSkillTimerAnchor.OnFrameDragEnd()
	this:CorrectPos()
	seSkillTimerAnchor.Anchor = GetFrameAnchor(this)
end

function seSkillTimerAnchor.UpdateAnchor(frame)
	local anchor = seSkillTimerAnchor.Anchor
	frame:SetPoint(anchor.s, 0, 0, anchor.r, anchor.x, anchor.y)
	frame:CorrectPos()
end

Wnd.OpenWindow("interface\\seBoss_SkillTimer\\seSkillTimerAnchor.ini", "seSkillTimerAnchor")