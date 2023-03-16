--<< AlphaZero v2 Loader >>--
if typeof(syn) == "table" and gethui then
    syn.protect_gui = not gethui and syn.protect_gui or function(Instance) Instance.Parent = gethui() end;
end

if not game:IsLoaded() then
    game.Loaded:Wait();
end

warn("--<< AlphaZero v2 Loader >>--")

--<< Handlers >>--
local LoadHandler = loadstring(game:HttpGet(("https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Handlers/Load%20Handler.lua")))();
local File = LoadHandler("File");
local Notify = LoadHandler("Notification");

Notify("Info", "[AlphaZero v2]", "Setting up file handler. (1/3)", 5);

File:Setup("AlphaZero", "1.0.0", {
    "Games",
})

Notify("Info", "[AlphaZero v2]", "Downloading files. (2/3)", 5);

File:Download("AlphaZero/Games/PlaceIds.lua", "https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Games/PlaceIds.lua");
File:Download("AlphaZero/Loader.lua", "https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Loader.lua");
File:Download("AlphaZero/Universal.lua", "https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Games/Universal.lua");

for _, Game in next, File:GetFilesFrom("https://github.com/Uvxtq/AlphaZero/tree/main/Games") do
    local Name = Game:match("([^/]+)$");
    local Url = string.format("https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Games/%s", Name);

    if Name ~= "PlaceIds.lua" and Name ~= "Universal.lua" then
        File:Download(string.format("AlphaZero/Games/%s", Name), Url);
    end
end

Notify("Info", "[AlphaZero v2]", "Finished setting up loader. (3/3)", 5);

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

    return false;
end

--<< Main >>--
local Game = GetGameFromPlaceId();

if not Game then
    Notify("Info", "Unknown Game", "Game not found, loading universal script.", 5);

    File:Load("AlphaZero/Universal.lua");

    Notify("Info", "[AlphaZero v2]", "Loaded universal script.", 5);
    return;
end

Notify("Info", "[AlphaZero v2]", string.format("Loading script for %s.", GameName), 5);

File:Load(string.format("AlphaZero/Games/%s.lua", Game));

Notify("Info", "[AlphaZero v2]", "Loaded script.", 5);