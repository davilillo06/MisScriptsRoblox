-- GENESIS PREMIUM V1.5 | DEFINITIVE EDITION
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

local state = {
    aim = false,
    noclip = false,
    esp = false,
    flySpeed = 90
}

-- --- INTERFAZ MODERNA ---
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 340, 0, 320)
Main.Position = UDim2.new(0.5, -170, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0, 180, 255)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "GENESIS <font color='#00B4FF'>PREMIUM</font>"
Title.RichText = true
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1

local Holder = Instance.new("ScrollingFrame", Main)
Holder.Size = UDim2.new(1, -20, 1, -80)
Holder.Position = UDim2.new(0, 10, 0, 70)
Holder.BackgroundTransparency = 1
Holder.ScrollBarThickness = 0
local Layout = Instance.new("UIListLayout", Holder)
Layout.Padding = UDim.new(0, 10)

local function AddToggle(text, key, icon, callback)
    local btn = Instance.new("TextButton", Holder)
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    btn.Text = "      " .. icon .. " " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        state[key] = not state[key]
        btn.BackgroundColor3 = state[key] and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(20, 20, 24)
        callback(state[key])
    end)
end

-- --- LÓGICA DE NOCLIP / FLY DEFINITIVA ---
local flyConnection

AddToggle("NOCLIP", "noclip", "👻", function(active)
    if active then
        flyConnection = RS.RenderStepped:Connect(function(dt)
            if state.noclip and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = lp.Character.HumanoidRootPart
                
                -- Desactivar colisiones constantemente
                for _, part in pairs(lp.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
                
                -- Control de movimiento por CFrame (Atraviesa todo)
                local dir = Vector3.new(0,0,0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
                
                hrp.Velocity = Vector3.new(0, 0.1, 0) -- Mantiene al personaje sin gravedad
                hrp.CFrame = hrp.CFrame + (dir * state.flySpeed * dt)
            end
        end)
    else
        if flyConnection then flyConnection:Disconnect() end
        if lp.Character then
            for _, part in pairs(lp.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
            lp.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- --- AIM ---
AddToggle("AIM", "aim", "🎯", function() end)
RS.RenderStepped:Connect(function()
    if state.aim and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil
        local dist = 250
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
                local pos, vis = camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                    if m < dist then dist = m target = v end
                end
            end
        end
        if target then camera.CFrame = CFrame.lookAt(camera.CFrame.Position, target.Character.Head.Position) end
    end
end)

-- --- ESP ---
AddToggle("ESP", "esp", "👁️", function(v)
    if not v then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("GenesisHighlight") then
                p.Character.GenesisHighlight:Destroy()
                if p.Character.Head:FindFirstChild("GenesisTag") then p.Character.Head.GenesisTag:Destroy() end
            end
        end
    end
end)

RS.RenderStepped:Connect(function()
    if state.esp then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not p.Character:FindFirstChild("GenesisHighlight") then
                    Instance.new("Highlight", p.Character).Name = "GenesisHighlight"
                    local bb = Instance.new("BillboardGui", p.Character.Head)
                    bb.Name = "GenesisTag"; bb.Size = UDim2.new(0,100,0,40); bb.AlwaysOnTop = true; bb.ExtentsOffset = Vector3.new(0,3,0)
                    local lb = Instance.new("TextLabel", bb)
                    lb.Size = UDim2.new(1,0,1,0); lb.BackgroundTransparency = 1; lb.TextColor3 = Color3.new(1,1,1); lb.Font = Enum.Font.GothamBold; lb.TextSize = 11
                end
                local tag = p.Character.Head:FindFirstChild("GenesisTag")
                if tag then
                    local d = math.floor((lp.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude)
                    tag.TextLabel.Text = p.DisplayName .. "\nHP: " .. math.floor(p.Character.Humanoid.Health) .. " | " .. d .. "m"
                end
            end
        end
    end
end)

-- ARRASTRE Y TECLA R-CTRL
local d, ds, sp
Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = Main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
    local delta = i.Position - ds
    Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
UIS.InputBegan:Connect(function(i) if i.KeyCode == Enum.KeyCode.RightControl then Main.Visible = not Main.Visible end end)
