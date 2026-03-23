--[[
    NecroUI - Slider Element
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Slider = {}

function Slider.new(page, name, min, max, default, callback)
    local UI = {}
    UI.Value = default or min
    UI.Name = name
    local AccentColor = Color3.fromRGB(90, 19, 95)

    UI.Frame = Instance.new("Frame")
    UI.Frame.Name = name .. "Slider"
    UI.Frame.Size = UDim2.new(1, -10, 0, 42)
    UI.Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    UI.Frame.BorderSizePixel = 0
    UI.Frame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = UI.Frame

    UI.Label = Instance.new("TextLabel")
    UI.Label.Size = UDim2.new(1, -60, 0, 20)
    UI.Label.Position = UDim2.new(0, 10, 0, 5)
    UI.Label.BackgroundTransparency = 1
    UI.Label.Text = name
    UI.Label.Font = Enum.Font.GothamMedium
    UI.Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    UI.Label.TextSize = 13
    UI.Label.TextXAlignment = Enum.TextXAlignment.Left
    UI.Label.Parent = UI.Frame

    UI.ValueLabel = Instance.new("TextLabel")
    UI.ValueLabel.Size = UDim2.new(0, 40, 0, 20)
    UI.ValueLabel.Position = UDim2.new(1, -50, 0, 5)
    UI.ValueLabel.BackgroundTransparency = 1
    UI.ValueLabel.Text = tostring(UI.Value)
    UI.ValueLabel.Font = Enum.Font.GothamBold
    UI.ValueLabel.TextColor3 = AccentColor
    UI.ValueLabel.TextSize = 13
    UI.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    UI.ValueLabel.Parent = UI.Frame

    UI.SliderBack = Instance.new("Frame")
    UI.SliderBack.Name = "SliderBack"
    UI.SliderBack.Size = UDim2.new(1, -20, 0, 4)
    UI.SliderBack.Position = UDim2.new(0, 10, 0, 30)
    UI.SliderBack.BackgroundColor3 = Color3.fromRGB(30,30,30)
    UI.SliderBack.BorderSizePixel = 0
    UI.SliderBack.Parent = UI.Frame

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = UI.SliderBack

    UI.SliderFill = Instance.new("Frame")
    UI.SliderFill.Name = "SliderFill"
    UI.SliderFill.Size = UDim2.new(0, 0, 1, 0)
    UI.SliderFill.BackgroundColor3 = AccentColor
    UI.SliderFill.BorderSizePixel = 0
    UI.SliderFill.Parent = UI.SliderBack

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 8)
    FillCorner.Parent = UI.SliderFill

    UI.Knob = Instance.new("Frame")
    UI.Knob.Name = "Knob"
    UI.Knob.Size = UDim2.new(0, 12, 0, 12)
    UI.Knob.Position = UDim2.new(0, 0, 0.5, -6)
    UI.Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UI.Knob.BorderSizePixel = 0
    UI.Knob.Parent = UI.SliderBack

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = UI.Knob

    local KnobStroke = Instance.new("UIStroke")
    UI.KnobStroke = KnobStroke
    KnobStroke.Color = AccentColor
    KnobStroke.Thickness = 2
    KnobStroke.Parent = UI.Knob

    local Dragging = false

    local function UpdateSlider()
        local percent = math.clamp((UserInputService:GetMouseLocation().X - UI.SliderBack.AbsolutePosition.X) / UI.SliderBack.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * percent)

        UI.Value = value
        UI.ValueLabel.Text = tostring(value)

        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quart)
        TweenService:Create(UI.SliderFill, tweenInfo, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
        TweenService:Create(UI.Knob, tweenInfo, {Position = UDim2.new(percent, -6, 0.5, -6)}):Play()

        pcall(callback, value)
    end

    UI.SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            UpdateSlider()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider()
        end
    end)

    local startPercent = (UI.Value - min) / (max - min)
    UI.SliderFill.Size = UDim2.new(startPercent, 0, 1, 0)
    UI.Knob.Position = UDim2.new(startPercent, -6, 0.5, -6)

    function UI:SetTheme(color)
        AccentColor = color
        UI.ValueLabel.TextColor3 = color
        UI.SliderFill.BackgroundColor3 = color
        if UI.KnobStroke then UI.KnobStroke.Color = color end
    end

    function UI:SetValue(val, silent)
        UI.Value = math.clamp(val, min, max)
        UI.ValueLabel.Text = tostring(UI.Value)
        local percent = (UI.Value - min) / (max - min)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart)
        TweenService:Create(UI.SliderFill, tweenInfo, {Size = UDim2.new(percent, 0, 1, 0)}):Play()
        TweenService:Create(UI.Knob, tweenInfo, {Position = UDim2.new(percent, -6, 0.5, -6)}):Play()
        if not silent then pcall(callback, UI.Value) end
    end

    return UI
end

return Slider
