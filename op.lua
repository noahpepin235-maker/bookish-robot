-- 🌷 Noah's FULL Pack - Hip Height + WalkSpeed + Full Bright + Teleports + AUTO RESEARCH (40 Stud FLY - ANTI FALL)
-- Made by noahexploits (Now actually stays in the air 🔥)

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

local ResearchOn = false
local OriginalCFrame = nil
local flightConnection = nil
local currentFlightHeight = 40

-- ====================== STRONG ANTI-FALL FLYING ======================
local function startFlying(targetHeight)
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    humanoid.PlatformStand = true

    if flightConnection then flightConnection:Disconnect() end

    flightConnection = RunService.Heartbeat:Connect(function()
        if not ResearchOn then 
            flightConnection:Disconnect()
            return 
        end
        
        local currentPos = hrp.Position
        local targetPos = Vector3.new(currentPos.X, targetHeight, currentPos.Z)
        
        hrp.CFrame = CFrame.new(targetPos, currentPos + hrp.CFrame.LookVector) -- Keep looking forward
        hrp.Velocity = Vector3.new(hrp.Velocity.X * 0.1, 0, hrp.Velocity.Z * 0.1) -- Kill falling momentum
    end)
end

local function stopFlying()
    if flightConnection then 
        flightConnection:Disconnect() 
        flightConnection = nil 
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
    startFlying(hrp.Position.Y + currentFlightHeight)  -- Start flying at +40 studs

    local monsters = getAllMonsters()
    if #monsters == 0 then
        Rayfield:Notify({Title = "Auto Research", Content = "No monsters found!", Duration = 5})
        stopFlying()
        ResearchOn = false
        return
    end

    Rayfield:Notify({Title = "🌟 FLYING RESEARCH STARTED", Content = "Locked at 40 studs above monsters", Duration = 6})

    for _, monster in ipairs(monsters) do
        if not ResearchOn then break end

        -- Fly directly above monster at 40 studs
        local targetPos = monster.Position + Vector3.new(0, currentFlightHeight, 0)
        hrp.CFrame = CFrame.new(targetPos)

        -- Mouse hover
        local cam = workspace.CurrentCamera
        local screenPos = cam:WorldToViewportPoint(monster.Position + Vector3.new(0, 10, 0))
        VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)

        task.wait(0.75) -- Increased a bit for better research
    end

    -- Return to start
    if OriginalCFrame then
        hrp.CFrame = OriginalCFrame
    end
    stopFlying()

    Rayfield:Notify({Title = "✅ Research Cycle Done", Content = "Returned safely", Duration = 5})
end

-- ====================== REST OF YOUR SCRIPT (ALL ORIGINAL FEATURES) ======================
-- [Hip Height, Sway Fix, WalkSpeed, Full Bright, Teleports, ESP — all kept exactly as before]

-- (Paste all the previous sections here: ESP, Teleports, Hip Height, etc.)

-- In the UI section, update the toggle:
MainTab:CreateToggle({
    Name = "Get Research - FLY 40 Studs Over Monsters (ANTI-FALL)",
    CurrentValue = false,
    Callback = function(v)
        ResearchOn = v
        if v then 
            task.spawn(autoResearchLoop) 
        else
            stopFlying()
        end
    end,
})

MainTab:CreateLabel("✅ Now uses Heartbeat loop + PlatformStand")
MainTab:CreateLabel("You should no longer fall at all")

Rayfield:Notify({Title = "🌷 Fixed!", Content = "Strong anti-fall flying at 40 studs enabled", Duration = 8})
