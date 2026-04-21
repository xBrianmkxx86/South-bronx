-- SOUTH BRONX STATIC (ANTI-FREEZE TOTAL)
if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Limpieza inmediata
if pgui:FindFirstChild("SBX_Static") then pgui.SBX_Static:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SBX_Static"
sg.ResetOnSpawn = false

-- --- INTERFAZ DE BAJO CONSUMO ---
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 150, 0, 260)
Main.Position = UDim2.new(0, 10, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true

local layout = Instance.new("UIListLayout", Main)
layout.Padding = UDim.new(0, 2)

local function Btn(name, color, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = color
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    b.MouseButton1Click:Connect(callback)
end

-- --- BOTONES ACCIÓN ÚNICA (CERO LAG) ---

-- ESP MANUAL: Solo brilla cuando lo tocas. No gasta FPS.
Btn("ACTUALIZAR ESP", Color3.fromRGB(0, 100, 200), function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.new(1, 0, 0)
            h.OutlineTransparency = 1
        end
    end
end)

Btn("QUITAR ESP", Color3.fromRGB(50, 50, 50), function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Highlight") then 
            p.Character.Highlight:Destroy() 
        end
    end
end)

-- AIMBOT ESTÁTICO: Solo apunta una vez cuando le das al botón.
Btn("AUTO AIM (ONE-TAP)", Color3.fromRGB(200, 0, 0), function()
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

-- AUTO FARM (TP DIRECTO POR BOTÓN)
local function Go(x, y, z)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
    end
end

Btn("TP: DELIVERY", Color3.fromRGB(30, 80, 30), function() Go(125, 5, -340) end)
Btn("TP: STORE", Color3.fromRGB(30, 80, 30), function() Go(-200, 5, 50) end)
Btn("TP: JANITOR", Color3.fromRGB(30, 80, 30), function() Go(45, 5, 120) end)

Btn("CERRAR SCRIPT", Color3.fromRGB(0, 0, 0), function() sg:Destroy() end)

-- ANTI-KICK PASIVO (NO CONSUME)
pcall(function()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() == "Kick" then return nil end
        return old(self, ...)
    end)
end)
