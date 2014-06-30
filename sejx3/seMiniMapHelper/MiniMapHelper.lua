seMiniMapHelper = seMiniMapHelper or {}
local seMinimap_tPlayerList = {}

local STR_MSG_REDNAME_LEAVE = "** 红名离开 **"
local STR_MSG_REDNAME_ENTER = "** 出现红名 **"

local tSchool_IdToName = {
	[0] = "江湖",
	[1] = "少林",
	[2] = "万花",
	[3] = "天策",
	[4] = "纯阳",
	[5] = "七秀",
	[6] = "五毒",
	[7] = "唐门",
	[8] = "藏剑",
	[9] = "丐帮",
	[10] = "明教",
}

seMinimap_bSearchRedName = true

RegisterCustomData("seMinimap_bSearchRedName")

local seMinimap_nRedNameCount = 0

function seMiniMapHelper.OnFrameBreathe()
	local player = GetClientPlayer()
	local minimap = Station.Lookup("Normal/Minimap/Wnd_Minimap/Minimap_Map")
	local nRedNameCount = 0
	if seMinimap_bSearchRedName then
		for nIndex, dwPlayerID in pairs(seMinimap_tPlayerList) do	-- red name playe flag
			local hPlayer = GetPlayer(dwPlayerID)
			if not hPlayer then

			else
				if IsEnemy(player.dwID, dwPlayerID) then
					local tMapAndPlayer = {
						map = minimap,
						hp = hPlayer,
					}
					PostThreadCall(OnGetPos, tMapAndPlayer, "Scene_GameWorldPositionToScenePosition", hPlayer.nX, hPlayer.nY, player.nZ, 0)
					nRedNameCount = nRedNameCount + 1
				end
			end
		end
		if seMinimap_nRedNameCount == 0 and nRedNameCount > 0 then
			OutputWarningMessage("MSG_WARNING_RED", STR_MSG_REDNAME_ENTER, 2)
		end
		if seMinimap_nRedNameCount > 0 and nRedNameCount == 0 then
			OutputWarningMessage("MSG_WARNING_GREEN", STR_MSG_REDNAME_LEAVE, 2)
		end
		seMinimap_nRedNameCount = nRedNameCount
	end
end

function OnGetPos(tMapAndPlayer, nX, nY, nZ)
	if tMapAndPlayer.hp.nMoveState ~= MOVE_STATE.ON_DEATH then
		tMapAndPlayer.map:UpdataArrowPoint(8, tMapAndPlayer.hp.dwID, 1, 48, nX, nZ, 16)
	else
		tMapAndPlayer.map:UpdataArrowPoint(8, tMapAndPlayer.hp.dwID, 199, 48, nX, nZ, 16)
	end
end

local function GetEnemy(bSay)
	local whole = {0, 0}
	local enemy = {
		[0] = { 0, 0 },
		[1] = { 0, 0 },
		[2] = { 0, 0 },
		[3] = { 0, 0 },
		[4] = { 0, 0 },
		[5] = { 0, 0 },
		[6] = { 0, 0 },
		[7] = { 0, 0 },
		[8] = { 0, 0 },
		[9] = { 0, 0 },
		[10] = { 0, 0 },
	}
	local result = {}
	for nIndex, dwPlayerID in pairs(seMinimap_tPlayerList) do	-- red name playe flag
		local hPlayer = GetPlayer(dwPlayerID)
		if hPlayer then
			if IsEnemy(GetClientPlayer().dwID, dwPlayerID) then
				if hPlayer.nMoveState ~= MOVE_STATE.ON_DEATH then
					enemy[hPlayer.dwForceID][1] = enemy[hPlayer.dwForceID][1] + 1
				else
					enemy[hPlayer.dwForceID][2] = enemy[hPlayer.dwForceID][2] + 1
				end
			end
		end
	end

	local TeamSay = "<<seMinimap>> 【红名统计】 by翼宿怜 程云丈\n"
	table.insert(result, TeamSay)
	for i=0, #tSchool_IdToName, 1 do
		if not bSay or enemy[i][1]+enemy[i][2] > 0 then
			TeamSay = "【"..tSchool_IdToName[i].."】人数："..(enemy[i][1]+enemy[i][2]).." （活="..enemy[i][1].."）（死="..enemy[i][2].."）\n"
			whole[1] = whole[1] + enemy[i][1]
			whole[2] = whole[2] + enemy[i][2] 
			table.insert(result, TeamSay)
		end
	end
	TeamSay = "红名总人数为："..(whole[1]+whole[2]).." （活="..whole[1].."）（死="..whole[2].."）\n"
	table.insert(result, TeamSay)
	return result
end

