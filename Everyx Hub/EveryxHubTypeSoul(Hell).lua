-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Local player
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LavaGuyManager"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 1, -120)
frame.AnchorPoint = Vector2.new(0.5, 1)
frame.BackgroundTransparency = 0.5
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local billboardToggle = Instance.new("TextButton")
billboardToggle.Size = UDim2.new(0.9, 0, 0.4, 0)
billboardToggle.Position = UDim2.new(0.05, 0, 0.05, 0)
billboardToggle.Text = "Toggle Billboards (ON)"
billboardToggle.Parent = frame

local tweenToggle = Instance.new("TextButton")
tweenToggle.Size = UDim2.new(0.9, 0, 0.4, 0)
tweenToggle.Position = UDim2.new(0.05, 0, 0.55, 0)
tweenToggle.Text = "Toggle Tweening (OFF)"
tweenToggle.Parent = frame

-- State variables
local billboardsEnabled = true
local tweeningEnabled = false
local activeBillboards = {}
local tweeningConnection = nil
local spamConnection = nil
local isCurrentlyTweening = false

-- Key codes for 1-2-3-4
local keysToPress = {
    Enum.KeyCode.One,
    Enum.KeyCode.Two,
    Enum.KeyCode.Three,
    Enum.KeyCode.Four
}

-- Enable noclipping during tween
local function setNoclip(state)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end
end

-- Simulate key presses using VirtualInputManager
local function simulateKeyPress(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

-- Billboard functions
function createBillboard(lguy)
    if not billboardsEnabled or lguy:FindFirstChild("LavaGuyLabel") then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "LavaGuyLabel"
    billboard.Adornee = lguy
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 500
    billboard.LightInfluence = 0
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = "🔥 LAVAGUY 🔥"
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
    
    textLabel.Parent = billboard
    billboard.Parent = lguy
    
    table.insert(activeBillboards, billboard)
end

function destroyAllBillboards()
    for _, billboard in ipairs(activeBillboards) do
        if billboard and billboard.Parent then
            billboard:Destroy()
        end
    end
    activeBillboards = {}
end



function startSpam()
    if spamConnection then spamConnection:Disconnect() end
    
    spamConnection = RunService.Heartbeat:Connect(function()
        if tweeningEnabled and not isCurrentlyTweening then
            -- Press keys 1-2-3-4 in sequence with delay
            for _, key in ipairs(keysToPress) do
                simulateKeyPress(key)
                task.wait(0.1) -- Delay between key presses
            end
            task.wait(5) -- Wait 5 seconds before next spam cycle
        end
    end)
end

-- Toggle functions
billboardToggle.MouseButton1Click:Connect(function()
    billboardsEnabled = not billboardsEnabled
    billboardToggle.Text = "Toggle Billboards (" .. (billboardsEnabled and "ON)" or "OFF)")
    
    if not billboardsEnabled then
        destroyAllBillboards()
    end
end)

-- Main scanning loop
while true do
    task.wait(5)
    if billboardsEnabled then
        for _, lguy in ipairs(workspace.Entities:GetDescendants()) do
            if lguy.Name == "LavaGuy" then
                createBillboard(lguy)
            end
        end
    end
end