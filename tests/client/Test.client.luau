local Snacky = require(game.ReplicatedStorage.Packages.Snacky)

local New = Snacky.new("test")
local NewInfinite = Snacky.new("test2")

New.BroadcastStarted:Connect(function(text, time)
    print(text, time, "Starting")
end)

local InfBroadcast = NewInfinite:Broadcast("Press to cancel this current broadcast!", nil, true)

InfBroadcast.Activated:Connect(function()
    print("Cancelled")
    InfBroadcast.Cancel()
end)

while true do
    task.wait(5)
    New:Broadcast("Welcome to the Snacky playground!", 3)
end