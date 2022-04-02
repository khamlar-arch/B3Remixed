local spin1 = false
local spin2 = false
local spincenter = false
local normal1 = false
local normal2 = false

function update (elapsed)
	local spin1 = false
	local spin2 = false
	local spincenter = false
	local normal1 = false
	local normal2 = false
	
	function update (elapsed)
		if spin1 then
			local currentBeat = (songPos / 1000)*(bpm/60)
			for i=0,3 do
				setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.25) * math.pi) + 360, i)
				setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.cos((currentBeat + i*0.25) * math.pi), i)
			end
		end
		if normal1 then
			for i=0,3 do
				setActorX(_G['defaultStrum'..i..'X'],i)
				setActorY(_G['defaultStrum'..i..'Y'],i)
			end
		end
		if spin2 then
			local currentBeat = (songPos / 1000)*(bpm/60)
			for i=4,7 do
				setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0.25) * math.pi) - 275, i)
				setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.cos((currentBeat + i*0.25) * math.pi), i)
			end
		end
		if normal2 then
			for i=4,7 do
				setActorX(_G['defaultStrum'..i..'X'],i)
				setActorY(_G['defaultStrum'..i..'Y'],i)
			end
		end
		if spincenter then
			local currentBeat = (songPos / 1000)*(bpm/60)
			for i=0,3 do
				setActorX(_G['defaultStrum'..i..'X'] + 300 * math.sin((currentBeat + i*5) * math.pi)+ 360, i)
				setActorY(_G['defaultStrum'..i..'Y'],i)
			end
			for i=4,7 do	
				setActorX(_G['defaultStrum'..i..'X'] - 300 * math.sin((currentBeat + i*5) * math.pi)- 275, i)
				setActorY(_G['defaultStrum'..i..'Y'],i)
			end
		end
	end
	
	
	function stepHit (step)
		if step == 1 then
		end
		if step == 2832 then
			spin1 = true
			normal1 = false
			showOnlyStrums = true
		end
		if step == 2896 then
			spin1 = false
			spin2 = true
		end
		if step == 2959 then
			normal1 = true
			normal2 = true
			spin2 = false
			showOnlyStrums = false
		end
	end
end