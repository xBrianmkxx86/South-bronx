-- SOUTH BRONX - VERSIÓN ULTRA ESTABLE (ANTI-CRASH)
-- Diseñado para Delta/Potassium en móviles con poca RAM

if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Borrar todo para liberar RAM antes de empezar
if pgui:FindFirstChild("SB_STABLE") then pgui.SB_STABLE:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SB_STABLE"

-- --- MENÚ ULTRA SIMPLE (SIN GRÁFICOS PESADOS) ---
local f = Instance.new("Frame", sg)
f.Size = UDim2.new(0, 140, 0, 200)
f.Position = UDim2.new(0, 5, 0.4, 0)
f.BackgroundColor3 = Color3.new(0,0,0)
f.BackgroundTransparency = 0.5 -- Menos carga gráfica

local function b(txt, y, cb)
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.Text = txt
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.BorderSizePixel = 0
    btn.TextSize = 12
    btn.MouseButton1Click:Connect(cb)
end

-- --- FUNCIONES MANUALES (CERO PROCESAMIENTO DE FONDO) ---

-- ESP MANUAL (Solo se activa al tocar el botón)
b("MARCAR GENTE", 0, function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            h.FillColor = Color3.new(1,0,0)
            h.FillOpacity = 0.5
        end
    end
end)

b("BORRAR MARCAS", 35, function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Highlight") then 
            p.Character.Highlight:Destroy() 
        end
    end
end)

-- AIMBOT MANUAL (Apunta solo 1 vez al tocar)
b("APUNTAR (1 VEZ)", 70, function()
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

-- TELEPORTS (Sin bucles)
b("TP: DELIVERY", 105, function()
    player.Character.HumanoidRootPart.CFrame = CFrame.new(125, 5, -340)
end)

b("TP: TIENDA", 140, function()
    player.Character.HumanoidRootPart.CFrame = CFrame.new(-200, 5, 50)
end)

b("CERRAR", 175, function() sg:Destroy() end)

-- ANTI-KICK (Ligero)
pcall(function()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() == "Kick" then return nil end
        return old(self, ...)
    end)
end)
