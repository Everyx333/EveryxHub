local KeyGuardLibrary = loadstring(game:HttpGet("https://cdn.keyguardian.org/library/v1.0.0.lua"))()
local trueData = "3902373f37b74c509f7aada6c5beebb0"
local falseData = "27ae62b19e3b4a719882853f1b52f2f7"

KeyGuardLibrary.Set({
  publicToken = "0122e642c5d34f448710cec37f5f5c2f",
  privateToken = "495efe61a13c4118a8c3c825a8dda8fb",
  trueData = trueData,
  falseData = falseData,
})

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local key = ""
_G.key_status

local Window = Fluent:CreateWindow({
    Title = "Key System",
    SubTitle = "EveryxHub",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 340),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    KeySys = Window:AddTab({ Title = "Key System", Icon = "key" }),
}

local Entkey = Tabs.KeySys:AddInput("Input", {
    Title = "Enter Key",
    Description = "Enter Key Here",
    Default = "",
    Placeholder = "Enter key…",
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        key = Value
    end
})

local Checkkey = Tabs.KeySys:AddButton({
    Title = "Check Key",
    Description = "Enter Key before pressing this button",
    Callback = function()
        local response = KeyGuardLibrary.validateDefaultKey(key)
        local premresponse = KeyGuardLibrary.validatePremiumKey(key)
        if response == trueData then
           print("Key is valid")
           _G.key_status = "Default"
           -- Your code here
        elseif premresponse == trueData then
            print("prem key")
            _G.key_status = "Premium"
        else
           print("Key is invalid")
        end
    end
})

local Getkey = Tabs.KeySys:AddButton({
    Title = "Get Key",
    Description = "Get Key here",
    Callback = function()
       setclipboard(KeyGuardLibrary.getLink())
    end
})


Window:SelectTab(1)