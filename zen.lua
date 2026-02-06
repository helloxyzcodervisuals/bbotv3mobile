local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local function Register_Font(Name, Weight, Style, Asset)
    if not isfile(Asset.Id) then
        writefile(Asset.Id, Asset.Font)
    end

    if isfile(Name .. ".font") then
        delfile(Name .. ".font")
    end

    local Data = {
        name = Name,
        faces = {
            {
                name = "Normal",
                weight = Weight,
                style = Style,
                assetId = getcustomasset(Asset.Id),
            },
        },
    }
    writefile(Name .. ".font", HttpService:JSONEncode(Data))

    return getcustomasset(Name .. ".font")
end

local ProggyTiny = Register_Font("ProggyTinyFont", 100, "Normal", {
    Id = "ProggyTiny.ttf",
    Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyTiny.ttf"),
})

local mainFont = Font.new(ProggyTiny, Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local Library = {
    Options = {},
    Theme = {
        MainColor = Color3.fromRGB(150, 100, 255),
        BackgroundColor = Color3.fromRGB(15, 15, 15),
        SectionColor = Color3.fromRGB(22, 22, 22),
        BorderColor = Color3.fromRGB(45, 45, 45),
        AccentColor = Color3.fromRGB(150, 100, 255),
        TextColor = Color3.fromRGB(240, 240, 240),
        Font = mainFont,
    },
    ConfigFolder = "Zenwave_Configs",
    KeybindList = {
        Enabled = false,
        Frame = nil,
        Keybinds = {}
    },
    Configurations = {},
    CurrentTheme = "Default",
    AutoLoadConfig = ""
}

if not isfolder(Library.ConfigFolder) then makefolder(Library.ConfigFolder) end

local function ColorToHSV(color)
    local r, g, b = color.r, color.g, color.b
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    
    v = max
    
    local d = max - min
    if max == 0 then
        s = 0
    else
        s = d / max
    end
    
    if max == min then
        h = 0
    else
        if max == r then
            h = (g - b) / d
            if g < b then
                h = h + 6
            end
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    
    return h, s, v
end

local function HSVToColor(h, s, v)
    local r, g, b
    
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    
    i = i % 6
    
    if i == 0 then
        r, g, b = v, t, p
    elseif i == 1 then
        r, g, b = q, v, p
    elseif i == 2 then
        r, g, b = p, v, t
    elseif i == 3 then
        r, g, b = p, q, v
    elseif i == 4 then
        r, g, b = t, p, v
    elseif i == 5 then
        r, g, b = v, p, q
    end
    
    return Color3.new(r, g, b)
end

local function MakeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Library:CreateWindow(cfg)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.IgnoreGuiInset = true
    
    local width = cfg.Width or 550
    local height = cfg.Height or 580
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, width, 0, height)
    Main.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    Main.BackgroundColor3 = self.Theme.BackgroundColor
    Main.BorderColor3 = self.Theme.BorderColor
    Main.BorderSizePixel = 1
    Main.ClipsDescendants = true
    
    local AccentBar = Instance.new("Frame", Main)
    AccentBar.Size = UDim2.new(1, 0, 0, 3)
    AccentBar.Position = UDim2.new(0, 0, 0, 0)
    AccentBar.BackgroundColor3 = self.Theme.AccentColor
    AccentBar.BorderSizePixel = 0
    
    local Topbar = Instance.new("Frame", Main)
    Topbar.Size = UDim2.new(1, 0, 0, 30)
    Topbar.Position = UDim2.new(0, 0, 0, 3)
    Topbar.BackgroundColor3 = self.Theme.SectionColor
    Topbar.BorderColor3 = self.Theme.BorderColor
    
    local Title = Instance.new("TextLabel", Topbar)
    Title.Text = " " .. (cfg.Title or "ZENWAVE")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.FontFace = self.Theme.Font
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    
    MakeDraggable(Main, Topbar)
    
    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Position = UDim2.new(0, 0, 0, 33)
    TabHolder.Size = UDim2.new(1, 0, 0, 28)
    TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabHolder.BorderColor3 = self.Theme.BorderColor
    
    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    
    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 0, 0, 61)
    Container.Size = UDim2.new(1, 0, 1, -61)
    Container.BackgroundTransparency = 1
    
    local Window = { Tabs = {}, ScreenGui = ScreenGui }
    
    local function LoadAutoConfigs()
        if Library.AutoLoadConfig ~= "" and isfile(Library.ConfigFolder .. "/" .. Library.AutoLoadConfig .. ".json") then
            Window:LoadConfig(Library.AutoLoadConfig)
        end
    end
    
    function Window:AddTab(name)
        local TabBtn = Instance.new("TextButton", TabHolder)
        TabBtn.Size = UDim2.new(0, 100, 1, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.BorderColor3 = Library.Theme.BorderColor
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.FontFace = Library.Theme.Font
        TabBtn.TextSize = 13
        
        local Page = Instance.new("Frame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = (#Container:GetChildren() == 1)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("Frame") then v.Visible = false end end
            Page.Visible = true
        end)
        
        local Left = Instance.new("ScrollingFrame", Page)
        Left.Size = UDim2.new(0.5, -10, 1, -10)
        Left.Position = UDim2.new(0, 5, 0, 5)
        Left.BackgroundTransparency = 1
        Left.ScrollBarThickness = 6
        Left.ScrollBarImageColor3 = Library.Theme.AccentColor
        Left.ScrollBarImageTransparency = 0.5
        
        local LeftLayout = Instance.new("UIListLayout", Left)
        LeftLayout.Padding = UDim.new(0, 15)
        
        LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Left.CanvasSize = UDim2.new(0, 0, 0, LeftLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local Right = Instance.new("ScrollingFrame", Page)
        Right.Size = UDim2.new(0.5, -10, 1, -10)
        Right.Position = UDim2.new(0.5, 5, 0, 5)
        Right.BackgroundTransparency = 1
        Right.ScrollBarThickness = 6
        Right.ScrollBarImageColor3 = Library.Theme.AccentColor
        Right.ScrollBarImageTransparency = 0.5
        
        local RightLayout = Instance.new("UIListLayout", Right)
        RightLayout.Padding = UDim.new(0, 15)
        
        RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Right.CanvasSize = UDim2.new(0, 0, 0, RightLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local Tab = {}
        
        function Tab:AddGroupbox(side, title)
            local ParentCol = (side:lower() == "left") and Left or Right
            local ParentLayout = (side:lower() == "left") and LeftLayout or RightLayout
            
            local Box = Instance.new("Frame", ParentCol)
            Box.BackgroundColor3 = Library.Theme.SectionColor
            Box.BorderColor3 = Library.Theme.BorderColor
            
            local Label = Instance.new("TextLabel", Box)
            Label.Text = " " .. title:upper()
            Label.Size = UDim2.new(1, 0, 0, 18)
            Label.TextColor3 = Library.Theme.AccentColor
            Label.FontFace = Library.Theme.Font
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundColor3 = Library.Theme.SectionColor
            Label.BorderColor3 = Library.Theme.BorderColor
            
            local Content = Instance.new("Frame", Box)
            Content.Position = UDim2.new(0, 0, 0, 22)
            Content.Size = UDim2.new(1, 0, 1, -22)
            Content.BackgroundTransparency = 1
            
            local Layout = Instance.new("UIListLayout", Content)
            Layout.Padding = UDim.new(0, 10)
            Instance.new("UIPadding", Content).PaddingLeft = UDim.new(0, 20)
            
            local Group = {}
            
            local function Resize()
                Box.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y + 35)
            end
            
            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)
            function Group:AddLabel(text)
                local Label = { 
                    Type = "Label", 
                    Value = text or "",
                    Connections = {}
                }
                
                local LblFrame = Instance.new("Frame", Content)
                LblFrame.Size = UDim2.new(1, -10, 0, 20)
                LblFrame.BackgroundTransparency = 1
                
                local LabelText = Instance.new("TextLabel", LblFrame)
                LabelText.Size = UDim2.new(1, 0, 1, 0)
                LabelText.Text = Label.Value
                LabelText.TextColor3 = Library.Theme.TextColor
                LabelText.FontFace = Library.Theme.Font
                LabelText.TextSize = 13
                LabelText.TextXAlignment = Enum.TextXAlignment.Left
                LabelText.BackgroundTransparency = 1
                
                function Label:Set(newText)
                    if Label.Value ~= newText then
                        Label.Value = newText
                        LabelText.Text = newText
                        
                        for _, callback in pairs(Label.Connections) do
                            coroutine.wrap(callback)(newText)
                        end
                    end
                end
                
                function Label:Connect(callback)
                    table.insert(Label.Connections, callback)
                    return {
                        Disconnect = function()
                            for i, conn in ipairs(Label.Connections) do
                                if conn == callback then
                                    table.remove(Label.Connections, i)
                                    break
                                end
                            end
                        end
                    }
                end
                
                Resize()
                return Label
            end
            
            function Group:AddToggle(id, data)
                local Tgl = { 
                    Type = "Toggle", 
                    Value = data.Default or false, 
                    Callback = data.Callback,
                    Connections = {}
                }
                
                local Btn = Instance.new("TextButton", Content)
                Btn.Size = UDim2.new(1, -10, 0, 16)
                Btn.BackgroundTransparency = 1
                Btn.Text = data.Text
                Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                Btn.FontFace = Library.Theme.Font
                Btn.TextXAlignment = Enum.TextXAlignment.Left
                
                local BoxG = Instance.new("Frame", Btn)
                BoxG.Size = UDim2.new(0, 12, 0, 12)
                BoxG.Position = UDim2.new(0, 220, 0.5, -6)
                BoxG.BackgroundColor3 = Tgl.Value and Library.Theme.AccentColor or Color3.fromRGB(35, 35, 35)
                BoxG.BorderColor3 = Library.Theme.BorderColor
                
                function Tgl:Set(v)
                    if Tgl.Value ~= v then
                        Tgl.Value = v
                        BoxG.BackgroundColor3 = v and Library.Theme.AccentColor or Color3.fromRGB(35, 35, 35)
                        
                        for _, callback in pairs(Tgl.Connections) do
                            coroutine.wrap(callback)(v)
                        end
                        
                        if Tgl.Callback then
                            coroutine.wrap(Tgl.Callback)(v)
                        end
                    end
                end
                
                function Tgl:Connect(callback)
                    table.insert(Tgl.Connections, callback)
                    return {
                        Disconnect = function()
                            for i, conn in ipairs(Tgl.Connections) do
                                if conn == callback then
                                    table.remove(Tgl.Connections, i)
                                    break
                                end
                            end
                        end
                    }
                end
                
                Btn.MouseButton1Click:Connect(function() Tgl:Set(not Tgl.Value) end)
                Library.Options[id] = Tgl
                Resize()
                return Tgl
            end
            
            function Group:AddSlider(id, data)
                local Sld = { 
                    Type = "Slider", 
                    Value = data.Default or data.Min, 
                    Min = data.Min, 
                    Max = data.Max, 
                    Text = data.Text, 
                    Callback = data.Callback,
                    Connections = {}
                }
                
                local SFrame = Instance.new("Frame", Content)
                SFrame.Size = UDim2.new(1, -10, 0, 32)
                SFrame.BackgroundTransparency = 1
                
                local L = Instance.new("TextLabel", SFrame)
                L.Size = UDim2.new(1, 0, 0, 14)
                L.TextColor3 = Color3.fromRGB(200, 200, 200)
                L.FontFace = Library.Theme.Font
                L.BackgroundTransparency = 1
                L.TextXAlignment = Enum.TextXAlignment.Left
                
                local BG = Instance.new("Frame", SFrame)
                BG.Position = UDim2.new(0, 0, 0, 18)
                BG.Size = UDim2.new(1, 0, 0, 10)
                BG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                BG.BorderColor3 = Library.Theme.BorderColor
                
                local Fill = Instance.new("Frame", BG)
                Fill.BackgroundColor3 = Library.Theme.AccentColor
                Fill.BorderSizePixel = 0
                
                function Sld:Set(v)
                    v = math.clamp(v, Sld.Min, Sld.Max)
                    if Sld.Value ~= v then
                        Sld.Value = v
                        L.Text = Sld.Text .. ": " .. v
                        Fill.Size = UDim2.new((v - Sld.Min)/(Sld.Max - Sld.Min), 0, 1, 0)
                        
                        for _, callback in pairs(Sld.Connections) do
                            coroutine.wrap(callback)(v)
                        end
                        
                        if Sld.Callback then
                            coroutine.wrap(Sld.Callback)(v)
                        end
                    end
                end
                
                function Sld:Connect(callback)
                    table.insert(Sld.Connections, callback)
                    return {
                        Disconnect = function()
                            for i, conn in ipairs(Sld.Connections) do
                                if conn == callback then
                                    table.remove(Sld.Connections, i)
                                    break
                                end
                            end
                        end
                    }
                end
                
                local function UpdateSlider(input)
                    local p = math.clamp((input.Position.X - BG.AbsolutePosition.X) / BG.AbsoluteSize.X, 0, 1)
                    Sld:Set(math.floor(Sld.Min + (Sld.Max - Sld.Min) * p))
                end
                
                BG.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        UpdateSlider(i)
                        local m; m = UserInputService.InputChanged:Connect(function(i2)
                            if i2.UserInputType == Enum.UserInputType.MouseMovement or i2.UserInputType == Enum.UserInputType.Touch then
                                UpdateSlider(i2)
                            end
                        end)
                        local rel; rel = UserInputService.InputEnded:Connect(function(i3)
                            if i3.UserInputType == Enum.UserInputType.MouseButton1 or i3.UserInputType == Enum.UserInputType.Touch then m:Disconnect() rel:Disconnect() end
                        end)
                    end
                end)
                
                Sld:Set(Sld.Value)
                Library.Options[id] = Sld
                Resize()
                return Sld
            end
            
            function Group:AddListBox(id, data)
                local LBox = { 
                    Type = "ListBox", 
                    Value = nil, 
                    Items = data.Values or {},
                    Container = Content,
                    Scroll = nil,
                    SL = nil,
                    Callback = data.Callback,
                    Connections = {}
                }
                
                local LFrame = Instance.new("Frame", Content)
                LFrame.Size = UDim2.new(1, -10, 0, data.Height or 100)
                LFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                LFrame.BorderColor3 = Library.Theme.BorderColor
                
                local Scroll = Instance.new("ScrollingFrame", LFrame)
                Scroll.Size = UDim2.new(1, 0, 1, 0)
                Scroll.BackgroundTransparency = 1
                Scroll.ScrollBarThickness = 2
                Scroll.ScrollBarImageColor3 = Library.Theme.AccentColor
                
                local SL = Instance.new("UIListLayout", Scroll)
                
                LBox.Scroll = Scroll
                LBox.SL = SL
                
                function LBox:Build()
                    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _, v in pairs(LBox.Items) do
                        local Opt = Instance.new("TextButton", Scroll)
                        Opt.Size = UDim2.new(1, 0, 0, 20)
                        Opt.BackgroundColor3 = (LBox.Value == v) and Color3.fromRGB(35, 35, 35) or Color3.fromRGB(25, 25, 25)
                        Opt.Text = " " .. v
                        Opt.TextColor3 = (LBox.Value == v) and Library.Theme.AccentColor or Color3.fromRGB(180, 180, 180)
                        Opt.FontFace = Library.Theme.Font
                        Opt.TextSize = 12
                        Opt.TextXAlignment = Enum.TextXAlignment.Left
                        Opt.BackgroundTransparency = 1
                        Opt.MouseButton1Click:Connect(function() LBox:Set(v) end)
                    end
                    Scroll.CanvasSize = UDim2.new(0, 0, 0, SL.AbsoluteContentSize.Y)
                end
                
                function LBox:Set(v) 
                    if LBox.Value ~= v then
                        LBox.Value = v 
                        LBox:Build() 
                        
                        for _, callback in pairs(LBox.Connections) do
                            coroutine.wrap(callback)(v)
                        end
                        
                        if LBox.Callback then 
                            coroutine.wrap(LBox.Callback)(v) 
                        end
                    end
                end
                
                function LBox:Connect(callback)
                    table.insert(LBox.Connections, callback)
                    return {
                        Disconnect = function()
                            for i, conn in ipairs(LBox.Connections) do
                                if conn == callback then
                                    table.remove(LBox.Connections, i)
                                    break
                                end
                            end
                        end
                    }
                end
                
                function LBox:Add(value)
                    table.insert(LBox.Items, value)
                    LBox:Build()
                    return self
                end
                
                function LBox:Remove(value)
                    for i, v in ipairs(LBox.Items) do
                        if v == value then
                            table.remove(LBox.Items, i)
                            break
                        end
                    end
                    if LBox.Value == value then
                        LBox.Value = nil
                    end
                    LBox:Build()
                    return self
                end
                
                function LBox:Refresh(newItems)
                    LBox.Items = newItems or LBox.Items
                    LBox:Build()
                    return self
                end
                
                function LBox:Clear()
                    LBox.Items = {}
                    LBox.Value = nil
                    LBox:Build()
                    return self
                end
                
                LBox:Build()
                Library.Options[id] = LBox
                Resize()
                return LBox
            end
            
            function Group:AddInput(id, data)
                local Inp = { 
                    Type = "Input", 
                    Value = data.Default or "", 
                    Callback = data.Callback,
                    Connections = {}
                }
                
                local IFrame = Instance.new("Frame", Content)
                IFrame.Size = UDim2.new(1, -10, 0, 35)
                IFrame.BackgroundTransparency = 1
                
                local L = Instance.new("TextLabel", IFrame)
                L.Text = data.Text
                L.Size = UDim2.new(1, 0, 0, 14)
                L.TextColor3 = Color3.fromRGB(200, 200, 200)
                L.FontFace = Library.Theme.Font
                L.TextXAlignment = Enum.TextXAlignment.Left
                L.BackgroundTransparency = 1
                
                local Box = Instance.new("TextBox", IFrame)
                Box.Position = UDim2.new(0, 0, 0, 18)
                Box.Size = UDim2.new(1, 0, 0, 18)
                Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Box.BorderColor3 = Library.Theme.BorderColor
                Box.TextColor3 = Color3.fromRGB(255, 255, 255)
                Box.FontFace = Library.Theme.Font
                Box.TextSize = 12
                Box.Text = Inp.Value
                
                function Inp:Set(v)
                    if Inp.Value ~= v then
                        Inp.Value = v
                        Box.Text = v
                        
                        for _, callback in pairs(Inp.Connections) do
                            coroutine.wrap(callback)(v)
                        end
                        
                        if Inp.Callback then 
                            coroutine.wrap(Inp.Callback)(v) 
                        end
                    end
                end
                
                function Inp:Connect(callback)
                    table.insert(Inp.Connections, callback)
                    return {
                        Disconnect = function()
                            for i, conn in ipairs(Inp.Connections) do
                                if conn == callback then
                                    table.remove(Inp.Connections, i)
                                    break
                                end
                            end
                        end
                    }
                end
                
                Box.FocusLost:Connect(function() 
                    Inp:Set(Box.Text)
                end)
                
                Library.Options[id] = Inp
                Resize()
                return Inp
            end
            
            function Group:AddButton(data)
                local Btn = Instance.new("TextButton", Content)
                Btn.Size = UDim2.new(1, -10, 0, 22)
                Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Btn.BorderColor3 = Library.Theme.BorderColor
                Btn.Text = data.Text
                Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
                Btn.FontFace = Library.Theme.Font
                Btn.TextSize = 13
                Btn.MouseButton1Click:Connect(data.Func)
                Resize()
                return {
                    Click = Btn.MouseButton1Click
                }
            end
            
            function Group:AddColorPicker(id, data)
                local CP = { 
                    Type = "ColorPicker", 
                    Value = data.Default or Color3.new(1,1,1), 
                    Open = false, 
                    Callback = data.Callback,
                    Connections = {}
                }
                
                local h, s, v = ColorToHSV(CP.Value)
                CP.H, CP.S, CP.V = h, s, v
                
                local PickerFrame = Instance.new("Frame", Content)
                PickerFrame.Size = UDim2.new(1, -10, 0, 20)
                PickerFrame.BackgroundTransparency = 1
                
                local L = Instance.new("TextLabel", PickerFrame)
                L.Text = data.Text
                L.Size = UDim2.new(1, 0, 1, 0)
                L.TextColor3 = Color3.fromRGB(200, 200, 200)
                L.FontFace = Library.Theme.Font
                L.TextXAlignment = Enum.TextXAlignment.Left
                L.BackgroundTransparency = 1
                
                local Box = Instance.new("TextButton", PickerFrame)
                Box.Size = UDim2.new(0, 35, 0, 14)
                Box.Position = UDim2.new(1, -40, 0.5, -7)
                Box.BackgroundColor3 = CP.Value
                Box.BorderColor3 = Library.Theme.BorderColor
                Box.Text = ""
                
                local MainUI = Instance.new("Frame", Content)
                MainUI.Size = UDim2.new(1, -10, 0, 120)
                MainUI.BackgroundColor3 = Library.Theme.SectionColor
                MainUI.BorderColor3 = Library.Theme.BorderColor
                MainUI.Visible = false
                
                local SVCanvas = Instance.new("TextButton", MainUI)
                SVCanvas.Size = UDim2.new(0, 100, 0, 100)
                SVCanvas.Position = UDim2.new(0, 10, 0, 10)
                SVCanvas.AutoButtonColor = false
                SVCanvas.Text = ""
                
                local WhiteGrad = Instance.new("Frame", SVCanvas)
                WhiteGrad.Size = UDim2.new(1,0,1,0)
                local WG = Instance.new("UIGradient", WhiteGrad)
                WG.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)})
                
                local BlackGrad = Instance.new("Frame", SVCanvas)
                BlackGrad.Size = UDim2.new(1,0,1,0)
                local BG = Instance.new("UIGradient", BlackGrad)
                BG.Rotation = 90
                BG.Color = ColorSequence.new(Color3.new(0,0,0))
                BG.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)})
                
                local Cursor = Instance.new("Frame", SVCanvas)
                Cursor.Size = UDim2.new(0, 4, 0, 4)
                Cursor.BackgroundColor3 = Color3.new(1,1,1)
                Cursor.BorderSizePixel = 1
                
                local HueSlider = Instance.new("TextButton", MainUI)
                HueSlider.Size = UDim2.new(0, 15, 0, 100)
                HueSlider.Position = UDim2.new(0, 120, 0, 10)
                HueSlider.Text = ""
                local HG = Instance.new("UIGradient", HueSlider)
                HG.Rotation = 90
                HG.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1,0,0)),
                    ColorSequenceKeypoint.new(0.16, Color3.new(1,1,0)),
                    ColorSequenceKeypoint.new(0.33, Color3.new(0,1,0)),
                    ColorSequenceKeypoint.new(0.5, Color3.new(0,1,1)),
                    ColorSequenceKeypoint.new(0.66, Color3.new(0,0,1)),
                    ColorSequenceKeypoint.new(0.83, Color3.new(1,0,1)),
                    ColorSequenceKeypoint.new(1, Color3.new(1,0,0))
                })
                
                local HueCursor = Instance.new("Frame", HueSlider)
                HueCursor.Size = UDim2.new(1, 4, 0, 2)
                HueCursor.Position = UDim2.new(0, -2, 0, 0)
                HueCursor.BackgroundColor3 = Color3.new(1,1,1)
                
                function CP:Update()
                    local finalColor = HSVToColor(CP.H, CP.S, CP.V)
                    if CP.Value ~= finalColor then
                        CP.Value = finalColor
                        Box.BackgroundColor3 = finalColor
                        SVCanvas.BackgroundColor3 = HSVToColor(CP.H, 1, 1)
                        Cursor.Position = UDim2.new(CP.S, -2, 1 - CP.V, -2)
                        HueCursor.Position = UDim2.new(0, -2, 1 - CP.H, -1)
                        
                        for _, callback in pairs(CP.Connections) do
                            coroutine.wrap(callback)(finalColor)
                        end
                        
                        if CP.Callback then 
                            coroutine.wrap(CP.Callback)(finalColor) 
                        end
                    end
                end
                
                function CP:Set(color)
                    local h, s, v = ColorToHSV(color)
                    CP.H, CP.S, CP.V = h, s, v
                    CP:Update()
                end
                
                function CP:Connect(callback)
                    table.insert(CP.Connections, callback)
                    return {
                        Disconnect = function()
                            for i, conn in ipairs(CP.Connections) do
                                if conn == callback then
                                    table.remove(CP.Connections, i)
                                    break
                                end
                            end
                        end
                    }
                end
                
                SVCanvas.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        local function move(i2)
                            CP.S = math.clamp((i2.Position.X - SVCanvas.AbsolutePosition.X) / SVCanvas.AbsoluteSize.X, 0, 1)
                            CP.V = 1 - math.clamp((i2.Position.Y - SVCanvas.AbsolutePosition.Y) / SVCanvas.AbsoluteSize.Y, 0, 1)
                            CP:Update()
                        end
                        move(i)
                        local m; m = UserInputService.InputChanged:Connect(function(i2)
                            if i2.UserInputType == Enum.UserInputType.MouseMovement or i2.UserInputType == Enum.UserInputType.Touch then move(i2) end
                        end)
                        local rel; rel = UserInputService.InputEnded:Connect(function(i3)
                            if i3.UserInputType == Enum.UserInputType.MouseButton1 or i3.UserInputType == Enum.UserInputType.Touch then m:Disconnect() rel:Disconnect() end
                        end)
                    end
                end)
                
                HueSlider.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        local function move(i2)
                            CP.H = 1 - math.clamp((i2.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
                            CP:Update()
                        end
                        move(i)
                        local m; m = UserInputService.InputChanged:Connect(function(i2)
                            if i2.UserInputType == Enum.UserInputType.MouseMovement or i2.UserInputType == Enum.UserInputType.Touch then move(i2) end
                        end)
                        local rel; rel = UserInputService.InputEnded:Connect(function(i3)
                            if i3.UserInputType == Enum.UserInputType.MouseButton1 or i3.UserInputType == Enum.UserInputType.Touch then m:Disconnect() rel:Disconnect() end
                        end)
                    end
                end)
                
                Box.MouseButton1Click:Connect(function() 
                    CP.Open = not CP.Open 
                    MainUI.Visible = CP.Open 
                    Resize() 
                end)
                
                CP:Update()
                Library.Options[id] = CP
                Resize()
                return CP
            end
            
            function Group:AddKeybind(id, data)
                local KB = { 
                    Type = "Keybind", 
                    Value = data.Default or Enum.KeyCode.RightControl, 
                    Binding = false, 
                    Callback = data.Callback,
                    Connections = {}
                }
                
                local KFrame = Instance.new("Frame", Content)
                KFrame.Size = UDim2.new(1, -10, 0, 20)
                KFrame.BackgroundTransparency = 1
                
                local L = Instance.new("TextLabel", KFrame)
                L.Text = data.Text
                L.Size = UDim2.new(1, 0, 1, 0)
                L.TextColor3 = Color3.fromRGB(200, 200, 200)
                L.FontFace = Library.Theme.Font
                L.TextXAlignment = Enum.TextXAlignment.Left
                L.BackgroundTransparency = 1
                
                local Box = Instance.new("TextButton", KFrame)
                Box.Size = UDim2.new(0, 60, 0, 14)
                Box.Position = UDim2.new(1, -65, 0.5, -7)
                Box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Box.TextColor3 = Library.Theme.AccentColor
                Box.FontFace = Library.Theme.Font
                Box.TextSize = 10
                Box.Text = KB.Value.Name
                
                function KB:Set(key)
                    KB.Value = key
                    Box.Text = key.Name
                    
                    for _, callback in pairs(KB.Connections) do
                        coroutine.wrap(callback)(key)
                    end
                    
                    if KB.Callback then 
                        coroutine.wrap(KB.Callback)(key) 
                    end
                end
                
                function KB:Connect(callback)
                    table.insert(KB.Connections, callback)
                    return {
                        Disconnect = function()
                            for i, conn in ipairs(KB.Connections) do
                                if conn == callback then
                                    table.remove(KB.Connections, i)
                                    break
                                end
                            end
                        end
                    }
                end
                
                Box.MouseButton1Click:Connect(function() 
                    Box.Text = "..." 
                    KB.Binding = true 
                end)
                
                UserInputService.InputBegan:Connect(function(i)
                    if KB.Binding and i.UserInputType == Enum.UserInputType.Keyboard then
                        KB:Set(i.KeyCode)
                        KB.Binding = false
                    end
                end)
                
                Resize()
                Library.Options[id] = KB
                return KB
            end
            
            return Group
        end
        return Tab
    end
    
    function Window:CreateKeybindList()
        if Library.KeybindList.Frame then Library.KeybindList.Frame:Destroy() end
        
        local KeybindFrame = Instance.new("Frame", ScreenGui)
        KeybindFrame.Size = UDim2.new(0, 250, 0, 300)
        KeybindFrame.Position = UDim2.new(1, -260, 0.5, -150)
        KeybindFrame.BackgroundColor3 = Library.Theme.BackgroundColor
        KeybindFrame.BorderColor3 = Library.Theme.BorderColor
        KeybindFrame.BorderSizePixel = 1
        
        local AccentBar = Instance.new("Frame", KeybindFrame)
        AccentBar.Size = UDim2.new(1, 0, 0, 3)
        AccentBar.BackgroundColor3 = Library.Theme.AccentColor
        AccentBar.BorderSizePixel = 0
        
        local Header = Instance.new("Frame", KeybindFrame)
        Header.Size = UDim2.new(1, 0, 0, 25)
        Header.Position = UDim2.new(0, 0, 0, 3)
        Header.BackgroundColor3 = Library.Theme.SectionColor
        Header.BackgroundTransparency = 1
        local Title = Instance.new("TextLabel", Header)
        Title.Text = "KEYBINDS"
        Title.Size = UDim2.new(1, 0, 1, 0)
        Title.TextColor3 = Library.Theme.AccentColor
        Title.FontFace = Library.Theme.Font
        Title.TextSize = 13
        Title.BackgroundTransparency = 1
        
        MakeDraggable(KeybindFrame, Header)
        
        local Content = Instance.new("ScrollingFrame", KeybindFrame)
        Content.Size = UDim2.new(1, -10, 1, -35)
        Content.Position = UDim2.new(0, 5, 0, 30)
        Content.BackgroundTransparency = 1
        Content.ScrollBarThickness = 2
        Content.ScrollBarImageColor3 = Library.Theme.AccentColor
        
        local ListLayout = Instance.new("UIListLayout", Content)
        ListLayout.Padding = UDim.new(0, 5)
        
        ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Content.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
        end)
        
        function Window:UpdateKeybindList()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
            
            for id, option in pairs(Library.Options) do
                if option.Type == "Keybind" then
                    local Entry = Instance.new("Frame", Content)
                    Entry.Size = UDim2.new(1, 0, 0, 25)
                    Entry.BackgroundTransparency = 1
                    
                    local NameLabel = Instance.new("TextLabel", Entry)
                    NameLabel.Text = id
                    NameLabel.Size = UDim2.new(0.6, 0, 1, 0)
                    NameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                    NameLabel.FontFace = Library.Theme.Font
                    NameLabel.TextSize = 12
                    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                    NameLabel.BackgroundTransparency = 1
                    
                    local KeyLabel = Instance.new("TextLabel", Entry)
                    KeyLabel.Text = option.Value.Name
                    KeyLabel.Size = UDim2.new(0.4, 0, 1, 0)
                    KeyLabel.Position = UDim2.new(0.6, 0, 0, 0)
                    KeyLabel.TextColor3 = Library.Theme.AccentColor
                    KeyLabel.FontFace = Library.Theme.Font
                    KeyLabel.TextSize = 12
                    KeyLabel.TextXAlignment = Enum.TextXAlignment.Right
                    KeyLabel.BackgroundTransparency = 1
                    
                    Library.KeybindList.Keybinds[id] = KeyLabel
                end
            end
        end
        
        Window:UpdateKeybindList()
        
        Library.KeybindList.Frame = KeybindFrame
        Library.KeybindList.Enabled = true
        
        return Window
    end
    
    function Window:ToggleKeybindList()
        if Library.KeybindList.Enabled and Library.KeybindList.Frame then
            Library.KeybindList.Frame.Visible = not Library.KeybindList.Frame.Visible
        else
            Window:CreateKeybindList()
        end
    end
    
    function Window:SaveConfig(name)
        if not name or name == "" then
            warn("Configuration name cannot be empty!")
            return false
        end
        
        local configData = {}
        
        for id, option in pairs(Library.Options) do
            if option.Type == "Toggle" then
                configData[id] = {Type = "Toggle", Value = option.Value}
            elseif option.Type == "Slider" then
                configData[id] = {Type = "Slider", Value = option.Value}
            elseif option.Type == "Input" then
                configData[id] = {Type = "Input", Value = option.Value}
            elseif option.Type == "ColorPicker" then
                configData[id] = {Type = "ColorPicker", Value = {r = option.Value.r, g = option.Value.g, b = option.Value.b}}
            elseif option.Type == "Keybind" then
                configData[id] = {Type = "Keybind", Value = option.Value.Name}
            end
        end
        
        local jsonData = HttpService:JSONEncode(configData)
        local fileName = name .. ".json"
        local filePath = Library.ConfigFolder .. "/" .. fileName
        
        writefile(filePath, jsonData)
        print("Configuration saved:", name)
        return true
    end
    
    function Window:LoadConfig(name)
        if not name or name == "" then
            warn("Configuration name cannot be empty!")
            return false
        end
        
        local fileName = name .. ".json"
        local filePath = Library.ConfigFolder .. "/" .. fileName
        
        if not isfile(filePath) then
            warn("Configuration file not found:", name)
            return false
        end
        
        local success, configData = pcall(function()
            local jsonData = readfile(filePath)
            return HttpService:JSONDecode(jsonData)
        end)
        
        if not success then
            warn("Failed to load configuration:", name)
            return false
        end
        
        for id, data in pairs(configData) do
            local option = Library.Options[id]
            if option then
                if option.Type == "Toggle" and data.Type == "Toggle" then
                    option:Set(data.Value)
                elseif option.Type == "Slider" and data.Type == "Slider" then
                    option:Set(data.Value)
                elseif option.Type == "Input" and data.Type == "Input" then
                    option.Value = data.Value
                    if option.Callback then option.Callback(data.Value) end
                elseif option.Type == "ColorPicker" and data.Type == "ColorPicker" then
                    local color = Color3.new(data.Value.r or 1, data.Value.g or 1, data.Value.b or 1)
                    option.Value = color
                    if option.Callback then option.Callback(color) end
                elseif option.Type == "Keybind" and data.Type == "Keybind" then
                    local keyCode = Enum.KeyCode[data.Value]
                    if keyCode then
                        option.Value = keyCode
                        if option.Callback then option.Callback(keyCode) end
                    end
                end
            end
        end
        
        print("Configuration loaded:", name)
        return true
    end
    
    function Window:DeleteConfig(name)
        if not name or name == "" then
            warn("Configuration name cannot be empty!")
            return false
        end
        
        local fileName = name .. ".json"
        local filePath = Library.ConfigFolder .. "/" .. fileName
        
        if not isfile(filePath) then
            warn("Configuration file not found:", name)
            return false
        end
        
        delfile(filePath)
        print("Configuration deleted:", name)
        return true
    end
    
    function Window:GetConfigList()
        local configs = {}
        for _, file in pairs(listfiles(Library.ConfigFolder)) do
            if file:sub(-5) == ".json" then
                local name = file:match(".*/(.*)%.json")
                if name then
                    table.insert(configs, name)
                end
            end
        end
        return configs
    end
    
    function Window:CreateConfigUI()
        local ConfigFrame = Instance.new("Frame", ScreenGui)
        ConfigFrame.Size = UDim2.new(0, 300, 0, 400)
        ConfigFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
        ConfigFrame.BackgroundColor3 = Library.Theme.BackgroundColor
        ConfigFrame.BorderColor3 = Library.Theme.BorderColor
        ConfigFrame.BorderSizePixel = 1
        
        local AccentBar = Instance.new("Frame", ConfigFrame)
        AccentBar.Size = UDim2.new(1, 0, 0, 3)
        AccentBar.BackgroundColor3 = Library.Theme.AccentColor
        AccentBar.BorderSizePixel = 0
        
        local Header = Instance.new("Frame", ConfigFrame)
        Header.Size = UDim2.new(1, 0, 0, 30)
        Header.Position = UDim2.new(0, 0, 0, 3)
        Header.BackgroundColor3 = Library.Theme.SectionColor
        
        local Title = Instance.new("TextLabel", Header)
        Title.Text = "CONFIGURATIONS"
        Title.Size = UDim2.new(1, 0, 1, 0)
        Title.TextColor3 = Library.Theme.AccentColor
        Title.FontFace = Library.Theme.Font
        Title.TextSize = 14
        Title.BackgroundTransparency = 1
        
        MakeDraggable(ConfigFrame, Header)
        
        local CloseBtn = Instance.new("TextButton", Header)
        CloseBtn.Size = UDim2.new(0, 30, 1, 0)
        CloseBtn.Position = UDim2.new(1, -30, 0, 0)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        CloseBtn.BorderColor3 = Library.Theme.BorderColor
        CloseBtn.Text = "X"
        CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        CloseBtn.FontFace = Library.Theme.Font
        CloseBtn.TextSize = 14
        CloseBtn.MouseButton1Click:Connect(function()
            ConfigFrame:Destroy()
        end)
        
        local Content = Instance.new("ScrollingFrame", ConfigFrame)
        Content.Size = UDim2.new(1, -10, 1, -50)
        Content.Position = UDim2.new(0, 5, 0, 35)
        Content.BackgroundTransparency = 1
        Content.ScrollBarThickness = 2
        
        local ListLayout = Instance.new("UIListLayout", Content)
        ListLayout.Padding = UDim.new(0, 5)
        
        local InputFrame = Instance.new("Frame", ConfigFrame)
        InputFrame.Size = UDim2.new(1, -10, 0, 30)
        InputFrame.Position = UDim2.new(0, 5, 1, -35)
        InputFrame.BackgroundTransparency = 1
        
        local ConfigInput = Instance.new("TextBox", InputFrame)
        ConfigInput.Size = UDim2.new(0.7, 0, 1, 0)
        ConfigInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ConfigInput.BorderColor3 = Library.Theme.BorderColor
        ConfigInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        ConfigInput.FontFace = Library.Theme.Font
        ConfigInput.TextSize = 12
        ConfigInput.PlaceholderText = "Config name..."
        ConfigInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        
        local SaveBtn = Instance.new("TextButton", InputFrame)
        SaveBtn.Size = UDim2.new(0.15, -2, 1, 0)
        SaveBtn.Position = UDim2.new(0.7, 2, 0, 0)
        SaveBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        SaveBtn.BorderColor3 = Library.Theme.BorderColor
        SaveBtn.Text = "Save"
        SaveBtn.TextColor3 = Library.Theme.AccentColor
        SaveBtn.FontFace = Library.Theme.Font
        SaveBtn.TextSize = 12
        
        local LoadBtn = Instance.new("TextButton", InputFrame)
        LoadBtn.Size = UDim2.new(0.15, -2, 1, 0)
        LoadBtn.Position = UDim2.new(0.85, 2, 0, 0)
        LoadBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        LoadBtn.BorderColor3 = Library.Theme.BorderColor
        LoadBtn.Text = "Load"
        LoadBtn.TextColor3 = Library.Theme.AccentColor
        LoadBtn.FontFace = Library.Theme.Font
        LoadBtn.TextSize = 12
        
        local function RefreshConfigList()
            for _, v in pairs(Content:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
            
            local configs = Window:GetConfigList()
            for _, configName in pairs(configs) do
                local ConfigEntry = Instance.new("Frame", Content)
                ConfigEntry.Size = UDim2.new(1, 0, 0, 30)
                ConfigEntry.BackgroundTransparency = 1
                
                local NameLabel = Instance.new("TextLabel", ConfigEntry)
                NameLabel.Text = configName
                NameLabel.Size = UDim2.new(0.6, 0, 1, 0)
                NameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                NameLabel.FontFace = Library.Theme.Font
                NameLabel.TextSize = 12
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                NameLabel.BackgroundTransparency = 1
                
                local LoadEntryBtn = Instance.new("TextButton", ConfigEntry)
                LoadEntryBtn.Size = UDim2.new(0.2, -2, 0.7, 0)
                LoadEntryBtn.Position = UDim2.new(0.6, 2, 0.15, 0)
                LoadEntryBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                LoadEntryBtn.BorderColor3 = Library.Theme.BorderColor
                LoadEntryBtn.Text = "Load"
                LoadEntryBtn.TextColor3 = Library.Theme.AccentColor
                LoadEntryBtn.FontFace = Library.Theme.Font
                LoadEntryBtn.TextSize = 10
                LoadEntryBtn.MouseButton1Click:Connect(function()
                    Window:LoadConfig(configName)
                end)
                
                local DeleteEntryBtn = Instance.new("TextButton", ConfigEntry)
                DeleteEntryBtn.Size = UDim2.new(0.2, -2, 0.7, 0)
                DeleteEntryBtn.Position = UDim2.new(0.8, 2, 0.15, 0)
                DeleteEntryBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                DeleteEntryBtn.BorderColor3 = Library.Theme.BorderColor
                DeleteEntryBtn.Text = "Delete"
                DeleteEntryBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
                DeleteEntryBtn.FontFace = Library.Theme.Font
                DeleteEntryBtn.TextSize = 10
                DeleteEntryBtn.MouseButton1Click:Connect(function()
                    Window:DeleteConfig(configName)
                    RefreshConfigList()
                end)
            end
            
            Content.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
        end
        
        SaveBtn.MouseButton1Click:Connect(function()
            if ConfigInput.Text ~= "" then
                Window:SaveConfig(ConfigInput.Text)
                ConfigInput.Text = ""
                RefreshConfigList()
            end
        end)
        
        LoadBtn.MouseButton1Click:Connect(function()
            if ConfigInput.Text ~= "" then
                Window:LoadConfig(ConfigInput.Text)
                ConfigInput.Text = ""
            end
        end)
        
        RefreshConfigList()
        
        return ConfigFrame
    end
    
    function Window:ToggleConfigUI()
        local existing = ScreenGui:FindFirstChild("ConfigUI")
        if existing then
            existing:Destroy()
        else
            Window:CreateConfigUI()
        end
    end
    
    local ToggleBtn = Instance.new("TextButton", Topbar)
    ToggleBtn.Size = UDim2.new(0, 100, 1, 0)
    ToggleBtn.Position = UDim2.new(1, -105, 0, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ToggleBtn.BorderColor3 = Library.Theme.BorderColor
    ToggleBtn.Text = "KEYBINDS"
    ToggleBtn.TextColor3 = Library.Theme.AccentColor
    ToggleBtn.FontFace = Library.Theme.Font
    ToggleBtn.TextSize = 12
    ToggleBtn.MouseButton1Click:Connect(function() Window:ToggleKeybindList() end)
    
    local ConfigBtn = Instance.new("TextButton", Topbar)
    ConfigBtn.Size = UDim2.new(0, 100, 1, 0)
    ConfigBtn.Position = UDim2.new(1, -210, 0, 0)
    ConfigBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ConfigBtn.BorderColor3 = Library.Theme.BorderColor
    ConfigBtn.Text = "CONFIG"
    ConfigBtn.TextColor3 = Library.Theme.AccentColor
    ConfigBtn.FontFace = Library.Theme.Font
    ConfigBtn.TextSize = 12
    ConfigBtn.MouseButton1Click:Connect(function() Window:ToggleConfigUI() end)
    
    LoadAutoConfigs()
    
    return Window
end

return Library