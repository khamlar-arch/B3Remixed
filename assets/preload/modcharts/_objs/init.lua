--[[
	hi if your reading this
	im sorry if i didnt fix sustains shit and downscroll im just lazy smh!!!
--]]

--[[ INITIALIZE ]]--
require("util/Overrides", getfenv())

print = require("util/CustomPrint", getfenv())

local ps = require("util/PsychOverrides", getfenv())

--[[ CLASSES AND LIBS ]]--
local Point = require("class/Point")
local Vector3 = require("class/Vector3")
local Matrix = require("class/Matrix")
local CFrame = require("class/CFrame")

local easing = require("lib/easing")
local tn = require("lib/tweenNumber", getfenv())
local clips = require("lib/PsychClip", getfenv())

--local opt = require("lib/PsychModOpt") -- me ralt source code optimizations
-- maded this for b3 and my own later released modcharts

printDebugs = false
local function printdebug(...)
	if (printDebugs) then
		print(...)
	end
end

if (clearUnusedMemory == nil) then
	function clearUnusedMemory()end
end

--[[ FUNKY NOTES ]]--
funkyConfig = {
	betterShake = true,
	betterShakeHardness = .5, -- from 0 to 1
	betterShakeFadeTime = .15,
	useScrollForShake = true
}

-- STILL IN WIP LMAO!!
templateReceptor = {
	x = 0,
	y = 0,
	z = 0,
	
	direction = Vector3.new(),
	rotation = Vector3.new(),
	angle = 0,
	
	scale = Vector3.new(.7, .7, .7),
	
	alpha = 1,
	
	_angle = 0,
	_dir = 0
}

templateStrumline = {
	x = 0,
	y = 0,
	z = 0,
	
	rotation = Vector3.new(),
	angle = 0,
	
	scale = Vector3.new(1, 1, 1),
	
	alpha = 1,
	
	speedMultiply = Point.new(),
	
	receptor = tableCopy(templateReceptor),
	receptorY = 0,
	
	downScroll = false
}

templateStrum = {
	x = 0,
	y = 0,
	z = 0,
	
	scrollFactor = Point.new(),
	
	rotation = Vector3.new(),
	angle = 0,
	
	scale = Vector3.new(1, 1, 1),
	
	alpha = 1,
	
	view = { -- basically camera
		x = 0,
		y = 0,
		z = 0,
		
		rotation = Vector3.new(),
		
		fov = 60,
		ortho = true
	},
	
	scrollSpeed = 1,
	
	noteScales = Point.new(1, 1),
	noteAngles = 0,
	
	lines = {
		tableCopy(templateStrumline),
		tableCopy(templateStrumline),
		tableCopy(templateStrumline),
		tableCopy(templateStrumline)
	},
	
	-- RALT DONT FORGET!! ALMOST EVERY ITG2 MODS EXPLAINED
	-- https://youtu.be/4cHCqwHcKPY
	-- https://youtu.be/hRK6fXbcl_U
	-- SOME ITG2 MODS, 1 = 100% REMEMBER!!!
	modsOffset = 0,
	
	hallway = 0, -- currently not possible because of ortho, might do it later
	distant = 0, -- ^^^
	
	reverse = 0,
	centered = 0,
	
	accel = 0,
	deccel = 0,
	dizzy = 0,
	wave = 0,
	expand = 0,
	boomerang = 0,
	
	bumpy = 0,
	drift = 0,
	float = 0,
	tipsy = 0,
	
	flip = 0,
	invert = 0,
	tornado = 0,
	beat = 0,
}

defaultStrums = nil

local strums_isReady = false
strums = setmetatable(
	{
		dad = tableCopy(templateStrum),
		bf = tableCopy(templateStrum)
	},
	{
		__index = function(t, i)
			return i == "isReady" and cams_isReady or nil
		end,
		__newindex = function(t, i, v)
			if i == "isReady" then cams_isReady = type(v) == "boolean" and v or strums_isReady end
		end
	}
)

function isVector3(t)
	return type(t) == "table" and t.__type == "vector3"
end

function isCFrame(t)
	return type(t) == "table" and t.__type == "cframe"
end

function initializeStrumLine(t, i, d)
	local l = t.lines[i]
	local r = l.receptor
	
	l.receptorY = -gameHeight / 2 + 134
	l.x = 112 * (i - 2.5)
	
	l.downScroll = d
	
	l.rotation = isVector3(l.rotation) and l.rotation or Vector3.new()
	l.scale = isVector3(l.scale) and l.scale or Vector3.new(1, 1, 1)
	
	r.rotation = isVector3(r.rotation) and r.rotation or Vector3.new()
	r.direction = isVector3(r.direction) and r.direction or Vector3.new()
	r.scale = isVector3(r.scale) and r.scale or Vector3.new(.7, .7, .7)
end

function initializeStrum(t)
	local downScroll = getPropertyFromClass("ClientPrefs", "downScroll")
	
	t.view.rotation = isVector3(t.view.rotation) and t.view.rotation or Vector3.new()
	t.rotation = isVector3(t.rotation) and t.rotation or Vector3.new()
	t.scale = isVector3(t.scale) and t.scale or Vector3.new(1, 1, 1)
	
	initializeStrumLine(t, 1, downScroll)
	initializeStrumLine(t, 2, downScroll)
	initializeStrumLine(t, 3, downScroll)
	initializeStrumLine(t, 4, downScroll)
	
	local isBf = t == strums.bf
	local g = isBf and "playerStrums" or "opponentStrums"
	
	for i = 0, getProperty(g .. ".length") - 1 do
		pcall(setPropertyFromGroup, g, i, "sustainReduce", false)
		-- FOR PSYCH 0.4.2
	end
end

