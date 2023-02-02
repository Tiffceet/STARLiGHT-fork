function jacketpath(text, so)
	if not text or text =="" then
		return nil
	end
	
	so = ToEnumShortString(so)
	if so == "Genre" then
		return THEME:GetPathG("","_jackets/genre/GENRE_sort.png")
	elseif so == "TopGrades" then
		return THEME:GetPathG("","_jackets/grade/"..group_name[text]..".png")
	elseif string.find(so,"Meter") then
		return THEME:GetPathG("","_jackets/EasyMeter/"..group_name[text]..".png")
	else
		local internalPath = THEME:GetAbsolutePath("Graphics/_jackets/"..so.."/"..text..".png", true)
		if FILEMAN:DoesFileExist(internalPath) then
			return internalPath
		end
		if so == "Group" then
			local groupPath = GetGroupJacketPath(text, SONGMAN:GetSongGroupBannerPath(text))
			if FILEMAN:DoesFileExist(groupPath) then
				return groupPath
			else
			end
		end
	end
	return THEME:GetPathG("","MusicWheelItem fallback")
end

function bannerpath(text, so)
	if not text or text =="" then
		return nil
	end
	
	so = ToEnumShortString(so)
	if so == "Genre" then
		return THEME:GetPathG("","_jackets/genre/GENRE_sort.png")
	elseif so == "TopGrades" then
		return THEME:GetPathG("","_jackets/grade/"..group_name[text]..".png")
	elseif string.find(so,"Meter") then
		return THEME:GetPathG("","_jackets/EasyMeter/"..group_name[text]..".png")
	else
		local internalPath = THEME:GetAbsolutePath("Graphics/_jackets/"..so.."/"..text..".png", true)
		if FILEMAN:DoesFileExist(internalPath) then
			return internalPath
		end
		if so == "Group" then
			local groupPath = GetGroupBannerPath(text, SONGMAN:GetSongGroupBannerPath(text))
			if FILEMAN:DoesFileExist(groupPath) then
				return groupPath
			else
			end
		end
	end
	return THEME:GetPathG("","Common fallback banner")
end

function bannerset(self)
	local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
	local fPath2 = THEME:GetPathG("","MusicWheelItem fallback")
	if mw:GetSelectedType() == "WheelItemDataType_Section" then
		fPath2 = bannerpath(mw:GetSelectedSection(), GAMESTATE:GetSortOrder())
	end
	return fPath2
end

function jacketset(self)
	local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
	local fPath2 = THEME:GetPathG("","MusicWheelItem fallback")
	if mw:GetSelectedType() == "WheelItemDataType_Section" then
		fPath2 = jacketpath(mw:GetSelectedSection(), GAMESTATE:GetSortOrder())
	end
	return fPath2
end

function jacketsetwi(_,params)
	return jacketpath(params.Text, GAMESTATE:GetSortOrder())
end

function BalloonX()
	if ThemePrefs.Get("WheelType") == "CoverFlow" then
		return _screen.cx
	elseif ThemePrefs.Get("WheelType") == "A" then
		return _screen.cx+201
	elseif ThemePrefs.Get("WheelType") == "Jukebox" then
		return _screen.cx
	elseif ThemePrefs.Get("WheelType") == "Wheel" then
		return SCREEN_LEFT+262
	end
end

function BalloonY()
	if ThemePrefs.Get("WheelType") == "CoverFlow" then
		return _screen.cy-190
	elseif ThemePrefs.Get("WheelType") == "A" then
		return _screen.cy-396
	elseif ThemePrefs.Get("WheelType") == "Jukebox" then
		return _screen.cy-190
	elseif ThemePrefs.Get("WheelType") == "Wheel" then
		return _screen.cy-274
	end
end

function BalloonOn(self)
	if ThemePrefs.Get("WheelType") == "A" then
		self:zoom(0.65)
	elseif ThemePrefs.Get("WheelType") == "Banner" then
		self:zoom(0)
	end
	self:draworder(100)
end

function RadarP1X(self)
	if ThemePrefs.Get("WheelType") == "Default" then
		return SCREEN_LEFT+200
	elseif ThemePrefs.Get("WheelType") == "CoverFlow" then
		return _screen.cx-360
	else
		return SCREEN_LEFT+200
	end
end

function RadarP2X(self)
	if ThemePrefs.Get("WheelType") == "Default" then
		return SCREEN_LEFT+200
	elseif ThemePrefs.Get("WheelType") == "CoverFlow" then
		return _screen.cx-360
	else
		return SCREEN_LEFT+200
	end
end

function RadarY(self)
	if ThemePrefs.Get("WheelType") == "CoverFlow" then
		return _screen.cy-12
	elseif ThemePrefs.Get("WheelType") == "A" then
		return SCREEN_BOTTOM-124
	elseif ThemePrefs.Get("WheelType") == "Wheel" then
		return SCREEN_BOTTOM-130
	elseif ThemePrefs.Get("WheelType") == "Jukebox" then
		return _screen.cy+50
	else
		return _screen.cy+220
	end;
end;

function StageDX(self)
	if ThemePrefs.Get("WheelType") == "CoverFlow" then
		return _screen.cx
	elseif ThemePrefs.Get("WheelType") == "A" then
		return SCREEN_LEFT+160
	else
		return _screen.cx
	end;
end;

function StageDY(self)
	if ThemePrefs.Get("WheelType") == "CoverFlow" then
		return SCREEN_TOP+104
	elseif ThemePrefs.Get("WheelType") == "A" then
		return _screen.cy-260
	elseif ThemePrefs.Get("WheelType") == "Banner" then
		return SCREEN_TOP+160
	else
		return _screen.cy
	end;
end;

function MusHeader(self)
	if ThemePrefs.Get("WheelType") == "CoverFlow" then
		return true
	elseif ThemePrefs.Get("WheelType") == "A" then
		return false
	end;
end;

function ShowTwoPart(self)
	if ThemePrefs.Get("WheelType") == "Jukebox" or ThemePrefs.Get("WheelType") == "Wheel" then
		return false
	else
		return true
	end;
end;

function AddCourseMode(self)
	SCREENMAN:AddNewScreenToTop("ScreenSelectPlayCourseMode", "SM_MenuTimer")
end;

function PrevSteps2(self)
	if ThemePrefs.Get("WheelType") == "CoverFlow" then
		return "MenuUp"
	else
		return
	end
end

function NextSteps2(self)
	if ThemePrefs.Get("WheelType") == "CoverFlow" then
		return "MenuDown"
	else
		return
	end
end

function CourseItem(self)
	if getenv("FixStage") == 1 then
		return ""
	else
		if GAMESTATE:GetCurrentStage() == "Stage_1st" or GAMESTATE:IsEventMode() then
			return "Crs"
		else return ""
		end
	end
end
