local SKILL_TIMER_INI = "interface\\seBoss_SkillTimer\\seSkillTimer.ini"
local PROGRESS_WIDTH = 300

local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seSkillTimer] " .. table.concat(a, "\t").. "\n" )
end

seSkillTimer = {
	BOUNDARY = 16 * 4,
	nCount = 0,

}

function seSkillTimer.OnFrameCreate()

end

function seSkillTimer.init(frame)
	frame:SetAlpha(255)
	local image = frame:Lookup("",""):Lookup("Image")
	image:SetFrame(15)
	local text = frame:Lookup("",""):Lookup("SkillName")
	text:SetFontColor(255,255,0)
	text = frame:Lookup("",""):Lookup("TimeLeft")
	text:SetFontColor(255,255,0)
	seSkillTimer.FreshBox(frame)
	seSkillTimer.FreshPos(frame)
end

function seSkillTimer.FlashFrame(frame, alpha)
	local text = frame:Lookup("",""):Lookup("TimeLeft")
	local image = frame:Lookup("",""):Lookup("Image")
	image:SetFrame(12)
	text:SetFontColor(255, 0, 0)
	text = frame:Lookup("",""):Lookup("SkillName")
	text:SetFontColor(255, 0, 0)
	frame:SetAlpha(alpha)
end

function seSkillTimer.OnFrameRender()
	seSkillTimer.FreshPos(this)
	local currentFrmCount = GetLogicFrameCount()
	local nLeft = this.nEndFrameCount - currentFrmCount
	local percentage = nLeft / (this.nEndFrameCount - this.nStartFrameCount)
	--[[
		5 1 80
		4 0 64
		3 1 48
		2 0 32
		1 1 16
		0 0  0 
	]]
	local alpha = 255 * (math.abs(math.mod(nLeft + 8, 32) - 7) + 4) / 12
	if percentage > 0 then
		local progress = this:Lookup("",""):Lookup("Image")
		local _, h = progress:GetSize()
		--progress:SetSize(PROGRESS_WIDTH * percentage, h)
		progress:SetPercentage(percentage)
		local text = this:Lookup("",""):Lookup("TimeLeft")
		local nH, nM, nS = GetTimeToHourMinuteSecond(nLeft, true)
		if nH > 0 then
			text:SetText(""..nH.."h "..nM.."m "..nS.."s")
		elseif nM > 0 then
			text:SetText(""..nM.."m "..nS.."s")
		else
			text:SetText(""..nS.."s")
			if nS < 5 then
				if this.nLS and nS < this.nLS then
					--print(this.bSayTimer)
					if this.bSayTimer then
						seBoss_Say(seBoss_Set.bSayChannel, "", "¡î¡ï"..Table_GetSkillName(this.nSkillID, this.nSkillLevel).."¡ï¡î Ê£Óà "..this.nLS.."s £¡ ")
					end
				end
				seSkillTimer.FlashFrame(this, alpha)
			end
			this.nLS = nS
		end
	else
		seSkillTimer.RemoveTimer(this.nID)
	end
end

function seSkillTimer.CopyFrame(pre, post)
	pre.nSkillID = post.nSkillID
	pre.nSkillLevel = post.nSkillLevel
	pre.nStartFrameCount = post.nStartFrameCount
	pre.nEndFrameCount = post.nEndFrameCount
	pre.bSayTimer = post.bSayTimer
	seSkillTimer.init(pre)
	pre:Show()
	pre:SetAlpha(post:GetAlpha())
end

function seSkillTimer.RemoveTimer(index)
	local pre, post
	for i=index, seSkillTimer.nCount - 1, 1 do
		pre = seSkillTimer.GetFrame(i)
		post = seSkillTimer.GetFrame(i+1)
		seSkillTimer.CopyFrame(pre, post)
	end
	post = seSkillTimer.GetFrame(seSkillTimer.nCount)
	post:Hide()
	post.nSkillID = 0
	post.nSkillLevel = 0
	post.bSayTimer = false
	seSkillTimer.nCount = seSkillTimer.nCount - 1
end

function seSkillTimer.FreshBox(frame)
	local nSkillID = frame.nSkillID
	local nSkillLevel = frame.nSkillLevel
	local box = frame:Lookup("",""):Lookup("Box")
	box:SetObject(UI_OBJECT_SKILL, nSkillID, nSkillLevel)
	box:SetObjectIcon(Table_GetSkillIconID(nSkillID, nSkillLevel))
	local text = frame:Lookup("",""):Lookup("SkillName")
	text:SetText(Table_GetSkillName(nSkillID, nSkillLevel))
end

function seSkillTimer.FreshPos(frame)
	local y = seSkillTimerAnchor.Anchor.y + (frame.nID) * 33
	frame:SetPoint(seSkillTimerAnchor.Anchor.s, 0, 0, seSkillTimerAnchor.Anchor.r, seSkillTimerAnchor.Anchor.x, y)
	frame:CorrectPos()
end

--[[
	frame.nID
	frame.nSkillID
	frame.nSkillLevel
	frame.nStartFrameCount
	frame.nEndFrameCount
]]
function seSkillTimer.GetFrame(index)
	local hTimerFrame = Station.Lookup("Normal/seSkillTimer_" .. index)
	return hTimerFrame
end

function seSkillTimer.CanSkillTimed(skillID, skillLV)
	for i=1, seSkillTimer.nCount, 1 do
		local frame = seSkillTimer.GetFrame(i)
		if ""..Table_GetSkillName(frame.nSkillID, skillLV) == ""..Table_GetSkillName(skillID, skillLV) then
			if (frame.nEndFrameCount - GetLogicFrameCount()) > seSkillTimer.BOUNDARY then
				return false
			else
				seSkillTimer.RemoveTimer(i)
			end
			break
		end
	end
	return true
end

function StartNewSkillTimer(skillID, skillLV, nFrameCount, bSayTimer)
	--print(""..Table_GetSkillName(skillID, skillLV).." "..skillID)
	if not seSkillTimer.CanSkillTimed(skillID, skillLV) then
		return
	end

	local nStartFrmCount = GetLogicFrameCount()
	local nEndFrmCount = nStartFrmCount + nFrameCount
	seSkillTimer.nCount = seSkillTimer.nCount + 1
	local hTimerFrame = Station.Lookup("Normal/seSkillTimer_" .. seSkillTimer.nCount)
	if not hTimerFrame then
		hTimerFrame = Wnd.OpenWindow(SKILL_TIMER_INI, "seSkillTimer_" .. seSkillTimer.nCount)
		hTimerFrame.nID = seSkillTimer.nCount
		hTimerFrame.OnFrameRender = seSkillTimer.OnFrameRender
	else
		
	end
	local index = 1
	for i=1, seSkillTimer.nCount - 1, 1 do
		local frm = seSkillTimer.GetFrame(i)
		if nEndFrmCount < frm.nEndFrameCount then
			break
		end
		index = i + 1
	end
	for i=seSkillTimer.nCount, index + 1, -1 do
		local pre = seSkillTimer.GetFrame(i)
		local post = seSkillTimer.GetFrame(i-1)
		seSkillTimer.CopyFrame(pre, post)
	end
	
	hTimerFrame = seSkillTimer.GetFrame(index)
	
	hTimerFrame.nSkillID = skillID
	hTimerFrame.nSkillLevel = skillLV
	hTimerFrame.nStartFrameCount = nStartFrmCount
	hTimerFrame.nEndFrameCount = nEndFrmCount
	hTimerFrame.bSayTimer = bSayTimer
	
	seSkillTimer.init(hTimerFrame)
	hTimerFrame:Show()
end
