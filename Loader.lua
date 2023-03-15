--<< AlphaZero v2 Loader >>--
if not game:IsLoaded() then
    game.Loaded:Wait();
end

--<< PlaceIds >>--
local PlaceIds = loadstring(game:HttpGetAsync(("https://github.com/Uvxtq/AlphaZero/blob/main/Games/PlaceIds.lua?raw=true")))();

--<< Services >>--
local Players = cloneref(game:GetService("Players"));
local LocalPlayer = Players.LocalPlayer;
local MarketplaceService = cloneref(game:GetService("MarketplaceService"));
local StarterGui = cloneref(game:GetService("StarterGui"));

--<< Variables >>--
local Exploit = identifyexecutor and table.concat({identifyexecutor()}, " ") or "Unknown";
local GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name;
local ToastTypes = {
    ["None"] = 0,
    ["Success"] = 1,
    ["Warning"] = 2,
    ["Error"] = 3,
    ["Info"] = 4
};

--<< Functions >>--
local function CheckExecutor(Name)
    if Exploit:gmatch("/") then
        Exploit = Exploit:split("/")[1];
    end

    if Exploit:lower():match(Name:lower()) then
        return true;
    end

    return false;
end

local function Notify(Type, Title, Content, Duration, IconColor)
    assert(ToastTypes[Type], "Invalid toast type");

    if CheckExecutor("Synapse X v3") then
        return syn.toast_notification({
            Type = ToastTypes[Type],
            Duration = Duration or 5,
            Title = Title,
            Content = Content,
            IconColor = IconColor
        })
    end

    return StarterGui:SetCore("SendNotification", {
        Title = Title,
        Text = Content,
        Duration = Duration
    })
end

local function GetGameFromPlaceId()
    for Game, PlaceId in next, PlaceIds do
        if PlaceId == game.PlaceId then
            return Game;
        end
    end

    return nil, "Game not found";
end

--<< Main >>--
local Game, Error = GetGameFromPlaceId();

if not Game then
    warn(Error);
    Notify("Info", "Unknown Game", "Game not found, loading universal script");

    loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Games/Universal.lua")))();
    return;
end

local Success, Script = pcall(game.HttpGet, game, string.format("https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Games/%s.lua", Game));

if Success then
    Notify("Info", "Game", string.format("Loading %s", GameName));
    loadstring(Script)();
    Notify("Success", "Game", string.format("Loaded %s", GameName));
else
    LocalPlayer:Kick(string.format("Failed to load %s", GameName));
end