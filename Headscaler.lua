-- ============================================
-- СКРИПТ ЖЁСТКОГО ТРОЛЛИНГА (SERVER-SIDE)
-- Delta Executor / Roblox
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- ============================================
-- ФУНКЦИИ ТРОЛЛИНГА
-- ============================================

-- 1. Бесконечный полёт (нокдаун)
local function FlyHack(target)
    if not target or not target.Character then return end
    local char = target.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if hrp and humanoid then
        humanoid.PlatformStand = true
        hrp.Velocity = Vector3.new(0, 50, 0)
        game:GetService("RunService").Heartbeat:Connect(function()
            if hrp and humanoid then
                hrp.Velocity = Vector3.new(0, 50, 0)
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, 0.1, 0)
            end
        end)
    end
end

-- 2. Спам звуков
local function SoundSpam(target)
    if not target then return end
    for i = 1, 20 do
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://9120149292" -- звук кек
        sound.Volume = 10
        sound.Parent = target.Character or target
        sound:Play()
        task.wait(0.1)
    end
end

-- 3. Взрыв эффект
local function Explode(target)
    if not target or not target.Character then return end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local explosion = Instance.new("Explosion")
        explosion.Position = hrp.Position
        explosion.BlastRadius = 30
        explosion.BlastPressure = 100000
        explosion.ExplosionType = Enum.ExplosionType.NoCraters
        explosion.Parent = workspace
        explosion:Destroy()
    end
end

-- 4. Обездвиживание
local function Freeze(target)
    if not target or not target.Character then return end
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid.PlatformStand = true
    end
end

-- 5. Ослепление (чёрный экран)
local function Blind(target)
    if not target then return end
    local gui = Instance.new("ScreenGui")
    gui.Parent = target.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(10, 0, 10, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0
    frame.Parent = gui
end

-- 6. Спам сообщений в чат
local function ChatSpam(target)
    for i = 1, 50 do
        game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer("/w " .. target.Name .. " ТЫ ТРОЛЛЕН!", "All")
        task.wait(0.05)
    end
end

-- 7. Переворот камеры
local function FlipCamera(target)
    if not target then return end
    local camera = workspace.CurrentCamera
    if camera then
        camera.CFrame = CFrame.new(camera.CFrame.Position) * CFrame.Angles(math.pi, 0, 0)
    end
end

-- 8. Спам частиц
local function ParticleSpam(target)
    if not target or not target.Character then return end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for i = 1, 30 do
            local particle = Instance.new("ParticleEmitter")
            particle.Parent = hrp
            particle.Rate = 1000
            particle.SpreadAngle = Vector2.new(360, 360)
            particle.Texture = "rbxassetid://3576956588"
            particle.Lifetime = NumberRange.new(5)
            particle.Speed = NumberRange.new(50)
            task.wait(0.1)
        end
    end
end

-- 9. Кнопка самоубийства
local function Kill(target)
    if not target or not target.Character then return end
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end

-- 10. Выкинуть из игры (краш)
local function Crash(target)
    if not target then return end
    for i = 1, 100 do
        local part = Instance.new("Part")
        part.Size = Vector3.new(1000, 1000, 1000)
        part.Position = Vector3.new(0, 0, 0)
        part.Anchored = true
        part.Transparency = 1
        part.Parent = workspace
        task.wait()
    end
end

-- ============================================
-- GUI ДЛЯ ТРОЛЛИНГА
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "🔥 ТРОЛЛ-ПАНЕЛЬ 🔥"
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

-- Поле ввода ника
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.9, 0, 0, 30)
nameBox.Position = UDim2.new(0.05, 0, 0.1, 0)
nameBox.PlaceholderText = "Ник цели"
nameBox.Text = ""
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 14
nameBox.Parent = mainFrame

-- Список кнопок
local buttons = {
    {"🚀 ПОЛЁТ", "fly"},
    {"🔊 ЗВУКИ", "sound"},
    {"💥 ВЗРЫВ", "explode"},
    {"🧊 ЗАМОРОЗКА", "freeze"},
    {"🌑 ОСЛЕПЛЕНИЕ", "blind"},
    {"💬 СПАМ ЧАТ", "chat"},
    {"🔄 ПЕРЕВОРОТ", "flip"},
    {"✨ ЧАСТИЦЫ", "particles"},
    {"💀 УБИТЬ", "kill"},
    {"💀 КРАШ", "crash"}
}

local function CreateButton(text, yPos, action)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = mainFrame
    
    btn.MouseButton1Click:Connect(function()
        local targetName = nameBox.Text
        if targetName == "" then
            print("❌ Введи ник!")
            return
        end
        
        local target = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if string.lower(plr.Name):find(string.lower(targetName)) then
                target = plr
                break
            end
        end
        
        if not target then
            print("❌ Игрок не найден: " .. targetName)
            return
        end
        
        print("🎯 Троллинг " .. target.Name .. " -> " .. text)
        
        if action == "fly" then FlyHack(target) end
        if action == "sound" then SoundSpam(target) end
        if action == "explode" then Explode(target) end
        if action == "freeze" then Freeze(target) end
        if action == "blind" then Blind(target) end
        if action == "chat" then ChatSpam(target) end
        if action == "flip" then FlipCamera(target) end
        if action == "particles" then ParticleSpam(target) end
        if action == "kill" then Kill(target) end
        if action == "crash" then Crash(target) end
    end)
end

-- Генерация кнопок
for i, data in ipairs(buttons) do
    local yPos = 0.18 + (i - 1) * 0.08
    CreateButton(data[1], yPos, data[2])
end

print("✅ Тролл-панель загружена!")
print("🔥 Введи ник и жми на кнопку для троллинга!")
