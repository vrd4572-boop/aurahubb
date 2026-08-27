-- ==========================================================
-- 👑 AURA HUB | PRO MULTIHACK v3.0 (MODERN CARD UI & COMBAT ENGINE)
-- Features: Modern Themed UI, Full Aimbot + Wallcheck + Deadzone + Triggerbot,
-- Native Highlight Chams + Pro Drawing ESP + Offscreen Arrows + Snaplines,
-- Search Bar, Keybinds, Sliders, Multi-Dropdowns, Toasts, World FX & Movement
-- ==========================================================

if getgenv().AuraHubUnload then pcall(getgenv().AuraHubUnload) end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ==========================================
-- 🎨 СИСТЕМА ТЕМ
-- ==========================================
local Themes = {
    ["Dark"] = {
        Name = "Dark Minimal",
        Background = Color3.fromRGB(13, 14, 18),
        Sidebar = Color3.fromRGB(18, 19, 25),
        Card = Color3.fromRGB(24, 25, 34),
        CardBorder = Color3.fromRGB(38, 40, 54),
        Accent = Color3.fromRGB(120, 85, 255),
        AccentGlow = Color3.fromRGB(140, 110, 255),
        TextPrimary = Color3.fromRGB(245, 245, 250),
        TextSecondary = Color3.fromRGB(140, 142, 160),
        Off = Color3.fromRGB(42, 44, 58),
        Success = Color3.fromRGB(60, 255, 120),
        Danger = Color3.fromRGB(255, 75, 95)
    },
    ["Cyberpunk"] = {
        Name = "Cyberpunk 2077",
        Background = Color3.fromRGB(10, 10, 15),
        Sidebar = Color3.fromRGB(16, 15, 24),
        Card = Color3.fromRGB(22, 20, 32),
        CardBorder = Color3.fromRGB(50, 45, 75),
        Accent = Color3.fromRGB(255, 220, 40),
        AccentGlow = Color3.fromRGB(255, 240, 100),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(170, 165, 195),
        Off = Color3.fromRGB(45, 40, 65),
        Success = Color3.fromRGB(0, 255, 200),
        Danger = Color3.fromRGB(255, 50, 100)
    },
    ["Rose"] = {
        Name = "Rose Tea",
        Background = Color3.fromRGB(18, 13, 18),
        Sidebar = Color3.fromRGB(25, 17, 24),
        Card = Color3.fromRGB(34, 23, 33),
        CardBorder = Color3.fromRGB(60, 40, 58),
        Accent = Color3.fromRGB(255, 110, 160),
        AccentGlow = Color3.fromRGB(255, 150, 190),
        TextPrimary = Color3.fromRGB(250, 240, 245),
        TextSecondary = Color3.fromRGB(170, 140, 160),
        Off = Color3.fromRGB(55, 38, 52),
        Success = Color3.fromRGB(100, 255, 180),
        Danger = Color3.fromRGB(255, 70, 90)
    },
    ["Midnight"] = {
        Name = "Midnight Ocean",
        Background = Color3.fromRGB(8, 14, 22),
        Sidebar = Color3.fromRGB(12, 20, 32),
        Card = Color3.fromRGB(16, 28, 44),
        CardBorder = Color3.fromRGB(28, 48, 74),
        Accent = Color3.fromRGB(0, 190, 255),
        AccentGlow = Color3.fromRGB(80, 220, 255),
        TextPrimary = Color3.fromRGB(240, 250, 255),
        TextSecondary = Color3.fromRGB(130, 165, 190),
        Off = Color3.fromRGB(30, 45, 65),
        Success = Color3.fromRGB(60, 255, 160),
        Danger = Color3.fromRGB(255, 80, 100)
    },
    ["Emerald"] = {
        Name = "Emerald Forest",
        Background = Color3.fromRGB(10, 16, 12),
        Sidebar = Color3.fromRGB(14, 24, 18),
        Card = Color3.fromRGB(19, 34, 25),
        CardBorder = Color3.fromRGB(32, 58, 42),
        Accent = Color3.fromRGB(46, 220, 130),
        AccentGlow = Color3.fromRGB(90, 255, 165),
        TextPrimary = Color3.fromRGB(240, 255, 245),
        TextSecondary = Color3.fromRGB(135, 175, 150),
        Off = Color3.fromRGB(30, 50, 38),
        Success = Color3.fromRGB(50, 255, 140),
        Danger = Color3.fromRGB(255, 80, 90)
    }
}

local CurrentThemeName = "Dark"
local CurrentTheme = Themes[CurrentThemeName]
local RegisteredThemeElements = {}
local RegisteredThemeSwitches = {}

local function RegisterElement(instance, property, themeKey)
    RegisteredThemeElements[#RegisteredThemeElements + 1] = {
        Instance = instance,
        Property = property,
        Key = themeKey
    }
    if CurrentTheme[themeKey] then
        instance[property] = CurrentTheme[themeKey]
    end
end

local function RegisterSwitch(switchBg, getState)
    RegisteredThemeSwitches[#RegisteredThemeSwitches + 1] = {
        Button = switchBg,
        GetState = getState
    }
end

local function ApplyTheme(themeKey)
    if not Themes[themeKey] then return end
    CurrentThemeName = themeKey
    CurrentTheme = Themes[themeKey]

    for _, entry in pairs(RegisteredThemeElements) do
        if entry.Instance and entry.Instance.Parent then
            local color = CurrentTheme[entry.Key]
            if color then
                TweenService:Create(entry.Instance, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    [entry.Property] = color
                }):Play()
            end
        end
    end

    for _, sw in pairs(RegisteredThemeSwitches) do
        if sw.Button and sw.Button.Parent then
            local state = sw.GetState()
            local targetColor = state and CurrentTheme.Accent or CurrentTheme.Off
            TweenService:Create(sw.Button, TweenInfo.new(0.2), { BackgroundColor3 = targetColor }):Play()
        end
    end
end

-- ==========================================
-- ⚙️ КОНФИГУРАЦИЯ
-- ==========================================
local Aura = {
    Config = {
        Theme = "Dark",
        AutoSave = true
    },
    Aimbot = {
        Enabled = false,
        Keybind = Enum.UserInputType.MouseButton2,
        Mode = "Head", -- Head, Torso, Hybrid, Closest
        Priority = "Crosshair", -- Crosshair, Distance, LowestHP
        FOV = 120,
        ShowFOV = false,
        Smooth = 4,
        OffsetY = 0,
        WallCheck = false,
        Deadzone = 4,
        Triggerbot = false,
        TriggerDelay = 50, -- ms
        TeamFilter = {} -- [TeamKey] = true
    },
    ESP = {
        Enabled = false,
        Chams = false, -- Native Highlight
        ChamsFillTrans = 0.5,
        ChamsOutlineTrans = 0.1,
        Boxes = false,
        Names = false,
        Health = false,
        Distance = false,
        Snaplines = false,
        SnaplineOrigin = "Bottom", -- Bottom, Center
        OffscreenArrows = false,
        ArrowRadius = 200,
        TeamColors = true
    },
    Movement = {
        SpeedOn = false,
        Speed = 24,
        Fly = false,
        FlySpeed = 60,
        InfJump = false,
        Noclip = false
    },
    Visuals = {
        Fullbright = false,
        NoFog = false,
        NoShadows = false,
        Neon = false,
        Plastic = false,
        FOV = 70
    },
    Crosshair = {
        Enabled = false,
        Size = 10,
        Gap = 4,
        Thickness = 2,
        Dot = true,
        Color = Color3.fromRGB(0, 255, 180)
    },
    UI = {
        Open = false,
        Drag = false
    }
}

-- Цвета каст (San Diego Border RP)
local TEAM_COLORS = {
    { key = "civilian",      name = "Civilian",      color = Color3.fromRGB(0, 230, 118)   },
    { key = "border patrol", name = "Border Patrol", color = Color3.fromRGB(255, 214, 0)   },
    { key = "bortac",        name = "BORTAC",        color = Color3.fromRGB(130, 160, 60)  },
    { key = "border",        name = "Border",        color = Color3.fromRGB(255, 214, 0)   },
    { key = "police",        name = "Police",        color = Color3.fromRGB(60, 140, 255)  },
    { key = "swat",          name = "SWAT",          color = Color3.fromRGB(40, 80, 220)   },
    { key = "coast guard",   name = "Coast Guard",   color = Color3.fromRGB(0, 200, 255)   },
    { key = "coast",         name = "Coast",         color = Color3.fromRGB(0, 200, 255)   },
    { key = "fbi",           name = "FBI",           color = Color3.fromRGB(235, 235, 235) },
    { key = "us army",       name = "US Army",       color = Color3.fromRGB(255, 140, 0)   },
    { key = "army",          name = "Army",          color = Color3.fromRGB(255, 140, 0)   }
}

