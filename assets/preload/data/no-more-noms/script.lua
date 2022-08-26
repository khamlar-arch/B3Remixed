local gfx = 0

function onCreatePost()
    setProperty('skipCountdown', true)
    setProperty('camHUD.alpha', 0)
    makeLuaSprite('do', '', -900, -300)
    makeGraphic('do', 3000, 1500, '000000')
    addLuaSprite('do', true)

	setProperty('dad.alpha', 0)
	
    makeAnimatedLuaSprite('dada', 'characters/b3_gf_phase_3', getProperty('dad.x'), getProperty('dad.y'))
    addAnimationByPrefix('dada', 'talk', 'GF_TALK_START', 24 * (getPropertyFromClass("ClientPrefs", "dTime") and 1.5 or 1), false)
end

function onSongStart()
    setProperty('dada.y', getProperty('dada.y') + 295)
    setProperty('dada.x', getProperty('dada.x') + 150)
    addLuaSprite('dada')
    doTweenAlpha('voic', 'do', 0, 0.6, 'circInOut')
    characterPlayAnim('dad', 'talk', false)
    setProperty('dad.specialAnim', true)
    setProperty('camGame.zoom', 1.25)
    triggerEvent('Camera Follow Pos', 450, 500)
end

function onTimerCompleted(t, l, ll)
    if t == 'zoom' then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom') + 0.1)
        if ll == 0 then
            setProperty('defaultCamZoom', getProperty('defaultCamZoom') + 0.1)
            runTimer('zoomOut', 0.35, 4)
        end
    end
    if t == 'zoomOut' then
        setProperty('defaultCamZoom', getProperty('defaultCamZoom') - 0.1)
        if ll == 0 then
            for i = 0,7 do
                noteTweenAngle('WEEE'..i..curStep, i, (getPropertyFromGroup('strumLineNotes', i, 'angle') == 720 and 0 or 720), 0.5, 'circInOut')
            end
        end
    end
    if t == 'wee' then
        setProperty('cameraSpeed', getPropertyFromClass('ClientPrefs', 'camSpeed'))
    end
end

function math.lerp(a, b, t)
    return (b - a) * t + a;
end
function math.invlerp(a, b, t)
    return (t - a) / (b - a);
end

function onStepHit()
    if curStep == 56 then
        doTweenAlpha('cam', 'camHUD', 1, 0.5)
    end
    if curStep == 62 then
	    setProperty('do.y', 500)
    	setProperty('do.alpha', 1)
	    doTweenY('byebye', 'do', -2500, 1, 'cubeInOut')
    end
    if curStep == 64 then
        triggerEvent('Camera Follow Pos', '', '')
	    setProperty('dad.alpha', 1)
	    setProperty('dada.alpha', 0)
    end
    if curStep == 80 then
	    removeLuaSprite('do', true)
    end
    if curStep == 223 then
        setCameraPos(200, 500, true)
        setProperty('defaultCamZoom', 1.05)
        setProperty('camGame.zoom', 1.05)
    end
    if curStep == 476 then
        --setup bars and zoom
        setProperty('defaultCamZoom', 0.95)

        makeLuaSprite('topBar', '', 0, -100)
        makeGraphic('topBar', 1280, 100, '000000')
        setObjectCamera('topBar', 'hud')
        addLuaSprite('topBar')
        doTweenY('zoomdown', 'topBar', 0, 0.4, 'circInOut')

        setObjectCamera('fade', 'game')
        setProperty('fade.x', 0)
        setProperty('fade.y', -30)
        setProperty('fade.scale.x', 2)
        setProperty('fade.scale.y', 2.5)

        makeLuaSprite('botBar', '', 0, 720)
        makeGraphic('botBar', 1280, 100, '000000')
        setObjectCamera('botBar', 'hud')
        addLuaSprite('botBar', true)
        doTweenY('zoomup', 'botBar', 620, 0.4, 'circInOut')

        doTweenAlpha('bye1', 'iconP1', 0, 0.4, 'circInOut')
        doTweenAlpha('godbye', 'laneUnderlayP1', 0, 0.4, 'circInOut')
        doTweenAlpha('helo', 'laneUnderlayP2', 0, 0.4, 'circInOut')
        doTweenAlpha('bye2', 'iconP2', 0, 0.4, 'circInOut')
        doTweenY('scoreup', 'scoreTxt', 590, 0.4, 'circInOut')

        doTweenY('byebye', 'timeBar', -200, 0.4, 'circInOut')

        setProperty('STRUM_OFFSET', -323)


    end
    if curStep == 607 then
        doTweenY('yeet', 'topBar', -100, 0.4, 'circInOut')
        doTweenY('gbye', 'botBar', 720, 0.4, 'circInOut')
    end
    if curStep == 991 then
        doTweenAlpha('dadadada', 'camHUD', 0, 0.5, 'circInOut')
    end
end

function onUpdate()
    songPos = getPropertyFromClass('Conductor', 'songPosition');
    currentBeat = (songPos / 1000) * (bpm / 60)

    if curStep >= 65 and curStep < 191 then
        setProperty('camGame.zoom', math.lerp(getProperty('camGame.zoom'), 1.05, 0.000195))
        setProperty('defaultCamZoom', math.lerp(getProperty('defaultCamZoom'), 1.05, 0.00195))
    end
end