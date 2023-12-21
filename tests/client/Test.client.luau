local Snacky = require(game.ReplicatedStorage.Packages.Snacky)
local New = Snacky.new({
    Name = "test"
})

New.BroadcastStarted:Connect(function(text, time)
    print(text, time, "Starting")
end)

New:BindToActivated(function()
    print("Cancelled")
    New:CancelBroadcast(false)
end)

while true do
    task.wait(5)
    New:Broadcast("Welcome to the Snacky playground!", 3)
end