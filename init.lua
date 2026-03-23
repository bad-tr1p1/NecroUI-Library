--[[
    NecroUI Library Loader
    Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/bad-tr1p1/NecroUI-Library/main/init.lua?t=" .. tostring(tick())))()
]]

local Library = {}
local BaseUrl = "https://raw.githubusercontent.com/bad-tr1p1/NecroUI-Library/main/"

local function GetFile(name)
    local success, content = pcall(function()
        return game:HttpGet(BaseUrl .. name .. ".lua?t=" .. tostring(tick()))
    end)
    if success then
        local fn, err = loadstring(content)
        if fn then
            return fn()
        else
            warn("Failed to load module " .. name .. ": " .. err)
        end
    else
        warn("Failed to fetch file " .. name)
    end
end

local Components = {
    Main = GetFile("Library"),
    Tab = GetFile("Tab"),
    Button = GetFile("Button"),
    Toggle = GetFile("Toggle"),
    Slider = GetFile("Slider"),
    Keybind = GetFile("Keybind"),
    TextBox = GetFile("TextBox"),
    Dropdown = GetFile("Dropdown"),
    ColorPicker = GetFile("ColorPicker"),
}

function Library:CreateWindow(config)
    local window = Components.Main.new(config)
    window.Tabs = {}
    window.CurrentConfigName = "default"

    function window:CreateTab(tabName, icon)
        print("NecroUI Debug: Creating Tab ->", tabName)
        local tab = Components.Tab.new(window, tabName, icon, Components)
        table.insert(window.Tabs, tab)
        return tab
    end

    window.Loaded = false
    local SystemTab = Components.Tab.new(window, "System", "rbxassetid://6031109405", Components)
    table.insert(window.Tabs, SystemTab)
    SystemTab.Button.LayoutOrder = 99999

    local MainGroup = SystemTab:CreateGroup("Management", "Left")

    MainGroup:CreateKeybind("Menu Toggle", Enum.KeyCode.RightControl, function(key)
        window.ToggleKey = key
    end)

    local Themes = {
        ["Eho"] = Color3.fromRGB(90, 19, 95),
        ["Lon"] = Color3.fromRGB(240, 140, 155),
        ["Sat"] = Color3.fromRGB(190, 20, 20),
    }

    local defaultThemeName = "Eho"
    for name, color in pairs(Themes) do
        if color == window.Settings.ThemeColor then
            defaultThemeName = name
            break
        end
    end

    MainGroup:CreateDropdown("Menu Theme", {"Eho", "Lon", "Sat"}, defaultThemeName, false, function(v)
        if Themes[v] then window:SetTheme(Themes[v]) end
    end)

    MainGroup:CreateButton("Unload Menu", function()
        if window.Unload then
            window:Unload()
        elseif window.Screen then 
            window.Screen:Destroy() 
        end
    end)

    local Settings = window.Settings or {}
    if Settings.SaveConfig then
        local ConfigGroup = SystemTab:CreateGroup("Config Manager", "Right")
        local HttpService = game:GetService("HttpService")
        local configFolder = Settings.ConfigFolder or "NecroConfigs"

        local function GetConfigs()
            local list = {}
            pcall(function()
                if isfolder(configFolder) then
                    for _, file in ipairs(listfiles(configFolder)) do
                        if file:match("%.json$") then
                            local name = file:match("([^/\\]+)%.json$")
                            if name then table.insert(list, name) end
                        end
                    end
                end
            end)
            if #list == 0 then table.insert(list, "default") end
            return list
        end

        local ConfigDropdown = ConfigGroup:CreateDropdown("Select Config", GetConfigs(), "default", false, function(v)
            if v ~= "" then window.CurrentConfigName = v end
        end)

        ConfigGroup:CreateTextBox("New Config Name", "Name...", "", false, function(v)
            if v ~= "" then window.CurrentConfigName = v end
        end)

        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 30)
        Row.BackgroundTransparency = 1
        Row.Parent = ConfigDropdown.Frame.Parent

        local Layout = Instance.new("UIListLayout")
        Layout.FillDirection = Enum.FillDirection.Horizontal
        Layout.Padding = UDim.new(0, 5)
        Layout.Parent = Row

        local function QuickButton(name, cb)
            local b = Components.Button.new(Row, name, cb)
            b.Frame.Size = UDim2.new(0.33, -3, 1, 0)
            return b
        end

        QuickButton("Save", function()
            local saveTable = {}
            for name, element in pairs(window.Flags) do
                if name ~= "Select Config" and name ~= "New Config Name" then
                    local val = element.Value
                    if typeof(val) == "EnumItem" then val = val.Name end
                    saveTable[name] = val
                end
            end
            pcall(function()
                if not isfolder(configFolder) then makefolder(configFolder) end
                writefile(configFolder .. "/" .. window.CurrentConfigName .. ".json", HttpService:JSONEncode(saveTable))
                ConfigDropdown:SetOptions(GetConfigs())
            end)
        end)

        QuickButton("Load", function()
            pcall(function()
                local path = configFolder .. "/" .. window.CurrentConfigName .. ".json"
                if isfile(path) then
                   local configData = HttpService:JSONDecode(readfile(path))
                   for name, val in pairs(configData) do
                       if window.Flags[name] and window.Flags[name].SetValue then
                           window.Flags[name]:SetValue(val)
                       elseif window.Flags[name] then
                           window.Flags[name].Value = val
                       end
                   end
                end
            end)
        end)

        QuickButton("Delete", function()
            pcall(function()
                local path = configFolder .. "/" .. window.CurrentConfigName .. ".json"
                if isfile(path) then
                    delfile(path)
                    ConfigDropdown:SetOptions(GetConfigs())
                end
            end)
        end)
    end

    window.SystemTab = SystemTab
    window.Loaded = true
    print("NecroUI Debug: CreateWindow Finished")
    return window
end

return Library
