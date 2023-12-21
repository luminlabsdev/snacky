local HintObject = Instance.new("TextButton")
HintObject.Name = "HintObject"
HintObject.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json")
HintObject.RichText = true
HintObject.Text = ""
HintObject.TextColor3 = Color3.fromRGB(255, 255, 255)
HintObject.TextSize = 13
HintObject.TextTransparency = 1
HintObject.AutoButtonColor = false
HintObject.Active = false
HintObject.AnchorPoint = Vector2.new(0.5, 0.5)
HintObject.AutomaticSize = Enum.AutomaticSize.XY
HintObject.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HintObject.BackgroundTransparency = 1
HintObject.BorderSizePixel = 0
HintObject.Position = UDim2.new(0.5, 0, 0.998, -85)
HintObject.Selectable = false
HintObject.Size = UDim2.fromOffset(0, 30)

local Corner = Instance.new("UICorner")
Corner.Name = "Corner"
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = HintObject

local Padding = Instance.new("UIPadding")
Padding.Name = "Padding"
Padding.PaddingBottom = UDim.new(0, 10)
Padding.PaddingLeft = UDim.new(0, 11)
Padding.PaddingRight = UDim.new(0, 11)
Padding.PaddingTop = UDim.new(0, 10)
Padding.Parent = HintObject

return HintObject