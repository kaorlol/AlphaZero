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
                        self:Delete(Hub.."/"..Subfolder);
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

    function FileHandler:Read(Path: string)
        assert(typeof(Path) == "string", "Path must be a string");
        assert(not isfolder(Path), "Cannot read a folder");
        assert(isfile(Path), "File does not exist");

        return readfile(Path);
    end;

    function FileHandler:Load(Path: string)
        assert(typeof(Path) == "string", "Path must be a string");
        assert(not isfolder(Path), "Cannot load a folder");
        assert(isfile(Path), "File does not exist");

        return loadfile(Path)();
    end;

    function FileHandler:Delete(Path: string)
        assert(typeof(Path) == "string", "Path must be a string");
        assert(isfile(Path) or isfolder(Path), "File or folder does not exist");

        if isfile(Path) then
            delfile(Path);
        else
            delfolder(Path);
        end
    end;

    function FileHandler:Exists(Path: string)
        assert(typeof(Path) == "string", "Path must be a string");

        return isfile(Path) or isfolder(Path);
    end;

    function FileHandler:Download(Path: string, Url: string)
        assert(typeof(Path) == "string", "Path must be a string");
        assert(typeof(Url) == "string", "Url must be a string");

        self:Write(Path, game:HttpGet(Url));
    end;
end

return FileHandler;