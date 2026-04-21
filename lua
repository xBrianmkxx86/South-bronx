-- Esperar a que el juego cargue sin congelar
repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Limpiar si ya existe
if player.PlayerGui:FindFirstChild("SBX_Lite") then
    player.PlayerGui.SBX_Lite:Destroy()
end

-- --- CONFIG ---
_G.Aimbot = false
_G.ESP = false
_G.Noclip = false

-- --- INTERFAZ SUPER LIGERA ---
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "SBX_Lite"

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 160, 0, 220)
Main.Position = UDim2.new(0.05, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
Main.Active = true
Main.Draggable = true -- Para moverlo si estorba

local function CreateBtn(text, pos, callback)
    local b = Instance.new("TextButton", Main)
    b.Text = text
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    
    b.MouseButton1Click:Connect(callback)
end

-- --- BOTONES ---
CreateBtn("AIMBOT (ON/OFF)", UDim2.new(0.05, 0, 0.1, 0), function()
    _G.Aimbot = not _G.Aimbot
    print("Aimbot: " .. tostring(_G.Aimbot))
end)

CreateBtn("ESP (ON/OFF)", UDim2.new(0.05, 0, 0.3, 0), function()
    _G.ESP = not _G.ESP
end)

CreateBtn("NOCLIP (ON/OFF)", UDim2.new(0.05, 0, 0.5, 0), function()
    _G.Noclip = not _G.Noclip
end)

CreateBtn("CERRAR", UDim2.new(0.05, 0, 0.75, 0), function()
    sg:Destroy()
end)

-- --- LÓGICA OPTIMIZADA (Aquí estaba el fallo) ---
-- Usamos un solo bucle para todo, así evitamos saturar a Potassium
RunService.Stepped:Connect(function()
    if not player.Character then return end
    
    -- Noclip
    if _G.Noclip then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- ESP & Aimbot (Solo cada 5 frames para no dar lag)
    if tick() % 0.1 < 0.02 then 
        if _G.ESP then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and not p.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end

        if _G.Aimbot then
            local target = nil
            local dist = 300
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                    local pos, vis = camera:WorldToViewportPoint(p.Character.Head.Position)
                    if vis then
                        local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                        if mag < dist then
                            target = p.Character.Head
                            dist = mag
                        end
                    end
                end
            end
            if target then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            end
        end
    end
end)
