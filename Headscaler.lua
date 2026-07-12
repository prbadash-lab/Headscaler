-- ============================================
-- СКРИПТ УВЕЛИЧЕНИЯ ГОЛОВЫ (Delta Executor / Roblox)
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Создаём GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 100)
frame.Position = UDim2.new(0.5, -150, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "Увеличение головы"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Parent = frame

-- Поле для ника
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.6, 0, 0, 25)
nameBox.Position = UDim2.new(0.05, 0, 0.35, 0)
nameBox.PlaceholderText = "Ник игрока"
nameBox.Text = player.Name
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
nameBox.Parent = frame

-- Ползунок
local slider = Instance.new("Slider")
slider.Size = UDim2.new(0.6, 0, 0, 25)
slider.Position = UDim2.new(0.05, 0, 0.7, 0)
slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
slider.Min = 0.5
slider.Max = 10
slider.Value = 1
slider.Parent = frame

-- Значение ползунка
local valueLabel = Instance.new("TextLabel")
valueLabel.Size = UDim2.new(0.2, 0, 0, 25)
valueLabel.Position = UDim2.new(0.75, 0, 0.7, 0)
valueLabel.Text = "x1.0"
valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
valueLabel.BackgroundTransparency = 1
valueLabel.Parent = frame

-- Кнопка применения
local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0.2, 0, 0, 25)
applyBtn.Position = UDim2.new(0.75, 0, 0.35, 0)
applyBtn.Text = "Применить"
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
applyBtn.Parent = frame

-- Обновление значения на ползунке
slider:GetPropertyChangedSignal("Value"):Connect(function()
    valueLabel.Text = "x" .. string.format("%.1f", slider.Value)
end)

-- Функция изменения головы
local function SetHeadScale(targetPlayer, scale)
    if not targetPlayer or not targetPlayer.Character then return end
    local head = targetPlayer.Character:FindFirstChild("Head")
    if head then
        head.Size = Vector3.new(scale, scale, scale) * 2
        -- Для MeshPart (если используется)
        for _, part in ipairs(head:GetChildren()) do
            if part:IsA("SpecialMesh") or part:IsA("MeshPart") then
                part.Scale = Vector3.new(scale, scale, scale)
            end
        end
    end
end

-- Применение по кнопке
applyBtn.MouseButton1Click:Connect(function()
    local targetName = nameBox.Text
    local scale = slider.Value
    local found = false
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name):find(string.lower(targetName)) then
            SetHeadScale(plr, scale)
            found = true
            break
        end
    end
    
    if not found then
        print("Игрок не найден: " .. targetName)
    end
end)

-- Автоприменение для себя при спавне
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    task.wait(0.1)
    local scale = slider.Value
    if scale ~= 1 then
        SetHeadScale(player, scale)
    end
end)

print("Скрипт загружен! Открой GUI и увеличь голову.")
