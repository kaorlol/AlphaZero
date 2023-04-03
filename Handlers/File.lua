local function GetLastCommit()
    local Response = game:HttpGetAsync("https://api.github.com/repos/Uvxtq/AlphaZero/branches/main");
    local Data = game:GetService("HttpService"):JSONDecode(Response);

    return Data.commit.sha;
end

local FileHandler = {}; do
    function FileHandler:Setup(Hub: string, Version: string, Subfolders: table)
        warn("Setting up file handler: "..Hub);

        if not isfolder(Hub) then
            makefolder(Hub);

            for _, Subfolder in next, Subfolders do
                makefolder(Hub.."/"..Subfolder);
            end

            self:Write(Hub.."/Version.txt", Version);
            self:Write(Hub.."/LastCommit.txt", GetLastCommit());

            warn("Completed setup of file handler: "..Hub);

            return;
        else
            for _, Subfolder in next, Subfolders do
                if not self:Exists(Hub.."/"..Subfolder) then
                    makefolder(Hub.."/"..Subfolder);
                end
            end
        end

        local VersionFile = Hub.."/Version.txt";

        if not isfile(VersionFile) then
            self:Write(VersionFile, Version);
        else
            if readfile(VersionFile) ~= Version then
                self:Write(VersionFile, Version);

                for _, Subfolder in next, Subfolders do
                    if self:Exists(Hub.."/"..Subfolder) then
                        self:Delete(Hub.."/"..Subfolder);
                    end

                    makefolder(Hub.."/"..Subfolder);
                end
            end
        end

        warn("Finished setting up file handler: "..Hub);
    end;

    function FileHandler:Write(Path: string, Content: any)
        writefile(Path, Content);
    end;

    function FileHandler:Append(Path: string, Content: any)
        if not isfile(Path) then
            return self:Write(Path, Content);
        end

        appendfile(Path, Content);
    end;

    function FileHandler:Read(Path: string)
        return readfile(Path);
    end;

    function FileHandler:Load(Path: string)
        warn("Loaded file: "..Path);

        return loadfile(Path)();
    end;

    function FileHandler:Delete(Path: string)
        if isfile(Path) then
            delfile(Path);
        else
            delfolder(Path);
        end
    end;

    function FileHandler:Exists(Path: string)
        return isfile(Path) or isfolder(Path);
    end;

    function FileHandler:Download(Path: string, Url: string)
        if self:Exists(Path) then
            local Content = self:Read(Path)
            local LastCommit = self:Read("AlphaZero/LastCommit.txt");

            if LastCommit ~= GetLastCommit() then
                warn("No changes have been made to " .. Path)

                return;
            end
        end

        warn("Downloaded file: "..Path.." ("..Url..")");

        self:Write(Path, game:HttpGet(Url));
    end;

    function FileHandler:GetFilesFrom(Folder: string)
        local Response = game:HttpGetAsync(Folder);
        local Files = {};

        for File in string.gmatch(Response, 'href="([^"]+)"') do
            if string.find(File, "blob") then
                table.insert(Files, File);
            end
        end

        return Files;
    end;
end

return FileHandler;