-- 🌷 Noah's Full Pack - Hip Height + WalkSpeed + Full Bright + Teleports + 40 Stud Flying Research + ESP
-- Made by noahexploits | Optimized for JJSpolit

print("🌷 Noah's Script Loading...")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
end

local Window = Rayfield:CreateWindow({
    Name = "🌷 Noah's Full Pack - 40 Stud Flying",
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
local hipHeightConnection = nil
local swayFixConnection = nil
local currentWalkSpeed = 16
local fullBrightEnabled = false

local ResearchOn = false
local OriginalCFrame = nil
local flightConnection = nil
local currentFlightHeight = 40

local ESPEnabled = false
local ESPObjects = {}

local DEFAULT_ROOT_C0 = CFrame.new(0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 1, 0)

-- ====================== STRONG 40 STUD FLYING (ANTI-FALL) ======================
local function startFlying()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    hum.PlatformStand = true

    if flightConnection then flightConnection:Disconnect() end

    flightConnection = RunService.Heartbeat:Connect(function()
        if not ResearchOn then return end
        local pos = hrp.Position
        hrp.CFrame = CFrame.new(pos.X, currentFlightHeight, pos.Z)
        hrp.Velocity = Vector3.new(hrp.Velocity.X * 0.2, 0, hrp.Velocity.Z * 0.2)
    end)
end

local function stopFlying()
    if flightConnection then
        flightConnection:Disconnect()
        flightConnection = nil
    end
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

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    OriginalCFrame = char.HumanoidRootPart.CFrame
    startFlying()

    local monsters = getAllMonsters()
    if #monsters == 0 then
        Rayfield:Notify({Title = "Auto Research", Content = "No monsters found! Wait for floor to load.", Duration = 6})
        stopFlying()
        ResearchOn = false
        return
    end

    Rayfield:Notify({Title = "🌟 40 STUD FLYING RESEARCH", Content = "Locked at 40 studs - No falling", Duration = 7})

    for _, monster in ipairs(monsters) do
        if not ResearchOn then break end

        char.HumanoidRootPart.CFrame = monster.CFrame * CFrame.new(0, currentFlightHeight, 0)

        local screenPos = workspace.CurrentCamera:WorldToViewportPoint(monster.Position + Vector3.new(0, 20, 0))
        VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)

        task.wait(0.8)
    end

    if OriginalCFrame then char.HumanoidRootPart.CFrame = OriginalCFrame end
    stopFlying()
    Rayfield:Notify({Title = "✅ Research Cycle Done", Content = "Returned to start position", Duration = 5})
end

-- ====================== MONSTER ESP ======================
local function updateMonsterESP()
    if not ESPEnabled then
        for _, data in pairs(ESPObjects) do
            pcall(function() data.H:Destroy() data.B:Destroy() end)
        end
        ESPObjects = {}
        return
    end

    local found = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("monster") or obj.Name:lower():find("twisted") then
            local root = obj:FindFirstChildWhichIsA("BasePart") or (obj:IsA("Model") and obj.PrimaryPart)
            if root and not ESPObjects[root] then
                local h = Instance.new("Highlight")
                h.Adornee = root
                h.FillColor = Color3.fromRGB(255, 0, 100)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.FillTransparency = 0.4
                h.OutlineTransparency = 0
                h.Parent = root

                local b = Instance.new("BillboardGui")
                b.Adornee = root
                b.Size = UDim2.new(0, 200, 0, 50)
                b.StudsOffset = Vector3.new(0, 5, 0)
                b.AlwaysOnTop = true
                b.Parent = root

                local t = Instance.new("TextLabel")
                t.Size = UDim2.new(1,0,1,0)
                t.BackgroundTransparency = 1
                t.Text = root.Parent.Name
                t.TextColor3 = Color3.fromRGB(255, 100, 200)
                t.TextScaled = true
                t.Font = Enum.Font.GothamBold
                t.Parent = b

                ESPObjects[root] = {H = h, B = b}
                found[root] = true
            end
        end
    end
end

-- ====================== TELEPORTS ======================
local function teleportToTarget(target, heightOffset, name)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not target then return end
    local cf = target:IsA("Model") and target:GetPivot() or target.CFrame
    hrp.CFrame = cf * CFrame.new(0, heightOffset or 5, 0)
    Rayfield:Notify({Title = "✅ Teleported", Content = "To " .. (name or "target"), Duration = 3})
end

local function getAllMachines()
    local t = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        local n = v.Name:lower()
        if (n:find("machine") or n:find("generator")) and (v:IsA("Model") or v:IsA("BasePart")) then
            table.insert(t, v)
        end
    end
    return t
end

local function teleportToNearestMachine()
    local m = getAllMachines()
    if #m == 0 then Rayfield:Notify({Title="Error", Content="No machines found", Duration=5}) return end
    table.sort(m, function(a,b) 
        local pa = a:GetPivot().Position
        local pb = b:GetPivot().Position
        return (pa - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < (pb - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    end)
    teleportToTarget(m[1], 5, "Nearest Machine")
end

local function teleportInsideElevator()
    local elev = workspace:FindFirstChild("Elevator", true)
    if elev then
        teleportToTarget(elev, 4, "Elevator")
    else
        Rayfield:Notify({Title="Error", Content="Elevator not found", Duration=5})
    end
end

-- ====================== HIP HEIGHT + SWAY FIX ======================
local function enableSwayFix(char)
    if swayFixConnection then swayFixConnection:Disconnect() end
    local hrp = char:WaitForChild("HumanoidRootPart", 3)
    local root = hrp and hrp:WaitForChild("RootJoint", 3)
    if not root then return end

    swayFixConnection = RunService.Stepped:Connect(function()
        if isEnabled and root then
            local c0 = root.C0
            local rx, ry, rz = c0:ToEulerAnglesXYZ()
            root.C0 = CFrame.new(0, c0.Y, c0.Z) * CFrame.fromEulerAnglesXYZ(rx, ry, rz)
        end
    end)
end

local function applyHipHeight(height)
    currentHeight = height
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.HipHeight = height end
        enableSwayFix(char)
    end
end

local function resetHipHeight()
    isEnabled = false
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.HipHeight = 2 end
    end
    if swayFixConnection then swayFixConnection:Disconnect() end
end

-- ====================== WALKSPEED & FULLBRIGHT ======================
local function setWalkSpeed(speed)
    currentWalkSpeed = speed
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speed end
    end
end

local function enableFullBright()
    fullBrightEnabled = true
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
end

local function disableFullBright()
    fullBrightEnabled = false
    Lighting.Brightness = 1
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = true
    Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
end

-- ====================== UI ======================
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Hip Height")
MainTab:CreateToggle({
    Name = "Enable Hip Height",
    CurrentValue = false,
    Callback = function(v)
        isEnabled = v
        if v then applyHipHeight(currentHeight) else resetHipHeight() end
    end,
})
MainTab:CreateSlider({
    Name = "Hip Height",
    Range = {2, 17},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 17,
    Callback = function(v)
        currentHeight = v
        if isEnabled then applyHipHeight(v) end
    end,
})

MainTab:CreateSection("Movement")
MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = " studs/sec",
    CurrentValue = 16,
    Callback = setWalkSpeed,
})

MainTab:CreateSection("Visuals")
MainTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,
    Callback = function(v)
        if v then enableFullBright() else disableFullBright() end
    end,
})

MainTab:CreateSection("Teleports")
MainTab:CreateButton({Name = "🚀 Teleport Inside Elevator", Callback = teleportInsideElevator})
MainTab:CreateButton({Name = "🚀 Nearest Machine", Callback = teleportToNearestMachine})

MainTab:CreateSection("🌟 Monster ESP + 40 Stud Flying Research")
MainTab:CreateToggle({
    Name = "Monster ESP (Pink + Names)",
    CurrentValue = false,
    Callback = function(v) ESPEnabled = v end,
})

MainTab:CreateToggle({
    Name = "Get Research - FLY 40 Studs (NO FALL)",
    CurrentValue = false,
    Callback = function(v)
        ResearchOn = v
        if v then task.spawn(autoResearchLoop) else stopFlying() end
    end,
})

RunService.Heartbeat:Connect(updateMonsterESP)

Rayfield:Notify({
    Title = "🌷 Noah's Full Script Loaded!",
    Content = "40 Stud Flying + All Features Ready\nEnjoy farming research ~",
    Duration = 10,
})