local function GetTeamInfo(plr)
    local t = plr.Team
    if not t then return Color3.new(1,1,1), "No Team", "noteam" end
    local lname = t.Name:lower()
    for _, m in pairs(TEAM_COLORS) do
        if lname:find(m.key, 1, true) then
            return m.color, m.name, m.key
        end
    end
    local ok, c = pcall(function() return t.TeamColor.Color end)
    return (ok and c) or Color3.new(1,1,1), t.Name, lname
end

-- ==========================================
-- 📦 УПРАВЛЕНИЕ РЕСУРСАМИ & ВЫГРУЗКА
-- ==========================================
local Connections = {}
local DrawObjects = {}
local HighlightObjects = {}
local WorldParts = {}
local PartOrigMat = {}
local Unloaded = false

local LightingOrig = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
    ClockTime = Lighting.ClockTime
}

local function Conn(signal, fn)
    local c = signal:Connect(fn)
    Connections[#Connections + 1] = c
    return c
end

local function NewDraw(kind, props)
    if not Drawing then return nil end
    local d = Drawing.new(kind)
    for k, v in pairs(props or {}) do d[k] = v end
    DrawObjects[#DrawObjects + 1] = d
    return d
end

local function cacheWorld()
    WorldParts = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            WorldParts[#WorldParts + 1] = v
        end
    end
end
cacheWorld()

local function rememberMat(p)
    if PartOrigMat[p] == nil then PartOrigMat[p] = p.Material end
end

local function applyWorldFX()
    if Aura.Visuals.Neon then
        for _, p in pairs(WorldParts) do
            if p.Parent then rememberMat(p); p.Material = Enum.Material.Neon end
        end
    elseif Aura.Visuals.Plastic then
        for _, p in pairs(WorldParts) do
            if p.Parent then rememberMat(p); p.Material = Enum.Material.SmoothPlastic end
        end
    else
        for p, m in pairs(PartOrigMat) do
            if p.Parent then pcall(function() p.Material = m end) end
        end
        PartOrigMat = {}
    end
end

-- ==========================================
-- 🖥️ ИНИЦИАЛИЗАЦИЯ GUI
-- ==========================================
for _, g in pairs(LocalPlayer.PlayerGui:GetChildren()) do
    if g.Name == "AuraHub" or g.Name:match("^AuraDbg") then g:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AuraHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Контейнер для тостов (уведомлений)
local ToastContainer = Instance.new("Frame", ScreenGui)
ToastContainer.Size = UDim2.new(0, 280, 1, -20)
ToastContainer.Position = UDim2.new(1, -290, 0, 10)
ToastContainer.BackgroundTransparency = 1
local ToastList = Instance.new("UIListLayout", ToastContainer)
ToastList.HorizontalAlignment = Enum.HorizontalAlignment.Right
ToastList.VerticalAlignment = Enum.VerticalAlignment.Bottom
ToastList.Padding = UDim.new(0, 8)

local function Notify(title, message, duration, toastType)
    duration = duration or 3
    local card = Instance.new("Frame", ToastContainer)
    card.Size = UDim2.new(1, 0, 0, 0)
    card.BackgroundColor3 = CurrentTheme.Card
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = (toastType == "error" and CurrentTheme.Danger) or (toastType == "success" and CurrentTheme.Success) or CurrentTheme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.3

    local bar = Instance.new("Frame", card)
    bar.Size = UDim2.new(0, 4, 1, 0)
    bar.BackgroundColor3 = stroke.Color
    bar.BorderSizePixel = 0

    local tLbl = Instance.new("TextLabel", card)
    tLbl.Size = UDim2.new(1, -20, 0, 20)
    tLbl.Position = UDim2.new(0, 14, 0, 8)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 13
    tLbl.TextColor3 = CurrentTheme.TextPrimary
    tLbl.TextXAlignment = Enum.TextXAlignment.Left

    local mLbl = Instance.new("TextLabel", card)
    mLbl.Size = UDim2.new(1, -20, 0, 26)
    mLbl.Position = UDim2.new(0, 14, 0, 26)
    mLbl.BackgroundTransparency = 1
    mLbl.Text = message
    mLbl.Font = Enum.Font.Gotham
    mLbl.TextSize = 11
    mLbl.TextColor3 = CurrentTheme.TextSecondary
    mLbl.TextXAlignment = Enum.TextXAlignment.Left
    mLbl.TextWrapped = true

    TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 58) }):Play()

    task.delay(duration, function()
        if card and card.Parent then
            local t = TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1 })
            t:Play()
            t.Completed:Connect(function() card:Destroy() end)
        end
    end)
end

-- Плавающая кнопка открытия
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 48, 0, 48)
OpenBtn.Position = UDim2.new(0, 12, 0.5, -24)
OpenBtn.BackgroundColor3 = CurrentTheme.Sidebar
OpenBtn.Text = "🔮"
OpenBtn.TextSize = 22
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.AutoButtonColor = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 14)
RegisterElement(OpenBtn, "BackgroundColor3", "Sidebar")

local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Thickness = 1.5
RegisterElement(OpenStroke, "Color", "Accent")

-- Главное окно
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 720, 0, 480)
Main.Position = UDim2.new(0.5, -360, 0.5, -240)
Main.BackgroundColor3 = CurrentTheme.Background
Main.BorderSizePixel = 0
Main.Visible = false
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
RegisterElement(Main, "BackgroundColor3", "Background")

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.5
RegisterElement(MainStroke, "Color", "Accent")

local UIScale = Instance.new("UIScale", Main)
UIScale.Scale = 1

-- Титлбар
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = CurrentTheme.Sidebar
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 16)
RegisterElement(TitleBar, "BackgroundColor3", "Sidebar")

local TitleFix = Instance.new("Frame", TitleBar)
TitleFix.Size = UDim2.new(1, 0, 0, 16)
TitleFix.Position = UDim2.new(0, 0, 1, -16)
TitleFix.BackgroundColor3 = CurrentTheme.Sidebar
TitleFix.BorderSizePixel = 0
RegisterElement(TitleFix, "BackgroundColor3", "Sidebar")

local LogoLbl = Instance.new("TextLabel", TitleBar)
LogoLbl.Size = UDim2.new(0, 180, 1, 0)
LogoLbl.Position = UDim2.new(0, 16, 0, 0)
LogoLbl.BackgroundTransparency = 1
LogoLbl.Text = "AURA HUB"
LogoLbl.Font = Enum.Font.GothamBlack
LogoLbl.TextSize = 16
LogoLbl.TextXAlignment = Enum.TextXAlignment.Left
RegisterElement(LogoLbl, "TextColor3", "Accent")

local ExeTag = Instance.new("TextLabel", TitleBar)
ExeTag.Size = UDim2.new(0, 120, 1, 0)
ExeTag.Position = UDim2.new(0, 115, 0, 0)
ExeTag.BackgroundTransparency = 1
local exe = "Universal"
pcall(function() exe = identifyexecutor() or "Universal" end)
ExeTag.Text = "⚡ " .. exe
ExeTag.Font = Enum.Font.Gotham
ExeTag.TextSize = 11
RegisterElement(ExeTag, "TextColor3", "TextSecondary")

-- Поле поиска (Search Bar)
local SearchFrame = Instance.new("Frame", TitleBar)
SearchFrame.Size = UDim2.new(0, 220, 0, 28)
SearchFrame.Position = UDim2.new(0.5, -110, 0.5, -14)
SearchFrame.BackgroundColor3 = CurrentTheme.Card
SearchFrame.BorderSizePixel = 0
Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 8)
RegisterElement(SearchFrame, "BackgroundColor3", "Card")

local SearchIcon = Instance.new("TextLabel", SearchFrame)
SearchIcon.Size = UDim2.new(0, 26, 1, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextSize = 12
SearchIcon.Font = Enum.Font.Gotham

local SearchBox = Instance.new("TextBox", SearchFrame)
SearchBox.Size = UDim2.new(1, -32, 1, 0)
SearchBox.Position = UDim2.new(0, 28, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "Поиск по функциям..."
SearchBox.Text = ""
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.TextSize = 12
SearchBox.ClearTextOnFocus = false
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
RegisterElement(SearchBox, "TextColor3", "TextPrimary")
RegisterElement(SearchBox, "PlaceholderColor3", "TextSecondary")

-- Кнопки титлбара (Свернуть / Закрыть)
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -14)
CloseBtn.BackgroundColor3 = CurrentTheme.Card
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.AutoButtonColor = false
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
RegisterElement(CloseBtn, "BackgroundColor3", "Card")
RegisterElement(CloseBtn, "TextColor3", "Danger")

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -70, 0.5, -14)
MinBtn.BackgroundColor3 = CurrentTheme.Card
MinBtn.Text = "─"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 12
MinBtn.AutoButtonColor = false
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
RegisterElement(MinBtn, "BackgroundColor3", "Card")
RegisterElement(MinBtn, "TextColor3", "TextSecondary")

