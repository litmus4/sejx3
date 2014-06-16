local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seSimpleCombatLog] " .. table.concat(a, "\t").. "\n" )
end

local function GetCharacterTipInfo(dwCharacter)
	local Player = GetClientPlayer()
    local szCharacter = g_tStrings.STR_NAME_UNKNOWN;
    
    if IsPlayer(dwCharacter) then
		Character = GetPlayer(dwCharacter);
	else
		Character = GetNpc(dwCharacter);
	end
    if not Character then
		return szCharacter;
	end
    
    local szMidString = g_tStrings.STR_PET_SKILL_LOG
	if (dwCharacter == Player.dwID) then
		szCharacter = g_tStrings.STR_NAME_YOU;
	elseif not IsPlayer(dwCharacter) and Character.dwEmployer ~= 0  then -- is Pet
        if (Character.dwEmployer == Player.dwID) then
            szCharacter = g_tStrings.STR_NAME_YOU..szMidString..Character.szName;
        else
            local Employer = GetPlayer(Character.dwEmployer)
            if Employer then
                szCharacter = Employer.szName..szMidString..Character.szName
            else
                szCharacter = g_tStrings.STR_SOME_BODY..szMidString..Character.szName
            end
        end
    else
        szCharacter = Character.szName;
	end
    return szCharacter	
end

local function GetCommonCTime()
	local time = TimeToDate(GetCurrentTime())
	local szTime = string.format("%02d:%02d:%02d", time.hour, time.minute, time.second)
	return	"<text>text="..EncodeComponentsString("[").."font=10 r=255 g=255 b=255 </text>"
			.."<text>text="..EncodeComponentsString(szTime).." font=10 r=0 g=255 b=255 </text>"
			.."<text>text="..EncodeComponentsString("] ").."font=10 r=255 g=255 b=255 </text>"
end

local function ReplaceSeFont(szStr, szFont)
	local szResult = string.gsub(szStr, "seFont", seSimpleCombatLog.FONT)
	return string.gsub(szResult, "seTime", GetCommonCTime())
end

local function GetSchoolFont(szMsgType, dwID)
	local dwForceID = nil
	local player = GetClientPlayer()
	if dwID == player.dwID then
		dwForceID = player.dwForceID
	elseif IsParty(dwID, player.dwID) then
		local tMemberInfo = GetClientTeam().GetMemberInfo(dwID)
		if tMemberInfo then
			dwForceID = tMemberInfo.dwForceID
		end
	elseif IsPlayer(dwID) then
		local targ = GetPlayer(dwID)
		if targ then
			dwForceID = targ.dwForceID
		end
	end
	if dwForceID then
		return GetMsgFontString(szMsgType,  g_tIdentityColor[dwForceID])
	else
		return GetMsgFontString(szMsgType, { r = 255, g = 0, b = 0 })
	end
end

local function GetCommonText(szStr)
	return "<text>text="..EncodeComponentsString(szStr).." seFont </text>"
end

local function GetCommonColorText(szStr, r, g, b)
	return "<text>text="..EncodeComponentsString(szStr).." font=10 r="..r.." g="..g.." b="..b.." </text>"
end

local function GetNameLink(dwId, szMsgType)
	local szName = GlobalEventHandler.GetCharacterTipInfo(dwId)
	return "<text>text="..EncodeComponentsString(szName)..GetSchoolFont(szMsgType, dwId).."</text>"
end

local function GetSkillLink(dwSkillId, dwSkillLv)
	return "<text>text="..EncodeComponentsString(Table_GetSkillName(dwSkillId, dwSkillLv))..seSimpleCombatLog.FONT_SKILL.."</text>"
end

local function GetBuffLink(dwBuffId, dwBuffLv)
	return "<text>text="..EncodeComponentsString(Table_GetBuffName(dwBuffId, dwBuffLv))..seSimpleCombatLog.FONT_BUFF.."</text>"
end

local function GetDeBuffLink(dwBuffId, dwBuffLv)
	return "<text>text="..EncodeComponentsString(Table_GetBuffName(dwBuffId, dwBuffLv))..seSimpleCombatLog.FONT_DEBUFF.."</text>"
end

local function GetRespondLink(szStr)
	return "<text>text="..EncodeComponentsString(szStr)..seSimpleCombatLog.FONT_RESPOND.."</text>"
end

local function GetDamageLink(TYPE, nValue)
	return FormatString(seSimpleCombatLog.SKILL_DAMAGE, seSimpleCombatLog.ColorDamage[TYPE], GetCommonText(nValue))
end

GlobalEventHandler.GetCharacterTipInfo = GlobalEventHandler.GetCharacterTipInfo or GetCharacterTipInfo

