-- SOUTH BRONX - KAWATAN SAFE MODE
if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- Limpieza total para liberar RAM
if pgui:FindFirstChild("SBX_Safe") then pgui.SBX_Safe:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "SBX_Safe"
sg.ResetOnSpawn = false

-- --- BOTÓN DE APERTURA (MÁS LIGERO) ---
local OpenBtn = Instance.new("TextButton", sg)
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
OpenBtn.Text = "K"
OpenBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 20)

-- --- PANEL (OPTIMIZADO PARA NO CRASHEAR) ---
local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 160, 0, 240)
Main.Position = UDim2.new(0.1, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
Main.Visible = false
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "KAWATAN LITE"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

local Container = Instance.new("ScrollingFrame", Main)
Container.Size = UDim2.new(1, 0, 0.85, 0)
Container.Position = UDim2.new(0, 0, 0.15, 0)
Container.BackgroundTransparency = 1
Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
Container.ScrollBarThickness = 0

local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- --- FUNCIONES (EJECUCIÓN ÚNICA) ---
local function NewBtn(txt, callback)
    local b = Instance.new("TextButton", Container)
    b.Size = UDim2.new(0.9, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(30, 40, 50)
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(callback)
end

-- --- BOTONES ---

NewBtn("ESP (UPDATE)", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            if p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.new(1, 0, 0)
            h.FillOpacity = 0.6
        end
    end
end)

NewBtn("CLEAR ESP", function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
    end
end)

NewBtn("AIM LOCK (HEAD)", function()
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

-- SECCIÓN TP (TRABAJOS)
NewBtn("TP: DELIVERY", function() player.Character.HumanoidRootPart.CFrame = CFrame.new(125, 5, -340) end)
NewBtn("TP: STORE", function() player.Character.HumanoidRootPart.CFrame = CFrame.new(-200, 5, 50) end)

-- Lógica abrir/cerrar
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Anti-Kick (Metamethod ligero)
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" then return nil end
        return old(self, ...)
    end)
end)
