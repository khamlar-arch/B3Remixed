function onCreate()
    curDadY = getProperty('dad.y')
end

function onUpdate(elapsed)
    songPos = getSongPosition()
    local currentBeat = (songPos/5000)*(curBpm/60)

    doTweenY('tailsFly', 'dad', curDadY - 150*math.sin((currentBeat+12*12)*math.pi), 2)
end
