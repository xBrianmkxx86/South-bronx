-- South Bronx Zero Lag - Especial para Potassium
if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Borrar todo lo anterior para liberar memoria
if pgui:FindFirstChild("SBX_Zero") then pgui.SBX_Zero:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SBX_Zero"
sg.ResetOnSpawn = false

-- --- ESTADOS ---
_G.Aimbot = false
_G.Locked = false

-- --- ANTI-KICK (Optimizado) ---
pcall(function()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() == "Kick" then return nil end
        return old(self, ...)
    end)
end)

-- --- INTERFAZ TIPO LISTA (MUY LIGERA) ---
local Main = Instance.new("ScrollingFrame", sg)
Main.Size = UDim2.new(0, 160, 0, 250)
Main.Position = UDim2.new(0, 10, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local layout = Instance.new("UIListLayout", Main)
layout.Padding = UDim.new(0, 4)

local function CreateBtn(name, color, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = color
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    b.MouseButton1Click:Connect(function()
        if not _G.Locked or name == "UNLOCK MENU" then callback(b) end
    end)
end

-- --- BOTONES ---

CreateBtn("LOCK/UNLOCK", Color3.fromRGB(150, 0, 0), function(b)
    _G.Locked = not _G.Locked
    b.Text = _G.Locked and "UNLOCK MENU" or "LOCK MENU"
    b.BackgroundColor3 = _G.Locked and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- ESP MANUAL: Solo se actualiza cuando lo tocas (Cero Lag)
CreateBtn("ACTUALIZAR ESP", Color3.fromRGB(50, 50, 80), function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            -- Borrar viejo
            if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
            -- Poner nuevo
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.new(1, 0, 0)
            h.OutlineTransparency = 1
        end
    end
end)

CreateBtn("QUITAR ESP", Color3.fromRGB(30, 30, 30), function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Highlight") then 
            p.Character.Highlight:Destroy() 
        end
    end
end)

-- AIMBOT: Solo se activa cuando lo necesitas
CreateBtn("AIMBOT (ON/OFF)", Color3.fromRGB(40, 40, 60), function(b)
    _G.Aimbot = not _G.Aimbot
    b.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(40, 40, 60)
end)

-- AUTO FARM TRABAJOS (Por CFrame Directo)
local function FarmTo(pos)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = pos
    end
end

CreateBtn("FARM: DELIVERY", Color3.fromRGB(30, 60, 30), function()
    FarmTo(CFrame.new(125, 5, -340)) -- Coordenadas ejemplo del Bronx
end)

CreateBtn("FARM: LIMPIEZA", Color3.fromRGB(30, 60, 30), function()
    FarmTo(CFrame.new(-200, 5, 50))
end)

-- --- BUCLE DE AIMBOT (SÚPER LENTO PARA NO FRISAR) ---
task.spawn(function()
    while task.wait(0.2) do -- Solo 5 veces por segundo, no 60
        if _G.Aimbot then
            local target = nil
            local dist = 200
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
        end
    end
end)
