local function GetFileNameFromPath(Path)
    return Path:match("^.+/(.+)$");
end

local FileHandler = {}; do
    function FileHandler:Setup(Hub: string, Version: string, Subfolders: table)
        assert(typeof(Hub) == "string", "Hub must be a string");
        assert(typeof(Subfolders) == "table", "Subfolders must be a table");
        assert(typeof(Version) == "string", "Version must be a string");

        if not isfolder(Hub) then
            makefolder(Hub);

            for _, Subfolder in next, Subfolders do
                makefolder(Hub.."/"..Subfolder);
            end

            self:Write(Hub.."/Version.txt", Version);

            return;
        else
            for _, Subfolder in next, Subfolders do
                if not isfolder(Hub.."/"..Subfolder) then
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
                    if isfolder(Hub.."/"..Subfolder) then
                        delfolder(Hub.."/"..Subfolder);
                    end

                    makefolder(Hub.."/"..Subfolder);
                end
            end
        end
    end;

    function FileHandler:Write(Path: string, Content: any)
        assert(typeof(Path) == "string", "Path must be a string");
        assert(typeof(Content) == "string" or typeof(Content) == "number", "Content must be a string or number");
        assert(not isfolder(Path), "Cannot write to a folder");


        writefile(Path, Content);
    end;

    function FileHandler:Append(Path: string, Content: any)
        assert(typeof(Path) == "string", "Path must be a string");
        assert(typeof(Content) == "string" or typeof(Content) == "number", "Content must be a string or number");
        assert(not isfolder(Path), "Cannot write to a folder");

        if not isfile(Path) then
            return self:Write(Path, Content);
        end

        appendfile(Path, Content);
    end;
end

return FileHandler;