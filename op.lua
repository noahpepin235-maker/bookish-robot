-- 🌷 Dandy's World ULTRA OP HUB - Noah Edition 🔥
-- No key, fully open, extra nasty for you

print("🌷 Noah's ULTRA OP Hub Loaded - You're untouchable 😈")

-- God Mode
spawn(function()
    while wait(0.05) do
        pcall(function()
            local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum.Health = 999999
                hum.MaxHealth = 999999
            end
        end)
    end
end)

-- ANTI-TWISTED (They can't hit or touch you)
spawn(function()
    while wait(0.1) do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:find("Twisted") and v:FindFirstChild("HumanoidRootPart") then
                    v.HumanoidRootPart.CanCollide = false
                    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root and (root.Position - v.HumanoidRootPart.Position).Magnitude < 30 then
                        v.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
                    end
                end
            end
        end)
    end
end)

-- Auto Farm Everything
spawn(function()
    while wait(0.07) do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    fireproximityprompt(v)
                end
            end
        end)
    end
end)

-- Auto Tapes & Items
spawn(function()
    while wait(0.15) do
        pcall(function()
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name:lower():find("tape") or v.Name:lower():find("item") then
                    local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        firetouchinterest(root, v, 0)
                        firetouchinterest(root, v, 1)
                    end
                end
            end
        end)
    end
end)

-- Movement
local plr = game.Players.LocalPlayer
plr.Character.Humanoid.WalkSpeed = 130
plr.Character.Humanoid.JumpPower = 250

-- Noclip
spawn(function()
    while wait() do
        pcall(function()
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end
end)

-- Fly (Press E to toggle)
local fly = false
game:GetService("UserInputService").InputBegan:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.E then
        fly = not fly
        local root = plr.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Velocity = fly and root.CFrame.LookVector * 130 or Vector3.new(0,0,0)
            bv.Parent = root
            print("Fly: " .. (fly and "ON 🔥" or "OFF"))
        end
    end
end)

-- Kill Aura
spawn(function()
    while wait(0.25) do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name:find("Twisted") and v:FindFirstChild("HumanoidRootPart") then
                    if (plr.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude < 35 then
                        v:Destroy()
                    end
                end
            end
        end)
    end
end)

print("✅ All features loaded! Press E to toggle Fly. Go destroy the game daddy 😏")
