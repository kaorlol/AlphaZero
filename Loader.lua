--<< AlphaZero v2 Loader >>--
if typeof(syn) == "table" and gethui then
    syn.protect_gui = not gethui and syn.protect_gui or function(Instance) Instance.Parent = gethui() end;
end

if not game:IsLoaded() then
    game.Loaded:Wait();
end

--<< Handlers >>--
local LoadHandler = loadstring(game:HttpGet(("https://github.com/Uvxtq/AlphaZero/blob/main/Handlers/Load%20Handler.lua?raw=true")))();
local File = LoadHandler("File");
local Notify = LoadHandler("Notification");

File:Setup("AlphaZero", "1.0.0", {
    "Games",
})

File:Download("AlphaZero/Games/PlaceIds.lua", "https://github.com/Uvxtq/AlphaZero/blob/main/Games/PlaceIds.lua?raw=true");
File:Download("AlphaZero/Loader.lua", "https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Loader.lua");
File:Download("AlphaZero/Universal.lua", "https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Games/Universal.lua");

--<< Services >>--
local Players = cloneref(game:GetService("Players"));
local LocalPlayer = Players.LocalPlayer;
local MarketplaceService = cloneref(game:GetService("MarketplaceService"));

--<< Variables >>--
local GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name;

local function GetGameFromPlaceId()
    local Games = File:Load("AlphaZero/Games/PlaceIds.lua");

    for Game, PlaceId in next, Games do
        if PlaceId == game.PlaceId then
            return Game;
        end
    end

    return false, "Game not found";
end

--<< Main >>--
local Game, Error = GetGameFromPlaceId();

if not Game then
    warn(Error);
    Notify("Info", "Unknown Game", "Game not found, loading universal script");

    File:Load("AlphaZero/Universal.lua");
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