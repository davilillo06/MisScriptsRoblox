--[[
    da block HUB - PREMIUM MODERN EDITION
    ESP con Vida, Distancia y Nombres + Aimlock Mejorado + Speed Slider
    Tecla: RIGHT CONTROL
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local pGui = player:WaitForChild("PlayerGui")

-- CONFIGURACIÓN
local Config = {
    Speed = 60,
    ForceSpeed = false,
    NoFall = false,
    ESP = false,
    Aimlock = false,
    Language = "ES",
    ThemeColor = Color3.fromRGB(120, 80, 255)
}

local Lang = {
    ES = {Combat = "COMBATE", Player = "JUGADOR", Visuals = "VISUALES", Settings = "AJUSTES", Aim = "Aimlock (Click Der.)", Speed = "Activar Velocidad", NoFall = "Sin Daño Caída", ESP = "ESP Maestro", Color = "Color Tema", Kill = "Borrar Hub"},
    EN = {Combat = "COMBAT", Player = "PLAYER", Visuals = "VISUALS", Settings = "SETTINGS", Aim = "Aimlock (R-Click)", Speed = "Toggle Speed", NoFall = "No Fall Damage", ESP = "Master ESP", Color = "Theme Color", Kill = "Unload Hub"}
}

-- BASE GUI
local sg = Instance.new("ScreenGui", pGui)
sg.Name = "ModernHub_V5"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 480) -- Aumentado un poco el tamaño para el perfil
main.Position = UDim2.new(0.5, -275, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Config.ThemeColor
mainStroke.Thickness = 2

-----------------------------------------------------------
-- NUEVA SECCIÓN: PERFIL Y TÍTULO (da block HUB)
-----------------------------------------------------------
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, -20, 0, 70)
header.Position = UDim2.new(0, 10, 0, 10)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
Instance.new("UICorner", header)

local profilePic = Instance.new("ImageLabel", header)
profilePic.Size = UDim2.new(0, 50, 0, 50)
profilePic.Position = UDim2.new(0, 10, 0.5, -25)
profilePic.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
profilePic.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
Instance.new("UICorner", profilePic).CornerRadius = UDim.new(1, 0) -- Circular

local welcomeLabel = Instance.new("TextLabel", header)
welcomeLabel.Size = UDim2.new(0, 200, 0, 20)
welcomeLabel.Position = UDim2.new(0, 70, 0, 15)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
welcomeLabel.TextColor3 = Color3.new(1, 1, 1)
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.TextSize = 14
welcomeLabel.TextXAlignment = Enum.TextXAlignment.Left

local idLabel = Instance.new("TextLabel", header)
idLabel.Size = UDim2.new(0, 200, 0, 20)
idLabel.Position = UDim2.new(0, 70, 0, 35)
idLabel.BackgroundTransparency = 1
idLabel.Text = "ID: " .. player.UserId
idLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
idLabel.Font = Enum.Font.Gotham
idLabel.TextSize = 12
idLabel.TextXAlignment = Enum.TextXAlignment.Left

local hubTitle = Instance.new("TextLabel", header)
hubTitle.Size = UDim2.new(0, 150, 1, 0)
hubTitle.Position = UDim2.new(1, -160, 0, 0)
hubTitle.BackgroundTransparency = 1
hubTitle.Text = "da block HUB"
hubTitle.TextColor3 = Config.ThemeColor
hubTitle.Font = Enum.Font.GothamBlack
hubTitle.TextSize = 18
hubTitle.TextXAlignment = Enum.TextXAlignment.Right
-----------------------------------------------------------

local Translatables = {}
local UIAccents = {}

-- SISTEMA ESP MAESTRO
local function CreateESP(plr)
    local bgui = Instance.new("BillboardGui")
    bgui.Name = "ESP_UI"
    bgui.AlwaysOnTop = true
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.ExtentsOffset = Vector3.new(0, 3, 0)
    
    local nameLabel = Instance.new("TextLabel", bgui)
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.TextStrokeTransparency = 0
    
    local distLabel = Instance.new("TextLabel", bgui)
    distLabel.Position = UDim2.new(0, 0, 0.4, 0)
    distLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 12
    
    local healthBarBack = Instance.new("Frame", bgui)
    healthBarBack.Position = UDim2.new(0.25, 0, 0.8, 0)
    healthBarBack.Size = UDim2.new(0.5, 0, 0, 4)
    healthBarBack.BackgroundColor3 = Color3.new(0, 0, 0)
    
    local healthBarMain = Instance.new("Frame", healthBarBack)
    healthBarMain.Size = UDim2.new(1, 0, 1, 0)
    healthBarMain.BackgroundColor3 = Color3.new(0, 1, 0)
    healthBarMain.BorderSizePixel = 0

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Chams"
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0

    local function Update()
        RunService.RenderStepped:Connect(function()
            if not Config.ESP or not plr or not plr.Parent or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                bgui.Enabled = false
                highlight.Enabled = false
                return
            end
            
            local char = plr.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char.HumanoidRootPart
            
            if hum and hum.Health > 0 then
                bgui.Enabled = true
                highlight.Enabled = true
                bgui.Adornee = hrp
                highlight.Parent = char
                highlight.FillColor = Config.ThemeColor
                
                local distance = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                nameLabel.Text = plr.DisplayName
                distLabel.Text = "[" .. distance .. "m]"
                
                local healthPercent = hum.Health / hum.MaxHealth
                healthBarMain.Size = UDim2.new(healthPercent, 0, 1, 0)
                healthBarMain.BackgroundColor3 = Color3.new(1, 0, 0):Lerp(Color3.new(0, 1, 0), healthPercent)
            else
                bgui.Enabled = false
                highlight.Enabled = false
            end
        end)
    end
    bgui.Parent = sg
    Update()
end

for _, p in pairs(Players:GetPlayers()) do if p ~= player then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= player then CreateESP(p) end end)

