local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Everyx Hub" .. "0.0.1(BETA),
    SubTitle = "by Everyx",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftAlt -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Ring1 = Window:AddTab({ Title = "Ring 1", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

Fluent:Notify({
    Title = "Notification",
    Content = "Join my dc🙏https://discord.gg/Z2AT6b2HA7 ",
    SubContent = "",
    Duration = 10
    })


local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local function moveto(obj, speed)
    local player = Players.LocalPlayer
    if not player or not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- resolve target CFrame and position
    local targetCFrame, targetPos
    local t = typeof(obj)
    if t == "Instance" then
        if obj:IsA("BasePart") then
            targetCFrame = obj.CFrame
            targetPos = obj.Position
        elseif obj:IsA("Model") and obj.PrimaryPart then
            targetCFrame = obj:GetPrimaryPartCFrame()
            targetPos = targetCFrame.p
        else
            error("moveto: Unsupported Instance type")
        end
    elseif t == "CFrame" then
        targetCFrame = obj
        targetPos = obj.p
    elseif t == "Vector3" then
        targetCFrame = CFrame.new(obj)
        targetPos = obj
    else
        error("moveto: expected Instance, CFrame, or Vector3")
    end

    local distance = (hrp.Position - targetPos).Magnitude
    if distance == 0 then return end

    local info = TweenInfo.new(distance/speed)
    local tween = TweenService:Create(hrp, info, {CFrame = targetCFrame})

    -- create or reuse an antifall BodyVelocity
    local antifall = hrp:FindFirstChild("Everyx_Antifall")
    local createdAntifall = false
    if not antifall then
        antifall = Instance.new("BodyVelocity")
        antifall.Name = "Everyx_Antifall"
        antifall.Parent = hrp
        antifall.Velocity = Vector3.new(0, 1, 0)
        antifall.MaxForce = Vector3.new(0, math.huge, 0)
        createdAntifall = true
    end

    -- use existing noclip function if available
    local noclipConnection
    if type(noclip) == "function" then
        noclipConnection = RunService.Stepped:Connect(noclip)
    else
        noclipConnection = RunService.Stepped:Connect(function()
            if not player.Character then return end
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end

    tween:Play()

    tween.Completed:Connect(function()
        if createdAntifall and antifall then
            antifall:Destroy()
        end
        if noclipConnection then
            noclipConnection:Disconnect()
        end
    end)
end



Tabs.Ring1:AddParagraph({
    Title = "Ring 1 tab",
    Content = "Auto boss, auto npc(probably soon),esp npcs,auto afk 25h"
    })
    Tabs.Ring1:AddButton({
        Title = "Esp npcs",
        Description = "Esp hell npcs",
        Callback = function()
            local player = game:GetService("Players").LocalPlayer
local character = nil
local humanoidRootPart = nil

-- Function to setup character references
local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Handle character death
    character:WaitForChild("Humanoid").Died:Connect(function()
        character = nil
        humanoidRootPart = nil
    end)
end

-- Initial setup
setupCharacter()
player.CharacterAdded:Connect(setupCharacter)

function findLGuys()
    local lavaGuys = {}
    for _, child in ipairs(workspace.Entities:GetDescendants()) do
        if child.Name == "LavaGuy" then
            table.insert(lavaGuys, child)
        end
    end
    return lavaGuys
end

function createBillboard(lguy)
    if lguy:FindFirstChild("LavaGuyLabel") then
        return
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "LavaGuyLabel"
    billboard.Adornee = lguy
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 500
    billboard.LightInfluence = 0
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 24
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.new(1, 0.5, 0)
    uiStroke.Thickness = 2
    uiStroke.Transparency = 0.3
    uiStroke.Parent = textLabel
    
    local connection
    local function updateLabel()
        if not lguy or not lguy.Parent then
            if connection then
                connection:Disconnect()
            end
            return
        end
        
        if not humanoidRootPart then
            textLabel.Text = "LavaGuy\nHP: ? | Dist: ?"
            return
        end
        
        local distance = (lguy:GetPivot().Position - humanoidRootPart.Position).Magnitude
        local hp = lguy:FindFirstChild("Humanoid") and math.floor(lguy.Humanoid.Health) or "N/A"
        
        textLabel.Text = string.format("LavaGuy\nHP: %s | Dist: %d", hp, math.floor(distance))
    end
    
    connection = game:GetService("RunService").Heartbeat:Connect(updateLabel)
    
    -- Clean up connection when billboard is destroyed
    billboard.AncestryChanged:Connect(function(_, parent)
        if not parent then
            connection:Disconnect()
        end
    end)
    
    textLabel.Parent = billboard
    billboard.Parent = lguy
end

while true do
    wait(5)
    local lavaGuys = findLGuys()
    
    for _, lguy in ipairs(lavaGuys) do
        createBillboard(lguy)
    end
end
        end
    })



local afkposMode = "Premade"

    local AfkPos = Tabs.Main
Ring1:AddDropdown("AfkPos", {
        Title = "AfkPos",
        Values = {"Premade","Custom"},
        Multi = false,
        Default = 1,
    })

    Dropdown:SetValue("Premade")

    Dropdown:OnChanged(function(Value)
        afkposMode = Value
    end)

    Tabs.Ring1:AddButton({
        Title = "Start afk",
        Description = "Rejoin to disable",
        Callback = function()
            if afkPosMode == "Premade" then
                while true do
                    moveto(Vector3.new(907.8778076171875,2173.336669921875,-36.08327865600586),100)
                end
            end
        end
    })


-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()