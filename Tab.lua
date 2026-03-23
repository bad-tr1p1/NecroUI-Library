--[[
    NecroUI - Tab Module (Fixed Sizing)
]]

local TweenService = game:GetService("TweenService")

local Tab = {}

function Tab.new(window, name, icon, Components)
    local UI = {}
    UI.Elements = {}

    UI.Button = Instance.new("TextButton")
    UI.Button.Name = name .. "Tab"
    UI.Button.Parent = window.TabContainer
    UI.Button.Size = UDim2.new(1, 0, 0, 32)
    UI.Button.BackgroundTransparency = 1
    UI.Button.Text = ""
    UI.Button.Active = true
    UI.Button.AutoButtonColor = false

    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, 0, 1, 0)
    TabLabel.Position = UDim2.new(0, icon and 35 or 15, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = name
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabLabel.TextSize = 14
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = UI.Button

    if icon then
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "TabIcon"
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -9)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = icon
        TabIcon.ZIndex = 30
        TabIcon.ImageColor3 = Color3.fromRGB(240, 240, 240)
        TabIcon.Parent = UI.Button
        UI.Icon = TabIcon
    end

    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 3, 0.6, 0)
    Indicator.Position = UDim2.new(0, 0, 0.2, 0)
    Indicator.BackgroundColor3 = window.ThemeColor
    Indicator.BackgroundTransparency = 1
    Indicator.Parent = UI.Button

    UI.Page = Instance.new("ScrollingFrame")
    UI.Page.Name = name .. "Page"
    UI.Page.Size = UDim2.new(1, 0, 1, 0)
    UI.Page.BackgroundTransparency = 1
    UI.Page.ScrollBarThickness = 1
    UI.Page.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    UI.Page.Visible = false
    UI.Page.BorderSizePixel = 0
    UI.Page.ClipsDescendants = false
    UI.Page.CanvasSize = UDim2.new(0,0,0,0)
    pcall(function() UI.Page.AutomaticCanvasSize = Enum.AutomaticSize.Y end)
    UI.Page.Parent = window.Container

    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 10)
    PagePadding.PaddingLeft = UDim.new(0, 5)
    PagePadding.PaddingRight = UDim.new(0, 12)
    PagePadding.Parent = UI.Page

    local function SetActive(active)
        local TargetColor = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        local TargetAlpha = active and 0 or 1

        TweenService:Create(TabLabel, TweenInfo.new(0.25), {TextColor3 = TargetColor}):Play()
        if UI.Icon then TweenService:Create(UI.Icon, TweenInfo.new(0.25), {ImageColor3 = TargetColor}):Play() end
        TweenService:Create(Indicator, TweenInfo.new(0.25), {BackgroundTransparency = TargetAlpha}):Play()
        UI.Page.Visible = active
    end

    UI.Button.MouseButton1Click:Connect(function()
        for _, tab in pairs(window.Tabs or {}) do
            if tab ~= UI then
                local tColor = Color3.fromRGB(180, 180, 180)
                TweenService:Create(tab.Button:FindFirstChildOfClass("TextLabel"), TweenInfo.new(0.2), {TextColor3 = tColor}):Play()
                if tab.Icon then TweenService:Create(tab.Icon, TweenInfo.new(0.2), {ImageColor3 = tColor}):Play() end
                TweenService:Create(tab.Button.Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                tab.Page.Visible = false
            end
        end
        SetActive(true)
    end)

    local ColContainer = Instance.new("Frame")
    ColContainer.Size = UDim2.new(1, 0, 0, 0)
    ColContainer.BackgroundTransparency = 1
    ColContainer.Parent = UI.Page
    pcall(function() ColContainer.AutomaticSize = Enum.AutomaticSize.Y end)

    local ColLayout = Instance.new("UIListLayout")
    ColLayout.FillDirection = Enum.FillDirection.Horizontal
    ColLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ColLayout.Padding = UDim.new(0, 8)
    ColLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    ColLayout.Parent = ColContainer

    local LeftCol = Instance.new("Frame")
    LeftCol.Name = "LeftColumn"
    LeftCol.LayoutOrder = 1
    LeftCol.Size = UDim2.new(0.5, -9, 0, 0)
    LeftCol.BackgroundTransparency = 1
    LeftCol.Parent = ColContainer
    pcall(function() LeftCol.AutomaticSize = Enum.AutomaticSize.Y end)
    local LeftLayout = Instance.new("UIListLayout", LeftCol)
    LeftLayout.Padding = UDim.new(0, 10)
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Divider = Instance.new("Frame")
    Divider.Name = "CenterDivider"
    Divider.LayoutOrder = 2
    Divider.Size = UDim2.new(0, 1, 1, 0)
    Divider.BackgroundTransparency = 1
    Divider.Parent = ColContainer

    local DivLine = Instance.new("Frame")
    DivLine.Size = UDim2.new(1, 0, 1, 0)
    DivLine.Position = UDim2.new(0, 0, 0, 0)
    DivLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DivLine.BorderSizePixel = 0
    DivLine.ZIndex = 3
    DivLine.Parent = Divider

    local DivGlow = Instance.new("Frame")
    DivGlow.Size = UDim2.new(0, 4, 1, 0)
    DivGlow.Position = UDim2.new(0.5, -2, 0, 0)
    DivGlow.BackgroundTransparency = 0.8
    DivGlow.BackgroundColor3 = window.ThemeColor
    DivGlow.BorderSizePixel = 0
    DivGlow.ZIndex = 2
    DivGlow.Parent = Divider

    local function ApplyThemeToDiv(color)
        DivLine.BackgroundColor3 = Color3.new(1, 1, 1)
        DivLine.BackgroundTransparency = 0

        local seq = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.new(0,0,0)),
            ColorSequenceKeypoint.new(0.5, color),
            ColorSequenceKeypoint.new(1,   Color3.new(0,0,0)),
        })

        UI.DivGradient = UI.DivGradient or Instance.new("UIGradient", DivLine)
        UI.DivGradient.Rotation = 90
        UI.DivGradient.Color = seq

        DivGlow.BackgroundColor3 = color
        DivGlow.BackgroundTransparency = 1
        UI.DivGlowGrad = UI.DivGlowGrad or Instance.new("UIGradient", DivGlow)
        UI.DivGlowGrad.Rotation = 90
        UI.DivGlowGrad.Color = seq
        UI.DivGlowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.4),
            NumberSequenceKeypoint.new(1, 1)
        })
    end

    ApplyThemeToDiv(window.ThemeColor)

    task.spawn(function()
        local RS = game:GetService("RunService")
        local conn
        conn = RS.RenderStepped:Connect(function()
            if not UI.DivGradient or not UI.DivGradient.Parent then
                if conn then conn:Disconnect() end
                return
            end

            local t = os.clock()
            local offset = (t * 0.25) % 2 - 1

            UI.DivGradient.Offset = Vector2.new(0, offset)
            if UI.DivGlowGrad then UI.DivGlowGrad.Offset = Vector2.new(0, offset) end
        end)
    end)

    local RightCol = Instance.new("Frame")
    RightCol.Name = "RightColumn"
    RightCol.LayoutOrder = 3
    RightCol.Size = UDim2.new(0.5, -9, 0, 0)
    RightCol.BackgroundTransparency = 1
    RightCol.Parent = ColContainer
    pcall(function() RightCol.AutomaticSize = Enum.AutomaticSize.Y end)
    local RightLayout = Instance.new("UIListLayout", RightCol)
    RightLayout.Padding = UDim.new(0, 10)
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder

    function UI:CreateGroup(groupName, side)
        local Group = {}
        local parentCol = (side == "Right") and RightCol or LeftCol

        local GroupFrame = Instance.new("Frame")
        GroupFrame.Name = groupName .. "Group"
        GroupFrame.Size = UDim2.new(1, 0, 0, 0)
        GroupFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        GroupFrame.Parent = parentCol
        pcall(function() GroupFrame.AutomaticSize = Enum.AutomaticSize.Y end)

        local GCorner = Instance.new("UICorner")
        GCorner.CornerRadius = UDim.new(0, 6)
        GCorner.Parent = GroupFrame

        local GStroke = Instance.new("UIStroke")
        GStroke.Color = Color3.fromRGB(25, 25, 25)
        GStroke.Thickness = 1
        GStroke.Parent = GroupFrame

        local GTitle = Instance.new("TextLabel")
        GTitle.Size = UDim2.new(1, 0, 0, 25)
        GTitle.Position = UDim2.new(0, 10, 0, 0)
        GTitle.BackgroundTransparency = 1
        GTitle.Text = groupName:upper()
        GTitle.Font = Enum.Font.GothamBold
        GTitle.TextColor3 = Color3.fromRGB(100, 100, 100)
        GTitle.TextSize = 10
        GTitle.TextXAlignment = Enum.TextXAlignment.Left
        GTitle.Parent = GroupFrame

        local GContent = Instance.new("Frame")
        GContent.Size = UDim2.new(1, -20, 0, 0)
        GContent.Position = UDim2.new(0, 10, 0, 25)
        GContent.BackgroundTransparency = 1
        GContent.Parent = GroupFrame
        pcall(function() GContent.AutomaticSize = Enum.AutomaticSize.Y end)

        local GLayout = Instance.new("UIListLayout")
        GLayout.Padding = UDim.new(0, 5)
        GLayout.Parent = GContent

        Instance.new("UIPadding", GContent).PaddingBottom = UDim.new(0, 10)

        local function Decorate(elem)
            function elem:AddDependency(flagName, value)
                local function Update()
                    local parent = window.Flags[flagName]
                    if parent then
                        elem.Frame.Visible = (parent.Value == value)
                    end
                end

                task.spawn(function()
                    while not window.Flags[flagName] do task.wait() end
                    Update()

                    local parent = window.Flags[flagName]
                    if parent.OnChanged then
                        parent.OnChanged.Event:Connect(Update)
                    end
                end)
                return elem
            end
            return elem
        end

        function Group:CreateButton(name, callback)
            local elem = Components.Button.new(GContent, name, callback, window)
            table.insert(UI.Elements, elem)
            return Decorate(elem)
        end

        function Group:CreateToggle(name, default, callback)
            local elem = Components.Toggle.new(GContent, name, default, callback, window)
            window.Flags[name] = elem
            table.insert(UI.Elements, elem)
            return Decorate(elem)
        end

        function Group:CreateSlider(name, min, max, default, callback)
            local elem = Components.Slider.new(GContent, name, min, max, default, callback, window)
            window.Flags[name] = elem
            table.insert(UI.Elements, elem)
            return Decorate(elem)
        end

        function Group:CreateDropdown(name, list, default, multi, callback)
            local elem = Components.Dropdown.new(GContent, name, list, default, multi, callback, window)
            window.Flags[name] = elem
            table.insert(UI.Elements, elem)
            return Decorate(elem)
        end

        function Group:CreateTextBox(name, placeholder, default, clear, callback)
            local elem = Components.TextBox.new(GContent, name, placeholder, default, clear, callback, window)
            window.Flags[name] = elem
            table.insert(UI.Elements, elem)
            return Decorate(elem)
        end

        function Group:CreateKeybind(name, default, callback)
            local elem = Components.Keybind.new(GContent, name, default, callback, window)
            window.Flags[name] = elem
            table.insert(UI.Elements, elem)
            return Decorate(elem)
        end

        function Group:CreateColorPicker(name, default, callback)
            local elem = Components.ColorPicker.new(GContent, name, default, callback, window)
            window.Flags[name] = elem
            table.insert(UI.Elements, elem)
            return Decorate(elem)
        end

        return Group
    end

    function UI:CreateButton(...) return UI:CreateGroup("General"):CreateButton(...) end
    function UI:CreateToggle(...) return UI:CreateGroup("General"):CreateToggle(...) end
    function UI:CreateSlider(...) return UI:CreateGroup("General"):CreateSlider(...) end
    function UI:CreateDropdown(...) return UI:CreateGroup("General"):CreateDropdown(...) end
    function UI:CreateTextBox(...) return UI:CreateGroup("General"):CreateTextBox(...) end
    function UI:CreateKeybind(...) return UI:CreateGroup("General"):CreateKeybind(...) end
    function UI:CreateColorPicker(...) return UI:CreateGroup("General"):CreateColorPicker(...) end

    function UI:SetTheme(color)
        Indicator.BackgroundColor3 = color

        local Divider = UI.Page:FindFirstChild("CenterDivider", true)
        if Divider then
            local seq = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   Color3.new(0,0,0)),
                ColorSequenceKeypoint.new(0.5, color),
                ColorSequenceKeypoint.new(1,   Color3.new(0,0,0)),
            })
            if UI.DivGradient then UI.DivGradient.Color = seq end
            if UI.DivGlowGrad then UI.DivGlowGrad.Color = seq end
        end

        for _, elem in pairs(UI.Elements) do
            if elem.SetTheme then elem:SetTheme(color) end
        end
    end

    if name ~= "System" then
        local anyVisible = false
        for _, tab in pairs(window.Tabs or {}) do
            if tab.Page and tab.Page.Visible then anyVisible = true break end
        end
        if not anyVisible then SetActive(true) end
    end

    return UI
end

return Tab