function initializeStrums()
	initializeStrum(strums.dad)
	strums.dad.x = (gameWidth / 2) - (gameWidth / 4)
	strums.dad.y = gameHeight / 2
	
	initializeStrum(strums.bf)
	strums.bf.x = (gameWidth / 2) + (gameWidth / 4)
	strums.bf.y = gameHeight / 2
	
	strums.isReady = true
	
	defaultStrums = tableCopy(strums)
	
	for i = 0, getProperty("unspawnNotes.length") - 1 do
		setPropertyFromGroup("unspawnNotes", i, "copyAngle", false)
		setPropertyFromGroup("unspawnNotes", i, "copyX", false)
		setPropertyFromGroup("unspawnNotes", i, "copyY", false)
	end
end

function applyRecMod(t, i, cf)
	local l = t.lines[i]
	
	local scaleX = l.scale.x * t.scale.x
	local scaleY = l.scale.y * t.scale.y
	local scaleZ = l.scale.z * t.scale.z
	
	local songPos = songPos + t.modsOffset
	
	if (t.invert ~= 0) then
		local two = math.fmod(i, 2) == 0
		
		cf = cf:toWorldSpace(
			CFrame.new(
				112 * (two and -1 or 1), 0, 0
			)
		)
	end
	
	if (t.drift ~= 0 or t.float ~= 0 or t.tipsy ~= 0) then
		cf = cf:toWorldSpace(
			CFrame.new(
				math.cos(songPos * math.pi + i) * 26 * scaleX * t.drift,
				math.sin((songPos * math.pi + i) / 1.363) * 26 * scaleY * t.float,
				math.cos((songPos * math.pi + i) / 1.737) * 26 * scaleZ * t.tipsy
			)
		)
	end
	
	if (t.beat ~= 0) then
		local v = math.cos(songPos * curBpm / 60 * math.pi)
		cf = cf:toWorldSpace(
			CFrame.new(
				math.clamp((v - (v > 0 and .9 or -.9)) * 10, v > 0 and 0 or -1, v > 0 and 1 or 0) * 15 * scaleX * t.beat,
				0,
				0
			)
		)
	end
	
	return cf
end

function applyNoteMod(t, i, cf, distance)
	distance = distance * .001
	
	local l = t.lines[i]
	
	local scaleX = l.scale.x * t.scale.x
	local scaleY = l.scale.y * t.scale.y
	local scaleZ = l.scale.z * t.scale.z
	
	local songPos = songPos + t.modsOffset
	
	if (t.drift ~= 0 or t.float ~= 0 or t.tipsy ~= 0) then
		cf = cf:toWorldSpace(
			CFrame.new(
				math.sin(distance * math.pi * 2.3) * 26 * scaleX * t.drift,
				math.sin((distance * math.pi) * 2.3 / 1.363) * 26 * scaleY * t.float,
				math.sin((distance * math.pi) * 2.3 / 1.737) * 26 * scaleZ * t.tipsy
			)
		)
	end
	
	return cf
end

function updateReceptor(t, i, cf)
	local l = t.lines[i]
	local r = l.receptor
	
	r.rotation = isVector3(r.rotation) and r.rotation or Vector3.new()
	r.direction = isVector3(r.direction) and r.direction or Vector3.new()
	r.scale = isVector3(r.scale) and r.scale or Vector3.new(.7, .7, .7)
	
	local scaleX = l.scale.x * t.scale.x
	local scaleY = l.scale.y * t.scale.y
	local scaleZ = l.scale.z * t.scale.z
	
	local cf = cf:toWorldSpace(
		CFrame.new(r.x * scaleX, r.y * scaleY, r.z * scaleZ) *
		CFrame.Angles(math.rad(r.rotation.x), math.rad(r.rotation.y), math.rad(r.rotation.z))
	)
	
	cf = applyRecMod(t, i, cf)
	
	local lCf = cf:toWorldSpace(
		CFrame.new()
	)
	
	r._angle = r.angle
	r._dir = r.angle
	
	local isBf = t == strums.bf
	local fI = i - 1
	
	local g = isBf and "playerStrums" or "opponentStrums"
	
	local offX = getPropertyFromGroup(g, fI, "width") / 2
	local offY = getPropertyFromGroup(g, fI, "height") / 2
	
	local viewX = lCf.x
	local viewY = lCf.y
	
	if (setSprPosFromGroup) then
		setSprPosFromGroup(g, fI, viewX - offX, viewY - offY, r.angle + t.noteAngles)
	else
		setPropertyFromGroup(g, fI, "x", viewX - offX)
		setPropertyFromGroup(g, fI, "y", viewY - offY)
		setPropertyFromGroup(g, fI, "angle", r.angle + t.noteAngles)
	end
	
	if (setSprScFromGroup) then
		setSprScFromGroup(g, fI, r.scale.x * t.noteScales.x, r.scale.y * t.noteScales.y)
	else
		setPropertyFromGroup(g, fI, "scale.x", r.scale.x * t.noteScales.x)
		setPropertyFromGroup(g, fI, "scale.y", r.scale.y * t.noteScales.y)
	end
	
	setPropertyFromGroup(g, fI, "alpha", r.alpha * l.alpha * t.alpha)
	
	return cf
end

function updateStrumLine(t, i, cf)
	local l = t.lines[i]
	
	l.rotation = isVector3(l.rotation) and l.rotation or Vector3.new()
	l.scale = isVector3(l.scale) and l.scale or Vector3.new(1, 1, 1)
	
	local cf = cf:toWorldSpace(
		CFrame.new(l.x * t.scale.x, l.y + l.receptorY * t.scale.y * (l.downScroll and -1 or 1), l.z * t.scale.z) *
		CFrame.Angles(math.rad(l.rotation.x), math.rad(l.rotation.y), math.rad(l.rotation.z))
	)
	
	return updateReceptor(t, i, cf)
end

