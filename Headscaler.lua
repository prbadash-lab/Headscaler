-- ============================================
-- СЕРВЕР-САЙД ТРОЛЛИНГ (Delta Executor)
-- Использует RemoteSpy и FireServer
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ============================================
-- ФУНКЦИЯ ДЛЯ ПОИСКА РЕМОУТОВ
-- ============================================

local function FindRemotes()
    local remotes = {}
    
    -- Поиск в ReplicatedStorage
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(remotes, v)
        end
    end
    
    -- Поиск в Workspace
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            table.insert(remotes, v)
        end
    end
    
    -- Поиск в Players
    for _, plr in ipairs(Players:GetPlayers()) do
        for _, v in ipairs(plr:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                table.insert(remotes, v)
            end
        end
    end
    
    return remotes
end

-- ============================================
-- АВТОМАТИЧЕСКИЙ СПАМ РЕМОУТОВ
-- ============================================

local function SpamRemotes(targetName)
    local remotes = FindRemotes()
    local target = nil
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name):find(string.lower(targetName)) then
            target = plr
            break
        end
    end
    
    if not target then
        print("❌ Игрок не найден")
        return
    end
    
    print("🔍 Найдено ремоутов: " .. #remotes)
    
    -- Спам на все ремоуты
    for _, remote in ipairs(remotes) do
        if remote:IsA("RemoteEvent") then
            -- Пробуем разные варианты аргументов
            local args = {
                target,
                target.Character,
                target.Character and target.Character:FindFirstChild("HumanoidRootPart"),
                "kick",
                "ban",
                "kill",
                target.Name,
                target.UserId
            }
            
            for _, arg in ipairs(args) do
                pcall(function()
                    remote:FireServer(arg)
                    print("✅ Отправлено в " .. remote.Name)
                end)
            end
        elseif remote:IsA("RemoteFunction") then
            pcall(function()
                remote:InvokeServer(target)
                print("✅ Invoked " .. remote.Name)
            end)
        end
    end
end

-- ============================================
-- КИК ЧЕРЕЗ REMOTE
-- ============================================

local function KickPlayer(targetName)
    local target = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name):find(string.lower(targetName)) then
            target = plr
            break
        end
    end
    
    if not target then return end
    
    -- Поиск ремоута для кика
    local kickRemote = nil
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and string.lower(v.Name):find("kick") then
            kickRemote = v
            break
        end
    end
    
    if kickRemote then
        pcall(function()
            kickRemote:FireServer(target)
            print("✅ Кик отправлен")
        end)
    end
end

-- ============================================
-- ФЛУД КОМАНД В ЧАТ
-- ============================================

local function ChatFlood(targetName)
    local target = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if string.lower(plr.Name):find(string.lower(targetName)) then
            target = plr
            break
        end
    end
    
    if not target then return end
    
    local chatRemote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatRemote then
        local sayRemote = chatRemote:FindFirstChild("SayMessageRequest")
        if sayRemote then
            for i = 1, 100 do
                pcall(function()
                    sayRemote:FireServer("/w " .. target.Name .. " ТЫ ТРОЛЛЕН!", "All")
                end)
                task.wait(0.01)
            end
            print("✅ Чат-флуд запущен")
        end
    end
end

-- ============================================
-- GUI
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🔥 СЕРВЕР-ТРОЛЛИНГ 🔥"
title.TextColor3 = Color3.fromRGB(255, 50, 50)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.9, 0, 0, 30)
nameBox.Position = UDim2.new(0.05, 0, 0.25, 0)
nameBox.PlaceholderText = "Ник цели"
nameBox.Text = ""
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 14
nameBox.Parent = frame

local btn1 = Instance.new("TextButton")
btn1.Size = UDim2.new(0.4, 0, 0, 30)
btn1.Position = UDim2.new(0.05, 0, 0.55, 0)
btn1.Text = "🔍 СПАМ РЕМОУТ"
btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
btn1.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
btn1.Font = Enum.Font.GothamBold
btn1.TextSize = 12
btn1.Parent = frame

btn1.MouseButton1Click:Connect(function()
    local target = nameBox.Text
    if target == "" then
        print("❌ Введи ник")
        return
    end
    SpamRemotes(target)
end)

local btn2 = Instance.new("TextButton")
btn2.Size = UDim2.new(0.4, 0, 0, 30)
btn2.Position = UDim2.new(0.55, 0, 0.55, 0)
btn2.Text = "💬 ФЛУД ЧАТ"
btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
btn2.BackgroundColor3 = Color3.fromRGB(200, 150, 30)
btn2.Font = Enum.Font.GothamBold
btn2.TextSize = 12
btn2.Parent = frame

btn2.MouseButton1Click:Connect(function()
    local target = nameBox.Text
    if target == "" then
        print("❌ Введи ник")
        return
    end
    ChatFlood(target)
end)

local btn3 = Instance.new("TextButton")
btn3.Size = UDim2.new(0.9, 0, 0, 30)
btn3.Position = UDim2.new(0.05, 0, 0.75, 0)
btn3.Text = "👢 КИК (если есть remote)"
btn3.TextColor3 = Color3.fromRGB(255, 255, 255)
btn3.BackgroundColor3 = Color3.fromRGB(200, 30, 150)
btn3.Font = Enum.Font.GothamBold
btn3.TextSize = 12
btn3.Parent = frame

btn3.MouseButton1Click:Connect(function()
    local target = nameBox.Text
    if target == "" then
        print("❌ Введи ник")
        return
    end
    KickPlayer(target)
end)

print("=====================================")
print("🔥 СЕРВЕР-САЙД ТРОЛЛИНГ ЗАГРУЖЕН")
print("=====================================")
print("📌 Инструкция:")
print("1. Введи ник цели")
print("2. Нажми 'СПАМ РЕМОУТ' - попытается найти и заспамить все ремоуты")
print("3. 'ФЛУД ЧАТ' - заспамит в личку")
print("4. 'КИК' - попытается кикнуть через remote")
print("=====================================")
print("⚠️ Работает только если игра использует ремоуты без проверок")
