--[[
    DA BLOCK HUB 
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
sg.Name = "DaBlockHub_V5"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 420)
main.Position = UDim2.new(0.5, -275, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Config.ThemeColor
mainStroke.Thickness = 2

-- === SECCIÓN DE INFORMACIÓN DEL USUARIO ===
local userInfoFrame = Instance.new("Frame", main)
userInfoFrame.Size = UDim2.new(1, -30, 0, 65)
userInfoFrame.Position = UDim2.new(0, 15, 0, 15)
userInfoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", userInfoFrame).CornerRadius = UDim.new(0, 12)

local userImage = Instance.new("ImageLabel", userInfoFrame)
userImage.Size = UDim2.new(0, 45, 0, 45)
userImage.Position = UDim2.new(0, 10, 0.5, -22)
userImage.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
userImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
Instance.new("UICorner", userImage).CornerRadius = UDim.new(1, 0)

local hubTitle = Instance.new("TextLabel", userInfoFrame)
hubTitle.Size = UDim2.new(0, 200, 0, 20)
hubTitle.Position = UDim2.new(1, -210, 0, 10)
hubTitle.BackgroundTransparency = 1
hubTitle.Text = "DA BLOCK HUB"
hubTitle.TextColor3 = Config.ThemeColor
hubTitle.Font = Enum.Font.GothamBlack
hubTitle.TextSize = 18
hubTitle.TextXAlignment = Enum.TextXAlignment.Right

local userName = Instance.new("TextLabel", userInfoFrame)
userName.Size = UDim2.new(1, -70, 0, 20)
userName.Position = UDim2.new(0, 65, 0.22, 0)
userName.BackgroundTransparency = 1
userName.Text = player.DisplayName
userName.TextColor3 = Color3.new(1, 1, 1)
userName.Font = Enum.Font.GothamBold
userName.TextSize = 15
userName.TextXAlignment = Enum.TextXAlignment.Left

local userIdLabel = Instance.new("TextLabel", userInfoFrame)
userIdLabel.Size = UDim2.new(1, -70, 0, 20)
userIdLabel.Position = UDim2.new(0, 65, 0.55, 0)
userIdLabel.BackgroundTransparency = 1
userIdLabel.Text = "@" .. player.Name
userIdLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
userIdLabel.Font = Enum.Font.Gotham
userIdLabel.TextSize = 12
userIdLabel.TextXAlignment = Enum.TextXAlignment.Left

local Translatables = {}
local UIAccents = {} 
table.insert(UIAccents, mainStroke)
table.insert(UIAccents, hubTitle)

-- === SISTEMA ESP MEJORADO (FIXED) ===
local function CreateESP(plr)
    local function Setup()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        local bgui = Instance.new("BillboardGui", sg)
        bgui.Name = "ESP_" .. plr.Name
        bgui.AlwaysOnTop = true
        bgui.Size = UDim2.new(0, 200, 0, 50)
        bgui.ExtentsOffset = Vector3.new(0, 3, 0)
        bgui.Adornee = hrp

        local nameLabel = Instance.new("TextLabel", bgui)
        nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.new(1, 1, 1)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.TextStrokeTransparency = 0

        local highlight = Instance.new("Highlight", char)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not Config.ESP or not plr.Parent or not char.Parent or not hrp.Parent then
                bgui.Enabled = false
                highlight.Enabled = false
                if not plr.Parent then connection:Disconnect() bgui:Destroy() end
                return
            end

            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                bgui.Enabled = true
                highlight.Enabled = true
                highlight.FillColor = Config.ThemeColor
                local dist = math.floor((player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                nameLabel.Text = plr.DisplayName .. " [" .. dist .. "m]"
            else
                bgui.Enabled = false
                highlight.Enabled = false
            end
        end)
    end
    Setup()
    plr.CharacterAdded:Connect(Setup)
end

-- Activar ESP para jugadores actuales y nuevos
for _, p in pairs(Players:GetPlayers()) do if p ~= player then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= player then CreateESP(p) end end)

-- === INTERFAZ Y FUNCIONES ===
local function UpdateThemeColor(newColor)
    Config.ThemeColor = newColor
    for _, obj in pairs(UIAccents) do
        if obj:IsA("UIStroke") then obj.Color = newColor
        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextColor3 = newColor
        elseif obj:IsA("Frame") and obj.Name == "SliderFill" then obj.BackgroundColor3 = newColor end
    end
end

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -110)
scroll.Position = UDim2.new(0, 10, 0, 95)
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
    t.Font = Enum.Font.GothamBold; t.TextSize = 18; t.TextColor3 = Config.ThemeColor
    Translatables[t] = key; table.insert(UIAccents, t)
    local c = Instance.new("Frame", f)
    c.Size = UDim2.new(1, 0, 0, 0); c.Position = UDim2.new(0, 0, 0, 50); c.BackgroundTransparency = 1
    local l = Instance.new("UIListLayout", c); l.HorizontalAlignment = 1; l.Padding = UDim.new(0, 8)
    t.MouseButton1Click:Connect(function()
        local isExp = f.Size.Y.Offset > 50
        TweenService:Create(f, TweenInfo.new(0.3), {Size = isExp and UDim2.new(0.95, 0, 0, 50) or UDim2.new(0.95, 0, 0, l.AbsoluteContentSize.Y + 70)}):Play()
    end)
    return c
end

local function AddToggle(parent, key, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.9, 0, 0, 40); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.6, 0, 1, 0); l.TextColor3 = Color3.new(1,1,1); l.Font = Enum.Font.Gotham; l.TextSize = 16; l.TextXAlignment = 0; l.BackgroundTransparency = 1
    Translatables[l] = key
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 70, 0, 30); b.Position = UDim2.new(1, -75, 0.5, -15); b.BackgroundColor3 = Color3.fromRGB(50,50,50); b.Text = "OFF"; b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    local active = false
    b.MouseButton1Click:Connect(function()
        active = not active
        b.Text = active and "ON" or "OFF"
        b.BackgroundColor3 = active and Config.ThemeColor or Color3.fromRGB(50,50,50)
        callback(active)
    end)
    RunService.RenderStepped:Connect(function() if active then b.BackgroundColor3 = Config.ThemeColor end end)