seSimpleCombatLog = {
	
	FONT			=	" font=10	r=255	g=255	b=255 ",
	FONT_SKILL		=	" font=10	r=255	g=255	b=0 ",
	FONT_BUFF		=	" font=10	r=0		g=255	b=0 ",
	FONT_DEBUFF		=	" font=10	r=0		g=255	b=255 ",
	FONT_RESPOND	=	" font=10	r=255	g=0		b=0 ",
	ColorDamage		=	{
		[SKILL_RESULT_TYPE.PHYSICS_DAMAGE]			= "<text>text="..EncodeComponentsString("外").." font=10 r=255 g=255 b=255 </text>",
		[SKILL_RESULT_TYPE.SOLAR_MAGIC_DAMAGE]		= "<text>text="..EncodeComponentsString("阳").." font=10 r=255 g=128 b=0 </text>",
		[SKILL_RESULT_TYPE.NEUTRAL_MAGIC_DAMAGE] 	= "<text>text="..EncodeComponentsString("混").." font=10 r=0 g=128 b=192 </text>",
		[SKILL_RESULT_TYPE.LUNAR_MAGIC_DAMAGE] 		= "<text>text="..EncodeComponentsString("阴").." font=10 r=128 g=0 b=255 </text>",
		[SKILL_RESULT_TYPE.POISON_DAMAGE] 			= "<text>text="..EncodeComponentsString("毒").." font=10 r=0 g=128 b=0 </text>",
		[SKILL_RESULT_TYPE.TRANSFER_LIFE]			= "<text>text="..EncodeComponentsString("血").." font=10 r=255 g=128 b=128 </text>",
		[SKILL_RESULT_TYPE.TRANSFER_MANA]			= "<text>text="..EncodeComponentsString("内").." font=10 r=0 g=128 b=255 </text>",
		
	},

	SKILL_DAMAGE				=	""	
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>",

	SKILL_DAMAGE_LOG			=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" ").." seFont </text>"
	.."<D2>"	--critical
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"    
	.."<D3>"	--target
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D4>"	--DAMAGE
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	SKILL_EFFECT_DAMAGE_LOG		=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" ").." seFont </text>"
	.."<D2>"	--critical
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"     
	.."<D3>"	--target
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D4>"	--DAMAGE
	.."<text>text="..EncodeComponentsString("（过量 ").." seFont </text>"
	.."<D5>"	--OVER
	.."<text>text="..EncodeComponentsString("）\n").." seFont </text>",

	SKILL_THERAPY_LOG			=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" ").." seFont </text>"
	.."<D2>"	--critical
	.."<text>text="..EncodeComponentsString("治疗 [").." seFont </text>"
	.."<D3>"	--target
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D4>"	--DAMAGE
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	SKILL_EFFECT_THERAPY_LOG	=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" ").." seFont </text>"
	.."<D2>"	--critical
	.."<text>text="..EncodeComponentsString("治疗 [").." seFont </text>"
	.."<D3>"	--target
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D4>"	--DAMAGE
	.."<text>text="..EncodeComponentsString("（过量 ").." seFont </text>"
	.."<D5>"	--OVER
	.."<text>text="..EncodeComponentsString("）\n").." seFont </text>",

	
	STR_SKILL_STEAL_LIFE_LOG_MSG	=		"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("吸血").." font=10 r=255 g=255 b=0 </text>"
	.."<text>text="..EncodeComponentsString(" [").." seFont </text>"
	.."<D1>"	--target
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D2>"	--HP
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	STR_SKILL_DAMAGE_ABSORB_LOG_MSG	=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" 被 [").." seFont </text>"
	.."<D2>"	--target
	.."<text>text="..EncodeComponentsString("] 化解 ").." seFont </text>"
	.."<D3>"	--DAMAGE
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	STR_SKILL_DAMAGE_SHIELD_LOG_MSG	=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" 被 [").." seFont </text>"
	.."<D2>"	--target
	.."<text>text="..EncodeComponentsString("] 抵消 ").." seFont </text>"
	.."<D3>"	--DAMAGE
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	STR_SKILL_DAMAGE_PARRY_LOG_MSG	=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" 被 [").." seFont </text>"
	.."<D2>"	--target
	.."<text>text="..EncodeComponentsString("] 拆招 ").." seFont </text>"
	.."<D3>"	--DAMAGE
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	STR_SKILL_DAMAGE_INSIGHT_LOG_MSG	=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" 被 [").." seFont </text>"
	.."<D2>"	--target
	.."<text>text="..EncodeComponentsString("] 识破 ").." seFont </text>"
	.."<D3>"	--DAMAGE
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	STR_SKILL_BLOCK_LOG_MSG		=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" 被 [").." seFont </text>"
	.."<D2>"	--target
	.."<text>text="..EncodeComponentsString("] 抵御 [").." seFont </text>"
	.."<D3>"	--TYPE
	.."<text>text="..EncodeComponentsString("]\n").." seFont </text>",

	STR_SKILL_SHIELD_LOG_MSG	=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" 对 [").." seFont </text>"
	.."<D2>"	--target
	.."<text>text="..EncodeComponentsString("] 无效\n").." seFont </text>",

	STR_SKILL_MISS_LOG_MSG		=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" [").." seFont </text>"
	.."<D2>"	--target
	.."<text>text="..EncodeComponentsString("] 偏离\n").." seFont </text>",

	STR_SKILL_DODGE_LOG_MSG		=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" 被 [").." seFont </text>"
	.."<D2>"	--target
	.."<text>text="..EncodeComponentsString("] 闪躲\n").." seFont </text>",

	STR_SKILL_HIT_LOG_MSG		=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" 命中 [").." seFont </text>"
	.."<D2>"	--target
	.."<text>text="..EncodeComponentsString("]\n").." seFont </text>",

	STR_YOU_GET_SOME_EFFECT_MSG =	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("++ ").." font=10 r=0 g=192 b=0 </text>"
	.."<D1>"	--buff/debuff,
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	STR_YOU_LOSE_SOME_EFFECT_MSG = "seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("-- ").." font=10 r=0 g=192 b=0 </text>"
	.."<D1>"	--buff/debuff,
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	STR_BUFF_IMMUNITY_LOG_MSG = "seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"
	.."<text>text="..EncodeComponentsString("] 免疫 ").." seFont </text>"
	.."<D1>"
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",
	
	STR_SKILL_DAMAGE_TRANSFER_LOG_MSG =	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D1>"	--skill
	.."<text>text="..EncodeComponentsString(" 吸 ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"    
	.."<D2>"	--target
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"    
	.."<D3>"	--hp/mp
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D4>"	--DAMAGE
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	STR_SKILL_COMMON_DAMAGE_LOG_MSG		=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("损 ").." font=10 r=255 g=0 b=0 </text>"
	.."<D1>"	--损失
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	STR_SKILL_COMMON_THERAPY_LOG_MSG	=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--caster
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("得 ").." font=10 r=0 g=255 b=0 </text>"
	.."<D1>"	--获得
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",

	STR_MSG_BE_HURT = "seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--szName
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("重伤\n").." font=10 r=255 g=0 b=0 </text>",

	STR_MSG_HURT_PEOPLE = "seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--killer
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("打伤 ").." font=10 r=255 g=0 b=0 </text>"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D1>"	--szName
	.."<text>text="..EncodeComponentsString("]\n").." seFont </text>",

	STR_MSG_BE_KILLED = "seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--szName
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("重伤\n").." font=10 r=255 g=0 b=0 </text>",

	STR_MSG_KILLED_PEOPLE = "seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"	--killer
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("打伤 ").." font=10 r=255 g=0 b=0 </text>"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D1>"	--szName
	.."<text>text="..EncodeComponentsString("]\n").." seFont </text>",
	
	
	STR_SKILL_CAST_LOG			=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"
	.."<text>text="..EncodeComponentsString("] 运功 ").." seFont </text>"
	.."<D1>"
	.."<text>text="..EncodeComponentsString("".."\n").." seFont </text>",

	STR_SKILL_CAST_RESPOND_LOG	=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"
	.."<text>text="..EncodeComponentsString("] 释放 ").." seFont </text>"
	.."<D1>"
	.."<text>text="..EncodeComponentsString(" 失败 [").." seFont </text>"
	.."<D2>"
	.."<text>text="..EncodeComponentsString("]".."\n").." seFont </text>",

	STR_SKILL_REFLECTIED_DAMAGE_LOG_MSG	=	"seTime"
	.."<text>text="..EncodeComponentsString("[").." seFont </text>"
	.."<D0>"
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<text>text="..EncodeComponentsString("弹").." font=10 r=255 g=128 b=128 </text>"
	.."<text>text="..EncodeComponentsString(" [").." seFont </text>"
	.."<D1>"
	.."<text>text="..EncodeComponentsString("] ").." seFont </text>"
	.."<D2>"
	.."<text>text="..EncodeComponentsString("\n").." seFont </text>",
}

