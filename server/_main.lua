local resourceName = GetCurrentResourceName()
local repositoryPath = GetResourcePath(resourceName).."/shared"
local cachedFiles = {}

local function listFiles(directory)
    local files = {}
    local jsonFiles = {}
    local handle = nil

    if Config.HostOS == 'windows' then
        handle = io.popen('dir "' .. directory .. '" /b /a-d')
    else
        handle = io.popen('ls "' .. directory .. '"')
    end

    if not handle then return false end

    for file in handle:lines() do files[#files+1] = file end

    handle:close()

    for _, file in ipairs(files) do
        if string.match(file, "%.json$") then jsonFiles[file] = LoadResourceFile(resourceName, file) end
    end

    return jsonFiles
end

local function resetCache()
    cachedFiles = listFiles(repositoryPath) or {}
end

function k_lib.WriteData(fileName, data)
    if not string.match(fileName, "%.json$") then
        print(Lang:t('error.file_type'))
        return false
    end
    if string.find(fileName, "/") then
        print(Lang:t('error.file_name'))
        return false
    end
    cachedFiles[fileName] = data
    local file = LoadResourceFile(resourceName, fileName)
    local newData = data or ""
    if file then
        SaveResourceFile(resourceName, fileName, newData, -1)
        return true
    end
    local path = string.match(fileName, "(.*/)")
    if path then
        os.execute("mkdir " .. path)
    end

    SaveResourceFile(resourceName, fileName, newData, -1)

    print(Lang:t('error.local_drive', {file = fileName}))
    return false
end
exports('WriteData', k_lib.WriteData)

function k_lib.GetData(fileName)
    return cachedFiles[fileName]
end
exports('GetData', k_lib.GetData)

resetCache()