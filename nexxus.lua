-- 🧠 TAPIS EQUIP AUTO TP - BEAUTIFUL UI + ESP LINE 🧠
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local basePosition = nil
local espLine = nil
local espConnection = nil

pcall(function()
    player.PlayerGui:FindFirstChild("BrainrotAutoTP"):Destroy()
end)

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotAutoTP"
gui.Parent = player.PlayerGui

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0.5, -125, 0.3, 0)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.new(1, 0.4, 1)
stroke.Thickness = 2
stroke.Parent = frame

-- Titre
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.new(0.8, 0.2, 0.8)
title.Text = "🧠 TAPIS EQUIP TP 🧠"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Sous-titre
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.BackgroundTransparency = 1
subtitle.Text = "✨ Equip tapis to TP... ✨"
subtitle.TextColor3 = Color3.new(0.7, 0.7, 1)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = frame

-- Bouton SET BASE
local setBtn = Instance.new("TextButton")
setBtn.Size = UDim2.new(0.8, 0, 0, 30)
setBtn.Position = UDim2.new(0.1, 0, 0, 70)
setBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
setBtn.Text = "💾 SET BASE POSITION"
setBtn.TextColor3 = Color3.new(1, 1, 1)
setBtn.TextSize = 14
setBtn.Font = Enum.Font.GothamBold
setBtn.Parent = frame

local setBtnCorner = Instance.new("UICorner")
setBtnCorner.CornerRadius = UDim.new(0, 8)
setBtnCorner.Parent = setBtn

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 15)
status.Position = UDim2.new(0, 0, 0, 105)
status.BackgroundTransparency = 1
status.Text = "⚡ Equip tapis in hands = TP!"
status.TextColor3 = Color3.new(0, 1, 0.5)
status.TextSize = 10
status.Font = Enum.Font.Gotham
status.Parent = frame

-- ESP Line
local function updateESPLine()
    if not basePosition then return end
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local playerPos = char.HumanoidRootPart.Position
    local distance = (playerPos - basePosition).Magnitude
    
    if espLine then
        espLine:Destroy()
    end
    
    espLine = Instance.new("Part")
    espLine.Name = "ESPLine"
    espLine.Anchored = true
    espLine.CanCollide = false
    espLine.Material = Enum.Material.Neon
    espLine.BrickColor = BrickColor.new("Bright orange")
    espLine.Size = Vector3.new(0.3, 0.3, distance)
    espLine.CFrame = CFrame.lookAt(playerPos:Lerp(basePosition, 0.5), basePosition)
    espLine.Parent = workspace
end

local function startESP()
    if espConnection then
        espConnection:Disconnect()
    end
    espConnection = RunService.Heartbeat:Connect(updateESPLine)
end

-- DETECTION DU TAPIS ÉQUIPÉ
local function isTapis(tool)
    if not tool or not tool:IsA("Tool") then return false end
    
    local toolName = tool.Name:lower()
    
    -- Noms possibles pour le tapis
    local tapisNames = {
        "tapis",
        "carpet",
        "rug",
        "mat",
        "flying carpet",
        "magic carpet",
        "tapis volant"
    }
    
    for _, name in pairs(tapisNames) do
        if toolName:find(name) then
            return true
        end
    end
    
    return false
end

-- AUTO TP fonction
local function autoSteal()
    if basePosition then
        spawn(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                
                for i = 1, 3 do
                    hrp.CFrame = CFrame.new(basePosition)
                    wait(0.01)
                end
                
                subtitle.Text = "🔥 TAPIS EQUIPPED! TP! 🔥"
                subtitle.TextColor3 = Color3.new(1, 0.5, 0)
                status.Text = "🚀 Teleported to base!"
                status.TextColor3 = Color3.new(1, 0, 1)
                
                wait(2)
                subtitle.Text = "✨ Equip tapis to TP... ✨"
                subtitle.TextColor3 = Color3.new(0.7, 0.7, 1)
                status.Text = "⚡ Equip tapis in hands = TP!"
                status.TextColor3 = Color3.new(0, 1, 0.5)
            end
        end)
    end
end

-- Set Base Position
setBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        basePosition = char.HumanoidRootPart.Position
        startESP()
        
        setBtn.Text = "✅ BASE + ESP ACTIVE!"
        setBtn.BackgroundColor3 = Color3.new(0, 1, 0)
        
        spawn(function()
            wait(2)
            setBtn.Text = "💾 SET BASE POSITION"
            setBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
        end)
    end
end)

-- DETECTION QUAND TU ÉQUIPES LE TAPIS (dans tes mains)
player.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(child)
        if isTapis(child) then
            print("✅ TAPIS EQUIPPED IN HANDS: " .. child.Name)
            autoSteal()
        end
    end)
end)

if player.Character then
    player.Character.ChildAdded:Connect(function(child)
        if isTapis(child) then
            print("✅ TAPIS EQUIPPED IN HANDS: " .. child.Name)
            autoSteal()
        end
    end)
end

print("🧠 TAPIS EQUIP AUTO TP LOADED!")
print("✅ Equip tapis in your hands = instant TP!")