-- SISTEMA DE INTERFAZ (Ajustado el Scroll para dejar espacio al Header)
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -100)
scroll.Position = UDim2.new(0, 10, 0, 90)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local layout = Instance.new("UIListLayout", scroll)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0, 10)

local function CreateSection(key)
    local f = Instance.new("Frame", scroll)
    f.Size = UDim2.new(0.95, 0, 0, 50)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    f.ClipsDescendants = true
    Instance.new("UICorner", f)
    
    local t = Instance.new("TextButton", f)
    t.Size = UDim2.new(1, 0, 0, 50)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamBold
    t.TextSize = 18
    t.TextColor3 = Config.ThemeColor
    Translatables[t] = key
    table.insert(UIAccents, t)

    local c = Instance.new("Frame", f)
    c.Size = UDim2.new(1, 0, 0, 0)
    c.Position = UDim2.new(0, 0, 0, 50)
    c.BackgroundTransparency = 1
    local l = Instance.new("UIListLayout", c)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l.Padding = UDim.new(0, 8)

    t.MouseButton1Click:Connect(function()
        local isExp = f.Size.Y.Offset > 50
        TweenService:Create(f, TweenInfo.new(0.3), {Size = isExp and UDim2.new(0.95, 0, 0, 50) or UDim2.new(0.95, 0, 0, l.AbsoluteContentSize.Y + 70)}):Play()
    end)
    return c
end

local function AddToggle(parent, key, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.9, 0, 0, 40)
    f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.6, 0, 1, 0)
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.Gotham; l.TextSize = 16; l.TextXAlignment = 0; l.BackgroundTransparency = 1
    Translatables[l] = key
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 70, 0, 30); b.Position = UDim2.new(1, -75, 0.5, -15)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50); b.Text = "OFF"; b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.Text = active and "ON" or "OFF"
        b.BackgroundColor3 = active and Config.ThemeColor or Color3.fromRGB(50,50,50)
        callback(active)
    end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.9, 0, 0, 55)
    f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.Text = text .. ": " .. default
    l.TextColor3 = Color3.new(1,1,1)
    l.Font = Enum.Font.Gotham; l.TextSize = 14; l.TextXAlignment = 0; l.BackgroundTransparency = 1
    local sliderBack = Instance.new("Frame", f)
    sliderBack.Size = UDim2.new(1, 0, 0, 10)
    sliderBack.Position = UDim2.new(0, 0, 0, 30)
    sliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", sliderBack)
    local sliderFill = Instance.new("Frame", sliderBack)
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Config.ThemeColor
    Instance.new("UICorner", sliderFill)
    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + (max - min) * pos)
        l.Text = text .. ": " .. val
        callback(val)
    end
    sliderBack.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; updateSlider(input) end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end

-- LLAMADAS
local secCombat = CreateSection("Combat")
local secPlayer = CreateSection("Player")
local secVisual = CreateSection("Visuals")
local secSettings = CreateSection("Settings")

AddToggle(secCombat, "Aim", function(v) Config.Aimlock = v end)
AddToggle(secPlayer, "Speed", function(v) Config.ForceSpeed = v end)
AddSlider(secPlayer, "Velocidad", 16, 300, Config.Speed, function(v) Config.Speed = v end)
AddToggle(secPlayer, "NoFall", function(v) Config.NoFall = v end)
AddToggle(secVisual, "ESP", function(v) Config.ESP = v end)

local function CreateBtn(parent, text, cb, color)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.9, 0, 0, 40); b.BackgroundColor3 = color or Color3.fromRGB(30, 30, 35)
    b.TextColor3 = Color3.new(1,1,1); b.Text = text; b.Font = Enum.Font.Gotham; b.TextSize = 16
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(cb)
    return b
end

CreateBtn(secSettings, "Español 🇪🇸", function() Config.Language = "ES" for o,k in pairs(Translatables) do o.Text = Lang.ES[k] end end)
CreateBtn(secSettings, "English 🇺🇸", function() Config.Language = "EN" for o,k in pairs(Translatables) do o.Text = Lang.EN[k] end end)
CreateBtn(secSettings, "Kill Menu", function() sg:Destroy() end, Color3.fromRGB(150, 0, 0))

-- BUCLE PRINCIPAL
RunService.RenderStepped:Connect(function()
    if Config.ForceSpeed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = Config.Speed
    end
    
    if Config.NoFall and player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root and root.Velocity.Y < -30 then
                root.Velocity = Vector3.new(root.Velocity.X, -30, root.Velocity.Z)
            end
        end
    end

    if Config.Aimlock and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil; local dist = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if m < dist then dist = m; target = v end
                end
            end
        end
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- ARRASTRAR
local d, ds, sp
main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; ds = i.Position; sp = main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local dl = i.Position - ds main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y) end end)
main.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightControl then main.Visible = not main.Visible end end)

for o,k in pairs(Translatables) do o.Text = Lang.ES[k] end