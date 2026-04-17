-- 🌷 Noah's Full Pack - Hip Height + WalkSpeed + Full Bright + Teleports + 40 Stud Flying Research + ESP
-- Made by noahexploits | Monster + Twisted Research

print("🌷 Noah's Script Loading...")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
end

local Window = Rayfield:CreateWindow({
    Name = "🌷 Noah's Full Pack - Monster & Twisted",
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
local ESPObjects = {}

-- ====================== STRONG 40 STUD FLYING ======================
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

-- ====================== MONSTER + TWISTED DETECTION ======================
local function getAllMonsters()
    local monsters = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        local nameLower = obj.Name:lower()
        -- Now gets BOTH Monster and Twisted
        if nameLower:find("monster") or nameLower:find("twisted") then
            local root = obj:FindFirstChildWhichIsA("BasePart") or (obj:IsA("Model") and obj.PrimaryPart)
            if root then 
                table.insert(monsters, root) 
            end
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

    local targets = getAllMonsters()
    if #targets == 0 then
        Rayfield:Notify({Title = "Auto Research", Content = "No Monster or Twisted found yet!", Duration = 6})
        stopFlying()
        ResearchOn = false
        return
    end

    Rayfield:Notify({Title = "🌟 MONSTER + TWISTED RESEARCH", Content = "Flying 40 studs above all targets...", Duration = 7})

    for _, target in ipairs(targets) do
        if not ResearchOn then break end

        char.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, currentFlightHeight, 0)

        local screenPos = workspace.CurrentCamera:WorldToViewportPoint(target.Position + Vector3.new(0, 20, 0))
        VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)

        task.wait(0.8)
    end

    if OriginalCFrame then char.HumanoidRootPart.CFrame = OriginalCFrame end
    stopFlying()
    Rayfield:Notify({Title = "✅ Research Cycle Done", Content = "Researched all Monsters & Twisteds", Duration = 5})
end

-- ====================== ESP (Monster + Twisted) ======================
local function updateMonsterESP()
    if not ESPEnabled then
        for _, data in pairs(ESPObjects) do 
            pcall(function() data.H:Destroy() data.B:Destroy() end) 
        end
        ESPObjects = {}
        return
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        local nameLower = obj.Name:lower()
        if (nameLower:find("monster") or nameLower:find("twisted")) then
            local root = obj:FindFirstChildWhichIsA("BasePart") or (obj:IsA("Model") and obj.PrimaryPart)
            if root and not ESPObjects[root] then
                local h = Instance.new("Highlight")
                h.Adornee = root
                h.FillColor = Color3.fromRGB(255, 0, 100)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.FillTransparency = 0.4
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
            end
        end
    end
end

-- ====================== OTHER FEATURES ======================
local function teleportToTarget(target, heightOffset, name)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not target then return end
    local cf = target:IsA("Model") and target:GetPivot() or target.CFrame
    hrp.CFrame = cf * CFrame.new(0, heightOffset or 5, 0)
    Rayfield:Notify({Title = "✅ Teleported", Content = "To " .. (name or "target"), Duration = 3})
end

local function teleportToNearestMachine()
    local m = {}
    for _, v in ipairs(workspace:GetDescendants()) do
        local n = v.Name:lower()
        if (n:find("machine") or n:find("generator")) and (v:IsA("Model") or v:IsA("BasePart")) then
            table.insert(m, v)
        end
    end
    if #m == 0 then return end
    table.sort(m, function(a,b) 
        return (a:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < (b:GetPivot().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude 
    end)
    teleportToTarget(m[1], 5, "Nearest Machine")
end

local function teleportInsideElevator()
    local elev = workspace:FindFirstChild("Elevator", true)
    if elev then teleportToTarget(elev, 4, "Elevator") end
end

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
MainTab:CreateToggle({Name = "Enable Hip Height", CurrentValue = false, Callback = function(v) isEnabled = v; if v then applyHipHeight(currentHeight) end end})
MainTab:CreateSlider({Name = "Hip Height", Range = {2, 17}, Increment = 1, Suffix = " studs", CurrentValue = 17, Callback = function(v) currentHeight = v; if isEnabled then applyHipHeight(v) end end})

MainTab:CreateSection("Movement")
MainTab:CreateSlider({Name = "Walk Speed", Range = {1, 100}, Increment = 1, Suffix = " studs/sec", CurrentValue = 16, Callback = setWalkSpeed})

MainTab:CreateSection("Visuals")
MainTab:CreateToggle({Name = "Full Bright", CurrentValue = false, Callback = function(v) if v then enableFullBright() else disableFullBright() end end})

MainTab:CreateSection("Teleports")
MainTab:CreateButton({Name = "🚀 Teleport Inside Elevator", Callback = teleportInsideElevator})
MainTab:CreateButton({Name = "🚀 Nearest Machine", Callback = teleportToNearestMachine})

MainTab:CreateSection("🌟 Monster & Twisted Research")
MainTab:CreateToggle({Name = "Monster + Twisted ESP (Pink)", CurrentValue = false, Callback = function(v) ESPEnabled = v end})
MainTab:CreateToggle({Name = "Get Research - MONSTER + TWISTED (40 Studs)", CurrentValue = false, Callback = function(v)
    ResearchOn = v
    if v then task.spawn(autoResearchLoop) else stopFlying() end
end})

RunService.Heartbeat:Connect(updateMonsterESP)

Rayfield:Notify({
    Title = "🌷 Loaded Successfully!",
    Content = "Now researches BOTH Monster and Twisted!",
    Duration = 10,
})
