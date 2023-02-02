local args = {...};
local graphic = args[1];
local pn = args[2];

local steps_changed = sesub("CurrentStepsChanged%MessageCommand",pn);

return Def.ActorFrame{
    SetCommand=function(self,param)
		self.CurSong = param.Song;
        self:queuecommand "DiffChange";
	end;
	LoadActor(graphic)..{
		InitCommand=function(s) s:draworder(1):visible(false); end;
		DiffChangeCommand = function(self)
			local cur_song = self:GetParent().CurSong;
			local steps = SameDiffSteps(cur_song, pn);
            self:visible(steps~=nil);
			if steps then
				self:diffuse(CustomDifficultyToColor(steps:GetDifficulty()));
			end;
		end;
		[steps_changed]=function(s) s:queuecommand('DiffChange') end,
		CurrentSongChangedMessageCommand=function(s) s:queuecommand('DiffChange') end,
	};
	Def.BitmapText{
		InitCommand=function(s) s:draworder(2); end;
		Font="_avenirnext lt pro bold 25px";
		DiffChangeCommand=function(self)
			local cur_song = self:GetParent().CurSong;
			local steps = SameDiffSteps(cur_song, pn);
            self:visible(steps~=nil);
			if steps then
				self:settext(steps:GetMeter());
				if ThemePrefs.Get("WheelType") == "A" then
					self:diffuse(CustomDifficultyToColor(steps:GetDifficulty()));
					self:zoom(0.75);
				else
					self:diffuse(color("#FFFFFF")):zoom(1)
				end;
			end;
		end;
		[steps_changed]=function(s) s:queuecommand('DiffChange') end,
		CurrentSongChangedMessageCommand=function(s) s:queuecommand('DiffChange') end,
	};
};
