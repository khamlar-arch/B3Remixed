-- LUA 5.3 FUNCTIONS
function string.split(self, sep)
	if sep == "" then return {str:match((str:gsub(".", "(.)")))} end
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(self, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

function table.find(table,v)
	for i,v2 in next,table do
		if v2 == v then
			return i
		end
	end
end

function table.clear(t, includeKeys)
	if (includeKeys) then
		for i,_ in pairs(t) do rawset(t, i, nil) end
		return
	end
	while #t ~= 0 do rawset(t, #t, nil) end
end

function math.clamp(x,min,max)return math.max(min,math.min(x,max))end

-- EXTRA FUNCTIONS
function table.keys(t, keys, includeI)
	keys = type(keys) == "table" and keys or {}
	for i in pairs(t) do
		if (type(i) ~= "number" or includeI) then table.insert(keys, i) end
	end
	return keys
end

function string.ext(self) return self:sub(1 - (self:reverse():find("%.") or 1))end
function string.withoutExt(self) return self:sub(0, -1-(self:reverse():find("%.") or 1))end

function string.startsWith(self, prefix) return self:find(prefix, 1, true) == 1 end
function string.endsWith(self, suffix) return self:find(suffix, 1, true) == #self - (#suffix - 1) end

function string.contains(self, s) return self:find(s) and true or false end

function string.isSpace(self, pos)
	if (#self < 1 or pos < 1 or pos > #self) then
		return false
	end
	local c = self:byte(pos)
	return (c > 8 and c < 14) or c == 32
end

function string.ltrim(self)
	local i = #self
	local r = 1
	while (r <= i and self:isSpace(r)) do
		r = r + 1
	end
	return r > 1 and self:sub(r, i) or self
end

function string.rtrim(self)
	local i = #self
	local r = 1
	while (r <= i and self:isSpace(i - r + 1)) do
		r = r + 1
	end
	return r > 1 and self:sub(0, i - r + 1) or self
end

function string.trim(self) return string.ltrim(self:rtrim()) end

function math.lerp(from,to,i)return from+(to-from)*i end

function math.truncate(x, precision, round)
	if (precision == 0) then return math.floor(x) end
	
	precision = type(precision) == "number" and precision or 2
	
	x = x * math.pow(10, precision);
	return (round and math.floor(x + .5) or math.floor(x)) / math.pow(10, precision)
end

function math.toTime(x, includeMS, blankIfNotExist)
	local abs = math.abs(x)
	local int = math.floor(abs)
	
	local ms = tostring(abs - int):sub(2, 5)
	ms = ms .. strthing("0", math.floor(math.clamp(4 - #ms, 0, 3)))
	
	local s = tostring(math.fmod(int, 60))
	if (#s == 1) then s = "0" .. s end
	
	local m = tostring(math.fmod(math.floor(int / 60), 60))
	if (#m == 1 and (blankIfNotExist or int >= 3600)) then m = "0" .. m end
	
	local h = tostring(math.floor(int / 3600))
	
	local r = m .. ":" .. s
	if (int >= 3600) then r = h .. ":" .. r end
	
	return (x < 0 and "-" or "") .. (includeMS and r .. ms or r)
end

local tableCopy
function tableCopy(t,st,copyMeta,x)
	if (copyMeta == nil) then copyMeta = true end
	x = x or 0
	getfenv().things = getfenv().things or {}
	local things = getfenv().things
	if (things[t] ~= nil) then return things[t] end

	st = st or {}
	
	things[t] = st
	
	for i,v in pairs(t) do
		st[i] = type(v) == "table" and tableCopy(v,{},copyMeta,x + 1) or v
	end
	if (x <= 0) then getfenv().things = {} end
	
	if (copyMeta) then
		local meta = getmetatable(t)
		if (type(meta) == "table") then
			setmetatable(st, meta)
		end
	end
	
	return st
end
_G.tableCopy = tableCopy

function _G.strThing(s,i)
	local str = ""
	for i = 1,i do
		str = str .. s
	end
	return str
end

_G.G = _G
_G.shared = {}