function updateStrum(t)
	t.view.rotation = isVector3(t.view.rotation) and t.view.rotation or Vector3.new()
	t.rotation = isVector3(t.rotation) and t.rotation or Vector3.new()
	t.scale = isVector3(t.scale) and t.scale or Vector3.new(1, 1, 1)
	
	local cf = (
		CFrame.new(-t.view.x, -t.view.y, -t.view.z) *
		CFrame.Angles(math.rad(-t.view.rotation.x), math.rad(-t.view.rotation.y), math.rad(-t.view.rotation.z))
	):toWorldSpace(
		CFrame.new(t.x, t.y, t.z) *
		CFrame.Angles(math.rad(t.rotation.x), math.rad(t.rotation.y), math.rad(t.rotation.z))
	)
	
	local cf1 = updateStrumLine(t, 1, cf)
	local cf2 = updateStrumLine(t, 2, cf)
	local cf3 = updateStrumLine(t, 3, cf)
	local cf4 = updateStrumLine(t, 4, cf)
	
	return cf1, cf2, cf3, cf4
end

function pointTowards(x1, x2)
	local p1x, p1y = x1.x, x1.y
	local p2x, p2y = x2.x, x2.y
	
	local dX, dY = p1x - p2x, p1y - p2y
	
	return math.deg(math.atan(dY/dX)) + (dX < 0 and 180 or 0)
end

function posOverlaps(
    x1, y1, w1, h1, --r1,
    x2, y2, w2, h2 --r2
)
    return (
        x1 + w1 >= x2 and x1 < x2 + w2 and
        y1 + h1 >= y2 and y1 < y2 + h2
    )
end

-- 14% SLOWS DOWN MY LAPTOP PERFORMANCE BUT ITS WORTH IT B)
function updateNotes(...)
	local args = {...}
	
	local fakeCrochet = (60 / bpm) * 1000
	
	local noteSwagWidth = 112
	local songSpeed = getProperty("songSpeed")
	local isPixelStage = getProperty("isPixelStage")
	local daPixelZoom = getProperty("daPixelZoom")
	
	for i = 0, getProperty("notes.length") - 1 do
		local strumTime = getPropertyFromGroup("notes", i, "strumTime")
		
		local isSustainNote = getPropertyFromGroup("notes", i, "isSustainNote")
		--local originalHeightForCalcs = getPropertyFromGroup("notes", i, "originalHeightForCalcs")
		
		local distance = -0.45 * (realSongPos - strumTime) * songSpeed
		--setPropertyFromGroup("notes", i, "distance", distance)
		
		if (distance > -gameHeight and distance < gameHeight) then
			local notePress = getPropertyFromGroup("notes", i, "mustPress")
			local noteData = getPropertyFromGroup("notes", i, "noteData")
			
			local offsetX = getPropertyFromGroup("notes", i, "offsetX")
			local offsetY = getPropertyFromGroup("notes", i, "offsetY")
			local offsetAngle = getPropertyFromGroup("notes", i, "offsetAngle")
			
			local nI = noteData + 1
			
			local t = notePress and strums.bf or strums.dad
			local l = t.lines[nI]
			local r = l.receptor
			
			local strumPos = args[noteData + 1 + (notePress and 4 or 0)]
			local strumAngle = r._angle + t.noteAngles
			local strumScaleX = r.scale.x * t.noteScales.x
			local strumScaleY = r.scale.y * t.noteScales.y
			local strumScroll = l.downScroll
			local strumDirection = r._dir
			
			local scrollScaleX = t.scale.x * l.scale.x
			local scrollScaleY = t.scale.y * l.scale.y
			local scrollScaleZ = t.scale.z * l.scale.z
			
			strumAngle = strumAngle + offsetAngle
			
			strumPos = strumPos:toWorldSpace(
				CFrame.Angles(math.rad(r.direction.x), math.rad(r.direction.y), math.rad(r.direction.z))
			)
			
			local width = getPropertyFromGroup("notes", i, "width")
			local height = getPropertyFromGroup("notes", i, "height")
			
			local hW = width / 2
			local hH = height / 2
			
			local endN
			local canCrop = false
			if (isSustainNote) then
				endN = getPropertyFromGroup("notes", i, "animation.curAnim.name"):endsWith("end")
				if (endN) then
					distance = distance - hH
				end
				
				local yesCrop = not notePress
				if (not yesCrop) then
					yesCrop = not getPropertyFromGroup("notes", i, "ignoreNote") and (
							getPropertyFromGroup("notes", i, "wasGoodHit") or
							getPropertyFromGroup("notes", i, "prevNote.wasGoodHit") or
							not getPropertyFromGroup("notes", i, "canBeHit")
						)
				end
				
				if (yesCrop and distance - hH <= 0) then
					canCrop = true
				end
				
				if (strumScroll) then distance = -distance end
			else
				if (strumScroll) then distance = -distance end
			end
			
			local notePos1 = strumPos:toWorldSpace(
				CFrame.new(0, (distance - hH) * scrollScaleY, 0)
			)
			notePos1 = applyNoteMod(t, nI, notePos1, distance - hH)
			
			local notePos2 = strumPos:toWorldSpace(
				CFrame.new(0, (distance + hH) * scrollScaleY, 0)
			)
			notePos2 = applyNoteMod(t, nI, notePos2, distance + hH)
			
			local notePos = notePos1:lerp(notePos2, .5)
			local angle = isSustainNote and pointTowards(notePos2, notePos1) - 90 or strumAngle
			local alpha = r.alpha * l.alpha * t.alpha
			
			-- WIP
			
			-- IM TRYING HARD TO OPTIMIZE THIS SHIT WITH USING FEWER GETPROPERTY FUNCTIONS
			-- omfg it looks so bad
			if (canCrop) then
				local x, y, w, h
				
				local th = endN and 2 or 4
				
				if (strumScroll) then
					x, y, w, h = clips.getObjectRealClipFromGroup("notes", i)
					
					local cool = math.clamp(-((-distance - hH) / th), 0, h - .1)
					
					clips.setObjectClipFromGroup("notes", i, x, y + cool, w, h - cool)
					notePos = notePos:toWorldSpace(
						CFrame.new(0, -cool * th, 0)
					)
				else
					x, y, w, h = clips.getObjectRealClipFromGroup("notes", i)
					
					local cool = math.clamp(-((distance - hH) / th), 0, h - .1)
					
					clips.setObjectClipFromGroup("notes", i, x, y + cool, w, h - cool)
					notePos = notePos:toWorldSpace(
						CFrame.new(0, cool * th, 0)
					)
				end
			end
			
			local finalX = (notePos.x - hW) + offsetX - (isSustainNote and (noteSwagWidth / 2) - hW or 0)
			local finalY = (notePos.y - hH) + offsetY
			
			if (posOverlaps(finalX, finalY, width, height, 0, 0, gameWidth, gameHeight)) then
				if (setSprPosFromGroup) then
					setSprPosFromGroup("notes", i, finalX, finalY, angle + offsetAngle)
				else
					setPropertyFromGroup("notes", i, "x", finalX)
					setPropertyFromGroup("notes", i, "y", finalY)
					setPropertyFromGroup("notes", i, "angle", angle + offsetAngle)
				end
				
				if (not setSprScFromGroup or isSustainNote) then
					setPropertyFromGroup("notes", i, "scale.x", strumScaleX)
					if (not isSustainNote) then
						setPropertyFromGroup("notes", i, "scale.y", strumScaleY)
					end
				else
					setSprScFromGroup("notes", i, strumScaleX, strumScaleY)
				end
				
				setPropertyFromGroup("notes", i, "alpha", r.alpha * l.alpha * t.alpha * (isSustainNote and .6 or 1))
			else
				setPropertyFromGroup("notes", i, "x", -999999999)
			end
		else
			setPropertyFromGroup("notes", i, "x", -999999999)
			--setPropertyFromGroup("notes", i, "y", -99999999)
		end
	end
