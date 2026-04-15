```lua
-- 🌷 Noah's Hip Height Changer + WalkSpeed + Full Bright + Enhanced Teleports | For Dandy's World
-- Made by noahexploits (All teleports now grouped in one clean "Teleports" section)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🌷 Noah's Hip Height Changer + All Teleports",
    LoadingTitle = "Noah's Hip Height Changer + All Teleports",
    LoadingSubtitle = "Made by noahexploits",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Variables
local isEnabled = false
local currentHeight = 2
local hipHeightConnection = nil
local swayFixConnection = nil
local currentWalkSpeed = 16
local fullBrightEnabled = false
local currentMachineIndex = 1
local currentCapsuleIndex = 1

-- Default RootJoint C0
local DEFAULT_ROOT_C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)

-- ====================== ENHANCED TELEPORT HELPERS ======================
local function teleportToTarget(target, heightOffset, targetType)
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp or not target then return end

    local pivotCFrame = target:IsA("Model") and target:GetPivot() or target.CFrame
    hrp.CFrame = pivotCFrame * CFrame.new(0, heightOffset or 4, 0)

    Rayfield:Notify({
        Title = "✅ Teleported!",
        Content = "You are now at the " .. (targetType or "target"),
        Duration = 3,
        Image = 4483362458,
    })
end

-- Machines
local function getAllMachines()
    local found = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        local nameLower = obj.Name:lower()
        if (nameLower:find("machine") or nameLower:find("generator")) and (obj:IsA("Model") or obj:IsA("BasePart")) then
            table.insert(found, obj)
        end
    end
    return found
end

local function teleportToNearestMachine()
    local machines = getAllMachines()
    if #machines == 0 then
        Rayfield:Notify({Title = "Error", Content = "No machines found yet! (wait for floor to load)", Duration = 5})
        return
    end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    table.sort(machines, function(a, b)
        local posA = a:IsA("Model") and a:GetPivot().Position or a.Position
        local posB = b:IsA("Model") and b:GetPivot().Position or b.Position
        return (posA - hrp.Position).Magnitude < (posB - hrp.Position).Magnitude
    end)
    teleportToTarget(machines[1], 5, "nearest machine")
end

local function teleportToNextMachine()
    local machines = getAllMachines()
    if #machines == 0 then
        Rayfield:Notify({Title = "Error", Content = "No machines found yet! (wait for floor to load)", Duration = 5})
        return
    end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    table.sort(machines, function(a, b)
        local posA = a:IsA("Model") and a:GetPivot().Position or a.Position
        local posB = b:IsA("Model") and b:GetPivot().Position or b.Position
        return (posA - hrp.Position).Magnitude < (posB - hrp.Position).Magnitude
    end)
    currentMachineIndex = (currentMachineIndex % #machines) + 1
    teleportToTarget(machines[currentMachineIndex], 5, "next machine")
end

-- Research Capsules
local function getAllCapsules()
    local found = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        local nameLower = obj.Name:lower()
        if nameLower:find("capsule") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            table.insert(found, obj)
        end
    end
    return found
end

local function teleportToNearestCapsule()
    local capsules = getAllCapsules()
    if #capsules == 0 then
        Rayfield:Notify({Title = "Error", Content = "No research capsules found yet! (wait for floor to load)", Duration = 5})
        return
    end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    table.sort(capsules, function(a, b)
        local posA = a:IsA("Model") and a:GetPivot().Position or a.Position
        local posB = b:IsA("Model") and b:GetPivot().Position or b.Position
        return (posA - hrp.Position).Magnitude < (posB - hrp.Position).Magnitude
    end)
    teleportToTarget(capsules[1], 3, "nearest research capsule")
end

local function teleportToNextCapsule()
    local capsules = getAllCapsules()
    if #capsules == 0 then
        Rayfield:Notify({Title = "Error", Content = "No research capsules found yet! (wait for floor to load)", Duration = 5})
        return
    end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    table.sort(capsules, function(a, b)
        local posA = a:IsA("Model") and a:GetPivot().Position or a.Position
        local posB = b:IsA("Model") and b:GetPivot().Position or b.Position
        return (posA - hrp.Position).Magnitude < (posB - hrp.Position).Magnitude
    end)
    currentCapsuleIndex = (currentCapsuleIndex % #capsules) + 1
    teleportToTarget(capsules[currentCapsuleIndex], 3, "next research capsule")
end

-- Elevator TP
local function findElevator()
    local elevator = workspace:FindFirstChild("Elevator", true)
    if elevator then return elevator end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower() == "elevator" then
            return obj
        end
    end
    return nil
end

local function teleportInsideElevator()
    local character = LocalPlayer.Character
    if not character then 
        Rayfield:Notify({Title = "Error", Content = "Character not loaded yet!", Duration = 3})
        return 
    end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        Rayfield:Notify({Title = "Error", Content = "HumanoidRootPart not found!", Duration = 3})
        return 
    end

    local elevator = nil
    for i = 1, 10 do
        elevator = findElevator()
        if elevator then break end
        task.wait(0.5)
    end

    if elevator then
        local targetPart = elevator:IsA("Model") and (elevator.PrimaryPart or elevator:FindFirstChildWhichIsA("BasePart")) or elevator
        if targetPart then
            local pivotCFrame = elevator:IsA("Model") and elevator:GetPivot() or targetPart.CFrame
            hrp.CFrame = pivotCFrame * CFrame.new(0, 4, 0)
            Rayfield:Notify({Title = "✅ Teleported!", Content = "You are now inside the elevator", Duration = 3})
        end
    else
        Rayfield:Notify({Title = "Error", Content = "Elevator not found (wait for it to spawn)", Duration = 5})
    end
end

-- ====================== HIP HEIGHT ======================
local function enableSwayFix(character)
    if swayFixConnection then swayFixConnection:Disconnect() end
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end
    local rootJoint = hrp:WaitForChild("RootJoint", 5)
    if not rootJoint then return end
   
    swayFixConnection = RunService.Stepped:Connect(function()
        if isEnabled and rootJoint and rootJoint.Parent then
            local c0 = rootJoint.C0
            local rx, ry, rz = c0:ToEulerAnglesXYZ()
            rootJoint.C0 = CFrame.new(0, c0.Y, c0.Z) * CFrame.fromEulerAnglesXYZ(rx, ry, rz)
        end
    end)
end

local function disableSwayFix()
    if swayFixConnection then
        swayFixConnection:Disconnect()
        swayFixConnection = nil
    end
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local rootJoint = hrp:FindFirstChild("RootJoint")
            if rootJoint then rootJoint.C0 = DEFAULT_ROOT_C0 end
        end
    end
end

local function applyHipHeight(height)
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.HipHeight = height end
        enableSwayFix(character)
    end
   
    if hipHeightConnection then hipHeightConnection:Disconnect() end
   
    hipHeightConnection = LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if isEnabled then
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then hum.HipHeight = currentHeight end
            enableSwayFix(char)
        end
    end)
end

local function resetHipHeight()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.HipHeight = 2 end
    end
    disableSwayFix()
    if hipHeightConnection then
        hipHeightConnection:Disconnect()
        hipHeightConnection = nil
    end
end

-- ====================== WALK SPEED ======================
local function setWalkSpeed(speed)
    currentWalkSpeed = speed
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.WalkSpeed = speed end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then hum.WalkSpeed = currentWalkSpeed end
end)

-- ====================== FULL BRIGHT ======================
local function enableFullBright()
    fullBrightEnabled = true
    Lighting.Brightness = 2
    Lighting.ClockTime = 12
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") then
            v.Enabled = false
        end
    end
end

local function disableFullBright()
    fullBrightEnabled = false
    Lighting.Brightness = 1
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = true
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end

-- ====================== UI (All teleports now in ONE "Teleports" section) ======================
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Hip Height")
local Toggle = MainTab:CreateToggle({
    Name = "Enable Hip Height",
    CurrentValue = false,
    Flag = "HipHeightToggle",
    Callback = function(Value)
        isEnabled = Value
        if isEnabled then
            applyHipHeight(currentHeight)
        else
            resetHipHeight()
        end
    end,
})

local HeightSlider = MainTab:CreateSlider({
    Name = "Hip Height",
    Range = {2, 17},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 2,
    Flag = "HipHeightSlider",
    Callback = function(Value)
        currentHeight = Value
        if isEnabled then
            applyHipHeight(currentHeight)
        end
    end,
})

MainTab:CreateSection("Movement")
local WalkSpeedSlider = MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = " studs/sec",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        setWalkSpeed(Value)
    end,
})

MainTab:CreateSection("Visuals")
local FullBrightToggle = MainTab:CreateToggle({
    Name = "Full Bright (Always Bright)",
    CurrentValue = false,
    Flag = "FullBrightToggle",
    Callback = function(Value)
        if Value then
            enableFullBright()
        else
            disableFullBright()
        end
    end,
})

-- ==================== ALL TELEPORTS IN ONE CLEAN SECTION ====================
MainTab:CreateSection("Teleports")

MainTab:CreateButton({
    Name = "🚀 Teleport Inside Elevator",
    Callback = function()
        teleportInsideElevator()
    end,
})

MainTab:CreateButton({
    Name = "🚀 Nearest Machine",
    Callback = teleportToNearestMachine,
})

MainTab:CreateButton({
    Name = "🔄 Next / Different Machine",
    Callback = teleportToNextMachine,
})

MainTab:CreateButton({
    Name = "🚀 Nearest Research Capsule",
    Callback = teleportToNearestCapsule,
})

MainTab:CreateButton({
    Name = "🔄 Next / Different Capsule",
    Callback = teleportToNextCapsule,
})
-- ==================== END OF TELEPORTS SECTION ====================

-- Quick Hip Height Presets
MainTab:CreateSection("Quick Hip Height Presets")
local presets = {
    {name = "Default (2)", value = 2},
    {name = "12 (Safe)", value = 12},
    {name = "17 (Max Distract)", value = 17},
}
for _, preset in ipairs(presets) do
    MainTab:CreateButton({
        Name = preset.name,
        Callback = function()
            currentHeight = preset.value
            HeightSlider:Set(preset.value)
            if isEnabled then
                applyHipHeight(preset.value)
            end
            Rayfield:Notify({
                Title = "Preset Applied",
                Content = "Hip Height set to " .. preset.value .. " studs",
                Duration = 2,
            })
        end,
    })
end

-- Info
MainTab:CreateSection("Info")
MainTab:CreateLabel("Made by noahexploits")
MainTab:CreateLabel("✅ All teleports grouped in one 'Teleports' section")
MainTab:CreateLabel("Use 'Next' buttons to cycle after finishing one!")

Rayfield:Notify({
    Title = "🌷 Script Loaded Successfully",
    Content = "All teleports now neatly organized under one section!\nHip Height • WalkSpeed • Full Bright • Enhanced TPs",
    Duration = 6,
})
```
