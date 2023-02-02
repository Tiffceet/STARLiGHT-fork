local t = LoadFallbackB();

t[#t+1] = Def.Actor{
	OnCommand=function(s)
		SCREENMAN:GetTopScreen():SetPrevScreenName("ScreenSelectMusic")
		local SB = SCREENMAN:GetTopScreen():GetChild("MusicWheel"):GetChild("ScrollBar")
		if not SB then return end
		SB:visible(false)
	end,
	CodeMessageCommand = function(self,params)
		if params.Name == "Back" then
			GAMESTATE:SetCurrentPlayMode("PlayMode_Regular")
			SCREENMAN:GetTopScreen():Cancel()
		end
	end
}

t[#t+1] = Def.ActorFrame {
	LoadActor(THEME:GetPathS("","Music_In"))..{
		OnCommand=cmd(play);
	};
};

t[#t+1] = LoadActor("InputHandler");

t[#t+1] = Def.ActorFrame{
  LoadActor("../ScreenSelectMusic underlay/wheelunder")..{
    InitCommand=function(s) s:xy(_screen.cx,SCREEN_CENTER_Y-72) end,
    OnCommand=function(s) s:zoomtowidth(0):linear(0.2):zoomtowidth(SCREEN_WIDTH) end,
    OffCommand=function(s) s:sleep(0.3):decelerate(0.3):zoomtowidth(0) end,
  };
};

-- Left/right arrows that bounce to the beat
t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:draworder(100):xy(_screen.cx-484,_screen.cy-59) end,
	OffCommand=function(s) s:stopeffect():accelerate(0.3):addx(-SCREEN_WIDTH) end,
	OnCommand=function(s) s:zoom(0):decelerate(0.2):zoom(1) end,
	LoadActor("../ScreenSelectMusic overlay/2014Deco/arrowb") .. {
		OnCommand =function(s) s:bounce():effectperiod(1):effectmagnitude(10,0,0):effectoffset(0.2) end,
		PreviousSongMessageCommand=function(s) s:finishtweening():linear(0):x(-20):decelerate(0.5):x(0) end,
	};
	LoadActor("../ScreenSelectMusic overlay/2014Deco/arrowm") .. {
		InitCommand=function(s) s:diffusealpha(0) end,
		OnCommand=function(s) s:bounce():effectperiod(1):effectmagnitude(10,0,0):effectoffset(0.2) end,
		PreviousSongMessageCommand=function(s) s:finishtweening():linear(0):diffusealpha(1):x(-20):decelerate(0.5):x(0):sleep(0):diffusealpha(0) end,
	}
}

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:draworder(100):xy(_screen.cx-176,_screen.cy-59) end,
	OffCommand=function(s) s:stopeffect():accelerate(0.3):addx(SCREEN_WIDTH) end,
	OnCommand=function(s) s:zoomx(0):zoomy(0):decelerate(0.2):zoomx(-1):zoomy(1) end,
	LoadActor("../ScreenSelectMusic overlay/2014Deco/arrowb") .. {
		OnCommand =function(s) s:bounce():effectperiod(1):effectmagnitude(10,0,0):effectoffset(0.2) end,
		NextSongMessageCommand=function(s) s:finishtweening():linear(0):x(-20):decelerate(0.5):x(0) end,
	};
	LoadActor("../ScreenSelectMusic overlay/2014Deco/arrowm") .. {
		InitCommand=function(s) s:diffusealpha(0) end,
		OnCommand=function(s) s:bounce():effectperiod(1):effectmagnitude(10,0,0):effectoffset(0.2) end,
		NextSongMessageCommand=function(s) s:finishtweening():linear(0):diffusealpha(1):x(-20):decelerate(0.5):x(0):sleep(0):diffusealpha(0) end,
	}
}

t[#t+1] = Def.ActorFrame{
	OnCommand=function(s) s:zoomy(0):sleep(0.3):bounceend(0.175):zoomy(1) end,
	OffCommand=function(s) s:sleep(0.2):bouncebegin(0.175):zoomy(0) end,
	InitCommand=function(s) s:xy(_screen.cx-336,_screen.cy+148) end,
	LoadActor("../ScreenSelectMusic overlay/2014Deco/titlebox");
	Def.BitmapText{
		Font="_avenirnext lt pro bold 25px";
		InitCommand = function(s) s:y(4):maxwidth(480) end,
		SetCommand = function(self)
			local course = GAMESTATE:GetCurrentCourse()
			self:settext(course and course:GetDisplayFullTitle() or "")
		end,
		CurrentCourseChangedMessageCommand = function(s) s:queuecommand("Set") end,
		ChangedLanguageDisplayMessageCommand = function(s) s:queuecommand("Set") end,
	};
};

t[#t+1] = LoadActor("pane")..{
  InitCommand=function(s) s:draworder(100):halign(1):xy(SCREEN_RIGHT,_screen.cy+46) end,
  OnCommand=function(s) s:addx(1200):decelerate(0.3):addx(-1200) end,
  OffCommand=function(s) s:decelerate(0.3):addx(1200) end,
};
t[#t+1] = StandardDecorationFromFileOptional("CourseContentsList","CourseContentsList");

t[#t+1] = Def.Quad{
  InitCommand=function(s) s:draworder(100):setsize(686,237):align(1,0):xy(SCREEN_RIGHT,SCREEN_TOP) end,
  OnCommand=function(self)
      self:MaskSource()
  end;
};

return t;
