function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seOption] " .. table.concat(a, "\t").. "\n" )
end

seOption = {
	menu_funcs = {},
	szTitals = {
		[1] = "С��",
		[2] = "С��",
		[3] = "С��",
	},
	Anchor = {s = "BOTTOMLEFT" , r = "BOTTOMLEFT" , x = 168 , y = -5},
	DefAnchor = {s = "BOTTOMLEFT" , r = "BOTTOMLEFT" , x = 168 , y = -5}
}

RegisterCustomData("seOption.Anchor")

function seOption.OnFrameCreate()
	this:RegisterEvent("CUSTOM_DATA_LOADED")
	this:RegisterEvent("CUSTOM_UI_MODE_SET_DEFAULT")
	this:RegisterEvent("UI_SCALED")
	seOption.UpdateAnchor(this)
end

function seOption.OnEvent(event)
	if event == "UI_SCALED" then
		seOption.UpdateAnchor(this)
	elseif event == "CUSTOM_DATA_LOADED" then
		seOption.UpdateAnchor(this)
	elseif event == "CUSTOM_UI_MODE_SET_DEFAULT" then
		seOption.ResetAnchor(this)
	end
end

function seOption.OnFrameDragEnd()
	this:CorrectPos()
	seOption.Anchor = GetFrameAnchor(this)
end

function seOption.ResetAnchor(frame)
	seOption.Anchor.s=seOption.DefAnchor.s
	seOption.Anchor.r=seOption.DefAnchor.r
	seOption.Anchor.x=seOption.DefAnchor.x
	seOption.Anchor.y=seOption.DefAnchor.y
	frame:SetPoint(seOption.Anchor.s,0,0,seOption.Anchor.r, seOption.Anchor.x , seOption.Anchor.y)
	frame:CorrectPos()
end

function seOption.UpdateAnchor(frame)
	frame:SetPoint(seOption.Anchor.s,0,0,seOption.Anchor.r, seOption.Anchor.x , seOption.Anchor.y)
	frame:CorrectPos()
end

function seOption.OnItemMouseEnter()
	local szTip = ""
	szTip = szTip.."<Text>text="..EncodeComponentsString(""..seOption.szTitals[math.random(1,3)].."���").." font=5 r=255 g=255 b=0</text>"
	szTip = szTip.."<Text>text="..EncodeComponentsString(" ���Ҽ����á������ק��\n").." r=255 g=255 b=0</text>"
	szTip = szTip.."<Text>text="..EncodeComponentsString("�Լ��ص���������������п�������\n").."</text>"
	local nX, nY = this:GetAbsPos()
	OutputTip(szTip, 345, {nX, nY, 0, 0})
end

function seOption.OnItemMouseLeave()
	HideTip()
end

function seOption.OnItemRButtonClick()
	--print("click")
	if this:GetName() == "Image" then
		PopupMenu(seOption.GetMenu())
	end
end

function seOption.GetMenu()
	local menu = {}
	for i=1, #seOption.menu_funcs, 1 do
		table.insert(menu, seOption.menu_funcs[i]())
	end
	table.insert(menu, {bDevide = true} )
	table.insert(menu, {szOption = "by Ҷ���ࡢ������", bCheck = true, fnAction = function() GetPopupMenu():Hide() end,})
	return menu
end

function seOption.RegMenu(func)
	table.insert(seOption.menu_funcs, func)
end

Wnd.OpenWindow("interface\\seOption\\seOption.ini", "seOption")