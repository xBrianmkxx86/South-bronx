-- South Bronx Ultra-Lite (Fix Freeze para Potassium)
repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Borrar menú anterior
if pgui:FindFirstChild("SBX_V3") then pgui.SBX_V3:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SBX_V3"
sg.ResetOnSpawn = false

-- --- ESTADOS ---
_G.Aimbot = false
_G.ESP = false
_G.Farm = false
_G.Locked = false

-- --- ANTI-KICK ---
local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    if getnamecallmethod() == "Kick" then return nil end
    return old(self, ...)
end)

-- --- INTERFAZ SIMPLE (SIN LAG) ---
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 180, 0, 280)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local function Btn(name, color, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.BackgroundColor3 = color
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    Instance.new("UIListLayout", Main).Padding = UDim.new(0, 5)
    
    b.MouseButton1Click:Connect(function()
        if not _G.Locked or name == "LOCK/UNLOCK" then callback(b) end
    end)
end

-- --- BOTONES ---

Btn("LOCK/UNLOCK", Color3.fromRGB(150, 0, 0), function(b)
    _G.Locked = not _G.Locked
    b.Text = _G.Locked and "MENU BLOQUEADO" or "LOCK/UNLOCK"
end)

Btn("AIMBOT", Color3.fromRGB(40, 40, 60), function(b)
    _G.Aimbot = not _G.Aimbot
    b.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(40, 40, 60)
end)

Btn("ESP", Color3.fromRGB(40, 40, 60), function(b)
    _G.ESP = not _G.ESP
    if not _G.ESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
        end
    end
end)

-- Trabajos Simplificados (TP a coordenadas para no dar lag)
local jobs = {
    ["DELIVERY"] = Vector3.new(100, 5, 200), -- Ejemplo, ajustar coordenadas reales
    ["CLEANER"] = Vector3.new(-50, 5, -150)
}

for name, pos in pairs(jobs) do
    Btn("FARM: "..name, Color3.fromRGB(30, 50, 30), function()
        _G.Farm = not _G.Farm
        task.spawn(function()
            while _G.Farm do
                if player.Character then 
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                end
                task.wait(5)
            end
        end)
    end)
end

-- --- BUCLE UNIFICADO (OPTIMIZADO) ---
game:GetService("RunService").Heartbeat:Connect(function()
    -- ESP cada 1 segundo (Ahorra FPS)
    if _G.ESP and tick() % 1 < 0.05 then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and not p.Character:FindFirstChild("Highlight") then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Color3.new(1, 0, 0)
            end
        end
    end

    -- Aimbot Suave
    if _G.Aimbot and tick() % 0.1 < 0.02 then
        local target = nil
        local dist = 250
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local screenPos, vis = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude
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
    end
end)