end

function updateStrums()
	local cf11, cf12, cf13, cf14 = updateStrum(strums.dad)
	local cf21, cf22, cf23, cf24 = updateStrum(strums.bf)
	
	updateNotes(cf11, cf12, cf13, cf14, cf21, cf22, cf23, cf24)
end

templateCam = {
	followZoomSpeed = 1,
	followZoom = 1,
	zoom = 1,
	zoomOffset = 0,
	
	visible = true,
	
	width = 1280,
	height = 720,
	
	scale = Point.new(1, 1),
	
	spriteScale = Point.new(1, 1),
	
	x = 0,
	y = 0,
	
	anchorPoint = Point.new(.5, .5),
	offset = Point.new(),
	
	-- Just incase if you want to mess around
	skew = Point.new(),
	clipSkew = Point.new(),
	
	transform = Matrix.new(),
	_matrix = Matrix.new(),
	
	clipTransform = Matrix.new(),
	clipWidthOffset = 0,
	clipHeightOffset = 0,
	clipOffset = Point.new(),
	
	viewOffset = Point.new(),
	
	rotation = 0, -- ITS DIFFERENT
	angle = 0,
	
	scroll = Point.new(),
	scrollOffset = Point.new(),
	followSpeed = Point.new(1, 1),
	follow = Point.new(),
	
	ignoreScaleMode = false,
	
	lockToFollow = true,
	lockToFollowZoom = true,
	lockToMustHit = true,
	zoomOnBeat = true,
	zoomBeatSteps = 16,
	zoomBeatOffsetSteps = 0,
	zoomBeatPower = .03,
	
	fxShakeTransform = Matrix.new(),
	fxShakeScroll = Point.new(),
	fxShakeIntensity = 0,
	fxShakeDuration = -1000,
	fxShakeI = -999999
}
function templateCam:zoomBeat()
	self.zoom = self.zoom + self.zoomBeatPower
end

defaultCams = nil

local cams_isReady = false
cams = setmetatable(
	{
		hud = tableCopy(templateCam),
		other = tableCopy(templateCam),
		game = tableCopy(templateCam)
	},
	{
		__index = function(t, i)
			return i == "isReady" and cams_isReady or nil
		end,
		__newindex = function(t, i, v)
			if i == "isReady" then cams_isReady = type(v) == "boolean" and v or cams_isReady end
		end
	}
)

bfOffsetCam = Point.new()
dadOffsetCam = Point.new()

function initializeCams()
	local function cam(t, cam, class)
		t.getProperty = type(class) == "string" and function(v)return getPropertyFromClass(class, cam .. "." .. v)end or
			function(v)return getProperty(cam .. "." .. v)end
		t.setProperty = type(class) == "string" and function(v, x)return setPropertyFromClass(class, cam .. "." .. v, x)end or
			function(v, x)return setProperty(cam .. "." .. v, x)end
		local getProperty = t.getProperty
		
		t.x = getProperty("x")
		t.y = getProperty("y")
		t.scroll.x = getProperty("scroll.x")
		t.scroll.y = getProperty("scroll.y")
		t.angle = getProperty("angle")
		t.zoom = getProperty("zoom")
		t.width = gameWidth
		t.height = gameHeight
		t.class = class
		t.cam = cam
		t.zoomOnBeat = cameraZoomOnBeat
	end
	
	cam(cams.hud, "camHUD")
	cam(cams.other, "camOther")
	cam(cams.game, "camera", "flixel.FlxG")
	cams.game.scroll.x = getProperty("camFollow.x")
	cams.game.scroll.y = getProperty("camFollow.y")
	cams.game.zoom = getProperty("defaultCamZoom")
	cams.game.followZoom = cams.game.zoom
	cams.game.zoomBeatPower = .015
	cams.other.zoomOnBeat = false
	
	cams.isReady = true
	
	defaultCams = tableCopy(cams)
end

