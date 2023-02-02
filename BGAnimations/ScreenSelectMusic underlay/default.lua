local t = Def.ActorFrame{};

if not GAMESTATE:IsCourseMode() then
  if GAMESTATE:IsAnExtraStage() then
    t[#t+1] = Def.Quad{
      InitCommand=function(s) s:FullScreen():diffuse(Color.Red):blend(Blend.Multiply):diffusealpha(0) end,
      OnCommand=function(s)
        s:linear(0.2):diffusealpha(0.8)
      end,
    }
  end
if ThemePrefs.Get("WheelType") == "Wheel" then
  t[#t+1] = Def.ActorFrame{
    LoadActor("MusicWheelWheelUnder.png")..{
      InitCommand=function(s) s:halign(1):xy(SCREEN_RIGHT,_screen.cy):diffusealpha(0.5)
        if GAMESTATE:IsAnExtraStage() then
          s:diffuse(color("#f900fe"))
        end
      end,
      OnCommand=function(s) s:addx(1100):sleep(0.5):decelerate(0.2):addx(-1100) end,
      OffCommand=function(s) s:sleep(0.3):decelerate(0.3):addx(1100) end,
    };
    Def.Quad{
      InitCommand=function(s) s:setsize(834,66):xy(_screen.cx+370,_screen.cy+22):diffuse(color("0,0,0,0.5")) end,
      OnCommand=function(s) s:addx(1100):sleep(0.5):decelerate(0.2):addx(-1100) end,
      OffCommand=function(s) s:sleep(0.3):decelerate(0.3):addx(1100) end,
    }
  };
end;

if ThemePrefs.Get("WheelType") == "A" then
  t[#t+1] = Def.ActorFrame{
    LoadActor("ADeco")..{
      InitCommand=function(s) s:halign(0):xy(SCREEN_LEFT,_screen.cy):blend(Blend.Add):diffusealpha(1) end,
      OnCommand=function(s) s:diffusealpha(0):linear(0.2):diffusealpha(1) end,
      OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
    };
    LoadActor("ADeco")..{
      InitCommand=function(s) s:zoomx(-1):halign(0):xy(SCREEN_RIGHT,_screen.cy):blend(Blend.Add):diffusealpha(1) end,
      OnCommand=function(s) s:diffusealpha(0):linear(0.2):diffusealpha(1) end,
      OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
    };
  };
end;

if ThemePrefs.Get("WheelType") == "Jukebox" then
  t[#t+1] = Def.ActorFrame{
    InitCommand=function(s) s:xy(_screen.cx,_screen.cy-140):rotationx(-55):zoomx(1.4):diffusealpha(0)
      if GAMESTATE:IsAnExtraStage() then
        s:diffuse(color("#f900fe"))
      end
    end,
    OnCommand=function(s) s:linear(0.5):diffusealpha(1) end,
    OffCommand=function(s) s:stoptweening():linear(0.5):diffusealpha(0) end,
    LoadActor("inner")..{
      InitCommand=function(s) s:spin():effectmagnitude(0,0,25) end,
    };
    LoadActor("outer")..{
      InitCommand=function(s) s:spin():effectmagnitude(0,0,-25) end,
    };
  }
end;

if ThemePrefs.Get("WheelType") == "Banner" then
t[#t+1] = Def.ActorFrame{
  LoadActor("wheelunder")..{
    InitCommand=function(s) s:xy(_screen.cx,_screen.cy-184)
      if GAMESTATE:IsAnExtraStage() then
        s:diffuse(color("#f900fe"))
      end
    end,
    OnCommand=function(s) s:zoomtowidth(0):linear(0.2):zoomtowidth(SCREEN_WIDTH) end,
    OffCommand=function(s) s:sleep(0.3):decelerate(0.3):zoomtowidth(0) end,
  };
};
end;

if ThemePrefs.Get("WheelType") == "CoverFlow" then
t[#t+1] = Def.ActorFrame{
  LoadActor("wheelunder")..{
    InitCommand=function(s) s:xy(_screen.cx,_screen.cy+246)
    end,
    OnCommand=function(s) s:zoomtowidth(0):linear(0.2):zoomtowidth(SCREEN_WIDTH) end,
    OffCommand=function(s) s:sleep(0.3):decelerate(0.3):zoomtowidth(0) end,
    StartSelectingStepsMessageCommand=function(s) s:queuecommand("Off") end,
  	SongUnchosenMessageCommand=function(s) s:queuecommand("On") end,
  };
};
end;
end;
return t;
