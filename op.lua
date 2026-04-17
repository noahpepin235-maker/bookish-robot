-- 🌷 Noah's Full Pack - Hip Height + WalkSpeed + Full Bright + All Teleports + 40 Stud Flying Research + ESP
-- Made by noahexploits | Machine TP = 30 studs above

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

local ESPEnabled = false
local MachineESPEnabled = false
local ESPObjects = {}
local MachineESPObjects = {}

local currentCapsuleIndex = 1
local currentMachineIndex = 1

-- ====================== 40 STUD FLYING ======================
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
    if flightConnection then flightConnection:Disconnect() flightConnection = nil end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
end

-- ====================== MONSTER + TWISTED ======================
local function getAllMonsters()
    local list = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("monster") or n:find("twisted") then
            local root = obj:FindFirstChildWhichIsA("BasePart") or (obj:IsA("Model") and obj.PrimaryPart)
            if root then table.insert(list, root) end
        end
    end
    return list
end

local function autoResearchLoop()
    if not ResearchOn then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    OriginalCFrame = char.HumanoidRootPart.CFrame
    startFlying()

    local targets = getAllMonsters()
    if #targets == 0 then
        Rayfield:Notify({Title = "Auto Research", Content = "No Monster/Twisted found!", Duration = 5})
        stopFlying()
        ResearchOn = false
        return
    end

    for _, target in ipairs(targets) do
        if not ResearchOn then break end
        char.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, currentFlightHeight, 0)
        local screenPos = workspace.CurrentCamera:WorldToViewportPoint(target.Position + Vector3.new(0,20,0))
        VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)
        task.wait(0.8)
    end

    if OriginalCFrame then char.HumanoidRootPart.CFrame = OriginalCFrame end
    stopFlying()
end

-- ====================== ESP ======================
local function updateMachineESP()
    if not MachineESPEnabled then
        for _, data in pairs(MachineESPObjects) do pcall(function() data.H:Destroy() data.B:Destroy() end) end
        MachineESPObjects = {}
        return
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("machine") or n:find("generator") then
            local root = obj:FindFirstChildWhichIsA("BasePart") or (obj:IsA("Model") and obj.PrimaryPart)
            if root and not MachineESPObjects[root] then
                local h = Instance.new("Highlight", root)
                h.FillColor = Color3.fromRGB(0, 255, 255)
                h.FillTransparency = 0.5
                local b = Instance.new("BillboardGui", root)
                b.Size = UDim2.new(0,200,0,50) b.StudsOffset = Vector3.new(0,4,0) b.AlwaysOnTop = true
                local t = Instance.new("TextLabel", b)
                t.Size = UDim2.new(1,0,1,0) t.BackgroundTransparency = 1
                t.Text = obj.Name t.TextColor3 = Color3.fromRGB(0,255,255) t.TextScaled = true
                MachineESPObjects[root] = {H = h, B = b}
            end
        end
    end
end

local function updateMonsterESP()
    if not ESPEnabled then
        for _, data in pairs(ESPObjects) do pcall(function() data.H:Destroy() data.B:Destroy() end) end
        ESPObjects = {}
        return
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("monster") or n:find("twisted") then
            local root = obj:FindFirstChildWhichIsA("BasePart") or (obj:IsA("Model") and obj.PrimaryPart)
            if root and not ESPObjects[root] then
                local h = Instance.new("Highlight", root)
                h.FillColor = Color3.fromRGB(255, 0, 100)
                h.FillTransparency = 0.4
                local b = Instance.new("BillboardGui", root)
                b.Size = UDim2.new(0,200,0,50) b.StudsOffset = Vector3.new(0,5,0) b.AlwaysOnTop = true
                local t = Instance.new("TextLabel", b)
                t.Size = UDim2.new(1,0,1,0) t.BackgroundTransparency = 1
                t.Text = root.Parent.Name t.TextColor3 = Color3.fromRGB(255,100,200) t.TextScaled = true
                ESPObjects[root] = {H = h, B = b}
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
    Rayfield:Notify({Title = "✅ Teleported", Content = name, Duration = 3})
