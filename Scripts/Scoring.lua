--[[Scoring.lua
This includes a couple modules that all have to do with scoring and grading.
SN2Grading partially depends on SN2Scoring.
All information used is from http://aaronin.jp/ddrssystem.html. The
information used for A was written by Aaron C.
]]

--SN2Scoring
--Implements the scoring system used by DDR A. Yes, I know about the name.

--Shared functions/data

SN2Scoring = {}
--ScoringInfo is used and maintained solely by PrepareScoringInfo.
ScoringInfo = {
    seed = nil
}

function GetEvaScore(maxsteps,pss,pn)
    local score;
    local w1=pss:GetTapNoteScores('TapNoteScore_W1');
    local w2=pss:GetTapNoteScores('TapNoteScore_W2');
    local w3=pss:GetTapNoteScores('TapNoteScore_W3');
    local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');

    if EXScore(pn) == "On" then
        score = w1*3 + w2*2 + w3 + hd*3;
    else
        if PREFSMAN:GetPreference("AllowW1")~="AllowW1_Everywhere" then
            w1=w1+w2;
            w2=0;
        end;
        score = (math.round( (w1 + w2 + w3/2+hd)*100000/maxsteps-(w2 + w3))*10);
    end;
    return score;
end;

function GetEvaSummScore(maxsteps,pss,pn)
    local score;
    local w1=pss:GetTapNoteScores('TapNoteScore_W1');
    local w2=pss:GetTapNoteScores('TapNoteScore_W2');
    local w3=pss:GetTapNoteScores('TapNoteScore_W3');
    local hd=pss:GetHoldNoteScores('HoldNoteScore_Held');

    if PREFSMAN:GetPreference("AllowW1")~="AllowW1_Everywhere" then
        w1=w1+w2;
        w2=0;
    end;
    score = (math.round( (w1 + w2 + w3/2+hd)*100000/maxsteps-(w2 + w3))*10);
    return score;
end;

local maxNoteValues =
{
    TapNoteScore_W1 = 1,
    TapNoteScore_W2 = 1,
    TapNoteScore_W3 = 1,
    TapNoteScore_W4 = 1,
    TapNoteScore_W5 = 1,
    TapNoteScore_Miss = 1
}

local maxHoldValues =
{
    HoldNoteScore_Held = 1,
    HoldNoteScore_LetGo = 1,
    HoldNoteScore_MissedHold = 1
}

--Given a thing which has functions hnsFuncName and tnsFuncName that take one
--argument and return the number of TNSes or HNSes there are in that thing,
--pack that information into something useful.
--This is a pretty bad function description, so just see how it's used.
local function GetScoreDataFromThing(thing, tnsFuncName, hnsFuncName)
    local output = {}
    --how class function lookup works internally in Lua
    local hnsFunc = thing[hnsFuncName]
    local tnsFunc = thing[tnsFuncName]
    local total = 0
    local value = 0
    for tns, _ in pairs(maxNoteValues) do
        value = tnsFunc(thing, tns)
        output[tns] = value
        total = total + value
    end
    for hns, _ in pairs(maxHoldValues) do
        value = hnsFunc(thing, hns)
        output[hns] = value
        total = total + value
    end
    output.Total = total
    return output
end

function SN2Scoring.GetCurrentScoreData(pss, judgment)
    local scoreData = GetScoreDataFromThing(pss, "GetTapNoteScores", "GetHoldNoteScores")
    --workaround for the fact that the current TNS or HNS won't have been
    --added to the PSS yet.
    if judgment and scoreData[judgment] then
        scoreData[judgment] = scoreData[judgment] + 1
        scoreData.Total = scoreData.Total + 1
    end
    return scoreData
end

function SN2Scoring.PrepareScoringInfo()
    if GAMESTATE then
        local stageSeed = GAMESTATE:GetStageSeed()
        --if the seed hasn't changed, we're in the same game so we don't want
        --to re-initialize
        if stageSeed == ScoringInfo.seed then return end

        ScoringInfo = {}
        ScoringInfo.seed = stageSeed
        local inCourse = GAMESTATE:IsCourseMode()

        local dataFetcher = inCourse and GameState.GetCurrentTrail or GameState.GetCurrentSteps
        for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
            local data = dataFetcher(GAMESTATE,pn)
            if data then
                ScoringInfo[pn] = SN2Scoring.MakeNormalScoringFunctions(data,pn,starterRules,inCourse)
            end
        end
    end
end

--The multiplier tables have to be filled in completely.
--However, the deduction ones do not.
local normalScoringRules =
{
    multipliers =
    {
        TapNoteScore_W1 = 1,
        TapNoteScore_W2 = 1,
        TapNoteScore_W3 = 0.6,
        TapNoteScore_W4 = 0.2,
        TapNoteScore_W5 = 0.2
    },
    deductions =
    {
        TapNoteScore_W2 = 10,
        TapNoteScore_W3 = 10,
        TapNoteScore_W4 = 10,
        TapNoteScore_W5 = 10
    }
}

