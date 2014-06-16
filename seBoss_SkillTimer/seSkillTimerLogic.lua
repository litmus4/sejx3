local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seSkillTimerLogic] " .. table.concat(a, "\t").. "\n" )
end

seSkillTimerLogic = {
}

function seSkillTimerLogic.OnFrameCreate()
	this:RegisterEvent("new_seSkillTimer")
	this:RegisterEvent("ON_BG_CHANNEL_MSG")
end

function seSkillTimerLogic.OnEvent(event)
	if event == "new_seSkillTimer" then
		StartNewSkillTimer(se_arg0, se_arg1, se_arg2, se_arg3)
		if seBoss_Set.bPublic then
			ShareSkillTimer(se_arg0, se_arg1, se_arg2)
		end
	elseif event == "ON_BG_CHANNEL_MSG" then
		local player = GetClientPlayer()
		local t = player.GetTalkData()
		if t and t[2] and t[2].text == "new_seSkillTimer" and player.szName ~= arg3 then
			local nSkillID = t[3].text
			local nSkillLV = t[4].text
			local nFrm = t[5].text
			StartNewSkillTimer(nSkillID, nSkillLV, nFrm)
		end
	end
end

Wnd.OpenWindow("interface\\seBoss_SkillTimer\\seSkillTimerLogic.ini", "seSkillTimerLogic")