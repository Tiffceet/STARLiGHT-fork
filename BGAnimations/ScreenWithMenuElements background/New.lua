-- Relative amount of meteors to create
local starriness = 1

-- Scale based on how much sky is visible
local nMeteors = ((_screen.h > 1080) and (_screen.h+260)/49 or _screen.w/64) * starriness

-- Definition of a meteor

local function meteor()
	local m = Def.ActorFrame {
		InitCommand = cmd(valign,1),
		OnCommand = cmd(sleep,math.random()*2;queuecommand,"Animate"),
		AnimateCommand = cmd(
			-- Random size between half- and full-size, weighted toward full
			zoom,0.5 + 0.5 * math.sqrt(math.random());
			-- Appear somewhere random
			xy,math.random(_screen.w)+40,math.random(_screen.h/2);
			-- Move in the direction of the arrow, slowing down when
			-- it starts to burn out.  (Note: this is slightly
			-- below the 42° angle of the arrow, because I like the
			-- resultant "falling" effect.)
			linear,0.3; addx,-100; addy,100;
			linear,0.15; addx,-60; addy,60;
			-- Wait a random amount of time
			sleep,math.random()*5;
			-- and start again
			queuecommand,"Animate"),
	}

	m[#m+1] = LoadActor("meteor-arrow") .. {
		AnimateCommand = cmd(
			-- Start partially visible
			diffusealpha,0;
			-- Come into sight
			linear,0.15; diffusealpha,0.7;
			-- Let the glow brighten (see below)
			sleep,0.15;
			-- Burn out
			linear,0.15; diffusealpha,0),
	}

	m[#m+1] = LoadActor("meteor-glow") .. {
		AnimateCommand = cmd(
			-- Glow is almost white, with a chance of being tinted slightly.
			-- Invisible to start with.
			diffuse,HSVA(360*math.random(), 0.4*math.random(), 1, 0);
			-- Don't start to glow until the meteor's fully visible
			sleep,0.15;
			-- Flare up!
			linear,0.15; diffusealpha,1;
			-- Burn out
			linear,0.15; diffusealpha,0),
	}

	return m
end

local t = Def.ActorFrame{
	LoadActor("background")..{
		InitCommand=cmd(FullScreen);
	};
};

-- Add meteors
for _ = 1, nMeteors do
	t[#t+1] = meteor()
end

t[#t+1] = ClearZ
return t;
