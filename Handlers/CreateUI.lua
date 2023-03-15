-- << Yielding to wait for game to load >> --
if not game:IsLoaded() then
    game.Loaded:Wait();
end

-- << Library >> --
local Library = loadstring(game:HttpGet(("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua")))();
local ThemeManager = loadstring(game:HttpGet(("https://raw.githubusercontent.com/Uvxtq/Project-AlphaZero/main/AlphaZero/Theme%20Manager.lua")))();
local SaveManager = loadstring(game:HttpGet(("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/addons/SaveManager.lua")))();

return {
    Library = Library,
    ThemeManager = ThemeManager,
    SaveManager = SaveManager
};
