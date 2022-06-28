local defaultNotePos = {};

function onEndSong()
	if not allowEnd then
		startVideo('illgetyou');
		allowEnd = true;
		return Function_Stop;
	end
	return Function_Continue;
end

function onSongStart()
    for i = 0,7 do 
        x = getPropertyFromGroup('strumLineNotes', i, 'x')
 
        y = getPropertyFromGroup('strumLineNotes', i, 'y')
 
        table.insert(defaultNotePos, {x,y})
    end
end

function onStepHit()
    if curStep == 1296 then
        -- PEP START
        for i = 4,7 do setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i - 3][1]) end
        for i = 0,3 do setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 5][1]) end
        setProperty('boyfriendGroup.flipX', true)
        setProperty('dadGroup.flipX', true)
        setProperty('dadGroup.x', 1100)
        setProperty('boyfriendGroup.x', -300)
    end
    if curStep == 2832 then
        -- PEP START
        for i = 0,7 do setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1]) end
        setProperty('boyfriendGroup.flipX', false)
        setProperty('dadGroup.flipX', false)
        setProperty('dadGroup.x', -200)
        setProperty('boyfriendGroup.x', 1200)
    
        makeLuaSprite('topBar', '', 0, -100)
        makeGraphic('topBar', 1280, 80, '000000')
        setObjectCamera('topBar', 'hud')
        addLuaSprite('topBar', true)
        doTweenY('zoomdown', 'topBar', 0, 0.4, 'circInOut')

        for i = 0,7 do 
            setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2] + (downscroll and -40 or 40)) 
        end

        makeLuaSprite('botBar', '', 0, 720)
        makeGraphic('botBar', 1280, 80, '000000')
        setObjectCamera('botBar', 'hud')
        addLuaSprite('botBar', true)
        doTweenY('zoomup', 'botBar', 640, 0.4, 'circInOut')

        doTweenAlpha('bye1', 'iconP1', 0, 0.4, 'circInOut')
        doTweenAlpha('godbye', 'laneUnderlayP1', 0, 0.4, 'circInOut')
        doTweenAlpha('helo', 'laneUnderlayP2', 0, 0.4, 'circInOut')
        doTweenAlpha('bye2', 'iconP2', 0, 0.4, 'circInOut')
        doTweenY('scoreup', 'scoreTxt', (downscroll and 115.2 or 610.4), 0.4, 'circInOut')
    end
    if curStep == 4111 then
        doTweenAlpha('bye1', 'iconP1', 1, 0.4, 'circInOut')
        doTweenAlpha('godbye', 'laneUnderlayP1', getPropertyFromClass('ClientPrefs', 'laneUnderlay'), 0.4, 'circInOut')
        doTweenAlpha('helo', 'laneUnderlayP2', getPropertyFromClass('ClientPrefs', 'laneUnderlay'), 0.4, 'circInOut')
        doTweenAlpha('bye2', 'iconP2', 1, 0.4, 'circInOut')
        doTweenY('scoreup', 'scoreTxt', (downscroll and 79.2 or 640.8), 0.4, 'circInOut')
        
        doTweenY('yeet', 'topBar', 0, 0.4, 'circInOut')
        doTweenY('gbye', 'botBar', 720, 0.4, 'circInOut')
    end
end

function onGameOver()
    setProperty('health', -500);
    math.randomseed(os.clock()/4.0)
    local num = math.random(1,16)
    local name = tostring(num)
    playSound(name, 1, 'deathquote')
end

function onUpdate()

    songPos = getSongPosition()
    currentBeat = (songPos/5000)*(curBpm/60)

    if curStep > 2832 then
        -- SHAYA END
    end
end
