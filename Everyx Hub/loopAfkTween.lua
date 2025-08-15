function moveTo(obj, speed)
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

function replicateButtonClick(button)
        GuiService.SelectedObject = button
    VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    wait(0.05)
    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    wait(0.05)
    GuiService.GuiNavigationEnabled = false
end

function checkForRaid()
    if game:GetService("Players").LocalPlayer.PlayerGui.Settings.RaidConfirm.Visible == true then
        local yes = game:GetService("Players").LocalPlayer.PlayerGui.Settings.RaidConfirm.Yes
        replicateButtonClick(yes)
    end
end
        

while true do
    checkForRaid()
    moveTo(workspace.Map:GetChildren()[9]:GetChildren()[6],250)
    task.wait(1)
end