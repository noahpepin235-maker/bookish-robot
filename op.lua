-- 🌷 Dandy's World OP HUB - Noah Edition (Safer + Toggles)
print("🌷 Noah's Hub Loaded - Toggles enabled 🔥")

-- ==================== TOGGLES (Change these to true/false) ====================
getgenv().AutoFarm = true
getgenv().GodMode = true
getgenv().AntiTwisted = true
getgenv().AutoTapes = true
getgenv().Noclip = true
getgenv().KillAura = true
getgenv().WalkSpeed = 100
-- =====================================================================

local plr = game.Players.LocalPlayer

-- God Mode
if getgenv().GodMode then
    spawn(function()
        while wait(0.1) do
            pcall(function()
                local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
                if hum then
                    hum.Health = 999999
                    hum.MaxHealth = 999999
                end
            end)
        end
    end)
end

-- Anti-Twisted (Main AC trigger fix - made slower & safer)
if getgenv().AntiTwisted then
    spawn(function()
        while wait(0.3) do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:find("Twisted") and v:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.CanCollide = false
                        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if root and (root.Position - v.HumanoidRootPart.Position).Magnitude < 25 then
                            v.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 80, 0)
                        end
                    end
                end
            end)
        end
    end)
end

-- Auto Farm
if getgenv().AutoFarm then
    spawn(function()
        while wait(0.15) do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        fireproximityprompt(v)
                    end
                end
            end)
        end
    end)
end

-- Auto Tapes
if getgenv().AutoTapes then
    spawn(function()
        while wait(0.2) do
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name:lower():find("tape") then
                        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            firetouchinterest(root, v, 0)
                            firetouchinterest(root, v, 1)
                        end
                    end
                end
            end)
        end
    end)
end

-- Movement
if plr.Character and plr.Character:FindFirstChild("Humanoid") then
    plr.Character.Humanoid.WalkSpeed = getgenv().WalkSpeed
end

-- Noclip
if getgenv().Noclip then
    spawn(function()
        while wait(0.2) do
            pcall(function()
                for _, part in pairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        end
    end)
end

-- Kill Aura
if getgenv().KillAura then
    spawn(function()
        while wait(0.4) do
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:find("Twisted") and v:FindFirstChild("HumanoidRootPart") then
                        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if root and (root.Position - v.HumanoidRootPart.Position).Magnitude < 30 then
                            v:Destroy()
                        end
                    end
                end
            end)
        end
    end)
end

-- Fly (Press E)
local fly = false
game:GetService("UserInputService").InputBegan:Connect(function(inp)
    if inp.KeyCode == Enum.KeyCode.E then
        fly = not fly
        local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local bv = root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
            bv.Name = "FlyVelocity"
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Velocity = fly and root.CFrame.LookVector * 100 or Vector3.new(0,0,0)
            bv.Parent = root
            print("🚀 Fly: " .. (fly and "ON" or "OFF"))
        end
    end
end)

print("✅ Hub loaded! Change toggles at the top of the script and re-execute.")
print("Press E to toggle Fly")
