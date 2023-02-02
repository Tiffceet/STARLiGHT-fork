local Crstext = THEME:GetString("MusicWheel","CustomItemCrsText");
local SongAttributes = LoadModule "SongAttributes.lua"

local AnimPlayed = true

local Jacket = Def.ActorFrame{
  Def.ActorProxy{
    InitCommand=function(s) s:xy(-4,2) end,
    SetCommand=function(s)
      if centerSongObjectProxy then
        s:SetTarget(centerSongObjectProxy)
      end
      s:zoom(1.75):visible(GAMESTATE:GetCurrentSong() ~= nil)
    end
  };
  Def.Sprite{
    SetCommand=function(s,p)
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      if not mw then return end
      if not GAMESTATE:GetCurrentSong() then
        if mw:GetSelectedType('WheelItemDataType_Section') then
          if mw:GetSelectedSection() ~= "" then
            s:Load(jacketset(s)):diffusealpha(1)
          else
            if mw:GetSelectedType('WheelItemDataType_Custom') then
              if p.Label == CrsText then
                s:Load(THEME:GetPathG("","_jackets/COURSE.png")):diffusealpha(1)
              end
            end
          end
        else
          s:diffusealpha(0)
        end
      else
        s:diffusealpha(0)
      end
      s:setsize(245,245)
    end
  };
  Def.BitmapText{
    Font="_avenirnext lt pro bold 46px",
    InitCommand=function(s) s:y(-20):diffusealpha(1):maxwidth(200):diffusebottomedge(color("#d8d8d8")):diffusetopedge(color("#8c8c8c")):strokecolor(Color.Black) end,
    SetMessageCommand=function(self,params)
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      if mw and mw:GetSelectedType() == "WheelItemDataType_Section" then
        if GAMESTATE:GetSortOrder() == "SortOrder_Genre" then
          self:settext(mw:GetSelectedSection())
        else
          self:settext("")
        end;
      else
        self:settext("")
      end
    end,
  };
}

local songinfo = Def.ActorFrame{
  Def.BitmapText{
    Font="_avenirnext lt pro bold 36px",
    Name="Title",
    InitCommand=function(s) s:halign(0):maxwidth(540):y(-34):diffuse(Color.Black) end,
    SetCommand=function(s)
      local song = GAMESTATE:GetCurrentSong()
      local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      if not mw then return end
      if song then
        if song:GetDisplaySubTitle() == "" then
          s:settext(song:GetDisplayMainTitle())
        else
          s:settext(song:GetDisplayFullTitle())
        end
      elseif mw:GetSelectedType('WheelItemDataType_Section') then
        local group = mw:GetSelectedSection()
        if group then
          s:settext(GAMESTATE:GetSortOrder('SortOrder_Group') and SongAttributes.GetGroupName(group) or "")
        end
      else
        s:settext("")
      end
    end
  };
  Def.BitmapText{
    Font="_avenirnext lt pro bold 36px",
    Name="Artist",
    InitCommand=function(s) s:halign(0):maxwidth(500):zoomx(0.78):zoomy(0.65) end,
    SetCommand=function(s)
      local song = GAMESTATE:GetCurrentSong()
      if song then
        s:settext(song:GetDisplayArtist())
      else
        s:settext("")
      end
    end
  }
}

return Def.ActorFrame{
  CurrentSongChangedMessageCommand=function(s)
    if GAMESTATE:GetCurrentSong() then
      s:finishtweening():queuecommand("Show"):queuecommand("Set")
    else
      s:queuecommand("Hide")
    end
  end,
  ShowCommand=function(s)
    if AnimPlayed == false then 
      s:diffusealpha(0):linear(0.05):diffusealpha(0.75)
      :linear(0.1):diffusealpha(0.25):linear(0.1):diffusealpha(1)
      s:queuecommand("UpdateShow")
    end
  end,
  UpdateShowCommand=function(s) AnimPlayed = true end,
  HideCommand=function(s)
    if AnimPlayed == true then
      s:diffusealpha(1):sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(0.5)
      :sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(0.25):sleep(0.05)
      :linear(0.05):diffusealpha(0)
      s:queuecommand("UpdateHide")
    end
  end,
  UpdateHideCommand=function(s) AnimPlayed = false end,
  Def.Sprite{
    Texture="SongInfo";
    InitCommand=function(s)
      s:xy(8,9)
      if GAMESTATE:IsAnExtraStage() then
        s:Load(THEME:GetPathB("ScreenSelectMusic","overlay/ADeco/extra_SongInfo"))
      end
    end,
  };
  Jacket..{
    InitCommand=function(s) s:x(301) end,
  };
  songinfo..{
    InitCommand=function(s) s:x(-420) end,
  }
}
