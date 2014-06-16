local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seEasyClothes] " .. table.concat(a, "\t").. "\n" )
end

_CharacterPanel_OnItemMouseEnter_Org = CharacterPanel.OnItemMouseEnter

--��������box���ж�alt���������¼���
function _CharacterPanel_OnItemMouseEnter()
	if this:GetType() == "Box" then
		if IsAltKeyDown() then
			PressAltOnBox(this)
		end
	end
	_CharacterPanel_OnItemMouseEnter_Org()
end

