--[[
    Скрипт для увеличения головы игрока по нику (Delta / Garry's Mod)
    Использование: 
        - В консоли: head_scale <ник> <значение_от_1_до_10>
        - Или через меню (привязано к клавише F4 по умолчанию)
]]

local PLAYER_META = FindMetaTable("Player")
if not PLAYER_META then return end

-- Хранилище масштабов
local headScales = {}

-- Функция применения масштаба
local function SetHeadScale(ply, scale)
    if not IsValid(ply) then return end
    scale = math.Clamp(scale, 0.5, 10.0)
    headScales[ply:SteamID()] = scale
    
    -- Применяем через модельку (бонусная кость "ValveBiped.Bip01_Head1")
    ply:SetNWFloat("HeadScale", scale)
    
    -- Принудительное обновление для клиента
    net.Start("UpdateHeadScale")
    net.WriteEntity(ply)
    net.WriteFloat(scale)
    net.Broadcast()
end

-- Хук на спавн игрока
hook.Add("PlayerSpawn", "RestoreHeadScale", function(ply)
    local sid = ply:SteamID()
    if headScales[sid] then
        timer.Simple(0.5, function()
            if IsValid(ply) then
                SetHeadScale(ply, headScales[sid])
            end
        end)
    end
end)

-- Команда для изменения размера головы
concommand.Add("head_scale", function(caller, args)
    if not IsValid(caller) then return end
    local targetName = args[1]
    local scale = tonumber(args[2]) or 1.0
    
    if not targetName then
        caller:PrintMessage(HUD_PRINTTALK, "Использование: head_scale <ник игрока> <значение (0.5 - 10)>")
        return
    end
    
    local found = false
    for _, ply in ipairs(player.GetAll()) do
        if string.find(string.lower(ply:Name()), string.lower(targetName)) then
            SetHeadScale(ply, scale)
            caller:PrintMessage(HUD_PRINTTALK, "Голова " .. ply:Name() .. " установлена на x" .. string.format("%.2f", scale))
            found = true
            break
        end
    end
    
    if not found then
        caller:PrintMessage(HUD_PRINTTALK, "Игрок не найден: " .. targetName)
    end
end)

-- Клиентский Net-обработчик
if CLIENT then
    net.Receive("UpdateHeadScale", function()
        local ply = net.ReadEntity()
        local scale = net.ReadFloat()
        if IsValid(ply) then
            ply:SetNWFloat("HeadScale", scale)
        end
    end)
    
    -- Хук для рендера головы (изменение размера)
    hook.Add("Think", "ApplyHeadScaleClient", function()
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) and ply:GetNWFloat("HeadScale", 1.0) ~= 1.0 then
                local scale = ply:GetNWFloat("HeadScale", 1.0)
                -- Применяем через бонусную кость
                ply:SetBoneScale(ply:LookupBone("ValveBiped.Bip01_Head1"), scale)
            end
        end
    end)
end

-- Создание простого слайдера (через консольную переменную)
CreateConVar("head_scale_slider", "1.0", {FCVAR_ARCHIVE})
cvars.AddChangeCallback("head_scale_slider", function(name, old, new)
    local ply = LocalPlayer()
    if IsValid(ply) then
        RunConsoleCommand("head_scale", ply:Name(), new)
    end
end)

-- Инструкция в консоль
print("=====================================")
print("[Ryzen] Скрипт увеличения головы")
print("Команда: head_scale <ник> <0.5-10>")
print("Слайдер: head_scale_slider (в консоли)")
print("=====================================")

-- Бинд на F4 для открытия слайдера (клиент)
if CLIENT then
    hook.Add("PlayerBindPress", "HeadScaleBind", function(ply, bind)
        if bind == "F4" then
            ply:PrintMessage(HUD_PRINTTALK, "Введите head_scale_slider в консоли для регулировки")
            return true
        end
    end)
end