function GlobalEventHandler.OnSkillCast(dwCaster, dwSkillID, dwLevel)
	local caster = nil
	if IsPlayer(dwCaster) then
		caster = GetPlayer(dwCaster)
	else
		caster = GetNpc(dwCaster)
	end
	local ClientPlayer = GetClientPlayer()
	if not ClientPlayer then
		return
	end
	local szChannel = GlobalEventHandler.GetChannelOnSkillCast(dwCaster)
	local szFormat = ReplaceSeFont(seSimpleCombatLog.STR_SKILL_CAST_LOG, GetMsgFontString(szChannel))
	local szMsg = FormatString(szFormat, GetNameLink(dwCaster, szChannel), GetSkillLink(dwSkillID, dwLevel))
	OutputMessage(szChannel, szMsg, true)
end

function GlobalEventHandler.OnSkillCastRespond(dwCaster, dwSkillID, dwLevel, nRespond)
	local caster = nil
	if IsPlayer(dwCaster) then
		caster = GetPlayer(dwCaster)
	else
		caster = GetNpc(dwCaster)
	end

	local ClientPlayer = GetClientPlayer()
	if not ClientPlayer then
		return
	end

	szRespond = GlobalEventHandler.GetSkillRespondText(nRespond)

	local szChannel = GlobalEventHandler.GetChannelOnSkillCastRespond(dwCaster)
	local szFormat = ReplaceSeFont(seSimpleCombatLog.STR_SKILL_CAST_RESPOND_LOG, GetMsgFontString(szChannel))
	local szMsg = FormatString(szFormat, GetNameLink(dwCaster, szChannel), GetSkillLink(dwSkillID, dwLevel), GetRespondLink(szRespond))

	OutputMessage(szChannel, szMsg, true)
end

