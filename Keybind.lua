--[[
    NecroUI - Keybind Element
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Keybind = {}

function Keybind.new(page, name, defaultKey, callback)
    local UI = {}
    UI.Value = defaultKey or Enum.KeyCode.Unknown
    local AccentColor = Color3.fromRGB(90, 19, 95)

    UI.Frame = Instance.new("Frame")
    UI.Frame.Name = name .. "Keybind"
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
    UI.Label.Size = UDim2.new(1, -70, 1, 0)
    UI.Label.Position = UDim2.new(0, 10, 0, 0)
    UI.Label.BackgroundTransparency = 1
    UI.Label.Text = name
    UI.Label.Font = Enum.Font.GothamMedium
    UI.Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    UI.Label.TextSize = 14
    UI.Label.TextXAlignment = Enum.TextXAlignment.Left
    UI.Label.Parent = UI.Frame

    UI.BindBox = Instance.new("Frame")
    UI.BindBox.Name = "BindBox"
    UI.BindBox.Size = UDim2.new(0, 50, 0, 20)
    UI.BindBox.Position = UDim2.new(1, -60, 0.5, -10)
    UI.BindBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    UI.BindBox.BorderSizePixel = 0
    UI.BindBox.Parent = UI.Frame

    local BindCorner = Instance.new("UICorner")
    BindCorner.CornerRadius = UDim.new(0, 4)
    BindCorner.Parent = UI.BindBox

    local BindStroke = Instance.new("UIStroke")
    BindStroke.Color = Color3.fromRGB(45, 45, 45)
    BindStroke.Thickness = 1
    BindStroke.Parent = UI.BindBox

    UI.BindLabel = Instance.new("TextLabel")
    UI.BindLabel.Size = UDim2.new(1, 0, 1, 0)
    UI.BindLabel.BackgroundTransparency = 1
    UI.BindLabel.Text = (UI.Value == Enum.KeyCode.Unknown) and "None" or UI.Value.Name
    UI.BindLabel.Font = Enum.Font.GothamBold
    UI.BindLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    UI.BindLabel.TextSize = 12
    UI.BindLabel.Parent = UI.BindBox

    local Binding = false
    local Interact = Instance.new("TextButton")
    Interact.Size = UDim2.new(1, 0, 1, 0)
    Interact.BackgroundTransparency = 1
    Interact.Text = ""
    Interact.Parent = UI.Frame

    Interact.MouseButton1Click:Connect(function()
        if Binding then return end
        Binding = true
        UI.BindLabel.Text = "..."

        TweenService:Create(BindStroke, TweenInfo.new(0.2), {Color = AccentColor}):Play()
        TweenService:Create(UI.BindBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 15, 45)}):Play()
        TweenService:Create(UI.BindLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if Binding then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode
                if key == Enum.KeyCode.Escape then
                    UI.Value = Enum.KeyCode.Unknown
                    UI.BindLabel.Text = "None"
                else
                    UI.Value = key
                    UI.BindLabel.Text = key.Name
                end

                TweenService:Create(BindStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 45)}):Play()
                TweenService:Create(UI.BindBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                TweenService:Create(UI.BindLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()

                task.delay(0.1, function() Binding = false end)

            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                UI.BindLabel.Text = (UI.Value == Enum.KeyCode.Unknown) and "None" or UI.Value.Name
                TweenService:Create(BindStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 45)}):Play()
                TweenService:Create(UI.BindBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                TweenService:Create(UI.BindLabel, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
                task.delay(0.1, function() Binding = false end)
            end
        elseif not gameProcessed then
            if input.KeyCode == UI.Value and UI.Value ~= Enum.KeyCode.Unknown then
                TweenService:Create(UI.BindBox, TweenInfo.new(0.1), {BackgroundColor3 = AccentColor}):Play()
                task.delay(0.1, function()
                    if not Binding then
                        TweenService:Create(UI.BindBox, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                    end
                end)

                pcall(callback, UI.Value)
            end
        end
    end)

    function UI:SetTheme(color)
        AccentColor = color
        if Binding then
            TweenService:Create(BindStroke, TweenInfo.new(0.2), {Color = color}):Play()
            TweenService:Create(UI.BindBox, TweenInfo.new(0.2), {BackgroundColor3 = color:lerp(Color3.new(0,0,0), 0.7)}):Play()
        end
    end

    function UI:SetValue(val)
        if type(val) == "string" then
            pcall(function() UI.Value = Enum.KeyCode[val] end)
        else
            UI.Value = val
        end
        UI.BindLabel.Text = (UI.Value == Enum.KeyCode.Unknown) and "None" or UI.Value.Name
    end

    return UI
end

return Keybind
