# Respond to Input

Snacky allows you to respond to input on your Snackbars. The extent of this responsiveness is clicking the snackbar. To start, use the `BindToActivated` function. This will set up the snackbar to respond to input, and then run the provided function when clicked.

```lua
local New = Snacky.new("Example")

local MyBroadcast = New:Broadcast("Click me and I'll be gone forever!", nil, true)

MyBroadcast.Activated:Connect(function()
    print("Click!")
    MyBroadcast.Cancel()
end)
```

There is no way to make the snackbar stop responding to input after it is broadcasted currently.