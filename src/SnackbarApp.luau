local Hints = Instance.new("ScreenGui")
Hints.Name = "Hints"
Hints.DisplayOrder = 1e+09
Hints.ResetOnSpawn = false
Hints.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local SnackbarFrame = Instance.new("Frame")
SnackbarFrame.Name = "SnackbarFrame"
SnackbarFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SnackbarFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SnackbarFrame.BackgroundTransparency = 1
SnackbarFrame.ClipsDescendants = true
SnackbarFrame.Position = UDim2.fromScale(0.5, 0.5)
SnackbarFrame.Size = UDim2.fromScale(1, 1)

local CenterFrame = Instance.new("Frame")
CenterFrame.Name = "CenterFrame"
CenterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CenterFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CenterFrame.BackgroundTransparency = 1
CenterFrame.ClipsDescendants = true
CenterFrame.Position = UDim2.fromScale(0.5, 0.511)
CenterFrame.Size = UDim2.fromScale(1, 0.979)

local Layout = Instance.new("UIListLayout")
Layout.Name = "Layout"
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
Layout.Parent = CenterFrame

local Padding = Instance.new("UIPadding")
Padding.Name = "Padding"
Padding.PaddingBottom = UDim.new(0, 10)
Padding.Parent = CenterFrame

CenterFrame.Parent = SnackbarFrame

local RightFrame = Instance.new("Frame")
RightFrame.Name = "RightFrame"
RightFrame.AnchorPoint = Vector2.new(0.5, 0.5)
RightFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
RightFrame.BackgroundTransparency = 1
RightFrame.ClipsDescendants = true
RightFrame.Position = UDim2.fromScale(0.5, 0.511)
RightFrame.Size = UDim2.fromScale(1, 0.979)

local Layout1 = Instance.new("UIListLayout")
Layout1.Name = "Layout"
Layout1.Padding = UDim.new(0, 5)
Layout1.HorizontalAlignment = Enum.HorizontalAlignment.Right
Layout1.SortOrder = Enum.SortOrder.LayoutOrder
Layout1.VerticalAlignment = Enum.VerticalAlignment.Bottom
Layout1.Parent = RightFrame

local Padding1 = Instance.new("UIPadding")
Padding1.Name = "Padding"
Padding1.PaddingBottom = UDim.new(0, 10)
Padding1.PaddingRight = UDim.new(0, 15)
Padding1.Parent = RightFrame

RightFrame.Parent = SnackbarFrame

local LeftFrame = Instance.new("Frame")
LeftFrame.Name = "LeftFrame"
LeftFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LeftFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LeftFrame.BackgroundTransparency = 1
LeftFrame.ClipsDescendants = true
LeftFrame.Position = UDim2.fromScale(0.5, 0.511)
LeftFrame.Size = UDim2.fromScale(1, 0.979)

local Layout2 = Instance.new("UIListLayout")
Layout2.Name = "Layout"
Layout2.Padding = UDim.new(0, 5)
Layout2.SortOrder = Enum.SortOrder.LayoutOrder
Layout2.VerticalAlignment = Enum.VerticalAlignment.Bottom
Layout2.Parent = LeftFrame

local Padding2 = Instance.new("UIPadding")
Padding2.Name = "Padding"
Padding2.PaddingBottom = UDim.new(0, 10)
Padding2.PaddingLeft = UDim.new(0, 15)
Padding2.Parent = LeftFrame

LeftFrame.Parent = SnackbarFrame

SnackbarFrame.Parent = Hints

return Hints