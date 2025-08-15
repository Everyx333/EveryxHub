local function moveTo(obj, speed)
    local info = TweenInfo.new((
        game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Position
    ).Magnitude / speed, Enum.EasingStyle.Linear)
    local tween = game.TweenService:Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart, 
        info, 
        {CFrame = obj.CFrame}
    )

    if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
        antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
        antifall.Velocity = Vector3.new(0, 0, 0)
        noclipE = game:GetService("RunService").Stepped:Connect(noclip)
        tween:Play()
    end

    tween.Completed:Connect(function()
        antifall:Destroy()
        noclipE:Disconnect()
    end)
end

function checkForRaid()
    if game:GetService("Players").LocalPlayer.PlayerGui.Settings.RaidConfirm.Visible == true then
        local yes = game:GetService("Players").LocalPlayer.PlayerGui.Settings.RaidConfirm.Yes
        

while true do
    moveTo(workspace.Map:GetChildren()[9]:GetChildren()[6],250)
    task.wait(1)
end