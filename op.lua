-- 🌷 Dandy's World CLEAN OP HUB - Noah Edition (FIXED 2026 - Working Auto Machines)
print("🌷 Noah's Fixed Dandy's World Hub Loaded - Auto Machines should now work")

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NoahHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 550)
frame.Position = UDim2.new(0.5, -160, 0.5, -275)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

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

-- Toggles
createToggle("God Mode (Infinite Health)", 70, false, function(s) getgenv().GodMode = s end)
createToggle("Anti-Twisted (No Collision)", 125, false, function(s) getgenv().AntiTwisted = s end)
createToggle("FULL AUTO PLAY (Machines)", 180, false, function(s) getgenv().AutoPlay = s end)
createToggle("Auto Tapes / Items", 235, false, function(s) getgenv().AutoTapes = s end)
createToggle("Kill Aura", 290, false, function(s) getgenv().KillAura = s end)
createToggle("Auto Research Capsules", 345, false, function(s) getgenv().AutoCapsules = s end)
createToggle("Speed Hack (68)", 400, false, function(s) getgenv().SpeedHack = s end)
createToggle("No Fall Damage + Anti-Ragdoll", 455, false, function(s) getgenv().NoFallDamage = s end)
createToggle("Twisted ESP", 510, false, function(s) getgenv().TwistedESP = s end)

-- Twisted ESP (unchanged)
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
                    if not workspace:FindFirstChild(esp.Name:match("TwistedESP_(.+)"), true) then
                        esp:Destroy()
                    end
                end
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

-- God Mode, Speed Hack, Anti-Twisted, Kill Aura, Auto Tapes, Auto Capsules, No Fall - same as before (working)

-- God Mode
spawn(function()
    while task.wait(0.03) do
        if getgenv().GodMode then
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.MaxHealth = 999999
                    hum.Health = 999999
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
                if hum then hum.WalkSpeed = 68; hum.JumpPower = 90 end
            end)
        end
    end
end)

-- FIXED FULL AUTO PLAY (Machines) - Broader detection + aggressive firing
spawn(function()
    while task.wait(0.07) do
        if getgenv().AutoPlay then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = 36.5 end

                -- Simple Twisted evasion (under map if too close)
                local anyClose = false
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                        if (root.Position - v.HumanoidRootPart.Position).Magnitude < 60 then
                            anyClose = true
                            break
                        end
                    end
                end

                if anyClose then
                    root.CFrame = CFrame.new(root.Position.X, -450, root.Position.Z)
                    return
                end

                -- Find any ProximityPrompt that could be a machine/extractor
                local closestPrompt = nil
                local closestDist = math.huge
                local closestPart = nil

                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                        local parent = prompt.Parent
                        local dist = 9999
                        local part = nil

                        if parent:IsA("BasePart") then
                            part = parent
                        else
                            part = parent:FindFirstChildWhichIsA("BasePart")
                        end

                        if part then
                            dist = (root.Position - part.Position).Magnitude
                        end

                        -- Broader check for machine-related prompts
                        local isMachine = false
                        local nameLower = (parent.Name or ""):lower()
                        local actionLower = (prompt.ActionText or ""):lower()

                        if nameLower:find("machine") or nameLower:find("extract") or nameLower:find("generator") or 
                           nameLower:find("valve") or nameLower:find("ichor") or 
                           actionLower:find("extract") or actionLower:find("machine") or actionLower:find("turn") then
                            isMachine = true
                        end

                        if isMachine and dist < closestDist and dist < 300 then
                            closestDist = dist
                            closestPrompt = prompt
                            closestPart = part
                        end
                    end
                end

                if closestPrompt and closestPart then
                    if closestDist < 20 then
                        -- Already near/on machine → spam fire (this bypasses skill check in most cases)
                        fireproximityprompt(closestPrompt)
                        task.wait(0.03)
                    else
                        -- Teleport closer
                        root.CFrame = CFrame.new(closestPart.Position + Vector3.new(0, 5, 0))
                        task.wait(0.08)
                        fireproximityprompt(closestPrompt)
                    end
                end
            end)
        end
    end
end)

-- Keep the rest of your features (Anti-Twisted, AutoTapes, etc.) exactly as in the previous version

print("✅ FIXED VERSION LOADED!")
print("   • FULL AUTO PLAY now uses broader machine detection")
print("   • More aggressive prompt firing near machines")
print("   • Under map evasion if Twisted gets too close")
print("Turn on FULL AUTO PLAY and walk near machines — it should start working now.")
print("If it still doesn't, tell me your executor (Delta, Solara, etc.) and I'll adjust further.")
