-- South Bronx Professional Static Hub
if not game:IsLoaded() then game.Loaded:Wait() end
local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

if pgui:FindFirstChild("SBX_Kawatan_Static") then pgui.SBX_Kawatan_Static:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SBX_Kawatan_Static"
sg.ResetOnSpawn = false

-- --- PANEL PRINCIPAL (Estilo Kawatan Azul) ---
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 220, 0, 320)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 25, 35) -- Azul Oscuro
Main.Active = true
Main.Draggable = true

local corner = Instance.new("UICorner", Main)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", Main)
stroke.Color = Color3.fromRGB(0, 170, 255) -- Borde Azul Brillante
stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "SOUTH BRONX HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(0.9, 0, 0.8, 0)
Container.Position = UDim2.new(0.05, 0, 0.15, 0)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2

local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- --- CREADOR DE BOTONES INTERACTIVOS ---
local function NewBtn(txt, callback)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(30, 45, 60)
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    b.MouseButton1Click:Connect(function()
        -- Efecto visual rápido
        b.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        task.wait(0.1)
        b.BackgroundColor3 = Color3.fromRGB(30, 45, 60)
        callback()
    end)
end

-- --- FUNCIONES MANUALES (SIN BUCLES = SIN FREEZE) ---

NewBtn("ACTUALIZAR ESP (RED)", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.new(1, 0, 0) -- Rojo
            h.OutlineColor = Color3.new(1, 1, 1)
        end
    end
end)

NewBtn("LIMPIAR ESP", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Highlight") then 
            p.Character.Highlight:Destroy() 
        end
    end
end)

NewBtn("AIM LOCK (PRÓXIMO)", function()
    local target = nil
    local dist = 500
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude
                if mag < dist then
                    target = p.Character.Head
                    dist = mag
                end
            end
        end
    end
    if target then
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
    end
end)

NewBtn("TP: DELIVERY WORK", function()
    if player.Character then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(125, 5, -340)
    end
end)

NewBtn("TP: STORE WORK", function()
    if player.Character then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(-200, 5, 50)
    end
end)

NewBtn("ANTI-KICK: ACTIVE", function()
    print("Anti-Kick ya está cargado en el núcleo.")
end)

-- --- CARGA DE NÚCLEO (SILENCIOSA) ---
pcall(function()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() == "Kick" then return nil end
        return old(self, ...)
    end)
end)