function GlobalEventHandler.OnSkillEffectLog(dwCaster, dwTarget, bReact, nEffectType, dwID, dwLevel, bCriticalStrike, nCount, tResult)
	if nCount <= 2 then
		return
	end

	local nTotal = 0
	local szDamage = ""
	local nValue = tResult[SKILL_RESULT_TYPE.PHYSICS_DAMAGE]
	if nValue and nValue > 0 then
		if szDamage ~= "" then
			szDamage = szDamage..GetCommonText(" ")
		end	
		nTotal = nTotal + nValue
		szDamage = szDamage..GetDamageLink(SKILL_RESULT_TYPE.PHYSICS_DAMAGE, nValue)
	end

	nValue = tResult[SKILL_RESULT_TYPE.SOLAR_MAGIC_DAMAGE]
	if nValue and nValue > 0 then
		if szDamage ~= "" then
			szDamage = szDamage..GetCommonText(" ")
		end	
		nTotal = nTotal + nValue
		szDamage = szDamage..GetDamageLink(SKILL_RESULT_TYPE.SOLAR_MAGIC_DAMAGE, nValue)
	end

	nValue = tResult[SKILL_RESULT_TYPE.NEUTRAL_MAGIC_DAMAGE]
	if nValue and nValue > 0 then
		if szDamage ~= "" then
			szDamage = szDamage..GetCommonText(" ")
		end	
		nTotal = nTotal + nValue
		szDamage = szDamage..GetDamageLink(SKILL_RESULT_TYPE.NEUTRAL_MAGIC_DAMAGE, nValue)
	end

	nValue = tResult[SKILL_RESULT_TYPE.LUNAR_MAGIC_DAMAGE]
	if nValue and nValue > 0 then
		if szDamage ~= "" then
			szDamage = szDamage..GetCommonText(" ")
		end	
		nTotal = nTotal + nValue
		szDamage = szDamage..GetDamageLink(SKILL_RESULT_TYPE.LUNAR_MAGIC_DAMAGE, nValue)
	end

	nValue = tResult[SKILL_RESULT_TYPE.POISON_DAMAGE]
	if nValue and nValue > 0 then
		if szDamage ~= "" then
			szDamage = szDamage..GetCommonText(" ")
		end	
		nTotal = nTotal + nValue
		szDamage = szDamage..GetDamageLink(SKILL_RESULT_TYPE.POISON_DAMAGE, nValue)
	end

	if szDamage ~= "" then
		GlobalEventHandler.OnSkillDamageLog(dwCaster, dwTarget, bReact, nEffectType, dwID, dwLevel, bCriticalStrike, szDamage, tResult, nTotal)
	end

	nValue = tResult[SKILL_RESULT_TYPE.THERAPY]
	if nValue and nValue > 0 then
		GlobalEventHandler.OnSkillTherapyLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, bCriticalStrike, tResult)
	end

	nValue = tResult[SKILL_RESULT_TYPE.REFLECTIED_DAMAGE]
	if nValue and nValue > 0 then
		GlobalEventHandler.OnSkillReflectiedDamageLog(dwCaster, dwTarget, nValue);
	end

	nValue = tResult[SKILL_RESULT_TYPE.STEAL_LIFE]
	if nValue and nValue > 0 then
		GlobalEventHandler.OnSkillStealLifeLog(dwCaster, dwTarget, nValue);
	end

	nValue = tResult[SKILL_RESULT_TYPE.ABSORB_DAMAGE]
	if nValue and nValue > 0 then
		GlobalEventHandler.OnSkillDamageAbsorbLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, nValue);
	end

	nValue = tResult[SKILL_RESULT_TYPE.SHIELD_DAMAGE]
	if nValue and nValue > 0 then
		GlobalEventHandler.OnSkillDamageShieldLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, nValue);
	end

	nValue = tResult[SKILL_RESULT_TYPE.PARRY_DAMAGE]
	if nValue and nValue > 0 then
		GlobalEventHandler.OnSkillDamageParryLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, nValue);
	end

	nValue = tResult[SKILL_RESULT_TYPE.INSIGHT_DAMAGE]
	if nValue and nValue > 0 then
		GlobalEventHandler.OnSkillDamageInsightLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, nValue);
	end	

	nValue = tResult[SKILL_RESULT_TYPE.TRANSFER_LIFE]
	if nValue and nValue > 0 then
		GlobalEventHandler.OnSkillDamageTransferLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, nValue, SKILL_RESULT_TYPE.TRANSFER_LIFE)
	end	

	nValue = tResult[SKILL_RESULT_TYPE.TRANSFER_MANA]
	if nValue and nValue > 0 then
		GlobalEventHandler.OnSkillDamageTransferLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, nValue, SKILL_RESULT_TYPE.TRANSFER_MANA)
	end	
end

function GlobalEventHandler.OnSkillDamageLog(dwCaster, dwTarget, bReact, nType, dwID, nLevel, bCriticalStrike, szDamage, tResult, nTotalDamage)
	local Caster = nil;
	if IsPlayer(dwCaster) then
		Caster = GetPlayer(dwCaster);
	else
		Caster = GetNpc(dwCaster);
	end

	if not Caster then
		return;
	end

	local Target = nil;
	if IsPlayer(dwTarget) then
		Target = GetPlayer(dwTarget)
	else
		Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local szChannel = GlobalEventHandler.GetChannelOnDamage(dwCaster, dwTarget)

	local szCasterName = GetNameLink(dwCaster, szChannel)
	local szTargetName = GetNameLink(dwTarget, szChannel)

	local szSkillName = nil;
	if nType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, nLevel);
	elseif nType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetDeBuffLink(dwID, nLevel);
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL);
	end

	local szCriticalStrike = "";

	if bCriticalStrike then
		szCriticalStrike = GetCommonText("(会心) ");
	end

	local nEffectDamage = tResult[SKILL_RESULT_TYPE.EFFECTIVE_DAMAGE] or 0

	local szMsg
	if nTotalDamage == nEffectDamage then
		szMsg = FormatString(seSimpleCombatLog.SKILL_DAMAGE_LOG,
		szCasterName, szSkillName, szCriticalStrike, szTargetName, szDamage)
	else
		szMsg = FormatString(seSimpleCombatLog.SKILL_EFFECT_DAMAGE_LOG,
		szCasterName, szSkillName, szCriticalStrike, szTargetName, szDamage, GetCommonText(""..(nTotalDamage - nEffectDamage)))
	end
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))
	OutputMessage(szChannel, szMsg, true);
end

