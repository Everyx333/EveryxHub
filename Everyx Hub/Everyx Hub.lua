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
local RS = game.ReplicatedStorage


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


--misc tab
local selectedAccessory

local accessory = Tabs.Misc:AddDropdown("Dropdown", {
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
    Content = "You logged in as " .. lp.Name .. "You use " .. _G.key_status .. ".",
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
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()

    local function onMouseClick()
        if EveryxHubUi.MainFrame.Visible == true then
            EveryxHubUi.MainFrame.Visible = false
        elseif EveryxHubUi.MainFrame.Visible == false then
            EveryxHubUi.MainFrame.Visible = true
        end    
    end


    openClose.MouseButton1Click:Connect(onMouseClick)
    openClose.TouchTap:Connect(onMouseClick)
end    

renameScreenGuiss("MainFrame")
setupOpenCloseUi()

SaveManager:LoadAutoloadConfig()

