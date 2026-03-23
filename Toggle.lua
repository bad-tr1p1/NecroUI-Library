--[[
    NecroUI - Toggle Element
]]

local TweenService = game:GetService("TweenService")

local Toggle = {}

function Toggle.new(page, name, default, callback)
    local UI = {}
    UI.Value = default or false
    UI.Name = name
    local AccentColor = Color3.fromRGB(90, 19, 95)

    UI.Frame = Instance.new("Frame")
    UI.Frame.Name = name .. "Toggle"
    UI.Frame.Size = UDim2.new(1, -10, 0, 32)
    UI.Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    UI.Frame.BorderSizePixel = 0
    UI.Frame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = UI.Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(30, 30, 30)
    Stroke.Thickness = 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = UI.Frame

    UI.Label = Instance.new("TextLabel")
    UI.Label.Size = UDim2.new(1, -40, 1, 0)
    UI.Label.Position = UDim2.new(0, 10, 0, 0)
    UI.Label.BackgroundTransparency = 1
    UI.Label.Text = name
    UI.Label.Font = Enum.Font.GothamMedium
    UI.Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    UI.Label.TextSize = 14
    UI.Label.TextXAlignment = Enum.TextXAlignment.Left
    UI.Label.Parent = UI.Frame

    UI.Box = Instance.new("Frame")
    UI.Box.Name = "Box"
    UI.Box.Size = UDim2.new(0, 18, 0, 18)
    UI.Box.Position = UDim2.new(1, -28, 0.5, -9)
    UI.Box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    UI.Box.BorderSizePixel = 0
    UI.Box.Parent = UI.Frame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 3)
    BoxCorner.Parent = UI.Box

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Color3.fromRGB(45, 45, 45)
    BoxStroke.Thickness = 1
    BoxStroke.Parent = UI.Box

    UI.Indicator = Instance.new("Frame")
    UI.Indicator.Size = UDim2.new(0, 0, 0, 0)
    UI.Indicator.Position = UDim2.new(0.5, 0, 0.5, 0)
    UI.Indicator.BackgroundColor3 = AccentColor
    UI.Indicator.BackgroundTransparency = 1
    UI.Indicator.Parent = UI.Box

    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(0, 2)
    IndCorner.Parent = UI.Indicator

    local function SetState(state)
        UI.Value = state
        local targetSize = state and UDim2.new(1, -4, 1, -4) or UDim2.new(0, 0, 0, 0)
        local targetPos = state and UDim2.new(0, 2, 0, 2) or UDim2.new(0.5, 0, 0.5, 0)
        local targetAlpha = state and 0 or 1

        TweenService:Create(UI.Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Size = targetSize,
            Position = targetPos,
            BackgroundTransparency = targetAlpha
        }):Play()

        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {
            Color = state and AccentColor or Color3.fromRGB(45, 45, 45)
        }):Play()

        pcall(callback, UI.Value)
        if UI.OnChanged then UI.OnChanged:Fire(UI.Value) end
    end

    UI.OnChanged = Instance.new("BindableEvent")

    local Interact = Instance.new("TextButton")
    Interact.Size = UDim2.new(1, 0, 1, 0)
    Interact.BackgroundTransparency = 1
    Interact.Text = ""
    Interact.Parent = UI.Frame

    Interact.MouseButton1Click:Connect(function()
        SetState(not UI.Value)
    end)

    if default then SetState(true) end

    function UI:AddKeybind(defaultKey)
        local UserInputService = game:GetService("UserInputService")
        UI.Key = defaultKey or Enum.KeyCode.Unknown

        local BindBox = Instance.new("Frame")
        BindBox.Name = "BindBox"
        BindBox.Size = UDim2.new(0, 45, 0, 18)
        BindBox.Position = UDim2.new(1, -78, 0.5, -9)
        BindBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        BindBox.BorderSizePixel = 0
        BindBox.ZIndex = 2
        UI.BindBox = BindBox
        BindBox.Parent = UI.Frame

        local BindCorner = Instance.new("UICorner")
        BindCorner.CornerRadius = UDim.new(0, 3)
        BindCorner.Parent = BindBox

        local BindStroke = Instance.new("UIStroke")
        UI.BindStroke = BindStroke
        BindStroke.Color = Color3.fromRGB(45, 45, 45)
        BindStroke.Thickness = 1
        BindStroke.Parent = BindBox

        local BindLabel = Instance.new("TextLabel")
        BindLabel.Size = UDim2.new(1, 0, 1, 0)
        BindLabel.BackgroundTransparency = 1
        BindLabel.Text = (UI.Key == Enum.KeyCode.Unknown) and "None" or UI.Key.Name
        BindLabel.Font = Enum.Font.GothamBold
        BindLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        BindLabel.TextSize = 11
        BindLabel.ZIndex = 3
        BindLabel.Parent = BindBox

        local BindInteract = Instance.new("TextButton")
        BindInteract.Size = UDim2.new(1, 0, 1, 0)
        BindInteract.BackgroundTransparency = 1
        BindInteract.Text = ""
        BindInteract.ZIndex = 4
        BindInteract.Parent = BindBox

        UI.IsBinding = false
        BindInteract.MouseButton1Click:Connect(function()
            if UI.IsBinding then return end
            UI.IsBinding = true
            BindLabel.Text = "..."

            TweenService:Create(BindStroke, TweenInfo.new(0.2), {Color = AccentColor}):Play()
            TweenService:Create(BindBox, TweenInfo.new(0.2), {BackgroundColor3 = AccentColor:lerp(Color3.new(0,0,0), 0.7)}):Play()
            TweenService:Create(BindLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if UI.IsBinding then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local key = input.KeyCode
                    if key == Enum.KeyCode.Escape then
                        UI.Key = Enum.KeyCode.Unknown
                        BindLabel.Text = "None"
                    else
                        UI.Key = key
                        BindLabel.Text = key.Name
                    end

                    TweenService:Create(BindStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 45)}):Play()
                    TweenService:Create(BindBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                    TweenService:Create(BindLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()

                    task.delay(0.1, function() UI.IsBinding = false end)
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                    BindLabel.Text = (UI.Key == Enum.KeyCode.Unknown) and "None" or UI.Key.Name
                    TweenService:Create(BindStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 45)}):Play()
                    TweenService:Create(BindBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                    TweenService:Create(BindLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
                    task.delay(0.1, function() UI.IsBinding = false end)
                end
            elseif not gameProcessed then
                if input.KeyCode == UI.Key and UI.Key ~= Enum.KeyCode.Unknown then
                    SetState(not UI.Value)

                    TweenService:Create(BindBox, TweenInfo.new(0.1), {BackgroundColor3 = AccentColor}):Play()
                    task.delay(0.1, function()
                        if not UI.IsBinding then
                            TweenService:Create(BindBox, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                        end
                    end)
                end
            end
        end)
    end

    function UI:SetTheme(color)
        AccentColor = color
        UI.Indicator.BackgroundColor3 = color

        if BoxStroke then
            BoxStroke.Color = UI.Value and color or Color3.fromRGB(45, 45, 45)
        end

        if UI.BindBox and UI.Binding then
            UI.BindBox.BackgroundColor3 = color:lerp(Color3.new(0,0,0), 0.7)
            if UI.BindStroke then UI.BindStroke.Color = color end
        end
    end

    function UI:SetValue(state)
        SetState(state)
    end

    return UI
end

return Toggle
