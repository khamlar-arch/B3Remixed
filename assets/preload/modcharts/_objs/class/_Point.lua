-- Point Class
local point = {__type = "point"}
local mt = {__index = point}

-- static class functions
function point.IsPoint(p)
	return p.__type and p.__type == "point"
end

-- private functions
local function calcMagnitude(v)
	return math.sqrt(v.x^2 + v.y^2)
end
 
local function normalize(v)
	local magnitude = calcMagnitude(v)
	
	return magnitude > 0 and
		point.new(v.x / magnitude, v.y / magnitude)
			or
		point.new(0, 0, 0)
end

local function expectGot(a)
	local t = type(a)
	local cust = t == "table" and a.__type or t
	return "(Point expected, got " .. cust .. ")"
end

-- Meta-Methods
function mt.__index(v, index)
	if (index == "unit") then
		return normalize(v)
	elseif (index == "magnitude") then
		return calcMagnitude(v)
	elseif point[index] then
		return point[index]
	elseif rawget(v, "proxy")[index] then
		return rawget(v, "proxy")[index]
	else
		error(index .. " is not a valid member of Point")
	end
end

function mt.__newindex(v, index, value)
	if (rawget(v, "proxy")[index]) then
		return rawset(rawget(v, "proxy"), index, value)
	else
		error(index .. " cannot be assigned to")
	end
end

function mt.__add(a, b)
	local aIsPoint, bIsPoint = point.isPoint(a), point.isPoint(b)
	
	return (aIsPoint and bIsPoint) and
		point.new(a.x + b.x, a.y + b.y)
			or (bIsPoint) and
		error("bad argument #1 to '?' " .. expectGot(a))
			or (aIsPoint) and
		error("bad argument #2 to '?' " .. expectGot(b))
end

function mt.__sub(a, b)
	local aIsPoint, bIsPoint = point.isPoint(a), point.isPoint(b)
	
	return (aIsPoint and bIsPoint) and
		point.new(a.x - b.x, a.y - b.y)
			or (bIsPoint) and
		error("bad argument #1 to '?' " .. expectGot(a))
			or (aIsPoint) and
		error("bad argument #2 to '?' " .. expectGot(b))
end

function mt.__mul(a, b)
	if (type(a) == "number") then
		return point.new(a * b.x, a * b.y)
	elseif (type(b) == "number") then
		return point.new(a.x * b, a.y * b)
	elseif (point.isPoint(a) and point.isPoint(b)) then
		return point.new(a.x * b.x, a.y * b.y)
	else
		error("attempt to multiply a Point with an incompatible value type or nil")
	end
end

function mt.__div(a, b)
	if (type(a) == "number") then
		return point.new(a / b.x, a / b.y)
	elseif (type(b) == "number") then
		return point.new(a.x / b, a.y / b)
	elseif (point.isPoint(a) and point.isPoint(b)) then
		return point.new(a.x / b.x, a.y / b.y)
	else
		error("attempt to divide a Point with an incompatible value type or nil")
	end
end

function mt.__unm(v)
	return point.new(-v.x, -v.y)
end

function mt.__tostring(v)
	return v.x .. ", " .. v.y
end

mt.__metatable = false

-- public class
function point.new(x, y)
	local self = {}
	self.proxy = {}
	self.proxy.x = x or 0
	self.proxy.y = y or 0
	return setmetatable(self, mt)
end

function point:LerpX(x, t)
	return point.new(self.x + (x - self.x) * t, self.y)
end

function point:LerpY(y, t)
	return point.new(self.x, self.t + (t - self.t) * t)
end

function point:Lerp(p, t)
	return self + (p - self) * t
end

function point:Dot(p)
	return point.isPoint(p) and
		self.x * p.x + self.y * p.y
			or
		error("bad argument #1 to 'Dot' (Point expected, got number)")
end

return point