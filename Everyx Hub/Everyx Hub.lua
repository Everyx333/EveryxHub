local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local EveryxHub = Fluent:CreateWindow({
    Title = "Everyx Hub " .. "1.0.0" ,
    SubTitle = "by Everyx",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Home = EveryxHub:AddTab({ Title = "Home", Icon = "home" }),
    Main = EveryxHub:AddTab({ Title = "Main", Icon = "folder-open" }),
    AF = EveryxHub:AddTab({ Title = "Auto Farm", Icon = "axe" }),
    Misc = EveryxHub:AddTab({ Title = "Misc", Icon = "folder-minus" }),
    Settings = EveryxHub:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options
local lp = game.Players.LocalPlayer
local character = lp.Character or lp.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local RS = game.ReplicatedStorage
local VirtualUser = game:GetService("VirtualUser")
local selectedWeapon = ""


local function rotateToGround()
    local position = hrp.Position
    
    local downwardsCFrame = CFrame.new(position, position - Vector3.new(0, 1, 0))
    hrp.CFrame = downwardsCFrame
end


local function getAccessories()
    local accessoriesFolder = RS:WaitForChild("Accessories")
    local accessoriesTable = {}
    for _, descendant in ipairs(accessoriesFolder:GetDescendants()) do
        if descendant:IsA("Accessory") then
            table.insert(accessoriesTable, descendant.Name)
        end
    end

    return accessoriesTable
end

local selectedNPC

local function getNPC()
    local dist, thing = math.huge
    for i, v in pairs(game:GetService("Workspace").Mob:GetChildren()) do
        if v.Name == selectedNPC then
            local humanoid = v:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                if mag < dist then 
                    dist = mag 
                    thing = v 
                end
            end
        end
    end
    return thing
end

local function getFX()
    local fxFolder = Workspace.FX
    for _, effect in ipairs(fxFolder:GetDescendants()) do
        if effect.Name ~= "cidbata2" then
            effect:Destroy()
        end
    end

    for _, highlight in ipairs(Workspace.Character:FindFirstChild(lp.Name):GetDescendants()) do
        if highlight.Name == "Highlight" then
            highlight:Destroy()
        end
    end
end


local TweenService  = game:GetService("TweenService")
local noclipE = false
local antifall = false
 
local function noclip()
    for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end
 
local function moveto(obj)
    
    hrp.CFrame = CFrame.new(obj.Position.X, obj.Position.Y + AFOffset, obj.Position.Z)
    if hrp.Anchored == true then
        hrp.Anchored = false
        wait()
        hrp.Anchored = true
    else
        hrp.Anchored = false
    end
end


local AFOffset = 15


local afnpc = false

local npcTable = {}

function getNPCs()
    for _, npc in ipairs(Workspace.Mob:GetDescendants()) do
        if npc:IsA("Model") then
            if not table.find(npcTable, npc.Name) then
                table.insert(npcTable, npc.Name)
            end
        end
    end    
    return npcTable
end    

--auto farm tab



local npcDropdown = Tabs.AF:AddDropdown("Dropdown", {
    Title = "NPC",
    Values = getNPCs(),
    Default = 1,
})

npcDropdown:SetValue("Bacon")

npcDropdown:OnChanged(function(Value)
   selectedNPC = Value
end)



local AFNPC = Tabs.AF:AddToggle("AFNPC", {Title = "Auto farm selected npc", Default = false })

AFNPC:OnChanged(function()
    afnpc = Options.AFNPC.Value
    while afnpc == true do 
        task.wait()
        local tool = lp.Backpack:FindFirstChild(selectedWeapon)
	    if tool then
            tool.Parent = character
            humanoid:EquipTool(tool)
        end
        moveto(getNPC())
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(9e9, 9e9))
    end
    while afnpc == false do
        wait()
        hrp.Anchored = false
    end
end)

Tabs.AF:AddParagraph({
    Title = "Auto Farm Settings",
    Content = "Auto Farm Settings are below this message!"
})

local EntOffset = Tabs.AF:AddInput("Input", {
    Title = "Enter Y Offset",
    Description = "Enter Y offset to auto farm",
    Default = "",
    Placeholder = "Enter offset...",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        AFOffset = Value
    end
})

local weaponsTable = {}

local function getWeapons()
    local bp = lp.Backpack

    for _, weapon in ipairs(bp:GetDescendants()) do
        if weapon:IsA("Tool") then
            table.insert(weaponsTable, weapon.Name)
        end
    end

    return weaponsTable
end

local weapons = Tabs.AF:AddDropdown("WDropdown", {
    Title = "Weapon",
    Values = getWeapons(),
    Default = 1,
})

weapons:OnChanged(function(Value)
    selectedWeapon = Value
end)

--misc tab
local selectedAccessory

local accessory = Tabs.Misc:AddDropdown("ADropdown", {
    Title = "Accessory",
    Values = getAccessories(),
    Default = 1,
})

accessory:SetValue("oioioi")

accessory:OnChanged(function(Value)
   selectedAccessory = Value
end)

Tabs.Misc:AddButton({
    Title = "Accessory equip",
    Description = "Press to equip selected accessory",
    Callback = function()
        local args = {
            [1] = selectedAccessory
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Inventory"):FireServer(unpack(args))
        
    end
})


local FxToggle = Tabs.Misc:AddToggle("FxDestroy", {Title = "Press to destroy the fx, unrevertable", Default = false })

    FxToggle:OnChanged(function()
        if Options.FxDestroy.Value == true then
            Fluent:Notify({
                Title = "Warning",
                Content = "If you want to turn it off, disable the toggle and rejoin!",
                SubContent = "",
                Duration = 10
            })
        end
        while Options.FxDestroy.Value == true do
            wait()
            getFX()
        end
    end)

    Options.FxDestroy:SetValue(false)


SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({})

InterfaceManager:SetFolder("EveryxHub")
SaveManager:SetFolder("EveryxHub/RockFruit")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


EveryxHub:SelectTab(1)

--[[Fluent:Notify({
    Title = "Fluent",
    Content = "You logged in as " .. lp.Name .. "You use " .. key_status .. ".",
    Duration = 8
})]]

local CoreGui = game:GetService("CoreGui")

local function renameScreenGuis(newName)
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "ScreenGui" then
            gui.Name = newName
        end
    end
end

renameScreenGuis("EveryxHub")
local EveryxHubUi = CoreGui.EveryxHub


local function renameScreenGuiss(newName)
    for _, gui in ipairs(EveryxHubUi:GetChildren()) do
        if gui:IsA("Frame") and gui:FindFirstChild("CanvasGroup") then
            gui.Name = newName
        end
    end
end

local function setupOpenCloseUi()
    local openClose = Instance.new("ImageButton")
    local UiCorner = Instance.new("UICorner")
    
    openClose.Parent = EveryxHubUi
    UiCorner.Parent = openClose
    openClose.Name = "OpenClose"
    openClose.Size = UDim2.new(0, 50, 0, 50)
    openClose.Position = UDim2.new(0.15171, 0, 0.35618, 0)
    openClose.Image = "rbxassetid://92834712270430"

    local function toggleMainFrameVisibility()
        EveryxHubUi.MainFrame.Visible = not EveryxHubUi.MainFrame.Visible
    end

    openClose.MouseButton1Click:Connect(toggleMainFrameVisibility)

    openClose.TouchTap:Connect(toggleMainFrameVisibility)
end

local function setupAutoFarmTurnOffOn()
    local AFTOON = Instance.new("TextButton")
    local UiCorner2 = Instance.new("UICorner")

    AFTOON.Parent = EveryxHubUi
    UiCorner2.Parent = AFTOON

    AFTOON.Name = "AFTOON"
    AFTOON.Size = UDim2.new(0, 50, 0, 50)
    AFTOON.Position = UDim2.new(0.20000, 0, 0.35618, 0)
    AFTOON.Text = "Turn off auto farm"
    AFTOON.TextColor3 = Color3.fromRGB(255, 255, 255)
    AFTOON.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    
    local function toggleAutoFarmOffOn()
        if Options.AFNPC.Value == true then
            Options.AFNPC:SetValue(false)
        else
            Options.AFNPC:SetValue(true)
        end
    end

    AFTOON.MouseButton1Click:Connect(toggleAutoFarmOffOn)

    AFTOON.TouchTap:Connect(toggleAutoFarmOffOn)
end





renameScreenGuiss("MainFrame")
setupOpenCloseUi()
setupAutoFarmTurnOffOn()

SaveManager:LoadAutoloadConfig()

