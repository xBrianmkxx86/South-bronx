local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()
local RunService = game:GetService("RunService")

-- --- CONFIGURACIÓN ---
_G.AimbotEnabled = false
_G.ESPEnabled = false
_G.AutoFarm = false
_G.AimPart = "Head" -- Puede ser "UpperTorso" para que sea menos obvio

-- --- INTERFAZ (Estilo Kawatan Real) ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SouthBronxHub"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 350)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
Main.Parent = ScreenGui
Main.Active = true
Main.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "SOUTH BRONX - KAWATAN"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Parent = Main

-- --- LÓGICA DE AIMBOT (Silent Aim) ---
local function getClosestPlayer()
    local closest = nil
    local shortestDist = math.huge
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild(_G.AimPart) then
            local pos, onScreen = camera:WorldToViewportPoint(p.Character[_G.AimPart].Position)
            if onScreen then
                local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if dist < shortestDist and dist < 200 then -- 200 es el radio del FOV
                    closest = p.Character[_G.AimPart]
                    shortestDist = dist
                end
            end
        end
    end
    return closest
end

-- Hook para el Aimbot
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.AimbotEnabled and method == "FireServer" and self.Name == "RemoteEventNameHere" then -- Ajustar al remoto del arma
        local target = getClosestPlayer()
        if target then
            args[1] = target.Position -- Redirige la bala
        end
    end
    return oldNamecall(self, unpack(args))
end)

-- --- LÓGICA DE ESP ---
RunService.RenderStepped:Connect(function()
    if _G.ESPEnabled then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not p.Character:FindFirstChild("ESPHighlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.Parent = p.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.new(1,1,1)
                end
            end
        end
    else
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESPHighlight") then
                p.Character.ESPHighlight:Destroy()
            end
        end
    end
end)

-- --- BOTONES DEL MENÚ ---
local function AddButton(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = Main
    
    local bCorner = Instance.new("UICorner")
    bCorner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
end

AddButton("AIMBOT (HEAD)", UDim2.new(0.05, 0, 0.15, 0), function()
    _G.AimbotEnabled = not _G.AimbotEnabled
    print("Aimbot: "..tostring(_G.AimbotEnabled))
end)

AddButton("ESP PLAYERS", UDim2.new(0.05, 0, 0.30, 0), function()
    _G.ESPEnabled = not _G.ESPEnabled
end)

AddButton("AUTO FARM TRABAJO", UDim2.new(0.05, 0, 0.45, 0), function()
    _G.AutoFarm = not _G.AutoFarm
    while _G.AutoFarm do
        -- Ejemplo de auto-farm: Ir a un punto de entrega
        local jobPoint = workspace:FindFirstChild("JobLocation") -- Ajustar según el trabajo
        if jobPoint and player.Character then
            player.Character.HumanoidRootPart.CFrame = jobPoint.CFrame
        end
        task.wait(5)
    end
end)

AddButton("CERRAR", UDim2.new(0.05, 0, 0.85, 0), function()
    ScreenGui:Destroy()
end)
