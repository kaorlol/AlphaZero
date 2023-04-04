if typeof(syn) == "table" and gethui then
    syn.protect_gui = not gethui and syn.protect_gui or function(Instance) Instance.Parent = gethui() end;
end

if not game:IsLoaded() then
    game.Loaded:Wait();
end

warn("--<< AlphaZero v2 Loader >>--")

local LoadHandler = loadstring(game:HttpGet(("https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Handlers/Load%20Handler.lua")))();
local File = LoadHandler("File");
local Notify = LoadHandler("Notification");

Notify("Info", "[AlphaZero v2]", "Setting up file handler... (1/3)", 5);

File:Setup("AlphaZero", "1.0.0", {
    Subfolders = { "Games" },
    HubData = { Owner = "Uvxtq", Repo = "AlphaZero" }
});

Notify("Info", "[AlphaZero v2]", "Downloading files... (2/3)", 5);

File:QueueDownload("AlphaZero/Loader.lua", "https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Loader.lua", true);

for _, Game in next, File:GetFilesFrom("https://github.com/Uvxtq/AlphaZero/tree/main/Games") do
    local Name = Game:match("([^/]+)$");
    local Url = "https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Games/"..Name;

    File:QueueDownload("AlphaZero/Games/"..Name, Url);
end

File:DownloadQueued();

Notify("Info", "[AlphaZero v2]", "Finished setting up loader. (3/3)", 5);

local MarketplaceService = cloneref(game:GetService("MarketplaceService"));
local GameName = MarketplaceService:GetProductInfo(game.PlaceId).Name;

local function GetGameFromPlaceId()
    local Games = File:Load("AlphaZero/Games/PlaceIds.lua", true);

    for Game, PlaceId in next, Games do
        if PlaceId == game.PlaceId then
            return Game;
        end
    end

    return false;
end

local Game = GetGameFromPlaceId();

if not Game then
    Notify("Info", "Unknown Game", "Game not found, loading universal script...", 5);

    File:Load("AlphaZero/Games/Universal.lua", true);

    Notify("Info", "[AlphaZero v2]", "Loaded universal script.", 5);
    return;
end

Notify("Info", "[AlphaZero v2]", string.format("Loading script for %s.", GameName), 5);

File:Load(string.format("AlphaZero/Games/%s.lua", Game), true);

Notify("Info", "[AlphaZero v2]", "Loaded script.", 5);
