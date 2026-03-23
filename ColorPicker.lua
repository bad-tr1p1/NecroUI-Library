--[[
    NecroUI - ColorPicker Element
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ColorPicker = {}

function ColorPicker.new(parent, name, default, callback, window)
    local UI = {}
    UI.Value = default or Color3.fromRGB(255, 255, 255)
    UI.Name = name

    local PopupLayer = window and window.PopupLayer or parent
    local Frame = Instance.new("Frame")
    Frame.Name = name .. "ColorPicker"
    Frame.Size = UDim2.new(1, 0, 0, 30)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent
    UI.Frame = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.GothamMedium
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local ColorPreview = Instance.new("TextButton")
    ColorPreview.Name = "ColorPreview"
    ColorPreview.Size = UDim2.new(0, 30, 0, 18)
    ColorPreview.Position = UDim2.new(1, -40, 0.5, -9)
    ColorPreview.BackgroundColor3 = UI.Value
    ColorPreview.Text = ""
    ColorPreview.Parent = Frame

    Instance.new("UICorner", ColorPreview).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", ColorPreview).Color = Color3.fromRGB(40, 40, 40)

    local Picker = Instance.new("Frame")
    Picker.Name = "PickerBox"
    Picker.Size = UDim2.new(0, 150, 0, 170)
    Picker.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Picker.Visible = false
    Picker.ZIndex = 10000
    Picker.Parent = (window and window.Screen) or PopupLayer

    Instance.new("UICorner", Picker).CornerRadius = UDim.new(0, 6)
    local PStroke = Instance.new("UIStroke", Picker)
    PStroke.Color = Color3.fromRGB(40, 40, 40)
    PStroke.Thickness = 1

    local h, s, v = UI.Value:ToHSV()

    local SVBox = Instance.new("Frame")
    SVBox.Name = "SVBox"
    SVBox.Size = UDim2.new(1, -20, 0, 100)
    SVBox.Position = UDim2.new(0, 10, 0, 10)
    SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    SVBox.ZIndex = 10001
    SVBox.Parent = Picker

    local SatGradient = Instance.new("UIGradient")
    SatGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
    })
    SatGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    })
    SatGradient.Rotation = 0
    SatGradient.Parent = SVBox

    local DarkOverlay = Instance.new("Frame")
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.ZIndex = 10002
    DarkOverlay.BorderSizePixel = 0
    DarkOverlay.Parent = SVBox

    local ValGradient = Instance.new("UIGradient")
    ValGradient.Rotation = 90
    ValGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
    })
    ValGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    ValGradient.Parent = DarkOverlay

    local PDCursor = Instance.new("Frame")
    PDCursor.Size = UDim2.new(0, 8, 0, 8)
    PDCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PDCursor.ZIndex = 10003
    PDCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    PDCursor.Parent = SVBox
    Instance.new("UICorner", PDCursor).CornerRadius = UDim.new(1, 0)
    local PCStroke = Instance.new("UIStroke", PDCursor)
    PCStroke.Color = Color3.fromRGB(0,0,0)
    PCStroke.Thickness = 1

    local HueSlider = Instance.new("Frame")
    HueSlider.Name = "HueBar"
    HueSlider.Size = UDim2.new(1, -20, 0, 12)
    HueSlider.Position = UDim2.new(0, 10, 0, 120)
    HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueSlider.ZIndex = 10001
    HueSlider.Parent = Picker

    local HueGradient = Instance.new("UIGradient")
    HueGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    HueGradient.Parent = HueSlider

    local HueCursor = Instance.new("Frame")
    HueCursor.Size = UDim2.new(0, 3, 1, 6)
    HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    HueCursor.Position = UDim2.new(0, 0, 0.5, 0)
    HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HueCursor.ZIndex = 10002
    HueCursor.Parent = HueSlider

    local HCStroke = Instance.new("UIStroke")
    HCStroke.Color = Color3.fromRGB(0, 0, 0)
    HCStroke.Thickness = 1
    HCStroke.Parent = HueCursor

    local function Update()
        UI.Value = Color3.fromHSV(h, s, v)
        ColorPreview.BackgroundColor3 = UI.Value
        SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        callback(UI.Value)
    end

    ColorPreview.MouseButton1Click:Connect(function()
        Picker.Visible = not Picker.Visible
        if Picker.Visible then
            local pos = ColorPreview.AbsolutePosition
            Picker.Position = UDim2.new(0, pos.X + 45, 0, pos.Y + 25)
        end
    end)

    local function SVInteract(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local move; move = UserInputService.InputChanged:Connect(function(mv)
                if mv.UserInputType == Enum.UserInputType.MouseMovement then
                    local pX = math.clamp((mv.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                    local pY = 1 - math.clamp((mv.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                    s, v = pX, pY
                    PDCursor.Position = UDim2.new(pX, 0, 1-pY, 0)
                    Update()
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then move:Disconnect() end
            end)
        end
    end
    SVBox.InputBegan:Connect(SVInteract)
    DarkOverlay.InputBegan:Connect(SVInteract)

    HueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local move; move = UserInputService.InputChanged:Connect(function(mv)
                if mv.UserInputType == Enum.UserInputType.MouseMovement then
                    local p = math.clamp((mv.Position.X - HueSlider.AbsolutePosition.X) / HueSlider.AbsoluteSize.X, 0, 1)
                    h = p
                    HueCursor.Position = UDim2.new(p, 0, 0.5, 0)
                    SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    Update()
                end
            end)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then move:Disconnect() end
            end)
        end
    end)

    function UI:SetValue(val)
        UI.Value = val
        ColorPreview.BackgroundColor3 = val
        h, s, v = val:ToHSV()
        HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
        PDCursor.Position = UDim2.new(s, 0, 1-v, 0)
        SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    end

    function UI:SetTheme(color) end

    return UI
end

return ColorPicker
