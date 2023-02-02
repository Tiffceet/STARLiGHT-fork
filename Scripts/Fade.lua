function Fade(inColor, inTime, waitTime, outTime, outColor)
	if inTime > 0 and outTime > 0 then
		-- Fade in and out
		return Def.Quad {
			InitCommand = cmd(FullScreen;diffuse,inColor),
			OnCommand = cmd(linear,inTime;diffusealpha,0;
				sleep,waitTime;diffusecolor,outColor;
				linear,outTime;diffuse,outColor),
		}
	elseif inTime > 0 then
		-- Just fade in
		return Def.Quad {
			InitCommand = cmd(FullScreen;diffuse,inColor),
			OnCommand = cmd(linear,inTime;diffusealpha,0),
		}
	elseif outTime > 0 then
		-- Just fade out
		return Def.Quad {
			InitCommand = cmd(FullScreen;diffuse,Color.Alpha(outColor,0)),
			OnCommand = cmd(sleep,waitTime;linear,outTime;diffuse,outColor),
		}
	end
end
