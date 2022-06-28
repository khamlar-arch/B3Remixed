sucked = false
function onStepHit()
    if curStep == 1400 then
        --setup bars and zoom
        setProperty('defaultCamZoom', 0.95)

        makeLuaSprite('topBar', '', 0, -100)
        makeGraphic('topBar', 1280, 100, '000000')
        setObjectCamera('topBar', 'hud')
        addLuaSprite('topBar')
        doTweenY('zoomdown', 'topBar', 0, 0.4, 'circInOut')

        makeLuaSprite('botBar', '', 0, 720)
        makeGraphic('botBar', 1280, 100, '000000')
        setObjectCamera('botBar', 'hud')
        addLuaSprite('botBar', true)
        doTweenY('zoomup', 'botBar', 620, 0.4, 'circInOut')

        doTweenAlpha('bye1', 'iconP1', 0, 0.4, 'circInOut')
        doTweenAlpha('bye2', 'iconP2', 0, 0.4, 'circInOut')
        doTweenY('scoreup', 'scoreTxt', 590, 0.4, 'circInOut')

        doTweenY('byebye', 'timeBar', -200, 0.4, 'circInOut')

        setProperty('STRUM_OFFSET', -323)


    end
    if curStep == 1408 then
        sucked = true
    end
    if curStep == 1696 then
        doTweenAlpha('dadadada', 'camHUD', 0, 0.5, 'circInOut')
        doTweenY('yeet', 'topBar', 0, 0.4, 'circInOut')
        doTweenY('gbye', 'botBar', 720, 0.4, 'circInOut')

    end
end

function math.lerp(a, b, t)
    return (b - a) * t + a;
end
function math.invlerp(a, b, t)
    return (t - a) / (b - a);
end

function onUpdate()
    if curStep > 1399 and curStep < 1408 then
        for i = 4,7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', math.lerp(getPropertyFromGroup('strumLineNotes', i, 'x'), 415 + (i - 4) * 112, 0.05))
            setPropertyFromGroup('strumLineNotes', i, 'angle', math.lerp(getPropertyFromGroup('strumLineNotes', i, 'angle'), 720, 0.08))
        end
        for i = 0,3 do
            setPropertyFromGroup('strumLineNotes', i, 'alpha', math.lerp(getPropertyFromGroup('strumLineNotes', i, 'alpha'), 0.2, 0.08))
        end
    end
    if sucked == true then
        setPropertyFromClass('ClientPrefs', 'hideHud', true);
    end
    if sucked == false then
        setPropertyFromClass('ClientPrefs', 'hideHud', false);
    end
end

function onUpdatePost()
    songPos = getSongPosition()
    local currentBeat = (songPos/5000)*(curBpm/60)

    if curStep > 1400 then
        for i = 0, getProperty('notes.length') - 1 do
            if getPropertyFromGroup('notes', i, 'mustPress') == false then
                setPropertyFromGroup('notes', i, 'copyAlpha', false);
                setPropertyFromGroup('notes', i, 'alpha', 0.2);
            end
        end
        for i = 0,3 do
            setPropertyFromGroup('strumLineNotes', i, 'x', (600 - 560*math.sin((currentBeat+1*0.1)*math.pi)) + ((i - 1.5) * 112))
            setPropertyFromGroup('strumLineNotes', i, 'y', (downscroll and 570 or 50) + 25 * math.cos((currentBeat + i*0.5) * (math.pi * 2)))
        end
    end
end

function onCreatePost()
    if sucked == true then
        setPropertyFromClass('ClientPrefs', 'hideHud', true);
    end
end

function onDestroy()
    setPropertyFromClass('ClientPrefs', 'hideHud', false);
end

function onGameOver()
	if sucked == true then
		setPropertyFromClass('ClientPrefs', 'hideHud', false);
	end
end
function onEndSong()
	if sucked == true then
		setPropertyFromClass('ClientPrefs', 'hideHud', false);
	end
end
function onPause()
	if sucked == true then
		setPropertyFromClass('ClientPrefs', 'hideHud', false);
	end
end
function onResume() -- lol put it back on
	if sucked == true then
		setPropertyFromClass('ClientPrefs', 'hideHud', true);
	end
end