-- Сайдбар
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 180, 1, -44)
Sidebar.Position = UDim2.new(0, 0, 0, 44)
Sidebar.BackgroundColor3 = CurrentTheme.Sidebar
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 16)
RegisterElement(Sidebar, "BackgroundColor3", "Sidebar")

local SideFix = Instance.new("Frame", Sidebar)
SideFix.Size = UDim2.new(0, 16, 1, 0)
SideFix.Position = UDim2.new(1, -16, 0, 0)
SideFix.BackgroundColor3 = CurrentTheme.Sidebar
SideFix.BorderSizePixel = 0
RegisterElement(SideFix, "BackgroundColor3", "Sidebar")

local TabListFrame = Instance.new("ScrollingFrame", Sidebar)
TabListFrame.Size = UDim2.new(1, -16, 1, -16)
TabListFrame.Position = UDim2.new(0, 8, 0, 8)
TabListFrame.BackgroundTransparency = 1
TabListFrame.BorderSizePixel = 0
TabListFrame.ScrollBarThickness = 0
local TabList = Instance.new("UIListLayout", TabListFrame)
TabList.Padding = UDim.new(0, 6)

-- Контейнер контента
local ContentArea = Instance.new("Frame", Main)
ContentArea.Size = UDim2.new(1, -196, 1, -56)
ContentArea.Position = UDim2.new(0, 188, 0, 48)
ContentArea.BackgroundTransparency = 1

-- ==========================================
-- 🛠️ СИСТЕМА КОМПОНЕНТОВ UI
-- ==========================================
local Tabs = {}
local AllCards = {} -- { Card = frame, Title = string, Page = page }
local ActiveTabName = nil

local function setOpen(open)
    Aura.UI.Open = open
    if open then
        Main.Visible = true
        UIScale.Scale = 0.94
        TweenService:Create(UIScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    else
        local t = TweenService:Create(UIScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.94 })
        t:Play()
        task.delay(0.17, function()
            if not Aura.UI.Open and not Unloaded then
                Main.Visible = false
                UIScale.Scale = 1
            end
        end)
    end
end

OpenBtn.MouseButton1Click:Connect(function()
    setOpen(not Aura.UI.Open)
end)
MinBtn.MouseButton1Click:Connect(function()
    setOpen(false)
end)

local function CreateTab(name, icon)
    local btn = Instance.new("TextButton", TabListFrame)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = CurrentTheme.Card
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ClipsDescendants = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    RegisterElement(btn, "BackgroundColor3", "Card")

    local bar = Instance.new("Frame", btn)
    bar.Size = UDim2.new(0, 4, 1, -12)
    bar.Position = UDim2.new(0, 0, 0.5, -6)
    bar.BackgroundColor3 = CurrentTheme.Accent
    bar.BorderSizePixel = 0
    bar.BackgroundTransparency = 1
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    RegisterElement(bar, "BackgroundColor3", "Accent")

    local ic = Instance.new("TextLabel", btn)
    ic.Size = UDim2.new(0, 30, 1, 0)
    ic.Position = UDim2.new(0, 10, 0, 0)
    ic.BackgroundTransparency = 1
    ic.Text = icon
    ic.TextSize = 15
    ic.Font = Enum.Font.GothamBold
    ic.TextColor3 = CurrentTheme.TextSecondary
    RegisterElement(ic, "TextColor3", "TextSecondary")

    local lb = Instance.new("TextLabel", btn)
    lb.Size = UDim2.new(1, -45, 1, 0)
    lb.Position = UDim2.new(0, 42, 0, 0)
    lb.BackgroundTransparency = 1
    lb.Text = name
    lb.TextSize = 13
    lb.Font = Enum.Font.GothamBold
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.TextColor3 = CurrentTheme.TextSecondary
    RegisterElement(lb, "TextColor3", "TextSecondary")

    local page = Instance.new("ScrollingFrame", ContentArea)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = CurrentTheme.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8)

    Tabs[name] = { Btn = btn, Bar = bar, Icon = ic, Label = lb, Page = page }

    btn.MouseButton1Click:Connect(function()
        ActiveTabName = name
        for n, t in pairs(Tabs) do
            local sel = (n == name)
            t.Page.Visible = sel
            TweenService:Create(t.Bar, TweenInfo.new(0.2), { BackgroundTransparency = sel and 0 or 1 }):Play()
            TweenService:Create(t.Label, TweenInfo.new(0.2), { TextColor3 = sel and CurrentTheme.TextPrimary or CurrentTheme.TextSecondary }):Play()
            TweenService:Create(t.Icon, TweenInfo.new(0.2), { TextColor3 = sel and CurrentTheme.Accent or CurrentTheme.TextSecondary }):Play()
        end
    end)

    return page
end

-- Фильтрация через строку поиска
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBox.Text:lower():gsub("%s+", "")
    for _, item in pairs(AllCards) do
        if q == "" then
            item.Card.Visible = true
        else
            local match = item.Title:lower():gsub("%s+", ""):find(q, 1, true)
            item.Card.Visible = match ~= nil
        end
    end
end)

-- Базовая карточка
local function CreateBaseCard(parent, titleText, height)
    height = height or 46
    local Card = Instance.new("Frame", parent)
    Card.Size = UDim2.new(1, -6, 0, height)
    Card.BackgroundColor3 = CurrentTheme.Card
    Card.BorderSizePixel = 0
    Card.ClipsDescendants = true
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)
    RegisterElement(Card, "BackgroundColor3", "Card")

    local Stroke = Instance.new("UIStroke", Card)
    Stroke.Color = CurrentTheme.CardBorder
    Stroke.Thickness = 1
    RegisterElement(Stroke, "Color", "CardBorder")

    local Label = Instance.new("TextLabel", Card)
    Label.Size = UDim2.new(0.55, 0, 0, 46)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = titleText
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    RegisterElement(Label, "TextColor3", "TextPrimary")

    AllCards[#AllCards + 1] = { Card = Card, Title = titleText, Page = parent }
    return Card, Label
end

-- 1. TOGGLE (ПЕРЕКЛЮЧАТЕЛЬ)
local function CreateToggle(parent, labelText, defaultState, callback)
    local state = defaultState or false
    local Card, Label = CreateBaseCard(parent, labelText, 46)

    local SwitchBG = Instance.new("TextButton", Card)
    SwitchBG.Size = UDim2.new(0, 44, 0, 22)
    SwitchBG.Position = UDim2.new(1, -58, 0.5, -11)
    SwitchBG.Text = ""
    SwitchBG.AutoButtonColor = false
    SwitchBG.BorderSizePixel = 0
    SwitchBG.BackgroundColor3 = state and CurrentTheme.Accent or CurrentTheme.Off
    Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)
    RegisterSwitch(SwitchBG, function() return state end)

    local Circle = Instance.new("Frame", SwitchBG)
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    SwitchBG.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        local targetColor = state and CurrentTheme.Accent or CurrentTheme.Off

        TweenService:Create(Circle, TweenInfo.new(0.18, Enum.EasingStyle.Back), { Position = targetPos }):Play()
        TweenService:Create(SwitchBG, TweenInfo.new(0.18), { BackgroundColor3 = targetColor }):Play()

        callback(state)
    end)

    return Card
end

