local Library = loadstring(game:HttpGet(("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua")))();

local Exploit = identifyexecutor and table.concat({identifyexecutor()}, " ") or "Unknown";
local ToastTypes = {
    ["None"] = 0,
    ["Success"] = 1,
    ["Warning"] = 2,
    ["Error"] = 3,
    ["Info"] = 4
};

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

    return Library:Notify(Content, Duration)
end

return Notify
