function cgProperty(i, v)
	return setProperty(i, getProperty(i) + v)
end

function cgPropertyFromGroup(o, id, i, v)
	return setPropertyFromGroup(o, id, i, getPropertyFromGroup(o, id, i) + v)
end

function cgPropertyFromClass(c, i, v)
	return setPropertyFromClass(c, i, getPropertyFromClass(c, i) + v)
end

function formatToSongPath(v)
	return v:lower():gsub("% ", "-")
end

printErrors = true

local function template1(t, cName)
	getfenv().foo = foo or function(tempT)
		return {
			__newindex = function(t, i, v)
				if (type(v) == "function") then
					if (running) then tempT[i] = v
					else rawset(t, i, v) end
				end
				error("no")
			end
		}
	end
	local foo = getfenv().foo
	
	t.last = {}
	
	local tempT = {}
	local tempTlast = {}
	
	local tMeta = foo(tempT)
	local tLastMeta = foo(tempTlast)
	
	setmetatable(t.last, tMeta)
	setmetatable(t, tLastMeta)
	
	local fooMeta = setmetatable({}, {__index = getfenv()})
	
	setfenv(tMeta.__newindex, fooMeta)
	setfenv(tLastMeta.__newindex, fooMeta)
	
	return function(...)
		--[[local vvv = {...}
		if (#vvv > 0) then print(cName, vvv) end
		if (type(vvv[1]) == "function") then
			print(debug.getinfo(vvv[1]))
		end]]
		
		getfenv(tMeta.__newindex).running = true
		getfenv(tLastMeta.__newindex).running = true
		
		local ret = Function_Continue
		
		for i,v in ipairs(t) do
			local success, val = pcall(v, ...)
			if (success and val ~= Function_Continue) then ret = val
			elseif (not success and printErrors) then print("Error! " .. val, debug.getinfo(v)) end
		end
		
		for i,v in ipairs(tempT) do
			local success, val = pcall(v, ...)
			if (success and val ~= Function_Continue) then ret = val
			elseif (not success and printErrors) then print("Error! " .. val, debug.getinfo(v)) end
		end
		
		for i,v in ipairs(t.last) do
			local success, val = pcall(v, ...)
			if (success and val ~= Function_Continue) then ret = val
			elseif (not success and printErrors) then print("Error! " .. val, debug.getinfo(v)) end
		end
		
		for i,v in ipairs(tempTlast) do
			local success, val = pcall(v, ...)
			if (success and val ~= Function_Continue) then ret = val
			elseif (not success and printErrors) then print("Error! " .. val, debug.getinfo(v)) end
		end
		
		getfenv(tMeta.__newindex).running = false
		getfenv(tLastMeta.__newindex).running = false
		
		for i,v in ipairs(tempT) do
			table.insert(t, v)
		end
		table.clear(tempT)
		
		for i,v in ipairs(tempTlast) do
			table.insert(t.last, v)
		end
		table.clear(tempTlast)
		
		--print(cName .. " end")
		
		return ret
	end
end

local function template2(t)
	return function(f, b)
		if (type(f) ~= "function") then return end
		
		if (b) then
			table.insert(t.last,f)
		else
			table.insert(t,f)
		end
		
		return function()
			if (b) then
				table.remove(t.last,table.find(t.last,f))
			else
				table.remove(t,table.find(t,f))
			end
			return nil
		end
	end
end

local cus = {}

for i, v in pairs(PsychCalls) do
	local funcs = {}
	getfenv()[v] = template1(funcs, v)
	cus[v] = template2(funcs)
end

return cus