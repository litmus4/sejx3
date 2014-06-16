function print(...)
	local a = {...}
	for i, v in ipairs(a) do
		a[i] = tostring(v)
	end
	OutputMessage("MSG_SYS", "[seAntiJX3] " .. table.concat(a, "\t").. "\n" )
end

function seAntiJX3()
	_loadstring("_ShieldList = {}")()
	print("∑¥∫Õ–≥ÕÍ±œ by “ÌÀﬁ¡Ø")
end

seAntiJX3()

