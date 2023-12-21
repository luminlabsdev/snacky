local Snackbar = Instance.new("TextButton")
Snackbar.Name = "Snackbar"
Snackbar.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
Snackbar.RichText = true
Snackbar.Text = ""
Snackbar.TextColor3 = Color3.fromRGB(255, 255, 255)
Snackbar.TextSize = 13
Snackbar.TextTransparency = 1
Snackbar.AutoButtonColor = false
Snackbar.Active = false
Snackbar.AnchorPoint = Vector2.new(0.5, 0.5)
Snackbar.AutomaticSize = Enum.AutomaticSize.XY
Snackbar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Snackbar.BackgroundTransparency = 1
Snackbar.BorderSizePixel = 0
Snackbar.Position = UDim2.new(0.5, 0, 0.998, -85)
Snackbar.Selectable = false
Snackbar.Size = UDim2.fromOffset(0, 30)
Snackbar.Visible = false

local Corner = Instance.new("UICorner")
Corner.Name = "Corner"
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Snackbar

local Padding = Instance.new("UIPadding")
Padding.Name = "Padding"
Padding.PaddingBottom = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 11)
Padding.PaddingRight = UDim.new(0, 11)
Padding.PaddingTop = UDim.new(0, 10)
Padding.Parent = Snackbar

return Snackbar