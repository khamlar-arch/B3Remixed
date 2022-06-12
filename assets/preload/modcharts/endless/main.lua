-- sorry guys if the modchart looks boring
-- ralt

events = {
	{0, function()
		coolioZoom = cams.game.followZoom
		tweenNumber(cams.game, "followZoom", cams.game.followZoom, coolioZoom + .15, stepC * 8, 0, easing.outCubic)
		
		strums.bf.modsOffset = stepC * 8
		strums.dad.modsOffset = stepC * 8
		
		cams.game.zoomBeatOffsetSteps = 8
		cams.hud.zoomBeatOffsetSteps = 8
		cams.other.zoomBeatOffsetSteps = 8
	end},
	{"s4", function()
		strums.bf.beat = 1
		strums.dad.beat = 1
		
		for i, v in pairs(strums) do
			tweenNumber(v, "float", 0, .4, stepC * 4, nil, easing.outCubic)
			tweenNumber(v, "drift", 0, .4, stepC * 4, nil, easing.outCubic)
		end
	end},
	{"s8", function()
		EVF1 = function(dt)
			cams.game.followZoom = coolioZoom + (mustHitSection and 0 or .07)
		end
		EVUF1 = onUpdate(EVF1)
	end},
	{"s264", function()
		clearUnusedMemory()
		
		tweenNumber(strums.bf, "x", defaultStrums.bf.x, defaultStrums.bf.x + 100, stepC * 8, stepC * 264, easing.outCubic)
		tweenNumber(strums.bf.scale.proxy, "x", 1, .7, stepC * 8, stepC * 264, easing.outCubic)
		tweenNumber(strums.bf.scale.proxy, "y", 1, .7, stepC * 8, stepC * 264, easing.outCubic)
		tweenNumber(strums.bf.noteScales, "x", 1, .7, stepC * 8, stepC * 264, easing.outCubic)
		tweenNumber(strums.bf.noteScales, "y", 1, .7, stepC * 8, stepC * 264, easing.outCubic)
		tweenNumber(strums.bf, "alpha", 1, .7, stepC * 8, stepC * 264, easing.outCubic)
		
		tweenNumber(strums.dad, "x", defaultStrums.dad.x, defaultStrums.dad.x + 100, stepC * 8, stepC * 264, easing.outCubic)
	end},
	{"s312", function()
		tweenNumber(strums.dad.rotation.proxy, "x", 0, 360, stepC * 14, stepC * 312, easing.outQuad)
		tweenNumber(strums.dad.rotation.proxy, "z", 0, 180, stepC * 16, stepC * 312, easing.outCubic)
	end},
	{"s320", function()
		tweenNumber(strums.dad.rotation.proxy, "y", 0, 180, stepC * 14, stepC * 320, easing.outQuad, function()
			strums.dad.rotation = Vector3.new(0, 180, 180)
		end)
	end},
	{"s392", function()
		tweenNumber(strums.dad, "x", strums.dad.x, defaultStrums.dad.x - 100, stepC * 8, stepC * 392, easing.outCubic)
		tweenNumber(strums.dad.scale.proxy, "x", 1, .7, stepC * 8, stepC * 392, easing.outCubic)
		tweenNumber(strums.dad.scale.proxy, "y", 1, .7, stepC * 8, stepC * 392, easing.outCubic)
		tweenNumber(strums.dad.noteScales, "x", 1, .7, stepC * 8, stepC * 392, easing.outCubic)
		tweenNumber(strums.dad.noteScales, "y", 1, .7, stepC * 8, stepC * 392, easing.outCubic)
		tweenNumber(strums.dad, "alpha", 1, .7, stepC * 8, stepC * 392, easing.outCubic)
		
		tweenNumber(strums.bf, "x", strums.bf.x, defaultStrums.bf.x - 100, stepC * 8, stepC * 392, easing.outCubic)
		tweenNumber(strums.bf.scale.proxy, "x", .7, 1, stepC * 8, stepC * 392, easing.outCubic)
		tweenNumber(strums.bf.scale.proxy, "y", .7, 1, stepC * 8, stepC * 392, easing.outCubic)
		tweenNumber(strums.bf.noteScales, "x", .7, 1, stepC * 8, stepC * 392, easing.outCubic)
		tweenNumber(strums.bf.noteScales, "y", .7, 1, stepC * 8, stepC * 392, easing.outCubic)
		tweenNumber(strums.bf, "alpha", .7, 1, stepC * 8, stepC * 392, easing.outCubic)
	end},
	{"s440", function()
		tweenNumber(strums.bf.rotation.proxy, "x", 0, 360, stepC * 14, stepC * 440, easing.outQuad)
		tweenNumber(strums.bf.rotation.proxy, "z", 0, -180, stepC * 16, stepC * 440, easing.outCubic)
	end},
	{"s448", function()
		tweenNumber(strums.bf.rotation.proxy, "y", 0, -180, stepC * 14, stepC * 448, easing.outQuad, function()
			strums.bf.rotation = Vector3.new(0, 180, 180)
		end)
	end},
	{"s512", function()
		strums.dad.rotation = Vector3.new(0, 0, 0)
		strums.bf.rotation = Vector3.new(0, 0, 0)
		
		strums.dad.scale.proxy.y = -1
		strums.bf.scale.proxy.y = -1
		
		tweenNumber(strums.dad.scale.proxy, "y", -.7, 1, stepC * 10, stepC * 512, easing.outQuad)
		tweenNumber(strums.bf.scale.proxy, "y", -1, 1, stepC * 10, stepC * 512, easing.outQuad)
	end},
	{"s520", function()
		clearUnusedMemory()
		
		tweenNumber(strums.dad, "x", strums.dad.x, defaultStrums.dad.x, stepC * 8, stepC * 520, easing.outCubic)
		tweenNumber(strums.dad.scale.proxy, "x", .7, 1, stepC * 8, stepC * 520, easing.outCubic)
		tweenNumber(strums.dad.scale.proxy, "y", strums.dad.scale.y, 1, stepC * 8, stepC * 520, easing.outCubic)
		tweenNumber(strums.dad.noteScales, "x", .7, 1, stepC * 8, stepC * 520, easing.outCubic)
		tweenNumber(strums.dad.noteScales, "y", .7, 1, stepC * 8, stepC * 520, easing.outCubic)
		tweenNumber(strums.dad, "alpha", .7, 1, stepC * 8, stepC * 520, easing.outCubic)
		
		tweenNumber(strums.bf, "x", strums.bf.x, defaultStrums.bf.x, stepC * 8, stepC * 520, easing.outCubic)
	end},
	{"s888", function()
		cams.game.lockToMustHit = false
		cams.game.follow.x = getProperty("gf.width") / 2 + getProperty("gf.x")
		cams.game.follow.y = getProperty("gf.height") / 2 + getProperty("gf.y")
		
		strums.bf.beat = 0
		strums.dad.beat = 0
		EVUF1()
		
		cams.game.followZoom = coolioZoom + .2
		
		uhm = function(st)
			tweenNumber(strums.bf.noteScales, "x", 1.2, 1, stepC * 2, st, easing.linear)
			tweenNumber(strums.bf.noteScales, "y", 1.2, 1, stepC * 2, st, easing.linear)
			
			tweenNumber(strums.dad.noteScales, "x", 1.2, 1, stepC * 2, st, easing.linear)
			tweenNumber(strums.dad.noteScales, "y", 1.2, 1, stepC * 2, st, easing.linear)
		end
		
		uhm(stepC * 888)
	end},
	{"s892", function()
		cams.game.followZoom = coolioZoom + .35
		
		uhm(stepC * 892)
	end},
	{"s896", function()
		cams.game.followZoom = coolioZoom + .5
		
		dadx = getProperty("dad.x")
		dady = getProperty("dad.y")
		
		boyfriendx = getProperty("boyfriend.x")
		boyfriendy = getProperty("boyfriend.y")
		
		doTweenX('dadTweenOut', 'dad', -1500, stepC * 5, 'cubein')
		doTweenX('boyfriendTweenOut', 'boyfriend', 2000, stepC * 5, 'cubein')
		
		strums.bf.beat = 1
		strums.dad.beat = 1
		
		uhm(stepC * 896)
	end},
	{"s900", function()
		tweenNumber(cams.game, "followZoom", cams.game.followZoom, coolioZoom, stepC * 8, stepC * 900, easing.outBack)
		tweenNumber(cams.game, "followZoomSpeed", 8, 1, stepC * 16, stepC * 900, easing.linear)
		
		uhm(stepC * 900)
		
		for i, v in pairs(strums) do
			tweenNumber(v, "tipsy", 0, 1, stepC * 4, stepC * 900, easing.outBack)
		end
		
		evf2bfspeed = 1
		evf2dadspeed = 1
		evf2bfi = songPos - (stepC * 900)
		evf2dadi = songPos - (stepC * 900)
		
		evf2bfpower = 0
		evf2dadpower = 0
		
		evf2bfrotpower = 0
		evf2dadrotpower = 0
		
		tweenNumber(nil, "evf2bfpower", 0, 1, stepC * 4, stepC * 900, easing.linear)
		tweenNumber(nil, "evf2dadpower", 0, 1, stepC * 4, stepC * 900, easing.linear)
		
		EVF2 = function(dt)
			evf2bfi = evf2bfi + (dt * evf2bfspeed)
			evf2dadi = evf2dadi + (dt * evf2dadspeed)
			
			local bfv = evf2bfi * curBpm / 60 * math.pi / 4
			local dadv = evf2dadi * curBpm / 60 * math.pi / 4
			
			strums.bf.rotation = Vector3.new(math.cos(bfv) * 25 * evf2bfpower, math.sin(bfv) * 25 * evf2bfpower, math.sin(bfv) * 25 * evf2bfrotpower)
			strums.dad.rotation = Vector3.new(math.cos(dadv) * 25 * evf2dadpower, math.sin(dadv) * 25 * evf2dadpower, math.sin(dadv) * 25 * evf2dadrotpower)
		end
		EVUF2 = onUpdate(EVF2)
		
		WOAHBEAT = false
		
		evf3WOAH = function(ss)
			for i, v in pairs(strums) do
				tweenNumber(v, "float", 1, .2, stepC * 4, nil, easing.outCubic)
				tweenNumber(v, "drift", 1, .2, stepC * 4, nil, easing.outCubic)
				
				if (WOAHBEAT) then
					local ss = math.fmod(curStep + 8, 16)
					if (ss == 0 or ss == 8) then
						tweenNumber(v, "noteAngles", 10, 0, stepC * 4, nil, easing.outCubic)
						for i, v in pairs(v.lines) do
							v.receptor.y = 0
						end
					elseif (ss == 4 or ss == 12) then
						tweenNumber(v, "noteAngles", -10, 0, stepC * 4, nil, easing.outCubic)
					end
				end
			end
			uhm(curStep * stepC)
		end
		
		evf3WOW = function()
			for i, v in pairs(strums) do
				tweenNumber(v, "float", .3, .2, stepC * 4, nil, easing.outCubic)
				tweenNumber(v, "drift", .3, .2, stepC * 4, nil, easing.outCubic)
			end
		end
		
		EVF3 = function()
			local v = math.fmod(curStep + 8, 8)
			if (v == 0) then
				evf3WOAH()
			end
			
			if (v == 4) then
				if (WOAHBEAT) then evf3WOAH()
				else evf3WOW() end
			end
		end
		EVUF3 = onStepHit(EVF3)
		
		for i, v in pairs(strums) do
			tweenNumber(v, "float", 1, 0, stepC * 4, nil, easing.outCubic)
			tweenNumber(v, "drift", 1, 0, stepC * 4, nil, easing.outCubic)
		end
	end},
	{"s902", function()
		doTweenAlpha('lightShutOff', 'lightShut', 0.35, 0.25, 'linear')
		
		healthBary = getProperty("healthBar.y")
		iconP1y = getProperty("iconP1.y")
		iconP2y = getProperty("iconP2.y")
		timeBary = getProperty("timeBar.y")
		timeTxty = getProperty("timeTxt.y")
		
		setProperty('scoreTxt.visible', false)
		addLuaText('infiniteFun', true)
		doTweenY('healthBarThingy', 'healthBar', 1000, 0.25, 'linear')
		doTweenY('iconP1Thingy', 'iconP1', 1000, 0.25, 'linear')
		doTweenY('iconP2Thingy', 'iconP2', 1000, 0.25, 'linear')
		doTweenY('songPosBar1', 'timeBar', -100, 0.25, 'linear')
		doTweenY('songPosBar2', 'timeTxt', -100, 0.25, 'linear')

		setObjectCamera('dad', 'hud')
		setProperty('dad.x', -175)
		setProperty('dad.y', 50 + 600)
		setObjectCamera('boyfriend', 'hud')
		setProperty('boyfriend.x', 850)
		setProperty('boyfriend.y', 400 + 600)
		if (curStep < 909) then
			doTweenY('dadTweenIn', 'dad', 50, 0.25, 'linear')
			doTweenY('boyfriendTweenIn', 'boyfriend', 400, 0.25, 'linear')
		end
	end},
	{"s904", function()
		cams.game.zoomBeatSteps = 8
		cams.hud.zoomBeatSteps = 8
		cams.other.zoomBeatSteps = 8
	end},
	{"s909", function()
		cancelTween("dadTweenOut")
		cancelTween("boyfriendTweenOut")
		
		cancelTween("dadTweenIn")
		cancelTween("boyfriendTweenIn")
		
		setProperty('dad.y', 50)
		setProperty('boyfriend.y', 400)
	end},
	{"s1032", function()
		tweenNumber(nil, "evf2dadspeed", 1, 2, stepC * 8, stepC * 1032, easing.linear)
		tweenNumber(nil, "evf2dadpower", 1, 1.25, stepC * 4, stepC * 1032, easing.linear)
		tweenNumber(nil, "evf2dadrotpower", 0, .7, stepC * 8, stepC * 1032, easing.linear)
	end},
	{"s1096", function()
		tweenNumber(nil, "evf2dadspeed", 1.5, 1, stepC * 8, stepC * 1096, easing.linear)
		tweenNumber(nil, "evf2dadpower", 1.25, 1, stepC * 4, stepC * 1096, easing.linear)
		tweenNumber(nil, "evf2dadrotpower", .7, .15, stepC * 4, stepC * 1096, easing.linear)
		
		tweenNumber(nil, "evf2bfspeed", 1, 2, stepC * 8, stepC * 1096, easing.linear)
		tweenNumber(nil, "evf2bfpower", 1, 1.25, stepC * 4, stepC * 1096, easing.linear)
		tweenNumber(nil, "evf2bfrotpower", 0, .7, stepC * 8, stepC * 1096, easing.linear)
	end},
	{"s1144", function()
		tweenNumber(nil, "evf2bfspeed", 1.5, 1, stepC * 8, stepC * 1144, easing.linear)
		tweenNumber(nil, "evf2bfpower", 1.25, 1, stepC * 4, stepC * 1144, easing.linear)
		tweenNumber(nil, "evf2bfrotpower", .7, .15, stepC * 4, stepC * 1144, easing.linear)
	end},
	{"s1146", function()
		doTweenAlpha('lightShutLol', 'lightShut', 0.5, 0.25, 'linear')
		screenCenter('infiniteFun', 'XY')
		setProperty('infiniteFun.alpha', 0)
		setTextSize('infiniteFun', 40)
		setTextString('infiniteFun', 'Fun is INFINITE!\n- The B3 Dev(il) Team')
		doTweenAlpha('funIsINFINITE', 'infiniteFun', 1, 0.25, 'circInOut')
	end},
	{"s1160", function()
		clearUnusedMemory()
		
		cams.game.zoomBeatSteps = 16
		cams.hud.zoomBeatSteps = 16
		cams.other.zoomBeatSteps = 16
		
		evf2bfi = songPos - (stepC * 1160)
		evf2dadi = songPos - (stepC * 1160)
		
		cams.game.lockToMustHit = true
		EVUF1 = onUpdate(EVF1)
		
		cameraFlash('other', 'FFFFFF', 0.2, true)
		setObjectCamera('dad', 'game')
		setProperty('dad.x', dadx)
		setProperty('dad.y', dady)
		setObjectCamera('boyfriend', 'game')
		setProperty('boyfriend.x', boyfriendx)
		setProperty('boyfriend.y', boyfriendy)
		
		removeLuaText('infiniteFun', true)
		setProperty('scoreTxt.visible', true)
		doTweenAlpha('lightShutON', 'lightShut', 0, 0.25, 'linear')
		doTweenY('healthBarThingy', 'healthBar', healthBary, 0.25, 'linear')
		doTweenY('iconP1Thingy', 'iconP1', iconP1y, 0.25, 'linear')
		doTweenY('iconP2Thingy', 'iconP2', iconP2y, 0.25, 'linear')
		doTweenY('songPosBar1', 'timeBar', timeBary, 0.25, 'linear')
		doTweenY('songPosBar2', 'timeTxt', timeTxty, 0.25, 'linear')
	end},
	{"s1416", function()
		cams.game.zoomBeatSteps = 8
		cams.hud.zoomBeatSteps = 8
		cams.other.zoomBeatSteps = 8
		
		cams.game:zoomBeat()
		cams.hud:zoomBeat()
		
		WOAHBEAT = true
		
		tweenNumber(nil, "evf2bfspeed", 1, 1, stepC * 8, stepC * 1096, easing.linear)
		tweenNumber(nil, "evf2bfpower", 1, 1.1, stepC * 4, stepC * 1096, easing.linear)
		tweenNumber(nil, "evf2bfrotpower", .15, .5, stepC * 8, stepC * 1096, easing.linear)
		
		tweenNumber(nil, "evf2dadspeed", 1, 1, stepC * 8, stepC * 1096, easing.linear)
		tweenNumber(nil, "evf2dadpower", 1, 1.1, stepC * 4, stepC * 1096, easing.linear)
		tweenNumber(nil, "evf2dadrotpower", .15, .5, stepC * 8, stepC * 1096, easing.linear)
		
		evf4section = 0
		evf4offset = 8
		EVF4 = function()
			local inSection = math.fmod((curStep + evf4offset) / 16, 4)
			inSection = inSection < evf4section + 1 and inSection >= evf4section
			
			if (inSection) then
				local v = math.fmod(curStep + evf4offset, 16)
				
				for i, v in pairs(strums) do
					v.invert = 0
				end
				
				if (v == 6 or v == 9 or v == 14) then
					evf3WOAH()
					for i, v in pairs(strums) do
						tweenNumber(v, "noteAngles", -10, 0, stepC * 4, nil, easing.outCubic)
						if (v == 9) then
							v.invert = -.15
						end
					end
					
				elseif (v == 7 or v == 10 or v == 15) then
					evf3WOAH()
					for i, v in pairs(strums) do
						tweenNumber(v, "noteAngles", 10, 0, stepC * 4, nil, easing.outCubic)
						tweenNumber(v, "float", -1, .2, stepC * 4, nil, easing.outCubic)
						tweenNumber(v, "drift", -1, .2, stepC * 4, nil, easing.outCubic)
						
						for i, v in pairs(v.lines) do
							v.receptor.y = getRandomFloat(-45, 45)
						end
					end
				end
			end
		end
		
		EVUF4 = onStepHit(EVF4)
	end},
	{"s1672", function()
		cams.game.zoomBeatSteps = 4
		cams.hud.zoomBeatSteps = 4
		cams.other.zoomBeatSteps = 4
		
		cams.game:zoomBeat()
		cams.hud:zoomBeat()
		
		cams.game.lockToMustHit = false
		cams.game.follow.x = getProperty("gf.width") / 2 + getProperty("gf.x")
		cams.game.follow.y = getProperty("gf.height") / 2 + getProperty("gf.y")
		
		evf3WOW()
		
		cams.game.followZoom = coolioZoom + .2
		uhm(stepC * 1672)
		
		EVUF3()
		EVUF1()
		
		tweenNumber(nil, "evf2bfpower", 1.1, .25, stepC * 4, stepC * 1672, easing.linear)
		tweenNumber(nil, "evf2bfrotpower", .5, .15, stepC * 8, stepC * 1672, easing.linear)
		
		tweenNumber(nil, "evf2dadpower", 1.1, .25, stepC * 4, stepC * 1672, easing.linear)
		tweenNumber(nil, "evf2dadrotpower", .5, .15, stepC * 8, stepC * 1672, easing.linear)
	end},
	{"s1676", function()
		cams.game.followZoom = coolioZoom + .35
		uhm(stepC * 1676)
		
		evf3WOW()
	end},
	{"s1680", function()
		cams.game.followZoom = coolioZoom + .5
		uhm(stepC * 1680)
		
		evf3WOW()
	end},
	{"s1684", function()
		cams.game.followZoom = coolioZoom
		uhm(stepC * 1684)
		
		cams.game.zoomBeatSteps = 8
		cams.hud.zoomBeatSteps = 8
		cams.other.zoomBeatSteps = 8
		
		for i, v in pairs(strums) do
			tweenNumber(v, "float", -2, .2, stepC * 4, nil, easing.outCubic)
			tweenNumber(v, "drift", -2, .2, stepC * 4, nil, easing.outCubic)
		end
		
		tweenNumber(nil, "evf2bfpower", .25, 1.1, stepC * 4, stepC * 1684, easing.linear)
		tweenNumber(nil, "evf2bfrotpower", .15, .5, stepC * 8, stepC * 1684, easing.linear)
		
		tweenNumber(nil, "evf2dadpower", .25, 1.1, stepC * 4, stepC * 1684, easing.linear)
		tweenNumber(nil, "evf2dadrotpower", .15, .5, stepC * 8, stepC * 1684, easing.linear)
	end},
	{"s1688", function()
		EVUF1 = onUpdate(EVF1)
		EVUF3 = onStepHit(EVF3)
		
		evf4section = 1
		evf4offset = 8
	end},
	{"s1816", function()
		tweenNumber(nil, "evf2dadspeed", 1, 2, stepC * 8, stepC * 1816, easing.linear)
		tweenNumber(nil, "evf2dadpower", 1.1, 1.25, stepC * 4, stepC * 1816, easing.linear)
		tweenNumber(nil, "evf2dadrotpower", .5, .7, stepC * 8, stepC * 1816, easing.linear)
	end},
	{"s1880", function()
		tweenNumber(nil, "evf2dadspeed", 2, 1, stepC * 8, stepC * 1880, easing.linear)
		tweenNumber(nil, "evf2dadpower", 1.25, 1.1, stepC * 4, stepC * 1880, easing.linear)
		tweenNumber(nil, "evf2dadrotpower", .7, .5, stepC * 8, stepC * 1880, easing.linear)
		
		tweenNumber(nil, "evf2bfspeed", 1, 2, stepC * 8, stepC * 1880, easing.linear)
		tweenNumber(nil, "evf2bfpower", 1.1, 1.25, stepC * 4, stepC * 1880, easing.linear)
		tweenNumber(nil, "evf2bfrotpower", .5, .7, stepC * 8, stepC * 1880, easing.linear)

		EVF4()
		EVUF4()
	end},
	{"s1944", function()
		tweenNumber(nil, "evf2bfspeed", 2, 1, stepC * 8, stepC * 1944, easing.linear)
		tweenNumber(nil, "evf2bfpower", 1.25, 1.1, stepC * 4, stepC * 1944, easing.linear)
		tweenNumber(nil, "evf2bfrotpower", .7, .5, stepC * 8, stepC * 1944, easing.linear)
		
		WOAHBEAT = false
		cams.game.lockToMustHit = true
		EVUF1()
		
		cams.game.followZoom = coolioZoom + .2
	end},
	{"s1974", function()
		tweenNumber(nil, "evf2bfspeed", 1, 0, stepC * 16, stepC * 1974, easing.linear)
		tweenNumber(nil, "evf2bfpower", 1.1, 0, stepC * 16, stepC * 1974, easing.outCubic)
		tweenNumber(nil, "evf2bfrotpower", .5, 0, stepC * 16, stepC * 1974, easing.outCubic)
		
		tweenNumber(nil, "evf2dadspeed", 1, 0, stepC * 16, stepC * 1974, easing.linear)
		tweenNumber(nil, "evf2dadpower", 1.1, 0, stepC * 16, stepC * 1974, easing.outCubic)
		tweenNumber(nil, "evf2dadrotpower", .5, 0, stepC * 16, stepC * 1974, easing.outCubic, function()
			EVUF2()
			EVF2(1 / 120)
		end)
		
		cams.game.lockToMustHit = false
		cams.game.follow.x = getProperty("gf.width") / 2 + getProperty("gf.x")
		cams.game.follow.y = getProperty("gf.height") / 2 + getProperty("gf.y")
		cams.game.followZoom = coolioZoom
		
		cams.game.zoomOnBeat = false
		cams.hud.zoomOnBeat = false
		cams.other.zoomOnBeat = false
		
		strums.bf.beat = 0
		strums.dad.beat = 0
		
		for i, v in pairs(strums) do
			tweenNumber(v, "float", .2, 0, stepC * 16, nil, easing.outCubic)
			tweenNumber(v, "drift", .2, 0, stepC * 16, nil, easing.outCubic)
		end
		
		clearUnusedMemory()
		EVUF3()
	end}
}

fixEvents()

onCreate(function()
	makeLuaSprite('lightShut', '', 0, 0)
	makeGraphic('lightShut', 1280, 720, '000000')
	setObjectCamera('lightShut', 'other')
	setProperty('lightShut.alpha', 0)
	addLuaSprite('lightShut', true)

	makeLuaText('infiniteFun', 'Fun: Infinite | Fun: Infinite | Fun: Infinite | Fun: Infinite | Fun: Infinite | Fun: Infinite | Fun: Infinite', 1400, 0, 680)
	setTextAlignment('infiniteFun', 'center')
	setObjectCamera('infiniteFun', 'hud')
	screenCenter('infiniteFun', 'X')
	setTextSize('infiniteFun', 20)
	
	clearUnusedMemory()
end)