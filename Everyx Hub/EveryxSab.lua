repeat wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")


local doorPositions = {
	Vector3.new(-472,-7,114),Vector3.new(-472,-7,221),Vector3.new(-472,-7,8),Vector3.new(-472,-7,-101),Vector3.new(-345,-7,5),Vector3.new(-345,-7,115),Vector3.new(-345,-7,220),Vector3.new(-345,-7,-101)
}



local function getNearestDoor()
	local closest, minDist = nil, math.huge
	for _, door in ipairs(doorPositions) do
		local dist = (root.Position - door).Magnitude
		if dist < minDist then
			minDist = dist
			closest = door
		end
	end
	return closest
end


local function goUp()
	local door = getNearestDoor()
	if door then
		TweenService:Create(root, TweenInfo.new(1.2), {CFrame = CFrame.new(door)}):Play()
		wait(1.3)
		root.CFrame = root.CFrame + Vector3.new(0, 200, 0)
	end
end

local function dropDown()
	root.CFrame = root.CFrame - Vector3.new(0, 50, 0)
end

-- Put this in a LocalScript inside StarterPlayerScripts
local UserInputService = game:GetService("UserInputService")

local function onInput(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.E then
            goUp()
        elseif input.KeyCode == Enum.KeyCode.R then
            dropDown()
        end
    end
end

UserInputService.InputBegan:Connect(onInput)