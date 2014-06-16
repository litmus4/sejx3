ChatPanel_Base_ctor = ChatPanel_Base_ctor or ChatPanel_Base.ctor

function ChatPanel_Base:ctor(nIndex, szName, nBufferSize, nMainGroupIndex, msg, Anchor, tOffMsg)
	ChatPanel_Base_ctor(self, nIndex, szName, nBufferSize, nMainGroupIndex, msg, Anchor, tOffMsg)
	if szName == g_tStrings.FIGHT_CHANNEL then
		self.Data.nBufferSize = nBufferSize * 6
	end
end