function GlobalEventHandler.OnSkillTherapyLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, bCriticalStrike, tResult)
	local Caster = nil;
	if IsPlayer(dwCaster) then
		Caster = GetPlayer(dwCaster);
	else
		Caster = GetNpc(dwCaster);
	end

	if not Caster then
		return;
	end

	local Target = nil;
	if IsPlayer(dwTarget) then
		Target = GetPlayer(dwTarget)
	else
		Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local ClientPlayer = GetClientPlayer()
	if not ClientPlayer then
		return
	end

	local szChannel = GlobalEventHandler.GetChannelOnTherapy(dwCaster, dwTarget)

	local szCasterName = GetNameLink(dwCaster, szChannel)
	local szTargetName = GetNameLink(dwTarget, szChannel)

	local szSkillName = nil;

	if nEffectType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, dwLevel)
	elseif nEffectType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetBuffLink(dwID, dwLevel)
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL)
	end

	local szCriticalStrike = "";

	if bCriticalStrike then
		szCriticalStrike = GetCommonText("(会心) ");
	end

	local nTherapy = tResult[SKILL_RESULT_TYPE.THERAPY] or 0
	local nEffectTherapy = tResult[SKILL_RESULT_TYPE.EFFECTIVE_THERAPY] or 0

	local szMsg
	if nEffectTherapy == nTherapy then
		szMsg = FormatString(seSimpleCombatLog.SKILL_THERAPY_LOG,
		szCasterName, szSkillName, szCriticalStrike, szTargetName, GetCommonText(nTherapy))
	else
		szMsg = FormatString(seSimpleCombatLog.SKILL_EFFECT_THERAPY_LOG,
		szCasterName, szSkillName, szCriticalStrike, szTargetName, GetCommonText(nTherapy), GetCommonText(""..(nTherapy-nEffectTherapy)))
	end

	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))      
	OutputMessage(szChannel, szMsg, true);

end

-- 伤害被反弹
function GlobalEventHandler.OnSkillReflectiedDamageLog(dwCaster, dwTarget, nDamage)
	local ClientPlayer = GetClientPlayer()
    if not ClientPlayer then
		return;
    end

	local Caster = nil
	if IsPlayer(dwCaster) then
	    Caster = GetPlayer(dwCaster)
    else
	    Caster = GetNpc(dwCaster)
    end

	if not Caster then
		return
    end

	local Target = nil
	if IsPlayer(dwTarget) then
	    Target = GetPlayer(dwTarget)
	else
	    Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local szChannel = GlobalEventHandler.GetChannelOnDamage(dwCaster, dwTarget)
    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)
    
	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_REFLECTIED_DAMAGE_LOG_MSG, szTargetName, szCasterName, GetCommonText(nDamage))
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))    

	OutputMessage(szChannel, szMsg, true)
end

--偷取生命
function GlobalEventHandler.OnSkillStealLifeLog(dwCaster, dwTarget, nHealth)

	local ClientPlayer = GetClientPlayer()

    if not ClientPlayer then
		return;
    end

	local Caster = nil

	if IsPlayer(dwCaster) then
	    Caster = GetPlayer(dwCaster)
    else
	    Caster = GetNpc(dwCaster)
    end

	if not Caster then
		return
    end

	local Target = nil

	if IsPlayer(dwTarget) then
	    Target = GetPlayer(dwTarget)
	else
	    Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local szChannel = nil
	if dwCaster == ClientPlayer.dwID or dwTarget == ClientPlayer.dwID then
		szChannel = "MSG_SKILL_SELF_SKILL"
	else
		szChannel = "MSG_SKILL_PARTY_SKILL"
	end

    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)

	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_STEAL_LIFE_LOG_MSG, szCasterName, szTargetName, GetCommonText(nHealth))

	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))    
	OutputMessage(szChannel, szMsg, true)
end

-- 攻击被吸收
function GlobalEventHandler.OnSkillDamageAbsorbLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, nDamage)
 	local ClientPlayer = GetClientPlayer()
    if not ClientPlayer then
		return;
    end

	local Caster = nil
	if IsPlayer(dwCaster) then
	    Caster = GetPlayer(dwCaster)
    else
	    Caster = GetNpc(dwCaster)
    end

	if not Caster then
		return
    end

	local Target = nil
	if IsPlayer(dwTarget) then
	    Target = GetPlayer(dwTarget)
	else
	    Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

 	local szChannel = GlobalEventHandler.GetChannelOnDamage(dwCaster, dwTarget)

 	if szChannel == nil then
		return
 	end

    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)
    
	local szSkillName = nil;
	if nEffectType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, dwLevel);
	elseif nEffectType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetDeBuffLink(dwID, dwLevel);
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL);
	end

	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_DAMAGE_ABSORB_LOG_MSG, szCasterName, szSkillName, szTargetName, GetCommonText(nDamage))
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))   
	OutputMessage(szChannel, szMsg, true)
end

--攻击被抵消
function GlobalEventHandler.OnSkillDamageShieldLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, nDamage)
 	local ClientPlayer = GetClientPlayer()

    if not ClientPlayer then
		return;
    end

	local Caster = nil

	if IsPlayer(dwCaster) then
	    Caster = GetPlayer(dwCaster)
    else
	    Caster = GetNpc(dwCaster)
    end

	if not Caster then
		return
    end

	local Target = nil

	if IsPlayer(dwTarget) then
	    Target = GetPlayer(dwTarget)
	else
	    Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local szChannel = GlobalEventHandler.GetChannelOnDamage(dwCaster, dwTarget)

 	if szChannel == nil then
		return
 	end

    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)
    
	local szSkillName = nil;
	if nEffectType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, dwLevel);
	elseif nEffectType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetDeBuffLink(dwID, dwLevel);
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL);
	end

	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_DAMAGE_SHIELD_LOG_MSG, szCasterName, szSkillName, szTargetName, GetCommonText(nDamage))
	
	local szChannel = GlobalEventHandler.GetChannelOnDamage(dwCaster, dwTarget)
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))   
	OutputMessage(szChannel, szMsg, true)
