local function getObjectRealClip(spr)
	if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.frame.x")) ~= "number") then return end
	
	return 
		getProperty(spr .. ".frame.frame.x"),
		getProperty(spr .. ".frame.frame.y"),
		getProperty(spr .. ".frame.frame.width"),
		getProperty(spr .. ".frame.frame.height")
end

local function getObjectClip(spr)
	if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.frame.x")) ~= "number") then return end
	
	return 
		getProperty(spr .. "._frame.frame.x"),
		getProperty(spr .. "._frame.frame.y"),
		getProperty(spr .. "._frame.frame.width"),
		getProperty(spr .. "._frame.frame.height")
end

local function setObjectRealClip(spr, x, y, width, height, offsetX, offsetY, offsetWidth, offsetHeight)
	-- Check and Fix Arguments
	if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.frame.x")) ~= "number") then return end
	x = (type(x) == "number" and x or getProperty(spr .. ".frame.frame.x")) + (type(offsetX) == "number" and offsetX or 0)
	y = (type(y) == "number" and y or getProperty(spr .. ".frame.frame.y")) + (type(offsetY) == "number" and offsetY or 0)
	width = type(width) == "number" and width >= 0 and width or getProperty(spr .. ".frame.frame.width") + (type(offsetWidth) == "number" and offsetWidth or 0)
	height = type(height) == "number" and height >= 0 and height or getProperty(spr .. ".frame.frame.height") + (type(offsetHeight) == "number" and offsetHeight or 0)
	
	-- ClipRect
	setProperty(spr .. ".frame.frame.x", x)
	setProperty(spr .. ".frame.frame.y", y)
	setProperty(spr .. ".frame.frame.width", width)
	setProperty(spr .. ".frame.frame.height", height)
	
	return x, y, width, height
end

local function setObjectClip(spr, x, y, width, height, offsetX, offsetY, offsetWidth, offsetHeight)
	-- Check and Fix Arguments
	if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.frame.x")) ~= "number") then return end
	x = (type(x) == "number" and x or getProperty(spr .. ".frame.frame.x")) + (type(offsetX) == "number" and offsetX or 0)
	y = (type(y) == "number" and y or getProperty(spr .. ".frame.frame.y")) + (type(offsetY) == "number" and offsetY or 0)
	width = type(width) == "number" and width >= 0 and width or getProperty(spr .. ".frame.frame.width") + (type(offsetWidth) == "number" and offsetWidth or 0)
	height = type(height) == "number" and height >= 0 and height or getProperty(spr .. ".frame.frame.height") + (type(offsetHeight) == "number" and offsetHeight or 0)
	
	-- ClipRect
	setProperty(spr .. "._frame.frame.x", x)
	setProperty(spr .. "._frame.frame.y", y)
	setProperty(spr .. "._frame.frame.width", width)
	setProperty(spr .. "._frame.frame.height", height)
	
	return x, y, width, height
end

local function getObjectRealClipFromGroup(g, spr)
	if (type(getPropertyFromGroup(g, spr, "frame.frame.x")) ~= "number") then return end
	
	return 
		getPropertyFromGroup(g, spr, "frame.frame.x"),
		getPropertyFromGroup(g, spr, "frame.frame.y"),
		getPropertyFromGroup(g, spr, "frame.frame.width"),
		getPropertyFromGroup(g, spr, "frame.frame.height")
end

local function getObjectClipFromGroup(g, spr)
	if (type(getPropertyFromGroup(g, spr, "frame.frame.x")) ~= "number") then return end
	
	return 
		getPropertyFromGroup(g, spr, "_frame.frame.x"),
		getPropertyFromGroup(g, spr, "_frame.frame.y"),
		getPropertyFromGroup(g, spr, "_frame.frame.width"),
		getPropertyFromGroup(g, spr, "_frame.frame.height")
end

local function setObjectRealClipFromGroup(g, spr, x, y, width, height, offsetX, offsetY, offsetWidth, offsetHeight)
	-- Check and Fix Arguments
	if (type(getPropertyFromGroup(g, spr, "frame.frame.x")) ~= "number") then return end
	x = (type(x) == "number" and x or getPropertyFromGroup(g, spr, "frame.frame.x")) + (type(offsetX) == "number" and offsetX or 0)
	y = (type(y) == "number" and y or getPropertyFromGroup(g, spr, "frame.frame.y")) + (type(offsetY) == "number" and offsetY or 0)
	width = type(width) == "number" and width >= 0 and width or getPropertyFromGroup(g, spr, "frame.frame.width") + (type(offsetWidth) == "number" and offsetWidth or 0)
	height = type(height) == "number" and height >= 0 and height or getPropertyFromGroup(g, spr, "frame.frame.height") + (type(offsetHeight) == "number" and offsetHeight or 0)
	
	-- ClipRect
	setPropertyFromGroup(g, spr, "frame.frame.x", x)
	setPropertyFromGroup(g, spr, "frame.frame.y", y)
	setPropertyFromGroup(g, spr, "frame.frame.width", width)
	setPropertyFromGroup(g, spr, "frame.frame.height", height)
	
	return x, y, width, height
