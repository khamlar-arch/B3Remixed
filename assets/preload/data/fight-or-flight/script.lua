function onCreatePost()

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

function onSongStart()
    for i = 0,7 do 
        x = getPropertyFromGroup('strumLineNotes', i, 'x')
 
        y = getPropertyFromGroup('strumLineNotes', i, 'y')
 
        table.insert(defaultNotePos, {x,y})
    end
end

function onStepHit()
    if curStep == 1 then
        for i = 4,7 do setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i - 3][1]) end
        for i = 0,3 do setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 5][1]) end
    end
end