end

function GlobalEventHandler.OnSkillDamageParryLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, nDamage)
 	local ClientPlayer = GetClientPlayer()

    if not ClientPlayer then
		return;
    end

	local Caster = nil

	if IsPlayer(dwCaster) then
	    Caster = GetPlayer(dwCaster)
    else
	    Caster = GetNpc(dwCaster)
    end

	if not Caster then
		return
    end

	local Target = nil

	if IsPlayer(dwTarget) then
	    Target = GetPlayer(dwTarget)
	else
	    Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end
	local szChannel = GlobalEventHandler.GetChannelOnDamage(dwCaster, dwTarget)

 	if szChannel == nil then
		return
 	end

    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)
    
	local szSkillName = nil;
	if nEffectType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, dwLevel);
	elseif nEffectType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetDeBuffLink(dwID, dwLevel);
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL);
	end

	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_DAMAGE_PARRY_LOG_MSG, szCasterName, szSkillName, szTargetName, GetCommonText(nDamage))
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))   
	OutputMessage(szChannel, szMsg, true)
end


--技能被识破
function GlobalEventHandler.OnSkillDamageInsightLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, nDamage)
 	local ClientPlayer = GetClientPlayer()

    if not ClientPlayer then
		return;
    end

	local Caster = nil

	if IsPlayer(dwCaster) then
	    Caster = GetPlayer(dwCaster)
    else
	    Caster = GetNpc(dwCaster)
    end

	if not Caster then
		return
    end

	local Target = nil

	if IsPlayer(dwTarget) then
	    Target = GetPlayer(dwTarget)
	else
	    Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local szChannel = GlobalEventHandler.GetChannelOnDamage(dwCaster, dwTarget)

 	if szChannel == nil then
		return
 	end

    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)
    
	local szSkillName = nil;
	if nEffectType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, dwLevel);
	elseif nEffectType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetDeBuffLink(dwID, dwLevel);
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL);
	end
	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_DAMAGE_INSIGHT_LOG_MSG, szCasterName, szSkillName, szTargetName, GetCommonText(nDamage))
	local szChannel = GlobalEventHandler.GetChannelOnDamage(dwCaster, dwTarget)
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))   
	OutputMessage(szChannel, szMsg, true)
end

--技能被格挡
function GlobalEventHandler.OnSkillBlockLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, dwDamageType)
    local ClientPlayer = nil;
	local Caster = nil
	local Target = nil

	ClientPlayer = GetClientPlayer()
    if ClientPlayer == nil then
    end

	if IsPlayer(dwCaster) then
	    Caster = GetPlayer(dwCaster)
    else
	    Caster = GetNpc(dwCaster)
    end

	if not Caster then
		return
    end

	if IsPlayer(dwTarget) then
	    Target = GetPlayer(dwTarget)
	else
	    Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local szChannel = GlobalEventHandler.GetChannelOnBlock(dwCaster, dwTarget)

 	if szChannel == nil then
		return
 	end

    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)
    
	local szSkillName = nil;
	if nEffectType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, dwLevel);
	elseif nEffectType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetDeBuffLink(dwID, dwLevel);
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL);
	end

	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_BLOCK_LOG_MSG,
		szCasterName, szSkillName, szTargetName, seSimpleCombatLog.ColorDamage[dwDamageType])
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))   
	OutputMessage(szChannel, szMsg, true)
end

function GlobalEventHandler.OnSkillShieldLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel)
	local Caster = nil;

	if IsPlayer(dwCaster) then
		Caster = GetPlayer(dwCaster);
	else
		Caster = GetNpc(dwCaster);
	end

	if not Caster then
		return;
	end

	local Target = nil;

	if IsPlayer(dwTarget) then
		Target = GetPlayer(dwTarget)
	else
		Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local ClientPlayer = GetClientPlayer()
	if not ClientPlayer then
		return
	end

	local szChannel = GlobalEventHandler.GetChannelOnShield(dwCaster, dwTarget)

 	if szChannel == nil then
		return
 	end

    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)
    
	local szSkillName = nil;
	if nEffectType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, dwLevel);
	elseif nEffectType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetDeBuffLink(dwID, dwLevel);
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL);
	end

	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_SHIELD_LOG_MSG, szCasterName, szSkillName, szTargetName)
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))  
	OutputMessage(szChannel, szMsg, true)
end


function GlobalEventHandler.OnSkillMissLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel)
	--print("未命中")
	local Caster = nil;
	if IsPlayer(dwCaster) then
		Caster = GetPlayer(dwCaster);
	else
		Caster = GetNpc(dwCaster);
	end

	if not Caster then
		return;
	end

	local Target = nil;
	if IsPlayer(dwTarget) then
		Target = GetPlayer(dwTarget)
	else
		Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local ClientPlayer = GetClientPlayer()
	if not ClientPlayer then
		return
	end

    local szChannel = GlobalEventHandler.GetChannelOnMiss(dwCaster, dwTarget)

 	if szChannel == nil then
		return
 	end

    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)
    
	local szSkillName = nil;
	if nEffectType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, dwLevel);
	elseif nEffectType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetDeBuffLink(dwID, dwLevel);
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL);
	end

	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_MISS_LOG_MSG, szCasterName, szSkillName, szTargetName)
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))  
	OutputMessage(szChannel, szMsg, true)
end