end

local function getAllMachines()
    local m = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        local n = v.Name:lower()
        if (n:find("machine") or n:find("generator")) and (v:IsA("Model") or v:IsA("BasePart")) then
            table.insert(m, v)
        end
    end
    return m
end

local function teleportToNearestMachine()
    local m = getAllMachines()
    if #m == 0 then Rayfield:Notify({Title="Error", Content="No machines found", Duration=5}) return end
    table.sort(m, function(a,b) return (a:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < (b:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude end)
    teleportToTarget(m[1], 30, "Nearest Machine (30 studs above)")  -- ← CHANGED TO 30
end

local function teleportToNextMachine()
    local m = getAllMachines()
    if #m == 0 then Rayfield:Notify({Title="Error", Content="No machines found", Duration=5}) return end
    currentMachineIndex = (currentMachineIndex % #m) + 1
    teleportToTarget(m[currentMachineIndex], 30, "Next Machine (30 studs above)")  -- ← CHANGED TO 30
end

local function teleportToNearestCapsule()
    local c = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("capsule") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            table.insert(c, obj)
        end
    end
    if #c == 0 then return end
    table.sort(c, function(a,b) return (a:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < (b:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude end)
    teleportToTarget(c[1], 8, "Nearest Research Capsule")
end

local function teleportToNextCapsule()
    local c = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("capsule") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            table.insert(c, obj)
        end
    end
    if #c == 0 then return end
    currentCapsuleIndex = (currentCapsuleIndex % #c) + 1
    teleportToTarget(c[currentCapsuleIndex], 8, "Next Research Capsule")
end

local function teleportInsideElevator()
    local elev = workspace:FindFirstChild("Elevator", true)
    if elev then teleportToTarget(elev, 4, "Elevator") end
end

-- ====================== OTHER FEATURES ======================
local function applyHipHeight(height)
    currentHeight = height
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.HipHeight = height end
    end
end

local function setWalkSpeed(speed)
    currentWalkSpeed = speed
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = speed end
    end
end

local function enableFullBright()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
end

local function disableFullBright()
    Lighting.Brightness = 1
    Lighting.GlobalShadows = true
    Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
end

-- ====================== UI ======================
local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Hip Height")
MainTab:CreateToggle({Name = "Enable Hip Height", CurrentValue = false, Callback = function(v) isEnabled = v if v then applyHipHeight(currentHeight) end end})
MainTab:CreateSlider({Name = "Hip Height", Range = {2, 17}, Increment = 1, Suffix = " studs", CurrentValue = 17, Callback = function(v) currentHeight = v if isEnabled then applyHipHeight(v) end end})

MainTab:CreateSection("Movement")
MainTab:CreateSlider({Name = "Walk Speed", Range = {1, 100}, Increment = 1, Suffix = " studs/sec", CurrentValue = 16, Callback = setWalkSpeed})

MainTab:CreateSection("Visuals")
MainTab:CreateToggle({Name = "Full Bright", CurrentValue = false, Callback = function(v) if v then enableFullBright() else disableFullBright() end end})

MainTab:CreateSection("Teleports")
MainTab:CreateButton({Name = "🚀 Teleport Inside Elevator", Callback = teleportInsideElevator})
MainTab:CreateButton({Name = "🚀 Nearest Machine (30 studs)", Callback = teleportToNearestMachine})
MainTab:CreateButton({Name = "🔄 Next Machine (30 studs)", Callback = teleportToNextMachine})
MainTab:CreateButton({Name = "🚀 Nearest Research Capsule (8 studs)", Callback = teleportToNearestCapsule})
MainTab:CreateButton({Name = "🔄 Next Research Capsule (8 studs)", Callback = teleportToNextCapsule})

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
    Content = "Machine Teleports now 30 studs above!",
    Duration = 10,
})
