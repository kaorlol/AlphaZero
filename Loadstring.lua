if isfile("AlphaZero/Loader.lua") then
    loadfile("AlphaZero/Loader.lua")();
else
    local Status, Script = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Loader.lua");

    if Status then
        loadstring(Script)()
    else
        game:GetService("Players").LocalPlayer:Kick("Failed to grab loader, join the discord for support.");
    end
end