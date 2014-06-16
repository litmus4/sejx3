function seBoss_print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seBoss] " .. table.concat(a, "\t").. "\n" )
end

function seBoss_Say(nChannel, szName, say)
	local player=GetClientPlayer() 
  player.Talk(nChannel, szName, {{type = "text", text = say}})
end

function ShareSkillTimer(nSkillID, nSkillLevel, nFrm)
	local player = GetClientPlayer()
	if player and player.IsInParty() then
		local t = 
		{
			{type = "text", text = "BG_CHANNEL_MSG"},
			{type = "text", text = "new_seSkillTimer"},
			{type = "text", text = nSkillID},
			{type = "text", text = nSkillLevel},
			{type = "text", text = nFrm},
		}
		player.Talk(PLAYER_TALK_CHANNEL.RAID, "", t)
	end
end

function ShareShowAbout()
	local player = GetClientPlayer()
	if player and player.IsInParty() then
		local t = 
		{
			{type = "text", text = "BG_CHANNEL_MSG"},
			{type = "text", text = "SayAbout"},
		}
		player.Talk(PLAYER_TALK_CHANNEL.RAID, "", t)
	end
	seBoss_print("开始团队内版本确认")
end

function seBoss_SayAbout()
	local player = GetClientPlayer()
	if player and player.IsInParty() then
		local t =
		{
			{type = "text", text = "BG_CHANNEL_MSG"},
			{type = "text", text = "MyAbout"},
			{type = "text", text = "["..player.szName.."]版本："..seBoss_Set.nVersion},
		}
		player.Talk(PLAYER_TALK_CHANNEL.RAID, "", t)
	end
end


