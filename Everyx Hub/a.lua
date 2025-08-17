local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")function replicateButtonClick(button) --path
        GuiService.SelectedObject = button
    VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
    wait(0.05)
    VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
    wait(0.05)
    GuiService.GuiNavigationEnabled = false
end

while true do
    task.wait()
    replicateButtonClick(game:GetService("Players").LocalPlayer.PlayerGui.Screen.Quests.Container.Get)
    replicateButtonClick(game:GetService("Players").LocalPlayer.PlayerGui.Screen.Quests.Container.Frame.Claim)
end