-- 2. SLIDER (СЛАЙДЕР С ВВОДОМ И КЛИКОМ)
local function CreateSlider(parent, labelText, min, max, defaultVal, step, unit, callback)
    step = step or 1
    unit = unit or ""
    local val = defaultVal or min
    local Card = CreateBaseCard(parent, labelText, 56)

    local ValBox = Instance.new("TextBox", Card)
    ValBox.Size = UDim2.new(0, 70, 0, 24)
    ValBox.Position = UDim2.new(1, -84, 0, 10)
    ValBox.BackgroundColor3 = CurrentTheme.Background
    ValBox.Text = tostring(val) .. unit
    ValBox.Font = Enum.Font.GothamBold
    ValBox.TextSize = 12
    ValBox.BorderSizePixel = 0
    Instance.new("UICorner", ValBox).CornerRadius = UDim.new(0, 6)
    RegisterElement(ValBox, "BackgroundColor3", "Background")
    RegisterElement(ValBox, "TextColor3", "Accent")

    local Track = Instance.new("TextButton", Card)
    Track.Size = UDim2.new(1, -28, 0, 8)
    Track.Position = UDim2.new(0, 14, 0, 38)
    Track.BackgroundColor3 = CurrentTheme.Off
    Track.Text = ""
    Track.AutoButtonColor = false
    Track.BorderSizePixel = 0
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)
    RegisterElement(Track, "BackgroundColor3", "Off")

    local Fill = Instance.new("Frame", Track)
    local pct = math.clamp((val - min) / (max - min), 0, 1)
    Fill.Size = UDim2.new(pct, 0, 1, 0)
    Fill.BackgroundColor3 = CurrentTheme.Accent
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    RegisterElement(Fill, "BackgroundColor3", "Accent")

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local raw = min + (max - min) * rel
        val = math.floor(raw / step + 0.5) * step
        Fill.Size = UDim2.new(rel, 0, 1, 0)
        ValBox.Text = tostring(val) .. unit
        callback(val)
    end

    Track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(i)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end
    end)

    ValBox.FocusLost:Connect(function()
        local num = tonumber(ValBox.Text:gsub("[^%d.-]", ""))
        if num then
            val = math.clamp(math.floor(num / step + 0.5) * step, min, max)
            local newRel = (val - min) / (max - min)
            Fill.Size = UDim2.new(newRel, 0, 1, 0)
            ValBox.Text = tostring(val) .. unit
            callback(val)
        else
            ValBox.Text = tostring(val) .. unit
        end
    end)

    return Card
end

-- 3. CYCLE BUTTON (ПЕРЕКЛЮЧАТЕЛЬ РЕЖИМОВ)
local function CreateCycleButton(parent, labelText, options, defaultIdx, callback)
    local idx = defaultIdx or 1
    local Card = CreateBaseCard(parent, labelText, 46)

    local Btn = Instance.new("TextButton", Card)
    Btn.Size = UDim2.new(0, 130, 0, 28)
    Btn.Position = UDim2.new(1, -144, 0.5, -14)
    Btn.BackgroundColor3 = CurrentTheme.Background
    Btn.Text = options[idx] or ""
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.AutoButtonColor = false
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    RegisterElement(Btn, "BackgroundColor3", "Background")
    RegisterElement(Btn, "TextColor3", "Accent")

    local bStroke = Instance.new("UIStroke", Btn)
    bStroke.Thickness = 1
    RegisterElement(bStroke, "Color", "Accent")

    Btn.MouseButton1Click:Connect(function()
        idx = (idx % #options) + 1
        Btn.Text = options[idx]
        local tInfo = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        Btn.Size = UDim2.new(0, 120, 0, 24)
        TweenService:Create(Btn, tInfo, { Size = UDim2.new(0, 130, 0, 28) }):Play()
        callback(idx, options[idx])
    end)

    return Card
end

-- 4. KEYBIND SELECTOR (ПРИВЯЗКА КЛАВИШ)
local function CreateKeybind(parent, labelText, defaultKey, callback)
    local curKey = defaultKey or Enum.UserInputType.MouseButton2
    local Card = CreateBaseCard(parent, labelText, 46)
    local binding = false

    local function formatKey(k)
        if typeof(k) == "EnumItem" then
            return k.Name:gsub("MouseButton", "M"):gsub("KeyCode.", "")
        end
        return tostring(k)
    end

    local Btn = Instance.new("TextButton", Card)
    Btn.Size = UDim2.new(0, 90, 0, 26)
    Btn.Position = UDim2.new(1, -104, 0.5, -13)
    Btn.BackgroundColor3 = CurrentTheme.Background
    Btn.Text = formatKey(curKey)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.AutoButtonColor = false
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    RegisterElement(Btn, "BackgroundColor3", "Background")
    RegisterElement(Btn, "TextColor3", "Accent")

    Btn.MouseButton1Click:Connect(function()
        binding = true
        Btn.Text = "..."
        Btn.TextColor3 = CurrentTheme.Danger
    end)

    Conn(UserInputService.InputBegan, function(i, gp)
        if not binding then return end
        if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode ~= Enum.KeyCode.Unknown then
            binding = false
            curKey = i.KeyCode
            Btn.Text = formatKey(curKey)
            Btn.TextColor3 = CurrentTheme.Accent
            callback(curKey)
        elseif i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.MouseButton2 or i.UserInputType == Enum.UserInputType.MouseButton3 then
            binding = false
            curKey = i.UserInputType
            Btn.Text = formatKey(curKey)
            Btn.TextColor3 = CurrentTheme.Accent
            callback(curKey)
        end
    end)

    return Card
end

-- 5. MULTI-DROPDOWN / TAGS (МУЛЬТИ-ВЫБОР КАСТ)
local function CreateMultiDropdown(parent, labelText, options, selectedTable, callback)
    local Card = Instance.new("Frame", parent)
    Card.Size = UDim2.new(1, -6, 0, 46)
    Card.BackgroundColor3 = CurrentTheme.Card
    Card.BorderSizePixel = 0
    Card.ClipsDescendants = true
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)
    RegisterElement(Card, "BackgroundColor3", "Card")

    local Stroke = Instance.new("UIStroke", Card)
    Stroke.Color = CurrentTheme.CardBorder
    Stroke.Thickness = 1
    RegisterElement(Stroke, "Color", "CardBorder")

    local Header = Instance.new("TextButton", Card)
    Header.Size = UDim2.new(1, 0, 0, 46)
    Header.BackgroundTransparency = 1
    Header.Text = ""

    local Label = Instance.new("TextLabel", Header)
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 14, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    RegisterElement(Label, "TextColor3", "TextPrimary")

    local Arrow = Instance.new("TextLabel", Header)
    Arrow.Size = UDim2.new(0, 30, 1, 0)
    Arrow.Position = UDim2.new(1, -40, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextSize = 11
    RegisterElement(Arrow, "TextColor3", "TextSecondary")

    local Grid = Instance.new("Frame", Card)
    Grid.Position = UDim2.new(0, 12, 0, 46)
    Grid.Size = UDim2.new(1, -24, 0, 0)
    Grid.BackgroundTransparency = 1
    local gLayout = Instance.new("UIGridLayout", Grid)
    gLayout.CellSize = UDim2.new(0.485, 0, 0, 28)
    gLayout.CellPadding = UDim2.new(0.03, 0, 0, 6)

    local expanded = false
    local rows = math.ceil(#options / 2)
    local targetHeight = 46 + (rows * 34) + 10

    for _, opt in pairs(options) do
        local tagBtn = Instance.new("TextButton", Grid)
        local isSel = selectedTable[opt] == true
        tagBtn.BackgroundColor3 = isSel and CurrentTheme.Accent or CurrentTheme.Background
        tagBtn.Text = opt
        tagBtn.TextColor3 = isSel and Color3.new(1,1,1) or CurrentTheme.TextSecondary
        tagBtn.Font = Enum.Font.GothamBold
        tagBtn.TextSize = 11
        tagBtn.BorderSizePixel = 0
        tagBtn.AutoButtonColor = false
        Instance.new("UICorner", tagBtn).CornerRadius = UDim.new(0, 6)

        tagBtn.MouseButton1Click:Connect(function()
            selectedTable[opt] = not selectedTable[opt]
            local cur = selectedTable[opt]
            TweenService:Create(tagBtn, TweenInfo.new(0.15), {
                BackgroundColor3 = cur and CurrentTheme.Accent or CurrentTheme.Background,
                TextColor3 = cur and Color3.new(1,1,1) or CurrentTheme.TextSecondary
            }):Play()
            callback(selectedTable)
        end)
    end

    Header.MouseButton1Click:Connect(function()
        expanded = not expanded
        Arrow.Text = expanded and "▲" or "▼"
        TweenService:Create(Card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -6, 0, expanded and targetHeight or 46)
        }):Play()
    end)

    AllCards[#AllCards + 1] = { Card = Card, Title = labelText, Page = parent }
    return Card
end

-- 6. ACTION BUTTON
local function CreateButton(parent, labelText, btnText, callback)
    local Card = CreateBaseCard(parent, labelText, 46)

    local Btn = Instance.new("TextButton", Card)
    Btn.Size = UDim2.new(0, 110, 0, 28)
    Btn.Position = UDim2.new(1, -124, 0.5, -14)
    Btn.BackgroundColor3 = CurrentTheme.Accent
    Btn.Text = btnText
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    RegisterElement(Btn, "BackgroundColor3", "Accent")

    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), { Size = UDim2.new(0, 100, 0, 24) }):Play()
        task.delay(0.1, function()
            TweenService:Create(Btn, TweenInfo.new(0.15, Enum.EasingStyle.Back), { Size = UDim2.new(0, 110, 0, 28) }):Play()
        end)
        callback()
    end)

    return Card
