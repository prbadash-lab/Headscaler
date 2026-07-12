-- ============================================
-- ЗАМОРОЗКА ПОДРУГИ
-- ============================================

local targetName = "ИМЯ_ПОДРУГИ"

local target = nil
for _, plr in ipairs(game.Players:GetPlayers()) do
    if string.lower(plr.Name):find(string.lower(targetName)) then
        target = plr
        break
    end
end

if target and target.Character then
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid.PlatformStand = true
        print("❄️ Подруга заморожена!")
    end
end
