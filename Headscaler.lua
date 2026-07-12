-- ============================================
-- СКРИПТ УВЕЛИЧЕНИЯ ГОЛОВЫ (+ / -)
-- Delta Executor / Roblox
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Создаём GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0.5, -140, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔧 Увеличение головы"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Поле ввода ника
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(1, -20, 0, 30)
nameBox.Position = UDim2.new(0.05, 0, 0.25, 0)
nameBox.PlaceholderText = "Ник игрока"
nameBox.Text = player.Name
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 14
nameBox.Parent = frame

-- Контейнер для кнопок +/-
local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(1, 0, 0, 40)
btnContainer.Position = UDim2.new(0, 0, 0.5, 0)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = frame

-- Кнопка "-"
local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0.3, -10, 1, 0)
minusBtn.Position = UDim2.new(0.05, 0, 0, 0)
minusBtn.Text = "➖"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 24
minusBtn.Parent = btnContainer

-- Текущее значение
local valueLabel = Instance.new("TextLabel")
valueLabel.Size = UDim2.new(0.2, 0, 1, 0)
valueLabel.Position = UDim2.new(0.4, 0, 0, 0)
valueLabel.Text = "x1.0"
valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
valueLabel.BackgroundTransparency = 1
valueLabel.Font = Enum.Font.GothamBold
valueLabel.TextSize = 22
valueLabel.Parent = btnContainer

-- Кнопка "+"
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0.3, -10, 1, 0)
plusBtn.Position = UDim2.new(0.65, 0, 0, 0)
plusBtn.Text = "➕"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 24
plusBtn.Parent = btnContainer

-- Кнопка "Применить"
local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0.9, 0, 0, 35)
applyBtn.Position = UDim2.new(0.05, 0, 0.78, 0)
applyBtn.Text = "✅ Применить"
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 16
applyBtn.Parent = frame

-- Переменная размера
local currentValue = 1
local minValue = 0.5
local maxValue = 10

-- Обновление текста
local function UpdateLabel()
    valueLabel.Text = "x" .. string.format("%.1f", currentValue)
end

-- Кнопка "+"
plusBtn.MouseButton1Click:Connect(function()
    currentValue = math.min(currentValue + 0.5, maxValue)
    UpdateLabel()
end)

-- Кнопка "-"
minusBtn.MouseButton1Click:Connect(function()
    currentValue = math.max(currentValue - 0.5, minValue)
    UpdateLabel()
end)

-- ============================================
-- ФУНКЦИЯ ИЗМЕНЕНИЯ ГОЛОВЫ
-- ============================================

local function SetHeadScale(targetPlayer, scale)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local head = targetPlayer.Character:FindFirstChild("Head")
    if head then
        -- Меняем размер головы
        head.Size = Vector3.new(scale, scale, scale) * 2
        
        -- Для MeshPart и SpecialMesh
        for _, part in ipairs(head:GetChildren()) do
            if part:IsA("SpecialMesh") or part:IsA("MeshPart") then
                part.Scale = Vector3.new(scale, scale, scale)
            end
        end
    end
end

-- Применение
applyBtn.MouseButton1Click:Connect(function()
    local targetName = nameBox.Text
    local found = false
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name):find(string.lower(targetName)) then
            SetHeadScale(plr, currentValue)
            found = true
            break
        end
    end
    
    if found then
        print("✅ Голова " .. targetName .. " изменена на x" .. string.format("%.1f", currentValue))
    else
        print("❌ Игрок не найден: " .. targetName)
    end
end)

-- Автоприменение при спавне (для себя)
player.CharacterAdded:Connect(function()
    task.wait(0.2)
    SetHeadScale(player, currentValue)
end)

print("✅ Скрипт загружен! Используй + и - для изменения размера.")
