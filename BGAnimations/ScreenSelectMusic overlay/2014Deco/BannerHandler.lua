local Crstext = THEME:GetString("MusicWheel","CustomItemCrsText");
local SongAttributes = LoadModule "SongAttributes.lua"
local jk = LoadModule"Jacket.lua"

local Jacket = Def.ActorFrame{
  InitCommand=function(s) s:y(-40) end,
  Def.Sprite{ Texture="_jacket back", };
	Def.ActorProxy{
    SetCommand=function(self)
      if centerSongObjectProxy then
        self:SetTarget(centerSongObjectProxy)
      end
      self:zoom(1.64)
      self:visible(GAMESTATE:GetCurrentSong() ~= nil)
		end;
  };
  Def.Sprite{
    SetCommand=function(self,params)
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      if not mw then return end
      if not GAMESTATE:GetCurrentSong() then
        self:Load(jk.GetGroupGraphicPath(mw:GetSelectedSection(),"Jacket",GAMESTATE:GetSortOrder()))
        :diffusealpha(1)
      else
        self:diffusealpha(0)
      end
      self:zoomto(378,378);
    end;
  },
  Def.Sprite{
    SetCommand=function(self)
      local song = GAMESTATE:GetCurrentSong();
      local so = GAMESTATE:GetSortOrder();
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      if not song and mw then
        if mw:GetSelectedType() == 'WheelItemDataType_Random' then
          self:Load(THEME:GetPathG("","_jackets/random"))
          self:diffusealpha(1);
        elseif mw:GetSelectedType() == 'WheelItemDataType_Roulette' then
          self:Load(THEME:GetPathG("","_jackets/random"))
          self:diffusealpha(1);
        elseif mw:GetSelectedType() == 'WheelItemDataType_Custom' then
          self:Load(THEME:GetPathG("","MusicWheelItem Custom OverPart/CoverFlow/COURSE.png"))
          self:diffusealpha(1);
        elseif mw:GetSelectedType('WheelItemDataType_Section') then
          self:diffusealpha(0)
        else
          self:diffusealpha(0);
        end;
      else
        self:diffusealpha(0)
      end;
      self:zoomto(378,378);
    end;
  },
  loadfile(THEME:GetPathG("","_jackets/GenreBanner.lua"))(BNR)..{
    InitCommand=function(s) s:zoom(0.735) end,
  },
}

local SongInfo = Def.ActorFrame{
  InitCommand=function(s) s:y(208) end,
  Def.Sprite{
    Texture="titlebox",
  };
  Def.BitmapText{
    Name="Title",
    Font="_avenirnext lt pro bold 20px",
    InitCommand=function(s) s:maxwidth(400) end,
    SetCommand=function(s)
      local song = GAMESTATE:GetCurrentSong()
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      if not mw then return end
      if song then
        s:settext(song:GetDisplayFullTitle())
        :diffuse(SongAttributes.GetMenuColor(song)):y(-6)
      elseif mw:GetSelectedType('WheelItemDataType_Section') then
        if mw:GetSelectedSection() ~= "" then
          s:settext(SongAttributes.GetGroupName(mw:GetSelectedSection())):y(6)
          s:diffuse(SongAttributes.GetGroupColor(mw:GetSelectedSection()))
        else
          s:settext("")
        end
      end
    end
  };
  Def.BitmapText{
    Font="_avenirnext lt pro bold 20px",
    InitCommand=function(s) s:y(20):maxwidth(400) end,
    SetCommand=function(s)
      local song = GAMESTATE:GetCurrentSong()
      if song then
        s:settext(song:GetDisplayArtist())
        :diffuse(SongAttributes.GetMenuColor(song))
      else
        s:settext("")
      end
    end
  };
}

return Def.ActorFrame{
  CurrentSongChangedMessageCommand=function(s) s:finishtweening():queuecommand("Set") end,
  ChangedLanguageDisplayMessageCommand = function(s) s:stoptweening():queuecommand("Set") end,
  Jacket;
  SongInfo;
};