end

-- ==========================================
-- 🎯 СТРАНИЦЫ ИНТЕРФЕЙСА
-- ==========================================
local PageAim = CreateTab("Aimbot", "🎯")
local PageESP = CreateTab("Visuals", "👁️")
local PageMove = CreateTab("Movement", "🏃")
local PageWorld = CreateTab("World FX", "✨")
local PageSettings = CreateTab("Settings", "⚙️")

-- ==================== СТРАНИЦА: AIMBOT ====================
CreateToggle(PageAim, "Включить Aimbot", Aura.Aimbot.Enabled, function(v)
    Aura.Aimbot.Enabled = v
    Notify("Aimbot", v and "Аимбот включен" or "Аимбот выключен", 2)
end)

CreateKeybind(PageAim, "Клавиша активации", Aura.Aimbot.Keybind, function(k)
    Aura.Aimbot.Keybind = k
    Notify("Keybind", "Клавиша аимбота изменена", 2)
end)

local targetPartOptions = {"Head", "Torso", "Hybrid", "Closest"}
local targetPartNames = {"Голова", "Тело", "Гибрид", "Ближайшая кость"}
local curPartIdx = table.find(targetPartOptions, Aura.Aimbot.Mode) or 1
CreateCycleButton(PageAim, "Точка прицеливания", targetPartNames, curPartIdx, function(idx)
    Aura.Aimbot.Mode = targetPartOptions[idx]
end)

local priorityOptions = {"Crosshair", "Distance", "LowestHP"}
local priorityNames = {"К прицелу (FOV)", "По дистанции", "Меньше всего HP"}
local curPrioIdx = table.find(priorityOptions, Aura.Aimbot.Priority) or 1
CreateCycleButton(PageAim, "Приоритет выбора цели", priorityNames, curPrioIdx, function(idx)
    Aura.Aimbot.Priority = priorityOptions[idx]
end)

CreateSlider(PageAim, "Радиус FOV", 10, 500, Aura.Aimbot.FOV, 5, " px", function(v)
    Aura.Aimbot.FOV = v
end)

CreateToggle(PageAim, "Отображать круг FOV", Aura.Aimbot.ShowFOV, function(v)
    Aura.Aimbot.ShowFOV = v
end)

CreateSlider(PageAim, "Плавность доводки (Smooth)", 1, 20, Aura.Aimbot.Smooth, 1, "", function(v)
    Aura.Aimbot.Smooth = v
end)

CreateSlider(PageAim, "Смещение по высоте (Y)", -100, 100, Aura.Aimbot.OffsetY, 1, " px", function(v)
    Aura.Aimbot.OffsetY = v
end)

CreateToggle(PageAim, "Проверка стен (Wall Check)", Aura.Aimbot.WallCheck, function(v)
    Aura.Aimbot.WallCheck = v
    Notify("Wall Check", v and "Проверка видимости включена" or "Стрельба сквозь стены активна", 2)
end)

CreateSlider(PageAim, "Мёртвая зона (Deadzone)", 0, 20, Aura.Aimbot.Deadzone, 1, " px", function(v)
    Aura.Aimbot.Deadzone = v
end)

CreateToggle(PageAim, "Авто-выстрел (Triggerbot)", Aura.Aimbot.Triggerbot, function(v)
    Aura.Aimbot.Triggerbot = v
    Notify("Triggerbot", v and "Автовыстрел активирован" or "Выключен", 2)
end)

local teamNamesList = {"Civilian", "Border Patrol", "Police", "Coast Guard", "FBI", "US Army", "SWAT", "BORTAC"}
CreateMultiDropdown(PageAim, "Фильтр целей по кастам", teamNamesList, Aura.Aimbot.TeamFilter, function(t)
    Aura.Aimbot.TeamFilter = t
end)

-- ==================== СТРАНИЦА: VISUALS (ESP) ====================
CreateToggle(PageESP, "Включить ESP", Aura.ESP.Enabled, function(v)
    Aura.ESP.Enabled = v
    Notify("ESP", v and "ESP активирован" or "ESP выключен", 2)
end)

CreateToggle(PageESP, "Подсветка игроков (Chams / Highlight)", Aura.ESP.Chams, function(v)
    Aura.ESP.Chams = v
end)

CreateToggle(PageESP, "2D Боксы (Boxes)", Aura.ESP.Boxes, function(v)
    Aura.ESP.Boxes = v
end)

CreateToggle(PageESP, "Имена и касты (Names)", Aura.ESP.Names, function(v)
    Aura.ESP.Names = v
end)

CreateToggle(PageESP, "Полоска здоровья (Health Bar)", Aura.ESP.Health, function(v)
    Aura.ESP.Health = v
end)

CreateToggle(PageESP, "Дистанция в метрах", Aura.ESP.Distance, function(v)
    Aura.ESP.Distance = v
end)

CreateToggle(PageESP, "Трейсеры к игрокам (Snaplines)", Aura.ESP.Snaplines, function(v)
    Aura.ESP.Snaplines = v
end)

local snaplineOrigins = {"Bottom", "Center"}
local snaplineNames = {"Снизу экрана", "Из прицела"}
CreateCycleButton(PageESP, "Откуда выходят линии", snaplineNames, 1, function(idx)
    Aura.ESP.SnaplineOrigin = snaplineOrigins[idx]
end)

CreateToggle(PageESP, "Стрелки за экраном (Offscreen Arrows)", Aura.ESP.OffscreenArrows, function(v)
    Aura.ESP.OffscreenArrows = v
end)

CreateSlider(PageESP, "Радиус стрелок", 100, 400, Aura.ESP.ArrowRadius, 10, " px", function(v)
    Aura.ESP.ArrowRadius = v
end)

CreateToggle(PageESP, "Окрашивать в цвета каст", Aura.ESP.TeamColors, function(v)
    Aura.ESP.TeamColors = v
end)

-- ==================== СТРАНИЦА: MOVEMENT ====================
CreateToggle(PageMove, "Спидхак (CFrame Step)", Aura.Movement.SpeedOn, function(v)
    Aura.Movement.SpeedOn = v
end)

CreateSlider(PageMove, "Скорость бега", 16, 500, Aura.Movement.Speed, 2, " studs/s", function(v)
    Aura.Movement.Speed = v
end)

CreateToggle(PageMove, "Полёт (Fly)", Aura.Movement.Fly, function(v)
    Aura.Movement.Fly = v
end)

CreateSlider(PageMove, "Скорость полёта", 10, 300, Aura.Movement.FlySpeed, 5, " studs/s", function(v)
    Aura.Movement.FlySpeed = v
end)

CreateToggle(PageMove, "Бесконечный прыжок (Infinite Jump)", Aura.Movement.InfJump, function(v)
    Aura.Movement.InfJump = v
end)

CreateToggle(PageMove, "Хождение сквозь стены (Noclip)", Aura.Movement.Noclip, function(v)
    Aura.Movement.Noclip = v
end)

Conn(UserInputService.JumpRequest, function()
    if Aura.Movement.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ==================== СТРАНИЦА: WORLD FX ====================
CreateToggle(PageWorld, "Максимальная яркость (Fullbright)", Aura.Visuals.Fullbright, function(v)
    Aura.Visuals.Fullbright = v
    if v then
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    else
        Lighting.Brightness = LightingOrig.Brightness
        Lighting.Ambient = LightingOrig.Ambient
        Lighting.OutdoorAmbient = LightingOrig.OutdoorAmbient
    end
end)

CreateToggle(PageWorld, "Убрать туман (No Fog)", Aura.Visuals.NoFog, function(v)
    Aura.Visuals.NoFog = v
    Lighting.FogEnd = v and 1e9 or LightingOrig.FogEnd
    Lighting.FogStart = v and 0 or LightingOrig.FogStart
end)

CreateToggle(PageWorld, "Отключить тени (No Shadows)", Aura.Visuals.NoShadows, function(v)
    Aura.Visuals.NoShadows = v
    Lighting.GlobalShadows = not v
end)

CreateSlider(PageWorld, "Угол обзора камеры (Camera FOV)", 30, 120, Aura.Visuals.FOV, 1, "°", function(v)
    Aura.Visuals.FOV = v
end)

CreateToggle(PageWorld, "Неоновый мир (Neon World)", Aura.Visuals.Neon, function(v)
    Aura.Visuals.Neon = v
    if v then Aura.Visuals.Plastic = false end
    applyWorldFX()
end)

CreateToggle(PageWorld, "Убрать текстуры (Smooth Plastic)", Aura.Visuals.Plastic, function(v)
    Aura.Visuals.Plastic = v
    if v then Aura.Visuals.Neon = false end
    applyWorldFX()
end)

local function setSky(id)
    local s = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)
    for _, k in pairs({"Bk","Dn","Ft","Lf","Rt","Up"}) do s["Skybox"..k] = id end
    Notify("Skybox", "Скайбокс изменён", 2)
