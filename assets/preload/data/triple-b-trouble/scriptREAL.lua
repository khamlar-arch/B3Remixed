local defaultNotePos = {};

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
        setProperty('dadGroup.x', getProperty('dad.x') + 1300)
        setProperty('boyfriendGroup.x', getProperty('boyfriend.x') - 1500)
    end
    if curStep == 2832 then
        -- PEP START
        for i = 0,7 do setPropertyFromGroup('strumLineNotes', i, 'x', defaultNotePos[i + 1][1]) end
        setProperty('boyfriendGroup.flipX', false)
        setProperty('dadGroup.flipX', false)
        setProperty('dadGroup.x', getProperty('dad.x') - 1300)
        setProperty('boyfriendGroup.x', getProperty('boyfriend.x') + 1500)
    end
end

function onUpdate()

    songPos = getSongPosition()
    currentBeat = (songPos/5000)*(curBpm/60)

    if curStep > 2832 then
        -- SHAYA END
    end
end
