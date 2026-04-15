-- 🌷 Noah's Hip Height Changer + Improved Elevator TP | For Dandy's World
-- Made by noahexploits (TP improved for reliability)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🌷 Noah's Hip Height Changer + Improved Elevator TP",
    LoadingTitle = "Noah's Hip Height Changer + Improved Elevator TP",
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
local LocalPlayer = Players.LocalPlayer
-- Variables
local isEnabled = false
local currentHeight = 2
local hipHeightConnection = nil
local swayFixConnection = nil
-- Default RootJoint C0 (Roblox standard)
local DEFAULT_ROOT_C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)

-- ====================== IMPROVED: TELEPORT TO ELEVATOR ======================
-- Much faster & more reliable detection:
-- 1. Uses workspace:FindFirstChild("Elevator", true) - Roblox's optimized recursive search
-- 2. Falls back to exact case-insensitive match
-- 3. Retries up to 5 seconds if elevator hasn't loaded yet (common in lobby/floor transitions)
local function findElevator()
    -- Priority 1: Fast native recursive search for exact "Elevator" (most common in Dandy's World)
    local elevator = workspace:FindFirstChild("Elevator", true)
    if elevator then
        return elevator
    end

    -- Priority 2: Exact case-insensitive match anywhere in workspace
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower() == "elevator" then
            return obj
        end
    end

    -- (Uncomment this block only if you still have issues - broader substring match)
    -- for _, obj in ipairs(workspace:GetDescendants()) do
    --     if obj.Name:lower():find("elevator") then
    --         return obj
    --     end
    -- end

    return nil
end

local function teleportInsideElevator()
    local character = LocalPlayer.Character
    if not character then 
        Rayfield:Notify({
            Title = "Error",
            Content = "Character not loaded yet!",
            Duration = 3,
        })
        return 
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        Rayfield:Notify({
            Title = "Error",
            Content = "HumanoidRootPart not found!",
            Duration = 3,
        })
        return 
    end

    -- Retry loop (up to 5 seconds) in case elevator is still loading
    local elevator = nil
    for i = 1, 10 do
        elevator = findElevator()
        if elevator then break end
        task.wait(0.5)
    end

    if elevator then
        local targetPart = nil
        if elevator:IsA("Model") then
            targetPart = elevator.PrimaryPart or elevator:FindFirstChildWhichIsA("BasePart")
        else
            targetPart = elevator
        end
        
        if targetPart then
            -- Improved teleport: uses model pivot when available + 4 studs up
            -- Places you cleanly inside the elevator (center + height)
            local pivotCFrame = elevator:IsA("Model") and elevator:GetPivot() or targetPart.CFrame
            hrp.CFrame = pivotCFrame * CFrame.new(0, 4, 0)
            
            Rayfield:Notify({
                Title = "✅ Teleported!",
                Content = "You are now inside the elevator (improved detection)",
                Duration = 3,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Elevator found but no valid part to teleport to",
                Duration = 3,
            })
        end
    else
        Rayfield:Notify({
            Title = "Error",
            Content = "Elevator not found after 5 seconds (try waiting for lobby/floor to load)",
            Duration = 5,
        })
    end
end
-- ====================== END OF IMPROVED TELEPORT CODE ======================

-- Sway Fix (unchanged)
local function enableSwayFix(character)
    if swayFixConnection then
        swayFixConnection:Disconnect()
        swayFixConnection = nil
    end
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
local function disableSwayFix(character)
    if swayFixConnection then
        swayFixConnection:Disconnect()
        swayFixConnection = nil
    end
    local char = character or LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local rootJoint = hrp:FindFirstChild("RootJoint")
            if rootJoint then
                rootJoint.C0 = DEFAULT_ROOT_C0
            end
        end
    end
end
local function applyHipHeight(height)
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.HipHeight = height
        end
        enableSwayFix(character)
    end
   
    if hipHeightConnection then
        hipHeightConnection:Disconnect()
    end
   
    hipHeightConnection = LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if isEnabled then
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then
                hum.HipHeight = currentHeight
            end
            enableSwayFix(char)
        end
    end)
end
local function resetHipHeight()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.HipHeight = 2
        end
    end
    disableSwayFix()
    if hipHeightConnection then
        hipHeightConnection:Disconnect()
        hipHeightConnection = nil
    end
end
-- UI Tab
local MainTab = Window:CreateTab("Hip Height", 4483362458)
-- Controls Section
MainTab:CreateSection("Controls")
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
local Slider = MainTab:CreateSlider({
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
-- Quick Presets
MainTab:CreateSection("Quick Presets")
local presets = {
    {name = "Default (2)", value = 2},
    {name = "12 (Cannot distract pebble, dyle, dandy)", value = 12},
    {name = "17 (can distract lethals and pebble)", value = 17},
}
for _, preset in ipairs(presets) do
    MainTab:CreateButton({
        Name = preset.name,
        Callback = function()
            currentHeight = preset.value
            Slider:Set(preset.value)
            if isEnabled then
                applyHipHeight(preset.value)
            end
            Rayfield:Notify({
                Title = "Preset Applied",
                Content = "Hip Height set to " .. preset.value .. " studs",
                Duration = 2,
                Image = 4483362458,
            })
        end,
    })
end

-- Teleport Section
MainTab:CreateSection("Teleports")
MainTab:CreateButton({
    Name = "🚀 Teleport Inside Elevator",
    Callback = function()
        teleportInsideElevator()
    end,
})

-- Info Section
MainTab:CreateSection("Info")
MainTab:CreateLabel("Hip Height Range: 2 - 17 studs")
MainTab:CreateLabel("Default Roblox Hip Height: ~2 studs")
MainTab:CreateLabel("Made by noahexploits • Elevator detection improved (faster + retries)")
-- Load Notification
Rayfield:Notify({
    Title = "🌷 Noah's Hip Height Changer + Improved Elevator TP",
    Content = "Loaded successfully!\nElevator TP is now faster and more reliable",
    Duration = 5,
    Image = 4483362458,
})