end

CreateButton(PageWorld, "Галактическое небо", "Применить", function() setSky("rbxassetid://159454286") end)
CreateButton(PageWorld, "Кровавое небо", "Применить", function() setSky("rbxassetid://600886090") end)
CreateButton(PageWorld, "Всегда день", "Включить", function() Lighting.ClockTime = 14 end)
CreateButton(PageWorld, "Всегда ночь", "Включить", function() Lighting.ClockTime = 0 end)

-- ==================== СТРАНИЦА: SETTINGS ====================
local themeKeys = {"Dark", "Cyberpunk", "Rose", "Midnight", "Emerald"}
local themeNames = {"Dark Minimal", "Cyberpunk 2077", "Rose Tea", "Midnight Ocean", "Emerald Forest"}
local curThemeIdx = table.find(themeKeys, Aura.Config.Theme) or 1
CreateCycleButton(PageSettings, "Цветовая тема меню", themeNames, curThemeIdx, function(idx)
    Aura.Config.Theme = themeKeys[idx]
    ApplyTheme(themeKeys[idx])
    Notify("Тема", "Применена тема: " .. themeNames[idx], 2, "success")
end)

CreateToggle(PageSettings, "Кастомный прицел (Crosshair)", Aura.Crosshair.Enabled, function(v)
    Aura.Crosshair.Enabled = v
end)

CreateSlider(PageSettings, "Размер прицела", 4, 30, Aura.Crosshair.Size, 1, " px", function(v)
    Aura.Crosshair.Size = v
end)

CreateSlider(PageSettings, "Зазор прицела", 0, 20, Aura.Crosshair.Gap, 1, " px", function(v)
    Aura.Crosshair.Gap = v
end)

CreateSlider(PageSettings, "Толщина прицела", 1, 6, Aura.Crosshair.Thickness, 1, " px", function(v)
    Aura.Crosshair.Thickness = v
end)

CreateButton(PageSettings, "Полная выгрузка чита", "Выгрузить", function()
    if getgenv().AuraHubUnload then getgenv().AuraHubUnload() end
end)

-- Инициализация первой вкладки
ActiveTabName = "Aimbot"
Tabs["Aimbot"].Page.Visible = true
Tabs["Aimbot"].Bar.BackgroundTransparency = 0
Tabs["Aimbot"].Label.TextColor3 = CurrentTheme.TextPrimary
Tabs["Aimbot"].Icon.TextColor3 = CurrentTheme.Accent

-- ==========================================
-- 🎯 БОЕВОЙ ДВИЖОК (AIMBOT + TARGETING)
-- ==========================================
local FOVCircle = NewDraw("Circle", {
    Thickness = 1.5,
    Color = CurrentTheme.Accent,
    Filled = false,
    NumSides = 60,
    Radius = Aura.Aimbot.FOV,
    Visible = false
})

