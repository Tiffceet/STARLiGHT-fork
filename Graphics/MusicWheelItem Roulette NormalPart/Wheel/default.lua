local t = Def.ActorFrame{
  LoadActor(THEME:GetPathG("","MusicWheelItem SectionCollapsed NormalPart/Wheel/Backing"))..{
    InitCommand=cmd(diffuse,Color.Green)
  }
};

t[#t+1] = Def.ActorFrame{
  Def.BitmapText{
		Font="_avenirnext lt pro bold 25px";
		InitCommand=cmd(halign,0;x,-420;maxwidth,250/0.8;wrapwidthpixels,2^24;zoom,2);
		SetMessageCommand=function(self, param)
      self:settext(THEME:GetString("MusicWheel","Roulette"))
      self:diffuse(Color.Green)
    end;
	};
}

return t;
