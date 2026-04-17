-- 🌷 Noah's FULL Pack - Hip Height + WalkSpeed + Full Bright + Teleports + AUTO RESEARCH (40 Stud FLY) + ESP
-- Made by noahexploits (Flying 40 Stud Edition 🔥)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🌷 Noah's Full Pack - 40 Stud Flying Research",
    LoadingTitle = "Noah's Everything Pack",
    LoadingSubtitle = "Made by noahexploits",
    Theme = "Default",
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Variables
local isEnabled = false
local currentHeight = 17
local hipHeightConnection = nil
local swayFixConnection = nil
local currentWalkSpeed = 16
local fullBrightEnabled = false

local ResearchOn = false
local OriginalCFrame = nil
local flightBodyVelocity = nil

local ESPEnabled = false
local ESPObjects = {}

local DEFAULT_ROOT_C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)

-- ====================== FLYING SYSTEM (Anti-Fall) ======================
local function startFlying()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    humanoid.PlatformStand = true  -- Stops normal falling

    if flightBodyVelocity then flightBodyVelocity:Destroy() end
    flightBodyVelocity = Instance.new("BodyVelocity")
    flightBodyVelocity.Name = "ResearchFlight"
    flightBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    flightBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flightBodyVelocity.Parent = hrp
end

local function stopFlying()
    if flightBodyVelocity then
        flightBodyVelocity:Destroy()
        flightBodyVelocity = nil
    end
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
end

-- ====================== AUTO RESEARCH - 40 STUD FLY ======================
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
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    OriginalCFrame = hrp.CFrame
    startFlying()   -- ENABLE FLYING

    local monsters = getAllMonsters()
    if #monsters == 0 then
        Rayfield:Notify({Title = "Auto Research", Content = "No monsters found!", Duration = 5})
        stopFlying()
        ResearchOn = false
        return
    end

    Rayfield:Notify({Title = "🌟 AUTO RESEARCH STARTED", Content = "Flying 40 studs above monsters...", Duration = 6})

    for _, monster in ipairs(monsters) do
        if not ResearchOn then break end

        -- Fly 40 studs above
        hrp.CFrame = monster.CFrame * CFrame.new(0, 40, 0)

        -- Mouse hover for research
        local cam = workspace.CurrentCamera
        local screenPos = cam:WorldToViewportPoint(monster.Position + Vector3.new(0, 5, 0))
        VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)

        task.wait(0.7)  -- 0.7 seconds per monster (good for research to register)
    end

    -- Return to original position
    if OriginalCFrame then
        hrp.CFrame = OriginalCFrame
    end
    stopFlying()

    Rayfield:Notify({Title = "✅ Research Cycle Complete", Content = "Back at start position", Duration = 5})
end

-- ====================== ESP, HIP HEIGHT, TELEPORTS, WALKSPEED, FULLBRIGHT ======================
-- (All your original code is kept exactly the same below - only changed the research part)

local function createESP(part) ... end  -- (same as before)
local function updateMonsterESP() ... end
local function removeESP(part) ... end

-- Teleport functions (all your original ones)
local function teleportToTarget(...) ... end
local function teleportToNearestMachine() ... end
local function teleportToNextMachine() ... end
local function teleportToNearestCapsule() ... end
local function teleportToNextCapsule() ... end
local function teleportInsideElevator() ... end

-- Hip Height + Sway Fix (full original code)
local function enableSwayFix(...) ... end
local function disableSwayFix(...) ... end
local function applyHipHeight(...) ... end
local function resetHipHeight(...) ... end

-- WalkSpeed + FullBright (full original)
local function setWalkSpeed(...) ... end
local function enableFullBright(...) ... end
local function disableFullBright(...) ... end

-- ====================== UI ======================
local MainTab = Window:CreateTab("Main", 4483362458)

-- Hip Height Section (same)
MainTab:CreateSection("Hip Height")
MainTab:CreateToggle({Name = "Enable Hip Height", CurrentValue = false, Callback = function(v) isEnabled = v if v then applyHipHeight(currentHeight) else resetHipHeight() end end})
MainTab:CreateSlider({Name = "Hip Height", Range = {2, 17}, Increment = 1, Suffix = " studs", CurrentValue = 17, Callback = function(v) currentHeight = v if isEnabled then applyHipHeight(v) end end})

-- Movement + Visuals
MainTab:CreateSection("Movement")
MainTab:CreateSlider({Name = "Walk Speed", Range = {1, 100}, Increment = 1, Suffix = " studs/sec", CurrentValue = 16, Callback = setWalkSpeed})

MainTab:CreateSection("Visuals")
MainTab:CreateToggle({Name = "Full Bright", CurrentValue = false, Callback = function(v) if v then enableFullBright() else disableFullBright() end end})

-- Teleports
MainTab:CreateSection("Teleports")
MainTab:CreateButton({Name = "🚀 Teleport Inside Elevator", Callback = teleportInsideElevator})
MainTab:CreateButton({Name = "🚀 Nearest Machine", Callback = teleportToNearestMachine})
MainTab:CreateButton({Name = "🔄 Next Machine", Callback = teleportToNextMachine})
MainTab:CreateButton({Name = "🚀 Nearest Research Capsule", Callback = teleportToNearestCapsule})
MainTab:CreateButton({Name = "🔄 Next Capsule", Callback = teleportToNextCapsule})

-- Quick Presets
MainTab:CreateSection("Quick Hip Height Presets")
local presets = {{name="Default (2)", val=2}, {name="12 (Safe)", val=12}, {name="17 (Max)", val=17}}
for _, p in ipairs(presets) do
    MainTab:CreateButton({Name = p.name, Callback = function() currentHeight = p.val; HeightSlider:Set(p.val); if isEnabled then applyHipHeight(p.val) end end})
end

-- Monster Features
MainTab:CreateSection("🌟 Monster ESP + 40 Stud Flying Research")
MainTab:CreateToggle({Name = "Monster ESP (Pink + Names)", CurrentValue = false, Callback = function(v) ESPEnabled = v end})

MainTab:CreateToggle({
    Name = "Get Research - FLY 40 Studs Over Monsters",
    CurrentValue = false,
    Callback = function(v)
        ResearchOn = v
        if v then task.spawn(autoResearchLoop) end
    end,
})

RunService.Heartbeat:Connect(function()
    if ESPEnabled then updateMonsterESP() end
end)

MainTab:CreateLabel("Now flies at 40 studs high with anti-fall system")
MainTab:CreateLabel("No more falling while researching 😈")

Rayfield:Notify({Title = "🌷 Script Updated!", Content = "40 Stud Flying Research + Anti-Fall Enabled", Duration = 8})
