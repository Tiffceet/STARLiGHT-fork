-- Relative amount of meteors to create
local starriness = 1.0

-- Scale based on how much sky is visible
local nMeteors = ((_screen.h > 720) and (_screen.h+260)/49 or _screen.w/64) * starriness

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


--
-- Screen ActorFrame starts here
--

local t = Def.ActorFrame{}

-- Diagonal of the screen (= diameter of the background rotation circle)
local d = math.sqrt(_screen.h^2 + _screen.w^2)

t[#t+1] = LoadActor("bg") .. {
	-- Make sure the sky fills the entire screen, with room to rotate
	InitCommand = cmd(scaletocover,0,0,d,d;Center),
	OnCommand = cmd(queuecommand,"Animate"),
	AnimateCommand = cmd(rotationz,0;linear,720;rotationz,360;queuecommand,"Animate"),
}

-- Add meteors
for _ = 1, nMeteors do
	t[#t+1] = meteor()
end

t[#t+1] = LoadActor("violetwave") .. {
	-- Continually scrolling texture
	InitCommand = cmd(TileX,_screen.w;
		xy,_screen.cx,_screen.cy-215;
		texcoordvelocity,0.1,0),
}

t[#t+1] = LoadActor("bluewave") .. {
	-- Also continually scrolling
	InitCommand = cmd(diffusealpha,0.9;TileX,_screen.w;
		valign,1;xy,_screen.cx,_screen.cy+170;
		texcoordvelocity,0.2,0),
}

t[#t+1] = LoadActor("glow") .. {
	InitCommand = cmd(zoomtowidth,_screen.w;
		valign,1;xy,_screen.cx,_screen.cy+130)
}

t[#t+1] = LoadActor("ground") .. {
	-- Make sure the ground graphic covers the entire ground :)
	InitCommand = cmd(valign,0;
		zoomto,_screen.w,_screen.cy-130;
		xy,_screen.cx,_screen.cy+130),
}

-- Mask for rotating reflection
t[#t+1] = Def.Quad {
	InitCommand = cmd(stretchto,0,0,_screen.w,_screen.cy+130;MaskSource,true),
}

-- Rotating reflection
t[#t+1] = LoadActor("bg") .. {
	InitCommand = cmd(scaletocover,0,0,d,-d;xy,_screen.cx,_screen.cy+260;
		diffusealpha,0.15;MaskDest),
	OnCommand = cmd(queuecommand,"Animate"),
	AnimateCommand = cmd(rotationz,0;linear,720;rotationz,360;queuecommand,"Animate"),
}

t[#t+1] = ClearZ


-- Ring animations came from the previous themer
t[#t+1] = LoadActor("ring1") .. {
	InitCommand = cmd(diffusealpha,0),
	OnCommand = cmd(rotationz,0;zoom,0.5;
		x,math.random(_screen.w);y,math.random(_screen.h);
		sleep,math.random(2)+1;
		linear,0.5;
		rotationz,180;zoom,0.6;diffusealpha,0.5;
		decelerate,0.5;
		rotationz,math.random(89)+270;zoom,0.65;
		diffusealpha,0;queuecommand,"On"),
}
t[#t+1] = LoadActor("ring2") .. {
	InitCommand = cmd(diffusealpha,0),
	OnCommand = cmd(rotationz,0;zoom,0.5;
		x,math.random(_screen.w);y,math.random(_screen.h);
		sleep,math.random(3);
		linear,0.5;
		rotationz,180;zoom,0.6;diffusealpha,0.5;
		decelerate,0.5;
		rotationz,math.random(89)+270;zoom,0.65;
		diffusealpha,0;queuecommand,"On");
}
t[#t+1] = LoadActor("ring3") .. {
	InitCommand = cmd(diffusealpha,0),
	OnCommand = cmd(rotationz,0;zoom,0.5;
		x,math.random(_screen.w);y,math.random(_screen.h);
		sleep,math.random(2);
		linear,0.5;
		rotationz,180;zoom,0.6;diffusealpha,0.5;
		decelerate,0.5;
		rotationz,math.random(89)+270;zoom,0.65;
		diffusealpha,0;queuecommand,"On");
}
t[#t+1] = LoadActor("ring4") .. {
	InitCommand = cmd(diffusealpha,0),
	OnCommand = cmd(rotationz,0;zoom,0.5;
		x,math.random(_screen.w);y,math.random(_screen.h);
		sleep,math.random(3)+1;
		linear,0.5;
		rotationz,180;zoom,0.6;diffusealpha,0.5;
		decelerate,0.5;
		rotationz,math.random(89)+270;zoom,0.65;
		diffusealpha,0;queuecommand,"On");
}

return t
