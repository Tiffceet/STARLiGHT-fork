local t = Def.ActorFrame{
  InitCommand=function(s) s:diffusealpha(0.5) end,
  LoadActor("door.png")..{
    Name="Top";
    InitCommand=function(s) s:valign(1):xy(_screen.cx,_screen.cy) end,
    AnOnCommand=function(s) s:y(_screen.cy-SCREEN_HEIGHT/2):decelerate(0.2):y(_screen.cy) end,
    AnOffCommand=function(s) s:y(_screen.cy):decelerate(0.2):y(_screen.cy-SCREEN_HEIGHT/2) end,
  };
  LoadActor("door.png")..{
    Name="Bottom";
    InitCommand=function(s) s:zoomy(-1):valign(1):xy(_screen.cx,_screen.cy) end,
    AnOnCommand=function(s) s:y(_screen.cy+SCREEN_HEIGHT/2):decelerate(0.2):y(_screen.cy) end,
    AnOffCommand=function(s) s:y(_screen.cy):decelerate(0.2):y(_screen.cy+SCREEN_HEIGHT/2) end,
  };
};

return t;
