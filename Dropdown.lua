--[[
    NecroUI - Dropdown Element
]]

local TweenService = game:GetService("TweenService")

local Dropdown = {}

function Dropdown.new(page, name, options, default, multi, callback)
    local UI = {}
    UI.Options = options or {}
    UI.Multi = multi or false

    if UI.Multi then
        UI.Value = {}
        if type(default) == "table" then
            for _, v in ipairs(default) do
                UI.Value[v] = true
            end
        end
    else
        UI.Value = default or UI.Options[1] or ""
    end

    local AccentColor = Color3.fromRGB(90, 19, 95)
    local ClosedHeight = 36
    local visibleItems = math.clamp(#UI.Options, 1, 5)
    local OpenHeight = ClosedHeight + (visibleItems * 25) + 5

    UI.Frame = Instance.new("Frame")
    UI.Frame.Name = name .. "Dropdown"
    UI.Frame.Size = UDim2.new(1, -10, 0, ClosedHeight)
    UI.Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    UI.Frame.BorderSizePixel = 0
    UI.Frame.ClipsDescendants = true
    UI.Frame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = UI.Frame

    local Stroke = Instance.new("UIStroke")
    UI.Stroke = Stroke
    Stroke.Color = Color3.fromRGB(30, 30, 30)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = UI.Frame

    local Header = Instance.new("TextButton")
    Header.Size = UDim2.new(1, 0, 0, ClosedHeight)
    Header.BackgroundTransparency = 1
    Header.Text = ""
    Header.Parent = UI.Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0.45, -10, 0, ClosedHeight)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = name
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    UI.SelectedLabel = Instance.new("TextLabel")
    UI.SelectedLabel.Size = UDim2.new(0.55, -30, 0, ClosedHeight)
    UI.SelectedLabel.Position = UDim2.new(0.45, 0, 0, 0)
    UI.SelectedLabel.BackgroundTransparency = 1
    UI.SelectedLabel.Font = Enum.Font.Gotham
    UI.SelectedLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    UI.SelectedLabel.TextSize = 12
    UI.SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    UI.SelectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
    UI.SelectedLabel.Parent = Header

    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 0, ClosedHeight)
    Arrow.Position = UDim2.new(1, -30, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
    Arrow.TextSize = 10
    Arrow.Parent = Header

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -10, 1, -ClosedHeight - 5)
    Container.Position = UDim2.new(0, 5, 0, ClosedHeight)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = AccentColor
    Container.BorderSizePixel = 0
    Container.Parent = UI.Frame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = Container

    local function UpdateText()
        if UI.Multi then
            local selected = {}
            for k, v in pairs(UI.Value) do
                if v then table.insert(selected, tostring(k)) end
            end
            UI.SelectedLabel.Text = #selected > 0 and table.concat(selected, ", ") or "None"
        else
            UI.SelectedLabel.Text = tostring(UI.Value)
        end
        pcall(callback, UI.Value)
    end
    UpdateText()

    local IsOpen = false
    Header.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        if IsOpen then
            TweenService:Create(UI.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -10, 0, OpenHeight)}):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = AccentColor}):Play()
        else
            TweenService:Create(UI.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -10, 0, ClosedHeight)}):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(30,30,30)}):Play()
        end
    end)

    UI.Indicators = {}

    function UI:SetOptions(newOptions)
        UI.Options = newOptions or {}

        for _, child in ipairs(Container:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        UI.OptionButtons = {}
        UI.Indicators = {}

        local currentVisibleItems = math.clamp(#UI.Options, 1, 5)
        OpenHeight = ClosedHeight + (currentVisibleItems * 25) + 5

        if IsOpen then
            TweenService:Create(UI.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -10, 0, OpenHeight)}):Play()
        end

        for _, opt in ipairs(UI.Options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Size = UDim2.new(1, 0, 0, 23)
            OptBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            OptBtn.BorderSizePixel = 0
            OptBtn.Text = "      " .. tostring(opt)
            OptBtn.Font = Enum.Font.Gotham
            OptBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            OptBtn.TextSize = 13
            OptBtn.TextXAlignment = Enum.TextXAlignment.Left
            OptBtn.Parent = Container

            local OptCorner = Instance.new("UICorner")
            OptCorner.CornerRadius = UDim.new(0, 3)
            OptCorner.Parent = OptBtn

            local OptIndicator = Instance.new("Frame")
            OptIndicator.Size = UDim2.new(0, 2, 0.6, 0)
            OptIndicator.Position = UDim2.new(0, 5, 0.2, 0)
            OptIndicator.BackgroundColor3 = AccentColor
            OptIndicator.BorderSizePixel = 0
            OptIndicator.BackgroundTransparency = 1
            OptIndicator.Parent = OptBtn
            table.insert(UI.Indicators, OptIndicator)

            local function RenderOpt()
                local selected = (UI.Multi and UI.Value[opt]) or (not UI.Multi and UI.Value == opt)
                if selected then
                    OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OptBtn.BackgroundColor3 = AccentColor:lerp(Color3.new(0,0,0), 0.85)
                    OptIndicator.BackgroundTransparency = 0
                else
                    OptBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
                    OptBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    OptIndicator.BackgroundTransparency = 1
                end
            end
            RenderOpt()
            table.insert(UI.OptionButtons, RenderOpt)

            OptBtn.MouseButton1Click:Connect(function()
                if UI.Multi then
                    UI.Value[opt] = not UI.Value[opt]
                else
                    UI.Value = opt
                    IsOpen = false
                    TweenService:Create(UI.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -10, 0, ClosedHeight)}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(30,30,30)}):Play()
                end

                for _, fn in ipairs(UI.OptionButtons) do fn() end
                UpdateText()
            end)
        end

        Container.CanvasSize = UDim2.new(0, 0, 0, #UI.Options * 25)
        pcall(function() Container.AutomaticCanvasSize = Enum.AutomaticSize.Y end)
    end

    function UI:SetTheme(color)
        AccentColor = color
        Container.ScrollBarImageColor3 = color
        for _, ind in pairs(UI.Indicators) do
            ind.BackgroundColor3 = color
        end
        for _, render in ipairs(UI.OptionButtons) do
            render()
        end
        if IsOpen then
            UI.Stroke.Color = color
        end
    end

    function UI:SetValue(val)
        if UI.Multi then
            UI.Value = val or {}
        else
            UI.Value = val
        end
        UpdateText()
        for _, fn in ipairs(UI.OptionButtons) do fn() end
    end

    UI:SetOptions(UI.Options)

    return UI
end

return Dropdown
