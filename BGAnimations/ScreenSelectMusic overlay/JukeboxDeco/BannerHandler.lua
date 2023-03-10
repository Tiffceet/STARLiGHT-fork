local Crstext = THEME:GetString("MusicWheel","CustomItemCrsText");
local SongAttributes = LoadModule "SongAttributes.lua"
local jk = LoadModule "Jacket.lua"

return Def.ActorFrame{
 	InitCommand=function(s) s:xy(_screen.cx,_screen.cy-190):diffusealpha(1):draworder(1) end,
  OnCommand=function(s) s:zoomy(0):sleep(0.2):bounceend(0.175):zoomy(1) end,
  OffCommand=function(s) s:bouncebegin(0.175):zoomy(0) end,
  CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
  Def.Sprite{
    Texture="BannerFrame",
  };
	Def.Banner{
    InitCommand=function(s) s:y(20) end,
    SetCommand=function(self,params)
      self:finishtweening()
      local song = GAMESTATE:GetCurrentSong();
      local so = GAMESTATE:GetSortOrder();
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      if not mw then return end
      if song then
        self:Load(jk.GetSongGraphicPath(song,"Banner"))
      elseif mw:GetSelectedType('WheelItemDataType_Section') then
        if mw:GetSelectedSection() == "" then
          self:Load(THEME:GetPathG("","_banners/Random"))
        else
          self:Load(jk.GetGroupGraphicPath(mw:GetSelectedSection(),"Banner",so))
        end
      else
        self:Load(THEME:GetPathG("","Common fallback banner"));
      end;
      self:zoomto(478,150)
		end;
  };
  Def.Sprite{
    InitCommand=function(s) s:y(20) end,
    SetCommand=function(self)
      local song = GAMESTATE:GetCurrentSong();
      local so = GAMESTATE:GetSortOrder();
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      if not song and mw then
        if mw:GetSelectedType() == 'WheelItemDataType_Custom' then
          self:Load(THEME:GetPathG("","_banners/COURSE")):setsize(478,150)
          self:visible(true)
        else
          self:visible(false)
        end;
      else
        self:visible(false)
      end;
    end;
  };
  Def.Quad{
    InitCommand=function(s) s:setsize(478,30):xy(239,96):align(1,1):diffuseleftedge(color("1,1,1,0.3")) end,
  },
  Def.BitmapText{
    Font="_avenirnext lt pro bold 20px",
    InitCommand=function(s) s:halign(1):maxwidth(450):xy(234,80):diffuse(Color.Black):strokecolor(Color.White) end,
    SetCommand=function(s)
      local song = GAMESTATE:GetCurrentSong();
      local so = GAMESTATE:GetSortOrder();
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      if not mw then return end
      if song then
        s:settext(song:GetDisplayFullTitle())
      elseif mw:GetSelectedType() == "WheelItemDataType_Section" then
        local group = mw:GetSelectedSection()
        s:settext(GAMESTATE:GetSortOrder('SortOrder_Group') and SongAttributes.GetGroupName(group) or "")
      else
        s:settext("")
      end
    end,
  },
  Def.BitmapText{
  Font="_avenirnext lt pro bold 46px",
		InitCommand=function(s) s:diffusealpha(1):maxwidth(200):diffusebottomedge(color("#d8d8d8")):diffusetopedge(color("#8c8c8c")):strokecolor(Color.Black) end,
    SetMessageCommand=function(self,params)
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      local so = GAMESTATE:GetSortOrder();
      if not mw then return end
      if mw:GetSelectedType() == "WheelItemDataType_Section" then
        local group = mw:GetSelectedSection()
			  if so == "SortOrder_Genre" then
			  	self:settext(group)
			  else
			  	self:settext("")
			  end;
		  else
			  self:settext("")
      end
    end,
	};
};
