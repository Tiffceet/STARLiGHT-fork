local args = {...};
local graphic = args[1];
local pn = args[2];

return LoadActor(graphic)..{
    InitCommand=function(self)
        self:visible(false);
        if #(GAMESTATE:GetHumanPlayers()) == 2 then
            if pn == PLAYER_1 then
                self:cropright(0.5);
            elseif pn == PLAYER_2 then
                self:cropleft(0.5);
            end;
        end;
    end;
	SetCommand=function(self,param)
		self.cur_song = param.Song;
		self:queuecommand "DiffChange";
	end;
    DiffChangeCommand=function(self)
        local steps = SameDiffSteps(self.cur_song, pn);
		self:visible(steps ~= nil);
        if steps then
            self:diffuse(ClearLampColors[ClearLamp(self.cur_song, steps, pn)]);
        end;
    end;
	[sesub("CurrentStepsChanged%MessageCommand",pn)]=cmd(queuecommand,"DiffChange");
	CurrentSongChangedMessageCommand=cmd(queuecommand,"DiffChange");
};
