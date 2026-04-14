-- 🌷 Dandy's World SAFE OP HUB - Noah Edition (FULL AUTO PLAY UPDATE 2026)
print("🌷 Noah's Hub with GUI Loaded 🔥 - FULL AUTO FARM MODE ADDED")

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NoahHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 480)
frame.Position = UDim2.new(0.5, -140, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
title.Text = "Noah's Dandy's World OP Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createToggle(name, yPos, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.9, 0, 0, 40)
    toggle.Position = UDim2.new(0.05, 0, 0, yPos)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.Text = name .. ": " .. (default and "ON" or "OFF")
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.Gotham
    toggle.Parent = frame
    
    local enabled = default
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.Text = name .. ": " .. (enabled and "ON" or "OFF")
        callback(enabled)
    end)
    callback(default)
end

-- ==================== FEATURES ====================

createToggle("God Mode", 60, true, function(state)
    getgenv().GodMode = state
end)

createToggle("Anti-Twisted", 110, true, function(state)
    getgenv().AntiTwisted = state
end)

createToggle("Auto Farm (FULL AUTO PLAY)", 160, true, function(state)
    getgenv().AutoFarm = state
end)

createToggle("Auto Tapes/Items", 210, true, function(state)
    getgenv().AutoTapes = state
end)

createToggle("Kill Aura", 260, true, function(state)
    getgenv().KillAura = state
end)

createToggle("Auto Research Capsules", 310, true, function(state)
    getgenv().AutoCapsules = state
end)

createToggle("Auto Skill Check", 360, true, function(state)
    getgenv().AutoSkillCheck = state
end)

-- ==================== MAIN LOOPS ====================

-- God Mode
spawn(function()
    while wait(0.1) do
        if getgenv().GodMode then
            pcall(function()
                local char = player.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.MaxHealth = 999999
                        hum.Health = 999999
                        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                    end
                end
            end)
        end
    end
end)

-- Anti-Twisted
spawn(function()
    while wait(0.3) do
        if getgenv().AntiTwisted then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                        local root = v.HumanoidRootPart
                        root.CanCollide = false
                        for _, part in pairs(v:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                                part.Transparency = 0.7
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Farm (ProximityPrompts - machines, extractors, etc.)
spawn(function()
    while wait(0.15) do
        if getgenv().AutoFarm then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled then
                        fireproximityprompt(v)
                    end
                end
            end)
        end
    end
end)

-- Auto Tapes / Items
spawn(function()
    while wait(0.2) do
        if getgenv().AutoTapes then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart

                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("tape") or v.Name:lower():find("item") or v.Name:lower():find("collect") then
                        if v:IsA("BasePart") or v:FindFirstChild("TouchInterest") then
                            firetouchinterest(root, v, 0)
                            wait(0.05)
                            firetouchinterest(root, v, 1)
                        elseif v:FindFirstChildWhichIsA("ProximityPrompt") then
                            fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt"))
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Research Capsules (for research farming)
spawn(function()
    while wait(0.22) do
        if getgenv().AutoCapsules then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart

                for _, v in pairs(workspace:GetDescendants()) do
                    if (v.Name:lower():find("capsule") or v.Name:lower():find("research")) and not v.Name:lower():find("rodger") then
                        if v:IsA("BasePart") or v:FindFirstChild("TouchInterest") then
                            firetouchinterest(root, v, 0)
                            wait(0.05)
                            firetouchinterest(root, v, 1)
                        elseif v:FindFirstChildWhichIsA("ProximityPrompt") then
                            fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt"))
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Skill Check (detects skill check GUI and auto-presses Space - works on current 2026 machines)
spawn(function()
    local vim = game:GetService("VirtualInputManager")
    while wait(0.08) do
        if getgenv().AutoSkillCheck then
            pcall(function()
                local pgui = player:FindFirstChild("PlayerGui")
                if pgui then
                    for _, g in pairs(pgui:GetDescendants()) do
                        if g:IsA("Frame") and g.Visible and (g.Name:lower():find("skill") or g.Name:lower():find("check") or g.Name:lower():find("machine")) then
                            vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                            wait(0.04)
                            vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- Kill Aura
spawn(function()
    while wait(0.25) do
        if getgenv().KillAura then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart

                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                        local dist = (root.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist < 35 then
                            v:Destroy()
                        end
                    end
                end
            end)
        end
    end
end)

-- 🔥 FULL AUTO PLAY LOGIC (when "Auto Farm (FULL AUTO PLAY)" is ON)
-- This makes the script literally PLAY the game for you:
-- • Auto-collects everything
-- • Triggers research encounters by getting seen by twisteds
-- • Immediately runs/hides away after
-- • Constantly runs away if any twisted gets too close
spawn(function()
    local lastEncounter = 0
    while wait(0.25) do
        if getgenv().AutoFarm then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart

                -- 1. EVASION: Run away if ANY twisted is too close
                local closestTwisted = nil
                local closestDist = math.huge
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                        local dist = (root.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestTwisted = v
                        end
                    end
                end

                if closestTwisted and closestDist < 35 then
                    local fleeDir = (root.Position - closestTwisted.HumanoidRootPart.Position).Unit * 120
                    root.CFrame = CFrame.new(root.Position + fleeDir + Vector3.new(0, 25, 0))
                end

                -- 2. RESEARCH ENCOUNTER (get seen by twisted once per floor for 5-10% research)
                -- Happens automatically every ~25 seconds
                if tick() - lastEncounter > 25 then
                    local targetTwisted = nil
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                            targetTwisted = v
                            break
                        end
                    end

                    if targetTwisted then
                        local twRoot = targetTwisted.HumanoidRootPart
                        -- Blink CLOSE to trigger "seen/encounter"
                        local approachPos = twRoot.Position + (root.Position - twRoot.Position).Unit * 13
                        root.CFrame = CFrame.new(approachPos)
                        wait(1.6) -- time for research to register
                        -- Then instantly hide/run far away
                        local fleeDir = (root.Position - twRoot.Position).Unit * 140
                        root.CFrame = CFrame.new(root.Position + fleeDir + Vector3.new(0, 30, 0))
                        lastEncounter = tick()
                    end
                end
            end)
        end
    end
end)

print("✅ GUI Loaded! FULL AUTO FARM is now active!")
print("💡 HOW TO USE FULL AUTO PLAY:")
print("   • Turn ON: God Mode + Anti-Twisted + Auto Farm + Auto Capsules + Auto Skill Check")
print("   • Turn OFF Kill Aura (so twisteds stay alive for research encounters)")
print("   • The script will now farm machines, collect tapes/capsules, do skill checks,")
print("     intentionally get seen by twisteds for research, then auto-run/hide every time.")
print("   Drag the GUI anywhere. Enjoy free research & ichor! 🌷")
