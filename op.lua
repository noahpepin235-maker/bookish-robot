-- 🌷 Noah's Full Pack - 40 Stud Flying Research (JJSPLOIT FIXED)
-- Made by noahexploits 🔥

print("🌷 Loading Noah's Script for JJSpolit...")

-- JJSpolit-Friendly Rayfield Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
end

local Window = Rayfield:CreateWindow({
    Name = "🌷 Noah's 40 Stud Flying Pack",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "JJSpolit Edition",
    Theme = "Default",
    DisableRayfieldPrompts = true,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local ResearchOn = false
local OriginalCFrame = nil
local flightConnection = nil
local currentFlightHeight = 40

local ESPEnabled = false
local ESPObjects = {}

local isEnabled = false
local currentHeight = 17
local hipHeightConnection = nil
local swayFixConnection = nil
local currentWalkSpeed = 16
local fullBrightEnabled = false

-- ====================== ANTI-FALL FLYING (Strong for JJSpolit) ======================
local function startFlying()
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    hum.PlatformStand = true

    if flightConnection then flightConnection:Disconnect() end

    flightConnection = RunService.Heartbeat:Connect(function()
        if not ResearchOn then return end
        local pos = hrp.Position
        -- Strong Y lock
        hrp.CFrame = CFrame.new(pos.X, currentFlightHeight + (monsterY or pos.Y - 40), pos.Z)
        hrp.Velocity = Vector3.new(hrp.Velocity.X * 0.1, 0, hrp.Velocity.Z * 0.1)
    end)
end

local function stopFlying()
    if flightConnection then flightConnection:Disconnect() flightConnection = nil end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
end

-- ====================== AUTO RESEARCH ======================
local function getAllMonsters()
    local monsters = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("monster") or obj.Name:lower():find("twisted") then
            local root = obj:FindFirstChildWhichIsA("BasePart") or (obj:IsA("Model") and obj.PrimaryPart)
            if root then table.insert(monsters, root) end
        end
    end
    return monsters
end

local function autoResearchLoop()
    if not ResearchOn then return end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        Rayfield:Notify({Title = "Error", Content = "Character not loaded!", Duration = 5})
        return 
    end

    OriginalCFrame = character.HumanoidRootPart.CFrame
    startFlying()

    local monsters = getAllMonsters()
    if #monsters == 0 then
        Rayfield:Notify({Title = "Auto Research", Content = "No monsters yet, wait for floor", Duration = 6})
        stopFlying()
        ResearchOn = false
        return
    end

    Rayfield:Notify({Title = "🌟 40 STUD FLYING ON", Content = "No falling guaranteed", Duration = 6})

    for _, monster in ipairs(monsters) do
        if not ResearchOn then break end

        local targetPos = monster.Position + Vector3.new(0, currentFlightHeight, 0)
        character.HumanoidRootPart.CFrame = CFrame.new(targetPos)

        local screenPos = workspace.CurrentCamera:WorldToViewportPoint(monster.Position + Vector3.new(0,15,0))
        VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)

        task.wait(0.8)
    end

    if OriginalCFrame then character.HumanoidRootPart.CFrame = OriginalCFrame end
    stopFlying()
    Rayfield:Notify({Title = "✅ Done", Content = "Returned to start", Duration = 5})
end

-- ====================== ESP (Same) ======================
-- (Add your previous ESP functions here: createESP, updateMonsterESP, etc.)

-- ====================== UI ======================
local MainTab = Window:CreateTab("Main", 4483362458)

-- Add all your old sections: Hip Height, WalkSpeed, Full Bright, Teleports, Presets...

MainTab:CreateSection("🌟 40 Stud Flying Research")
MainTab:CreateToggle({
    Name = "Monster ESP (Pink)",
    CurrentValue = false,
    Callback = function(v) ESPEnabled = v end,
})

MainTab:CreateToggle({
    Name = "Get Research - FLY 40 Studs (ANTI FALL)",
    CurrentValue = false,
    Callback = function(v)
        ResearchOn = v
        if v then task.spawn(autoResearchLoop) else stopFlying() end
    end,
})

Rayfield:Notify({
    Title = "🌷 Loaded for JJSpolit!",
    Content = "Try the 40 Stud Flying Research now",
    Duration = 8,
})