--data format for this function:
--a table with a count of total holds, rolls, and taps called "Total"
--all earned TapNoteScores in the class W1-W5 and Miss under their native names
--all earned HoldNoteScores
function SN2Scoring.ComputeNormalScoreFromData(data, max)
    local objectCount = data.Total
    local maxScore = 1000000
    local maxFraction = 0
    local totalDeductions = 0
    local tnsMultipliers, hnsMultipliers, deductions
    if max then
        tnsMultipliers = maxNoteValues
        hnsMultipliers = maxHoldValues
        deductions = {}
    else
        tnsMultipliers = normalScoringRules.multipliers
        hnsMultipliers = {HoldNoteScore_Held = 1}
        deductions = normalScoringRules.deductions
    end
    local scoreCount
    for tns, multiplier in pairs(tnsMultipliers) do
        scoreCount = data[tns]
        maxFraction = maxFraction + scoreCount * multiplier
        totalDeductions = totalDeductions + scoreCount * (deductions[tns] or 0)
    end
    for hns, multiplier in pairs(hnsMultipliers) do
        scoreCount = data[hns]
        maxFraction = maxFraction + scoreCount * multiplier
    end
    return (maxFraction/objectCount) * maxScore - totalDeductions
end

local exScoringTapValues =
{
    TapNoteScore_W1 = 3,
    TapNoteScore_W2 = 2,
    TapNoteScore_W3 = 1
}


function SN2Scoring.ComputeEXScoreFromData(data,max)
    local finalMultiplier = max and 3 or 1
    local tnsValues, hnsValues
    if max then
        tnsValues = maxNoteValues
        hnsValues = maxHoldValues
    else
        tnsValues = exScoringTapValues
        hnsValues = {HoldNoteScore_Held = 3}
    end
    local scoreCount
    local totalScore = 0
    for tns, value in pairs(tnsValues) do
        scoreCount = data[tns]
        totalScore = totalScore + scoreCount * value
    end
    for hns, value in pairs(hnsValues) do
        scoreCount = data[hns]
        totalScore = totalScore + scoreCount * value
    end
    return totalScore * finalMultiplier
end

function SN2Scoring.GetSN2ScoreFromHighScore(steps, highScore)
    local scoreData = GetScoreDataFromThing(highScore, "GetTapNoteScore",
        "GetHoldNoteScore")
    local radar = steps:GetRadarValues(pn)
    scoreData.Total = radar:GetValue('RadarCategory_TapsAndHolds')+
        radar:GetValue('RadarCategory_Holds')+radar:GetValue('RadarCategory_Rolls')
    return SN2Scoring.ComputeNormalScoreFromData(scoreData)
end

--Normal scoring

function SN2Scoring.MakeNormalScoringFunctions(stepsObject,pn,course)
    local package = {}

    local objectCount
    local radar = stepsObject:GetRadarValues(pn)
    objectCount = radar:GetValue('RadarCategory_TapsAndHolds')+radar:GetValue('RadarCategory_Holds')+radar:GetValue('RadarCategory_Rolls')
    if objectCount < 0 then
	--this seems to happen with courses on some versions of StepMania and I do not know why -tertu
        --it seems to only happen with courses though
        objectCount = 0
        local trailEntries = stepsObject:GetTrailEntries()
	    for _, entry in pairs(trailEntries) do
            local radar = entry:GetSteps():GetRadarValues(pn)
            objectCount = objectCount+radar:GetValue('RadarCategory_TapsAndHolds')+radar:GetValue('RadarCategory_Holds')+radar:GetValue('RadarCategory_Rolls')
	    end
    end

    local function ComputeScore(pss, max, currentNoteScore)
        local computeData = SN2Scoring.GetCurrentScoreData(pss,currentNoteScore)
        computeData.Total = objectCount
        return SN2Scoring.ComputeNormalScoreFromData(computeData, max)
    end

    package.GetCurrentScore = function(pss, currentNoteScore)
        --stage is unused
        return 10 * math.round(ComputeScore(pss, false, currentNoteScore) / 10)
    end

    package.GetCurrentMaxScore = function(pss, currentNoteScore)
        --ditto
        return 10 * math.round(ComputeScore(pss, true, currentNoteScore) / 10)
    end

    return package
end


--SN2Grading
--Implements the grading system used by DDR A. As above.

SN2Grading = {}
local grade_table = {
    Grade_Tier01 = 1000000, --AAA+
    Grade_Tier02 = 990000, --AAA
    Grade_Tier03 = 950000, --AA+
    Grade_Tier04 = 900000, --AA
    Grade_Tier05 = 890000, --AA-
    Grade_Tier06 = 850000, --A+
    Grade_Tier07 = 800000, --A
    Grade_Tier08 = 790000, --A-
    Grade_Tier09 = 750000, --B+
    Grade_Tier10 = 700000, --B
    Grade_Tier11 = 690000, --B-
    Grade_Tier12 = 650000, --C+
    Grade_Tier13 = 600000, --C
    Grade_Tier14 = 590000, --C-
    Grade_Tier15 = 550000, --D+
    Grade_Tier16 = 500000, --D
    Grade_Tier17 = 0, --D
}

function SN2Grading.ScoreToGrade(score)
    local output = nil
    local best = 0
    for grade, min_score in pairs(grade_table) do
        if score >= min_score and min_score >= best then
            output = grade
            best = min_score
        end
    end
    return output
end

--returns score too because what the hell
function SN2Grading.GetSN2GradeFromHighScore(steps, highScore)
    local score = SN2Scoring.GetSN2ScoreFromHighScore(steps, highScore)
    return SN2Grading.ScoreToGrade(score), score
end



-- (c) 2015-2019 tertu marybig, Inorizushi
-- All rights reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.
