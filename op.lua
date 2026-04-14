-- 🌷 Dandy's World SAFE OP HUB with GUI - Noah Edition
print("🌷 Noah's Hub with GUI Loaded 🔥")

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NoahHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 400)
frame.Position = UDim2.new(0.5, -140, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
title.Text = "Noah's Dandy's World OP Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = frame

-- Toggle Function
local function createToggle(name, yPos, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.9, 0, 0, 40)
    toggle.Position = UDim2.new(0.05, 0, 0, yPos)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.Text = name .. ": " .. (default and "ON" or "OFF")
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.TextScaled = true
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

createToggle("Auto Farm", 160, true, function(state)
    getgenv().AutoFarm = state
end)

createToggle("Auto Tapes", 210, true, function(state)
    getgenv().AutoTapes = state
end)

createToggle("Kill Aura", 260, true, function(state)
    getgenv().KillAura = state
end)

-- Main Loops
spawn(function()
    while wait(0.15) do
        if getgenv().GodMode then
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChild("Humanoid")
                if hum then hum.Health = 999999 end
            end)
        end
    end
end)

spawn(function()
    while wait(0.35) do
        if getgenv().AntiTwisted then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:find("Twisted") and v:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.CanCollide = false
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait(0.2) do
        if getgenv().AutoFarm then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        fireproximityprompt(v)
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait(0.25) do
        if getgenv().AutoTapes then
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:lower():find("tape") then
                        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            firetouchinterest(root, v, 0)
                            firetouchinterest(root, v, 1)
                        end
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while wait(0.4) do
        if getgenv().KillAura then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:find("Twisted") and v:FindFirstChild("HumanoidRootPart") then
                        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if root and (root.Position - v.HumanoidRootPart.Position).Magnitude < 30 then
                            v:Destroy()
                        end
                    end
                end
            end)
        end
    end
end)

print("GUI Loaded! Click the buttons to toggle features.")
