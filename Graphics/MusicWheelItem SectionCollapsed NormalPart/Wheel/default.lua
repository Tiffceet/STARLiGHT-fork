local SongAttributes = LoadModule"SongAttributes.lua"

local t = Def.ActorFrame{
  LoadActor("Backing")..{
    SetMessageCommand=function(self, param)
		  local group = param.Text;
      self:diffuse(SongAttributes.GetGroupColor(group));
    end;
  }
};

t[#t+1] = Def.ActorFrame{
  Def.BitmapText{
		Font="_avenirnext lt pro bold 25px";
		InitCommand=cmd(halign,0;x,-420;maxwidth,250/0.8;wrapwidthpixels,2^24;zoom,2);
		SetMessageCommand=function(self, param)
		  local group = param.Text;
   		self:diffuse(SongAttributes.GetGroupColor(group));
		self:settext(SongAttributes.GetGroupName(group));
	end;
	};
}

return t;
