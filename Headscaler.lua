-- ============================================
-- СКРИПТ УВЕЛИЧЕНИЯ ГОЛОВЫ (Delta Executor)
-- С НАСТОЯЩИМ ПОЛЗУНКОМ
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Создаём GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 150)
frame.Position = UDim2.new(0.5, -160, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BackgroundTransparency = 0.15
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
nameBox.Size = UDim2.new(0.5, -10, 0, 30)
nameBox.Position = UDim2.new(0.05, 0, 0.3, 0)
nameBox.PlaceholderText = "Ник игрока"
nameBox.Text = player.Name
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 14
nameBox.Parent = frame

-- Кнопка "Применить"
local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0.35, 0, 0, 30)
applyBtn.Position = UDim2.new(0.6, 0, 0.3, 0)
applyBtn.Text = "✅ Применить"
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 14
applyBtn.Parent = frame

-- ============================================
-- НАСТОЯЩИЙ ПОЛЗУНОК (Slider)
-- ============================================

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(0.8, 0, 0, 8)
sliderTrack.Position = UDim2.new(0.1, 0, 0.7, 0)
sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = frame

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.Position = UDim2.new(0.5, -10, 0.5, -10)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderTrack

-- Значение ползунка
local valueLabel = Instance.new("TextLabel")
valueLabel.Size = UDim2.new(0.2, 0, 0, 25)
valueLabel.Position = UDim2.new(0.75, 0, 0.65, 0)
valueLabel.Text = "x1.0"
valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
valueLabel.BackgroundTransparency = 1
valueLabel.Font = Enum.Font.GothamBold
valueLabel.TextSize = 16
valueLabel.Parent = frame

-- Переменные для ползунка
local dragging = false
local minValue = 0.5
local maxValue = 10
local currentValue = 1

local function UpdateSlider(inputPos)
    local trackSize = sliderTrack.AbsoluteSize.X
    if trackSize <= 0 then return end
    
    local relativeX = math.clamp((inputPos.X - sliderTrack.AbsolutePosition.X) / trackSize, 0, 1)
    currentValue = minValue + (maxValue - minValue) * relativeX
    currentValue = math.round(currentValue * 10) / 10
    
    sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
    sliderButton.Position = UDim2.new(relativeX, -10, 0.5, -10)
    valueLabel.Text = "x" .. string.format("%.1f", currentValue)
end

-- Нажатие на ползунок
sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

-- Перетаскивание
sliderTrack.MouseButton1Down:Connect(function(x, y)
    UpdateSlider(Vector2.new(x, y) + sliderTrack.AbsolutePosition)
    dragging = true
end)

-- Отпускание
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Обновление при движении мыши
game:GetService("RunService").RenderStepped:Connect(function()
    if dragging then
        local mouse = player:GetMouse()
        if mouse then
            UpdateSlider(mouse.X)
        end
    end
end)

-- ============================================
-- ФУНКЦИЯ ИЗМЕНЕНИЯ ГОЛОВЫ
-- ============================================

local function SetHeadScale(targetPlayer, scale)
    if not targetPlayer or not targetPlayer.Character then return end
    local head = targetPlayer.Character:FindFirstChild("Head")
    if head then
        -- Меняем размер
        head.Size = Vector3.new(scale, scale, scale) * 2
        
        -- Для MeshPart
        for _, part in ipairs(head:GetChildren()) do
            if part:IsA("SpecialMesh") then
                part.Scale = Vector3.new(scale, scale, scale)
            elseif part:IsA("MeshPart") then
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
    
    if not found then
        print("❌ Игрок не найден: " .. targetName)
    else
        print("✅ Голова изменена на x" .. string.format("%.1f", currentValue))
    end
end)

-- Автоприменение при спавне
player.CharacterAdded:Connect(function()
    task.wait(0.2)
    SetHeadScale(player, currentValue)
end)

print("✅ Скрипт загружен! Перетаскивай ползунок и жми 'Применить'.")nameBox.PlaceholderText = "Ник игрока"
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
