local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seSmartCombatLog] " .. table.concat(a, "\t").. "\n" )
end

seSmartCombatLog = {
	tAppendFuncList = {},
	panel = nil,
	bOn = true,
}

local _NewChatPanel = NewChatPanel

NewChatPanel = function(szName, nCount, ...)
	local t = _NewChatPanel(szName, nCount, ...)
	if szName == "Õ½¶·" then
		seSmartCombatLog.panel = t
		local _AppendMsg = t.AppendMsg	
		t.AppendMsg = function(self, szMsg, nFont, bRich, r, g, b)
			if seSmartCombatLog.bOn then
				if #seSmartCombatLog.tAppendFuncList >= nCount then
					table.remove(seSmartCombatLog.tAppendFuncList, 1)
				end
				table.insert(seSmartCombatLog.tAppendFuncList, function() _AppendMsg(self, szMsg, nFont, bRich, r, g, b) end )
			else
				_AppendMsg(self, szMsg, nFont, bRich, r, g, b)
			end
		end
	end
	return t
end

local _ChatPanel_Base_SelMgTitle = ChatPanel_Base_SelMgTitle

ChatPanel_Base_SelMgTitle = function(nIndex)
	_ChatPanel_Base_SelMgTitle(nIndex)
	if seSmartCombatLog.panel.Data.nMainGroupIndex == nIndex then
		FreshCombatLog()
		seSmartCombatLog.bOn = false
	else
		seSmartCombatLog.bOn = true
	end
end

function FreshCombatLog()
	while(#seSmartCombatLog.tAppendFuncList > 0) do
		local func = table.remove(seSmartCombatLog.tAppendFuncList, 1)
		func()
	end
end

function ForTest(n)
	arg0 = "UI_OME_SKILL_HIT_LOG"
	arg1 = GetClientPlayer().dwID
	arg2 = arg1
	arg3 = 1
	arg4 = 537
	arg5 = 5
	local nStartTime = GetTickCount()
	for i=1, n do
		FireEvent("SYS_MSG")
	end
	OutputMessage("MSG_SYS", "Time: " .. (GetTickCount() - nStartTime) .. "\n" )
end