function GlobalEventHandler.OnSkillDodgeLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel)
	local Caster = nil;
	if IsPlayer(dwCaster) then
		Caster = GetPlayer(dwCaster);
	else
		Caster = GetNpc(dwCaster);
	end

	if not Caster then
		return;
	end

	local Target = nil;
	if IsPlayer(dwTarget) then
		Target = GetPlayer(dwTarget)
	else
		Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local ClientPlayer = GetClientPlayer()
	if not ClientPlayer then
		return
	end

    local szChannel = GlobalEventHandler.GetChannelOnDodge(dwCaster, dwTarget)

 	if szChannel == nil then
		return
 	end

    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)
    
	local szSkillName = nil;
	if nEffectType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, dwLevel);
	elseif nEffectType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetDeBuffLink(dwID, dwLevel);
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL);
	end

	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_DODGE_LOG_MSG, szCasterName, szSkillName, szTargetName)
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))  
	OutputMessage(szChannel, szMsg, true);

end

---------------------------------- 技能命中目标 -----------------------------------------------------------------

function GlobalEventHandler.OnSkillHitLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel)
	--print("命中")
	local Caster = nil;
	if IsPlayer(dwCaster) then
		Caster = GetPlayer(dwCaster);
	else
		Caster = GetNpc(dwCaster);
	end

	if not Caster then
		return;
	end

	local Target = nil;
	if IsPlayer(dwTarget) then
		Target = GetPlayer(dwTarget)
	else
		Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local ClientPlayer = GetClientPlayer()
	if not ClientPlayer then
		return
	end

    local szChannel = GlobalEventHandler.GetChannelOnHit(dwCaster, dwTarget)

 	if szChannel == nil then
		return
 	end

    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)
    
	local szSkillName = nil;
	if nEffectType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, dwLevel);
	elseif nEffectType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetDeBuffLink(dwID, dwLevel);
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL);
	end

	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_HIT_LOG_MSG, szCasterName, szSkillName, szTargetName)
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))  
	OutputMessage(szChannel, szMsg, true)

end


function GlobalEventHandler.OnBuffLog(dwTarget, bCanCancel, dwID, bAddOrDel, nLevel)
	if not Table_BuffIsVisible(dwID, nLevel) then
		return
	end

	local ClientPlayer = nil
	local Target = nil

	ClientPlayer = GetClientPlayer()
    if ClientPlayer == nil then
		return
    end

	if IsPlayer(dwTarget) then
	    Target = GetPlayer(dwTarget)
	else
	    Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local szChannel = GlobalEventHandler.GetChannelOnBuff(dwTarget, bCanCancel)
	if not szChannel then
		return
	end
    local szTargetName = GetNameLink(dwTarget, szChannel)
	local szBuffName = nil
	if bCanCancel then
		szBuffName = GetBuffLink(dwID, nLevel)
	else
		szBuffName = GetDeBuffLink(dwID, nLevel)
	end

	local szMsg = ""
	if bAddOrDel ~= 0 then
	   szMsg = FormatString(seSimpleCombatLog.STR_YOU_GET_SOME_EFFECT_MSG, szTargetName, szBuffName)
    else
	   szMsg = FormatString(seSimpleCombatLog.STR_YOU_LOSE_SOME_EFFECT_MSG,szTargetName, szBuffName)
	end
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))
	OutputMessage(szChannel, szMsg, true)
end

--STR_BUFF_IMMUNITY_LOG_MSG
function GlobalEventHandler.OnBuffImmunity(dwTarget, bCanCancel, dwID, nLevel)

	local ClientPlayer = nil
	local Target = nil

	ClientPlayer = GetClientPlayer()
    if ClientPlayer == nil then
		return
    end

	if IsPlayer(dwTarget) then
	    Target = GetPlayer(dwTarget)
	else
	    Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end
	
	local szChannel = GlobalEventHandler.GetChannelOnBuff(dwTarget, bCanCancel)
	if not szChannel then
		return
	end

    local szTargetName = GetNameLink(dwTarget, szChannel)
	local szBuffName = nil
	if bCanCancel then
		szBuffName = GetBuffLink(dwID, nLevel)
	else
		szBuffName = GetDeBuffLink(dwID, nLevel)
	end

	local szMsg = ""

	szMsg = FormatString(seSimpleCombatLog.STR_BUFF_IMMUNITY_LOG_MSG, szTargetName, szBuffName)

	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))
	OutputMessage(szChannel, szMsg, true)
end

--STR_SKILL_DAMAGE_TRANSFER_LOG_MSG
function GlobalEventHandler.OnSkillDamageTransferLog(dwCaster, dwTarget, nEffectType, dwID, dwLevel, nDamage, dwTransferType)
 	local ClientPlayer = GetClientPlayer()

    if not ClientPlayer then
		return;
    end

	local Caster = nil

	if IsPlayer(dwCaster) then
	    Caster = GetPlayer(dwCaster)
    else
	    Caster = GetNpc(dwCaster)
    end

	if not Caster then
		return
    end

	local Target = nil

	if IsPlayer(dwTarget) then
	    Target = GetPlayer(dwTarget)
	else
	    Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local szCasterName = ""
	local szTargetName = ""

	if (dwCaster == ClientPlayer.dwID) then
		szCasterName = g_tStrings.STR_NAME_YOU
	else
		szCasterName = Caster.szName;
	end

	if (dwTarget == ClientPlayer.dwID) then
		szTargetName = g_tStrings.STR_NAME_YOU;
	else
		szTargetName = Target.szName;
	end

	local szChannel = GlobalEventHandler.GetChannelOnDamage(dwCaster, dwTarget)
 	if szChannel == nil then
		return
 	end

    local szCasterName = GetNameLink(dwCaster, szChannel)
    local szTargetName = GetNameLink(dwTarget, szChannel)
    
	local szSkillName = nil;
	if nEffectType == SKILL_EFFECT_TYPE.SKILL then
		szSkillName = GetSkillLink(dwID, dwLevel);
	elseif nEffectType == SKILL_EFFECT_TYPE.BUFF then
		szSkillName = GetDeBuffLink(dwID, dwLevel);
	end

	if not szSkillName then
		szSkillName = GetCommonText(g_tStrings.STR_UNKOWN_SKILL);
	end
	
	local szMsg = FormatString(seSimpleCombatLog.STR_SKILL_DAMAGE_TRANSFER_LOG_MSG, szCasterName, szSkillName,
		 szTargetName, seSimpleCombatLog.ColorDamage[dwTransferType], GetCommonText(nDamage))
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))
	OutputMessage(szChannel, szMsg, true)
