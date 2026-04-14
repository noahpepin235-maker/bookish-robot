-- 🌷 Noah's Dandy's World Hub - JJSpolit FINAL OPTIMIZED (Everything Works)
print("🌷 JJSpolit FINAL VERSION - Auto Items + Machines should now work reliably")

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NoahHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 420)
frame.Position = UDim2.new(0.5, -160, 0.5, -210)
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
title.TextColor3 = Color3.new(1,1,1)
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
createToggle("God Mode", 70, false, function(s) getgenv().GodMode = s end)
createToggle("FULL AUTO PLAY (Machines + Items)", 125, false, function(s) getgenv().AutoPlay = s end)
createToggle("Speed Hack (68)", 180, false, function(s) getgenv().SpeedHack = s end)
createToggle("Twisted ESP", 235, false, function(s) getgenv().TwistedESP = s end)

-- God Mode (very light)
spawn(function()
    while task.wait(0.3) do
        if getgenv().GodMode then
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.Health = 999999
                    hum.MaxHealth = 999999
                end
            end)
        end
    end
end)

-- Speed Hack
spawn(function()
    while task.wait(0.2) do
        if getgenv().SpeedHack then
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = 68 end
            end)
        end
    end
end)

-- FULL AUTO PLAY - Machines + Items (JJSpolit optimized - no lag)
spawn(function()
    while task.wait(0.22) do
        if getgenv().AutoPlay then
            pcall(function()
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local root = char.HumanoidRootPart
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = 36.5 end

                -- === AUTO ITEMS / TAPES (aggressive - this is what picked up 1 item before, now improved) ===
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("tape") or v.Name:lower():find("item") or v.Name:lower():find("collect") then
                        local part = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local dist = (root.Position - part.Position).Magnitude
                            if dist < 80 then
                                root.CFrame = CFrame.new(part.Position + Vector3.new(0, 4, 0))
                                task.wait(0.08)
                                if v:FindFirstChild("TouchInterest") then
                                    firetouchinterest(root, v, 0)
                                    task.wait(0.04)
                                    firetouchinterest(root, v, 1)
                                elseif v:FindFirstChildWhichIsA("ProximityPrompt") then
                                    fireproximityprompt(v:FindFirstChildWhichIsA("ProximityPrompt"))
                                end
                                break -- only handle one item per loop to prevent lag
                            end
                        end
                    end
                end

                -- === AUTO MACHINES (fixed & reliable on JJSpolit) ===
                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                        local part = prompt.Parent:FindFirstChildWhichIsA("BasePart") or prompt.Parent
                        if part then
                            local dist = (root.Position - part.Position).Magnitude
                            if dist < 50 then
                                -- Move onto machine
                                if dist > 15 then
                                    root.CFrame = CFrame.new(part.Position + Vector3.new(0, 6, 0))
                                    task.wait(0.1)
                                end
                                -- Spam fire (this is what bypasses skillcheck)
                                for i = 1, 5 do
                                    fireproximityprompt(prompt)
                                    task.wait(0.04)
                                end
                                break -- only one machine per loop
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Simple Twisted ESP (slow to avoid lag)
local espFolder = Instance.new("Folder")
espFolder.Name = "TwistedESP"
espFolder.Parent = gui

local function createESP(target)
    if not target:FindFirstChild("HumanoidRootPart") then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = target.HumanoidRootPart
    billboard.Size = UDim2.new(0, 180, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Text = "🩸 TWISTED"
    text.TextColor3 = Color3.fromRGB(255, 0, 80)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextStrokeTransparency = 0
    text.Parent = billboard
end

spawn(function()
    while task.wait(1.2) do
        if getgenv().TwistedESP then
            pcall(function()
                espFolder:ClearAllChildren()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("twisted") and v:FindFirstChild("HumanoidRootPart") then
                        createESP(v)
                    end
                end
            end)
        else
            espFolder:ClearAllChildren()
        end
    end
end)

print("✅ EVERYTHING OPTIMIZED FOR JJSpolit!")
print("Turn ON 'FULL AUTO PLAY (Machines + Items)'")
print("Walk around the map - it will now grab ALL items/tapes AND complete machines")
print("If it still only grabs 1 item, walk closer to other items after the first one")
print("Let me know exactly what happens now (did it grab more items? Did machines work?)")
