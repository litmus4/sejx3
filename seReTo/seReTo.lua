seReTo = {
}
function seReTo.ReturnToRoleList()
	ReInitUI(LOAD_LOGIN_REASON.RETURN_ROLE_LIST)
end
function seReTo.ReturnToLogin()
	ReInitUI(LOAD_LOGIN_REASON.RETURN_GAME_LOGIN)
end

Hotkey.AddBinding("ReturnToRoleList", "退出至人物选择", "seReTo 快速退出", seReTo.ReturnToRoleList, nil)
Hotkey.AddBinding("ReturnToLogin", "退出至登陆界面", nil, seReTo.ReturnToLogin, nil)

function seReTo.GetMenu()
	local menu = { 
		szOption = "seReTo 快速登出",
		{
			szOption = "退出至人物选择界面",
			fnAction = function()
				seReTo.ReturnToRoleList()
			end,
		},
		{
			szOption = "退出至游戏登陆界面",
			fnAction = function()
				seReTo.ReturnToLogin()
			end,
		},
	}
	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by 叶芷青、翼宿怜", bCheck = true, fnAction = function() GetPopupMenu():Hide() end,})
	return menu
end

RegisterEvent("CUSTOM_DATA_LOADED", function() if arg0 == "Role" then seOption.RegMenu(seReTo.GetMenu) end end)

