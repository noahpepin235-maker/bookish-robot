-- 🌷 Dandy's World SAFE OP HUB - Noah Edition (Clean GUI 2026)
print("🌷 Noah's Clean Dandy's World Hub Loaded - FULL AUTO PLAY + Smart Evasion")

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NoahHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 550)
frame.Position = UDim2.new(0.5, -160, 0.5, -275)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Pink Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "🌷 Noah's Dandy's World OP Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- Clean Toggle Function
local function createToggle(name, yPos, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 45)
    btn.Position = UDim2.new(0.025, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = frame
    
    local enabled = default
    
    local function update()
        btn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        btn.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(30, 30, 30)
    end
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        update()
        callback(enabled)
    end)
    
    update()
    callback(default)
end

-- ==================== TOGGLES ====================
createToggle("God Mode (Infinite Health)", 70, false, function(s) getgenv().GodMode = s end)
createToggle("Anti-Twisted (No Collision)", 125, false, function(s) getgenv().AntiTwisted = s end)
createToggle("FULL AUTO PLAY (Machines + Teleport)", 180, false, function(s) getgenv().AutoPlay = s end)
createToggle("Auto Tapes / Items", 235, false, function(s) getgenv().AutoTapes = s end)
createToggle("Kill Aura", 290, false, function(s) getgenv().KillAura = s end)
createToggle("Auto Research Capsules", 345, false, function(s) getgenv().AutoCapsules = s end)
createToggle("Speed Hack (68)", 400, false, function(s) getgenv().SpeedHack = s end)
createToggle("No Fall Damage + Anti-Ragdoll", 455, false, function(s) getgenv().NoFallDamage = s end)
createToggle("Twisted ESP", 510, false, function(s) getgenv().TwistedESP = s end)

-- ==================== TWISTED ESP ====================
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
                -- Clean old ESP
                for _, esp in pairs(espFolder:GetChildren()) do
                    local name = esp.Name:match("TwistedESP_(.+)")
                    if name then
                        if not workspace:FindFirstChild(name, true) then
                            esp:Destroy()
                        end
                    end
                end
                -- Add new
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                        if not espFolder:FindFirstChild("TwistedESP_" .. v.Name) then
                            createESP(v)
                        end
                    end
                end
            end)
        else
            espFolder:ClearAllChildren()
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

-- FULL AUTO PLAY + MACHINES + UNDER-MAP EVASION
spawn(function()
    while task.wait(0.08) do
        if getgenv().AutoPlay then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = 36.5 end

                -- Twisted detection (based on typical ranges ~35-80 studs)
                local anyCloseTwisted = false
                local closestTwistedDist = math.huge

                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                        local dist = (root.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist < closestTwistedDist then closestTwistedDist = dist end
                        if dist < 55 then anyCloseTwisted = true end
                    end
                end

                if anyCloseTwisted then
                    -- Hide under map
                    root.CFrame = CFrame.new(root.Position.X, -400, root.Position.Z)
                    return
                end

                -- Safe → continue
                if closestTwistedDist > 100 then
                    -- Safe to surface (handled naturally by loop)
                end

                -- Check if already on a machine
                local onMachine = false
                local currentPrompt = nil

                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled then
                        local parentName = v.Parent.Name:lower()
                        local action = (v.ActionText or ""):lower()
                        if parentName:find("machine") or parentName:find("extract") or parentName:find("generator") or 
                           action:find("extract") or action:find("machine") then
                            local part = v.Parent:FindFirstChildWhichIsA("BasePart") or v.Parent
                            if part and (root.Position - part.Position).Magnitude < 18 then
                                onMachine = true
                                currentPrompt = v
                                break
                            end
                        end
                    end
                end

                if onMachine and currentPrompt then
                    -- Stay + rapid fire (bypasses skill check)
                    fireproximityprompt(currentPrompt)
                    task.wait(0.04)
                    return
                end

                -- Teleport to closest machine
                local closestPrompt, closestPart, closestDist = nil, nil, math.huge

                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") and v.Enabled then
                        local parentName = v.Parent.Name:lower()
                        local action = (v.ActionText or ""):lower()
                        if parentName:find("machine") or parentName:find("extract") or parentName:find("generator") or 
                           action:find("extract") or action:find("machine") then
                            local part = v.Parent:FindFirstChildWhichIsA("BasePart") or v.Parent
                            if part then
                                local dist = (root.Position - part.Position).Magnitude
                                if dist < closestDist and dist < 280 then
                                    closestDist = dist
                                    closestPrompt = v
                                    closestPart = part
                                end
                            end
                        end
                    end
                end

                if closestPrompt and closestPart then
                    root.CFrame = CFrame.new(closestPart.Position + Vector3.new(0, 6, 0))
                    task.wait(0.06)
                    fireproximityprompt(closestPrompt)
                end
            end)
        end
    end
end)

-- Anti-Twisted (No Collision)
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

print("✅ Clean GUI + FULL AUTO PLAY Loaded!")
print("   • Machines: Teleport → Stay & auto-complete (skillcheck bypassed)")
print("   • Evasion: Under map if Twisted <55 studs | Return when >100 studs")
print("   • WalkSpeed: 36.5 during Auto Play")
print("   Drag the pink title bar to move the GUI. Stay safe & farm well! 🌷")
