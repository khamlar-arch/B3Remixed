local point = {userdata = "point"}
point.__index = point

function point.new(x, y)
	return point.set(setmetatable({}, point), x, y)
end

function point.set(p, x, y)
	p.x = x or 0
	p.y = y or 0

	return p
end
	
function point.add(p, x, y)
	p.x = p.x + (x or 0)
	p.y = p.y + (y or 0)

	return p
end

return point