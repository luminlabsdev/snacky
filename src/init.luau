-- Package

local Snacky = { }
local Packages = script.Parent

-- Variables

local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Signal = require(Packages.signal)

local Player = PlayerService.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Snackbar = require(script.Snackbar)
local SnackbarApp: any = require(script.SnackbarApp)
local SnackbarFrame = SnackbarApp.SnackbarFrame

local BackpackConnections: {RBXScriptConnection} = { }

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
	Left = "LeftFrame",
	Center = "CenterFrame",
	Right = "RightFrame"
}

type BroadcastStyle = "Animated" | "Static"
type BroadcastArea = "Left" | "Center" | "Right"
type SnackbarStyle = {
	CornerRadius: number?,
	TextColor3: number?,
	TextTransparency: number?,
	BackgroundColor3: number?,
	BackgroundTransparency: number?,
	FontFace: Font?,
}

Snacky.__index = Snacky

SnackbarApp.Parent = PlayerGui
SnackbarApp.Archivable = false

-- Functions

local function New(name: string, area: BroadcastArea?, style: BroadcastStyle?, tweenTime: number?, tweenStyle: Enum.EasingStyle?)
	local self = setmetatable({ }, Snacky)
	local SnackbarClone = Snackbar:Clone()
	
	self._Element = SnackbarClone
	
	self.BroadcastArea = area or "Center"
	self.BroadcastStyle = style or "Animated"
	self.CurrentlyBroadcasting = {}

	self.BroadcastStarted = Signal.new() :: Signal.Signal<string, number>
	
	self._TweenBackgroundTransparency = 0.3
	self._TweenTextTransparency = 0
	self._TweenTime = tweenTime
	self._TweenStyle = tweenStyle
	self._TweenInfo = {}

	SnackbarClone.Name = name
	
	if self.BroadcastStyle == "Animated" then
		if tweenTime and tweenStyle then
			self._TweenInfo.In = TweenInfo.new(
				tweenTime,
				tweenStyle,
				Enum.EasingDirection.In
			)
			
			self._TweenInfo.Out = TweenInfo.new(
				tweenTime,
				tweenStyle,
				Enum.EasingDirection.Out
			)
		else
			self._TweenInfo.In = SnackbarInTweenInfoDefault
			self._TweenInfo.Out = SnackbarOutTweenInfoDefault
		end
	end
	
	return self
end

function Snacky:SetStyle(properties: SnackbarStyle)
	local Element = self._Element
	
	for property, value in properties do
		if property == "CornerRadius" then
			Element.Corner.CornerRadius = UDim.new(0, value :: number)
			continue
		end
		
		if property == "BackgroundTransparency" or "TextTransparency" then
			self[`_Tween{property}`] = value
		end
		
		Element[property] = value
	end
end

function Snacky:SetOrder(order: number)
	self._Element.LayoutOrder = order
end

function Snacky:Broadcast(broadcastText: string, broadcastTime: number?, allowActivation: boolean?)
	local Element = self._Element:Clone() :: any

	local BroadcastFinished = Signal.new() :: Signal.Signal<nil>
	local BroadcastCancelled = Signal.new() :: Signal.Signal<nil>
	local Activated

	if allowActivation then
		Activated = Signal.new() :: Signal.Signal<Enum.UserInputType>
		Element.AutoButtonColor = true
		self._ActivatedConnection = Element.Activated:Connect(function(userInputType)
			Activated:Fire(userInputType)
		end)
	end

	local InTweens: {[string]: Tween} = {
		Background = TweenService:Create(Element, self._TweenInfo.In, {BackgroundTransparency = self._TweenBackgroundTransparency}),
		Text = TweenService:Create(Element, self._TweenInfo.In, {TextTransparency = self._TweenTextTransparency})
	}
	local OutTweens: {[string]: Tween} = {
		Background = TweenService:Create(Element, self._TweenInfo.Out, {BackgroundTransparency = 1}),
		Text = TweenService:Create(Element, self._TweenInfo.Out, {TextTransparency = 1})
	}

	table.insert(self.CurrentlyBroadcasting, Element)
	Element.Text = broadcastText
	Element.Parent = SnackbarFrame:FindFirstChild(
		SnackbarBroadcastAreas[self.BroadcastArea]
	)
	
	local Thread
	Thread = task.defer(function()
		self.BroadcastStarted:Fire(broadcastText, broadcastTime)
		if self.BroadcastStyle == "Animated" then
			Element.Visible = true
			
			if self._ActivatedConnection then
				Element.Active = true
			end
			
			for _, tween in InTweens do
				tween:Play()
				print("HI")
			end

			if not broadcastTime then
				return
			end

			BroadcastCancelled:Once(function()
				task.cancel(Thread)
			end)

			task.wait(broadcastTime + InTweens.Background.TweenInfo.Time)
			
			OutTweens.Background.Completed:Once(function()
				Element.Visible = false
				Element:Destroy()
				BroadcastFinished:Fire()

				table.clear(InTweens)
				table.clear(OutTweens)
				table.remove(self.CurrentlyBroadcasting, table.find(self.CurrentlyBroadcasting, Element))
			end)

			Element.Active = false

			for _, tween in OutTweens do
				tween:Play()
			end
		else
			Element.Visible = true

			if self._ActivatedConnection then
				Element.Active = true
			end

			if not broadcastTime then
				return
			end

			BroadcastCancelled:Once(function()
				task.cancel(Thread)
			end)

			task.wait(broadcastTime)

			Element.Visible = false
			Element.Active = false
			Element:Destroy()
			self.BroadcastFinished:Fire()

			table.remove(self.CurrentlyBroadcasting, table.find(self.CurrentlyBroadcasting, Element))
		end
	end)

	return {
		Cancel = function()
			if self.BroadcastStyle == "Animated" then
				OutTweens.Background.Completed:Once(function()
					Element.Visible = false
					Element:Destroy()
					BroadcastFinished:Fire()
	
					table.clear(InTweens)
					table.clear(OutTweens)
				end)
	
				for _, tween in OutTweens do
					tween:Play()
				end
			else
				Element.Visible = false
				Element:Destroy()
				BroadcastFinished:Fire()
			end
		end,
		BroadcastFinished = BroadcastFinished,
		BroadcastCancelled = BroadcastCancelled,
		Activated = Activated,
	}
end

function Snacky:Destroy()
	for _, prop in self do
		if typeof(prop) == "RBXScriptConnection" then
			prop:Disconnect()
		end
		
		prop = nil
	end
end

-- Connections

Player.CharacterAdded:Connect(function(character)
	if #BackpackConnections ~= 0 then
		for _, connection in BackpackConnections do
			connection:Disconnect()
		end
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

-- Actions

return {
	new = New,
}