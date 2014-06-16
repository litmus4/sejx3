seRemoveBuff = {
	BuffList = {
		[1] = {
			szName = "½ð¸Õ·üÄ§ÎåÕó",
			bOn = false,
		},
		[2] = {
			szName = "¾ÅÏåµØÐþÎåÕó",
			bOn = false,
		},
		[3] = {
			szName = "ËéÐÇ³½",
			bOn = false,
		},
	},
}

function seRemoveBuff.GetMenu()
	local menu = {
		szOption = "seRemoveBuff ÔöÒæÒÆ³ý",
	}
	for i=1, #seRemoveBuff.BuffList, 1 do
		local m = {
			szOption = seRemoveBuff.BuffList[i].szName,
			bCheck = true,
			bChecked = seRemoveBuff.BuffList[i].bOn,
			fnAction = function()
				seRemoveBuff.BuffList[i].bOn = not seRemoveBuff.BuffList[i].bOn
			end,
		}
		table.insert(menu, m)
	end
	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by Ò¶ÜÆÇà¡¢ÒíËÞÁ¯", bCheck = true, fnAction = function() GetPopupMenu():Hide() end,})
	return menu
end

function seRemoveBuff.OnBuffUpdate(playerID, buffID, buffLV, index)
	if playerID == GetClientPlayer().dwID then
		local szBuffName = Table_GetBuffName(buffID, buffLV)
		for i=1, #seRemoveBuff.BuffList, 1 do
			if seRemoveBuff.BuffList[i].bOn and seRemoveBuff.BuffList[i].szName == szBuffName then
				GetClientPlayer().CancelBuff(index)
			end
		end
	end
end

RegisterEvent("BUFF_UPDATE", function() seRemoveBuff.OnBuffUpdate(arg0, arg4, arg8, arg2) end)
RegisterEvent("CUSTOM_DATA_LOADED", function() if arg0 == "Role" then seOption.RegMenu(seRemoveBuff.GetMenu) end end)

