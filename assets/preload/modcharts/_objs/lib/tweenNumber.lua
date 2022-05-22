local easing = require("easing")

local tweenReqs = {}

local function tnTick()
	local clock = songPos
	--print(songPos, #tweenReqs)
	if #tweenReqs > 0 then
		for i,v in next,tweenReqs do
			if v[1] == nil then
				table.remove(tweenReqs,i)
				if v[9] then
					v[9]()
				end
			else
				if clock>v[5]+v[6] then
					v[1][v[2]] =  v[7](v[6],v[3],v[4]-v[3],v[6])
					table.remove(tweenReqs,i)
					if v[9] then
						v[9]()
					end
				else
					v[1][v[2]] = v[7](clock-v[5],v[3],v[4]-v[3],v[6])
					--if (v[8]) then
					--	v[8] = false
					--	v[1][v[2]] = v[7](0,v[3],v[4]-v[3],v[6])
					--end
				end
			end
		end
	end
end

local function tweenNumber(maps, varName, startVar, endVar, time, startTime, easeF, onComplete)
	local clock = songPos
	maps = maps or getfenv()
	
	if #tweenReqs > 0 then
		for i2,v2 in next,tweenReqs do
			if v2[2] == varName and v2[1] == maps then
				v2[1][v2[2]] =  v2[7](v2[6],v2[3],v2[4]-v2[3],v2[6])
				table.remove(tweenReqs,i2)
				if v2[9] then
					v2[9]()
				end
				break
			end
		end
	end
	
	--print("Created TweenNumber: "..tostring(varName), startVar, endVar, time, startTime, type(onComplete) == "function")
	local t = {
		maps,
		varName,
		startVar,
		endVar,
		startTime or clock,
		time,
		easeF or easing.linear,
		true,
		onComplete
	}
	
	table.insert(tweenReqs,t)
	t[1][t[2]] = t[7](0,t[3],t[4]-t[3],t[6])
	
	return function()
		maps[varName] = t[7](v[6],t[3],t[4]-t[3],t[6])
		table.remove(tweenReqs,table.find(tweenReqs,t))
		if onComplete then
			onComplete()
		end
		return nil
	end
end

return {
	tick = tnTick,
	tweenNumber = tweenNumber
}