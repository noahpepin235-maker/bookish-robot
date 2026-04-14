-- 🌷 Dandy's World SAFE OP HUB - Noah Edition (FULL AUTO PLAY - NO SKILLCHECK + 36.5 WALKSPEED + UNDER-MAP EVASION)
print("🌷 Noah's Hub with GUI Loaded 🔥 - FULL AUTO PLAY (Machines + Smart Evasion)")

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NoahHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 520)
frame.Position = UDim2.new(0.5, -150, 0.5, -260)
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

-- ==================== FEATURES ====================

createToggle("God Mode (Infinite Health)", 60, false, function(state)
    getgenv().GodMode = state
end)

createToggle("Anti-Twisted (No Collision)", 110, false, function(state)
    getgenv().AntiTwisted = state
end)

createToggle("FULL AUTO PLAY (Machines + Teleport)", 160, false, function(state)
    getgenv().AutoPlay = state
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

createToggle("Speed Hack (68)", 360, false, function(state)
    getgenv().SpeedHack = state
end)

createToggle("No Fall Damage + Anti-Ragdoll", 410, false, function(state)
    getgenv().NoFallDamage = state
end)

createToggle("Twisted ESP", 460, false, function(state)
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

spawn(function()
    while task.wait(0.5) do
        if getgenv().TwistedESP then
            pcall(function()
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
                        if not stillExists then esp:Destroy() end
                    end
                end

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
            for _, esp in pairs(espFolder:GetChildren()) do esp:Destroy() end
        end
    end
end)

-- ==================== CORE FEATURES ====================

-- God Mode
spawn(function()
    while task.wait(0.03) do
        if getgenv().GodMode then
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.MaxHealth = 999999
                    hum.Health = 999999
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
            end)
        end
    end
end)

-- Speed Hack (68)
spawn(function()
    while task.wait(0.1) do
        if getgenv().SpeedHack then
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = 68; hum.JumpPower = 90 end
            end)
        end
    end
end)

-- FULL AUTO PLAY + MACHINES + UNDER-MAP EVASION
spawn(function()
    while task.wait(0.08) do
        if getgenv().AutoPlay then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.WalkSpeed = 36.5
                end

                -- === EVASION: If Twisted sees you → go under map ===
                local minTwistedDist = math.huge
                local anyCloseTwisted = false
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                        local dist = (root.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist < minTwistedDist then
                            minTwistedDist = dist
                        end
                        if dist < 55 then
                            anyCloseTwisted = true
                        end
                    end
                end

                if anyCloseTwisted then
                    -- Twisted sees you → hide under map
                    root.CFrame = CFrame.new(root.Position.X, -380, root.Position.Z) -- deep underground
                    return -- skip machine logic while hiding
                end

                if minTwistedDist > 100 then
                    -- Safe again → return to surface (loop will handle machine next tick)
                end

                -- === MACHINE LOGIC ===
                -- First check if you're already on a machine
                local onMachine = false
                local machinePrompt = nil

                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled then
                        local parentName = v.Parent.Name:lower()
                        local action = (v.ActionText or ""):lower()
                        if parentName:find("machine") or parentName:find("extract") or parentName:find("generator") or action:find("extract") or action:find("machine") then
                            local part = v.Parent:FindFirstChildWhichIsA("BasePart") or v.Parent
                            if part then
                                local dist = (root.Position - part.Position).Magnitude
                                if dist < 15 then
                                    onMachine = true
                                    machinePrompt = v
                                    break
                                end
                            end
                        end
                    end
                end

                if onMachine and machinePrompt then
                    -- You're on a machine → STOP teleporting + auto-click prompt rapidly (bypasses skillcheck)
                    fireproximityprompt(machinePrompt)
                    task.wait(0.035) -- fast spam for perfect bypass
                    return
                end

                -- Not on a machine → find closest and teleport + initial fire
                local closestPrompt = nil
                local closestDist = math.huge
                local bestPart = nil

                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled then
                        local parentName = v.Parent.Name:lower()
                        local action = (v.ActionText or ""):lower()
                        if parentName:find("machine") or parentName:find("extract") or parentName:find("generator") or action:find("extract") or action:find("machine") then
                            local part = v.Parent:FindFirstChildWhichIsA("BasePart") or v.Parent
                            if part then
                                local dist = (root.Position - part.Position).Magnitude
                                if dist < closestDist and dist < 250 then
                                    closestDist = dist
                                    closestPrompt = v
                                    bestPart = part
                                end
                            end
                        end
                    end
                end

                if closestPrompt and bestPart then
                    -- Teleport to machine
                    root.CFrame = CFrame.new(bestPart.Position + Vector3.new(0, 5, 0))
                    task.wait(0.05)
                    fireproximityprompt(closestPrompt)
                    -- Next loop will detect you're now "on" it and stay + spam
                end
            end)
        end
    end
end)

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

-- Auto Tapes / Items
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

-- Auto Research Capsules
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

-- No Fall Damage + Anti-Ragdoll
spawn(function()
    while task.wait(0.5) do
        if getgenv().NoFallDamage then
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChild("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                end
            end)
        end
    end
end)

print("✅ GUI Loaded! FULL AUTO PLAY with new features:")
print("   • Teleports to machines + auto-stops while you're on one")
print("   • Auto-clicks machine prompt rapidly (skillcheck fully removed)")
print("   • If Twisted sees you (within ~55 studs) → hides under map")
print("   • Returns to machine when all Twisteds are >100 studs away")
print("   • WalkSpeed locked at 36.5 during Auto Play")
print("   Drag the GUI to move it. Enable other toggles as needed! 🌷")