end

local function AddSlider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.9, 0, 0, 55); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 0, 20); l.Text = text .. ": " .. default; l.TextColor3 = Color3.new(1,1,1); l.Font = Enum.Font.Gotham; l.TextSize = 14; l.TextXAlignment = 0; l.BackgroundTransparency = 1
    local sliderBack = Instance.new("Frame", f)
    sliderBack.Size = UDim2.new(1, 0, 0, 10); sliderBack.Position = UDim2.new(0, 0, 0, 30); sliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", sliderBack)
    local sliderFill = Instance.new("Frame", sliderBack)
    sliderFill.Name = "SliderFill"; sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); sliderFill.BackgroundColor3 = Config.ThemeColor; table.insert(UIAccents, sliderFill)
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

local function CreateBtn(parent, text, cb, color)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.9, 0, 0, 40); b.BackgroundColor3 = color or Color3.fromRGB(30, 30, 35)
    b.TextColor3 = Color3.new(1,1,1); b.Text = text; b.Font = Enum.Font.Gotham; b.TextSize = 16
    Instance.new("UICorner", b); b.MouseButton1Click:Connect(cb)
    return b
end

-- SECCIONES
local secCombat = CreateSection("Combat")
local secPlayer = CreateSection("Player")
local secVisual = CreateSection("Visuals")
local secSettings = CreateSection("Settings")

AddToggle(secCombat, "Aim", function(v) Config.Aimlock = v end)
AddToggle(secPlayer, "Speed", function(v) Config.ForceSpeed = v end)
AddSlider(secPlayer, "Velocidad", 16, 300, Config.Speed, function(v) Config.Speed = v end)
AddToggle(secPlayer, "NoFall", function(v) Config.NoFall = v end)
AddToggle(secVisual, "ESP", function(v) Config.ESP = v end)

CreateBtn(secSettings, "Español 🇪🇸", function() Config.Language = "ES" for o,k in pairs(Translatables) do o.Text = Lang.ES[k] end end)
CreateBtn(secSettings, "English 🇺🇸", function() Config.Language = "EN" for o,k in pairs(Translatables) do o.Text = Lang.EN[k] end end)

local colorGrid = Instance.new("Frame", secSettings)
colorGrid.Size = UDim2.new(0.9, 0, 0, 45); colorGrid.BackgroundTransparency = 1
local clayout = Instance.new("UIListLayout", colorGrid); clayout.FillDirection = 0; clayout.HorizontalAlignment = 1; clayout.Padding = UDim.new(0, 10)

local function ColorCircle(col)
    local b = Instance.new("TextButton", colorGrid); b.Size = UDim2.new(0, 35, 0, 35); b.BackgroundColor3 = col; b.Text = ""
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(function() UpdateThemeColor(col) end)
end

ColorCircle(Color3.fromRGB(120, 80, 255))
ColorCircle(Color3.fromRGB(255, 50, 50))
ColorCircle(Color3.fromRGB(50, 255, 100))
ColorCircle(Color3.fromRGB(50, 150, 255))
ColorCircle(Color3.fromRGB(255, 200, 50))

CreateBtn(secSettings, "Kill Menu", function() sg:Destroy() end, Color3.fromRGB(150, 0, 0))

-- BUCLE DE LÓGICA
RunService.RenderStepped:Connect(function()
    if Config.ForceSpeed and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = Config.Speed
    end
    
    if Config.Aimlock and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target, dist = nil, math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if m < dist then dist = m; target = v end
                end
            end
        end
        if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.HumanoidRootPart.Position) end
    end
end)

-- ARRASTRAR Y CERRAR
local d, ds, sp
main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true; ds = i.Position; sp = main.Position end end)
UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local dl = i.Position - ds main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dl.X, sp.Y.Scale, sp.Y.Offset + dl.Y) end end)
main.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
UserInputService.InputBegan:Connect(function(i, g) if not g and i.KeyCode == Enum.KeyCode.RightControl then main.Visible = not main.Visible end end)

for o,k in pairs(Translatables) do o.Text = Lang.ES[k] end
