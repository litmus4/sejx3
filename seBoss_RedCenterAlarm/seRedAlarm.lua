local function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seRedAlarm] " .. table.concat(a, "\t").. "\n" )
end

seRedAlarm = {
	bRedAlarm = true,
	bCenterAlarm = true,
	r = 255,
	g = 0,
	b = 0,
	
	pRed = nil,
	bUp = true,
	nMaxAlpha = 128,
	nAlpha = 0,
	nTime = 0,
	nSpeed = 16,
}


function seRedAlarm.OnFrameCreate()
	this:RegisterEvent("DO_SKILL_CAST")
	this:RegisterEvent("BUFF_UPDATE")
	
	local frame = Station.Lookup("Topmost/seRedAlarm")
	local handle = frame:Lookup("", "")
	seRedAlarm.pRed = handle:Lookup("Shadow_Info")
	
	--print("Loaded by Ò¶ÜÆÇà¡¢ÒíËÞÁ¯")
end

function seRedAlarm.OnEvent(event)
	
end

function seRedAlarm.OnFrameRender()
	local fps = GetFPS()
	local passed_time = 1000.0 / fps
	--print(fps)
	if seRedAlarm.nTime > 0 then
		if seRedAlarm.bUp then
			seRedAlarm.nAlpha = seRedAlarm.nAlpha + seRedAlarm.nSpeed * passed_time / 67
		else
			seRedAlarm.nAlpha = seRedAlarm.nAlpha - seRedAlarm.nSpeed * passed_time / 67
		end
		if seRedAlarm.nAlpha > seRedAlarm.nMaxAlpha then
			seRedAlarm.nAlpha = seRedAlarm.nMaxAlpha
			seRedAlarm.bUp = false
		end
		if seRedAlarm.nAlpha < 0 then
			seRedAlarm.nAlpha = 0
			seRedAlarm.bUp = true
			seRedAlarm.nTime = seRedAlarm.nTime - 1
		end
		local red_alpha = seRedAlarm.nAlpha
		local center_alpha = seRedAlarm.nAlpha + 128
		if not seRedAlarm.bRedAlarm then
			red_alpha = 0
		end
		if not seRedAlarm.bCenterAlarm then
			center_alpha = 0
		end
		seRedAlarm.Draw( red_alpha )
		seCenterAlarm.UpdateAlpha( center_alpha )
	else
		seRedAlarm.Draw( 0 )
		seCenterAlarm.UpdateAlpha( 0 )
	end
end

function seRedAlarm.OnFrameBreathe()
	
end

function seRedAlarm.Flash(t, msg, bRed, bCenter, r, g, b)
	seRedAlarm.r = r
	seRedAlarm.g = g
	seRedAlarm.b = b
	seRedAlarm.bRedAlarm = bRed
	seRedAlarm.bCenterAlarm = bCenter
	seRedAlarm.nTime = t
	seRedAlarm.bUp = true
	seRedAlarm.nAlpha = 0
	seCenterAlarm.UpdateText(msg)
end

function seRedAlarm.Draw(alpha)
	local xScreen, yScreen = Station.GetClientSize()
	local nR, nG, nB = seRedAlarm.r, seRedAlarm.g, seRedAlarm.b
	seRedAlarm.pRed:SetTriangleFan(true)
	seRedAlarm.pRed:ClearTriangleFanPoint()
	seRedAlarm.pRed:AppendTriangleFanPoint(xScreen/2, 	yScreen/2, 	nR, nG, nB, 0)
	seRedAlarm.pRed:AppendTriangleFanPoint(0, 					0, 					nR, nG, nB, alpha)
	seRedAlarm.pRed:AppendTriangleFanPoint(0, 					yScreen, 		nR, nG, nB, alpha)
	seRedAlarm.pRed:AppendTriangleFanPoint(xScreen, 		yScreen, 		nR, nG, nB, alpha)
	seRedAlarm.pRed:AppendTriangleFanPoint(xScreen, 		0, 					nR, nG, nB, alpha)
	seRedAlarm.pRed:AppendTriangleFanPoint(0, 					0, 					nR, nG, nB, alpha)
end

Wnd.OpenWindow("interface\\seBoss_RedCenterAlarm\\seRedAlarm.ini", "seRedAlarm")