local function GetCamp()
	local whole = {0, 0}
	local enemy = 
	{
		[0] = {0, 0},
		[1] = {0, 0},
		[2] = {0, 0},
	}
	local result = {}
	for nIndex, dwPlayerID in pairs(seMinimap_tPlayerList) do
		local hPlayer = GetPlayer(dwPlayerID)
		if hPlayer then
			if hPlayer.nMoveState ~= MOVE_STATE.ON_DEATH then
				enemy[hPlayer.nCamp][1] = enemy[hPlayer.nCamp][1] + 1
			else
				enemy[hPlayer.nCamp][2] = enemy[hPlayer.nCamp][2] + 1
			end
		end
	end

	local TeamSay = "<<seMinimap>> 【阵营统计】 by翼宿怜 程云丈\n"
	table.insert(result, TeamSay)

	TeamSay = "【中立】人数："..(enemy[0][1]+enemy[0][2]).." （活="..enemy[0][1].."）（死="..enemy[0][2].."）\n"
	whole[1] = whole[1] + enemy[0][1]
	whole[2] = whole[2] + enemy[0][2]
	table.insert(result, TeamSay)
	TeamSay = "【浩气】人数："..(enemy[1][1]+enemy[1][2]).." （活="..enemy[1][1].."）（死="..enemy[1][2].."）\n"
	whole[1] = whole[1] + enemy[1][1]
	whole[2] = whole[2] + enemy[1][2]
	table.insert(result, TeamSay)

	TeamSay = "【恶人】人数："..(enemy[2][1]+enemy[2][2]).." （活="..enemy[2][1].."）（死="..enemy[2][2].."）\n"
	whole[1] = whole[1] + enemy[2][1]
	whole[2] = whole[2] + enemy[2][2]
	table.insert(result, TeamSay)

	TeamSay = "在场总人数为："..(whole[1]+whole[2]).." （活="..whole[1].."）（死="..whole[2].."）\n"
	table.insert(result, TeamSay)
	return result
end

local function GetGuild()
	local whole = {0, 0}
	local enemy = {	}
	local result = {}
	for nIndex, dwPlayerID in pairs(seMinimap_tPlayerList) do
		local hPlayer = GetPlayer(dwPlayerID)
		if hPlayer then
			if not enemy[hPlayer.dwTongID] then
				enemy[hPlayer.dwTongID] = {0, 0}
			end
			if hPlayer.nMoveState ~= MOVE_STATE.ON_DEATH then
				enemy[hPlayer.dwTongID][1] = enemy[hPlayer.dwTongID][1] + 1
			else
				enemy[hPlayer.dwTongID][2] = enemy[hPlayer.dwTongID][2] + 1
			end
		end
	end

	local TeamSay = "<<seMinimap>> 【帮会统计】 by翼宿怜 程云丈\n"
	table.insert(result, TeamSay)
	for i, v in pairs(enemy) do
		local strGuildName = "无帮会人士"
		if i ~= 0 then
			local tong = GetTongClient()
			if not tong or not tong.ApplyGetTongName(i) then
				strGuildName = "无帮会人士"
			else
				strGuildName = "【"..GetTongClient().ApplyGetTongName(i).."】"
			end
		end
		TeamSay = ""..strGuildName.."人数："..(v[1]+v[2]).." （活="..v[1].."）（死="..v[2].."）\n"
		table.insert(result, TeamSay)
		whole[1] = whole[1] + v[1]
		whole[2] = whole[2] + v[2]
	end

	TeamSay = "在场总人数为："..(whole[1]+whole[2]).." （活="..whole[1].."）（死="..whole[2].."）\n"
	table.insert(result, TeamSay)
	return result
end

local function GetAll(bSay)
	local whole = {0, 0}
	local enemy = {
		[0] = { 0, 0 },
		[1] = { 0, 0 },
		[2] = { 0, 0 },
		[3] = { 0, 0 },
		[4] = { 0, 0 },
		[5] = { 0, 0 },
		[6] = { 0, 0 },
		[7] = { 0, 0 },
		[8] = { 0, 0 },
		[9] = { 0, 0 },
		[10] = { 0, 0 },
		}
	local result = {}
	for nIndex, dwPlayerID in pairs(seMinimap_tPlayerList) do	-- red name playe flag
		local hPlayer = GetPlayer(dwPlayerID)
		if hPlayer then
			if hPlayer.nMoveState ~= MOVE_STATE.ON_DEATH then
				enemy[hPlayer.dwForceID][1] = enemy[hPlayer.dwForceID][1] + 1
			else
				enemy[hPlayer.dwForceID][2] = enemy[hPlayer.dwForceID][2] + 1
			end
		end
	end

	local TeamSay = "<<seMinimap>> 【全民统计】 by翼宿怜 程云丈\n"
	table.insert(result, TeamSay)
	for i=0, #tSchool_IdToName - 1, 1 do
		if not bSay or enemy[i][1]+enemy[i][2] > 0 then
			TeamSay = "【"..tSchool_IdToName[i].."】人数："..(enemy[i][1]+enemy[i][2]).." （活="..enemy[i][1].."）（死="..enemy[i][2].."）\n"
			whole[1] = whole[1] + enemy[i][1]
			whole[2] = whole[2] + enemy[i][2] 
			table.insert(result, TeamSay)
		end
	end
	TeamSay = "在场总人数为："..(whole[1]+whole[2]).." （活="..whole[1].."）（死="..whole[2].."）\n"
	table.insert(result, TeamSay)
	return result
end

