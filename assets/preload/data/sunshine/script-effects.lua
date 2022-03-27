local defaultNotePos = {};

function onSongStart()
    for i = 0,7 do 
        x = getPropertyFromGroup('strumLineNotes', i, 'x')
        y = getPropertyFromGroup('strumLineNotes', i, 'y')
        table.insert(defaultNotePos, {x,y})
    end
end

function onCreate()
    makeLuaSprite('lightShut', '', 0, 0)
    makeGraphic('lightShut', 1280, 720, '000000')
    setObjectCamera('lightShut', 'other')
    setProperty('lightShut.visible', false)
    addLuaSprite('lightShut', true)

    makeLuaSprite('vignette', 'vignette', 0, 0)
    setObjectCamera('vignette', 'other')
    scaleObject('vignette', 2, 2)
    setProperty('vignette.visible', false)
    addLuaSprite('vignette', true)
end

function onUpdate()
    songPos = getSongPosition()
    local currentBeat = (songPos/5000)*(curBpm/60)

    if curStep == 586 then
        triggerEvent('Hide Ratings', '', '')
        triggerEvent('Change Character', '0', 'Tailsalt')
        triggerEvent('Change Scroll Speed', 0.75, 0.2)
        triggerEvent('Tails', '1', '')
        setProperty('boyfriendGroup.visible', false)
        setProperty('lightShut.visible', true)
        for i = 0,3 do
            setPropertyFromGroup('strumLineNotes', i, 'x', -1000)
        end
        for i = 4,7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', -20 + (110 * i))
        end
        setProperty('vignette.visible', true)
        showUI(false)
    end
    if curStep < 856 and curStep >= 587 then
        for i = 4,7 do 
            noteTweenAlpha('superCoolEffectThingLol' .. i, i, math.abs(math.sin((currentBeat+1*0.1)*math.pi)) + 0.25, 1.1)
        end
        doTweenAlpha('vignetteThing', 'vignette', math.abs(math.sin((currentBeat+1*0.035)*math.pi)) + 0.25, 2)
    end
    if curStep == 592 or curStep == 861 then
        setProperty('lightShut.visible', false)
    end
    if curStep == 858 then
        triggerEvent('Hide Ratings', '', '')
        triggerEvent('Change Character', '0', 'Tails')
        triggerEvent('Tails', '2', '')
        triggerEvent('Change Scroll Speed', 1, 0.2)
        setProperty('boyfriendGroup.visible', true)
        for i = 4,7 do 
            cancelTween('superCoolEffectThingLol' .. i)
            setPropertyFromGroup('strumLineNotes', i, 'alpha', 1)
        end
        setProperty('lightShut.visible', true)
        setProperty('vignette.visible', false)
        showUI(true)
        for i = 0,7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1])
        end
    end
end

function showUI(bool)
    setProperty('healthBar.visible', bool)
    setProperty('healthBarBG.visible', bool)
    setProperty('iconP1.visible', bool)
    setProperty('iconP2.visible', bool)
    setProperty('timeBar.visible', bool)
    setProperty('timeBarBG.visible', bool)
    setProperty('scoreTxt.visible', bool)
    setProperty('timeTxt.visible', bool)
end