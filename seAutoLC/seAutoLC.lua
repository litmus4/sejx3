seAutoLC = {
	bOn = false,
	ticks = 0,
}

local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seAutoLC] " .. table.concat(a, "\t").. "\n" )
end

function seAutoLC.OnFrameCreate()
	print("自动龙池 Loaded by 叶芷青、翼宿怜")
end

function seAutoLC.OnFrameBreathe()
	if seAutoLC.bOn then
		local skill = GetSkill(548, 5)	
		if skill.UITestCast(GetClientPlayer().dwID) then
			local bCool, nLeft, nTotal = GetClientPlayer().GetSkillCDProgress(548, 5)
			if nLeft == 0 then
				if Station.Lookup("Topmost/OTActionBar"):Lookup("",""):GetAlpha() ~= 255 then
					OnUseSkill(548, 5)
				end
			end
		end
	end
end

function seAutoLC.GetMenu()
	local menu = {
		szOption = "seAutoLC 自动龙池（需反和谐）",
		{
			szOption = "开启自动龙池",
			bCheck = true,
			bChecked = seAutoLC.bOn,
			fnAction = function()
				seAutoLC.bOn = not seAutoLC.bOn
			end,
			fnAutoClose = function() 
				return true 
			end
		},
	}
	return menu
end

Wnd.OpenWindow("interface\\seAutoLC\\seAutoLC.ini", "seAutoLC")
RegisterEvent("CUSTOM_DATA_LOADED", function() if arg0 == "Role" then seOption.RegMenu(seAutoLC.GetMenu) end end)
