--[[
    NecroUI - Button Element
]]

local TweenService = game:GetService("TweenService")

local Button = {}

function Button.new(page, name, callback)
    local UI = {}
    UI.Name = name
    local AccentColor = Color3.fromRGB(90, 19, 95)

    UI.Frame = Instance.new("Frame")
    UI.Frame.Name = name .. "Button"
    UI.Frame.Size = UDim2.new(1, -10, 0, 28)
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

    local ShimmerBG = Instance.new("Frame")
    ShimmerBG.Size = UDim2.new(1, 0, 1, 0)
    ShimmerBG.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ShimmerBG.BackgroundTransparency = 1
    ShimmerBG.BorderSizePixel = 0
    ShimmerBG.ZIndex = 2
    ShimmerBG.Parent = UI.Frame

    local ShimmerCorner = Instance.new("UICorner")
    ShimmerCorner.CornerRadius = UDim.new(0, 4)
    ShimmerCorner.Parent = ShimmerBG

    local ShimmerGrad = Instance.new("UIGradient")
    ShimmerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
        ColorSequenceKeypoint.new(0.4, AccentColor),
        ColorSequenceKeypoint.new(0.6, AccentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    })
    ShimmerGrad.Offset = Vector2.new(-1, 0)
    ShimmerGrad.Rotation = 15
    ShimmerGrad.Parent = ShimmerBG

    local RunService = game:GetService("RunService")
    local phase = math.random() * 10
    local waveConnection
    waveConnection = RunService.RenderStepped:Connect(function(dt)
        if not ShimmerGrad.Parent then
            waveConnection:Disconnect()
            return
        end

        phase = phase + dt * 0.7

        local ox = math.sin(phase) * 0.4 + math.sin(phase * 0.7) * 0.25
        local oy = math.cos(phase * 1.1) * 0.4
        local rot = math.sin(phase * 0.4) * 45

        ShimmerGrad.Offset = Vector2.new(ox, oy)
        ShimmerGrad.Rotation = rot
    end)

    UI.Label = Instance.new("TextLabel")
    UI.Label.Size = UDim2.new(1, 0, 1, 0)
    UI.Label.BackgroundTransparency = 1
    UI.Label.Text = name
    UI.Label.Font = Enum.Font.GothamMedium
    UI.Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    UI.Label.TextSize = 13
    UI.Label.ZIndex = 3
    UI.Label.Parent = UI.Frame

    local Interact = Instance.new("TextButton")
    Interact.Size = UDim2.new(1, 0, 1, 0)
    Interact.BackgroundTransparency = 1
    Interact.Text = ""
    Interact.ZIndex = 4
    Interact.Parent = UI.Frame

    function UI:SetTheme(color)
        AccentColor = color
        ShimmerGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
            ColorSequenceKeypoint.new(0.4, color),
            ColorSequenceKeypoint.new(0.6, color),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
        })
    end

    Interact.MouseEnter:Connect(function()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = AccentColor}):Play()
        TweenService:Create(ShimmerBG, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
        TweenService:Create(UI.Label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    Interact.MouseLeave:Connect(function()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(30, 30, 30)}):Play()
        TweenService:Create(ShimmerBG, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(UI.Label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(220, 220, 220)}):Play()
    end)

    Interact.MouseButton1Click:Connect(function()
        local Flash = Instance.new("Frame")
        Flash.Size = UDim2.new(1, 0, 1, 0)
        Flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Flash.ZIndex = 5
        Flash.BackgroundTransparency = 0.7
        Flash.Parent = UI.Frame

        local FlashCorner = Corner:Clone()
        FlashCorner.Parent = Flash

        TweenService:Create(Flash, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.delay(0.3, function() Flash:Destroy() end)

        pcall(callback)
    end)

    return UI
end

return Button
