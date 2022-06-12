local function approriateStr(str,isIndex)
	if isIndex then
		local wrap = false

		if str:find(' ') or str:find('	') or str:find('"') or str:find("'") then wrap = true end
		local c = approriateStr(str)

		return wrap and "["..c..(string.sub(c,#c,#c) == "]" and " ]" or "]") or str
	else
		local v = '"'

		if str:find(v) then
			v = "'"
			if str:find(v) then
				v = "[["
				if str:find("]]") then
					v = nil
				end
			end
		end

		if v ~= nil then
			return v..str..(v == "[[" and "]]" or v)
		end
	end
end

local tableToStr = nil
tableToStrLIMITTABLES = 4
function tableToStr(t,cln,x)
	if type(x) == "number" and (x or 0) >= tableToStrLIMITTABLES then return "Limited" end
	local count,indexNumber = 0,true
	for i,v in pairs(t) do
		count = count + 1
		if type(i) ~= "number" or type(v) == "table" then indexNumber = false end
	end
	if count < 8 and indexNumber then cln = false end
	
	local a = 1+(type(x) == "number" and x or 0)
	local str = --[[(cln and strThing("	",a-1) or "")..]]"{"..(cln and "\n" or "")
	
	for i,v in pairs(t) do
		if cln then str = str..strThing("	",a) end
		if type(i) == "string" then
			str = str..approriateStr(i,true)..' = '
		end
		if type(v) == "table" then
			str = str..tableToStr(v,cln,a)
		else
			str = str..(type(v) == "string" and (approriateStr(v) or "") or tostring(v))
		end
		
		str = str..(cln and ",\n" or ",")
	end
	if count > 0 then str = str:sub(1,#str-(cln and 2 or 1)) else if cln then str = str:sub(1,#str-1) end end

	str = str..((cln and count and "\n" or "")..(cln and strThing("	",a-1) or "").."}")
	return str
end

ogprint = print
local ogprint = ogprint
return function(...)
	local rst = ""
	for i,v in pairs({...}) do
		if i > 1 then rst = rst..", " end
		if type(v) == "table" then
			rst = rst..tostring(v).." - "..tableToStr(v,true)
		else
			rst = rst..tostring(v)
		end
	end
	ogprint(rst)
end