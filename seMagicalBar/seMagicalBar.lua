local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[MagicalBar] " .. table.concat(a, "\t").. "\n" )
end

local szIniFile = "interface\\seMagicalBar\\seMagicalBar.ini"
tMigicalBars = {
	Minimalist 	=	"Interface\\seMagicalBar\\texture\\Minimalist.UITex",
	Rocks		=	"Interface\\seMagicalBar\\texture\\Rocks.UITex",
	Runes		=	"Interface\\seMagicalBar\\texture\\Runes.UITex",
	BantoBar	=	"Interface\\seMagicalBar\\texture\\BantoBar.UITex",
	Frost		=	"Interface\\seMagicalBar\\texture\\Frost.UITex",
	Healbot		=	"Interface\\seMagicalBar\\texture\\Healbot.UITex",
	LiteStep	=	"Interface\\seMagicalBar\\texture\\LiteStep.UITex",
}

local function shadowDrawRectangle(shadow, w, h, r, g, b, a, p)
	shadow:SetTriangleFan(true)
	shadow:ClearTriangleFanPoint()
	shadow:AppendTriangleFanPoint(0, 0, r, g, b, a)
	shadow:AppendTriangleFanPoint(w * p, 0, r, g, b, a)
	shadow:AppendTriangleFanPoint(w * p, h, r, g, b, a)
	shadow:AppendTriangleFanPoint(0, h, r, g, b, a)
end

MagicalBar = class()

function MagicalBar:ctor(parent, szName, uiTex, frm, w, h, r, g, b)
	self.parent = parent
	self.color = {
		r = r,
		g = g,
		b = b,
	}
	self.magicalBar = parent:AppendItemFromIni(szIniFile, "Handle_Bar", szName)
	self.shadow = self.magicalBar:Lookup("Shadow")
	self.fImage = self.magicalBar:Lookup("Texture")
	if uiTex then
		self.fImage:FromUITex(uiTex, frm)
	else
		self.fImage:FromUITex(tMigicalBars.Minimalist, 0)
	end
	local alpha = self.fImage:GetAlpha()
	shadowDrawRectangle(self.shadow, w, h, self.color.r, self.color.g, self.color.b, 255, self.fImage:GetPercentage())
	self.fImage:SetSize(w, h)
	self.magicalBar:Show()
	self.parent:FormatAllItemPos()
end

function MagicalBar:SetSize(w, h)
	local alpha = self:GetAlpha()
	shadowDrawRectangle(self.shadow, w, h, self.color.r, self.color.g, self.color.b, alpha, self:GetPercentage())
	self.fImage:SetSize(w, h)
end


function MagicalBar:SetAlpha(alpha)
	local w, h = self:GetSize()
	if alpha > 255 then
		alpha = 255
	elseif alpha < 0 then
		alpha = 0
	end
	shadowDrawRectangle(self.shadow, w, h, self.color.r, self.color.g, self.color.b, alpha, self:GetPercentage())
	self.fImage:SetAlpha(alpha)
end

function MagicalBar:SetPercentage(p)
	if p > 1 then
		p = 1
	elseif p < 0 then
		p = 0
	end
	local w, h = self:GetSize()
	local alpha = self:GetAlpha()
	shadowDrawRectangle(self.shadow, w, h, self.color.r, self.color.g, self.color.b, alpha, p)
	self.fImage:SetPercentage(p)
end

function MagicalBar:SetRelPos(x, y)
	self.magicalBar:SetRelPos(x, y)
	self.parent:FormatAllItemPos()
end

function MagicalBar:GetSize()
	return self.fImage:GetSize()
end

function MagicalBar:GetAlpha()
	return self.fImage:GetAlpha()
end

function MagicalBar:GetPercentage()
	return self.fImage:GetPercentage()
end

--Examples

Wnd.OpenWindow("interface\\seMagicalBar\\seMagicalBar.ini", "seMagicalBar")

seMagicalBarHandle = Station.Lookup("Normal/seMagicalBar"):Lookup("","")

local tSchoolColor = 
{
	[0] = { R = 255, G = 255, B = 255 },
	[1] = { R = 255, G = 111, B = 83 },
	[2] = { R = 196, G = 152, B = 255 },
	[3] = { R = 89, G = 224, B = 232 },
	[4] = { R = 255, G = 129, B = 176 },
	[5] = { R = 255, G = 178, B = 95 },
	[6] = { R = 214, G = 249, B = 93 },
}


local eX = 0
for i1, v1 in pairs(tMigicalBars) do
	local eY = 0
	for i2, v2 in pairs(tSchoolColor) do 
		local tMagicalBar = MagicalBar.new(seMagicalBarHandle, "sbMagicalBar", v1, 0, 200, 32, v2.R, v2.G, v2.B)
		tMagicalBar:SetRelPos(eX * 205, eY * 35)
		tMagicalBar:SetPercentage(1 - eY / 8)
		tMagicalBar:SetAlpha(255 - 200 * eY / 6)
		eY = eY + 1
	end
	eX = eX + 1
end

function ShowMagicalExample()
	Station.Lookup("Normal/seMagicalBar"):Show()
end
function HideMagicalExample()
	Station.Lookup("Normal/seMagicalBar"):Hide()
end
HideMagicalExample()
