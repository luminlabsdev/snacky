-- // Package

local Snacky = { }
local HintObject = { }

local Packages = script.Parent

-- // Variables

local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Signal = require(Packages.signal)

local Player = PlayerService.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local HintScreenGui = require(script.UIElements.Hints)
local HintObjectGui = require(script.UIElements.HintObject)

local BackpackConnections = { }

local HintInTweenInfoDefault = TweenInfo.new(
	0.8,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.In
)

local HintOutTweenInfoDefault = TweenInfo.new(
	0.8,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

local HintBroadcastAreas = {
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

Snacky.BroadcastTime = {
	Infinite = 1,
	Set = 2,
}

type HintProps = {
	Area: number?,
	Style: number?,
	Time: number?,
	TweenStyle: Enum.EasingStyle?,
	TweenTime: number?,
	Name: string,
}

HintObject.__index = HintObject

HintScreenGui.Parent = PlayerGui
HintScreenGui.Archivable = false

-- // Functions

function Snacky.CreateHint(properties: HintProps)
	local self = setmetatable({ }, HintObject)
	local HintClone = HintObjectGui:Clone()
	
	self._Element = HintClone
	
	self.BroadcastArea = properties.Area or Snacky.BroadcastArea.Center
	self.BroadcastStyle = properties.Style or Snacky.BroadcastStyle.Animated
	self.BroadcastTime = properties.Time or Snacky.BroadcastTime.Set
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
	
	HintClone.Name = properties.Name
	
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
			TweenInfoToUse.In = HintInTweenInfoDefault
			TweenInfoToUse.Out = HintOutTweenInfoDefault
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

function HintObject:SetStyle(properties: {
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

function HintObject:SetOrder(order: number)
	self._Element.LayoutOrder = order
end

function HintObject:BindToActivated(func: (inputType: Enum.UserInputType) -> ())
	local Element: TextButton = self._Element
	
	Element.Active = true
	Element.AutoButtonColor = true

	self._ActivatedConnection = Element.Activated:Connect(function(input)
		func(input.UserInputType)
	end)
end

function HintObject:UnbindFromActivated()
	local Element: TextButton = self._Element
	
	Element.Active = false
	Element.AutoButtonColor = false
	
	self._ActivatedConnection:Disconnect()
	self._ActivatedConnection = nil
end

function HintObject:CancelBroadcast(destroy: boolean?)
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
		task.defer(function()
			Element.Visible = true
			task.wait(self._Tweens[false].Background.TweenInfo.Time)
			Element.Visible = false

			if destroy then
				self:Destroy()
			end
		end)
	end
end

function HintObject:Broadcast(broadcastText: string, broadcastTime: number?, destroyWhenFinished: boolean?)
	local Element: TextButton = self._Element
	
	Element.Text = broadcastText
	Element.Parent = HintScreenGui.HintsFrame:FindFirstChild(
		HintBroadcastAreas[self.BroadcastArea]
	)
	
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

			self.CurrentlyBroadcasting = false

			for key, tween in NewTweenToPlay do
				tween:Play()
			end

			self.BroadcastFinished:Fire()
		elseif self.BroadcastStyle == Snacky.BroadcastStyle.Static then
			Element.Visible = true
			task.wait(broadcastTime)
			Element.Visible = false

			if self.CurrentBroadcastCancelled then
				return
			end

			self.BroadcastFinished:Fire()

			if destroyWhenFinished then
				self:Destroy()
			end
		end
	end)
end

function HintObject:Destroy()
	self._Element:Destroy()
	
	for _, prop in HintObject do
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
			HintScreenGui.HintsFrame.CenterFrame.Padding.PaddingBottom = UDim.new(0, 70)
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
				HintScreenGui.HintsFrame.CenterFrame.Padding.PaddingBottom = UDim.new(0, 10)
			end
		end
	end))
end)

Snacky.new = Snacky.CreateHint

-- // Actions

return Snacky