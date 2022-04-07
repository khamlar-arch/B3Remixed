local defaultNotePos = {};
 
function onCreate()
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
end
function onSongStart()
    for i = 0,7 do 
        x = getPropertyFromGroup('strumLineNotes', i, 'x')
 
        y = getPropertyFromGroup('strumLineNotes', i, 'y')
 
        table.insert(defaultNotePos, {x,y})
    end
end

function onUpdate()
    songPos = getPropertyFromClass('Conductor', 'songPosition');
    currentBeat = (songPos / 1000) * (bpm / 60)

    if curStep > 902 and curStep < 1160 then
        for i = 0,7 do 
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1] + 5 * math.sin((currentBeat + i*0.25) * math.pi))
            setPropertyFromGroup('strumLineNotes', i, 'y', defaultNotePos[i + 1][2] + 5 * math.cos((currentBeat + i*0.25) * math.pi))
        end
    end
    if curStep > 888 and curStep < 1033 then
        -- Happens through all the steps
        triggerEvent('Camera Follow Pos', 500, 600)
    end
    if curStep > 1033 and curStep < 1160 then
        -- Yeah
        triggerEvent('Camera Follow Pos', 500, 100)
    end
    if curStep == 887 then
        triggerEvent('Hide Ratings', '', '')
        -- Right before the event
        dadx = getProperty('dad.x') + getProperty('dad.offset.x')
        dady = getProperty('dad.y') + getProperty('dad.offset.y')
        boyfriendx = getProperty('boyfriend.x') + getProperty('boyfriend.offset.x')
        boyfriendy = getProperty('boyfriend.y') + getProperty('boyfriend.offset.y')
    end
    if curStep == 888 then
        -- 3!
        setProperty('defaultCamZoom', 0.75)
    end
    if curStep == 892 then
        -- 2!
        setProperty('defaultCamZoom', 0.9)
    end
    if curStep == 896 then
        -- 1!
        doTweenX('dadTweenOut', 'dad', -1500, 0.25, 'linear')
        doTweenX('boyfriendTweenOut', 'boyfriend', 1500, 0.25, 'linear')
        setProperty('defaultCamZoom', 1.6)
    end
    if curStep == 902 then
        -- Finished
        doTweenAlpha('lightShutOff', 'lightShut', 0.35, 0.25, 'linear')

        setProperty('scoreTxt.visible', false)
        addLuaText('infiniteFun', true)
        doTweenY('healthBarThingy', 'healthBar', 1000, 0.25, 'linear')
        doTweenY('iconP1Thingy', 'iconP1', 1000, 0.25, 'linear')
        doTweenY('iconP2Thingy', 'iconP2', 1000, 0.25, 'linear')
        doTweenY('songPosBar1', 'timeBar', -100, 0.25, 'linear')
        doTweenY('songPosBar2', 'timeTxt', -100, 0.25, 'linear')

        setProperty('defaultCamZoom', 1.1)

        setObjectCamera('dad', 'hud')
        setProperty('dad.x', -175)
        setProperty('dad.y', 50 + 600)
        setObjectCamera('boyfriend', 'hud')
        setProperty('boyfriend.x', 850)
        setProperty('boyfriend.y', 400 + 600)
        doTweenY('dadTweenIn', 'dad', 50, 0.25, 'linear')
        doTweenY('boyfriendTweenIn', 'boyfriend', 400, 0.25, 'linear')
    end
    if curStep == 1033 then
        -- Completed fast part
    end
    if curStep == 1146 then
        -- har har funny megalo
        doTweenAlpha('lightShutLol', 'lightShut', 0.5, 0.25, 'linear')
        screenCenter('infiniteFun', 'XY')
        setProperty('infiniteFun.alpha', 0)
        setTextSize('infiniteFun', 40)
        setTextString('infiniteFun', 'Fun is INFINITE!\n- The B3 Dev(il) Team')
        doTweenAlpha('funIsINFINITE', 'infiniteFun', 1, 0.25, 'circInOut')
    end
    if curStep == 1160 then
        cameraFlash('other', 'FFFFFF', 0.2, true)
        -- Completed other fast part
        setProperty('defaultCamZoom', 0.6)
        triggerEvent('Camera Follow Pos', '', '')
        setObjectCamera('dad', 'game')
        setProperty('dad.x', dadx)
        setProperty('dad.y', dady)
        setObjectCamera('boyfriend', 'game')
        setProperty('boyfriend.x', boyfriendx)
        setProperty('boyfriend.y', boyfriendy)

        triggerEvent('Hide Ratings', '', '')
        removeLuaText('infiniteFun', true)
        setProperty('scoreTxt.visible', true)
        doTweenAlpha('funIsINFINITE', 'infiniteFun', 0, 0.1, 'circInOut')
        doTweenAlpha('lightShutON', 'lightShut', 0, 0.25, 'linear')
        doTweenY('healthBarThingy', 'healthBar', 645, 0.25, 'linear')
        doTweenY('iconP1Thingy', 'iconP1', 570, 0.25, 'linear')
        doTweenY('iconP2Thingy', 'iconP2', 570, 0.25, 'linear')
        doTweenY('songPosBar1', 'timeBar', 31, 0.25, 'linear')
        doTweenY('songPosBar2', 'timeTxt', 19, 0.25, 'linear')
    end
end