local function GetArena()
	local result = {}
	local TeamSay = "<<seMinimap>> 【名剑大会敌方概况】 by翼宿怜 程云丈\n"
	table.insert(result, TeamSay)
	local i = 1
	for nIndex, dwPlayerID in pairs(seMinimap_tPlayerList) do
		local hPlayer = GetPlayer(dwPlayerID)
		if hPlayer then
			if IsEnemy(GetClientPlayer().dwID, dwPlayerID) then
				if hPlayer.GetKungfuMount() then
					TeamSay = "【"..tSchool_IdToName[hPlayer.dwForceID].."·"..string.sub(hPlayer.GetKungfuMount().szSkillName, 1, 4).."】"
				else
					TeamSay = "【"..tSchool_IdToName[hPlayer.dwForceID].."】"
				end
				TeamSay = TeamSay..hPlayer.szName.." （血量="..hPlayer.nMaxLife.."）\n"
				table.insert(result, TeamSay)
				i = i + 1
				if i > 5 then
					break
				end
			end
		end
	end
	return result
end

local function Say(str)
	local player=GetClientPlayer() 
	local nChannel,szName=EditBox_GetChannel()
	if szName==nil then
		szName = ""
	end
	player.Talk(nChannel, szName, {{type = "text", text =str}})
end
local function SayOut(func)
	local result = nil
	if func == GetEnemy or func == GetAll then
		result = func(true)
	else
		result = func()
	end

	for i, v in pairs(result) do
		Say(v)
	end
end

function seMiniMapHelper.GetMenu()
	local menu = {
		szOption = "seMiniMap 红名雷达",
		{
			szOption = "开启红名显示",
			bCheck = true,
			bChecked = seMinimap_bSearchRedName,
			fnAction = function()
				seMinimap_bSearchRedName = not seMinimap_bSearchRedName
			end,
			fnAutoClose = function() 
				return true 
			end
		},
		{bDevide = true},

	}
	
	local tRedMenu = {szOption = "红名统计数据"}
	local result = GetEnemy(false)
	for i, v in pairs(result) do
		table.insert(tRedMenu, {szOption = v, fnAction = function() Say(v) end,})
	end
	table.insert(menu, tRedMenu)

	local tCampMenu = {szOption = "阵营统计数据"}
	result = GetCamp()
	for i, v in pairs(result) do
		table.insert(tCampMenu, {szOption = v, fnAction = function() Say(v) end,})
	end
	table.insert(menu, tCampMenu)

	local tGuildMenu = {szOption = "帮会统计数据"}
	result = GetGuild()
	for i, v in pairs(result) do
		table.insert(tGuildMenu, {szOption = v, fnAction = function() Say(v) end,})
	end
	table.insert(menu, tGuildMenu)
	
	local tAllMenu = {szOption = "全民统计数据"}
	result = GetAll(false)
	for i, v in pairs(result) do
		table.insert(tAllMenu, {szOption = v, fnAction = function() Say(v) end,})
	end
	table.insert(menu, tAllMenu)
	
	local tArenaMenu = {szOption = "名剑大会敌方概况"}
	result = GetArena()
	for i, v in pairs(result) do
		table.insert(tArenaMenu, {szOption = v, fnAction = function() Say(v) end,})
	end
	table.insert(menu, tArenaMenu)
	
	table.insert(menu, {bDevide = true})
	table.insert(menu, 
	{
		szOption = "当前频道广播",
		{
			szOption = "红名统计",
			fnAction = function()
				SayOut(GetEnemy)
			end,
		},
		{
			szOption = "阵营统计",
			fnAction = function()
				SayOut(GetCamp)
			end,
		},
		{
			szOption = "帮会统计",
			fnAction = function()
				SayOut(GetGuild)
			end,
		},
		{
			szOption = "全民统计",
			bCheck = true,
			fnAction = function()
				SayOut(GetAll)
				GetPopupMenu():Hide()
			end,
		},
		{
			szOption = "名剑大会敌方概况",
			fnAction = function()
				SayOut(GetArena)
			end,
		},
	})
	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by 叶芷青、翼宿怜 程云丈", bCheck = true, fnAction = function() GetPopupMenu():Hide() end,})
	return menu
end

local function seMinimap_OnPlayerEnterScene()
	table.insert(seMinimap_tPlayerList, arg0)
end

local function seMinimap_OnPlayerLeaveScene()
	for i, v in ipairs(seMinimap_tPlayerList) do
		if v == arg0 then
			table.remove(seMinimap_tPlayerList, i)
			break
		end
	end
end

RegisterEvent("LOGIN_GAME", function()
	local tMenu = {
		function()
			return {seMiniMapHelper.GetMenu()}
		end,
	}
	Player_AppendAddonMenu(tMenu)
end)

RegisterEvent("PLAYER_ENTER_SCENE", seMinimap_OnPlayerEnterScene)
RegisterEvent("PLAYER_LEAVE_SCENE", seMinimap_OnPlayerLeaveScene)

Wnd.OpenWindow("interface/sejx3/seMiniMapHelper/MiniMapHelper.ini", "seMiniMapHelper")