function updateCamClip(t)
	local renderBlit = getPropertyFromClass("flixel.FlxG", "renderBlit") -- useless lmao
	local scaleModeX = t.ignoreScaleMode and 1 or getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
	local scaleModeY = t.ignoreScaleMode and 1 or getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")
	local initialZoom = t.getProperty("initialZoom")
	
	t.setProperty("width", t.width)
	t.setProperty("height", t.height)
	
	local scaleX = t.scale.x * t.zoom
	local scaleY = t.scale.y * t.zoom
	
	t.setProperty("scaleX", scaleX)
	t.setProperty("scaleY", scaleY)
	
	local totalScaleX = scaleX * scaleModeX
	local totalScaleY = scaleY * scaleModeY
	
	t.setProperty("totalScaleX", totalScaleX)
	t.setProperty("totalScaleY", totalScaleY)
	
	if (renderBlit) then
		-- updateBlitMatrix()
		
		t.setProperty("_flashBitmap.scaleX", totalScaleX)
		t.setProperty("_flashBitmap.scaleY", totalScaleY)
	end
	
	-- calcOffsetX()
	local viewOffsetX = 0.5 * t.width * (scaleX - initialZoom) / scaleX;
	t.setProperty("viewOffsetX", viewOffsetX)
	t.setProperty("viewOffsetWidth", t.width - viewOffsetX)
	t.setProperty("viewWidth", t.width - 2 * viewOffsetX)
	
	-- calcOffsetY()
	local viewOffsetY = 0.5 * t.height * (scaleY - initialZoom) / scaleY;
	t.setProperty("viewOffsetY", viewOffsetY)
	t.setProperty("viewOffsetHeight", t.height - viewOffsetY)
	t.setProperty("viewHeight", t.height - 2 * viewOffsetY)
	
	-- updateScrollRect()
	if (type(t.getProperty("_scrollRect.__scrollRect.x")) == "number") then
		t.setProperty("_scrollRect.__scrollRect.x", 0); t.setProperty("_scrollRect.__scrollRect.y", 0)
		
		local width = math.abs(t.width * initialZoom * scaleModeX)
		local height = math.abs(t.height * initialZoom * scaleModeY)
		
		local www = width * t.spriteScale.x
		local hhh = height * t.spriteScale.y
		
		local rW = (width + t.clipWidthOffset) * t.spriteScale.x
		local rH = (height + t.clipHeightOffset) * t.spriteScale.y
		
		local rX = (-.5 * www) + (t.clipOffset.x / width * www)
		local rY = (-.5 * hhh) + (t.clipOffset.y / height * hhh)
		
		t.setProperty("_scrollRect.__scrollRect.width", rW)
		t.setProperty("_scrollRect.__scrollRect.height", rH)
		
		-- Setup Matrix
		local mat = t._matrix
		mat:identity()
		
		mat:translate(rX, rY) -- Set Position
		
		mat:concat(t.clipTransform) -- Transform
		
		-- Finals
		t.setProperty("_scrollRect.__transform.a", mat.a)
		t.setProperty("_scrollRect.__transform.b", mat.b)
		t.setProperty("_scrollRect.__transform.c", mat.c)
		t.setProperty("_scrollRect.__transform.d", mat.d)
		t.setProperty("_scrollRect.__transform.tx", mat.tx)
		t.setProperty("_scrollRect.__transform.ty", mat.ty)
	end
	
	-- updateInternalSpritePositions()
	if (renderBlit) then
		if (type(t.getProperty("_flashBitmap.x")) == "number") then
			t.setProperty("_flashBitmap.x", 0)
			t.setProperty("_flashBitmap.y", 0)
		end
	else
		if (type(t.getProperty("canvas.x")) == "number") then
			local width = (t.width * t.spriteScale.x)
			local height = (t.height * t.spriteScale.y)
			
			local ratio = t.width / width
			
			local aW, aH = width*t.anchorPoint.x, height*t.anchorPoint.y
			
			-- TY https://community.openfl.org/t/rotation-around-center/8751/4
			
			local pX = (
				(t.clipOffset.x * ratio)
			)
			* scaleModeX
			
			local pY = (
				(t.clipOffset.y * ratio)
			)
			* scaleModeY
			
			-- Setup Matrix
			local mat = t._matrix
			mat:identity()
			
			mat:translate(-aW, -aH) -- AnchorPoint In
			
			mat:scale(scaleX, scaleY) -- Scaling
			
			mat:rotate(t.angle) -- Angle
			
			mat:skew(t.skew.x, t.skew.y) -- Skewing
			
			mat:concat(t.fxShakeTransform)
			
			mat:translate(aW, aH) -- AnchorPoint Out
			
			mat:translate(t.viewOffset.x, t.viewOffset.y) -- Offset
			
			mat:scale(scaleModeX * t.spriteScale.x, scaleModeY * t.spriteScale.y) -- ScaleMode
			
			mat:concat(t.transform) -- Transform
			
			-- Finals
			t.setProperty("canvas.__transform.a", mat.a)
			t.setProperty("canvas.__transform.b", mat.b)
			t.setProperty("canvas.__transform.c", mat.c)
			t.setProperty("canvas.__transform.d", mat.d)
			t.setProperty("canvas.__transform.tx", mat.tx)
			t.setProperty("canvas.__transform.ty", mat.ty)
		end
	end
end

function updateCam(t)
	if (not cams.isReady) then return end
	
	t.setProperty("x", t.x + t.offset.x)
	t.setProperty("y", t.y + t.offset.y)
	t.setProperty("angle", t.rotation)
	
	t.setProperty("scroll.x", t.scroll.x + t.scrollOffset.x + t.fxShakeScroll.x)
	t.setProperty("scroll.y", t.scroll.y + t.scrollOffset.y + t.fxShakeScroll.y)
	
	t.setProperty("visible", t.visible)
	
	updateCamClip(t)
	t.setProperty("_fxShakeIntensity", 0)
	
	if (cams.game == t) then
		setProperty("camFollowPos.x", t.scroll.x + t.scrollOffset.x + t.fxShakeScroll.x)
		setProperty("camFollowPos.y", t.scroll.y + t.scrollOffset.y + t.fxShakeScroll.y)
	end
end

