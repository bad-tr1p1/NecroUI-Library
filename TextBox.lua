--[[
    NecroUI - TextBox Element
]]
local TweenService = game:GetService("TweenService")

local TextBoxModule = {}

function TextBoxModule.new(page, name, placeholder, default, clearOnFocus, callback)
    local UI = {}
    UI.Value = default or ""

    local AccentColor = Color3.fromRGB(90, 19, 95)
    pcall(function()
        if page.Parent.Parent.Parent.Name == "Main" then
            AccentColor = page.Parent.Parent.Parent.UIStroke.Color
        end
    end)
    if getgenv().NecroThemeColor then AccentColor = getgenv().NecroThemeColor end

    UI.Frame = Instance.new("Frame")
    UI.Frame.Name = name .. "TextBox"
    UI.Frame.Size = UDim2.new(1, -10, 0, 45)
    UI.Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    UI.Frame.BorderSizePixel = 0
    UI.Frame.Parent = page

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = UI.Frame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(30, 30, 30)
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = UI.Frame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -10, 0, 18)
    TitleLabel.Position = UDim2.new(0, 10, 0, 2)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = name
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = UI.Frame

    local InputBoxBg = Instance.new("Frame")
    InputBoxBg.Size = UDim2.new(1, -16, 0, 20)
    InputBoxBg.Position = UDim2.new(0, 8, 0, 20)
    InputBoxBg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    InputBoxBg.BorderSizePixel = 0
    InputBoxBg.Parent = UI.Frame

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 3)
    InputCorner.Parent = InputBoxBg

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(40, 40, 40)
    InputStroke.Parent = InputBoxBg

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(1, -10, 1, 0)
    InputBox.Position = UDim2.new(0, 5, 0, 0)
    InputBox.BackgroundTransparency = 1
    InputBox.Text = UI.Value
    InputBox.PlaceholderText = placeholder or "Type here..."
    InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextColor3 = Color3.fromRGB(180, 180, 180)
    InputBox.TextSize = 12
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    InputBox.ClearTextOnFocus = clearOnFocus or false
    InputBox.Parent = InputBoxBg

    InputBox.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.3), {Color = AccentColor}):Play()
    end)

    InputBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(InputStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(40, 40, 40)}):Play()
        UI.Value = InputBox.Text
        pcall(callback, UI.Value)
    end)

    function UI:SetTheme(color)
        AccentColor = color
    end

    function UI:SetValue(val)
        UI.Value = val or ""
        InputBox.Text = UI.Value
        pcall(callback, UI.Value)
    end

    return UI
end

return TextBoxModule
