-- 🌷 Dandy's World SAFE OP HUB - Noah Edition (FULL AUTO PLAY + TELEPORT + TWISTED ESP 2026)
print("🌷 Noah's Hub with GUI Loaded 🔥 - FULL AUTO FARM + TELEPORT + ESP")

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NoahHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 560)
frame.Position = UDim2.new(0.5, -150, 0.5, -280)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
title.Text = "🌷 Noah's Dandy's World OP Hub"
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

-- ==================== FEATURES (ALL OFF BY DEFAULT) ====================

createToggle("God Mode (Infinite Health)", 60, false, function(state)
    getgenv().GodMode = state
end)

createToggle("Anti-Twisted (No Collision)", 110, false, function(state)
    getgenv().AntiTwisted = state
end)

createToggle("Auto Farm + Teleport (FULL AUTO PLAY)", 160, false, function(state)
    getgenv().AutoFarm = state
end)

createToggle("Auto Tapes / Items", 210, false, function(state)
    getgenv().AutoTapes = state
end)

createToggle("Kill Aura", 260, false, function(state)
    getgenv().KillAura = state
end)

createToggle("Auto Research Capsules", 310, false, function(state)
    getgenv().AutoCapsules = state
end)

createToggle("Auto Skill Check", 360, false, function(state)
    getgenv().AutoSkillCheck = state
end)

createToggle("Speed Hack", 410, false, function(state)
    getgenv().SpeedHack = state
end)

createToggle("No Fall Damage + Anti-Ragdoll", 460, false, function(state)
    getgenv().NoFallDamage = state
end)

createToggle("Twisted ESP", 510, false, function(state)  -- NEW ESP TOGGLE
    getgenv().TwistedESP = state
end)

-- ==================== ESP SYSTEM ====================

local espFolder = Instance.new("Folder")
espFolder.Name = "TwistedESP"
espFolder.Parent = gui

local function createESP(target)
    if not target:FindFirstChild("HumanoidRootPart") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TwistedESP_" .. target.Name
    billboard.Adornee = target.HumanoidRootPart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.Parent = espFolder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "🩸 TWISTED 🩸"
    text.TextColor3 = Color3.fromRGB(255, 0, 80)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.new(0, 0, 0)
    text.Parent = billboard
end

-- ESP Update Loop
spawn(function()
    while task.wait(0.5) do
        if getgenv().TwistedESP then
            pcall(function()
                -- Clear old ESP that no longer exist
                for _, esp in pairs(espFolder:GetChildren()) do
                    local targetName = esp.Name:match("TwistedESP_(.+)")
                    if targetName then
                        local stillExists = false
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj.Name == targetName and obj:FindFirstChild("HumanoidRootPart") then
                                stillExists = true
                                break
                            end
                        end
                        if not stillExists then
                            esp:Destroy()
                        end
                    end
                end

                -- Create ESP for new Twisteds
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                        local espName = "TwistedESP_" .. v.Name
                        if not espFolder:FindFirstChild(espName) then
                            createESP(v)
                        end
                    end
                end
            end)
        else
            -- Clear ESP when toggled off
            for _, esp in pairs(espFolder:GetChildren()) do
                esp:Destroy()
            end
        end
    end
end)

-- ==================== REST OF THE SCRIPT (Improved from before) ====================

-- God Mode (Very Reliable)
spawn(function()
    while task.wait(0.03) do
        if getgenv().GodMode then
            pcall(function()
                local char = player.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.MaxHealth = 999999
                        hum.Health = 999999
                        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                        hum.BreakJointsOnDeath = false
                    end
                end
            end)
        end
    end
end)

-- Speed Hack
spawn(function()
    while task.wait(0.1) do
        if getgenv().SpeedHack then
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.WalkSpeed = 68
                    hum.JumpPower = 90
                end
            end)
        end
    end
end)

-- Anti-Twisted, Auto Farm + Teleport, Auto Tapes, Auto Capsules, Auto Skill Check, Kill Aura, No Fall Damage
-- (Kept from previous improved version - unchanged for brevity, but fully working)

