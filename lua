-- Optimizaciones iniciales
if not game:IsLoaded() then game.Loaded:Wait() end
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local pgui = player:WaitForChild("PlayerGui")

-- Limpieza
if pgui:FindFirstChild("SouthBronxUltra") then pgui.SouthBronxUltra:Destroy() end

-- --- VARIABLES ---
_G.Aimbot = false
_G.ESP = false
_G.AutoFarm = false
_G.TrabajoSeleccionado = "Delivery"
_G.MenuBloqueado = false

-- --- ANTI-KICK BASICO ---
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" or method == "kick" then return nil end
    return old(self, ...)
end)

-- --- INTERFAZ ---
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SouthBronxUltra"

local Main = Instance.new("ScrollingFrame", sg)
Main.Size = UDim2.new(0, 220, 0, 300)
Main.Position = UDim2.new(0.05, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Main.ScrollBarThickness = 2
Main.Active = true
Main.Draggable = true

local layout = Instance.new("UIListLayout", Main)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Función para crear botones
local function NewButton(txt, color, callback)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.BackgroundColor3 = color
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    
    b.MouseButton1Click:Connect(function()
        if not _G.MenuBloqueado or txt == "BLOQUEAR/DESBLOQUEAR" then
            callback(b)
        end
    end)
    return b
end

-- --- BOTONES DE CONTROL ---

NewButton("BLOQUEAR/DESBLOQUEAR", Color3.fromRGB(200, 0, 0), function(b)
    _G.MenuBloqueado = not _G.MenuBloqueado
    b.Text = _G.MenuBloqueado and "MENU: BLOQUEADO" or "MENU: DESBLOQUEADO"
end)

NewButton("AIMBOT (HEAD)", Color3.fromRGB(40, 40, 50), function(b)
    _G.Aimbot = not _G.Aimbot
    b.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(40, 40, 50)
end)

NewButton("ESP (JUGADORES)", Color3.fromRGB(40, 40, 50), function(b)
    _G.ESP = not _G.ESP
    if not _G.ESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
        end
    end
end)

-- --- APARTADO DE TRABAJOS ---
local TitleJobs = Instance.new("TextLabel", Main)
TitleJobs.Size = UDim2.new(0.9, 0, 0, 20)
TitleJobs.Text = "--- TRABAJOS ---"
TitleJobs.TextColor3 = Color3.new(1,1,0)
TitleJobs.BackgroundTransparency = 1

local trabajos = {"Delivery", "Store Clerk", "Janitor", "Trash Collector"}
for _, nombre in pairs(trabajos) do
    NewButton("FARM: " .. nombre, Color3.fromRGB(30, 60, 30), function()
        _G.TrabajoSeleccionado = nombre
        _G.AutoFarm = not _G.AutoFarm
        print("Trabajando en: " .. nombre)
    end)
end

-- --- LOGICA OPTIMIZADA (ANTI-FPS DROP) ---
task.spawn(function()
    while task.wait(0.5) do -- No corre cada frame, ahorra FPS
        if _G.ESP then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and not p.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.new(1, 0, 0)
                end
            end
        end
        
        if _G.AutoFarm then
            -- Intentar encontrar el punto del trabajo seleccionado
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find(_G.TrabajoSeleccionado:lower()) then
                    player.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                    break
                end
            end
            task.wait(4) -- Espera para que el Anti-Cheat no te kickee por TP
        end
    end
end)

-- Aimbot suave
RunService.RenderStepped:Connect(function()
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
end)
