if typeof(syn) ~= "table" and Krnl.Base64.Decode then
    syn.crypt.base64.decode = Krnl.Base64.Decode;
elseif typeof(syn) ~= "table" and crypt.base64encode then
    syn.crypt.base64.decode = crypt.base64decode;
end

if isfile("AlphaZero/Loader.lua") then
    loadfile(syn.crypt.base64.decode("AlphaZero/Loader.lua"))();
else
    local Status, Script = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/Uvxtq/AlphaZero/main/Loader.lua");

    if Status then
        loadstring(Script)()
    else
        game:GetService("Players").LocalPlayer:Kick("Failed to grab loader, join the discord for support.");
    end
end