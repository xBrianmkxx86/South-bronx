-- South Bronx Fix para Potassium
if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Limpieza total para evitar lag acumulado
if pgui:FindFirstChild("SBX_Fix") then pgui.SBX_Fix:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SBX_Fix"
sg.ResetOnSpawn = false

-- --- ESTADOS ---
_G.Aimbot = false
_G.ESP = false
_G.Farm = false

-- --- CREADOR DE BOTONES LIGEROS ---
local function CreateMiniBtn(name, pos, color, callback)
    local btn = Instance.new("TextButton", sg)
    btn.Size = UDim2.new(0, 140, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Active = true
    btn.Draggable = true -- Los puedes mover si se estorban
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.new(1,1,1)
    stroke.Thickness = 1

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- --- FUNCIONES (OPTIMIZADAS) ---

-- 1. Aimbot (Menos pesado)
CreateMiniBtn("AIMBOT: OFF", UDim2.new(0.05, 0, 0.2, 0), Color3.fromRGB(40, 40, 40), function(b)
    _G.Aimbot = not _G.Aimbot
    b.Text = _G.Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
    b.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

-- 2. ESP (Simple Highlight)
CreateMiniBtn("ESP: OFF", UDim2.new(0.05, 0, 0.3, 0), Color3.fromRGB(40, 40, 40), function(b)
    _G.ESP = not _G.ESP
    b.Text = _G.ESP and "ESP: ON" or "ESP: OFF"
    b.BackgroundColor3 = _G.ESP and Color3.fromRGB(0, 150, 200) or Color3.fromRGB(40, 40, 40)
end)

-- 3. Auto Farm
CreateMiniBtn("AUTO FARM", UDim2.new(0.05, 0, 0.4, 0), Color3.fromRGB(40, 40, 40), function(b)
    _G.Farm = not _G.Farm
    b.BackgroundColor3 = _G.Farm and Color3.fromRGB(150, 150, 0) or Color3.fromRGB(40, 40, 40)
    
    task.spawn(function()
        while _G.Farm do
            print("Farm activo")
            task.wait(5) -- Espera larga para evitar que se frise
        end
    end)
end)

-- --- LOOP DE CONTROL (UN SOLO HILO) ---
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.ESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and not p.Character:FindFirstChild("Highlight") then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Color3.new(1, 0, 0)
            end
        end
    end

    if _G.Aimbot and tick() % 0.2 < 0.05 then -- Solo calcula cada 0.2 segundos
        local target = nil
        local dist = 400
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude
                    if m < dist then
                        target = p.Character.Head
                        dist = m
                    end
                end
            end
        end
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
        end
    end
end)
