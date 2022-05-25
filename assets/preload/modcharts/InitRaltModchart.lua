--[[
	me (raltyro) awesome abndnb aepic smodcharr templtate :Dc
	
	real init script is below
	modcharts/_objs/init.lua
--]]

currentModDir = nil
masterPath = debug.getinfo(1).source:sub(2):reverse()
masterPath = masterPath:sub(masterPath:find("/", 1, true) + 1, #masterPath)
if (masterPath:reverse() == "assets/modcharts") then -- LOCAL ASSETS
	masterPath = masterPath:sub(masterPath:find("/", 1, true) + 1, #masterPath)
elseif (masterPath:sub(1, 4) ~= "sdom") then
	currentModDir = masterPath:sub(1, masterPath:find("/", 1, true) - 1):reverse()
	masterPath = masterPath:sub(masterPath:find("/", 1, true) + 1, #masterPath)
end
masterPath = masterPath:reverse()

function _readFile(loc)
	local file = io.open(loc, "rb")
	if (file) then
		local str = file:read("*all")
		file:close()
		return str
	end
end

function readFile(loc, ignoreModFolders, ignoreMods)
	return ignoreMods and _readFile(loc) or (
			currentModDir ~= nil and not ignoreModFolders and
			_readFile(masterPath .. "/" .. currentModDir .. "/" .. loc)
				or
			_readFile(masterPath .. "/" .. loc)
		)
end

function _fileExists(loc)
	local file = io.open(loc, "rb")
	if (file) then
		file:close()
		return true
	end
	return false
end

function fileExists(loc, ignoreModFolders, ignoreMods)
	return ignoreMods and _fileExists(loc) or (
			currentModDir ~= nil and not ignoreModFolders and
			_fileExists(masterPath .. "/" .. currentModDir .. "/" .. loc)
				or
			_fileExists(masterPath .. "/" .. loc)
		)
end

function getPath(loc, ignoreModFolders, ignoreMods)
	return ignoreMods and loc or (
		currentModDir ~= nil and not ignoreModFolders and _fileExists(masterPath .. "/" .. currentModDir .. "/" .. loc) and
		masterPath .. "/" .. currentModDir .. "/" .. loc
			or
		masterPath .. "/" .. loc
	)
end

local _loadstring = _G.loadstring
local _loadfile = _G.loadfile
if (_loadfile == nil and _loadstring ~= nil) then
	_loadfile = function(path)
		return _loadstring(_readFile(path), path)
	end
end

local function genReq(loaded)
	return function(path, env)
		local _d = debug.getinfo(2)
		local src = _d.source
		src = src:sub(1, 1) == "@" and src:sub(2) or src
		--[[dirs[src] = dirs[src] or dir]]
		local dir = src:reverse()
		dir = dir:sub(dir:find("/", 1, true) + 1, #dir):reverse()
		
		if (path:sub(#path - 3):lower() ~= ".lua") then
			path = path .. ".lua"
		end
		
		local dpath = dir .. "/" .. path
		if (not _fileExists(dpath)) then
			dpath = dpath:sub(1, #dpath - 4) .. "/init.lua"
			if (not _fileExists(dpath)) then
				dpath = path
				if (not _fileExists(dpath)) then
					dpath = dpath:sub(1, #dpath - 4) .. "/init.lua"
				end
			end
		end
		
		local locL = dpath:lower()
		if (loaded[locL]) then
			return loaded[locL]
		end
		
		local coo = loadfile(dpath, true, true)
		
		if (type(env) == "table") then
			setfenv(coo, env)
		end
		local _env = getfenv(coo)
		if (_env.package and _env.package.loaded) then
			_env.package.loaded = loaded
		end
		if (type(_env._G) == "table" and type(env) ~= "table") then
			_env._G = getfenv(_d.func)
		end
		
		local s, r = pcall(coo)
		loaded[locL] = (s and r ~= nil) and r or getfenv(coo)
		
		return loaded[locL], coo
	end
end

function loadfile(loc, ignoreModFolders, ignoreMods)
	if (_loadfile == nil) then return error("Oops loadfile doesn't exists") end
	
	local dir = getPath(loc, ignoreModFolders, ignoreMods)
	local foo, w = _loadfile(dir)
	
	if (type(foo) ~= "function") then
		error("Ooops: " .. w)
	end
	
	local wowFoo = foo
	
	local dir = dir:reverse()
	dir = dir:sub(dir:find("/", 1, true) + 1, #dir):reverse()
	
	local _env = getfenv(wowFoo)
	local loaded = _env.package and _env.package.loaded or {}
	_env._G = _env
	
	if (not _env.coolRequire) then
		_env.require = genReq(loaded, wowFoo)
		_env.coolRequire = true
	end
	
	return wowFoo
end

function loadScript(loc, cenv, ignoreModFolders, forceReturnEnv, dontRun, ignoreLoaded)
	if (loc:sub(#loc - 3):lower() ~= ".lua") then
		loc = loc .. ".lua"
	end
	
	if (not fileExists(loc, ignoreModFolders)) then
		loc = loc:sub(1, #loc - 4) .. "/init.lua"
	end
	
	local locL = loc:lower()
	if (not ignoreLoaded and package.loaded[locL]) then
		return package.loaded[locL]
	end
	
	--[[
	local s, data = pcall(readFile, loc, ignoreModFolders)
	if (not s or data == "" or data == " " or data == nil) then
		s, data = pcall(readFile, loc:sub(1, #loc - 4) .. "/init.lua", ignoreModFolders)
	end
	if (not s or data == "" or data == " " or data == nil) then return false end
	local foo = loadstring(data)
	]]
	local s, foo = pcall(loadfile, loc, ignoreModFolders)
	if (not s or type(foo) ~= "function") then print(foo) return false end
	
	local env = getfenv(foo)
	local require = env.require
	
	if (type(cenv) ~= "table") then
		--setfenv(foo, getfenv())
	else
		setfenv(foo, cenv)
		env = cenv
	end
	if (cenv == nil or cenv.require == nil or cenv ~= getfenv()) then env.require = require end
	
	if (dontRun) then
		return foo
	end
	
	local s, r = pcall(foo)
	package.loaded[locL] = (s and r == nil) and env or r
	
	if (forceReturnEnv) then return env end
	return package.loaded[locL], foo
end

local mainEnv

local function callB(n, ...)
	if (type(mainEnv) == "table" and type(mainEnv[n]) == "function") then
		pcall(mainEnv[n], ...)
	end
end

local function localOnCreate()
	-- LMAO DONT RUN THE SCRIPT TWICE!!
	for i = 0, getProperty("luaArray.length") - 1 do
		local scriptName = getPropertyFromGroup("luaArray", i, "scriptName"):reverse()
		scriptName = scriptName:sub(1, scriptName:find("/", 1, true) - 1):reverse()
		
		if (scriptName == "InitRaltModchart.lua") then
			return close(false)
		end
	end
	
	if (currentModDir == nil) then
		currentModDir = getPropertyFromClass("Paths", "currentModDirectory")
		currentModDir = currentModDir == "" and nil or currentModDir
	end
	
	local s, w = pcall(function()
		mainEnv = loadScript("../../../../../assets/preload/modcharts/_objs", getfenv(), false, true)
		
		if (mainEnv == false) then
			mainEnv = loadScript("modcharts/_objs", getfenv(), false, true)
		end
	end)
	if (not s) then close(false) print(w) end
	--if (type(mainEnv) == "table") then mainEnv.PsychCalls = PsychCalls end
	if (onCreate ~= localOnCreate) then callB("onCreate") end
end
onCreate = localOnCreate

--[[
--- asfildasioghasghasig HELP ME
local function template1(n)
	return function(...)
		callB(n, ...)
	end
end
]]

PsychCalls = {
	"onDestroy",
	"onCreate",
	"onCreatePost",
	"onBeatHit",
	"onStepHit",
	"onUpdate",
	"onUpdatePost",
	"onSongStart",
	"onEndSong",
	"onGameOver",
	"onGameOverStart",
	"onGameOverConfirm",
	"onStartCountdown",
	"onCountdownStarted",
	"onCountdownTick",
	"onMoveCamera",
	"onTweenCompleted",
	"onSoundFinished",
	"onTimerCompleted",
	"onEvent",
	"onRecalculateRating",
	"onNextDialogue",
	"onSkipDialogue",
	"onResume",
	"onPause",
	"eventEarlyTrigger",
	"opponentNoteHit",
	"goodNoteHit",
	"noteMissPress",
	"noteMiss",
	"onKeyPress",
	"onKeyRelease"
}

--[[
for i, v in pairs(PsychCalls) do
	if (type(getfenv()[v]) ~= "function") then getfenv()[v] = template1(v) end
end]]