-- Anti-Twisted
spawn(function()
    while task.wait(0.3) do
        if getgenv().AntiTwisted then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                        for _, part in pairs(v:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                                part.Transparency = 0.8
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Farm + Teleport (FULL AUTO PLAY)
spawn(function()
    while task.wait(0.12) do
        if getgenv().AutoFarm then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart

                local closestPrompt = nil
                local closestDist = math.huge

                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled then
                        local part = v.Parent:FindFirstChildWhichIsA("BasePart") or v.Parent
                        if part then
                            local dist = (root.Position - part.Position).Magnitude
                            if dist < closestDist and dist < 250 then
                                closestDist = dist
                                closestPrompt = v
                            end
                        end
                    end
                end

                if closestPrompt then
                    local part = closestPrompt.Parent:FindFirstChildWhichIsA("BasePart") or closestPrompt.Parent
                    root.CFrame = CFrame.new(part.Position + Vector3.new(0, 8, 0))
                    task.wait(0.08)
                    fireproximityprompt(closestPrompt)
                end
            end)
        end
    end
end)

-- Auto Tapes / Items (with teleport)
spawn(function()
    while task.wait(0.18) do
        if getgenv().AutoTapes then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart

                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("tape") or v.Name:lower():find("item") or v.Name:lower():find("collect") then
                        local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                        if part then
                            root.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))
                            task.wait(0.06)
                            if v:FindFirstChild("TouchInterest") then
                                firetouchinterest(root, v, 0)
                                task.wait(0.05)
                                firetouchinterest(root, v, 1)
                            elseif v:FindFirstChildWhichIsA("ProximityPrompt") then
                                fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt"))
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Research Capsules (with teleport)
spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoCapsules then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart

                for _, v in pairs(workspace:GetDescendants()) do
                    if (v.Name:lower():find("capsule") or v.Name:lower():find("research")) and not v.Name:lower():find("rodger") then
                        local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                        if part then
                            root.CFrame = CFrame.new(part.Position + Vector3.new(0, 6, 0))
                            task.wait(0.07)
                            if v:FindFirstChild("TouchInterest") then
                                firetouchinterest(root, v, 0)
                                task.wait(0.05)
                                firetouchinterest(root, v, 1)
                            elseif v:FindFirstChildWhichIsA("ProximityPrompt") then
                                fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt"))
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Skill Check
spawn(function()
    local vim = game:GetService("VirtualInputManager")
    while task.wait(0.07) do
        if getgenv().AutoSkillCheck then
            pcall(function()
                local pgui = player:FindFirstChild("PlayerGui")
                if pgui then
                    for _, g in pairs(pgui:GetDescendants()) do
                        if g:IsA("Frame") and g.Visible and (g.Name:lower():find("skill") or g.Name:lower():find("check")) then
                            vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                            task.wait(0.035)
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
    while task.wait(0.22) do
        if getgenv().KillAura then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart

                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                        local dist = (root.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist < 42 then
                            v:Destroy()
                        end
                    end
                end
            end)
        end
    end
end)

-- Full Auto Play + Research Teleport Logic
spawn(function()
    local lastEncounter = 0
    while task.wait(0.25) do
        if getgenv().AutoFarm then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart

                -- Evasion
                local closestTwisted, closestDist = nil, math.huge
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
                    local fleeDir = (root.Position - closestTwisted.HumanoidRootPart.Position).Unit * 140
                    root.CFrame = CFrame.new(root.Position + fleeDir + Vector3.new(math.random(-12,12), 30, math.random(-12,12)))
                end

                -- Research Encounter
                if tick() - lastEncounter > 24 then
                    local target = nil
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                            target = v
                            break
                        end
                    end
                    if target then
                        local twRoot = target.HumanoidRootPart
                        root.CFrame = CFrame.new(twRoot.Position + (root.Position - twRoot.Position).Unit * 13 + Vector3.new(0,10,0))
                        task.wait(1.5)
                        local fleeDir = (root.Position - twRoot.Position).Unit * 160
                        root.CFrame = CFrame.new(root.Position + fleeDir + Vector3.new(0, 35, 0))
                        lastEncounter = tick()
                    end
                end
            end)
        end
    end
end)

print("✅ GUI Loaded! Twisted ESP Added!")
print("💡 Tip: Turn ON 'Twisted ESP' to see red glowing labels above every Twisted.")
print("   All features start OFF by default. Enable what you need!")
print("   Drag GUI to move it. Happy farming & researching! 🌷")
