seReTo = {
}
function seReTo.ReturnToRoleList()
	ReInitUI(LOAD_LOGIN_REASON.RETURN_ROLE_LIST)
end
function seReTo.ReturnToLogin()
	ReInitUI(LOAD_LOGIN_REASON.RETURN_GAME_LOGIN)
end

Hotkey.AddBinding("ReturnToRoleList", "�˳�������ѡ��", "seReTo �����˳�", seReTo.ReturnToRoleList, nil)
Hotkey.AddBinding("ReturnToLogin", "�˳�����½����", nil, seReTo.ReturnToLogin, nil)

function seReTo.GetMenu()
	local menu = { 
		szOption = "seReTo ���ٵǳ�",
		{
			szOption = "�˳�������ѡ�����",
			fnAction = function()
				seReTo.ReturnToRoleList()
			end,
		},
		{
			szOption = "�˳�����Ϸ��½����",
			fnAction = function()
				seReTo.ReturnToLogin()
			end,
		},
	}
	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by Ҷ���ࡢ������", bCheck = true, fnAction = function() GetPopupMenu():Hide() end,})
	return menu
end

RegisterEvent("CUSTOM_DATA_LOADED", function() if arg0 == "Role" then seOption.RegMenu(seReTo.GetMenu) end end)