end

--STR_SKILL_COMMON_HEALTH_LOG_MSG
function GlobalEventHandler.OnCommonHealthLog(dwTarget, nDeltaLife)
	local Target = nil;
	if IsPlayer(dwTarget) then
		Target = GetPlayer(dwTarget)
	else
		Target = GetNpc(dwTarget)
	end

	if not Target then
		return
	end

	local ClientPlayer = GetClientPlayer();
	if not ClientPlayer then
		return
	end

	local szMsg = nil;
	local szChannel = nil
	if nDeltaLife < 0 then
		szChannel = GlobalEventHandler.GetChannelOnCommonHealth(dwTarget)
		local szTargetName = GetNameLink(dwTarget, szChannel)
		szMsg = FormatString(seSimpleCombatLog.STR_SKILL_COMMON_DAMAGE_LOG_MSG, szTargetName, GetCommonText(""..(-nDeltaLife)))
	elseif nDeltaLife > 0 then
		szChannel = GlobalEventHandler.GetChannelOnCommonHealth(dwTarget)
		local szTargetName = GetNameLink(dwTarget, szChannel)
		szMsg = FormatString(seSimpleCombatLog.STR_SKILL_COMMON_THERAPY_LOG_MSG, szTargetName, GetCommonText(""..nDeltaLife))
	end
	szMsg = ReplaceSeFont(szMsg, GetMsgFontString(szChannel))
	OutputMessage(szChannel, szMsg, true);
end

function GlobalEventHandler.OnDeathNotify(dwID, nLeftReviveFrame, szKiller)
	local player = GetClientPlayer()
	local szChannel = "MSG_OTHER_DEATH"
	if dwID == player.dwID then
		local szFormat = ReplaceSeFont(seSimpleCombatLog.STR_MSG_BE_HURT, GetMsgFontString(szChannel))
		OutputMessage(szChannel, FormatString(szFormat, GetNameLink(dwID, szChannel)), true)
		if szKiller and szKiller ~= "" then
			local szFormat = ReplaceSeFont(seSimpleCombatLog.STR_MSG_HURT_PEOPLE, GetMsgFontString(szChannel))
			OutputMessage(szChannel, FormatString(szFormat, GetCommonColorText(szKiller, 0, 255, 128), GetNameLink(dwID, szChannel)), true)
		end
	elseif IsParty(dwID, player.dwID) then
		local szName = GetTeammateName(dwID)
		if szName and szName ~= "" then
			local szFormat = ReplaceSeFont(seSimpleCombatLog.STR_MSG_BE_HURT, GetMsgFontString(szChannel))
			OutputMessage(szChannel, FormatString(szFormat, "<text>text="..EncodeComponentsString(szName)..GetSchoolFont(szChannel, dwID).."</text>"), true)
			if szKiller and szKiller ~= "" then
				local szFormat = ReplaceSeFont(seSimpleCombatLog.STR_MSG_HURT_PEOPLE, GetMsgFontString(szChannel))
				OutputMessage(szChannel, FormatString(szFormat, GetCommonColorText(szKiller, 0, 255, 128), "<text>text="..EncodeComponentsString(szName)..GetSchoolFont(szChannel, dwID).."</text>"), true)
			end
		end
	elseif IsPlayer(dwID) then
		local targ = GetPlayer(dwID)
		if targ then
			local szFormat = ReplaceSeFont(seSimpleCombatLog.STR_MSG_BE_HURT, GetMsgFontString(szChannel))
			OutputMessage(szChannel, FormatString(szFormat, GetNameLink(dwID, szChannel)), true)
			if szKiller and szKiller ~= "" then
				local szFormat = ReplaceSeFont(seSimpleCombatLog.STR_MSG_HURT_PEOPLE, GetMsgFontString(szChannel))
				OutputMessage(szChannel, FormatString(szFormat, GetCommonColorText(szKiller, 0, 255, 128), GetNameLink(dwID, szChannel)), true)
			end
		end
	else
        local szTargetName = GetNameLink(dwID, szChannel)
		local targ = GetNpc(dwID)
		if targ then
			local szFormat = ReplaceSeFont(seSimpleCombatLog.STR_MSG_BE_KILLED, GetMsgFontString(szChannel))
			OutputMessage(szChannel, FormatString(szFormat, szTargetName), true)
			if szKiller and szKiller ~= "" then
				local szFormat = ReplaceSeFont(seSimpleCombatLog.STR_MSG_HURT_PEOPLE, GetMsgFontString(szChannel))
				OutputMessage(szChannel, FormatString(szFormat, GetCommonColorText(szKiller, 0, 255, 128), szTargetName), true)
			end
		end
	end
end

