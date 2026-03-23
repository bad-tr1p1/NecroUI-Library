--[[
    NecroUI - Library (Premium Black Edition)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Library = {}

function Library.new(config)
    local UI = {}

    if type(config) == "string" then
        config = { Name = config }
    end
    print("NecroUI Debug: Starting Library.new for", config.Name or "Unknown")

    local windowSettings = {
        Title = config.Name or config.Title or "NecroUI",
        ThemeColor = config.ThemeColor or Color3.fromRGB(90, 19, 95),
        Size = config.Size or UDim2.new(0, 750, 0, 500),
        LoadingScreen = config.LoadingScreen or false,
        LoadingLogo = config.LoadingLogo or "",
        LoadingText = config.LoadingText or "Booting NecroUI engine...",
        SaveConfig = config.SaveConfig or false,
        ConfigFolder = config.ConfigFolder or "NecroConfigs"
    }

    UI.Flags = {}
    UI.OnFlagChanged = Instance.new("BindableEvent")
    UI.Enabled = true
    UI.ToggleKey = Enum.KeyCode.RightControl
    UI.Loaded = false

    UI.ThemeColor = windowSettings.ThemeColor
    UI.Settings = windowSettings

    pcall(function() getgenv().NecroThemeColor = UI.ThemeColor end)

    local core = game:GetService("CoreGui")
    local plyGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    for _, child in pairs(core:GetChildren()) do
        if child.Name == "NecroUI" then child:Destroy() end
    end
    for _, child in pairs(plyGui:GetChildren()) do
        if child.Name == "NecroUI" then child:Destroy() end
    end

    UI.Screen = Instance.new("ScreenGui")
    UI.Screen.Name = "NecroUI"
    UI.Screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
    UI.Screen.DisplayOrder = 1000
    UI.Screen.IgnoreGuiInset = true
    UI.Screen.Parent = core or plyGui

    UI.Frame = Instance.new("Frame")
    UI.Frame.Name = "Main"
    UI.Frame.ClipsDescendants = false

    UI.PopupLayer = Instance.new("Frame")
    UI.PopupLayer.Name = "Popups"
    UI.PopupLayer.Size = UDim2.new(1, 0, 1, 0)
    UI.PopupLayer.BackgroundTransparency = 1
    UI.PopupLayer.ZIndex = 2000
    UI.PopupLayer.Parent = UI.Screen
    UI.Frame.ClipsDescendants = false
    UI.Frame.Size = windowSettings.Size
    UI.Frame.Position = UDim2.new(0.5, -windowSettings.Size.X.Offset/2, 0.5, -windowSettings.Size.Y.Offset/2)
    UI.Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    UI.Frame.BorderSizePixel = 0
    UI.Frame.Parent = UI.Screen

    local FrameScale = Instance.new("UIScale")
    FrameScale.Parent = UI.Frame

    UI.Visible = true
    UI.Animating = false

    function UI:SetVisible(state)
        if UI.Animating then return end
        UI.Animating = true

        if state then
            UI.Frame.Visible = true
            TweenService:Create(FrameScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
            task.wait(0.3)
        else
            TweenService:Create(FrameScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0}):Play()
            task.wait(0.3)
            UI.Frame.Visible = false
        end

        UI.Visible = state
        UI.Animating = false
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == UI.ToggleKey then
            UI:SetVisible(not UI.Visible)
        end
    end)

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = UI.Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Thickness = 2.4
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = UI.Frame

    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, UI.ThemeColor),
        ColorSequenceKeypoint.new(0.4, UI.ThemeColor),
        ColorSequenceKeypoint.new(0.45, Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(0.55, Color3.new(0,0,0)),
        ColorSequenceKeypoint.new(0.6, UI.ThemeColor),
        ColorSequenceKeypoint.new(1, UI.ThemeColor)
    })
    StrokeGradient.Parent = Stroke

    UI.MainGradient = StrokeGradient

    task.spawn(function()
        local r = 0
        RunService.RenderStepped:Connect(function(dt)
            r = (r + dt * 45) % 360
            StrokeGradient.Rotation = r
        end)
    end)

    function UI:SetTheme(newColor)
        UI.ThemeColor = newColor
        getgenv().NecroThemeColor = newColor

        StrokeGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, newColor),
            ColorSequenceKeypoint.new(0.4, newColor),
            ColorSequenceKeypoint.new(0.45, Color3.new(0,0,0)),
            ColorSequenceKeypoint.new(0.55, Color3.new(0,0,0)),
            ColorSequenceKeypoint.new(0.6, newColor),
            ColorSequenceKeypoint.new(1, newColor)
        })

        for _, tab in pairs(UI.Tabs or {}) do
            if tab.SetTheme then tab:SetTheme(newColor) end
        end
    end

    UI.NavBar = Instance.new("Frame")
    UI.NavBar.Name = "NavBar"
    UI.NavBar.Size = UDim2.new(1, 0, 0, 45)
    UI.NavBar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    UI.NavBar.BorderSizePixel = 0
    UI.NavBar.Parent = UI.Frame

    local NavBarCorner = Instance.new("UICorner")
    NavBarCorner.CornerRadius = UDim.new(0, 8)
    NavBarCorner.Parent = UI.NavBar

    local dragging, dragInput, dragStart, startPos
    UI.NavBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = UI.Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UI.NavBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            UI.Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UI.TitleLabel = Instance.new("TextLabel")
    UI.TitleLabel.Size = UDim2.new(0, 150, 1, 0)
    UI.TitleLabel.Position = UDim2.new(0, 20, 0, 0)
    UI.TitleLabel.BackgroundTransparency = 1
    UI.TitleLabel.Text = windowSettings.Title
    UI.TitleLabel.Font = Enum.Font.GothamBold
    UI.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    UI.TitleLabel.TextSize = 16
    UI.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    UI.TitleLabel.Parent = UI.NavBar

    UI.StatsContainer = Instance.new("Frame")
    UI.StatsContainer.Size = UDim2.new(0.6, -20, 1, 0)
    UI.StatsContainer.Position = UDim2.new(0.4, 0, 0, 0)
    UI.StatsContainer.BackgroundTransparency = 1
    UI.StatsContainer.Parent = UI.NavBar

    local StatsList = Instance.new("UIListLayout")
    StatsList.FillDirection = Enum.FillDirection.Horizontal
    StatsList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    StatsList.VerticalAlignment = Enum.VerticalAlignment.Center
    StatsList.Padding = UDim.new(0, 15)
    StatsList.Parent = UI.StatsContainer

    local function CreateStatLabel(name, initialValue)
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(0, 70, 0, 20)
        Container.BackgroundTransparency = 1
        Container.Parent = UI.StatsContainer

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(1, 0, 1, 0)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextColor3 = UI.ThemeColor
        ValueLabel.TextSize = 12
        ValueLabel.Text = initialValue
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Container

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Font = Enum.Font.GothamMedium
        Label.TextColor3 = Color3.fromRGB(150, 150, 150)
        Label.TextSize = 11
        Label.Text = name
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Container

        return ValueLabel
    end

    local ClockLabel = CreateStatLabel("TIME", "00:00:00")
    local FPSLabel = CreateStatLabel("FPS", "60")
    local PingLabel = CreateStatLabel("PING", "0ms")
    UI.StatLabels = {ClockLabel, FPSLabel, PingLabel}

    task.spawn(function()
        local lastIteration = tick()
        local frameCount = 0
        local RunService = game:GetService("RunService")

        RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            local now = tick()

            if now - lastIteration >= 1 then
                FPSLabel.Text = tostring(frameCount) .. " FPS"
                frameCount = 0
                lastIteration = now

                local ping = tonumber(string.format("%.0f", game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()))
                PingLabel.Text = tostring(ping) .. " MS"
            end
            ClockLabel.Text = os.date("%X")
        end)
    end)

    local oldSetTheme = UI.SetTheme
    function UI:SetTheme(color)
        oldSetTheme(UI, color)
        if UI.StatLabels then
            for _, lbl in pairs(UI.StatLabels) do
                lbl.TextColor3 = color
            end
        end
    end

    function UI:Notify() end

    UI.SearchBox = Instance.new("Frame")
    UI.SearchBox.Name = "Search"
    UI.SearchBox.Size = UDim2.new(0, 130, 0, 28)
    UI.SearchBox.Position = UDim2.new(0, 15, 0, 55)
    UI.SearchBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    UI.SearchBox.Parent = UI.Frame

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = Color3.fromRGB(35, 35, 35)
    SearchStroke.Thickness = 1
    SearchStroke.Parent = UI.SearchBox

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 4)
    SearchCorner.Parent = UI.SearchBox

    local SearchInput = Instance.new("TextBox")
    SearchInput.Size = UDim2.new(1, -10, 1, 0)
    SearchInput.Position = UDim2.new(0, 10, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.PlaceholderText = "Search..."
    SearchInput.Font = Enum.Font.GothamMedium
    SearchInput.Text = ""
    SearchInput.TextColor3 = Color3.fromRGB(200, 200, 200)
    SearchInput.TextSize = 12
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.Parent = UI.SearchBox

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchInput.Text:lower()
        for _, tab in pairs(UI.Tabs or {}) do
            for _, elem in pairs(tab.Elements or {}) do
                if elem.Frame then
                    local name = tostring(elem.Name or ""):lower()
                    local nameMatch = name:find(query) ~= nil
                    elem.Frame.Visible = query == "" or nameMatch
                end
            end
        end
    end)

    UI.TabContainer = Instance.new("Frame")
    UI.TabContainer.Name = "Tabs"
    UI.TabContainer.Size = UDim2.new(0, 140, 1, -105)
    UI.TabContainer.Position = UDim2.new(0, 10, 0, 95)
    UI.TabContainer.BackgroundTransparency = 1
    UI.TabContainer.Parent = UI.Frame

    local TabList = Instance.new("UIListLayout")
    TabList.FillDirection = Enum.FillDirection.Vertical
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 8)
    TabList.Parent = UI.TabContainer

    local Divider = Instance.new("Frame")
    Divider.Name = "Divider"
    Divider.Size = UDim2.new(0, 1, 1, -65)
    Divider.Position = UDim2.new(0, 160, 0, 55)
    Divider.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Divider.BorderSizePixel = 0
    Divider.Parent = UI.Frame

    UI.Container = Instance.new("Frame")
    UI.Container.Name = "Content"
    UI.Container.Size = UDim2.new(1, -180, 1, -65)
    UI.Container.Position = UDim2.new(0, 170, 0, 55)
    UI.Container.BackgroundTransparency = 1
    UI.Container.Parent = UI.Frame

    if windowSettings.LoadingScreen then
        UI.Frame.Visible = false

        local LoadingOverlay = Instance.new("Frame")
        LoadingOverlay.Size = UDim2.new(1, 0, 1, 0)
        LoadingOverlay.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        LoadingOverlay.BackgroundTransparency = 1
        LoadingOverlay.BorderSizePixel = 0
        LoadingOverlay.Parent = UI.Screen

        local TerminalText = Instance.new("TextLabel")
        TerminalText.Size = UDim2.new(1, 0, 0, 50)
        TerminalText.Position = UDim2.new(0, 0, 0.5, -40)
        TerminalText.BackgroundTransparency = 1
        TerminalText.Text = ""
        TerminalText.Font = Enum.Font.Code
        TerminalText.TextColor3 = UI.ThemeColor
        TerminalText.TextSize = 28
        TerminalText.Parent = LoadingOverlay

        local SubGlow = Instance.new("TextLabel")
        SubGlow.Size = UDim2.new(1, 0, 0, 50)
        SubGlow.Position = UDim2.new(0, 0, 0, 0)
        SubGlow.BackgroundTransparency = 1
        SubGlow.Text = ""
        SubGlow.Font = Enum.Font.Code
        SubGlow.TextColor3 = UI.ThemeColor
        SubGlow.TextTransparency = 0.6
        SubGlow.TextSize = 28
        SubGlow.Parent = TerminalText

        local StatusLog = Instance.new("TextLabel")
        StatusLog.Size = UDim2.new(1, 0, 0, 20)
        StatusLog.Position = UDim2.new(0, 0, 0.5, 10)
        StatusLog.BackgroundTransparency = 1
        StatusLog.Text = ""
        StatusLog.Font = Enum.Font.Code
        StatusLog.TextColor3 = Color3.fromRGB(150, 150, 150)
        StatusLog.TextSize = 14
        StatusLog.Parent = LoadingOverlay

        local Cursor = Instance.new("Frame")
        Cursor.Size = UDim2.new(0, 10, 0, 3)
        Cursor.Position = UDim2.new(0.5, 0, 1, 5)
        Cursor.BackgroundColor3 = UI.ThemeColor
        Cursor.BorderSizePixel = 0
        Cursor.AnchorPoint = Vector2.new(0.5, 0)
        Cursor.Parent = TerminalText

        task.spawn(function()
            local titleStr = "NECROUI.EXE"

            local cursorBlink = true
            task.spawn(function()
                while cursorBlink do
                    Cursor.BackgroundTransparency = 1
                    task.wait(0.3)
                    Cursor.BackgroundTransparency = 0
                    task.wait(0.3)
                end
            end)

            for i = 1, #titleStr do
                TerminalText.Text = string.sub(titleStr, 1, i)
                SubGlow.Text = string.sub(titleStr, 1, i)
                task.wait(0.08)
            end

            task.wait(0.3)

            local logs = {
                "> Injecting core modules...",
                "> Bypassing anticheat...",
                "> Hooking meta-methods... [OK]",
                "> Rendering Necro Interface..."
            }

            for _, msg in ipairs(logs) do
                StatusLog.Text = msg
                task.wait(math.random(3, 7) / 10)
            end

            StatusLog.TextColor3 = UI.ThemeColor
            StatusLog.Text = "> Initialization Complete."
            task.wait(0.5)

            cursorBlink = false
            Cursor:Destroy()

            local tweenFlash = TweenService:Create(TerminalText, TweenInfo.new(0.2), {TextSize = 35, TextTransparency = 1})
            local tweenSubFlash = TweenService:Create(SubGlow, TweenInfo.new(0.2), {TextSize = 45, TextTransparency = 1})
            local tweenLog = TweenService:Create(StatusLog, TweenInfo.new(0.2), {TextTransparency = 1})
            local tweenBg = TweenService:Create(LoadingOverlay, TweenInfo.new(0.5), {BackgroundTransparency = 1})

            tweenFlash:Play()
            tweenSubFlash:Play()
            tweenLog:Play()
            tweenBg:Play()

            tweenBg.Completed:Wait()
            LoadingOverlay:Destroy()

            UI.Frame.Size = UDim2.new(0, 0, 0, 0)
            UI.Frame.Visible = true
            TweenService:Create(UI.Frame, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = windowSettings.Size
            }):Play()
            TweenService:Create(UI.Frame, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -windowSettings.Size.X.Offset/2, 0.5, -windowSettings.Size.Y.Offset/2)
            }):Play()
        end)
    end

    return UI
end

return Library