function updateCamFxShake(t, dt)
	if (not cams.isReady) then return end
	
	local cool = (funkyConfig.betterShake and -funkyConfig.betterShakeFadeTime or 0)
	
	t.fxShakeDuration = t.fxShakeDuration > cool and t.fxShakeDuration - dt or cool
	
	local _fxShakeIntensity = t.getProperty("_fxShakeIntensity")
	local _fxShakeDuration = t.getProperty("_fxShakeDuration")
	if (_fxShakeIntensity ~= 0 and _fxShakeDuration > 0) then
		t.fxShakeIntensity = _fxShakeIntensity
		t.fxShakeDuration = _fxShakeDuration
	end
	t.setProperty("_fxShakeIntensity", 0)
	
	if (t.fxShakeDuration > cool) then
		local sX = t.fxShakeIntensity * t.width -- uwu~
		local sY = t.fxShakeIntensity * t.height
		
		local rX, rY, rAngle, rSkewX, rSkewY = 0, 0, 0, 0, 0
		if (funkyConfig.betterShake) then
			local w = (t.fxShakeDuration / -cool) + 1
			local ww = math.clamp(w, 0, 1) * (-funkyConfig.betterShakeHardness + 1)
			local www = math.clamp(w, 0, 1) * funkyConfig.betterShakeHardness
			
			t.fxShakeI = t.fxShakeI + (math.clamp((t.fxShakeIntensity * 7) + .75, 0, 10) * dt * math.clamp(w, 0, 1.5))
			rX = math.cos(t.fxShakeI * 97) * sX * ww
			rY = math.sin(t.fxShakeI * 86) * sY * ww
			rAngle = math.sin(t.fxShakeI * 62) * math.clamp(t.fxShakeIntensity * 66, -60, 60) * ww
			rSkewX = math.cos(t.fxShakeI * 54) * math.clamp(t.fxShakeIntensity * 12, -4, 4) * ww
			rSkewY = math.sin(t.fxShakeI * 51) * math.clamp(t.fxShakeIntensity * 12, -1.5, 1.5) * ww
			
			if (funkyConfig.betterShakeHardness > 0) then
				rX = rX + (math.cos(t.fxShakeI * 165) * sX * www)
				rY = rY + (math.cos(t.fxShakeI * 132) * sY * www)
				rAngle = rAngle + (math.sin(t.fxShakeI * 111) * math.clamp(t.fxShakeIntensity * 66, -60, 60) * www)
				rSkewX = rSkewX + (math.sin(t.fxShakeI * 123) * math.clamp(t.fxShakeIntensity * 12, -4, 4) * www)
				rSkewY = rSkewY + (math.cos(t.fxShakeI * 101) * math.clamp(t.fxShakeIntensity * 12, -1.5, 1.5) * www)
			end
		else
			rX = getRandomFloat(-sX, sX)
			rY = getRandomFloat(-sY, sY)
		end
		
		local useScroll = funkyConfig.useScrollForShake and t == cams.game
		if (useScroll) then
			t.fxShakeScroll:set(
				rX,
				rY
			)
		end
		
		-- Setup Matrix
		local mat = t.fxShakeTransform
		mat:identity()
		
		mat:rotate(rAngle)
		mat:translate(
			useScroll and 0 or rX * t.zoom,
			useScroll and 0 or rY * t.zoom
		)
		
		mat:skew(rSkewX, rSkewY)
	else
		t.fxShakeScroll:set(0, 0)
	end
end

function updateCamLerp(t, dt)
	if (not cams.isReady) then return end
	
	local isCamsGame = cams.game == t
	
	if (t.lockToFollowZoom) then
		t.zoom = math.lerp(t.zoom, t.followZoom, math.clamp(dt * 3.125 * t.followZoomSpeed, 0, 1))
	end
	
	if (isCamsGame and t.lockToMustHit) then
		if (not inGameOver) then cameraSetTarget(mustHitSection and "bf" or "dad") end
		t.follow.x = getProperty("camFollow.x")
		t.follow.y = getProperty("camFollow.y")
	end
	
	if (t.lockToFollow) then
		local x = isCamsGame and not inGameOver and (
			(bfOffsetCam.x * (mustHitSection and 1 or .4)) +
			(dadOffsetCam.x * (mustHitSection and .4 or 1))
		) or 0
		local y = isCamsGame and not inGameOver and (
			(bfOffsetCam.y * (mustHitSection and 1 or .4)) +
			(dadOffsetCam.y * (mustHitSection and .4 or 1))
		) or 0
		
		t.scroll.x = math.lerp(t.scroll.x, t.follow.x + x, dt * 2.4 * t.followSpeed.x)
		t.scroll.y = math.lerp(t.scroll.y, t.follow.y + y, dt * 2.4 * t.followSpeed.y)
	end
	
	updateCamFxShake(t, dt)
end

function updateCams()
	if (not inGameOver) then
		updateCam(cams.hud)
		updateCam(cams.other)
	end
	updateCam(cams.game)
end

function updateCamsLerp(dt)
	if (not inGameOver) then
		updateCamLerp(cams.hud, dt)
		updateCamLerp(cams.other, dt)
	end
	updateCamLerp(cams.game, dt)
end

ps.opponentNoteHit(function(id, dir)
	if (not cams.isReady and not inGameOver) then return end
	
	local x = dir == 0 and -32 or (dir == 3 and 32) or 0
	local y = dir == 1 and 32 or (dir == 2 and -32) or 0
	tn.tweenNumber(dadOffsetCam, "x", x, 0, .5, nil, easing.outCubic)
	tn.tweenNumber(dadOffsetCam, "y", y, 0, .5, nil, easing.outCubic)
end)

camNoteHit = function(id, dir)
	if (not cams.isReady and not inGameOver) then return end
	
	local x = dir == 0 and -32 or (dir == 3 and 32) or 0
	local y = dir == 1 and 32 or (dir == 2 and -32) or 0
	tn.tweenNumber(bfOffsetCam, "x", x, 0, .5, nil, easing.outCubic)
	tn.tweenNumber(bfOffsetCam, "y", y, 0, .5, nil, easing.outCubic)
