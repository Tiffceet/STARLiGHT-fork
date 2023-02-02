local t = Def.ActorFrame {InitCommand=function(s) s:zoom(0.5) end,};
local jk = LoadModule "Jacket.lua"

t[#t+1] = Def.ActorFrame{
	LoadActor("cd/cd_mask")..{
		InitCommand=cmd(blend,Blend.NoEffect;zwrite,1;clearzbuffer,true;zoom,1;);
	};
	Def.Banner{
		Name="SongCD";
		SetMessageCommand=function(self,params)
			self:ztest(1)
			local song = params.Song;
			if song then
				local songtit = params.Song:GetDisplayMainTitle();
				if CDImage[songtit] ~= nil then
					local diskImage = CDImage[songtit];
					self:Load(THEME:GetPathG("","MusicWheelItem Song NormalPart/Jukebox/cd/"..diskImage));
					self:setsize(475,475);
				else
				--Fallback to Jacket/BG or just load the fallback cd.
					--Verify Jacket
					if jk.GetSongGraphicPath(song) then
						self:Load(jk.GetSongGraphicPath(song))
						:setsize(475,475)
					else
						--Fallback CD
						self:Load(THEME:GetPathG("", "MusicWheelItem Song NormalPart/Jukebox/cd/fallback"));
						self:setsize(475,475);
					end;
				end;
			end;
		end;
	};

	--Overlay
	Def.ActorFrame{
		Name="CdOver";
		InitCommand=cmd(zoom,1);
		LoadActor(THEME:GetPathG("", "MusicWheelItem Song NormalPart/Jukebox/cd/overlay"))..{
			SetMessageCommand=function(self,params)
				local song = params.Song;
				if song then
					local songtit = params.Song:GetDisplayMainTitle();
					if CDImage[songtit] ~= nil then
						self:visible(false)
					else
						self:visible(true)
					end;
				else
					self:visible(false)
				end;
			end;
		};
	};

};

t[#t+1] = Def.ActorFrame{
	SetCommand=function(s,params)
		local song = params.Song
		if song then
			if song:IsLong() or song:IsMarathon() then
				s:visible(true)
			else
				s:visible(false)
			end
		end
	end,
	Def.BitmapText{
		Font="Common normal",
		InitCommand=function(s) s:diffuse(Color.White):strokecolor(Alpha(Color.Black,0.5)):xy(160,50) end,
		SetMessageCommand=function(s,p)
			local song = p.Song
			local text;
			if song then
				if song:IsLong() then
					text = "Long ver."
				elseif song:IsMarathon() then
					text = "Single ver."
				else
					text = ""
				end
			else
				text = ""
			end
			s:settext(text)
		end
	},
};

return t;
