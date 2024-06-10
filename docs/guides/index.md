# Basic Usage

It's fairly easy to setup and start using Snacky. To create a new hint, you can enter the following code into your script:

```lua
local New = Snacky.new("Example")
```

This will create a new snackbar named "Example". Although, this does not do anything on the user-facing side. To show the hint to the user, we must use the `Broadcast` function. This will play the animations and display the provided text.

```lua
-- reference to your snackbar
New:Broadcast("Hello! This is a test broadcast", 5)
```

Now, the first parameter is the text you want to display. This will show on the snackbar for the current broadcast only, it will change depending on how you change the parameters of the function. The second parameter is how much time it will stay on the screen for. In the example, I chose 5 seconds as this is usually enough time for the user to notice it. If you would like to display it infinitely, leave the param blank (nil). To cancel and infinitely shown snackbar, you can use the `Cancel` function which is returned by the broadcast itself.

```lua
local MyBroadcast = New:Broadcast("Hello! This is a test broadcast, which is infinite")
task.wait(50)
MyBroadcast.Cancel()
```

The above can be implemented identically by using 50 as the time parameter, but you could use a signal that is fired to cancel it as well for example.