end
ps.goodNoteHit(camNoteHit)
ps.noteMiss(camNoteHit)

ps.onStepHit(function()
	if (not cams.isReady and not inGameOver) then return end
	
	if (cams.game.zoomOnBeat and math.fmod(curStep + cams.game.zoomBeatOffsetSteps, cams.game.zoomBeatSteps) == 0) then
		cams.game:zoomBeat()
	end
	
	if (cams.hud.zoomOnBeat and math.fmod(curStep + cams.hud.zoomBeatOffsetSteps, cams.hud.zoomBeatSteps) == 0) then
		cams.hud:zoomBeat()
	end
	if (cams.other.zoomOnBeat and math.fmod(curStep + cams.other.zoomBeatOffsetSteps, cams.other.zoomBeatSteps) == 0) then
		cams.other:zoomBeat()
	end
end)

ps.onMoveCamera(function(player)
	if (not cams.isReady and not inGameOver) then return end
	
	if (cams.game.lockToMustHit) then
		cams.game.follow.x = getProperty("camFollow.x")
		cams.game.follow.y = getProperty("camFollow.y")
	end
end)

function cameraFromString(cam)
	if (type(cam) ~= "string") then return type(cam) == "table" and cam or cams.game end
	cam = cam:lower()
	return (
			(cam:find("hud") or cam:sub(#cam - 3, #cam) == "hud") and cams.hud or
			(cam:find("other") or cam:sub(#cam - 5, #cam) == "other") and cams.other
		)
		or cams.game
end

local function cameraShake(cam, int, dur, st)
	cam = cameraFromString(cam)
	cam.fxShakeIntensity = int
	cam.fxShakeDuration = dur - (type(st) == "number" and songPos - st or 0)
end

--[[ EVENTS AND STUFFS ]]--
curEventsStep = 0
events = {}

-- supports for changebpm later
function fixEvents()
	for i,event in pairs(events) do
		if (type(event[1]) == "string") then
			local woah = event[1]:sub(1,1):lower()
			if (woah == "s") then
				event[1] = (stepC*tonumber(event[1]:sub(2,256)))
			elseif (woah == "b") then
				event[1] = (stepC*4*tonumber(event[1]:sub(2,256)))
			end
		end
	end
	
	table.sort(events, function(a, b)return a[1]<b[1] end)
end

function eventsTick()
	if (not getProperty("startingSong") and not getProperty("endingSong")) then
		if curEventsStep+1 <= #events then
			for i = curEventsStep+1,#events do
				local t = events[curEventsStep+1][1]
				if (type(t) == "number") then
					if songPos < t then break else
						curEventsStep = curEventsStep + 1
						printdebug("Passed Event #"..curEventsStep)
						events[curEventsStep][2]()
					end
				end
			end
		end
	end
end

--[[ WINDOW ]]--
function setWindowProperty(p, v)
	setPropertyFromClass("lime.app.Application","current.window." .. p, v)
end

function getWindowProperty(p)
	return getPropertyFromClass("lime.app.Application","current.window." .. p)
end

templateWindow = setmetatable(
	{
		x = 0,
		y = 0,
		
		width = 0,
		height = 0,
		
		fullscreen = false,
		borderless = false,
		fps = 0,
		
		title = "",
		
		forcePos = false,
		forceSize = false
	},
	{
		__index = function(t, i)
			if (i == "mouseLock") then
				return getWindowProperty("mouseLock")
			elseif (i == "maximized") then
				return getWindowProperty("maximized")
			elseif (i == "fps") then
				return getWindowProperty("frameRate")
			elseif (i == "fullscreen") then
				return getWindowProperty("fullscreen")
			end
			return rawget(t, i)
		end,
		__newindex = function(t, i, v)
			if (i == "mouseLock") then
				setWindowProperty("mouseLock", v)
			elseif (i == "maximized") then
				setWindowProperty("maximized", v)
				if (not v) then
					setWindowProperty("minimized", v)
				end
			elseif (i == "fps") then
				setWindowProperty("frameRate", v)
			elseif (i == "fullscreen") then
				setWindowProperty("fullscreen", v)
			else
				rawset(t, i, v)
			end
		end
	}
)

defaultWindow = nil

windowDeltaUpdateCap, windowUpdateTime = 0, math.huge

window = tableCopy(templateWindow, nil, true)
window.isReady = false

function initializeWindow()
	screenWidth = getWindowProperty("display.currentMode.width")
	screenHeight = getWindowProperty("display.currentMode.height")
	
	window.x = getWindowProperty("x")
	window.y = getWindowProperty("y")
	
	window.width = getWindowProperty("width")
	window.height = getWindowProperty("height")
	
	window.borderless = getWindowProperty("borderless")
	window.title = getWindowProperty("title")
	window.title = window.title == nil or window.title == "" and "Friday Night Funkin': 3X3 REMIXED" or window.title
	
	windowDeltaUpdateCap = window.fps
	
	defaultWindow = tableCopy(window, {}, false)
	defaultWindow.mouseLock = window.mouseLock
	defaultWindow.maximized = window.maximized
	defaultWindow.fullscreen = window.fullscreen
	defaultWindow.fps = window.fps
	
	window.isReady = true
end

function updateWindow(dt, force)
	if (not window.isReady) then return end
	windowUpdateTime = windowUpdateTime + dt
	
	local canUpdate = force or windowUpdateTime > windowDeltaUpdateCap
	
	-- Miscs
	if (window.borderless ~= getWindowProperty("__borderless")) then setWindowProperty("borderless", window.borderless) end
	if (window.title ~= getWindowProperty("__title")) then setWindowProperty("title", window.title) end
	screenWidth = getWindowProperty("display.currentMode.width")
	screenHeight = getWindowProperty("display.currentMode.height")
	
	-- Position
	if (window.forcePos and canUpdate) then
		local fX, fY = math.floor(window.x), math.floor(window.y)
		
		local updateX = fX ~= getWindowProperty("__x")
		local updateY = fY ~= getWindowProperty("__y")
		
		if (updateX) then setWindowProperty(updateY and "__x" or "x", fX) end
		if (updateY) then setWindowProperty("y", fY) end
	else
		window.x = getWindowProperty("__x")
		window.y = getWindowProperty("__y")
	end
	
	if (window.forceSize and canUpdate) then
		local fX, fY = math.floor(window.width), math.floor(window.height)
		
		local updateX = fX ~= getWindowProperty("__width")
		local updateY = fY ~= getWindowProperty("__height")
		
		if (updateX) then setWindowProperty(updateY and "__width" or "width", fX) end
		if (updateY) then setWindowProperty("height", fY) end
	else
		window.width = getWindowProperty("__width")
		window.height = getWindowProperty("__height")
	end
	
	if (canUpdate) then
		windowUpdateTime = 0
	end
end

function resetWindow(fullscreen)
	local lastForcePos, lastForceSize = window.forcePos, window.forceSize
	
	window.title = defaultWindow.title
	
	window.fullscreen = fullscreen
	if (not fullscreen) then
		window.forcePos, window.forceSize = true, true
		
		window.maximized = false
		window.width = gameWidth
		window.height = gameHeight
		window.x = (screenWidth / 2) - (window.width / 2)
		window.y = (screenHeight / 2) - (window.height / 2)
		
		updateWindow(0, true)
	end
	
	window.forcePos, window.forceSize = lastForcePos, lastForceSize
end

------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
--[[ TEMPLATE ]]--
ps.onCreate(function()
	realSongPos = getPropertyFromClass("Conductor","songPosition")
	songPos = realSongPos/1000
	stepC = stepCrochet/1000
	
	gameWidth = _G.screenWidth
	gameHeight = _G.screenHeight
	
	initializeWindow()
	
	local _t = {
		Vector3 = Vector3,
		CFrame = CFrame,
		Point = Point,
		Matrix = Matrix,
		
		cameraShake = cameraShake,
		easing = easing,
		tweenNumber = tn.tweenNumber
	}
	
	for i, v in pairs(PsychCalls) do
		_t[v] = ps[v]
	end
	
	local fenv = setmetatable(_t, {
		__index = getfenv(), 
		__newindex = function(_, i, v)
			getfenv()[i] = v
		end,
		__metatable = false
	})
	
	local env = loadScript("../../../../../assets/preload/modcharts/" .. formatToSongPath(songName) .. "/main", fenv, false, true)

	if (env == false) then
		env = loadScript("modcharts/" .. formatToSongPath(songName) .. "/main", fenv, false, true)
	end
	if (env == false) then
		return close(false)
	end
end)

-- to make sure if it hasnt been initialized yet
local realCreatePostS = false
local onCreatePostFoo = function()
	if (not realCreatePostS) then getfenv().onCreatePost() end
end

inGameOver = false
ps.onGameOverStart(function()
	inGameOver = true
	
	tn.tweenNumber(bfOffsetCam, "x", 0, 0, 0, -10000)
	tn.tweenNumber(dadOffsetCam, "x", 0, 0, 0, -10000)
	tn.tweenNumber(bfOffsetCam, "y", 0, 0, 0, -10000)
	tn.tweenNumber(dadOffsetCam, "y", 0, 0, 0, -10000, nil, function()
		bfOffsetCam.x = 0
		bfOffsetCam.y = 0
		
		dadOffsetCam.x = 0
		dadOffsetCam.y = 0
	end)
	
	cams.game.scroll.x = 0
	cams.game.scroll.y = 0
	cams.game.lockToFollow = false
	
	local COOL
	COOL = ps.onUpdate(function()
		if (
			getProperty("boyfriend.animation.curAnim.name") == "firstDeath" and
			getProperty("boyfriend.animation.curAnim.curFrame") >= 12
		) then
			cams.game.lockToFollow = true
			cams.game.scroll.x = (gameWidth / 2)
			cams.game.scroll.y = (gameHeight / 2)
			COOL()
		end
	end, true)
end)

ps.onCreatePost(function()
	realCreatePostS = true
	
	initializeStrums()
	initializeCams()
end)
onStartCountdown(onCreatePostFoo)
onCountdownTick(onCreatePostFoo)

ps.onSongStart(function()
	stepC = stepCrochet/1000
	
	eventsTick()
end)

ps.onStepHit(function()
	stepC = stepCrochet/1000
end)

ps.onUpdate(function(dt)
	if (not realCreatePostS) then onCreatePostFoo() end
	realSongPos = getSongPosition and getSongPosition() or getPropertyFromClass("Conductor","songPosition")
	songPos = realSongPos/1000
	
	updateCamsLerp(dt)
	--[[
	--strums.bf.scale = Vector3.new(math.cos(songPos * 12) / 3 + .675, math.cos(songPos * 8) / 3 + .675, 1)
	--strums.dad.scale = Vector3.new(math.cos(songPos * 12) / 3 + .675, math.cos(songPos * 8) / 3 + .675, 1)
	
	--strums.bf.rotation = Vector3.new(songPos * 165, songPos * 97, songPos * 152)
	--strums.dad.rotation = Vector3.new(songPos * 121, songPos * 112, songPos * 186)
	
	strums.bf.rotation = Vector3.new(30, 0)--songPos * 120)
	strums.dad.rotation = Vector3.new(30, 0)--songPos * 120)
	
	strums.bf.float = 3
	strums.bf.drift = 3
	strums.bf.tipsy = 3
	
	strums.dad.float = 3
	strums.dad.drift = 3
	strums.dad.tipsy = 3]]
end)

ps.onUpdatePost(function(dt)
	updateCams(dt)
	if (not inGameOver) then updateStrums(dt) end
	
	eventsTick()
	tn.tick()
	
	updateWindow(dt)
end, true)


--[[ yaayyayy ]]--
--getfenv().onCreate()