local function IsVisible(targetPart)
    local origin = Camera.CFrame.Position
    local dir = targetPart.Position - origin

    -- Определяем персонажа, которому принадлежит часть (устойчиво к вложенности).
    local targetChar = nil
    for _, pl in pairs(Players:GetPlayers()) do
        if pl.Character and targetPart:IsDescendantOf(pl.Character) then
            targetChar = pl.Character
            break
        end
    end

    local params = RaycastParams.new()
    local filter = {}
    for _, pl in pairs(Players:GetPlayers()) do
        -- Исключаем всех персонажей, КРОМЕ цели:
        -- 1) союзники не блокируют луч до цели;
        -- 2) луч упирается в тело самой цели и не "пробивает" его насквозь
        --    до стены, стоящей вплотную за спиной (ложное "не видно").
        if pl.Character and pl.Character ~= targetChar then
            filter[#filter + 1] = pl.Character
        end
    end
    params.FilterDescendantsInstances = filter
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true

    local result = Workspace:Raycast(origin, dir, params)
    if not result then
        -- Ни во что не попали — цели на линии нет (считаем невидимой).
        return false
    end

    if targetChar then
        -- Упёрлись в часть самой цели — видима; в стену/препятствие — нет.
        return result.Instance:IsDescendantOf(targetChar)
    end

    -- Часть не принадлежит игроку (редкий случай) — видима, только если
    -- луч упёрся непосредственно в неё.
    return result.Instance == targetPart or result.Instance:IsDescendantOf(targetPart)
end

-- Типовые названия частей тела (R6/R15). Режим "Closest" выбирает только
-- скелет, а не любые декоративные BasePart-дети персонажа.
local BODY_PART_NAMES = {
    Head = true, Torso = true, UpperTorso = true, LowerTorso = true,
    HumanoidRootPart = true,
    LeftArm = true, RightArm = true, LeftUpperArm = true, RightUpperArm = true,
    LeftLowerArm = true, RightLowerArm = true, LeftHand = true, RightHand = true,
    LeftLeg = true, RightLeg = true, LeftUpperLeg = true, RightUpperLeg = true,
    LeftLowerLeg = true, RightLowerLeg = true, LeftFoot = true, RightFoot = true
}

local function GetTargetParts(ch)
    local head = ch:FindFirstChild("Head")
    local torso = ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") or ch:FindFirstChild("HumanoidRootPart")
    if Aura.Aimbot.Mode == "Head" then
        -- Фолбэк на торс: у нестандартных моделей части Head может не быть,
        -- иначе цель просто не находилась бы (возвращался { nil }).
        return { head or torso }
    elseif Aura.Aimbot.Mode == "Torso" then
        return { torso }
    elseif Aura.Aimbot.Mode == "Hybrid" then
        return { head, torso }
    else
        -- "Closest": только части скелета по типовым именам.
        local parts = {}
        for _, p in pairs(ch:GetChildren()) do
            if p:IsA("BasePart") and BODY_PART_NAMES[p.Name] then
                parts[#parts + 1] = p
            end
        end
        -- Фолбэк для кастомных моделей: если по именам ничего не нашлось,
        -- берём все BasePart-дети (прежнее поведение).
        if #parts == 0 then
            for _, p in pairs(ch:GetChildren()) do
                if p:IsA("BasePart") then parts[#parts + 1] = p end
            end
        end
        return parts
    end
end

local function HasActiveTeamFilter()
    for _, v in pairs(Aura.Aimbot.TeamFilter) do
        if v then return true end
    end
    return false
end

-- Проверяет, выбран ли фильтр, соответствующий касте игрока.
-- Ключи фильтра — "красивые" названия из UI (напр. "US Army"), а GetTeamInfo
-- возвращает lowercase-ключ (напр. "us army" или просто "army"), поэтому
-- сравниваем регистронезависимо и в обе стороны по подстроке:
-- "us army" == "army" не сработает, а "us army":find("army") — да.
local function TeamMatchesFilter(teamKey)
    for fName, fActive in pairs(Aura.Aimbot.TeamFilter) do
        if fActive then
            local f = fName:lower()
            if f == teamKey or teamKey:find(f, 1, true) or f:find(teamKey, 1, true) then
                return true
            end
        end
    end
    return false
end

local function GetBestTarget()
    local bestTarget = nil
    local bestScore = math.huge
    local cx, cy = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2
    local filterActive = HasActiveTeamFilter()

    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("Humanoid") and pl.Character.Humanoid.Health > 0 then
            local ch = pl.Character
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end

            if filterActive then
                local _, _, teamKey = GetTeamInfo(pl)
                if not TeamMatchesFilter(teamKey) then continue end
            end

            local parts = GetTargetParts(ch)
            for _, part in pairs(parts) do
                if part then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    -- pos.Z > 0 — цель впереди камеры. Для цели за спиной проекция
                    -- "отзеркаливается", onScreen бывает true, и прицел резко
                    -- разворачивается на 180°. Проверка глубины это исключает.
                    if onScreen and pos.Z > 0 then
                        -- Смещение по Y учитывается и в FOV-гейте (как в наведении).
                        local aimY = pos.Y + Aura.Aimbot.OffsetY
                        local screenDist = (Vector2.new(cx, cy) - Vector2.new(pos.X, aimY)).Magnitude
                        if screenDist <= Aura.Aimbot.FOV then
                            if not Aura.Aimbot.WallCheck or IsVisible(part) then
                                local score = 0
                                if Aura.Aimbot.Priority == "Crosshair" then
                                    score = screenDist
                                elseif Aura.Aimbot.Priority == "Distance" then
                                    score = (Camera.CFrame.Position - part.Position).Magnitude
                                elseif Aura.Aimbot.Priority == "LowestHP" then
                                    score = ch.Humanoid.Health
                                end

                                if score < bestScore then
                                    bestScore = score
                                    bestTarget = part
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return bestTarget
end

-- ==========================================
-- 👁️ ESP ДВИЖОК (HIGHLIGHTS + DRAWING)
-- ==========================================
local ESP_Entries = {}

local function UpdatePlayerHighlight(plr)
    if not Aura.ESP.Enabled or not Aura.ESP.Chams then
        if HighlightObjects[plr] then
            HighlightObjects[plr]:Destroy()
            HighlightObjects[plr] = nil
        end
        return
    end

    if plr == LocalPlayer or not plr.Character then return end

    local color = Color3.new(1,1,1)
    if Aura.ESP.TeamColors then
        color = GetTeamInfo(plr)
    end

    local hl = HighlightObjects[plr]
    if not hl or hl.Parent ~= plr.Character then
        if hl then hl:Destroy() end
        hl = Instance.new("Highlight")
        hl.Name = "AuraChams"
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = plr.Character
        HighlightObjects[plr] = hl
    end

    hl.FillColor = color
    hl.OutlineColor = Color3.new(1,1,1)
    hl.FillTransparency = Aura.ESP.ChamsFillTrans
    hl.OutlineTransparency = Aura.ESP.ChamsOutlineTrans
end

local function CreateDrawingESP(plr)
    if plr == LocalPlayer or not Drawing then return end
    local box = NewDraw("Square", { Thickness = 1.5, Filled = false, Visible = false })
    local boxOutline = NewDraw("Square", { Thickness = 3.5, Color = Color3.new(0,0,0), Filled = false, Visible = false })
    local name = NewDraw("Text", { Size = 12, Center = true, Outline = true, OutlineColor = Color3.new(0,0,0), Visible = false })
    local hpBg = NewDraw("Line", { Thickness = 4, Color = Color3.new(0,0,0), Visible = false })
    local hpBar = NewDraw("Line", { Thickness = 4, Visible = false })
    local tracer = NewDraw("Line", { Thickness = 1.5, Visible = false })
    local arrow = NewDraw("Triangle", { Filled = true, Visible = false })

    ESP_Entries[plr] = {
        Box = box, BoxOutline = boxOutline, Name = name,
        HpBg = hpBg, HpBar = hpBar, Tracer = tracer, Arrow = arrow
    }
end

local function RemoveDrawingESP(plr)
    local e = ESP_Entries[plr]
    if e then
        for _, obj in pairs(e) do pcall(function() obj:Remove() end) end
        ESP_Entries[plr] = nil
    end
    if HighlightObjects[plr] then
        HighlightObjects[plr]:Destroy()
        HighlightObjects[plr] = nil
    end
end

for _, p in pairs(Players:GetPlayers()) do CreateDrawingESP(p) end
Conn(Players.PlayerAdded, CreateDrawingESP)
Conn(Players.PlayerRemoving, RemoveDrawingESP)

-- Crosshair Lines
local CrossLines = {}
for i = 1, 4 do
    CrossLines[i] = NewDraw("Line", { Thickness = 2, Color = Aura.Crosshair.Color, Visible = false })
end
local CrossDot = NewDraw("Circle", { Radius = 2, Filled = true, Color = Aura.Crosshair.Color, NumSides = 12, Visible = false })

-- ==========================================
-- 🔄 ГЛАВНЫЙ ЦИКЛ ОБРАБОТКИ
-- ==========================================
local flyVel, flyAlign, flyAtt
local lastTriggerTime = 0

Conn(RunService.RenderStepped, function(dt)
    local cx, cy = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2

    -- 1. FOV Круг
    if FOVCircle then
        FOVCircle.Visible = Aura.Aimbot.ShowFOV
        FOVCircle.Radius = Aura.Aimbot.FOV
        FOVCircle.Position = Vector2.new(cx, cy)
        FOVCircle.Color = CurrentTheme.Accent
    end

    -- 2. Кастомный прицел
    if CrossLines and CrossLines[1] then
        local showCross = Aura.Crosshair.Enabled
        local sz, gp, th = Aura.Crosshair.Size, Aura.Crosshair.Gap, Aura.Crosshair.Thickness
        local segs = {
            { cx, cy - gp - sz, cx, cy - gp },
            { cx, cy + gp, cx, cy + gp + sz },
            { cx - gp - sz, cy, cx - gp, cy },
            { cx + gp, cy, cx + gp + sz, cy }
        }
        for i, s in pairs(segs) do
            local l = CrossLines[i]
            l.Visible = showCross
            l.Thickness = th
            l.Color = CurrentTheme.Accent
            l.From = Vector2.new(s[1], s[2])
            l.To = Vector2.new(s[3], s[4])
        end
        if CrossDot then
            CrossDot.Visible = showCross and Aura.Crosshair.Dot
            CrossDot.Position = Vector2.new(cx, cy)
            CrossDot.Color = CurrentTheme.Accent
        end
    end

    -- 3. Aimbot & Triggerbot
    -- Перебор игроков и raycast'ы — только когда аимбот/триггербот реально нужны.
    local target = nil
    if Aura.Aimbot.Enabled or Aura.Aimbot.Triggerbot then
        target = GetBestTarget()
    end
    local isAimHotkeyPressed = false
    if typeof(Aura.Aimbot.Keybind) == "EnumItem" then
        if Aura.Aimbot.Keybind.EnumType == Enum.UserInputType then
            isAimHotkeyPressed = UserInputService:IsMouseButtonPressed(Aura.Aimbot.Keybind)
        elseif Aura.Aimbot.Keybind.EnumType == Enum.KeyCode then
            isAimHotkeyPressed = UserInputService:IsKeyDown(Aura.Aimbot.Keybind)
        end
    end

    if Aura.Aimbot.Enabled and isAimHotkeyPressed and target then
        -- WorldToViewportPoint — та же система координат, что в FOV-гейте, ESP
        -- и у GetMouseLocation (без GUI inset). Раньше здесь был WorldToScreenPoint,
        -- из-за чего точка прицеливания съезжала по Y на величину верхней панели.
        local pos, onScreen = Camera:WorldToViewportPoint(target.Position)
        if onScreen and pos.Z > 0 then
            local targetY = pos.Y + Aura.Aimbot.OffsetY

            -- mousemoverel двигает курсор ОТНОСИТЕЛЬНО его текущего положения,
            -- поэтому дельту считаем от реальной позиции мыши, а не от центра
            -- экрана (совпадает с центром только при залоченной мыши).
            local mousePos = UserInputService:GetMouseLocation()
            local dx = pos.X - mousePos.X
            local dy = targetY - mousePos.Y
            local dist = math.sqrt(dx*dx + dy*dy)

            if dist > Aura.Aimbot.Deadzone then
                local smooth = math.clamp(Aura.Aimbot.Smooth, 1, 20) -- слайдер Smooth: 1..20
                local moveX = dx / smooth
                local moveY = dy / smooth
                if mousemoverel then
                    mousemoverel(math.clamp(moveX, -150, 150), math.clamp(moveY, -150, 150))
                else
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 1 / smooth)
                end
            end
        end
    end

    -- Triggerbot. Работает только при включённом аимботе, зажатой клавише
    -- активации и с той же проверкой стен, что и сам аимбот.
    if Aura.Aimbot.Enabled and Aura.Aimbot.Triggerbot and isAimHotkeyPressed and target and (tick() - lastTriggerTime) >= (Aura.Aimbot.TriggerDelay / 1000) then
        local pos, onScreen = Camera:WorldToViewportPoint(target.Position)
        if onScreen and pos.Z > 0 then
            -- Точка прицеливания с учётом смещения по Y.
            local aimY = pos.Y + Aura.Aimbot.OffsetY
            local dist = (Vector2.new(cx, cy) - Vector2.new(pos.X, aimY)).Magnitude
            -- Порог выстрела привязан к мёртвой зоне: стреляем, когда цель уже
            -- в зоне, где аимбот перестаёт доводить. Минимум 2px, чтобы при
            -- Deadzone = 0 не требовалось пиксельной точности.
            local triggerRadius = math.max(Aura.Aimbot.Deadzone, 2)
            if dist <= triggerRadius and (not Aura.Aimbot.WallCheck or IsVisible(target)) then
                -- lastTriggerTime ставим только в момент реального выстрела.
                if mouse1click then
                    lastTriggerTime = tick()
                    mouse1click()
                elseif mouse1press and mouse1release then
                    lastTriggerTime = tick()
                    -- task.spawn, чтобы task.wait внутри не замораживал рендер-цикл
                    task.spawn(function()
                        mouse1press()
                        task.wait(0.02)
                        mouse1release()
                    end)
                end
            end
        end
    end

    -- 4. ESP отрисовка
    for plr, e in pairs(ESP_Entries) do
        local ch = plr.Character
        local show = Aura.ESP.Enabled and ch and ch:FindFirstChild("HumanoidRootPart") and ch:FindFirstChild("Humanoid") and ch.Humanoid.Health > 0

        UpdatePlayerHighlight(plr)

        if show then
            local hrp = ch.HumanoidRootPart
            local hum = ch.Humanoid
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local teamColor, teamName = GetTeamInfo(plr)
            local clr = Aura.ESP.TeamColors and teamColor or CurrentTheme.Accent

            if onScreen then
                if e.Arrow then e.Arrow.Visible = false end

                local headPos = Camera:WorldToViewportPoint(ch.Head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = legPos.Y - headPos.Y
                local width = height / 2
                local distStuds = (Camera.CFrame.Position - hrp.Position).Magnitude
                local distMeters = math.floor(distStuds * 0.28)

                -- Боксы
                if Aura.ESP.Boxes then
                    e.BoxOutline.Visible = true
                    e.BoxOutline.Size = Vector2.new(width, height)
                    e.BoxOutline.Position = Vector2.new(headPos.X - width/2, headPos.Y)
                    e.Box.Visible = true
                    e.Box.Color = clr
                    e.Box.Size = Vector2.new(width, height)
                    e.Box.Position = Vector2.new(headPos.X - width/2, headPos.Y)
                else
                    e.Box.Visible = false; e.BoxOutline.Visible = false
                end

                -- Имена
                if Aura.ESP.Names then
                    e.Name.Visible = true
                    e.Name.Color = clr
                    e.Name.Position = Vector2.new(headPos.X, headPos.Y - 16)
                    local str = "[" .. teamName .. "] " .. plr.Name
                    if Aura.ESP.Distance then str = str .. " (" .. distMeters .. "m)" end
                    e.Name.Text = str
                else
                    e.Name.Visible = false
                end

                -- ХП Бар
                if Aura.ESP.Health then
                    local pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    local x = headPos.X - width/2 - 6
                    e.HpBg.From = Vector2.new(x, headPos.Y)
                    e.HpBg.To = Vector2.new(x, headPos.Y + height)
                    e.HpBg.Visible = true

                    e.HpBar.From = Vector2.new(x, headPos.Y + height * (1 - pct))
                    e.HpBar.To = Vector2.new(x, headPos.Y + height)
                    e.HpBar.Color = Color3.fromHSV(pct * 0.3, 1, 1)
                    e.HpBar.Visible = true
                else
                    e.HpBg.Visible = false; e.HpBar.Visible = false
                end

                -- Трейсеры
                if Aura.ESP.Snaplines then
                    e.Tracer.Visible = true
                    e.Tracer.Color = clr
                    local fromY = (Aura.ESP.SnaplineOrigin == "Bottom") and Camera.ViewportSize.Y or cy
                    e.Tracer.From = Vector2.new(cx, fromY)
                    e.Tracer.To = Vector2.new(headPos.X, legPos.Y)
                else
                    e.Tracer.Visible = false
                end
            else
                -- Offscreen Arrows
                e.Box.Visible = false; e.BoxOutline.Visible = false; e.Name.Visible = false
                e.HpBg.Visible = false; e.HpBar.Visible = false; e.Tracer.Visible = false

                if Aura.ESP.OffscreenArrows and e.Arrow then
                    local camCFrame = Camera.CFrame
                    local rel = camCFrame:PointToObjectSpace(hrp.Position)
                    local angle = math.atan2(-rel.X, rel.Z)
                    local radius = Aura.ESP.ArrowRadius
                    local ax = cx + math.sin(angle) * radius
                    local ay = cy - math.cos(angle) * radius

                    local p1 = Vector2.new(ax + math.sin(angle) * 12, ay - math.cos(angle) * 12)
                    local p2 = Vector2.new(ax + math.sin(angle + 2.5) * 8, ay - math.cos(angle + 2.5) * 8)
                    local p3 = Vector2.new(ax + math.sin(angle - 2.5) * 8, ay - math.cos(angle - 2.5) * 8)

                    e.Arrow.PointA = p1
                    e.Arrow.PointB = p2
                    e.Arrow.PointC = p3
                    e.Arrow.Color = clr
                    e.Arrow.Visible = true
                elseif e.Arrow then
                    e.Arrow.Visible = false
                end
            end
        else
            for _, obj in pairs(e) do obj.Visible = false end
        end
    end

    -- 5. Movement
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid

        if Aura.Movement.SpeedOn and not Aura.Movement.Fly and hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + hum.MoveDirection * (Aura.Movement.Speed - 16) * dt
        end

        if Aura.Movement.Fly then
            hum.PlatformStand = true
            if not flyVel or not flyVel.Parent then
                flyAtt = Instance.new("Attachment", hrp)
                flyVel = Instance.new("LinearVelocity")
                flyVel.Attachment0 = flyAtt
                flyVel.RelativeTo = Enum.ActuatorRelativeTo.World
                flyVel.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                flyAlign = Instance.new("AlignOrientation")
                flyAlign.Attachment0 = flyAtt
                flyAlign.Mode = Enum.OrientationAlignmentMode.OneAttachment
                flyAlign.Responsiveness = 200
                flyVel.Parent = hrp
                flyAlign.Parent = hrp
            end

            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
            flyVel.VectorVelocity = (dir.Magnitude > 0 and dir.Unit or Vector3.zero) * Aura.Movement.FlySpeed
            flyAlign.CFrame = Camera.CFrame
        elseif flyVel then
            flyVel:Destroy(); flyAlign:Destroy(); flyAtt:Destroy()
            flyVel, flyAlign, flyAtt = nil, nil, nil
            hum.PlatformStand = false
        end

        if Aura.Movement.Noclip then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end

    Camera.FieldOfView = Aura.Visuals.FOV
end)

-- ==========================================
-- 🖱️ ДРАГ И ХОТКЕИ ОКНА
-- ==========================================
local dragStart, startPos
Conn(TitleBar.InputBegan, function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        Aura.UI.Drag = true
        dragStart = i.Position
        startPos = Main.Position
    end
end)
Conn(TitleBar.InputEnded, function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then Aura.UI.Drag = false end
end)
Conn(UserInputService.InputChanged, function(i)
    if Aura.UI.Drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

Conn(UserInputService.InputBegan, function(i, gp)
    if Unloaded then return end
    if not gp and (i.KeyCode == Enum.KeyCode.RightControl or i.KeyCode == Enum.KeyCode.Insert) then
        setOpen(not Aura.UI.Open)
    end
end)

-- ==========================================
-- 🛑 ВЫГРУЗКА
-- ==========================================
local function Unload()
    if Unloaded then return end
    Unloaded = true
    for _, c in pairs(Connections) do pcall(function() c:Disconnect() end) end
    for _, d in pairs(DrawObjects) do pcall(function() d:Remove() end) end
    for _, h in pairs(HighlightObjects) do pcall(function() h:Destroy() end) end

    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
        if flyVel then flyVel:Destroy() end
        if flyAlign then flyAlign:Destroy() end
    end)

    for p, m in pairs(PartOrigMat) do
        if p.Parent then pcall(function() p.Material = m end) end
    end

    pcall(function()
        Lighting.Brightness = LightingOrig.Brightness
        Lighting.Ambient = LightingOrig.Ambient
        Lighting.OutdoorAmbient = LightingOrig.OutdoorAmbient
        Lighting.FogEnd = LightingOrig.FogEnd
        Lighting.FogStart = LightingOrig.FogStart
        Lighting.GlobalShadows = LightingOrig.GlobalShadows
        Camera.FieldOfView = 70
    end)

    pcall(function() ScreenGui:Destroy() end)
    getgenv().AuraHubUnload = nil
    print("🔮 AURA HUB v3.0 UNLOADED")
end

getgenv().AuraHubUnload = Unload
CloseBtn.MouseButton1Click:Connect(Unload)

Notify("AURA HUB v3.0", "Чит успешно инициализирован! Нажми Insert / RCtrl", 4, "success")
print("🔮 AURA HUB v3.0 READY")
