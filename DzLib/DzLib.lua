if getgenv().Library then
    getgenv().Library:Unload()
end

local Library do
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local TextService = game:GetService("TextService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local function FallbackFromHex(Hex)
        Hex = tostring(Hex or ""):gsub("#", "")

        if #Hex == 3 then
            Hex = Hex:sub(1, 1) .. Hex:sub(1, 1)
                .. Hex:sub(2, 2) .. Hex:sub(2, 2)
                .. Hex:sub(3, 3) .. Hex:sub(3, 3)
        end

        local R = tonumber(Hex:sub(1, 2), 16) or 255
        local G = tonumber(Hex:sub(3, 4), 16) or 255
        local B = tonumber(Hex:sub(5, 6), 16) or 255

        return Color3.fromRGB(R, G, B)
    end

    local function FallbackClamp(Value, Min, Max)
        if Value < Min then
            return Min
        end

        if Value > Max then
            return Max
        end

        return Value
    end

    local function FallbackFind(List, Target)
        for Index, Value in next, List do
            if Value == Target then
                return Index
            end
        end
    end

    local function FallbackClone(List)
        local NewList = {}

        for Index, Value in next, List do
            NewList[Index] = Value
        end

        return NewList
    end

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex or FallbackFromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local UDim2FromOffset = UDim2.fromOffset
    local TweenInfoNew = TweenInfo.new
    local Vector2New = Vector2.new
    local Vector3New = Vector3.new

    local MathClamp = math.clamp or FallbackClamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find or FallbackFind
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone or FallbackClone
    local TableUnpack = table.unpack or unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len

    local InstanceNew = Instance.new

    local RectNew = Rect.new

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.RightControl), 
        DefaultToggleButtonIcon = "rbxassetid://85556830856878",
        DefaultToggleButtonPosition = UDim2.new(0.5, -25, 0, 50),
        DefaultKeybindListPosition = UDim2.new(1, -18, 0, 120),
        DefaultHeaderLogo = "rbxassetid://75802679174420",
        DefaultHeaderLogoSize = 52,

        Flags = { },
        KeybindRegistry = { },
        KeybindLists = { },

        Tween = {
            Time = 0.2,
            Style = Enum.EasingStyle.Quart,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "DZHUB",
            Configs = "DZHUB/Configs",
            Assets = "DZHUB/Assets",
            Settings = "DZHUB/Settings",
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },
        CleanupCallbacks = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },
        IgnoredFlags = { },

        ExecutorSettings = {
            AutoExec = false,
            MenuKeybind = nil
        },

        _ExecutorSettingsLoaded = false,
        _AutoExecRunId = 0,
        _AutoExecLastQueuedFingerprint = nil,
        _AutoLoadApplied = false,
        _AutoLoadScheduled = false,

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,

        Font = nil,
        Unloading = false,
        Unloaded = false
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    Library.IsMobileClient = function(self)
        return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    end

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    local Themes = {
        ["Preset"] = {
            ["Background"]   = FromRGB(12, 13, 15),
            ["Panel"]        = FromRGB(16, 18, 21),
            ["Surface"]      = FromRGB(20, 22, 26),
            ["Inline"]       = FromRGB(17, 19, 22),
            ["Element"]      = FromRGB(25, 28, 33),
            ["Outline"]      = FromRGB(56, 61, 70),
            ["OutlineSoft"]  = FromRGB(38, 42, 49),
            ["Accent"]       = FromRGB(125, 181, 255),
            ["AccentSoft"]   = FromRGB(28, 47, 73),
            ["Text"]         = FromRGB(245, 247, 250),
            ["TextMuted"]    = FromRGB(159, 168, 181)
        },
        ["Midnight"] = {
            ["Background"]   = FromRGB(8, 9, 12),
            ["Panel"]        = FromRGB(13, 14, 18),
            ["Surface"]      = FromRGB(16, 18, 22),
            ["Inline"]       = FromRGB(14, 15, 19),
            ["Element"]      = FromRGB(22, 24, 28),
            ["Outline"]      = FromRGB(45, 48, 55),
            ["OutlineSoft"]  = FromRGB(30, 33, 39),
            ["Accent"]       = FromRGB(99, 102, 241),
            ["AccentSoft"]   = FromRGB(35, 38, 80),
            ["Text"]         = FromRGB(241, 245, 249),
            ["TextMuted"]    = FromRGB(148, 163, 184)
        },
        ["Ocean"] = {
            ["Background"]   = FromRGB(8, 18, 26),
            ["Panel"]        = FromRGB(11, 24, 35),
            ["Surface"]      = FromRGB(15, 30, 43),
            ["Inline"]       = FromRGB(13, 26, 38),
            ["Element"]      = FromRGB(18, 35, 50),
            ["Outline"]      = FromRGB(40, 70, 95),
            ["OutlineSoft"]  = FromRGB(28, 50, 70),
            ["Accent"]       = FromRGB(56, 189, 248),
            ["AccentSoft"]   = FromRGB(15, 50, 70),
            ["Text"]         = FromRGB(236, 254, 255),
            ["TextMuted"]    = FromRGB(125, 165, 185)
        },
        ["Crimson"] = {
            ["Background"]   = FromRGB(15, 8, 10),
            ["Panel"]        = FromRGB(20, 12, 14),
            ["Surface"]      = FromRGB(26, 16, 19),
            ["Inline"]       = FromRGB(22, 14, 16),
            ["Element"]      = FromRGB(30, 19, 22),
            ["Outline"]      = FromRGB(75, 38, 45),
            ["OutlineSoft"]  = FromRGB(50, 26, 32),
            ["Accent"]       = FromRGB(248, 113, 113),
            ["AccentSoft"]   = FromRGB(80, 25, 30),
            ["Text"]         = FromRGB(254, 242, 242),
            ["TextMuted"]    = FromRGB(180, 145, 145)
        },
        ["Forest"] = {
            ["Background"]   = FromRGB(8, 16, 12),
            ["Panel"]        = FromRGB(11, 22, 16),
            ["Surface"]      = FromRGB(15, 28, 21),
            ["Inline"]       = FromRGB(13, 25, 18),
            ["Element"]      = FromRGB(18, 33, 25),
            ["Outline"]      = FromRGB(40, 70, 50),
            ["OutlineSoft"]  = FromRGB(28, 50, 36),
            ["Accent"]       = FromRGB(74, 222, 128),
            ["AccentSoft"]   = FromRGB(20, 60, 35),
            ["Text"]         = FromRGB(240, 253, 244),
            ["TextMuted"]    = FromRGB(155, 185, 165)
        },
        ["Sunset"] = {
            ["Background"]   = FromRGB(20, 12, 10),
            ["Panel"]        = FromRGB(28, 17, 14),
            ["Surface"]      = FromRGB(35, 22, 18),
            ["Inline"]       = FromRGB(30, 19, 16),
            ["Element"]      = FromRGB(42, 27, 22),
            ["Outline"]      = FromRGB(110, 65, 45),
            ["OutlineSoft"]  = FromRGB(70, 42, 30),
            ["Accent"]       = FromRGB(251, 146, 60),
            ["AccentSoft"]   = FromRGB(95, 45, 20),
            ["Text"]         = FromRGB(255, 247, 237),
            ["TextMuted"]    = FromRGB(195, 165, 145)
        },
        ["Amethyst"] = {
            ["Background"]   = FromRGB(15, 10, 22),
            ["Panel"]        = FromRGB(21, 14, 30),
            ["Surface"]      = FromRGB(27, 18, 38),
            ["Inline"]       = FromRGB(23, 15, 33),
            ["Element"]      = FromRGB(33, 22, 45),
            ["Outline"]      = FromRGB(85, 55, 120),
            ["OutlineSoft"]  = FromRGB(55, 35, 80),
            ["Accent"]       = FromRGB(192, 132, 252),
            ["AccentSoft"]   = FromRGB(60, 35, 90),
            ["Text"]         = FromRGB(250, 245, 255),
            ["TextMuted"]    = FromRGB(170, 155, 185)
        },
        ["Light"] = {
            ["Background"]   = FromRGB(245, 246, 248),
            ["Panel"]        = FromRGB(255, 255, 255),
            ["Surface"]      = FromRGB(248, 249, 251),
            ["Inline"]       = FromRGB(252, 252, 253),
            ["Element"]      = FromRGB(241, 243, 246),
            ["Outline"]      = FromRGB(210, 215, 222),
            ["OutlineSoft"]  = FromRGB(228, 232, 237),
            ["Accent"]       = FromRGB(59, 130, 246),
            ["AccentSoft"]   = FromRGB(200, 220, 250),
            ["Text"]         = FromRGB(15, 23, 35),
            ["TextMuted"]    = FromRGB(95, 105, 120)
        },
    }
    Library.Themes = Themes  -- expõe pra dropdown da Settings page

    function Library:ApplyThemePreset(name)
        local preset = Themes[name]
        if type(preset) ~= "table" then return false end
        for key, color in pairs(preset) do
            Library.Theme[key] = color
            pcall(function() Library:ChangeTheme(key, color) end)
        end
        Library.CurrentThemeName = name
        return true
    end

    function Library:SetBackgroundImage(assetIdOrUrl, transparency)
        -- Aceita rbxassetid://N, número, ou URL http
        local imageId = assetIdOrUrl
        if type(imageId) == "number" then
            imageId = "rbxassetid://" .. tostring(imageId)
        elseif type(imageId) == "string" then
            local asNumber = tonumber(imageId)
            if asNumber then imageId = "rbxassetid://" .. tostring(asNumber) end
        end

        local mainFrame = Library.Holder and Library.Holder.Instance
        if not mainFrame then return false end

        local existing = mainFrame:FindFirstChild("DzBL_BackgroundImage")
        if not imageId or imageId == "" then
            if existing then existing:Destroy() end
            return true
        end

        local bg = existing
        if not bg then
            bg = Instance.new("ImageLabel")
            bg.Name = "DzBL_BackgroundImage"
            bg.BackgroundTransparency = 1
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.ZIndex = 0
            bg.ScaleType = Enum.ScaleType.Crop
            bg.Parent = mainFrame
        end
        bg.Image = imageId
        bg.ImageTransparency = transparency or 0.5
        return true
    end

    Library.Theme = TableClone(Themes["Preset"])

    -- Folders
    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    local AutoExecGuardKey = "DzLibV3_AutoExecGuard"
    local AutoExecSourceKeys = {
        { Script = "DzLibV3_AutoExecScript", Url = "DzLibV3_AutoExecURL", File = "DzLibV3_AutoExecFile" },
        { Script = "DzLib_AutoExecScript", Url = "DzLib_AutoExecURL", File = "DzLib_AutoExecFile" },
        { Script = "DzHub_AutoExecScript", Url = "DzHub_AutoExecURL", File = "DzHub_AutoExecFile" }
    }

    -- Tweening
    local FadePropertyStates = setmetatable({ }, { __mode = "k" })

    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 

            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then 
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 
            local ItemState = FadePropertyStates[Item]

            if not ItemState then
                ItemState = { }
                FadePropertyStates[Item] = ItemState
            end

            local PropertyState = ItemState[Property]

            if not PropertyState then
                PropertyState = {
                    BaseTransparency = Item[Property],
                    Tween = nil,
                    Token = 0
                }
                ItemState[Property] = PropertyState
            end

            if PropertyState.Tween then
                pcall(function()
                    PropertyState.Tween:Cancel()
                end)
                PropertyState.Tween = nil
            end

            PropertyState.Token += 1
            local CurrentToken = PropertyState.Token

            if Visibility then
                PropertyState.BaseTransparency = Item[Property]
                Item[Property] = 1
            end

            local BaseTransparency = PropertyState.BaseTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and BaseTransparency or 1
            }, true)

            PropertyState.Tween = NewTween.Tween

            Library:Connect(NewTween.Tween.Completed, function()
                if PropertyState.Token ~= CurrentToken then
                    return
                end

                PropertyState.Tween = nil

                if not Visibility then 
                    task.wait()

                    if PropertyState.Token ~= CurrentToken then
                        return
                    end

                    Item[Property] = BaseTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            local ActiveLibrary = Library
            if type(ActiveLibrary) ~= "table" or ActiveLibrary.Unloading or ActiveLibrary.Unloaded then
                return self
            end

            ActiveLibrary:AddToTheme(self, Properties)
            return self
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            local ActiveLibrary = Library
            if type(ActiveLibrary) ~= "table" or ActiveLibrary.Unloading or ActiveLibrary.Unloaded then
                return
            end

            ActiveLibrary:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            local ActiveLibrary = Library
            if type(ActiveLibrary) ~= "table" or ActiveLibrary.Unloading or ActiveLibrary.Unloaded then
                return
            end

            return ActiveLibrary:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            local ActiveLibrary = Library
            if type(ActiveLibrary) ~= "table" or ActiveLibrary.Unloading or ActiveLibrary.Unloaded then
                return
            end

            return ActiveLibrary:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end
        
            local Gui = self.Instance
            local Dragging = false 
            local DragStart
            local StartAbsolutePosition

            local function GetParentBounds()
                local Parent = Gui.Parent

                if Parent and Parent:IsA("GuiObject") then
                    return Parent.AbsolutePosition, Parent.AbsoluteSize
                end

                return Vector2New(0, 0), (Camera and Camera.ViewportSize) or Vector2New(1920, 1080)
            end
        
            local Set = function(Input)
                if not DragStart or not StartAbsolutePosition then
                    return
                end

                local DragDelta = Input.Position - DragStart
                local ParentPosition, ParentSize = GetParentBounds()
                local GuiSize = Gui.AbsoluteSize
                local AnchorPoint = Gui.AnchorPoint

                local NewLeft = (StartAbsolutePosition.X - ParentPosition.X) + DragDelta.X
                local NewTop = (StartAbsolutePosition.Y - ParentPosition.Y) + DragDelta.Y

                -- Permite arrastar pra fora da tela, mas mantém ao menos 40px visíveis
                -- em cada lado pra não perder a janela permanentemente.
                local Margin = 40
                NewLeft = MathClamp(NewLeft, -(GuiSize.X - Margin), ParentSize.X - Margin)
                NewTop = MathClamp(NewTop, -(GuiSize.Y - Margin), ParentSize.Y - Margin)
        
                Gui.Position = UDim2FromOffset(
                    NewLeft + (GuiSize.X * AnchorPoint.X),
                    NewTop + (GuiSize.Y * AnchorPoint.Y)
                )
            end
        
            local InputChanged
        
            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    -- Hook opcional: chamado ANTES de capturar a posição inicial.
                    -- Usado pelo Window pra desmaximizar quando o usuário arrasta.
                    if self.OnDragStarted then
                        self.OnDragStarted(Input)
                    end

                    Dragging = true
                    DragStart = Input.Position
                    StartAbsolutePosition = Gui.AbsolutePosition
        
                    if InputChanged then 
                        return
                    end
        
                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            DragStart = nil
                            StartAbsolutePosition = nil
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)
        
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)
        
            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local CurrentSide = nil

            local StartMouse = nil 
            local StartPosition = nil 
            local StartSize = nil
            
            local EdgeThickness = 3

            local MakeEdge = function(Name, Position, Size)
                local Button = Instances:Create("TextButton", {
                    Name = "\0",
                    Size = Size,
                    Position = Position,
                    BackgroundColor3 = FromRGB(166, 147, 243),
                    BackgroundTransparency = 1,
                    Text = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent = Gui,
                    ZIndex = 99999,
                })  Button:AddToTheme({BackgroundColor3 = "Accent"})

                return Button
            end

            local Edges = {
                {Button = MakeEdge(
                    "Left", 
                    UDim2.new(0, 0, 0, 0), 
                    UDim2.new(0, EdgeThickness, 1, 0)), 
                    Side = "L"
                },

                {Button = MakeEdge(
                    "Right", 
                    UDim2.new(1, -EdgeThickness, 0, 0), 
                    UDim2.new(0, EdgeThickness, 1, 0)), 
                    Side = "R"
                },

                {Button = MakeEdge(
                    "Top", UDim2.new(0, 0, 0, 0), 
                    UDim2.new(1, 0, 0, EdgeThickness)), 
                    Side = "T"
                },

                {Button = MakeEdge(
                    "Bottom", 
                    UDim2.new(0, 0, 1, -EdgeThickness), 
                    UDim2.new(1, 0, 0, EdgeThickness)), 
                    Side = "B"
                },
            }

            local BeginResizing = function(Side)
                Resizing = true 
                CurrentSide = Side 

                StartMouse = UserInputService:GetMouseLocation()

                -- store offsets, not absolute screen pos
                StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
                StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)
                
                for Index, Value in Edges do 
                    Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
                end
            end

            local EndResizing = function()
                Resizing = false 
                CurrentSide = nil

                for Index, Value in ipairs(Edges) do
                    Value.Button.Instance.BackgroundTransparency = 1
                end
            end

            for Index, Value in ipairs(Edges) do
                Value.Button:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        BeginResizing(Value.Side)
                    end
                end)
            end

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        EndResizing()
                    end
                end
            end)

            Library:Connect(RunService.RenderStepped, function()
                if not Resizing or not CurrentSide then 
                    return 
                end

                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y
            
                local x, y = StartPosition.X, StartPosition.Y
                local w, h = StartSize.X, StartSize.Y

                if CurrentSide == "L" then
                    x = StartPosition.X + dx
                    w = StartSize.X - dx
                elseif CurrentSide == "R" then
                    w = StartSize.X + dx
                elseif CurrentSide == "T" then
                    y = StartPosition.Y + dy
                    h = StartSize.Y - dy
                elseif CurrentSide == "B" then
                    h = StartSize.Y + dy
                end
            
                if w < Minimum.X then
                    if CurrentSide == "L" then
                        x = x - (Minimum.X - w)
                    end
                    w = Minimum.X
                end
                if h < Minimum.Y then
                    if CurrentSide == "T" then
                        y = y - (Minimum.Y - h)
                    end
                    h = Minimum.Y
                end
            
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2FromOffset(x, y)})
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2FromOffset(w, h)})
            end)
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    -- Custom font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then 
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile(`{Library.Folders.Assets}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Folders.Assets}/{Name}.font`))
        end

        Library.Font = CustomFont:New("OutfitMedium", 400, "Regular", {
            Id = "OutfitMedium",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/Outfit-Medium.ttf"
        })

        local TitleFontSuccess, TitleFont = pcall(function()
            return Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
        end)

        local TitleFontEnumSuccess, TitleFontEnum = pcall(function()
            return Enum.Font.BuilderSansBold
        end)

        local BrandFontSuccess, BrandFont = pcall(function()
            return Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Italic)
        end)

        Library.TitleFont = TitleFontSuccess and TitleFont or Library.Font
        Library.TitleFontEnum = TitleFontEnumSuccess and TitleFontEnum or Enum.Font.GothamBold
        Library.BrandFont = BrandFontSuccess and BrandFont or Library.TitleFont
        Library.BrandFontEnum = Library.TitleFontEnum
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 10,
        ResetOnSpawn = false
    })

    Library.NotifAnchor = Instances:Create("Frame", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        BorderColor3 = FromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        BorderSizePixel = 0
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    local NotificationCards = { }
    -- Mobile: narrower so the notification card doesn't get clipped on the
    -- left edge of phones (~360px wide). Desktop keeps the original 312.
    local NotificationWidth = Library:IsMobileClient() and 260 or 312
    local NotificationMinHeight = 82
    local NotificationGap = 12
    local NotificationEdgeX = 20
    local NotificationEdgeY = 20

    local function MeasureNotificationTextHeight(Text, FontSize, FontEnum, Width)
        local Success, Bounds = pcall(function()
            return TextService:GetTextSize(Text, FontSize, FontEnum, Vector2New(Width, 1000))
        end)

        if Success and Bounds then
            return MathFloor(Bounds.Y)
        end

        return FontSize
    end

    local function GetNotificationHeight(NotificationData)
        local CardInstance = NotificationData and NotificationData.Card and NotificationData.Card.Instance

        if CardInstance and CardInstance.Parent then
            return math.max(MathFloor(CardInstance.AbsoluteSize.Y), NotificationMinHeight)
        end

        return NotificationMinHeight
    end

    local function GetNotificationOffset(Index)
        local TotalHeight = NotificationEdgeY

        for CurrentIndex = 1, Index - 1 do
            TotalHeight += GetNotificationHeight(NotificationCards[CurrentIndex]) + NotificationGap
        end

        return -TotalHeight
    end

    local function RestackNotifications()
        for Index, NotificationData in next, NotificationCards do
            local CardInstance = NotificationData.Card and NotificationData.Card.Instance

            if CardInstance and CardInstance.Parent then
                TweenService:Create(CardInstance, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1, -NotificationEdgeX, 1, GetNotificationOffset(Index))
                }):Play()
            end
        end
    end

    Library.Unload = function(self)
        if self.Unloading or self.Unloaded then
            return
        end

        self.Unloading = true

        for Index, Value in self.Connections do 
            if Value.Connection then
                Value.Connection:Disconnect()
            end
        end

        for Index, Value in self.Threads do 
            pcall(coroutine.close, Value)
        end

        for _, Callback in self.CleanupCallbacks do
            pcall(Callback)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        if self.NotifHolder then
            self.NotifHolder:Clean()
        end

        if self.UnusedHolder then
            self.UnusedHolder:Clean()
        end

        self.Unloaded = true
        getgenv().Library = nil
    end

    Library.OnUnload = function(self, Callback)
        if type(Callback) == "function" then
            TableInsert(self.CleanupCallbacks, Callback)
        end

        return Callback
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        -- Guard: callbacks opcionais (ex: AddToggle sem Callback) chegam nil aqui.
        -- Sem isso coroutine.create(nil) explode com "function expected, got nil".
        if type(Function) ~= "function" then
            return nil
        end

        local NewThread = coroutine.create(Function)

        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        -- Increment a session counter and return a DETERMINISTIC flag id.
        -- The previous version appended a per-call GUID, which made every
        -- reload generate new flag names — so saved configs never matched
        -- the widgets on autoload (the values existed in the JSON but
        -- Library.SetFlags[Index] was nil for the new GUID-suffixed names).
        -- Widgets are created in a fixed order per script run, so a plain
        -- counter is stable across reloads.
        self.UnnamedFlags = (self.UnnamedFlags or 0) + 1
        return StringFormat("flag_number_%d", self.UnnamedFlags)
    end

    Library.AddToTheme = function(self, Item, Properties)
        -- Aceita wrappers da lib (com .Instance) OU instances raw do Roblox.
        -- Acessar .Instance em instance raw dá erro, então testa o tipo antes.
        if type(Item) == "table" and Item.Instance then
            Item = Item.Instance
        end

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not self.Theme[Value] then
                    Item[Property] = Value 
                end

                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

	Library.ToRich = function(self, Text, Color)
		return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
	end

    Library.RegisterIgnoredFlag = function(self, Flag)
        if type(Flag) == "string" and Flag ~= "" then
            self.IgnoredFlags[Flag] = true
        end
    end

    Library.RegisterIgnoredFlags = function(self, Flags)
        if type(Flags) ~= "table" then
            return
        end

        for _, Flag in next, Flags do
            self:RegisterIgnoredFlag(Flag)
        end
    end

    Library.ShouldIgnoreFlag = function(self, Flag)
        return self.IgnoredFlags[Flag] == true
    end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if Library:ShouldIgnoreFlag(Index) then
                    continue
                end

                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                if Library:ShouldIgnoreFlag(Index) then
                    continue
                end

                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Folders.Configs)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        if Element then
            Element:Refresh(ReturnList)
        end

        return ReturnList
    end

    Library.GetExecutorSettingsPath = function(self)
        local PlayerName = LocalPlayer and LocalPlayer.Name or "default"
        return self.Folders.Settings .. "/" .. PlayerName .. ".json"
    end

    Library.NormalizeMenuKeybind = function(self, Value)
        if typeof(Value) == "EnumItem" then
            return tostring(Value)
        end

        if type(Value) == "table" and Value.Key then
            return tostring(Value.Key)
        end

        if type(Value) == "string" and Value ~= "" then
            return Value
        end

        return nil
    end

    Library.GetMenuKeybindDisplay = function(self, Value)
        local Normalized = self:NormalizeMenuKeybind(Value or self.MenuKeybind)
        if not Normalized then
            return "Unknown"
        end

        return Keys[Normalized]
            or StringGSub(StringGSub(Normalized, "Enum.KeyCode.", ""), "Enum.UserInputType.", "")
            or tostring(Normalized)
    end

    Library.SetMenuKeybind = function(self, Value, SkipSave)
        local Normalized = self:NormalizeMenuKeybind(Value)
        if not Normalized then
            return false, "invalid keybind"
        end

        self.MenuKeybind = Normalized
        self.ExecutorSettings.MenuKeybind = Normalized

        if SkipSave then
            return true
        end

        return self:SaveExecutorSettings()
    end

    Library.GetAutoloadPath = function(self)
        return self.Folders.Settings .. "/autoload.txt"
    end

    Library.ResolveTeleportQueueFunction = function(self)
        return queue_on_teleport
            or queueonteleport
            or (syn and syn.queue_on_teleport)
            or (fluxus and fluxus.queue_on_teleport)
    end

    Library.GetAutoExecGuard = function(self)
        local Environment = (getgenv and getgenv()) or _G
        local Guard = Environment[AutoExecGuardKey]

        if type(Guard) ~= "table" then
            Guard = { }
            Environment[AutoExecGuardKey] = Guard
        end

        return Guard
    end

    Library.BuildAutoExecSource = function(self)
        local Environment = (getgenv and getgenv()) or _G

        local function WrapAutoExecBody(Body)
            return TableConcat({
                "pcall(function()",
                "	repeat task.wait() until game and game:IsLoaded()",
                Body,
                "end)"
            }, "\n")
        end

        for _, KeysData in next, AutoExecSourceKeys do
            local RawScript = Environment[KeysData.Script]
            if type(RawScript) == "string" and RawScript ~= "" then
                return WrapAutoExecBody(RawScript)
            end

            local Url = Environment[KeysData.Url]
            if type(Url) == "string" and Url ~= "" then
                return WrapAutoExecBody(StringFormat("	loadstring(game:HttpGet(%q))()", Url))
            end

            local FilePath = Environment[KeysData.File]
            if type(FilePath) == "string" and FilePath ~= "" then
                return WrapAutoExecBody(StringFormat("	if readfile and isfile and isfile(%q) then loadstring(readfile(%q))() end", FilePath, FilePath))
            end
        end

        return nil
    end

    Library.BuildAutoExecFingerprint = function(self, Source)
        if type(Source) ~= "string" then
            return nil
        end

        return tostring(#Source) .. ":" .. Source:sub(1, 160)
    end

    Library.LoadExecutorSettings = function(self)
        if self._ExecutorSettingsLoaded then
            return true
        end

        self._ExecutorSettingsLoaded = true

        if type(readfile) ~= "function" or type(isfile) ~= "function" then
            return false, "filesystem unavailable"
        end

        local Path = self:GetExecutorSettingsPath()
        local OkIsFile, HasFile = pcall(isfile, Path)
        if not OkIsFile or not HasFile then
            return false, "settings file missing"
        end

        local OkRead, Raw = pcall(readfile, Path)
        if not OkRead or type(Raw) ~= "string" or Raw == "" then
            return false, Raw
        end

        local OkDecode, Decoded = pcall(function()
            return HttpService:JSONDecode(Raw)
        end)
        if not OkDecode or type(Decoded) ~= "table" then
            return false, Decoded
        end

        if type(Decoded.AutoExec) == "boolean" then
            self.ExecutorSettings.AutoExec = Decoded.AutoExec
        end

        if type(Decoded.MenuKeybind) == "string" and Decoded.MenuKeybind ~= "" then
            self:SetMenuKeybind(Decoded.MenuKeybind, true)
        end

        return true
    end

    Library.SaveExecutorSettings = function(self)
        if type(writefile) ~= "function" then
            return false, "filesystem unavailable"
        end

        local OkWrite, Result = pcall(writefile, self:GetExecutorSettingsPath(), HttpService:JSONEncode(self.ExecutorSettings))
        if not OkWrite then
            return false, Result
        end

        return true
    end

    Library.GetAutoExecEnabled = function(self)
        return self.ExecutorSettings.AutoExec == true
    end

    Library.QueueAutoExec = function(self, ForceQueue)
        local QueueFunction = self:ResolveTeleportQueueFunction()
        local Source = self:BuildAutoExecSource()

        if not QueueFunction or not Source then
            return false, "queue or source unavailable"
        end

        local Fingerprint = self:BuildAutoExecFingerprint(Source)
        local CurrentJobId = tostring(game.JobId or "")
        local Guard = self:GetAutoExecGuard()

        if not ForceQueue and Fingerprint and self._AutoExecLastQueuedFingerprint == Fingerprint then
            return false, "already queued"
        end

        if not ForceQueue and Fingerprint and Guard.JobId == CurrentJobId and Guard.Fingerprint == Fingerprint then
            return false, "guard prevented duplicate"
        end

        local OkQueue, QueueError = pcall(QueueFunction, Source)
        if not OkQueue then
            return false, QueueError
        end

        self._AutoExecLastQueuedFingerprint = Fingerprint
        Guard.JobId = CurrentJobId
        Guard.Fingerprint = Fingerprint
        Guard.QueuedAt = os.clock()

        return true
    end

    Library.RefreshAutoExecQueue = function(self, ForceQueue)
        self._AutoExecRunId += 1

        if not self:GetAutoExecEnabled() then
            self._AutoExecLastQueuedFingerprint = nil

            local Guard = self:GetAutoExecGuard()
            if Guard.JobId == tostring(game.JobId or "") then
                Guard.JobId = nil
                Guard.Fingerprint = nil
                Guard.QueuedAt = nil
            end

            return false, "auto exec disabled"
        end

        return self:QueueAutoExec(ForceQueue)
    end

    Library.SetAutoExecEnabled = function(self, State, ForceQueue)
        self.ExecutorSettings.AutoExec = State and true or false
        self:SaveExecutorSettings()
        return self:RefreshAutoExecQueue(ForceQueue)
    end

    Library.GetAutoloadConfigName = function(self)
        if type(isfile) ~= "function" or type(readfile) ~= "function" then
            return nil
        end

        local Path = self:GetAutoloadPath()
        local OkIsFile, HasFile = pcall(isfile, Path)
        if not OkIsFile or not HasFile then
            return nil
        end

        local OkRead, Name = pcall(readfile, Path)
        if not OkRead or type(Name) ~= "string" then
            return nil
        end

        Name = StringGSub(Name, "\r", "")
        Name = StringGSub(Name, "\n", "")

        if Name == "" then
            return nil
        end

        return Name
    end

    Library.SetAutoloadConfig = function(self, Name)
        if type(writefile) ~= "function" or type(Name) ~= "string" or Name == "" then
            return false, "autoload unavailable"
        end

        local OkWrite, Result = pcall(writefile, self:GetAutoloadPath(), Name)
        if not OkWrite then
            return false, Result
        end

        return true
    end

    Library.ClearAutoloadConfig = function(self)
        if type(isfile) ~= "function" or type(delfile) ~= "function" then
            return false, "autoload unavailable"
        end

        local Path = self:GetAutoloadPath()
        local OkIsFile, HasFile = pcall(isfile, Path)
        if not OkIsFile or not HasFile then
            return false, "autoload not set"
        end

        local OkDelete, Result = pcall(delfile, Path)
        if not OkDelete then
            return false, Result
        end

        return true
    end

    Library.CountSetFlags = function(self)
        local Count = 0

        for _ in next, self.SetFlags do
            Count += 1
        end

        return Count
    end

    Library.WaitForFlagRegistration = function(self, Timeout, StableTicks)
        local TimeoutValue = Timeout or 3
        local RequiredStableTicks = StableTicks or 3
        local LastCount = -1
        local StableCount = 0
        local Deadline = os.clock() + TimeoutValue

        repeat
            local CurrentCount = self:CountSetFlags()

            if CurrentCount == LastCount and CurrentCount > 0 then
                StableCount += 1
            else
                LastCount = CurrentCount
                StableCount = 0
            end

            if StableCount >= RequiredStableTicks then
                break
            end

            task.wait(0.1)
        until os.clock() >= Deadline
    end

    Library.LoadAutoloadConfig = function(self, Force)
        if self._AutoLoadApplied and not Force then
            return false, "autoload already applied"
        end

        local Name = self:GetAutoloadConfigName()
        if not Name then
            return false, "autoload not configured"
        end

        self:WaitForFlagRegistration()

        local Path = self.Folders.Configs .. "/" .. Name .. ".json"
        local OkIsFile, HasFile = pcall(isfile, Path)
        if not OkIsFile or not HasFile then
            return false, "autoload config missing"
        end

        local OkRead, RawConfig = pcall(readfile, Path)
        if not OkRead or type(RawConfig) ~= "string" then
            return false, RawConfig
        end

        local Success, Result = self:LoadConfig(RawConfig)
        if Success then
            self._AutoLoadApplied = true
            return true, Name
        end

        return false, Result
    end

    Library.ScheduleAutoload = function(self)
        if self._AutoLoadScheduled then
            return
        end

        self._AutoLoadScheduled = true

        task.defer(function()
            task.wait()
            local Success, Result = self:LoadAutoloadConfig()
            if not Success and Result ~= "autoload not configured" and Result ~= "autoload already applied" and Result ~= "autoload config missing" then
                warn("[dzlibv3] autoload failed:", Result)
            end
        end)
    end

    Library:LoadExecutorSettings()
    Library:RefreshAutoExecQueue()

    Library.ChangeItemTheme = function(self, Item, Properties)
        if self.Unloading or self.Unloaded then
            return
        end

        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.Notification = function(self, Title, Description, Duration)
        if not Description and Title then
            Description = Title
            Title = "DZ HUB"
        end

        Title = tostring(Title or "Notification")
        Description = tostring(Description or "")
        Duration = math.max(tonumber(Duration) or 3, 1)

        local Notification = { }
        local Closing = false
        local ProgressTween
        local CountdownEndsAt = os.clock() + Duration
        local LastCountdownValue

        local Items = { } do
            Items["Card"] = Instances:Create("TextButton", {
                Parent = Library.NotifAnchor.Instance,
                Name = "\0",
                Text = "",
                AutoButtonColor = false,
                Active = true,
                Selectable = false,
                AnchorPoint = Vector2New(1, 1),
                Position = UDim2.new(1, NotificationWidth + 16, 1, GetNotificationOffset(#NotificationCards + 1)),
                Size = UDim2FromOffset(NotificationWidth, NotificationMinHeight),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme["Panel"],
                BackgroundTransparency = 1,
                ZIndex = 20,
                TextSize = 14
            })

            Instances:Create("UICorner", {
                Parent = Items["Card"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 16)
            })

            Items["Shadow"] = Instances:Create("Frame", {
                Parent = Items["Card"].Instance,
                Name = "\0",
                BackgroundColor3 = FromRGB(0, 0, 0),
                BackgroundTransparency = 0.66,
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2FromOffset(0, 7),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 19
            })

            Instances:Create("UICorner", {
                Parent = Items["Shadow"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 16)
            })

            Instances:Create("UIStroke", {
                Parent = Items["Card"].Instance,
                Name = "\0",
                Color = Library.Theme["OutlineSoft"],
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = 'OutlineSoft'})

            Items["Surface"] = Instances:Create("Frame", {
                Parent = Items["Card"].Instance,
                Name = "\0",
                BackgroundColor3 = Library.Theme["Surface"],
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2FromOffset(0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 21
            }):AddToTheme({BackgroundColor3 = 'Surface'})

            Instances:Create("UICorner", {
                Parent = Items["Surface"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 16)
            })

            Items["IconChip"] = Instances:Create("Frame", {
                Parent = Items["Surface"].Instance,
                Name = "\0",
                BackgroundColor3 = Library.Theme["Element"],
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2FromOffset(14, 12),
                Size = UDim2FromOffset(26, 26),
                ZIndex = 21
            }):AddToTheme({BackgroundColor3 = 'Element'})

            Instances:Create("UICorner", {
                Parent = Items["IconChip"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 8)
            })

            Instances:Create("UIStroke", {
                Parent = Items["IconChip"].Instance,
                Name = "\0",
                Color = Library.Theme["OutlineSoft"],
                Transparency = 0.15,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = 'OutlineSoft'})

            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["IconChip"].Instance,
                Name = "\0",
                ScaleType = Enum.ScaleType.Fit,
                ImageTransparency = 0.08,
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AnchorPoint = Vector2New(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Image = Library:ResolveIcon("bell"),
                BackgroundTransparency = 1,
                Size = UDim2FromOffset(15, 15),
                ZIndex = 22
            }):AddToTheme({ImageColor3 = 'Accent'})

            Items["Kicker"] = Instances:Create("TextLabel", {
                Parent = Items["Surface"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                Font = Enum.Font.GothamSemibold,
                TextColor3 = Library.Theme["TextMuted"],
                TextTransparency = 0.35,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "DZ HUB",
                BackgroundTransparency = 1,
                Position = UDim2FromOffset(46, 12),
                Size = UDim2FromOffset(72, 12),
                BorderSizePixel = 0,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                TextSize = 10,
                ZIndex = 21
            }):AddToTheme({TextColor3 = 'TextMuted'})

            Items["TimerPill"] = Instances:Create("Frame", {
                Parent = Items["Surface"].Instance,
                Name = "\0",
                BackgroundColor3 = Library.Theme["Element"],
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2.new(1, -12, 0, 12),
                Size = UDim2FromOffset(30, 16),
                ZIndex = 21
            }):AddToTheme({BackgroundColor3 = 'Element'})

            Instances:Create("UICorner", {
                Parent = Items["TimerPill"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })

            Items["TimerText"] = Instances:Create("TextLabel", {
                Parent = Items["TimerPill"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                Font = Enum.Font.GothamMedium,
                TextColor3 = Library.Theme["TextMuted"],
                Text = string.format("%ss", math.max(1, math.ceil(Duration))),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                ZIndex = 22
            }):AddToTheme({TextColor3 = 'TextMuted'})

            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Surface"].Instance,
                Name = "\0",
                FontFace = Library.TitleFont or Library.Font,
                Font = Library.TitleFontEnum or Enum.Font.GothamBold,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Title,
                BackgroundTransparency = 1,
                Position = UDim2FromOffset(46, 24),
                Size = UDim2.new(1, -90, 0, 18),
                BorderSizePixel = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextSize = 14,
                ZIndex = 21
            }):AddToTheme({TextColor3 = 'Text'})

            Items["Description"] = Instances:Create("TextLabel", {
                Parent = Items["Surface"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["TextMuted"],
                TextTransparency = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Description,
                BackgroundTransparency = 1,
                Position = UDim2FromOffset(46, 44),
                Size = UDim2.new(1, -58, 0, 16),
                BorderSizePixel = 0,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextSize = 12,
                ZIndex = 21
            }):AddToTheme({TextColor3 = 'TextMuted'})

            Items["ProgressTrack"] = Instances:Create("Frame", {
                Parent = Items["Surface"].Instance,
                Name = "\0",
                BackgroundColor3 = Library.Theme["Element"],
                BackgroundTransparency = 0.35,
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Position = UDim2FromOffset(46, 0),
                Size = UDim2FromOffset(NotificationWidth - 58, 2),
                ZIndex = 21
            }):AddToTheme({BackgroundColor3 = 'Element'})

            Instances:Create("UICorner", {
                Parent = Items["ProgressTrack"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })

            Items["Progress"] = Instances:Create("Frame", {
                Parent = Items["ProgressTrack"].Instance,
                Name = "\0",
                BackgroundColor3 = Library.Theme["Accent"],
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 22
            }):AddToTheme({BackgroundColor3 = 'Accent'})

            Instances:Create("UICorner", {
                Parent = Items["Progress"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })
        end

        local function UpdateNotificationLayout()
            local TitleWidth = NotificationWidth - 90
            local DescriptionWidth = NotificationWidth - 58
            local TitleHeight = math.max(MeasureNotificationTextHeight(Title, 14, Library.TitleFontEnum or Enum.Font.GothamBold, TitleWidth), 18)
            local DescriptionHeight = math.max(MeasureNotificationTextHeight(Description, 12, Enum.Font.Gotham, DescriptionWidth), 14)
            local ContentHeight = 12 + 12 + 4 + TitleHeight + 4 + DescriptionHeight + 12 + 2 + 10
            local CardHeight = math.max(NotificationMinHeight, ContentHeight)

            Items["Title"].Instance.Position = UDim2FromOffset(46, 24)
            Items["Title"].Instance.Size = UDim2.new(1, -90, 0, TitleHeight)
            Items["Description"].Instance.Position = UDim2FromOffset(46, 24 + TitleHeight + 4)
            Items["Description"].Instance.Size = UDim2.new(1, -58, 0, DescriptionHeight)
            Items["ProgressTrack"].Instance.Position = UDim2FromOffset(46, CardHeight - 12)
            Items["ProgressTrack"].Instance.Size = UDim2FromOffset(NotificationWidth - 58, 2)
            Items["Card"].Instance.Size = UDim2FromOffset(NotificationWidth, CardHeight)

            RestackNotifications()
        end

        Notification.Items = Items
        Notification.Card = Items["Card"]

        local function UpdateCountdownText()
            if not Items["TimerText"] or not Items["TimerText"].Instance or not Items["TimerText"].Instance.Parent then
                return
            end

            local Remaining = math.max(0, CountdownEndsAt - os.clock())
            local DisplayValue = math.max(0, math.ceil(Remaining))

            if DisplayValue ~= LastCountdownValue then
                LastCountdownValue = DisplayValue
                Items["TimerText"].Instance.Text = tostring(DisplayValue) .. "s"
            end
        end

        UpdateCountdownText()
        UpdateNotificationLayout()
        TableInsert(NotificationCards, Notification)
        RestackNotifications()

        Library.Thread(function()
            local SlideTween = TweenService:Create(Items["Card"].Instance, TweenInfoNew(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -NotificationEdgeX, 1, GetNotificationOffset(#NotificationCards))
            })

            SlideTween:Play()
        end)

        ProgressTween = TweenService:Create(Items["Progress"].Instance, TweenInfoNew(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 1, 0)
        })
        ProgressTween:Play()

        Library.Thread(function()
            while not Closing do
                UpdateCountdownText()

                if CountdownEndsAt - os.clock() <= 0 then
                    break
                end

                task.wait(0.1)
            end

            if not Closing then
                UpdateCountdownText()
            end
        end)

        function Notification:Close()
            if Closing then
                return
            end

            Closing = true

            local RemoveIndex = TableFind(NotificationCards, Notification)

            if RemoveIndex then
                TableRemove(NotificationCards, RemoveIndex)
            end

            if ProgressTween then
                ProgressTween:Cancel()
            end

            local SlideTween = TweenService:Create(Items["Card"].Instance, TweenInfoNew(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(1, NotificationWidth + 16, 1, Items["Card"].Instance.Position.Y.Offset)
            })

            SlideTween:Play()
            -- Tracked + one-shot: evita firing depois de Library:Unload tocar Items["Card"]
            local slideConn
            slideConn = Library:Connect(SlideTween.Completed, function()
                if slideConn and slideConn.Connection then
                    slideConn.Connection:Disconnect()
                end
                if Items["Card"] then
                    Items["Card"]:Clean()
                end
            end)

            RestackNotifications()
        end

        Items["Card"]:Connect("MouseButton1Down", function()
            Notification:Close()
        end)

        task.defer(function()
            local Remaining = math.max(0, CountdownEndsAt - os.clock())

            if Remaining > 0 then
                task.wait(Remaining)
            end

            if not Closing then
                Notification:Close()
            end
        end)

        return Notification
    end

    Library.Notify = function(self, Description, Duration)
        return self:Notification("DZ HUB", Description, Duration)
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
    end

    Library.CompareVectors = function(self, PointA, PointB)
        return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
    end

    Library.IsClipped = function(self, Object, Column)
        local Parent = Column
        
        local BoundryTop = Parent.AbsolutePosition
        local BoundryBottom = BoundryTop + Parent.AbsoluteSize

        local Top = Object.AbsolutePosition
        local Bottom = Top + Object.AbsoluteSize 

        return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
    end

    Library.RegisterKeybind = function(self, Keybind)
        if type(Keybind) ~= "table" or not Keybind.Flag then
            return
        end

        self.KeybindRegistry[Keybind.Flag] = Keybind
        self:RefreshKeybindLists()
    end

    Library.UnregisterKeybind = function(self, Keybind)
        local Flag = type(Keybind) == "table" and Keybind.Flag or Keybind

        if not Flag then
            return
        end

        self.KeybindRegistry[Flag] = nil
        self:RefreshKeybindLists()
    end

    Library.GetKeybindListEntries = function(self)
        local Entries = { }

        for _, Keybind in next, self.KeybindRegistry do
            if self:ShouldIgnoreFlag(Keybind.Flag) then
                continue
            end

            local DisplayKey = Keybind.Value

            if type(DisplayKey) == "string" and DisplayKey ~= "" and DisplayKey ~= "None" then
                TableInsert(Entries, {
                    Name = tostring(Keybind.Name or Keybind.Flag or "Keybind"),
                    Key = DisplayKey,
                    Mode = tostring(Keybind.Mode or "Toggle"),
                    Toggled = Keybind.Toggled == true
                })
            end
        end

        table.sort(Entries, function(Left, Right)
            local LeftName = StringLower(Left.Name)
            local RightName = StringLower(Right.Name)

            if LeftName == RightName then
                return StringLower(Left.Key) < StringLower(Right.Key)
            end

            return LeftName < RightName
        end)

        return Entries
    end

    Library.RefreshKeybindLists = function(self)
        local Entries = self:GetKeybindListEntries()

        for _, KeybindList in next, self.KeybindLists do
            if type(KeybindList) == "table" and KeybindList.Refresh then
                KeybindList:Refresh(Entries)
            end
        end
    end

    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Flag = Data.Flag, 

            Hue = 0,
            Saturation = 0,
            Value = 0,

            Color = Color3.fromRGB(0, 0, 0),
            Hex = "#000000",

            IsOpen = false 
        }

        local Items = { } do 
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2.new(0, 20, 0, 16),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(148, 255, 237)
            })
            
            Instances:Create("UICorner", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                Color = Library.Theme["Outline"],
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = 'Outline'})
            
            Items["Glow"] = Instances:Create("ImageLabel", {
                Parent = Items["ColorpickerButton"].Instance,
                Name = "\0",
                ImageColor3 = FromRGB(148, 255, 237),
                ScaleType = Enum.ScaleType.Slice,
                ImageTransparency = 0.800000011920929,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2.new(1, 25, 1, 25),
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "http://www.roblox.com/asset/?id=18245826428",
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
            })            

            Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2.new(0, 94, 0, 60),
                Size = UDim2.new(0, 160, 0, 160),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = Library.Theme["Background"]
            }):AddToTheme({BackgroundColor3 = 'Background'})
            
            Instances:Create("UICorner", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            
            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2.new(0, 8, 0, 8),
                Size = UDim2.new(1, -40, 1, -16),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(148, 255, 237)
            })
            
            Instances:Create("UICorner", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })
            
            Items["Saturation"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2.new(1, 1, 1, 0),
                BorderSizePixel = 0
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Instances:Create("UICorner", {
                Parent = Items["Saturation"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })
            
            Items["Value"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2.new(1, 1, 1, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(0, 0, 0)
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                Rotation = 90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            })
            
            Instances:Create("UICorner", {
                Parent = Items["Value"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 5)
            })
            
            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2.new(0, 5, 0, 5),
                BorderSizePixel = 0
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0"
            })
            
            Instances:Create("UICorner", {
                Parent = Items["PaletteDragger"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })
            
            Items["Hue"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Position = UDim2.new(1, -8, 0, 8),
                Size = UDim2.new(0, 15, 1, -16),
                BorderSizePixel = 0,
                TextSize = 14
            })
            
            Instances:Create("UIGradient", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
            })
            
            Instances:Create("UICorner", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            
            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2.new(0, 15, 0, 15),
                BorderSizePixel = 0
            })
            
            Instances:Create("UICorner", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(1, 0)
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                Name = "\0"
            })            
        end

        function Colorpicker:Get()
            return Colorpicker.Color
        end

        function Colorpicker:Update()
            local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
            Colorpicker.Color = FromHSV(Hue, Saturation, Value)
            Colorpicker.HexValue = Colorpicker.Color:ToHex()

            Library.Flags[Colorpicker.Flag] = {
                Color = Colorpicker.Color,
                HexValue = Colorpicker.HexValue
            }

            Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
            Items["Glow"]:Tween(nil, {ImageColor3 = Colorpicker.Color})
            Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Colorpicker.Color)
            end
        end

        local SlidingPalette = false
        local PaletteChanged
        
        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then
                return
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Saturation = ValueX
            Colorpicker.Value = ValueY

            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.955)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.955)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(SlideX, 0, SlideY, 0)})
            Colorpicker:Update()
        end
        
        local SlidingHue = false
        local HueChanged

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then
                return
            end
            
            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            Colorpicker.Hue = ValueY

            local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.91)

            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, SlideY, 0)})
            Colorpicker:Update()
        end

        local Debounce = false
        local RenderStepped  

        function Colorpicker:SetOpen(Bool)
            if Debounce then 
                return
            end

            Colorpicker.IsOpen = Bool

            Debounce = true 

            if Colorpicker.IsOpen then 
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["ColorpickerWindow"].Instance.Position = UDim2.new(
                        0, 
                        Items["ColorpickerButton"].Instance.AbsolutePosition.X, 
                        0, 
                        Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 5
                    )
                end)

                for Index, Value in Library.OpenFrames do 
                        if Value ~= Colorpicker then
                            Value:SetOpen(false)
                        end
                    end

                Library.OpenFrames[Colorpicker] = Colorpicker 
            else
                if Library.OpenFrames[Colorpicker] then 
                    Library.OpenFrames[Colorpicker] = nil
                end

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if not Value.ClassName:find("UI") then 
                    Value.ZIndex = (Colorpicker.IsOpen and Data.Section.IsSettings and 9) or (Colorpicker.IsOpen and not Data.Section.IsSettings and 3) or 1
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            -- Tracked + one-shot: evita acesso a Items["ColorpickerWindow"] depois do Unload
            local fadeConn
            fadeConn = Library:Connect(NewTween.Tween.Completed, function()
                if fadeConn and fadeConn.Connection then
                    fadeConn.Connection:Disconnect()
                end
                Debounce = false
                if not Items["ColorpickerWindow"] then
                    return
                end
                Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                task.wait(0.2)
                if Items["ColorpickerWindow"] and Library.UnusedHolder and Library.Holder then
                    Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end
            end)
        end

        function Colorpicker:Set(Color)
            if type(Color) == "table" then
                Color = FromRGB(Color[1], Color[2], Color[3])
            elseif type(Color) == "string" then
                Color = FromHex(Color)
            end 

            Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()

            local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.955)
            local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.955)
                
            local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.955)

            Items["PaletteDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)})
            Items["HueDragger"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, HuePositionY, 0)})
            Colorpicker:Update()
        end

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingPalette = true 

                Colorpicker:SlidePalette(Input)

                if PaletteChanged then
                    return
                end

                PaletteChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingPalette = false

                        PaletteChanged:Disconnect()
                        PaletteChanged = nil
                    end
                end)
            end
        end)

        Items["Hue"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingHue = true 

                Colorpicker:SlideHue(Input)

                if HueChanged then
                    return
                end

                HueChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingHue = false

                        HueChanged:Disconnect()
                        HueChanged = nil
                    end
                end)
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if SlidingPalette then 
                    Colorpicker:SlidePalette(Input)
                end

                if SlidingHue then
                    Colorpicker:SlideHue(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if not Colorpicker.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                    return
                end

                Colorpicker:SetOpen(false)
            end
        end)

        if Data.Default then
            Colorpicker:Set(Data.Default)
        end

        Library.SetFlags[Colorpicker.Flag] = function(Value)
            Colorpicker:Set(Value)
        end

        return Colorpicker, Items 
    end

    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            Flag = Data.Flag,
            Name = Data.Name or Data.name or Data.DisplayName or Data.displayname or Data.Flag or "Keybind",

            Value = "",
            Key = "",
            Mode = "",
            
            Toggled = false,
            Picking = false,
            IsOpen = false 
        }

        local Items = { } do 
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "[C]",
                AutoButtonColor = false,
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 16
            }):AddToTheme({TextColor3 = 'Text'})      
            
            Items["KeybindWindow"] = Instances:Create("TextButton", {
                Parent = Library.UnusedHolder.Instance,
                Name = "\0",
                Visible = false,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Position = UDim2.new(0, 10, 0, 10),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 14,
                BackgroundColor3 = Library.Theme["Background"]
            }):AddToTheme({BackgroundColor3 = 'Background'})
            
            Instances:Create("UICorner", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                CornerRadius = UDimNew(0, 6)
            })
            
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 15),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})
            
            Instances:Create("UIListLayout", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            Instances:Create("UIPadding", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                PaddingTop = UDimNew(0, 10),
                PaddingBottom = UDimNew(0, 10),
                PaddingRight = UDimNew(0, 10),
                PaddingLeft = UDimNew(0, 10)
            })
            
            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "Hold",
                AutoButtonColor = false,
                Size = UDim2.new(0, 0, 0, 15),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})
            
            Items["Always"] = Instances:Create("TextButton", {
                Parent = Items["KeybindWindow"].Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme["Text"],
                TextTransparency = 0.5,
                Text = "Always",
                AutoButtonColor = false,
                Size = UDim2.new(0, 0, 0, 15),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14
            }):AddToTheme({TextColor3 = 'Text'})
        end

        local Modes = {
            Toggle = Items["Toggle"],
            Hold = Items["Hold"],
            Always = Items["Always"]
        }

        local Debounce = false
        local RenderStepped  

        function Keybind:SetOpen(Bool)
            if Debounce then 
                return
            end

            Keybind.IsOpen = Bool

            Debounce = true 

            if Keybind.IsOpen then 
                Items["KeybindWindow"].Instance.Visible = true
                Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                
                RenderStepped = RunService.RenderStepped:Connect(function()
                    Items["KeybindWindow"].Instance.Position = UDim2.new(
                        0, 
                        Items["KeyButton"].Instance.AbsolutePosition.X, 
                        0, 
                        Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 5
                    )
                end)

                for Index, Value in Library.OpenFrames do 
                    if Value ~= Keybind then
                        Value:SetOpen(false)
                    end
                end

                Library.OpenFrames[Keybind] = Keybind 
            else
                if Library.OpenFrames[Keybind] then 
                    Library.OpenFrames[Keybind] = nil
                end

                if RenderStepped then 
                    RenderStepped:Disconnect()
                    RenderStepped = nil
                end
            end

            local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["KeybindWindow"].Instance)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then
                    continue 
                end

                if not Value.ClassName:find("UI") then 
                    Value.ZIndex = Keybind.IsOpen and 4 or 1
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                end
            end
            
            NewTween.Tween.Completed:Connect(function()
                Debounce = false
                if Items["KeybindWindow"] and Items["KeybindWindow"].Instance then
                    Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                end
                task.wait(0.2)
                if Items["KeybindWindow"] and Items["KeybindWindow"].Instance and Library.UnusedHolder and Library.Holder then
                    pcall(function()
                        Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                    end)
                end
            end)
        end

        function Keybind:SetMode(Mode)
            if not Modes[Mode] then
                return
            end

            Keybind.Mode = Mode

            for Index, Value in Modes do 
                if Index == Mode then
                    Value:Tween(nil, {TextTransparency = 0})
                else
                    Value:Tween(nil, {TextTransparency = 0.5})
                end
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Library:RefreshKeybindLists()
        end

        function Keybind:Press(Bool)
            if Keybind.Mode == "Toggle" then 
                Keybind.Toggled = not Keybind.Toggled
            elseif Keybind.Mode == "Hold" then 
                Keybind.Toggled = Bool
            elseif Keybind.Mode == "Always" then 
                Keybind.Toggled = true
            end

            Library.Flags[Keybind.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Library:RefreshKeybindLists()
        end

        function Keybind:Get()
            return Keybind.Key, Keybind.Mode, Keybind.Toggled
        end

        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then 
                Keybind.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = "["..TextToDisplay.."]"

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif type(Key) == "table" then
                local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                Keybind.Key = tostring(Key.Key)

                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                else
                    Keybind.Mode = "Toggle"
                    Keybind:SetMode("Toggle")
                end

                local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                Keybind.Value = TextToDisplay
                Items["KeyButton"].Instance.Text = "["..TextToDisplay.."]"

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                Keybind.Mode = Key
                Keybind:SetMode(Key)

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            Library:RefreshKeybindLists()
            Keybind.Picking = false
        end

        function Keybind:StartPicking()
            if Keybind.Picking then return end
            Keybind.Picking = true

            Items["KeyButton"].Instance.Text = "..."

            -- Snapshot which mouse buttons / inputs are currently held, so the
            -- input that opened the picker (e.g. the right-click on a toggle)
            -- doesn't get captured as the bind. We only accept an input once
            -- it has BEGAN AFTER any currently-held inputs are released.
            local heldUITypes = {}
            for _, inp in ipairs(UserInputService:GetMouseButtonsPressed()) do
                heldUITypes[inp.UserInputType] = true
            end

            local InputBegan
            local startedAt = os.clock()

            InputBegan = UserInputService.InputBegan:Connect(function(Input)
                -- Ignore the very first frame's events (the trigger click).
                if os.clock() - startedAt < 0.05 then return end
                -- Ignore any input type that was held when picker opened
                -- until it's released and pressed fresh.
                if heldUITypes[Input.UserInputType] then return end

                if Input.UserInputType == Enum.UserInputType.Keyboard then
                    Keybind:Set(Input.KeyCode)
                else
                    Keybind:Set(Input.UserInputType)
                end

                Keybind.Picking = false
                if InputBegan then
                    InputBegan:Disconnect()
                    InputBegan = nil
                end
            end)

            -- When the trigger button is released, allow re-pressing it as a bind.
            local InputEnded
            InputEnded = UserInputService.InputEnded:Connect(function(Input)
                if heldUITypes[Input.UserInputType] then
                    heldUITypes[Input.UserInputType] = nil
                end
                if InputEnded and not next(heldUITypes) then
                    InputEnded:Disconnect()
                    InputEnded = nil
                end
            end)
        end

        Items["KeyButton"]:Connect("MouseButton1Click", function()
            Keybind:StartPicking()
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Keybind.Value == "None" then
                return
            end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Keybind.IsOpen then
                    return
                end

                if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                    return
                end

                Keybind:SetOpen(false)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Keybind.Value == "None" then
                return
            end

            if tostring(Input.KeyCode) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            elseif tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                elseif Keybind.Mode == "Always" then 
                    Keybind:Press(true)
                end
            end
        end)

        Items["KeyButton"]:Connect("MouseButton2Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)

        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)

        Items["Always"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
            Keybind:SetMode("Always")
        end)

        if Data.Default then 
            Keybind:Set({
                Mode = Data.Mode or "Toggle",
                Key = Data.Default,
            })
        end

        Library.SetFlags[Keybind.Flag] = function(Value)
            Keybind:Set(Value)
        end

        Library:RegisterKeybind(Keybind)
        
        return Keybind, Items 
    end

    do 
        Library.Watermark = function(self, Name, Logo)
            local Watermark = { }

            local Items = { } do 
                Items["Watermark"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 20),
                    Size = UDim2.new(0, 0, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Items["Watermark"]:MakeDraggable()
                
                Instances:Create("UICorner", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
                
                Items["Logo"] = Instances:Create("ImageLabel", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 25, 0, 25),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    FontFace = Library.TitleFont or Library.Font,
                    Font = Library.TitleFontEnum or Enum.Font.GothamBold,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Perccss in my sodaa",
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 34, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 18
                }):AddToTheme({TextColor3 = 'Text'})
            end

            function Watermark:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool 
            end

            function Watermark:SetCenter()
                local CenterPosition = Items["Watermark"].Instance.AbsolutePosition
                task.wait()
                Items["Watermark"].Instance.AnchorPoint = Vector2New(0, 0)

                Items["Watermark"].Instance.Position = UDim2.new(0, CenterPosition.X, 0, CenterPosition.Y)
            end

            Watermark:SetText(Name)
            Watermark:SetCenter()

            return Watermark 
        end

        Library.KeybindList = function(self, Window, Data)
            Data = Data or { }

            local KeybindList = {
                Window = Window,
                Visible = Data.Visible ~= false,
                Entries = { }
            }

            local Items = { } do
                Items["Main"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = Data.Position or self.DefaultKeybindListPosition or UDim2.new(1, -18, 0, 120),
                    Size = UDim2FromOffset(Data.Width or 220, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Panel"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Visible = false,
                    ZIndex = 18
                }):AddToTheme({BackgroundColor3 = 'Panel'})

                Items["Main"]:MakeDraggable()

                Instances:Create("UICorner", {
                    Parent = Items["Main"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 12)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Main"].Instance,
                    Name = "\0",
                    Color = Library.Theme["OutlineSoft"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'OutlineSoft'})

                Instances:Create("UIPadding", {
                    Parent = Items["Main"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 12),
                    PaddingBottom = UDimNew(0, 12),
                    PaddingLeft = UDimNew(0, 12),
                    PaddingRight = UDimNew(0, 12)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Main"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Main"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 16),
                    FontFace = Library.TitleFont or Library.Font,
                    Font = Library.TitleFontEnum or Enum.Font.GothamBold,
                    Text = string.upper(tostring(Data.Title or "Keybinds")),
                    TextColor3 = Library.Theme["TextMuted"],
                    TextSize = 15,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 19
                }):AddToTheme({TextColor3 = 'TextMuted'})

                Items["Divider"] = Instances:Create("Frame", {
                    Parent = Items["Main"].Instance,
                    Name = "\0",
                    BackgroundColor3 = Library.Theme["OutlineSoft"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 1),
                    ZIndex = 19
                }):AddToTheme({BackgroundColor3 = 'OutlineSoft'})

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Main"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ZIndex = 19
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            function KeybindList:SetVisibility(Bool)
                KeybindList.Visible = Bool and true or false
                KeybindList:Refresh(KeybindList.Entries)
            end

            function KeybindList:SetPosition(Position)
                if Position then
                    Items["Main"].Instance.Position = Position
                end
            end

            function KeybindList:Refresh(Entries)
                Entries = Entries or Library:GetKeybindListEntries()
                KeybindList.Entries = Entries

                for _, Child in next, Items["Content"].Instance:GetChildren() do
                    if not Child:IsA("UIListLayout") then
                        Child:Destroy()
                    end
                end

                for _, Entry in next, Entries do
                    local Row = Instances:Create("Frame", {
                        Parent = Items["Content"].Instance,
                        Name = "\0",
                        BackgroundColor3 = Entry.Toggled and Library.Theme["AccentSoft"] or Library.Theme["Surface"],
                        BackgroundTransparency = Entry.Toggled and 0 or 0.08,
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Size = UDim2.new(1, 0, 0, 28),
                        ZIndex = 19
                    }):AddToTheme({BackgroundColor3 = function()
                        return Entry.Toggled and Library.Theme["AccentSoft"] or Library.Theme["Surface"]
                    end})

                    Instances:Create("UICorner", {
                        Parent = Row.Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 8)
                    })

                    local AccentStrip = Instances:Create("Frame", {
                        Parent = Row.Instance,
                        Name = "\0",
                        BackgroundColor3 = Library.Theme["Accent"],
                        BackgroundTransparency = Entry.Toggled and 0 or 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2FromOffset(8, 6),
                        Size = UDim2FromOffset(3, 16),
                        ZIndex = 20
                    }):AddToTheme({BackgroundColor3 = 'Accent'})

                    Instances:Create("UICorner", {
                        Parent = AccentStrip.Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(1, 0)
                    })

                    local NameLabel = Instances:Create("TextLabel", {
                        Parent = Row.Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2FromOffset(18, 0),
                        Size = UDim2.new(1, -104, 1, 0),
                        FontFace = Library.Font,
                        Text = Entry.Name,
                        TextColor3 = Entry.Toggled and Library.Theme["Text"] or Library.Theme["Text"],
                        TextTransparency = Entry.Toggled and 0 or 0.08,
                        TextSize = 14,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 20
                    }):AddToTheme({TextColor3 = function()
                        return Library.Theme["Text"]
                    end})

                    local KeyLabel = Instances:Create("TextLabel", {
                        Parent = Row.Instance,
                        Name = "\0",
                        AnchorPoint = Vector2New(1, 0.5),
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        Position = UDim2.new(1, -10, 0.5, 0),
                        Size = UDim2FromOffset(82, 14),
                        FontFace = Library.Font,
                        Text = StringFormat("[%s] %s", Entry.Key, Entry.Mode),
                        TextColor3 = Entry.Toggled and Library.Theme["Text"] or Library.Theme["TextMuted"],
                        TextTransparency = Entry.Toggled and 0.2 or 0,
                        TextSize = 12,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        ZIndex = 20
                    }):AddToTheme({TextColor3 = function()
                        return Entry.Toggled and Library.Theme["Text"] or Library.Theme["TextMuted"]
                    end})
                end

                Items["Main"].Instance.Visible = KeybindList.Visible and #Entries > 0
            end

            TableInsert(self.KeybindLists, KeybindList)
            self:RefreshKeybindLists()

            return KeybindList
        end

        Library.ToggleButton = function(self, Window, Data)
            Data = Data or { }

            local ToggleButton = { }
            local Items = { } do
                Items["Button"] = Instances:Create("ImageButton", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AutoButtonColor = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"],
                    Position = Data.Position or self.DefaultToggleButtonPosition or UDim2.new(0.5, -25, 0, 105),
                    Size = Data.Size or UDim2FromOffset(50, 50),
                    Image = "",
                    ClipsDescendants = true,
                    BackgroundTransparency = 0,
                    ZIndex = 20
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Items["Button"]:MakeDraggable()

                Instances:Create("UICorner", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 12)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["Inner"] = Instances:Create("ImageLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Library.Theme["Background"],
                    BackgroundTransparency = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Image = Data.Icon or self.DefaultToggleButtonIcon or "rbxassetid://10723407389",
                    ImageColor3 = FromRGB(250, 250, 250),
                    ZIndex = 21
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Instances:Create("UICorner", {
                    Parent = Items["Inner"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 10)
                })
            end

            function ToggleButton:Press()
                Window:SetOpen(not Window.IsOpen)
            end

            function ToggleButton:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function ToggleButton:SetPosition(Position)
                if Position then
                    Items["Button"].Instance.Position = Position
                end
            end

            function ToggleButton:SetIcon(Icon)
                if Icon and Icon ~= "" then
                    Items["Inner"].Instance.Image = Icon
                end
            end

            local PressStart = nil

            Items["Button"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    PressStart = Input.Position
                end
            end)

            Items["Button"]:Connect("InputEnded", function(Input)
                if not PressStart then
                    return
                end

                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                local DragDistance = (Input.Position - PressStart).Magnitude
                PressStart = nil

                if DragDistance <= 8 then
                    ToggleButton:Press()
                end
            end)

            ToggleButton:SetIcon(Data.Icon)
            return ToggleButton
        end

        Library.Window = function(self, Data)
            Data = Data or { }

            local HideLogo = Data.HideLogo or Data.hidelogo or Data.Logo == false or Data.logo == false
            local HasTitleCrown = Data.TitleCrown or Data.titlecrown or false
            local TitleCrownColor = Data.TitleCrownColor or Data.titlecrowncolor or Library.Theme["Text"]
            local TitleCrownIcon = Data.TitleCrownIcon or Data.titlecrownicon or "crown"

            local Window = {
                Name = Data.Name or Data.name or "Window",
                SubName = Data.SubName or Data.subname or Data.SubTitle or Data.subtitle or Data.Subtitle or "",
                Logo = (not HideLogo) and (Data.Logo or Data.logo or self.DefaultHeaderLogo or "rbxassetid://81441172534384") or nil,

                Pages = { },
                Items = { },
                SidebarGroups = { },
                SidebarGroupCount = 0,
                VisualRefreshers = { },
                IsOpen = false,
                IsMaximized = false,
                IsSidebarCollapsed = false,
                SidebarCollapseEnabled = Data.SidebarCollapseEnabled ~= false and Data.sidebarcollapseenabled ~= false,
                -- Mobile defaults (smaller widget) — overridable via Data.*
                ExpandedSidebarWidth = Data.SidebarWidth or Data.sidebarwidth or (Library:IsMobileClient() and 170 or 240),
                CollapsedSidebarWidth = Data.CollapsedSidebarWidth or Data.collapsedsidebarwidth or (Library:IsMobileClient() and 52 or 72),
                SidebarGap = Data.SidebarGap or Data.sidebargap or (Library:IsMobileClient() and 8 or 12),
                DefaultSidebarCollapsed = Data.DefaultSidebarCollapsed == true or Data.defaultsidebarcollapsed == true or Library:IsMobileClient(),
                RestorePosition = nil,
                RestoreSize = nil
            }

            local SearchIcon = Data.SearchIcon or Data.searchicon or "search"
            if self.ResolveIcon then
                SearchIcon = self:ResolveIcon(SearchIcon)
                TitleCrownIcon = self:ResolveIcon(TitleCrownIcon)
            end

            if type(SearchIcon) ~= "string" or (not SearchIcon:match("^rbxassetid://") and not SearchIcon:match("^https?://")) then
                SearchIcon = "rbxassetid://6031154871"
            end

            local HasSubtitle = Window.SubName ~= ""
            local HasLogo = type(Window.Logo) == "string" and Window.Logo ~= ""
            local HeaderLogoSize = Data.HeaderLogoSize or Data.headerlogosize or Data.LogoSize or Data.logosize or self.DefaultHeaderLogoSize or 28
            local BrandPrimary, BrandSecondary = tostring(Window.Name):match("^(%S+)%s+(.+)$")

            if type(HeaderLogoSize) ~= "number" then
                HeaderLogoSize = 28
            end

            if not BrandPrimary then
                BrandPrimary = Window.Name
                BrandSecondary = nil
            end

            local HeaderHeight = HasTitleCrown and 58 or 46
            local PagesCardTop = HasTitleCrown and 88 or 74
            local CompactTitle = tostring(BrandPrimary):sub(1, 1) .. (BrandSecondary and tostring(BrandSecondary):sub(1, 1) or "")
            local WindowControlCount = Window.SidebarCollapseEnabled and 4 or 3
            local WindowControlsWidth = (WindowControlCount * 30) + ((WindowControlCount - 1) * 6)
            local SubtitleRightInset = WindowControlsWidth + 68
            local ContentOffset = Window.ExpandedSidebarWidth + Window.SidebarGap

            -- Mobile: smaller window so it fits on phones/tablets without
            -- requiring the user to resize manually. Min size also smaller
            -- so user can shrink further if desired.
            local _isMobileWin = Library:IsMobileClient()
            local _winW = _isMobileWin and 560 or 960
            local _winH = _isMobileWin and 360 or 560
            local _minW = _isMobileWin and 480 or 860
            local _minH = _isMobileWin and 320 or 520

            local Items = { } do
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2FromOffset(_winW, _winH),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1
                })

                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2New(_minW, _minH), Vector2New(9999, 9999))

                Items["Sidebar"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundColor3 = Library.Theme["Panel"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(0, Window.ExpandedSidebarWidth, 1, 0),
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = 'Panel'})

                Instances:Create("UICorner", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 18)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    Color = Library.Theme["OutlineSoft"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'OutlineSoft'})

                Items["Top"] = Instances:Create("Frame", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Position = UDim2FromOffset(16, 16),
                    Size = UDim2.new(1, -32, 0, HeaderHeight),
                    BorderSizePixel = 0
                })

                Items["TopContent"] = Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0
                })

                Items["TopContentLayout"] = Instances:Create("UIListLayout", {
                    Parent = Items["TopContent"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                if HasLogo then
                    Items["Logo"] = Instances:Create("ImageLabel", {
                        Parent = Items["TopContent"].Instance,
                        Name = "\0",
                        ScaleType = Enum.ScaleType.Fit,
                        ImageColor3 = Library.Theme["Text"],
                        BorderColor3 = FromRGB(0, 0, 0),
                        Image = Window.Logo,
                        BackgroundTransparency = 1,
                        Size = UDim2FromOffset(HeaderLogoSize, HeaderLogoSize),
                        BorderSizePixel = 0
                    }):AddToTheme({ImageColor3 = 'Text'})
                else
                    Items["Logo"] = Instances:Create("Frame", {
                        Parent = Items["TopContent"].Instance,
                        Name = "\0",
                        Visible = false,
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2FromOffset(0, 0),
                        BorderSizePixel = 0
                    })
                end

                Items["Brand"] = Instances:Create("Frame", {
                    Parent = Items["TopContent"].Instance,
                    Name = "\0",
                    Size = UDim2.new(0, 0, 1, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0
                })

                Items["BrandLayout"] = Instances:Create("UIListLayout", {
                    Parent = Items["Brand"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDimNew(0, BrandSecondary and 12 or 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Title"] = Instances:Create("TextLabel", {
                    Parent = Items["Brand"].Instance,
                    Name = "\0",
                    FontFace = Library.BrandFont or Library.TitleFont or Library.Font,
                    Font = Library.BrandFontEnum or Library.TitleFontEnum or Enum.Font.GothamBold,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = BrandPrimary,
                    Size = UDim2.new(0, 0, 0, 32),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextWrapped = false,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 36,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center
                }):AddToTheme({TextColor3 = 'Text'})

                if BrandSecondary then
                    Items["TitleSecondary"] = Instances:Create("TextLabel", {
                        Parent = Items["Brand"].Instance,
                        Name = "\0",
                        FontFace = Library.BrandFont or Library.TitleFont or Library.Font,
                        Font = Library.BrandFontEnum or Library.TitleFontEnum or Enum.Font.GothamBold,
                        TextColor3 = Library.Theme["Text"],
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = BrandSecondary,
                        Size = UDim2.new(0, 0, 0, 32),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        TextWrapped = false,
                        AutomaticSize = Enum.AutomaticSize.X,
                        TextSize = 36,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Center
                    }):AddToTheme({TextColor3 = 'Text'})
                end

                if HasTitleCrown then
                    Items["TitleCrown"] = Instances:Create("ImageLabel", {
                        Parent = Items["Title"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Image = TitleCrownIcon,
                        ImageColor3 = TitleCrownColor,
                        Rotation = -26,
                        Position = UDim2FromOffset(-12, -24),
                        Size = UDim2FromOffset(28, 28),
                        ScaleType = Enum.ScaleType.Fit,
                        BorderSizePixel = 0,
                        ZIndex = 2
                    })
                end

                Items["CompactBadge"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    Visible = false,
                    FontFace = Library.BrandFont or Library.TitleFont or Library.Font,
                    Font = Library.BrandFontEnum or Library.TitleFontEnum or Enum.Font.GothamBold,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = CompactTitle ~= "" and CompactTitle or tostring(Window.Name):sub(1, 1),
                    Size = UDim2.new(0, 0, 0, 24),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.X,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    TextSize = 22,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center
                }):AddToTheme({TextColor3 = 'Text'})

                Items["PagesCard"] = Instances:Create("Frame", {
                    Parent = Items["Sidebar"].Instance,
                    Name = "\0",
                    Position = UDim2FromOffset(8, PagesCardTop),
                    Size = UDim2.new(1, -16, 1, -(PagesCardTop + 8)),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Surface"]
                }):AddToTheme({BackgroundColor3 = 'Surface'})

                Instances:Create("UICorner", {
                    Parent = Items["PagesCard"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 16)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["PagesCard"].Instance,
                    Name = "\0",
                    Color = Library.Theme["OutlineSoft"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'OutlineSoft'})

                Items["Pages"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["PagesCard"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 0,
                    Size = UDim2.new(1, -24, 1, -24),
                    BackgroundTransparency = 1,
                    Position = UDim2FromOffset(12, 12)
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})

                Instances:Create("UIListLayout", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    -- Match inner-group button padding (4) so tabs across
                    -- different groups look identical to tabs in same group.
                    Padding = UDimNew(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["ContentShell"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundColor3 = Library.Theme["Background"],
                    Position = UDim2FromOffset(ContentOffset, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, -ContentOffset, 1, 0),
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Instances:Create("UICorner", {
                    Parent = Items["ContentShell"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 18)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["ContentShell"].Instance,
                    Name = "\0",
                    Color = Library.Theme["OutlineSoft"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'OutlineSoft'})

                Items["WindowControls"] = Instances:Create("Frame", {
                    Parent = Items["ContentShell"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2.new(1, -18, 0, 12),
                    Size = UDim2FromOffset(WindowControlsWidth, 24),
                    BorderSizePixel = 0
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["WindowControls"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Subtitle"] = Instances:Create("TextLabel", {
                    Parent = Items["ContentShell"].Instance,
                    Name = "\0",
                    Visible = HasSubtitle,
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["TextMuted"],
                    TextTransparency = 0,
                    Text = Window.SubName,
                    Size = UDim2.new(1, -SubtitleRightInset, 0, 22),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2FromOffset(20, 14),
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 17
                }):AddToTheme({TextColor3 = 'TextMuted'})

                local function ResolveWindowControlIcon(Name)
                    if self.ResolveIcon then
                        return self:ResolveIcon(Name)
                    end

                    return Name
                end

                local function CreateWindowControl(IconName)
                    local Button = Instances:Create("TextButton", {
                        Parent = Items["WindowControls"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = Library.Theme["Text"],
                        TextTransparency = 1,
                        Text = "",
                        AutoButtonColor = false,
                        BackgroundColor3 = Library.Theme["Element"],
                        BackgroundTransparency = 0.06,
                        Size = UDim2FromOffset(30, 24),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        TextSize = 14
                    }):AddToTheme({BackgroundColor3 = 'Element', TextColor3 = 'Text'})

                    Instances:Create("UICorner", {
                        Parent = Button.Instance,
                        Name = "\0",
                        CornerRadius = UDimNew(0, 8)
                    })

                    Instances:Create("UIStroke", {
                        Parent = Button.Instance,
                        Name = "\0",
                        Color = Library.Theme["OutlineSoft"],
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    }):AddToTheme({Color = 'OutlineSoft'})

                    local Icon = Instances:Create("ImageLabel", {
                        Parent = Button.Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Image = ResolveWindowControlIcon(IconName),
                        ImageTransparency = 0.2,
                        AnchorPoint = Vector2New(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2FromOffset(14, 14),
                        BorderSizePixel = 0
                    }):AddToTheme({ImageColor3 = 'Text'})

                    return Button, Icon
                end

                if Window.SidebarCollapseEnabled then
                    Items["SidebarButton"], Items["SidebarToggleIcon"] = CreateWindowControl("chevrons-left")
                end

                Items["MinimizeButton"], Items["MinimizeIcon"] = CreateWindowControl("minus")
                Items["ExpandButton"], Items["ExpandIcon"] = CreateWindowControl("maximize-2")
                Items["CloseButton"], Items["CloseIcon"] = CreateWindowControl("x")

                Items["TopDivider"] = Instances:Create("Frame", {
                    Parent = Items["ContentShell"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Position = UDim2FromOffset(20, 48),
                    Size = UDim2.new(1, -40, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["OutlineSoft"]
                }):AddToTheme({BackgroundColor3 = 'OutlineSoft'})

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["ContentShell"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2FromOffset(0, 58),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, -58),
                    BorderSizePixel = 0
                })

                -- ── Loading overlay ──────────────────────────────────────
                -- Sits on top of every Window child while the host script is
                -- adding tabs/sections. Hidden by Window:HideLoading() — or
                -- auto-fades after 4s as a safety net.
                Items["LoadingOverlay"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundColor3 = Library.Theme["Panel"],
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    ZIndex = 100,
                }):AddToTheme({BackgroundColor3 = 'Panel'})

                Instances:Create("UICorner", {
                    Parent = Items["LoadingOverlay"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 12),
                })

                Items["LoadingLogo"] = Instances:Create("ImageLabel", {
                    Parent = Items["LoadingOverlay"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, -64),
                    Size = UDim2FromOffset(96, 96),
                    Image = Library.DefaultHeaderLogo or "rbxassetid://75802679174420",
                    ZIndex = 101,
                })

                Items["LoadingTitle"] = Instances:Create("TextLabel", {
                    Parent = Items["LoadingOverlay"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 8),
                    Size = UDim2FromOffset(400, 32),
                    FontFace = Library.Font,
                    Text = (Window.Name and Window.Name .. " — Loading…") or "Loading…",
                    TextColor3 = Library.Theme["TextStrong"] or Library.Theme["Text"],
                    TextSize = 22,
                    ZIndex = 101,
                }):AddToTheme({TextColor3 = 'Text'})

                Items["LoadingSub"] = Instances:Create("TextLabel", {
                    Parent = Items["LoadingOverlay"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 36),
                    Size = UDim2FromOffset(400, 18),
                    FontFace = Library.Font,
                    Text = "preparing the interface",
                    TextColor3 = Library.Theme["TextMuted"],
                    TextSize = 13,
                    TextTransparency = 0.15,
                    ZIndex = 101,
                }):AddToTheme({TextColor3 = 'TextMuted'})

                -- Tiny animated dots after the subtitle text
                task.spawn(function()
                    local dots = {"", ".", "..", "..."}
                    local i = 1
                    while Items["LoadingOverlay"] and Items["LoadingOverlay"].Instance and Items["LoadingOverlay"].Instance.Parent do
                        if Items["LoadingSub"] and Items["LoadingSub"].Instance and Items["LoadingSub"].Instance.Parent then
                            Items["LoadingSub"].Instance.Text = "preparing the interface" .. dots[i]
                        end
                        i = (i % #dots) + 1
                        task.wait(0.3)
                    end
                end)

                Window.IsLoading = true

                Window.Items = Items
            end

            function Window:GetSidebarGroup(Name)
                Name = tostring(Name or "")

                local GroupKey = Name ~= "" and Name or "__default"
                if Window.SidebarGroups[GroupKey] then
                    return Window.SidebarGroups[GroupKey]
                end

                Window.SidebarGroupCount += 1

                -- Group labels disabled: tabs render as a flat list with no
                -- "Settings" / category headers between them.
                local HasLabel = false
                local GroupItems = { } do
                    GroupItems["Group"] = Instances:Create("Frame", {
                        Parent = Items["Pages"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2.new(1, 0, 0, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.Y
                    })

                    GroupItems["Group"].Instance.LayoutOrder = Window.SidebarGroupCount
                    GroupItems.HasLabel = HasLabel

                    GroupItems["Layout"] = Instances:Create("UIListLayout", {
                        Parent = GroupItems["Group"].Instance,
                        Name = "\0",
                        Padding = UDimNew(0, HasLabel and 10 or 0),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    GroupItems["Label"] = Instances:Create("TextLabel", {
                        Parent = GroupItems["Group"].Instance,
                        Name = "\0",
                        Visible = HasLabel,
                        FontFace = Library.Font,
                        TextColor3 = Library.Theme["TextMuted"],
                        TextTransparency = 0.05,
                        Text = Name,
                        Size = UDim2.new(1, 0, 0, 14),
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextSize = 14
                    }):AddToTheme({TextColor3 = 'TextMuted'})

                    GroupItems["Buttons"] = Instances:Create("Frame", {
                        Parent = GroupItems["Group"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2.new(1, 0, 0, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.Y
                    })

                    Instances:Create("UIListLayout", {
                        Parent = GroupItems["Buttons"].Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 4),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                end

                Window.SidebarGroups[GroupKey] = GroupItems

                if type(Window.RefreshSidebarGroupLayout) == "function" then
                    Window:RefreshSidebarGroupLayout(GroupItems)
                end

                return GroupItems
            end

            function Window:RefreshSidebarHeaderLayout()
                local Collapsed = Window.IsSidebarCollapsed
                local ShowLogo = Collapsed and HasLogo

                if Items["Logo"] then
                    Items["Logo"].Instance.Visible = ShowLogo
                    Items["Logo"].Instance.Size = ShowLogo and UDim2FromOffset(HeaderLogoSize, HeaderLogoSize) or UDim2FromOffset(0, 0)
                end

                if Items["Brand"] then
                    Items["Brand"].Instance.Visible = not Collapsed
                    Items["Brand"].Instance.AutomaticSize = (not Collapsed) and Enum.AutomaticSize.X or Enum.AutomaticSize.None
                    Items["Brand"].Instance.Size = (not Collapsed) and UDim2.new(0, 0, 1, 0) or UDim2FromOffset(0, 0)
                end

                if Items["TopContentLayout"] then
                    Items["TopContentLayout"].Instance.Padding = UDimNew(0, ShowLogo and 10 or 0)
                end

                if Items["BrandLayout"] then
                    Items["BrandLayout"].Instance.Padding = UDimNew(0, (not Collapsed and BrandSecondary) and 12 or 0)
                end

                Items["TopContent"].Instance.Visible = not Collapsed or ShowLogo
                Items["CompactBadge"].Instance.Visible = Collapsed and not HasLogo
                Items["Title"].Instance.Visible = not Collapsed

                if Items["TitleSecondary"] then
                    Items["TitleSecondary"].Instance.Visible = not Collapsed
                end

                if Items["TitleCrown"] then
                    Items["TitleCrown"].Instance.Visible = not Collapsed
                end
            end

            function Window:RefreshSidebarGroupLayout(GroupItems)
                if type(GroupItems) ~= "table" then
                    return
                end

                local ShowLabel = GroupItems.HasLabel and not Window.IsSidebarCollapsed

                if GroupItems["Label"] then
                    GroupItems["Label"].Instance.Visible = ShowLabel
                end

                if GroupItems["Layout"] then
                    GroupItems["Layout"].Instance.Padding = UDimNew(0, ShowLabel and 10 or 0)
                end
            end

            function Window:RefreshSidebarPageLayout(Page)
                if type(Page) ~= "table" or type(Page.Items) ~= "table" then
                    return
                end

                local PageItems = Page.Items
                local Collapsed = Window.IsSidebarCollapsed
                local IsActiveOrHovered = Page.Active or Page.Hovered

                if PageItems["Text"] then
                    PageItems["Text"].Instance.Visible = not Collapsed
                    PageItems["Text"].Instance.TextTransparency = Collapsed and 1 or (Page.Active and 0 or 0.22)
                    PageItems["Text"].Instance.Position = UDim2.new(0, 44, 0.5, 0)
                end

                if PageItems["Background"] then
                    PageItems["Background"].Instance.AnchorPoint = Collapsed and Vector2New(0.5, 0.5) or Vector2New(0, 0)
                    PageItems["Background"].Instance.Position = Collapsed and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 0, 0, 0)
                    PageItems["Background"].Instance.Size = Collapsed and UDim2FromOffset(42, 42) or UDim2.new(1, 0, 1, 0)
                end

                if PageItems["Stroke"] then
                    PageItems["Stroke"].Instance.Transparency = Collapsed and (IsActiveOrHovered and 0.25 or 1) or PageItems["Stroke"].Instance.Transparency
                end

                if PageItems["AccentBar"] then
                    PageItems["AccentBar"].Instance.Visible = not Collapsed
                end

                if PageItems["Icon"] then
                    PageItems["Icon"].Instance.AnchorPoint = Collapsed and Vector2New(0.5, 0.5) or Vector2New(0, 0.5)
                    PageItems["Icon"].Instance.Position = Collapsed and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0, 16, 0.5, 0)
                    PageItems["Icon"].Instance.Size = Collapsed and UDim2FromOffset(18, 18) or UDim2FromOffset(16, 16)
                end
            end

            function Window:RefreshSidebarLayout(Animate)
                local SidebarWidth = Window.IsSidebarCollapsed and Window.CollapsedSidebarWidth or Window.ExpandedSidebarWidth
                local NewContentOffset = SidebarWidth + Window.SidebarGap
                local SidebarTweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                if Items["SidebarToggleIcon"] then
                    Items["SidebarToggleIcon"].Instance.Image = Library:ResolveIcon(Window.IsSidebarCollapsed and "chevrons-right" or "chevrons-left")
                end

                Window:RefreshSidebarHeaderLayout()

                for _, GroupItems in next, Window.SidebarGroups do
                    Window:RefreshSidebarGroupLayout(GroupItems)
                end

                for _, Page in next, Window.Pages do
                    if type(Page.RefreshVisualState) == "function" then
                        Page:RefreshVisualState(false)
                    else
                        Window:RefreshSidebarPageLayout(Page)
                    end
                end

                if Animate then
                    Items["Sidebar"]:Tween(SidebarTweenInfo, {Size = UDim2.new(0, SidebarWidth, 1, 0)})
                    Items["ContentShell"]:Tween(SidebarTweenInfo, {
                        Position = UDim2FromOffset(NewContentOffset, 0),
                        Size = UDim2.new(1, -NewContentOffset, 1, 0)
                    })
                else
                    Items["Sidebar"].Instance.Size = UDim2.new(0, SidebarWidth, 1, 0)
                    Items["ContentShell"].Instance.Position = UDim2FromOffset(NewContentOffset, 0)
                    Items["ContentShell"].Instance.Size = UDim2.new(1, -NewContentOffset, 1, 0)
                end
            end

            function Window:SetSidebarCollapsed(Bool)
                Bool = Bool and true or false

                if Window.IsSidebarCollapsed == Bool then
                    return
                end

                Window.IsSidebarCollapsed = Bool
                Window:RefreshSidebarLayout(true)
            end

            function Window:ToggleSidebar()
                Window:SetSidebarCollapsed(not Window.IsSidebarCollapsed)
            end

            function Window:RegisterVisualRefresher(Callback)
                if type(Callback) ~= "function" then
                    return
                end

                TableInsert(Window.VisualRefreshers, Callback)
                return Callback
            end

            function Window:RefreshVisualStates()
                for _, Callback in next, Window.VisualRefreshers do
                    Library:SafeCall(Callback)
                end
            end

            function Window:SetCenter()
                local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
                task.wait()
                Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)

                Items["MainFrame"].Instance.Position = UDim2.new(0, CenterPosition.X, 0, CenterPosition.Y)
            end

            function Window:SetMaximized(Bool)
                if Window.IsMaximized == Bool then
                    return
                end

                Window.IsMaximized = Bool

                if Items["ExpandIcon"] then
                    Items["ExpandIcon"].Instance.Image = self:ResolveIcon(Window.IsMaximized and "minimize-2" or "maximize-2")
                end

                if Bool then
                    Window.RestorePosition = Items["MainFrame"].Instance.Position
                    Window.RestoreSize = Items["MainFrame"].Instance.Size

                    local ScreenSize = Library.Holder.Instance.AbsoluteSize
                    local NewPosition = UDim2FromOffset(12, 12)
                    local NewSize = UDim2FromOffset(ScreenSize.X - 24, ScreenSize.Y - 24)

                    Items["MainFrame"]:Tween(TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Position = NewPosition
                    })
                    Items["MainFrame"]:Tween(TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = NewSize
                    })
                else
                    Items["MainFrame"]:Tween(TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Position = Window.RestorePosition or UDim2FromOffset(60, 60)
                    })
                    Items["MainFrame"]:Tween(TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = Window.RestoreSize or UDim2FromOffset(960, 560)
                    })
                end
            end

            function Window:ToggleMaximize()
                Window:SetMaximized(not Window.IsMaximized)
            end

            -- Quando o usuário arrasta a janela maximizada, ela volta pro tamanho
            -- anterior e fica posicionada sob o cursor — comportamento padrão de
            -- janelas de SO (Windows/macOS). A posição é setada na hora (pra que o
            -- drag math do MakeDraggable capture o ponto correto), mas o tamanho
            -- anima suavemente.
            Items["MainFrame"].OnDragStarted = function(Input)
                if not Window.IsMaximized then
                    return
                end

                Window.IsMaximized = false
                if Items["ExpandIcon"] then
                    Items["ExpandIcon"].Instance.Image = Window:ResolveIcon("maximize-2")
                end

                local RestoreSize = Window.RestoreSize or UDim2FromOffset(960, 560)
                local Frame = Items["MainFrame"].Instance

                local TargetWidth = RestoreSize.X.Offset
                if TargetWidth == 0 then
                    TargetWidth = Frame.AbsoluteSize.X
                end

                -- Posiciona a janela com o cursor próximo ao centro da barra de
                -- título — instantâneo pra não quebrar a captura do drag delta.
                local AnchorOffsetX = TargetWidth * Frame.AnchorPoint.X
                local AnchorOffsetY = 20 * Frame.AnchorPoint.Y
                local NewX = Input.Position.X - (TargetWidth / 2) + AnchorOffsetX
                local NewY = Input.Position.Y - 20 + AnchorOffsetY

                Frame.Position = UDim2FromOffset(NewX, math.max(0, NewY))

                -- Tween só o Size (a posição vai sendo atualizada pelo drag, então
                -- não dá pra animar a posição sem conflitar com o MakeDraggable).
                TweenService:Create(
                    Frame,
                    TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    { Size = RestoreSize }
                ):Play()
            end

            function Window:SetOpen(Bool)
                Bool = Bool and true or false

                if Window.IsOpen == Bool then
                    return
                end

                Window.IsOpen = Bool

                if Window.IsOpen then 
                    Window:RefreshVisualStates()
                end

                Items["MainFrame"].Instance.Visible = Window.IsOpen
            end

            local function ConnectWindowControl(Button, HoverTransparency, Callback)
                Button:Connect("MouseEnter", function()
                    Button:Tween(nil, {BackgroundTransparency = HoverTransparency or 0})
                end)

                Button:Connect("MouseLeave", function()
                    Button:Tween(nil, {BackgroundTransparency = 0.06})
                end)

                Button:Connect("MouseButton1Down", Callback)
            end

            if Items["SidebarButton"] then
                ConnectWindowControl(Items["SidebarButton"], 0, function()
                    Window:ToggleSidebar()
                end)
            end

            ConnectWindowControl(Items["MinimizeButton"], 0, function()
                Window:SetOpen(false)
            end)

            ConnectWindowControl(Items["ExpandButton"], 0, function()
                Window:ToggleMaximize()
            end)

            ConnectWindowControl(Items["CloseButton"], 0, function()
                Library:Unload()
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:RefreshSidebarLayout(false)

            if Window.DefaultSidebarCollapsed then
                Window.IsSidebarCollapsed = true
                Window:RefreshSidebarLayout(false)
            end

            Window:SetCenter()
            task.wait()
            Window:SetOpen(true)
            return setmetatable(Window, Library)
        end

        Library.Page = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self,

                Name = Data.Name or Data.name or "Page",
                Icon = Data.Icon or Data.icon or "rbxassetid://72196061405823",
                Category = Data.Category or Data.category or Data.Group or Data.group or "",

                Items = { },
                Active = false,
                Hovered = false
            }

            local SidebarGroup = Page.Window:GetSidebarGroup(Page.Category)

            local Items = { } do 
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = SidebarGroup["Buttons"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 42),
                    BorderSizePixel = 0,
                    TextSize = 14
                })

                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Surface"]
                }):AddToTheme({BackgroundColor3 = 'Surface'})

                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 12)
                })

                Items["Stroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Color = Library.Theme["OutlineSoft"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Transparency = 1
                }):AddToTheme({Color = 'OutlineSoft'})

                Items["AccentBar"] = Instances:Create("Frame", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2.new(0, 8, 0.5, 0),
                    Size = UDim2FromOffset(3, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"],
                    BackgroundTransparency = 1
                }):AddToTheme({BackgroundColor3 = 'Accent'})

                Instances:Create("UICorner", {
                    Parent = Items["AccentBar"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Fit,
                    ImageTransparency = 0.35,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 16, 0.5, 0),
                    Size = UDim2FromOffset(16, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'TextMuted'})

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["TextMuted"],
                    TextTransparency = 0.22,
                    Text = Page.Name,
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 44, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Left
                }):AddToTheme({TextColor3 = 'TextMuted'})

                Items["Page"] = Instances:Create("ScrollingFrame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                    ElasticBehavior = Enum.ElasticBehavior.Never,
                    ScrollBarThickness = 0,
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})

                Items["Columns"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Columns"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                local function CreatePageColumn(ColumnName)
                    local Column = Instances:Create("Frame", {
                        Parent = Items["Columns"].Instance,
                        Name = ColumnName,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0.5, -4, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.Y
                    })

                    Instances:Create("UIPadding", {
                        Parent = Column.Instance,
                        Name = "\0",
                        PaddingTop = UDimNew(0, 18),
                        PaddingBottom = UDimNew(0, 18),
                        PaddingRight = UDimNew(0, 10),
                        PaddingLeft = UDimNew(0, 10)
                    })

                    Instances:Create("UIListLayout", {
                        Parent = Column.Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 14),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })

                    return Column
                end

                Items["LeftColumn"] = CreatePageColumn("LeftColumn")
                Items["RightColumn"] = CreatePageColumn("RightColumn")
                Items["Column"] = Items["LeftColumn"]

                Page.Items = Items
            end

            function Page:RefreshVisualState(Animate)
                local UseTween = Animate == true
                local Collapsed = Page.Window.IsSidebarCollapsed
                local TextColor = Page.Active and Library.Theme.Text or (Page.Hovered and Library.Theme.Text or Library.Theme.TextMuted)
                local TextTransparency = Collapsed and 1 or (Page.Active and 0 or (Page.Hovered and 0.08 or 0.22))
                local IconColor = Page.Active and Library.Theme.Accent or (Page.Hovered and Library.Theme.Text or Library.Theme.TextMuted)
                local IconTransparency = Page.Active and 0 or (Page.Hovered and 0.08 or 0.3)
                local BackgroundTransparency = Collapsed and (Page.Active and 0.04 or (Page.Hovered and 0.18 or 1)) or (Page.Active and 0.08 or (Page.Hovered and 0.35 or 1))
                local StrokeTransparency = Collapsed and (Page.Active and 0.25 or (Page.Hovered and 0.55 or 1)) or (Page.Active and 0.4 or (Page.Hovered and 0.7 or 1))
                local AccentTransparency = Collapsed and 1 or (Page.Active and 0 or 1)
                local AccentHeight = Collapsed and 0 or (Page.Active and 18 or 0)

                Items["Page"].Instance.Visible = Page.Active
                Items["Page"].Instance.Parent = Page.Active and Page.Window.Items["Content"].Instance or Library.UnusedHolder.Instance

                Items["Text"]:ChangeItemTheme({TextColor3 = function()
                    return Page.Active and Library.Theme.Text or (Page.Hovered and Library.Theme.Text or Library.Theme.TextMuted)
                end})
                Items["Icon"]:ChangeItemTheme({ImageColor3 = function()
                    return Page.Active and Library.Theme.Accent or (Page.Hovered and Library.Theme.Text or Library.Theme.TextMuted)
                end})

                if UseTween then
                    Items["Background"]:Tween(nil, {BackgroundTransparency = BackgroundTransparency})
                    Items["Stroke"]:Tween(nil, {Transparency = StrokeTransparency})
                    Items["AccentBar"]:Tween(nil, {Size = UDim2FromOffset(3, AccentHeight), BackgroundTransparency = AccentTransparency})
                    Items["Text"]:Tween(nil, {TextColor3 = TextColor, TextTransparency = TextTransparency})
                    Items["Icon"]:Tween(nil, {ImageColor3 = IconColor, ImageTransparency = IconTransparency})
                else
                    Items["Background"].Instance.BackgroundTransparency = BackgroundTransparency
                    Items["Stroke"].Instance.Transparency = StrokeTransparency
                    Items["AccentBar"].Instance.Size = UDim2FromOffset(3, AccentHeight)
                    Items["AccentBar"].Instance.BackgroundTransparency = AccentTransparency
                    Items["Text"].Instance.TextColor3 = TextColor
                    Items["Text"].Instance.TextTransparency = TextTransparency
                    Items["Icon"].Instance.ImageColor3 = IconColor
                    Items["Icon"].Instance.ImageTransparency = IconTransparency
                end

                if type(Page.Window.RefreshSidebarPageLayout) == "function" then
                    Page.Window:RefreshSidebarPageLayout(Page)
                end
            end

            function Page:Turn(Bool)
                Page.Active = Bool and true or false
                Page.Hovered = false
                Page:RefreshVisualState(true)
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            Items["Inactive"]:Connect("MouseEnter", function()
                if Page.Active then
                    return
                end

                Page.Hovered = true
                Page:RefreshVisualState(true)
            end)

            Items["Inactive"]:Connect("MouseLeave", function()
                if Page.Active then
                    return
                end

                Page.Hovered = false
                Page:RefreshVisualState(true)
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn(true)
            end

            Items["Inactive"].Instance.LayoutOrder = #Page.Window.Pages + 1
            TableInsert(Page.Window.Pages, Page)
            Page.Window:RegisterVisualRefresher(function()
                Page:RefreshVisualState(false)
            end)

            if type(Page.Window.RefreshSidebarPageLayout) == "function" then
                Page.Window:RefreshSidebarPageLayout(Page)
            end

            return setmetatable(Page, Library.Pages)
        end

        Library.Pages.Section = function(self, Data)
            Data = Data or { }

            local Section = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "Section",
                Side = Data.Side or Data.side or 1,
                Icon = Data.Icon or Data.icon or "rbxassetid://127136375066593",

                Items = { }
            }

            local ColumnParent = (Section.Side == 2 and Section.Page.Items["RightColumn"]) or Section.Page.Items["LeftColumn"] or Section.Page.Items["Column"]

            local Items = { } do
                Items["SectionOutline"] = Instances:Create("Frame", {
                    Parent = ColumnParent.Instance,
                    Name = "\0",
                    Size = UDim2.new(1, 0, 0, 48),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["OutlineSoft"]
                }):AddToTheme({BackgroundColor3 = 'OutlineSoft'})

                Instances:Create("UICorner", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 16)
                })

                Items["Section"] = Instances:Create("Frame", {
                    Parent = Items["SectionOutline"].Instance,
                    Name = "\0",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Surface"]
                }):AddToTheme({BackgroundColor3 = 'Surface'})

                Instances:Create("UICorner", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 15)
                })

                Items["Top"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 40),
                    BorderSizePixel = 0
                })

                Items["IconBadge"] = Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2.new(0, 14, 0.5, 0),
                    Size = UDim2FromOffset(20, 20),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Instances:Create("UICorner", {
                    Parent = Items["IconBadge"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.TitleFont or Library.Font,
                    TextWrapped = true,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    Size = UDim2.new(0, 0, 0, 14),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 42, 0.5, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left
                }):AddToTheme({TextColor3 = 'Text'})

                Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2.new(0, 16, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, -32, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["OutlineSoft"]
                }):AddToTheme({BackgroundColor3 = 'OutlineSoft'})

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["IconBadge"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = Section.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Accent'})

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 40),
                    Size = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 12),
                    PaddingBottom = UDimNew(0, 14),
                    PaddingRight = UDimNew(0, 16),
                    PaddingLeft = UDimNew(0, 16)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Section.Items = Items
            end

            return setmetatable(Section, Library.Sections)
        end

        Library.Sections.Toggle = function(self, Data)
            Data = Data or { }

            local Toggle = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Toggle",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,
                SkipInitialCallback = Data.SkipInitialCallback or Data.skipinitialcallback or Data.SkipCallbackOnInit or Data.skipcallbackoninit or false,

                Value = false
            }

            local Items = { } do
                -- Adaptive: row mais alto no mobile pra hit area maior
                local _isMobileToggle = Library:IsMobileClient()
                local _toggleRowY = _isMobileToggle and 28 or 20

                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Toggle.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, _toggleRowY),
                    BorderSizePixel = 0,
                    TextSize = 14
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = Toggle.Name,
                    Size = UDim2.new(1, -43, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})

                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -45, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                -- Adaptive: switch maior no mobile (44x24) vs PC (35x18)
                local _indW = _isMobileToggle and 44 or 35
                local _indH = _isMobileToggle and 24 or 18

                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(0, _indW, 0, _indH),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Instances:Create("UICorner", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0"
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Circle"] = Instances:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    BackgroundTransparency = 0.5,
                    Position = UDim2.new(0, 4, 0.5, 0),
                    Size = UDim2.new(0, 10, 0, 10),
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})
                
                Instances:Create("UICorner", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                
                Items["Glow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})                
            end

            function Toggle:Get()
                return Toggle.Value 
            end

            local function UpdateToggleLayout()
                local ToggleWidth = Items["Toggle"].Instance.AbsoluteSize.X
                if ToggleWidth <= 0 then
                    return
                end

                local IndicatorWidth = MathFloor(math.max(Items["Indicator"].Instance.AbsoluteSize.X, 35))
                local SubElementsWidth = MathFloor(math.max(Items["SubElements"].Instance.AbsoluteSize.X, 0))
                local Gap = 8
                local RightReserve = IndicatorWidth + Gap

                if SubElementsWidth > 0 then
                    Items["SubElements"].Instance.Position = UDim2.new(1, -RightReserve, 0, 0)
                    RightReserve = RightReserve + SubElementsWidth + Gap
                else
                    Items["SubElements"].Instance.Position = UDim2.new(1, -RightReserve, 0, 0)
                end

                Items["Text"].Instance.Size = UDim2FromOffset(math.max(ToggleWidth - RightReserve, 0), 15)
            end

            local function ApplyToggleVisualState(Animate)
                local UseTween = Animate == true

                if Toggle.Value then
                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

                    if UseTween then
                        Items["Glow"]:Tween(nil, {ImageTransparency = 0.7})
                        -- Bounce sutil ao ligar (Back easing dá overshoot leve)
                        Items["Circle"]:Tween(TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            AnchorPoint = Vector2New(1, 0.5),
                            Position = UDim2.new(1, -3, 0.5, 0),
                            BackgroundTransparency = 0,
                            BackgroundColor3 = Library.Theme.Accent
                        })
                        Items["Text"]:Tween(nil, {TextTransparency = 0})
                    else
                        Items["Glow"].Instance.ImageTransparency = 0.7
                        Items["Circle"].Instance.AnchorPoint = Vector2New(1, 0.5)
                        Items["Circle"].Instance.Position = UDim2.new(1, -3, 0.5, 0)
                        Items["Circle"].Instance.BackgroundTransparency = 0
                        Items["Circle"].Instance.BackgroundColor3 = Library.Theme.Accent
                        Items["Text"].Instance.TextTransparency = 0
                    end
                else
                    Items["Circle"]:ChangeItemTheme({BackgroundColor3 = function() return FromRGB(255, 255, 255) end})

                    if UseTween then
                        Items["Glow"]:Tween(nil, {ImageTransparency = 1})
                        Items["Circle"]:Tween(TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                            AnchorPoint = Vector2New(0, 0.5),
                            Position = UDim2.new(0, 3, 0.5, 0),
                            BackgroundTransparency = 0.6,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })
                        Items["Text"]:Tween(nil, {TextTransparency = 0.5})
                    else
                        Items["Glow"].Instance.ImageTransparency = 1
                        Items["Circle"].Instance.AnchorPoint = Vector2New(0, 0.5)
                        Items["Circle"].Instance.Position = UDim2.new(0, 3, 0.5, 0)
                        Items["Circle"].Instance.BackgroundTransparency = 0.6
                        Items["Circle"].Instance.BackgroundColor3 = FromRGB(255, 255, 255)
                        Items["Text"].Instance.TextTransparency = 0.5
                    end
                end
            end

            function Toggle:Set(Value, SuppressCallback)
                Toggle.Value = Value and true or false
                Library.Flags[Toggle.Flag] = Toggle.Value

                ApplyToggleVisualState(true)

                if not SuppressCallback and Toggle.Callback then 
                    Library:SafeCall(Toggle.Callback, Toggle.Value)
                end
            end

            Toggle.Window:RegisterVisualRefresher(function()
                ApplyToggleVisualState(false)
            end)

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Name = Toggle.Name,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            -- Right-click any toggle → lazy-attach a keybind, start key picking
            -- and open the Toggle/Hold/Always mode picker. The keybind drives
            -- the toggle: pressing the bound key flips/holds the toggle state.
            Items["Toggle"]:Connect("MouseButton2Down", function()
                if not Toggle._RightClickKeybind then
                    Toggle._RightClickKeybind = Toggle:Keybind({
                        Default = Enum.KeyCode.Backspace,  -- internal lib alias for "None"
                        Mode = "Toggle",
                        Callback = function(state)
                            Toggle:Set(state == true)
                        end,
                    })
                end
                local kb = Toggle._RightClickKeybind
                if kb then
                    if kb.SetOpen then kb:SetOpen(true) end
                    if kb.StartPicking then kb:StartPicking() end
                end
            end)

            Library:Connect(Items["Toggle"].Instance:GetPropertyChangedSignal("AbsoluteSize"), UpdateToggleLayout)
            Library:Connect(Items["SubElements"].Instance:GetPropertyChangedSignal("AbsoluteSize"), UpdateToggleLayout)
            task.defer(UpdateToggleLayout)

            Toggle:Set(Toggle.Default, Toggle.SkipInitialCallback)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle 
        end

        Library.Sections.Button = function(self, Data)
            Data = Data or { }

            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Button",
                Callback = Data.Callback or Data.callback or function() end
            }

            local Items = { } do 
                Items["Button"] = Instances:Create("TextButton", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 30),
                    Selectable = false,
                    Active = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Button.Name,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Instances:Create("UICorner", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Stroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://117716971575946",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -6, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})                
            end 

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:Press()
                local ActiveLibrary = Library
                if type(ActiveLibrary) ~= "table" or ActiveLibrary.Unloading or ActiveLibrary.Unloaded then
                    return
                end

                -- Press feedback: stroke flash + UIScale punch (cheap, 1 tween cada)
                Items["Stroke"]:ChangeItemTheme({Color = "Accent"})
                Items["Stroke"]:Tween(nil, {Color = ActiveLibrary.Theme.Accent})

                local PressScale = Items["Button"].Instance:FindFirstChildOfClass("UIScale")
                if not PressScale then
                    PressScale = Instance.new("UIScale")
                    PressScale.Parent = Items["Button"].Instance
                end
                PressScale.Scale = 0.96
                TweenService:Create(PressScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()

                task.wait(0.1)

                if ActiveLibrary.Unloading or ActiveLibrary.Unloaded then
                    return
                end

                ActiveLibrary:SafeCall(Button.Callback)
                Items["Stroke"]:ChangeItemTheme({Color = "Outline"})
                Items["Stroke"]:Tween(nil, {Color = ActiveLibrary.Theme.Outline})
            end

            -- Hover feedback: stroke acende sutilmente
            Items["Button"]:Connect("MouseEnter", function()
                Items["Button"]:Tween(TweenInfo.new(0.15), {BackgroundColor3 = Library.Theme["Accent"]:Lerp(Library.Theme["Element"], 0.85)})
            end)
            Items["Button"]:Connect("MouseLeave", function()
                Items["Button"]:Tween(TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme["Element"]})
            end)

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return Button
        end

        Library.Sections.Slider = function(self, Data)
            Data = Data or { }

            local Slider = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Slider",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Min = Data.Min or Data.min or 0,
                Default = Data.Default or Data.default or 0,
                Max = Data.Max or Data.max or 100,
                Suffix = Data.Suffix or Data.suffix or "",
                Decimals = Data.Decimals or Data.decimals or 1,
                Callback = Data.Callback or Data.callback or function() end,

                Value = 0,
                Sliding = false
            }

            local Items = { } do 
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 42),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                -- Adaptive: bar mais alta no mobile pra hit area maior (touch-friendly).
                -- PC mantém 9px (preciso com mouse). Mobile 24px (gordura do dedo).
                local _isMobileSlider = Library:IsMobileClient()
                local _sliderBarY = _isMobileSlider and 24 or 9

                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    Active = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2.new(1, -40, 0.5, 0),
                    Size = UDim2.new(0, 200, 0, _sliderBarY),
                    Selectable = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Instances:Create("UICorner", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(0.6000000238418579, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Glow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Dragger"] = Instances:Create("Frame", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2.new(1, -4, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(0, 13, 0, 13),
                    BorderSizePixel = 0
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Glow2"] = Instances:Create("ImageLabel", {
                    Parent = Items["Dragger"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.800000011920929,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = "50%",
                    Size = UDim2.new(0, 0, 0, 15),
                    AnchorPoint = Vector2New(1, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})                
            end

            function Slider:Get()
                return Slider.Value 
            end

            local ReservedValueWidth = 0

            local function GetSliderDisplayText(Value)
                return StringFormat("%s%s", Library:Round(Value, Slider.Decimals), Slider.Suffix)
            end

            local function RefreshReservedValueWidth()
                local CurrentText = Items["Value"].Instance.Text
                local Width = 0
                local Samples = {
                    Slider.Min,
                    Slider.Max,
                    Slider.Default,
                    Slider.Value
                }

                for _, Sample in next, Samples do
                    if Sample ~= nil then
                        Items["Value"].Instance.Text = GetSliderDisplayText(Sample)
                        Width = math.max(Width, Items["Value"].Instance.TextBounds.X)
                    end
                end

                Items["Value"].Instance.Text = CurrentText
                ReservedValueWidth = MathFloor(math.max(Width + 4, 32))
                Items["Value"].Instance.Size = UDim2FromOffset(ReservedValueWidth, 15)
            end

            local function UpdateSliderLayout()
                local SliderWidth = Items["Slider"].Instance.AbsoluteSize.X
                if SliderWidth <= 0 then
                    return
                end

                local TextWidth = MathFloor(math.max(Items["Text"].Instance.AbsoluteSize.X, Items["Text"].Instance.TextBounds.X))
                local ValueWidth = ReservedValueWidth > 0 and ReservedValueWidth or MathFloor(math.max(Items["Value"].Instance.AbsoluteSize.X, Items["Value"].Instance.TextBounds.X))
                local InlineGap = 12
                local MinimumTrackWidth = 110

                local InlineTrackWidth = SliderWidth - TextWidth - ValueWidth - (InlineGap * 2)
                local UseStackedLayout = InlineTrackWidth < MinimumTrackWidth

                if UseStackedLayout then
                    Items["Slider"].Instance.Size = UDim2.new(1, 0, 0, 42)

                    Items["Text"].Instance.AnchorPoint = Vector2New(0, 0)
                    Items["Text"].Instance.Position = UDim2.new(0, 0, 0, 0)

                    Items["Value"].Instance.AnchorPoint = Vector2New(1, 0)
                    Items["Value"].Instance.Position = UDim2.new(1, 0, 0, 0)

                    Items["RealSlider"].Instance.AnchorPoint = Vector2New(0, 0)
                    Items["RealSlider"].Instance.Position = UDim2FromOffset(0, 28)
                    Items["RealSlider"].Instance.Size = UDim2.new(1, 0, 0, 9)
                else
                    local TrackX = TextWidth + InlineGap
                    local TrackWidth = math.max(MinimumTrackWidth, InlineTrackWidth)

                    Items["Slider"].Instance.Size = UDim2.new(1, 0, 0, 20)

                    Items["Text"].Instance.AnchorPoint = Vector2New(0, 0.5)
                    Items["Text"].Instance.Position = UDim2.new(0, 0, 0.5, 0)

                    Items["Value"].Instance.AnchorPoint = Vector2New(1, 0.5)
                    Items["Value"].Instance.Position = UDim2.new(1, 0, 0.5, 0)

                    Items["RealSlider"].Instance.AnchorPoint = Vector2New(0, 0.5)
                    Items["RealSlider"].Instance.Position = UDim2.new(0, TrackX, 0.5, 0)
                    Items["RealSlider"].Instance.Size = UDim2FromOffset(TrackWidth, 9)
                end
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:Set(Value)
                -- Stale autoload configs can pass a table here (e.g. a flag
                -- name that used to belong to a multi-select dropdown and
                -- now belongs to a slider). Coerce or fall back to Default
                -- so the entire config load doesn't blow up on one bad key.
                if type(Value) ~= "number" then
                    Value = tonumber(Value) or Slider.Default or Slider.Min
                end
                Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
                Library.Flags[Slider.Flag] = Slider.Value

                Items["Value"].Instance.Text = GetSliderDisplayText(Slider.Value)

                Items["Accent"]:Tween(TweenInfo.new(Library.Tween.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})

                if Slider.Callback then 
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            local InputChanged 
            
            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                        local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                        Slider:Set(Value)
                    end
                end
            end)

            RefreshReservedValueWidth()
            Library:Connect(Items["Slider"].Instance:GetPropertyChangedSignal("AbsoluteSize"), UpdateSliderLayout)
            task.defer(UpdateSliderLayout)

            if Slider.Default then
                Slider:Set(Slider.Default)
            end

            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return Slider 
        end

        Library.Sections.Dropdown = function(self, Data)
            Data = Data or { }

            local Dropdown = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Dropdown",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Items = Data.Items or Data.items or { "One", "Two", "Three" },
                Default = Data.Default or Data.default or nil,
                Callback = Data.Callback or Data.callback or function() end,
                Multi = Data.Multi or Data.multi or false,
                SearchThreshold = Data.SearchThreshold or Data.searchthreshold or 6,

                Value = { },
                Options = { },
                IsOpen = false
            }

            local Items = { } do 
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 52),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 1),
                    Position = UDim2.new(1, 0, 1, 0),
                    Size = UDim2.new(0, 200, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Instances:Create("UICorner", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Items["Stroke"] = Instances:Create("UIStroke", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = "--",
                    Size = UDim2.new(1, -40, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextWrapped = false,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Text"],
                    Rotation = 270,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://72690112230014",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})
                
                Instances:Create("Frame", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2.new(1, -32, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})       
                
                Items["OptionHolder"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    Active = true,
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    ZIndex = 4,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})

                Items["OptionHolderBlocker"] = Instances:Create("TextButton", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Active = true,
                    Selectable = false,
                    AutoButtonColor = false,
                    Text = "",
                    ZIndex = 4,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 14
                })

                Instances:Create("UICorner", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 18)
                })

                Items["OptionHolderStroke"] = Instances:Create("UIStroke", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["PanelDivider"] = Instances:Create("Frame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    ZIndex = 5,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Position = UDim2FromOffset(0, 12),
                    Size = UDim2.new(0, 1, 1, -24),
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["PanelTopDivider"] = Instances:Create("Frame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    ZIndex = 5,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Position = UDim2FromOffset(20, 48),
                    Size = UDim2.new(1, -40, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})

                Items["PanelHeader"] = Instances:Create("Frame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    ZIndex = 5,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Position = UDim2FromOffset(18, 68),
                    Size = UDim2.new(1, -36, 0, 46),
                    BorderSizePixel = 0
                })

                Items["PanelTitle"] = Instances:Create("TextLabel", {
                    Parent = Items["PanelHeader"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    Text = Dropdown.Name,
                    ZIndex = 5,
                    Size = UDim2.new(1, 0, 0, 18),
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 18
                }):AddToTheme({TextColor3 = 'Text'})

                Items["PanelValue"] = Instances:Create("TextLabel", {
                    Parent = Items["PanelHeader"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.45,
                    Text = "Select an option",
                    ZIndex = 5,
                    Position = UDim2FromOffset(0, 24),
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14
                }):AddToTheme({TextColor3 = 'Text'})

                Items["OptionList"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 0,
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    ZIndex = 5,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Position = UDim2FromOffset(18, 126),
                    Size = UDim2.new(1, -36, 1, -144),
                    BorderSizePixel = 0
                }):AddToTheme({ScrollBarImageColor3 = 'Accent'})

                Items["SearchFrame"] = Instances:Create("Frame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Visible = false,
                    ZIndex = 5,
                    BackgroundColor3 = Library.Theme["Element"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Position = UDim2FromOffset(18, 126),
                    Size = UDim2.new(1, -36, 0, 32),
                    BorderSizePixel = 0
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Instances:Create("UICorner", {
                    Parent = Items["SearchFrame"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })

                Instances:Create("UIStroke", {
                    Parent = Items["SearchFrame"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["SearchIcon"] = Instances:Create("ImageLabel", {
                    Parent = Items["SearchFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = "rbxassetid://6031154871",
                    ImageTransparency = 0.4,
                    ZIndex = 6,
                    Position = UDim2FromOffset(10, 8),
                    Size = UDim2FromOffset(14, 14),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Text'})

                Items["SearchBox"] = Instances:Create("TextBox", {
                    Parent = Items["SearchFrame"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    PlaceholderColor3 = Library.Theme["Text"],
                    TextTransparency = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    PlaceholderText = "Search option",
                    Text = "",
                    ClearTextOnFocus = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 6,
                    Position = UDim2FromOffset(32, 0),
                    Size = UDim2.new(1, -42, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 15
                }):AddToTheme({TextColor3 = 'Text'})

                Items["OptionsLayout"] = Instances:Create("UIListLayout", {
                    Parent = Items["OptionList"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["OptionsPadding"] = Instances:Create("UIPadding", {
                    Parent = Items["OptionList"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 4)
                })
            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            local function UpdateDropdownLayout()
                local DropdownWidth = Items["Dropdown"].Instance.AbsoluteSize.X
                if DropdownWidth <= 0 then
                    return
                end

                local TextWidth = MathFloor(math.max(Items["Text"].Instance.AbsoluteSize.X, Items["Text"].Instance.TextBounds.X))
                local InlineGap = 12
                local MinimumFieldWidth = 135
                local InlineFieldWidth = DropdownWidth - TextWidth - InlineGap
                local UseStackedLayout = InlineFieldWidth < MinimumFieldWidth

                if UseStackedLayout then
                    Items["Dropdown"].Instance.Size = UDim2.new(1, 0, 0, 52)

                    Items["Text"].Instance.AnchorPoint = Vector2New(0, 0)
                    Items["Text"].Instance.Position = UDim2.new(0, 0, 0, 0)

                    Items["RealDropdown"].Instance.AnchorPoint = Vector2New(0, 1)
                    Items["RealDropdown"].Instance.Position = UDim2.new(0, 0, 1, 0)
                    Items["RealDropdown"].Instance.Size = UDim2.new(1, 0, 0, 30)
                else
                    local FieldWidth = math.max(MinimumFieldWidth, InlineFieldWidth)

                    Items["Dropdown"].Instance.Size = UDim2.new(1, 0, 0, 30)

                    Items["Text"].Instance.AnchorPoint = Vector2New(0, 0.5)
                    Items["Text"].Instance.Position = UDim2.new(0, 0, 0.5, 0)

                    Items["RealDropdown"].Instance.AnchorPoint = Vector2New(1, 1)
                    Items["RealDropdown"].Instance.Position = UDim2.new(1, 0, 1, 0)
                    Items["RealDropdown"].Instance.Size = UDim2FromOffset(FieldWidth, 30)
                end
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            local DrawerWidth = InstanceNew("NumberValue")
            DrawerWidth.Value = 0
            local DrawerOffset = InstanceNew("NumberValue")
            DrawerOffset.Value = 0
            local OpenDrawerTweenInfo = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local CloseDrawerTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local ArrowTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            local TransitionId = 0
            local WidthTween
            local OffsetTween

            local function GetOptionHolderWidth()
                local ContentWidth = Dropdown.Window.Items["ContentShell"].Instance.AbsoluteSize.X
                if ContentWidth <= 0 then
                    return 340
                end

                local TargetWidth = MathClamp(MathFloor(ContentWidth * 0.42), 300, 430)
                return math.max(0, math.min(TargetWidth, ContentWidth))
            end

            local function UpdateOptionHolderFrame()
                Items["OptionHolder"].Instance.Position = UDim2.new(1, DrawerOffset.Value, 0, 0)
                Items["OptionHolder"].Instance.Size = UDim2.new(0, MathFloor(DrawerWidth.Value), 1, 0)
            end

            local function GetOptionCount()
                local Count = 0

                for _ in Dropdown.Options do
                    Count += 1
                end

                return Count
            end

            local function UpdatePanelLayout()
                local HasSearch = Items["SearchFrame"].Instance.Visible
                local SearchHeight = HasSearch and 32 or 0
                local SearchGap = HasSearch and 12 or 0
                local ListTop = 126 + SearchHeight + SearchGap

                Items["OptionList"].Instance.Position = UDim2FromOffset(18, ListTop)
                Items["OptionList"].Instance.Size = UDim2.new(1, -36, 1, -(ListTop + 18))
            end

            local function ApplyOptionFilter()
                local Query = StringLower(Items["SearchBox"].Instance.Text or "")
                local HasQuery = StringLen(Query) > 0

                for _, OptionData in Dropdown.Options do
                    local Matches = (not HasQuery) or (StringFind(StringLower(OptionData.Name), Query, 1, true) ~= nil)
                    OptionData.Button.Instance.Visible = Matches
                end
            end

            local function UpdateSearchVisibility()
                local ShouldShowSearch = GetOptionCount() >= Dropdown.SearchThreshold
                Items["SearchFrame"].Instance.Visible = ShouldShowSearch

                if not ShouldShowSearch and Items["SearchBox"].Instance.Text ~= "" then
                    Items["SearchBox"].Instance.Text = ""
                end

                UpdatePanelLayout()
                ApplyOptionFilter()
            end

            local function UpdatePanelValue()
                local ValueText = "Select an option"

                if Dropdown.Multi then
                    if type(Dropdown.Value) == "table" and #Dropdown.Value > 0 then
                        ValueText = TableConcat(Dropdown.Value, ", ")
                    end
                elseif Dropdown.Value ~= nil and type(Dropdown.Value) ~= "table" then
                    -- Guard contra Value ser a tabela inicial { } em single-mode
                    -- (sem isso aparece "table: 0xADDR" quando Default é nil).
                    ValueText = tostring(Dropdown.Value)
                end

                Items["PanelValue"].Instance.Text = ValueText
            end

            function Dropdown:SetOpen(Bool)
                if Dropdown.IsOpen == Bool and Items["OptionHolder"].Instance.Visible == Bool then
                    return
                end

                TransitionId += 1
                local CurrentTransition = TransitionId
                Dropdown.IsOpen = Bool

                if WidthTween then
                    WidthTween:Cancel()
                    WidthTween = nil
                end

                if OffsetTween then
                    OffsetTween:Cancel()
                    OffsetTween = nil
                end

                if Dropdown.IsOpen then 
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"].Instance.Parent = Dropdown.Window.Items["ContentShell"].Instance
                    Items["Stroke"]:ChangeItemTheme({Color = "Accent"})
                    Items["Stroke"]:Tween(nil, {Color = Library.Theme.Accent})
                    Items["Icon"]:Tween(ArrowTweenInfo, {
                        Rotation = 90
                    })

                    DrawerWidth.Value = 0
                    DrawerOffset.Value = 0
                    UpdatePanelValue()
                    UpdateOptionHolderFrame()

                    WidthTween = TweenService:Create(DrawerWidth, OpenDrawerTweenInfo, {
                        Value = GetOptionHolderWidth()
                    })
                    OffsetTween = TweenService:Create(DrawerOffset, OpenDrawerTweenInfo, {
                        Value = 0
                    })
                    WidthTween:Play()
                    OffsetTween:Play()

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Dropdown and not Dropdown.Section.IsSettings then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end

                    Items["Stroke"]:ChangeItemTheme({Color = "Outline"})
                    Items["Stroke"]:Tween(nil, {Color = Library.Theme.Outline})
                    Items["Icon"]:Tween(ArrowTweenInfo, {
                        Rotation = 270
                    })

                    WidthTween = TweenService:Create(DrawerWidth, CloseDrawerTweenInfo, {
                        Value = 0
                    })
                    OffsetTween = TweenService:Create(DrawerOffset, CloseDrawerTweenInfo, {
                        Value = 0
                    })
                    WidthTween:Play()
                    OffsetTween:Play()
                end

                WidthTween.Completed:Connect(function()
                    if CurrentTransition ~= TransitionId then
                        return
                    end

                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen

                    if not Dropdown.IsOpen then
                        Items["OptionHolder"].Instance.Parent = Library.UnusedHolder.Instance
                        DrawerWidth.Value = 0
                        DrawerOffset.Value = 0
                    else
                        Items["OptionHolder"].Instance.Parent = Dropdown.Window.Items["ContentShell"].Instance
                    end
                end)
            end

            function Dropdown:Set(Option)
                if Dropdown.Multi then
                    if type(Option) ~= "table" then
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]

                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true
                        OptionData:Toggle("Active")
                    end

                    -- Mantém placeholder "--" quando nada está selecionado em vez de string vazia
                    Items["Value"].Instance.Text = #Option > 0 and TableConcat(Option, ", ") or "--"
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = Option
                end

                if Dropdown.Callback then   
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                UpdatePanelValue()
                task.defer(UpdateDropdownLayout)
            end

            function Dropdown:Add(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["OptionList"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 34),
                    ZIndex = 6,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    TextSize = 14,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})

                Instances:Create("UICorner", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                local OptionLiner = Instances:Create("Frame", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 3, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 7,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                local OptionGlow = Instances:Create("ImageLabel", {
                    Parent = OptionLiner.Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 25, 1, 25),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    ZIndex = 6,
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = RectNew(Vector2New(21, 21), Vector2New(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Instances:Create("UICorner", {
                    Parent = OptionLiner.Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                
                local OptionText = Instances:Create("TextLabel", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    TextTransparency = 0.5,
                    Text = Option,
                    ZIndex = 7,
                    Size = UDim2.new(1, -20, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                local OptionData = {
                    Button = OptionButton,
                    Name = Option,
                    Liner = OptionLiner,
                    Glow = OptionGlow,
                    Text = OptionText,
                    Selected = false
                }
                
                function OptionData:Toggle(Value)
                    if Value == "Active" then
                        OptionData.Button:Tween(nil, {BackgroundTransparency = 0})
                        OptionData.Liner:Tween(nil, {BackgroundTransparency = 0, Size = UDim2.new(0, 3, 1, 0)})
                        OptionData.Text:Tween(nil, {Position = UDim2.new(0, 12, 0.5 ,0), TextTransparency = 0})
                    else
                        OptionData.Button:Tween(nil, {BackgroundTransparency = 1})
                        OptionData.Liner:Tween(nil, {BackgroundTransparency = 1, Size = UDim2.new(0, 3, 0, 0)})
                        OptionData.Text:Tween(nil, {Position = UDim2.new(0, 0, 0.5 ,0), TextTransparency = 0.5})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Dropdown.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    if Dropdown.Callback then
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end

                    UpdatePanelValue()
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                UpdateSearchVisibility()
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button:Clean()
                    Dropdown.Options[Option] = nil
                    UpdateSearchVisibility()
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dropdown.IsOpen then
                        if Library:IsMouseOverFrame(Items["RealDropdown"]) then
                            return
                        end

                        if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                            return
                        end

                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Library:Connect(Dropdown.Window.Items["ContentShell"].Instance:GetPropertyChangedSignal("AbsoluteSize"), function()
                if Dropdown.IsOpen then
                    DrawerWidth.Value = GetOptionHolderWidth()
                    UpdateOptionHolderFrame()
                end

                UpdatePanelLayout()
            end)

            Library:Connect(Items["SearchBox"].Instance:GetPropertyChangedSignal("Text"), ApplyOptionFilter)
            Library:Connect(Items["Dropdown"].Instance:GetPropertyChangedSignal("AbsoluteSize"), UpdateDropdownLayout)
            Library:Connect(Items["Text"].Instance:GetPropertyChangedSignal("AbsoluteSize"), UpdateDropdownLayout)
            Library:Connect(DrawerWidth:GetPropertyChangedSignal("Value"), UpdateOptionHolderFrame)
            Library:Connect(DrawerOffset:GetPropertyChangedSignal("Value"), UpdateOptionHolderFrame)
            task.defer(UpdateDropdownLayout)
            task.defer(UpdatePanelValue)
            task.defer(UpdateSearchVisibility)

            for Index, Value in Dropdown.Items do 
                Dropdown:Add(Value)
            end

            if Dropdown.Default then 
                Dropdown:Set(Dropdown.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown
        end

        Library.Sections.Label = function(self, Name)
            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Name or "Label"
            }

            local Items = { } do 
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Label.Name,
                    AnchorPoint = Vector2New(0, 0),
                    Size = UDim2.new(1, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
            end

            local function UpdateLabelLayout()
                local LabelWidth = Items["Label"].Instance.AbsoluteSize.X
                if LabelWidth <= 0 then
                    return
                end

                local SubElementsWidth = MathFloor(math.max(Items["SubElements"].Instance.AbsoluteSize.X, 0))
                local Gap = SubElementsWidth > 0 and 8 or 0
                local TextWidth = math.max(LabelWidth - SubElementsWidth - Gap, 0)

                Items["Text"].Instance.Size = UDim2FromOffset(TextWidth, 0)

                local TextHeight = MathFloor(math.max(Items["Text"].Instance.TextBounds.Y, 15))
                local Height = math.max(TextHeight, 20)
                local TextY = TextHeight > 15 and 0 or MathFloor((Height - 15) / 2)

                Items["Text"].Instance.Position = UDim2FromOffset(0, TextY)
                Items["SubElements"].Instance.Size = UDim2.new(0, 0, 0, Height)
                Items["Label"].Instance.Size = UDim2.new(1, 0, 0, Height)
            end

            function Label:SetText(Text)
                Text = tostring(Text)
                Items["Text"].Instance.Text = Text
                task.defer(UpdateLabelLayout)
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or false
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Name = Label.Name,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Library:Connect(Items["Label"].Instance:GetPropertyChangedSignal("AbsoluteSize"), UpdateLabelLayout)
            Library:Connect(Items["SubElements"].Instance:GetPropertyChangedSignal("AbsoluteSize"), UpdateLabelLayout)
            Library:Connect(Items["Text"].Instance:GetPropertyChangedSignal("TextBounds"), UpdateLabelLayout)
            task.defer(UpdateLabelLayout)

            return Label
        end

        Library.Sections.Textbox = function(self, Data)
            Data = Data or { }

            local Textbox = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Textbox",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,
                Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
                Numeric = Data.Numeric or Data.numeric or false,
                Finished = Data.Finished or Data.finished or false,
                MaxLength = Data.MaxLength or Data.maxlength or Data.maxLength,

                Value = ""
            }

            local Items = { } do 
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 30),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Textbox.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2.new(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 16
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    Active = true,
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Size = UDim2FromOffset(180, 30),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Selectable = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Instances:Create("UIPadding", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
                
                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    -- Active+Selectable MUST be true on the TextBox itself or
                    -- click-to-focus and keyboard input never fire on mobile
                    -- (and on PC the cursor wouldn't appear after clicking).
                    Active = true,
                    Selectable = true,
                    TextTransparency = 0,
                    AnchorPoint = Vector2New(0, 0.5),
                    PlaceholderColor3 = FromRGB(133, 139, 143),
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 16,
                    Size = UDim2.new(1, 0, 0, 15),
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    CursorPosition = -1,
                    BorderSizePixel = 0,
                    ClearTextOnFocus = false,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left
                }):AddToTheme({TextColor3 = 'Text'})
            end
            
            local function UpdateTextboxLayout()
                local TextboxWidth = Items["Textbox"].Instance.AbsoluteSize.X
                if TextboxWidth <= 0 then
                    return
                end

                local TitleWidth = MathFloor(math.max(Items["Text"].Instance.TextBounds.X, 0))
                local Gap = 12
                local MinInputWidth = 120
                local AvailableWidth = TextboxWidth - TitleWidth - Gap
                local UseStackedLayout = AvailableWidth < MinInputWidth

                if UseStackedLayout then
                    local InputWidth = math.max(TextboxWidth, 0)

                    Items["Text"].Instance.AnchorPoint = Vector2New(0, 0)
                    Items["Text"].Instance.Position = UDim2FromOffset(0, 0)
                    Items["Background"].Instance.AnchorPoint = Vector2New(1, 1)
                    Items["Background"].Instance.Position = UDim2.new(1, 0, 1, 0)
                    Items["Background"].Instance.Size = UDim2FromOffset(InputWidth, 30)
                    Items["Textbox"].Instance.Size = UDim2.new(1, 0, 0, 56)
                else
                    local InputWidth = math.min(math.max(AvailableWidth, MinInputWidth), 220)

                    Items["Text"].Instance.AnchorPoint = Vector2New(0, 0.5)
                    Items["Text"].Instance.Position = UDim2.new(0, 0, 0.5, 0)
                    Items["Background"].Instance.AnchorPoint = Vector2New(1, 0.5)
                    Items["Background"].Instance.Position = UDim2.new(1, 0, 0.5, 0)
                    Items["Background"].Instance.Size = UDim2FromOffset(InputWidth, 30)
                    Items["Textbox"].Instance.Size = UDim2.new(1, 0, 0, 30)
                end
            end

            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:Set(Value)
                Value = tostring(Value or "")

                if Textbox.MaxLength and Textbox.MaxLength > 0 and StringLen(Value) > Textbox.MaxLength then
                    Value = Value:sub(1, Textbox.MaxLength)
                end

                if Textbox.Numeric then
                    if (not tonumber(Value)) and StringLen(Value) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value
                task.defer(UpdateTextboxLayout)

                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, Value)
                end
            end

            local function ClampLiveTextboxText()
                if not Textbox.MaxLength or Textbox.MaxLength <= 0 then
                    return
                end

                local CurrentText = Items["Input"].Instance.Text
                if StringLen(CurrentText) <= Textbox.MaxLength then
                    return
                end

                local ClampedText = CurrentText:sub(1, Textbox.MaxLength)
                local CursorPosition = Items["Input"].Instance.CursorPosition

                Items["Input"].Instance.Text = ClampedText

                if CursorPosition > 0 then
                    Items["Input"].Instance.CursorPosition = math.min(CursorPosition, Textbox.MaxLength + 1)
                end
            end

            Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), ClampLiveTextboxText)

            if Textbox.Finished then 
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            Library:Connect(Items["Textbox"].Instance:GetPropertyChangedSignal("AbsoluteSize"), UpdateTextboxLayout)
            Library:Connect(Items["Text"].Instance:GetPropertyChangedSignal("TextBounds"), UpdateTextboxLayout)
            task.defer(UpdateTextboxLayout)

            if Textbox.Default then
                Textbox:Set(Textbox.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox
        end
    end

    Library.CreateSettingsPage = function(self, Window, Watermark)
        local SettingsPage = Window:Page({
            Name = "Settings",
            Icon = "rbxassetid://128742673777519",
            Category = "Settings"
        })

        do
            local function GetWindowKeybindList()
                return rawget(Window, "KeybindList") or rawget(Window, "BindList")
            end

            local function EnsureWindowKeybindList()
                local WindowKeybindList = GetWindowKeybindList()

                if type(WindowKeybindList) == "table" then
                    return WindowKeybindList
                end

                if type(Window.CreateKeybindList) == "function" then
                    WindowKeybindList = Window:CreateKeybindList({
                        Visible = true
                    })
                end

                return WindowKeybindList
            end

            Library:RegisterIgnoredFlags({
                "Configs",
                "ConfigName",
                "Settings_AutoExec",
                "Settings_KeybindListVisible",
                "Settings_MenuKeybind"
            })

            local InterfaceSection = SettingsPage:Section({Name = "Interface", Icon = "keyboard", Side = 2})
            local MenuBindLabel = InterfaceSection:Label("Menu Bind")

            MenuBindLabel:Keybind({
                Flag = "Settings_MenuKeybind",
                Default = Library.MenuKeybind,
                Mode = "Toggle",
                Callback = function()
                    local Current = Library.Flags["Settings_MenuKeybind"]
                    local CurrentKey = type(Current) == "table" and Current.Key or nil

                    if type(CurrentKey) ~= "string" or CurrentKey == "" or Library.MenuKeybind == CurrentKey then
                        return
                    end

                    local Success = Library:SetMenuKeybind(CurrentKey)
                    if Success and Window and Window.Notification then
                        Window:Notification("Interface", "menu bind = " .. Library:GetMenuKeybindDisplay(CurrentKey), 2)
                    end
                end
            })

            local ExistingWindowKeybindList = GetWindowKeybindList()

            InterfaceSection:Toggle({
                Name = "Keybind List",
                Flag = "Settings_KeybindListVisible",
                Default = type(ExistingWindowKeybindList) == "table" and ExistingWindowKeybindList.Visible ~= false or false,
                SkipInitialCallback = true,
                Callback = function(Value)
                    local WindowKeybindList = Value and EnsureWindowKeybindList() or GetWindowKeybindList()

                    if type(WindowKeybindList) == "table" then
                        WindowKeybindList:SetVisibility(Value)
                    end
                end
            })

            local ThemingSection = SettingsPage:Section({Name = "Theming", Icon = "rbxassetid://73803440257131", Side = 2})

            do
                -- Dropdown de presets: aplica todas as cores de uma vez
                local presetNames = {}
                for name in pairs(Library.Themes or {}) do
                    table.insert(presetNames, name)
                end
                table.sort(presetNames)

                local colorpickerHandles = {}  -- Index → colorpicker (pra atualizar visual)

                ThemingSection:Dropdown({
                    Name = "Preset",
                    Flag = "ThemingPreset",
                    Items = presetNames,
                    Default = Library.CurrentThemeName or "Preset",
                    Callback = function(Value)
                        if Library:ApplyThemePreset(Value) then
                            -- Atualiza os colorpickers visualmente pra refletir o novo tema
                            for Index, picker in pairs(colorpickerHandles) do
                                local newColor = Library.Theme[Index]
                                if newColor and picker.Set then
                                    pcall(picker.Set, picker, newColor)
                                end
                            end
                        end
                    end
                })

                -- Background image: textbox pra Asset ID ou URL
                ThemingSection:Textbox({
                    Name = "Background Image",
                    Flag = "BackgroundImage",
                    Placeholder = "Asset ID or rbxassetid://N",
                    Finished = true,
                    Callback = function(Text)
                        Library:SetBackgroundImage(Text, Library.BackgroundTransparency or 0.5)
                    end
                })

                ThemingSection:Slider({
                    Name = "Background Transparency",
                    Flag = "BackgroundTransparency",
                    Min = 0, Max = 1, Default = 0.5, Decimals = 0.05,
                    Callback = function(Value)
                        Library.BackgroundTransparency = Value
                        local mainFrame = Library.Holder and Library.Holder.Instance
                        local bg = mainFrame and mainFrame:FindFirstChild("DzBL_BackgroundImage")
                        if bg then bg.ImageTransparency = Value end
                    end
                })

                -- Colorpickers individuais (cada cor do tema)
                for Index, Value in Library.Theme do
                    local picker = ThemingSection:Label(Index):Colorpicker({
                        Flag = Index.."_ThemingThing",
                        Default = Value,
                        Alpha = 0,
                        Callback = function(Value)
                            Library.Theme[Index] = Value
                            Library:ChangeTheme(Index, Value)
                        end
                    })
                    colorpickerHandles[Index] = picker
                end
            end

            local ConfigsSection = SettingsPage:Section({Name = "Configs", Icon = "rbxassetid://74885853379841", Side = 1}) do
                local ConfigName
                local ConfigSelected
                local AutoloadLabel
                local ConfigsDropdown

                local function NotifySettings(Text, Duration, Title)
                    if Window and Window.Notification then
                        Window:Notification(Title or "Settings", Text, Duration)
                    else
                        Library:Notification(Title or "Settings", Text, Duration)
                    end
                end

                -- Backwards-compat helpers for the rest of the section. Status
                -- info now flows through notifications + the AutoloadLabel only.
                local function SetConfigStatus(Text) end
                local function SetConfigFeedback(Text, Duration, Title)
                    NotifySettings(Text, Duration, Title)
                end

                local function UpdateAutoloadStatus()
                    if not AutoloadLabel then return end
                    local Name = Library:GetAutoloadConfigName()
                    if Name and Name ~= "" then
                        AutoloadLabel:SetText("Autoload • " .. Name)
                    else
                        AutoloadLabel:SetText("Autoload • off")
                    end
                end

                local function RefreshConfigs(Preferred)
                    local List = Library:RefreshConfigsList(ConfigsDropdown)

                    if Preferred and TableFind(List, Preferred) then
                        ConfigSelected = Preferred
                    elseif ConfigSelected and TableFind(List, ConfigSelected) then
                        ConfigSelected = ConfigSelected
                    else
                        ConfigSelected = List[1] or nil
                    end

                    if ConfigsDropdown.Set then
                        ConfigsDropdown:Set(ConfigSelected or "")
                    end

                    return List
                end

                -- Compact one-liner showing the current autoload. Updates on
                -- Set/Clear Autoload. No "Status: ready" clutter.
                AutoloadLabel = ConfigsSection:Label("Autoload • off")

                ConfigsSection:Toggle({
                    Name = "Auto Exec",
                    Flag = "Settings_AutoExec",
                    Default = Library:GetAutoExecEnabled(),
                    SkipInitialCallback = true,
                    Callback = function(Value)
                        local Success, Result = Library:SetAutoExecEnabled(Value)

                        if Value then
                            if Success then
                                SetConfigFeedback("auto exec armed", 3, "Auto Exec")
                            else
                                SetConfigFeedback(Result == "queue or source unavailable" and "auto exec enabled, but source is missing" or tostring(Result), 4, "Auto Exec")
                            end
                        else
                            SetConfigFeedback("auto exec disabled", 2, "Auto Exec")
                        end
                    end
                })

                ConfigsDropdown = ConfigsSection:Dropdown({
                    Name = "Configs", 
                    Flag = "Configs",
                    Items = { }, 
                    Multi = false,
                    MaxSize = 120,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })
    
                ConfigsSection:Textbox({
                    Name = "Config name",
                    Placeholder = "Config name",
                    Flag = "ConfigName",
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })
    
                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                        if not ConfigName or ConfigName == "" then
                            SetConfigFeedback("enter a config name", 3, "Configs")
                            return
                        end

                        local Path = Library.Folders.Configs .. "/" .. ConfigName .. ".json"
                        local OkIsFile, Exists = pcall(isfile, Path)
                        if not OkIsFile then
                            SetConfigFeedback("storage unavailable", 3, "Configs")
                            return
                        end

                        if Exists then
                            SetConfigFeedback("config already exists", 3, "Configs")
                            return
                        end

                        local OkWrite, Result = pcall(writefile, Path, Library:GetConfig())
                        if OkWrite then
                            RefreshConfigs(ConfigName)
                            SetConfigFeedback("created " .. ConfigName, 3, "Configs")
                        else
                            SetConfigFeedback("failed to create config", 3, "Configs")
                            warn("[dzlibv3] create config failed:", Result)
                        end
                    end
                })
    
                ConfigsSection:Button({
                    Name = "Load",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            SetConfigFeedback("select a config first", 3, "Configs")
                            return
                        end

                        local Path = Library.Folders.Configs .. "/" .. ConfigSelected .. ".json"
                        local OkRead, RawConfig = pcall(readfile, Path)
                        if not OkRead or type(RawConfig) ~= "string" then
                            SetConfigFeedback("failed to read config", 3, "Configs")
                            return
                        end

                        local Success = Library:LoadConfig(RawConfig)
                        if Success then
                            SetConfigFeedback("loaded " .. ConfigSelected, 3, "Configs")
                        else
                            SetConfigFeedback("failed to load config", 3, "Configs")
                        end
                    end
                })
    
                ConfigsSection:Button({
                    Name = "Save",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            SetConfigFeedback("select a config first", 3, "Configs")
                            return
                        end

                        local OkWrite, Result = pcall(writefile, Library.Folders.Configs .. "/" .. ConfigSelected .. ".json", Library:GetConfig())
                        if OkWrite then
                            SetConfigFeedback("saved " .. ConfigSelected, 3, "Configs")
                        else
                            SetConfigFeedback("failed to save config", 3, "Configs")
                            warn("[dzlibv3] save config failed:", Result)
                        end
                    end
                })
    
                ConfigsSection:Button({
                    Name = "Delete",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            SetConfigFeedback("select a config first", 3, "Configs")
                            return
                        end

                        local Name = ConfigSelected
                        local OkDelete, Result = pcall(delfile, Library.Folders.Configs .. "/" .. Name .. ".json")
                        if not OkDelete then
                            SetConfigFeedback("failed to delete config", 3, "Configs")
                            warn("[dzlibv3] delete config failed:", Result)
                            return
                        end

                        if Library:GetAutoloadConfigName() == Name then
                            Library:ClearAutoloadConfig()
                        end

                        RefreshConfigs()
                        UpdateAutoloadStatus()
                        SetConfigFeedback("deleted " .. Name, 3, "Configs")
                    end
                })

                ConfigsSection:Button({
                    Name = "Set Autoload",
                    Callback = function()
                        if not ConfigSelected or ConfigSelected == "" then
                            SetConfigFeedback("select a config first", 3, "Autoload")
                            return
                        end

                        local Success, Result = Library:SetAutoloadConfig(ConfigSelected)
                        if Success then
                            UpdateAutoloadStatus()
                            SetConfigFeedback("autoload = " .. ConfigSelected, 3, "Autoload")
                        else
                            SetConfigFeedback("failed to set autoload", 3, "Autoload")
                            warn("[dzlibv3] set autoload failed:", Result)
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Clear Autoload",
                    Callback = function()
                        local Success, Result = Library:ClearAutoloadConfig()
                        UpdateAutoloadStatus()

                        if Success then
                            SetConfigFeedback("autoload cleared", 3, "Autoload")
                        else
                            SetConfigFeedback(Result == "autoload not set" and "autoload already empty" or "failed to clear autoload", 3, "Autoload")
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Refresh",
                    Callback = function()
                        RefreshConfigs()
                        UpdateAutoloadStatus()
                        SetConfigFeedback("config list refreshed", 2, "Configs")
                    end
                })

                RefreshConfigs()
                UpdateAutoloadStatus()
            end
        end

        return SettingsPage
    end
end



-- loadstring-friendly wrappers / aliases
Library.LucideIconsUrl = "https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"
Library.IconPacks = Library.IconPacks or {}
Library.ActiveIconPack = "lucide"

function Library:LoadIconPack(Url, PackName)
    PackName = PackName or "lucide"

    if self.IconPacks[PackName] then
        return self.IconPacks[PackName]
    end

    local Success, Result = pcall(function()
        local Source = game:HttpGet(Url)
        local Chunk = loadstring(Source)
        if not Chunk then
            return {}
        end

        local Icons = Chunk()
        if type(Icons) ~= "table" then
            return {}
        end

        return Icons
    end)

    self.IconPacks[PackName] = Success and Result or {}
    return self.IconPacks[PackName]
end

function Library:SetIconPack(PackName)
    self.ActiveIconPack = PackName or "lucide"
end

function Library:GetIconPack(PackName)
    PackName = PackName or self.ActiveIconPack or "lucide"

    if not self.IconPacks[PackName] then
        if PackName == "lucide" then
            self:LoadIconPack(self.LucideIconsUrl, "lucide")
        else
            self.IconPacks[PackName] = {}
        end
    end

    return self.IconPacks[PackName] or {}
end

function Library:ResolveIcon(Icon, PackName)
    if not Icon or Icon == "" then
        return Icon
    end

    if typeof(Icon) ~= "string" then
        return Icon
    end

    if Icon:match("^rbxassetid://") or Icon:match("^https?://") then
        return Icon
    end

    local Icons = self:GetIconPack(PackName)
    return Icons[string.lower(Icon)] or Icon
end

local OriginalWindowFunction = Library.Window
Library.Window = function(self, Data)
    Data = Data or {}

    if Data.HideLogo or Data.hidelogo or Data.Logo == false or Data.logo == false then
        Data.Logo = nil
        Data.logo = nil
    end

    Data.Logo = self:ResolveIcon(Data.Logo)
    Data.logo = self:ResolveIcon(Data.logo)

    if Data.WatermarkLogo then
        Data.WatermarkLogo = self:ResolveIcon(Data.WatermarkLogo)
    end

    if Data.ToggleButtonIcon then
        Data.ToggleButtonIcon = self:ResolveIcon(Data.ToggleButtonIcon)
    end

    if Data.togglebuttonicon then
        Data.togglebuttonicon = self:ResolveIcon(Data.togglebuttonicon)
    end

    if Data.MobileButtonIcon then
        Data.MobileButtonIcon = self:ResolveIcon(Data.MobileButtonIcon)
    end

    if Data.mobilebuttonicon then
        Data.mobilebuttonicon = self:ResolveIcon(Data.mobilebuttonicon)
    end

    return OriginalWindowFunction(self, Data)
end

local OriginalSectionFunction = Library.Pages.Section
Library.Pages.Section = function(self, Data)
    Data = Data or {}
    Data.Icon = Library:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon
    return OriginalSectionFunction(self, Data)
end

Library.CreateWindow = function(self, Data)
    Data = Data or {}

    local Window = self:Window(Data)
    local Watermark
    local ToggleButton
    local KeybindList

    if Data.WatermarkEnabled then
        Watermark = self:Watermark(
            Data.WatermarkText or Data.Name or "Window",
            self:ResolveIcon(Data.WatermarkLogo or Data.Logo)
        )
        Window.Watermark = Watermark
    end

    local ToggleButtonRequested = Data.ToggleButtonEnabled or Data.togglebuttonenabled or Data.ShowToggleButton or Data.showtogglebutton or Data.MobileButtonEnabled or Data.mobilebuttonenabled
    local ToggleButtonMobileOnly = Data.ToggleButtonMobileOnly

    if ToggleButtonMobileOnly == nil then
        ToggleButtonMobileOnly = Data.togglebuttonmobileonly
    end

    if ToggleButtonMobileOnly == nil then
        ToggleButtonMobileOnly = true
    end

    if ToggleButtonRequested and (not ToggleButtonMobileOnly or self:IsMobileClient()) then
        ToggleButton = self:ToggleButton(Window, {
            Icon = Data.ToggleButtonIcon or Data.togglebuttonicon or Data.MobileButtonIcon or Data.mobilebuttonicon or self:ResolveIcon(Data.Logo) or self.DefaultToggleButtonIcon or "rbxassetid://10723407389",
            Position = Data.ToggleButtonPosition or Data.togglebuttonposition,
            Size = Data.ToggleButtonSize or Data.togglebuttonsize
        })
        Window.ToggleButton = ToggleButton
        Window.MenuButton = ToggleButton
    end

    function Window:CreateKeybindList(ListData)
        local ExistingKeybindList = rawget(Window, "KeybindList") or rawget(Window, "BindList")

        if type(ExistingKeybindList) == "table" then
            return ExistingKeybindList
        end

        Window.KeybindList = Library:KeybindList(Window, ListData or { })
        Window.BindList = Window.KeybindList

        return Window.KeybindList
    end

    if Data.KeybindListEnabled or Data.keybindlistenabled or Data.BindListEnabled or Data.bindlistenabled then
        KeybindList = Window:CreateKeybindList({
            Title = Data.KeybindListTitle or Data.keybindlisttitle,
            Position = Data.KeybindListPosition or Data.keybindlistposition,
            Width = Data.KeybindListWidth or Data.keybindlistwidth,
            Visible = Data.KeybindListVisible ~= false and Data.keybindlistvisible ~= false
        })
    end

    function Window:Notification(Title, Description, Duration)

        if not Description and Title then
            Description = Title
            Title = Window.Name or "DZ HUB"
        end

        return Library:Notification(Title or Window.Name or "DZ HUB", Description, Duration)
    end

    function Window:Notify(Description, Duration)
        return Library:Notification(Window.Name or "DZ HUB", Description, Duration)
    end

    Window._AutoSettingsEnabled = Data.SettingsTabEnabled and true or false
    Window._AutoSettingsWatermark = Watermark

    local OriginalPage = Window.Page
    local CreatingSettings = false

    local function ReorderTabs()
        local Order = 1

        for _, Value in Window.Pages do
            if Value ~= Window.SettingsPage and Value.Items and Value.Items["Inactive"] then
                Value.Items["Inactive"].Instance.LayoutOrder = Order
                Order += 1
            end
        end

        if Window.SettingsPage and Window.SettingsPage.Items and Window.SettingsPage.Items["Inactive"] then
            Window.SettingsPage.Items["Inactive"].Instance.LayoutOrder = 999999
        end
    end

    function Window:CreateSettingsPage()
        if Window.SettingsPage or CreatingSettings then
            ReorderTabs()
            return Window.SettingsPage
        end

        CreatingSettings = true
        Window.SettingsPage = Library:CreateSettingsPage(Window, Window._AutoSettingsWatermark)
        CreatingSettings = false

        ReorderTabs()
        return Window.SettingsPage
    end

    Window.AddSettingsPage = Window.CreateSettingsPage
    Window.CreateSettings = Window.CreateSettingsPage

    -- ════════════════════════════════════════════════════════════════════
    -- CreateInfoPage(opts) — gera tab "Info" com layout rico:
    --   • Welcome banner (avatar + nome + tags)
    --   • Stats row (4 cards: Players, FPS, Ping, Uptime — auto-update)
    --   • Credits + Key Info grid (2 cols)
    --
    -- opts = {
    --   tabName    = "Info" (default),
    --   tabIcon    = "info" (default),
    --   subtitle   = "#1 Script Hub",       -- texto secundário do banner
    --   tags       = {"Premium", "Free"},   -- chips no canto direito
    --   credits    = {"Lead Dev: @x", ...}, -- linhas do Credits card
    --   keyInfo    = {"Game: x", ...},      -- linhas do Key Info card
    --   onCopyDiscord = function() end,     -- opcional — adiciona botão
    -- }
    -- Retorna: page, statHandles {players, fps, ping, uptime} (cada um tem :SetText)
    -- ════════════════════════════════════════════════════════════════════
    function Window:CreateInfoPage(opts)
        opts = opts or {}
        local UDim2New = UDim2.new
        local UDimNew = UDim.new
        local Vector2New = Vector2.new
        local page = Window:AddTab({
            Name = opts.tabName or "Info",
            Icon = opts.tabIcon or "info",
        })
        if not page then return nil, nil end

        -- Esconde o layout default de colunas (vamos usar layout próprio)
        local pageInst = page.Items.Page.Instance
        local columnsInst = page.Items.Columns and page.Items.Columns.Instance
        if columnsInst then columnsInst.Visible = false end

        -- Helper: cria instance e registra no ThemeItems da Library, pra
        -- que mudar o tema automaticamente atualize as cores.
        local function themed(class, parent, props, themeMap)
            local inst = Instance.new(class)
            for k, v in pairs(props or {}) do
                inst[k] = v
            end
            inst.Parent = parent
            if themeMap then
                pcall(function() Library:AddToTheme(inst, themeMap) end)
            end
            return inst
        end

        -- Container custom dentro da Page
        local container = Instance.new("Frame")
        container.Name = "InfoContainer"
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, -20, 0, 0)
        container.Position = UDim2.new(0, 10, 0, 0)
        container.AutomaticSize = Enum.AutomaticSize.Y
        container.Parent = pageInst

        local containerLayout = Instance.new("UIListLayout")
        containerLayout.Padding = UDimNew(0, 12)
        containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        containerLayout.Parent = container

        Instance.new("UIPadding", container).PaddingTop = UDimNew(0, 14)

        -- Helper: cria card padrão (background themed + corner + stroke themed)
        local function makeCard(parent, layoutOrder, height)
            local card = themed("Frame", parent, {
                Name = "Card",
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, height or 0),
                AutomaticSize = (height and Enum.AutomaticSize.None) or Enum.AutomaticSize.Y,
                LayoutOrder = layoutOrder,
            }, { BackgroundColor3 = "Element" })

            themed("UICorner", card, { CornerRadius = UDimNew(0, 8) })
            themed("UIStroke", card, {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            }, { Color = "Outline" })

            return card
        end

        local LocalPlayer = game:GetService("Players").LocalPlayer

        -- ── Welcome Banner ─────────────────────────────────────────────
        local banner = makeCard(container, 1, 88)
        local bannerPadding = Instance.new("UIPadding", banner)
        bannerPadding.PaddingLeft = UDimNew(0, 16)
        bannerPadding.PaddingRight = UDimNew(0, 16)
        bannerPadding.PaddingTop = UDimNew(0, 14)
        bannerPadding.PaddingBottom = UDimNew(0, 14)

        -- Avatar circular (themed)
        local avatar = themed("ImageLabel", banner, {
            Size = UDim2.new(0, 60, 0, 60),
            AnchorPoint = Vector2New(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            BorderSizePixel = 0,
        }, { BackgroundColor3 = "Background" })
        themed("UICorner", avatar, { CornerRadius = UDimNew(1, 0) })
        pcall(function()
            local thumb = game:GetService("Players"):GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size150x150
            )
            avatar.Image = thumb
        end)

        -- "Welcome back," small label
        themed("TextLabel", banner, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 76, 0, 8),
            Size = UDim2.new(0, 200, 0, 16),
            Text = "Welcome back,",
            TextXAlignment = Enum.TextXAlignment.Left,
            FontFace = Library.Font,
            TextSize = 14,
        }, { TextColor3 = "TextMuted" })

        -- Username big
        themed("TextLabel", banner, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 76, 0, 24),
            Size = UDim2.new(0, 300, 0, 24),
            Text = LocalPlayer.DisplayName or LocalPlayer.Name,
            TextXAlignment = Enum.TextXAlignment.Left,
            FontFace = Library.Font,
            TextSize = 22,
        }, { TextColor3 = "Text" })

        -- Subtitle
        if opts.subtitle then
            themed("TextLabel", banner, {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 76, 0, 50),
                Size = UDim2.new(0, 300, 0, 14),
                Text = opts.subtitle,
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Library.Font,
                TextSize = 12,
            }, { TextColor3 = "TextMuted" })
        end

        -- Tags (chips na direita)
        if type(opts.tags) == "table" and #opts.tags > 0 then
            local tagsHolder = Instance.new("Frame")
            tagsHolder.BackgroundTransparency = 1
            tagsHolder.AnchorPoint = Vector2New(1, 0.5)
            tagsHolder.Position = UDim2.new(1, 0, 0.5, 0)
            tagsHolder.Size = UDim2.new(0, 0, 0, 28)
            tagsHolder.AutomaticSize = Enum.AutomaticSize.X
            tagsHolder.Parent = banner

            local tagsLayout = Instance.new("UIListLayout")
            tagsLayout.FillDirection = Enum.FillDirection.Horizontal
            tagsLayout.Padding = UDimNew(0, 6)
            tagsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            tagsLayout.Parent = tagsHolder

            for i, tagText in ipairs(opts.tags) do
                local themeBg = (i == 1) and "Accent" or "Background"
                local chip = themed("Frame", tagsHolder, {
                    Size = UDim2.new(0, 0, 0, 24),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BorderSizePixel = 0,
                }, { BackgroundColor3 = themeBg })
                themed("UICorner", chip, { CornerRadius = UDimNew(1, 0) })
                local pad = Instance.new("UIPadding", chip)
                pad.PaddingLeft = UDimNew(0, 12)
                pad.PaddingRight = UDimNew(0, 12)
                if i == 1 then
                    -- Tag accent: texto preto fixo (lê melhor em accent)
                    themed("TextLabel", chip, {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 0, 1, 0),
                        AutomaticSize = Enum.AutomaticSize.X,
                        Text = tagText,
                        TextColor3 = Color3.new(0, 0, 0),
                        FontFace = Library.Font,
                        TextSize = 12,
                    })
                else
                    themed("TextLabel", chip, {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 0, 1, 0),
                        AutomaticSize = Enum.AutomaticSize.X,
                        Text = tagText,
                        FontFace = Library.Font,
                        TextSize = 12,
                    }, { TextColor3 = "Text" })
                end
            end
        end

        -- ── Stats Row (4 cards) ────────────────────────────────────────
        local statsRow = Instance.new("Frame")
        statsRow.BackgroundTransparency = 1
        statsRow.Size = UDim2.new(1, 0, 0, 80)
        statsRow.LayoutOrder = 2
        statsRow.Parent = container

        local statsLayout = Instance.new("UIListLayout")
        statsLayout.FillDirection = Enum.FillDirection.Horizontal
        statsLayout.Padding = UDimNew(0, 10)
        statsLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
        statsLayout.Parent = statsRow

        local function makeStatCard(label, defaultValue)
            local card = themed("Frame", statsRow, {
                Size = UDim2.new(0.25, -8, 1, 0),
                BorderSizePixel = 0,
            }, { BackgroundColor3 = "Element" })
            themed("UICorner", card, { CornerRadius = UDimNew(0, 8) })
            themed("UIStroke", card, {}, { Color = "Outline" })

            local pad = Instance.new("UIPadding", card)
            pad.PaddingLeft = UDimNew(0, 14)
            pad.PaddingRight = UDimNew(0, 14)
            pad.PaddingTop = UDimNew(0, 12)
            pad.PaddingBottom = UDimNew(0, 12)

            themed("TextLabel", card, {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                Text = label,
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Library.Font,
                TextSize = 13,
            }, { TextColor3 = "TextMuted" })

            local val = themed("TextLabel", card, {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 22),
                Size = UDim2.new(1, 0, 0, 28),
                Text = defaultValue or "--",
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Library.Font,
                TextSize = 24,
            }, { TextColor3 = "Text" })

            return {
                Instance = val,
                SetText = function(_, t) val.Text = tostring(t or "--") end,
            }
        end

        local statHandles = {
            players = makeStatCard("Players", "--"),
            fps = makeStatCard("FPS", "--"),
            ping = makeStatCard("Ping", "--"),
            uptime = makeStatCard("Uptime", "0s"),
        }

        -- ── Bottom Grid (Credits + Key Info) ──────────────────────────
        local bottomRow = Instance.new("Frame")
        bottomRow.BackgroundTransparency = 1
        bottomRow.Size = UDim2.new(1, 0, 0, 0)
        bottomRow.AutomaticSize = Enum.AutomaticSize.Y
        bottomRow.LayoutOrder = 3
        bottomRow.Parent = container

        local bottomLayout = Instance.new("UIListLayout")
        bottomLayout.FillDirection = Enum.FillDirection.Horizontal
        bottomLayout.Padding = UDimNew(0, 10)
        bottomLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
        bottomLayout.Parent = bottomRow

        local function makeInfoCard(title, lines)
            local card = themed("Frame", bottomRow, {
                Size = UDim2.new(0.5, -5, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0,
            }, { BackgroundColor3 = "Element" })
            themed("UICorner", card, { CornerRadius = UDimNew(0, 8) })
            themed("UIStroke", card, {}, { Color = "Outline" })

            local pad = Instance.new("UIPadding", card)
            pad.PaddingLeft = UDimNew(0, 14)
            pad.PaddingRight = UDimNew(0, 14)
            pad.PaddingTop = UDimNew(0, 12)
            pad.PaddingBottom = UDimNew(0, 12)

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDimNew(0, 6)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Parent = card

            themed("TextLabel", card, {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 18),
                Text = title,
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace = Library.Font,
                TextSize = 16,
                LayoutOrder = 0,
            }, { TextColor3 = "Text" })

            for i, line in ipairs(lines or {}) do
                themed("TextLabel", card, {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    Text = tostring(line),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    FontFace = Library.Font,
                    TextSize = 13,
                    LayoutOrder = i,
                }, { TextColor3 = "TextMuted" })
            end

            return card
        end

        makeInfoCard("Credits", opts.credits or {})
        local keyInfoCard = makeInfoCard(opts.keyInfoTitle or "Game Info", opts.keyInfo or {})

        -- Optional: Copy Discord button — usa o Library.Sections.Button REAL
        -- via fake-section apontando pro card de Game Info. Assim herda todas
        -- as animações (hover lerp, UIScale punch, stroke flash) do botão
        -- original sem precisar replicar manualmente.
        if type(opts.onCopyDiscord) == "function" then
            -- Wrapper que mimica a interface esperada pelo Library.Sections.Button:
            -- self.Items["Content"].Instance = parent onde o botão será criado
            local fakeSection = {
                Window = Window,
                Page = page,
                Section = nil,
                Items = {
                    ["Content"] = { Instance = keyInfoCard },
                },
            }
            local btn = Library.Sections.Button(fakeSection, {
                Name = "Copy Discord",
                Callback = opts.onCopyDiscord,
            })
            -- Reordena pro fim do card (depois do título e linhas)
            if btn and btn.Items and btn.Items["Button"] then
                btn.Items["Button"].Instance.LayoutOrder = 99
            end
        end

        return page, statHandles
    end

    local function EnsureSettings()
        if not Window._AutoSettingsEnabled then
            ReorderTabs()
            return
        end

        Window:CreateSettingsPage()
    end

    local function WrappedPage(_, TabData)
        TabData = TabData or {}
        TabData.Icon = Library:ResolveIcon(TabData.Icon or TabData.icon)
        TabData.icon = TabData.Icon

        local Page = OriginalPage(Window, TabData)

        EnsureSettings()
        ReorderTabs()

        return Page
    end

    Window.Page = WrappedPage
    Window.CreateTab = WrappedPage
    Window.CreatePage = WrappedPage

    -- ── Loading overlay control ──────────────────────────────────────
    -- Hide the overlay once the host script finishes adding tabs/sections.
    -- Either call Window:HideLoading() manually for instant feedback, or
    -- the auto-fallback kicks in after 4s.
    function Window:HideLoading()
        if not Window.IsLoading then return end
        Window.IsLoading = false
        local items = Window.Items
        if not items or not items["LoadingOverlay"] then return end
        local TweenService = game:GetService("TweenService")
        local overlay = items["LoadingOverlay"].Instance
        local title   = items["LoadingTitle"]   and items["LoadingTitle"].Instance
        local sub     = items["LoadingSub"]     and items["LoadingSub"].Instance
        local logo    = items["LoadingLogo"]    and items["LoadingLogo"].Instance
        local info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        pcall(function()
            TweenService:Create(overlay, info, { BackgroundTransparency = 1 }):Play()
            if title then TweenService:Create(title, info, { TextTransparency = 1 }):Play() end
            if sub   then TweenService:Create(sub,   info, { TextTransparency = 1 }):Play() end
            if logo  then TweenService:Create(logo,  info, { ImageTransparency = 1 }):Play() end
        end)
        task.delay(0.4, function()
            pcall(function() overlay:Destroy() end)
        end)
    end

    -- Safety net: auto-hide after 4s if the host script never calls it
    task.delay(4, function()
        if Window.IsLoading then
            Window:HideLoading()
        end
    end)

    Library:ScheduleAutoload()

    return Window
end

Library.CreateTab = Library.Page
Library.Pages.CreateSection = Library.Pages.Section

Library.Sections.CreateButton = Library.Sections.Button
Library.Sections.CreateToggle = Library.Sections.Toggle
Library.Sections.CreateSlider = Library.Sections.Slider
Library.Sections.CreateDropdown = Library.Sections.Dropdown
Library.Sections.CreateTextbox = Library.Sections.Textbox
Library.Sections.CreateLabel = Library.Sections.Label

local function NormalizeNamedData(NameOrData, Icon)
    if type(NameOrData) == "table" then
        local Data = {}

        for Key, Value in next, NameOrData do
            Data[Key] = Value
        end

        if Data.Title and not (Data.Name or Data.name) then
            Data.Name = Data.Title
        end

        if Data.title and not (Data.Name or Data.name) then
            Data.Name = Data.title
        end

        if Icon and not (Data.Icon or Data.icon) then
            Data.Icon = Icon
        end

        return Data
    end

    local Data = {
        Name = NameOrData
    }

    if Icon ~= nil then
        Data.Icon = Icon
    end

    return Data
end

function Library:AddTab(NameOrData, Icon)
    local Data = NormalizeNamedData(NameOrData, Icon)
    Data.Icon = self:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon

    if self.CreateTab then
        return self:CreateTab(Data)
    end

    return self:Page(Data)
end

function Library.Pages:AddSection(NameOrData, Icon)
    local Data = NormalizeNamedData(NameOrData, Icon)
    Data.Icon = Library:ResolveIcon(Data.Icon or Data.icon)
    Data.icon = Data.Icon

    if self.CreateSection then
        return self:CreateSection(Data)
    end

    return self:Section(Data)
end

function Library.Sections:AddButton(NameOrData, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateButton(Data)
    end

    return self:CreateButton({
        Name = NameOrData,
        Callback = Callback
    })
end

function Library.Sections:AddToggle(NameOrData, FlagOrCallback, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateToggle(Data)
    end

    local RealCallback = type(FlagOrCallback) == "function" and FlagOrCallback or Callback

    return self:CreateToggle({
        Name = NameOrData,
        Flag = type(FlagOrCallback) == "string" and FlagOrCallback or nil,
        Default = Default,
        Callback = RealCallback
    })
end

function Library.Sections:AddSlider(NameOrData, Min, Max, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateSlider(Data)
    end

    return self:CreateSlider({
        Name = NameOrData,
        Min = Min,
        Max = Max,
        Default = Default,
        Callback = Callback
    })
end

function Library.Sections:AddDropdown(NameOrData, Items, Default, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateDropdown(Data)
    end

    return self:CreateDropdown({
        Name = NameOrData,
        Items = Items,
        Default = Default,
        Callback = Callback
    })
end

function Library.Sections:AddTextbox(NameOrData, Placeholder, Callback)
    if type(NameOrData) == "table" then
        local Data = NormalizeNamedData(NameOrData)
        return self:CreateTextbox(Data)
    end

    return self:CreateTextbox({
        Name = NameOrData,
        Placeholder = Placeholder,
        Callback = Callback
    })
end

function Library.Sections:AddLabel(TextOrData)
    if type(TextOrData) == "table" then
        local Data = NormalizeNamedData(TextOrData)
        return self:CreateLabel(Data.Name or Data.Text or Data.text or "Label")
    end

    return self:CreateLabel(TextOrData)
end

getgenv().Library = Library
return Library
