-- 🌷 Noah's Full Pack - Hip Height + WalkSpeed + Full Bright + Teleports + Flying Research + Fly + Noclip + ESP
-- Made by noahexploits

print("🌷 Noah's Script Loading...")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
end

local Window = Rayfield:CreateWindow({
    Name = "🌷 Noah's Full Pack",
    LoadingTitle = "Noah's Script",
    LoadingSubtitle = "Made by noahexploits",
    Theme = "Default",
    DisableRayfieldPrompts = true,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Variables
local isEnabled = false
local currentHeight = 17
local currentWalkSpeed = 16
local fullBrightEnabled = false

local ResearchOn = false
local OriginalCFrame = nil
local flightConnection = nil
local currentFlightHeight = 40

local FlyEnabled = false
local NoclipEnabled = false
local FlySpeed = 50

local ESPEnabled = false
local MachineESPEnabled = false
local ESPObjects = {}
local MachineESPObjects = {}

local currentCapsuleIndex = 1
local currentMachineIndex = 1

-- ====================== GENERAL FLY ======================
local flyBodyVelocity = nil
local flyConnection = nil

local function startGeneralFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    hum.PlatformStand = true

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Velocity = Vector3.new(0,0,0)
    flyBodyVelocity.Parent = hrp

    flyConnection = RunService.Heartbeat:Connect(function()
        if not FlyEnabled then return end
        local moveDirection = Vector3.new()
        local camera = workspace.CurrentCamera

        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0,1,0) end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0,1,0) end

        if moveDirection.Magnitude > 0 then
            flyBodyVelocity.Velocity = moveDirection.Unit * FlySpeed
        else
            flyBodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end)
end

local function stopGeneralFly()
    FlyEnabled = false
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
end

-- ====================== NOCLIP ======================
local noclipConnection = nil

local function startNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        if not NoclipEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    -- Reset collision
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

-- ====================== REST OF THE SCRIPT (same as before) ======================
-- [All previous functions: startFlying, autoResearchLoop, ESP, Teleports, etc.]

local function teleportToTarget(target, heightOffset, name)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not target then return end
    local cf = target:IsA("Model") and target:GetPivot() or target.CFrame
    hrp.CFrame = cf * CFrame.new(0, heightOffset or 5, 0)
    Rayfield:Notify({Title = "✅ Teleported", Content = name, Duration = 3})
end

-- (Keep all your previous teleport functions, ESP, hip height, etc. - I'm shortening here for space)

-- ====================== UI ======================
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Hip Height")
MainTab:CreateToggle({Name = "Enable Hip Height", CurrentValue = false, Callback = function(v) isEnabled = v if v then applyHipHeight(currentHeight) end end})
MainTab:CreateSlider({Name = "Hip Height", Range = {2, 17}, Increment = 1, Suffix = " studs", CurrentValue = 17, Callback = function(v) currentHeight = v if isEnabled then applyHipHeight(v) end end})

MainTab:CreateSection("Movement")
MainTab:CreateSlider({Name = "Walk Speed", Range = {1, 100}, Increment = 1, Suffix = " studs/sec", CurrentValue = 16, Callback = setWalkSpeed})

MainTab:CreateSection("Fly & Noclip")
MainTab:CreateToggle({
    Name = "General Fly (WASD + Space)",
    CurrentValue = false,
    Callback = function(v)
        FlyEnabled = v
        if v then startGeneralFly() else stopGeneralFly() end
    end,
})
MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(v) FlySpeed = v end,
})
MainTab:CreateToggle({
    Name = "Noclip (Walk through walls)",
    CurrentValue = false,
    Callback = function(v)
        NoclipEnabled = v
        if v then startNoclip() else stopNoclip() end
    end,
})

MainTab:CreateSection("Teleports")
MainTab:CreateButton({Name = "🚀 Teleport Inside Elevator", Callback = teleportInsideElevator})
MainTab:CreateButton({Name = "🚀 Nearest Machine (30 studs)", Callback = teleportToNearestMachine})
MainTab:CreateButton({Name = "🔄 Next Machine (30 studs)", Callback = teleportToNextMachine})
MainTab:CreateButton({Name = "🚀 Nearest Research Capsule", Callback = teleportToNearestCapsule})
MainTab:CreateButton({Name = "🔄 Next Research Capsule", Callback = teleportToNextCapsule})

MainTab:CreateSection("🌟 ESP")
MainTab:CreateToggle({Name = "Monster + Twisted ESP (Pink)", CurrentValue = false, Callback = function(v) ESPEnabled = v end})
MainTab:CreateToggle({Name = "Machine ESP (Cyan)", CurrentValue = false, Callback = function(v) MachineESPEnabled = v end})

MainTab:CreateSection("🌟 Auto Research")
MainTab:CreateToggle({Name = "Get Research - MONSTER + TWISTED (40 Studs)", CurrentValue = false, Callback = function(v)
    ResearchOn = v
    if v then task.spawn(autoResearchLoop) else stopFlying() end
end})

RunService.Heartbeat:Connect(function()
    updateMonsterESP()
    updateMachineESP()
end)

Rayfield:Notify({
    Title = "🌷 Script Loaded!",
    Content = "General Fly + Noclip Added!\nUse WASD + Space to fly",
    Duration = 10,
})