end

local function setObjectClipFromGroup(g, spr, x, y, width, height, offsetX, offsetY, offsetWidth, offsetHeight)
	-- Check and Fix Arguments
	if (type(getPropertyFromGroup(g, spr, "frame.frame.x")) ~= "number") then return end
	x = (type(x) == "number" and x or getPropertyFromGroup(g, spr, "frame.frame.x")) + (type(offsetX) == "number" and offsetX or 0)
	y = (type(y) == "number" and y or getPropertyFromGroup(g, spr, "frame.frame.y")) + (type(offsetY) == "number" and offsetY or 0)
	width = type(width) == "number" and width >= 0 and width or getPropertyFromGroup(g, spr, "frame.frame.width") + (type(offsetWidth) == "number" and offsetWidth or 0)
	height = type(height) == "number" and height >= 0 and height or getPropertyFromGroup(g, spr, "frame.frame.height") + (type(offsetHeight) == "number" and offsetHeight or 0)
	
	-- ClipRect
	setPropertyFromGroup(g, spr, "_frame.frame.x", x)
	setPropertyFromGroup(g, spr, "_frame.frame.y", y)
	setPropertyFromGroup(g, spr, "_frame.frame.width", width)
	setPropertyFromGroup(g, spr, "_frame.frame.height", height)
	
	return x, y, width, height
end

local function getObjectRealFrameOffset(spr)
	if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.offset.x")) ~= "number") then return end
	
	return 
		getProperty(spr .. ".frame.offset.x"),
		getProperty(spr .. ".frame.offset.y")
end

local function getObjectFrameOffset(spr)
	if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.offset.x")) ~= "number") then return end
	
	return 
		getProperty(spr .. "._frame.offset.x"),
		getProperty(spr .. "._frame.offset.y")
end

local function setObjectRealFrameOffset(spr, x, y, offsetX, offsetY)
	-- Check and Fix Arguments
	if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.offset.x")) ~= "number") then return end
	x = (type(x) == "number" and x or getProperty(spr .. ".frame.offset.x")) + (type(offsetX) == "number" and offsetX or 0)
	y = (type(y) == "number" and y or getProperty(spr .. ".frame.offset.y")) + (type(offsetY) == "number" and offsetY or 0)
	
	-- Frame Offset
	setProperty(spr .. ".frame.offset.x", x)
	setProperty(spr .. ".frame.offset.y", y)
	
	return x, y
end

local function setObjectFrameOffset(spr, x, y, offsetX, offsetY)
	-- Check and Fix Arguments
	if (type(spr) ~= "string" or type(getProperty(spr .. ".frame.offset.x")) ~= "number") then return end
	x = (type(x) == "number" and x or getProperty(spr .. ".frame.offset.x")) + (type(offsetX) == "number" and offsetX or 0)
	y = (type(y) == "number" and y or getProperty(spr .. ".frame.offset.y")) + (type(offsetY) == "number" and offsetY or 0)
	
	-- Frame Offset
	setProperty(spr .. "._frame.offset.x", x)
	setProperty(spr .. "._frame.offset.y", y)
	
	return x, y
end

return {
	getObjectRealClip = getObjectRealClip,
	getObjectClip = getObjectClip,
	setObjectRealClip = setObjectRealClip,
	setObjectClip = setObjectClip,
	
	getObjectRealClipFromGroup = getObjectRealClipFromGroup,
	getObjectClipFromGroup = getObjectClipFromGroup,
	setObjectRealClipFromGroup = setObjectRealClipFromGroup,
	setObjectClipFromGroup = setObjectClipFromGroup,
	
	getObjectRealFrameOffset = getObjectRealFrameOffset,
	getObjectFrameOffset = getObjectFrameOffset,
	setObjectRealFrameOffset = setObjectRealFrameOffset,
	setObjectFrameOffset = setObjectFrameOffset
	
	--[[
	getObjectRealFrameOffsetFromGroup = getObjectRealFrameOffsetFromGroup,
	getObjectFrameOffsetFromGroup = getObjectFrameOffsetFromGroup,
	setObjectRealFrameOffsetFromGroup = setObjectRealFrameOffsetFromGroup,
	setObjectFrameOffsetFromGroup = setObjectFrameOffsetFromGroup
	]]
}