

while true do
    task.wait()
    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("GetQuest"):InvokeServer()

    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("GetQuest"):InvokeServer()

end