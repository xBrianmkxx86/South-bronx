-- SOUTH BRONX KAWATAN (ULTRA STABLE VERSION)
if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Limpiar todo lo anterior
if pgui:FindFirstChild("SBX_Final_Fixed") then pgui.SBX_Final_Fixed:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SBX_Final_Fixed"
sg.ResetOnSpawn = false

-- --- BOTÓN DE ABRIR (EL AZUL DE SIEMPRE) ---
local OpenBtn = Instance.new("TextButton", sg)
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.Text = "≡"
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.TextSize = 25
local btnCorner = Instance.new("UICorner", OpenBtn)
btnCorner.CornerRadius = UDim.new(0, 10)

-- --- PANEL PRINCIPAL (ESTILO KAWATAN) ---
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 200, 0, 280)
Main.Position = UDim2.new(0.1, 0, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
Main.Visible = false -- Empieza cerrado
Main.Active = true
Main.Draggable = true

local mCorner = Instance.new("UICorner", Main)
local mStroke = Instance.new("UIStroke", Main)
mStroke.Color = Color3.fromRGB(0, 170, 255)
mStroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "KAWATAN SBX"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

-- --- CONTENEDOR LIGERO ---
local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(0.9, 0, 0.8, 0)
Container.Position = UDim2.new(0.05, 0, 0.15, 0)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.2, 0)
Container.ScrollBarThickness = 0

local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- --- FUNCIONES SIN BUCLES (ANTI-FREEZE) ---
local function NewBtn(txt, callback)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(1, 0, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(30, 45, 60)
    b.Text = txt
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        b.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        task.wait(0.1)
        b.BackgroundColor3 = Color3.fromRGB(30, 45, 60)
        callback()
    end)
end

-- --- BOTONES ---

NewBtn("ACTUALIZAR ESP", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.new(1, 0, 0)
        end
    end
end)

NewBtn("LIMPIAR ESP", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
    end
end)

NewBtn("AIM LOCK (CABEZAS)", function()
    local target = nil
    local dist = 400
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude
                if mag < dist then target = p.Character.Head dist = mag end
            end
        end
    end
    if target then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position) end
end)

-- --- SECCIÓN DE TRABAJOS (AUTO-FARM MANUAL) ---
NewBtn("FARM: DELIVERY", function() player.Character.HumanoidRootPart.CFrame = CFrame.new(125, 5, -340) end)
NewBtn("FARM: STORE", function() player.Character.HumanoidRootPart.CFrame = CFrame.new(-200, 5, 50) end)
NewBtn("FARM: JANITOR", function() player.Character.HumanoidRootPart.CFrame = CFrame.new(45, 5, 120) end)

-- Lógica abrir/cerrar
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Anti-Kick Silencioso
pcall(function()
    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() == "Kick" then return nil end
        return old(self, ...)
    end)
end)
