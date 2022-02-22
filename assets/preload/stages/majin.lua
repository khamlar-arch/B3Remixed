function onCreate()
	-- background shit

	makeLuaSprite('floor', 'majin/floor', -2000,-500); 
	setScrollFactor('floor', 1, 1);
	scaleObject('floor', 1.3, 1.3);

	makeLuaSprite('banner', 'majin/banner', -450,-50); 
	setScrollFactor('banner', 1, 1);
	scaleObject('banner', 1.3, 1.3);

	makeAnimatedLuaSprite('mazins','majin/mazins', -550, 300);
	addAnimationByPrefix('mazins','move','mazins',24,true);
	scaleObject('mazins', 1.3, 1.3);

	makeLuaSprite('middlepillars', 'majin/middlepillars', -1350, -200); 
	setScrollFactor('middlepillars', 0.8, 0.9);
	scaleObject('middlepillars', 1.3, 1.3);

	makeAnimatedLuaSprite('backmazins','majin/backmazins', -1250, 450);
	addAnimationByPrefix('backmazins','move','backmazins',24,true);
	setScrollFactor('backmazins', 0.8, 1);
	scaleObject('backmazins', 1.3, 1.3);

	makeLuaSprite('backpillars', 'majin/backpillars', -1850, 100); 
	setScrollFactor('backpillars', 0.6, 0.9);
	scaleObject('backpillars', 1.3, 1.3);

	makeLuaSprite('walls', 'majin/walls',  -1700, -600); 
	setScrollFactor('walls', 0.4, 0.9);
	scaleObject('walls', 1.3, 1.3);

  	addLuaSprite('walls', false);
  	addLuaSprite('backpillars', false);
	addLuaSprite('backmazins',false);
  	addLuaSprite('middlepillars', false);
	addLuaSprite('mazins',false);
	addLuaSprite('banner', false);
	addLuaSprite('floor', false);
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end

function onBeatHit()
	objectPlayAnimation('backmazins','move',false);

	objectPlayAnimation('mazins','move',false);
end