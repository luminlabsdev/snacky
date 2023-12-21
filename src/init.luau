-- // Package

local Snacky = { }
local Packages = script.Parent

-- // Variables

local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Signal = require(Packages.signal)

local Player = PlayerService.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Snackbar = require(script.UIElements.Snackbar)
local SnackbarApp = require(script.UIElements.SnackbarApp)
local SnackbarFrame = SnackbarApp.SnackbarFrame

local BackpackConnections = { }

local SnackbarInTweenInfoDefault = TweenInfo.new(
	0.65,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.In
)

local SnackbarOutTweenInfoDefault = TweenInfo.new(
	0.65,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

local SnackbarBroadcastAreas = {
	"LeftFrame",
	"CenterFrame",
	"RightFrame"
}

Snacky.BroadcastStyle = {
	Animated = 1,
	Static = 2,
}

Snacky.BroadcastArea = {
	Left = 1,
	Center = 2,
	Right = 3,
}

type SnackbarProps = {
	Area: number?,
	Style: number?,
	TweenStyle: Enum.EasingStyle?,
	TweenTime: number?,
	Name: string,
}

Snacky.__index = Snacky

SnackbarApp.Parent = PlayerGui
SnackbarApp.Archivable = false

-- // Functions

function Snacky.CreateSnackbar(properties: SnackbarProps)
	local self = setmetatable({ }, Snacky)
	local SnackbarClone = Snackbar:Clone()
	
	self._Element = SnackbarClone
	
	self.BroadcastArea = properties.Area or Snacky.BroadcastArea.Center
	self.BroadcastStyle = properties.Style or Snacky.BroadcastStyle.Animated
	self.BroadcastText = ""
	self.CurrentBroadcastCancelled = false
	self.CurrentlyBroadcasting = false
	
	self.BroadcastFinished = Signal() :: Signal.Signal<>
	self.BroadcastStarted = Signal() :: Signal.Signal<string, number>
	self.BroadcastCancelled = Signal() :: Signal.Signal<>
	
	self._ActivatedConnection = nil
	self._TweenTime = properties.TweenTime
	self._TweenStyle = properties.TweenStyle
	self._Tweens = {
		[true] = nil,
		[false] = nil,
	}
	
	SnackbarClone.Name = properties.Name
	SnackbarClone.Parent = SnackbarFrame:FindFirstChild(
		SnackbarBroadcastAreas[self.BroadcastArea]
	)
	
	if self.BroadcastStyle == Snacky.BroadcastStyle.Animated then
		local TweenInfoToUse = {
			In = nil,
			Out = nil,
		}
		
		if properties.TweenTime and properties.TweenStyle then
			TweenInfoToUse.In = TweenInfo.new(
				properties.TweenTime,
				properties.TweenStyle,
				Enum.EasingDirection.In
			)
			
			TweenInfoToUse.Out = TweenInfo.new(
				properties.TweenTime,
				properties.TweenStyle,
				Enum.EasingDirection.Out
			)
		else
			TweenInfoToUse.In = SnackbarInTweenInfoDefault
			TweenInfoToUse.Out = SnackbarOutTweenInfoDefault
		end
		
		self._Tweens[true] = {
			Background = TweenService:Create(self._Element, TweenInfoToUse.In, {BackgroundTransparency = 0.3}),
			Text = TweenService:Create(self._Element, TweenInfoToUse.In, {TextTransparency = 0})
		}
		
		self._Tweens[false] = {
			Background = TweenService:Create(self._Element, TweenInfoToUse.Out, {BackgroundTransparency = 1}),
			Text = TweenService:Create(self._Element, TweenInfoToUse.Out, {TextTransparency = 1})
		}
	end
	
	return self
end

function Snacky:SetStyle(properties: {
		CornerRadius: number?,
		TextColor3: number?,
		BackgroundColor3: number?,
		BackgroundTransparency: number?,
		FontFace: Font?,
	})
	
	local Element = self._Element
	
	for property, value in properties do
		if property == "CornerRadius" then
			Element.Corner.CornerRadius = UDim.new(0, value)
			continue
		end
		
		if property == "BackgroundTransparency" then
			self._Tweens[true].Background = TweenService:Create(Element, TweenInfo.new(
					self._TweenTime,
					self._TweenStyle,
					Enum.EasingDirection.In
				))
		end
		
		Element[property] = value
	end
end

function Snacky:SetOrder(order: number)
	self._Element.LayoutOrder = order
end

function Snacky:BindToActivated(func: (inputType: Enum.UserInputType) -> ())
	local Element: TextButton = self._Element
	
	Element.Active = true
	Element.AutoButtonColor = true

	self._ActivatedConnection = Element.Activated:Connect(function(input)
		func(input.UserInputType)
	end)
end

function Snacky:UnbindFromActivated()
	local Element: TextButton = self._Element
	
	Element.Active = false
	Element.AutoButtonColor = false
	
	self._ActivatedConnection:Disconnect()
	self._ActivatedConnection = nil
end

function Snacky:CancelBroadcast(destroy: boolean?)
	local Element: TextButton = self._Element
	
	self.CurrentBroadcastCancelled = true
	self.BroadcastCancelled:Fire()
	
	if self.BroadcastStyle == Snacky.BroadcastStyle.Animated then
		local TweenToPlay: {[string]: Tween} = self._Tweens[false]
		
		TweenToPlay.Background.Completed:Once(function()
			Element.Visible = false
			if destroy then
				self:Destroy()
			end
		end)
		
		self.CurrentlyBroadcasting = false
		for _, tween in TweenToPlay do
			tween:Play()
		end
	elseif self.BroadcastStyle == Snacky.BroadcastStyle.Static then
		Element.Visible = false
		self.CurrentlyBroadcasting = false

		if destroy then
			self:Destroy()
		end
	end
end

function Snacky:Broadcast(broadcastText: string, broadcastTime: number?, destroyWhenFinished: boolean?)
	local Element: TextButton = self._Element
	
	Element.Text = broadcastText
	self.BroadcastText = broadcastText
	
	task.defer(function()
		self.BroadcastStarted:Fire(broadcastText, broadcastTime)
		self.CurrentBroadcastCancelled = false
		
		if self.BroadcastStyle == Snacky.BroadcastStyle.Animated then
			local TweenToPlay: {[string]: Tween} = self._Tweens[true]
			self.CurrentlyBroadcasting = true
			
			for _, tween in TweenToPlay do
				Element.Visible = true
				tween:Play()
			end

			if not broadcastTime then
				return
			end

			task.wait(broadcastTime + self._Tweens[true].Background.TweenInfo.Time)

			if self.CurrentBroadcastCancelled then
				self.CurrentlyBroadcasting = false
				return
			end

			local NewTweenToPlay: {[string]: Tween} = self._Tweens[false]
			
			NewTweenToPlay.Background.Completed:Once(function()
				Element.Visible = false
				if destroyWhenFinished then
					self:Destroy()
				end
			end)

			self.BroadcastFinished:Fire()
			self.CurrentlyBroadcasting = false

			for key, tween in NewTweenToPlay do
				tween:Play()
			end
		elseif self.BroadcastStyle == Snacky.BroadcastStyle.Static then
			Element.Visible = true
			self.CurrentlyBroadcasting = true

			if not broadcastTime then
				return
			end

			task.wait(broadcastTime)
			Element.Visible = false

			if self.CurrentBroadcastCancelled then
				return
			end

			self.BroadcastFinished:Fire()
			self.CurrentlyBroadcasting = false

			if destroyWhenFinished then
				self:Destroy()
			end
		end
	end)
end

function Snacky:Destroy()
	self._Element:Destroy()
	
	for _, prop in self do
		if typeof(prop) == "RBXScriptConnection" then
			prop:Disconnect()
		end
		
		prop = nil
	end
end

-- // Connections

Player.CharacterAdded:Connect(function(character)
	for _, connection in BackpackConnections do
		connection:Disconnect()
	end

	local Backpack = Player:WaitForChild("Backpack")
	
	table.insert(BackpackConnections, Backpack.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then	
			SnackbarFrame.CenterFrame.Padding.PaddingBottom = UDim.new(0, 70)
		end
	end))
	
	table.insert(BackpackConnections, Backpack.ChildRemoved:Connect(function(child)
		if child:IsA("Tool") then
			local Character = Player.Character
			
			if Character then
				local FoundChild = Character:FindFirstChild(child.Name)
				
				if FoundChild and FoundChild:IsA("Tool") then
					return
				end
			end
			
			if #Backpack:GetChildren() == 0 then
				SnackbarFrame.CenterFrame.Padding.PaddingBottom = UDim.new(0, 10)
			end
		end
	end))
end)

Snacky.new = Snacky.CreateSnackbar

-- // Actions

return Snacky