local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")


local AimbotEnabled = false
local ESPEnabled = false
local aiming = false
local ESPConnections = {}


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WexasHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui


local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Active = true
Frame.Draggable = false
Frame.Name = "MainFrame"
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)


local TopBar = Instance.new("Frame", Frame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 15)


local Title = Instance.new("TextLabel", TopBar)
Title.Text = "WexasHub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Position = UDim2.new(0, 10, 0, 5)
Title.Size = UDim2.new(1, -20, 1, -10)
Title.TextXAlignment = Enum.TextXAlignment.Left


local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)


local LeftPanel = Instance.new("Frame", Frame)
LeftPanel.Size = UDim2.new(0.5, 0, 1, -30)
LeftPanel.Position = UDim2.new(0, 0, 0, 30)
LeftPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)


local AimbotLabel = Instance.new("TextLabel", LeftPanel)
AimbotLabel.Size = UDim2.new(1, -20, 0, 20)
AimbotLabel.Position = UDim2.new(0, 10, 0, 10)
AimbotLabel.BackgroundTransparency = 1
AimbotLabel.Text = "Aimbot Settings"
AimbotLabel.TextColor3 = Color3.new(1, 1, 1)
AimbotLabel.Font = Enum.Font.GothamBold
AimbotLabel.TextSize = 16
AimbotLabel.TextXAlignment = Enum.TextXAlignment.Left


local AimbotBtn = Instance.new("TextButton", LeftPanel)
AimbotBtn.Size = UDim2.new(0, 120, 0, 40)
AimbotBtn.Position = UDim2.new(0, 10, 0, 40)
AimbotBtn.Text = "Aimbot: Off"
AimbotBtn.Font = Enum.Font.Gotham
AimbotBtn.TextSize = 14
AimbotBtn.TextColor3 = Color3.new(1, 1, 1)
AimbotBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", AimbotBtn).CornerRadius = UDim.new(0, 10)


local RightPanel = Instance.new("Frame", Frame)
RightPanel.Size = UDim2.new(0.5, 0, 1, -30)
RightPanel.Position = UDim2.new(0.5, 0, 0, 30)
RightPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)


local ESPLabel = Instance.new("TextLabel", RightPanel)
ESPLabel.Size = UDim2.new(1, -20, 0, 20)
ESPLabel.Position = UDim2.new(0, 10, 0, 10)
ESPLabel.BackgroundTransparency = 1
ESPLabel.Text = "ESP Settings"
ESPLabel.TextColor3 = Color3.new(1, 1, 1)
ESPLabel.Font = Enum.Font.GothamBold
ESPLabel.TextSize = 16
ESPLabel.TextXAlignment = Enum.TextXAlignment.Left


local ESPBtn = Instance.new("TextButton", RightPanel)
ESPBtn.Size = UDim2.new(0, 120, 0, 40)
ESPBtn.Position = UDim2.new(0, 10, 0, 40)
ESPBtn.Text = "ESP: Off"
ESPBtn.Font = Enum.Font.Gotham
ESPBtn.TextSize = 14
ESPBtn.TextColor3 = Color3.new(1, 1, 1)
ESPBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Instance.new("UICorner", ESPBtn).CornerRadius = UDim.new(0, 10)


local function GetClosestPlayer()
	local closest, shortest = nil, math.huge
	local mouse = UserInputService:GetMouseLocation()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			local head = plr.Character.Head
			local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local dist = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
				if dist < shortest then
					shortest = dist
					closest = head
				end
			end
		end
	end
	return closest
end


local aimbotConn = RunService.RenderStepped:Connect(function()
	if AimbotEnabled and aiming then
		local target = GetClosestPlayer()
		if target then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
		end
	end
end)


UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.MouseButton2 and AimbotEnabled then
		aiming = true
	end
end)

UserInputService.InputEnded:Connect(function(input, gp)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		aiming = false
	end
end)


local function AddESPToCharacter(character, name)
	local head = character:WaitForChild("Head", 5)
	if head and not head:FindFirstChild("ESPNameTag") then
		local tag = Instance.new("BillboardGui", head)
		tag.Name = "ESPNameTag"
		tag.AlwaysOnTop = true
		tag.Size = UDim2.new(0, 100, 0, 30)
		tag.Adornee = head
		tag.StudsOffset = Vector3.new(0, 3, 0)

		local label = Instance.new("TextLabel", tag)
		label.Size = UDim2.new(1, 0, 1, 0)
		label.Text = name
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Font = Enum.Font.Gotham
		label.TextSize = 14
	end
end

local function ToggleESP()
	ESPEnabled = not ESPEnabled
	ESPBtn.Text = ESPEnabled and "ESP: On" or "ESP: Off"

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			if ESPEnabled then
				AddESPToCharacter(plr.Character, plr.Name)
			else
				local head = plr.Character:FindFirstChild("Head")
				if head and head:FindFirstChild("ESPNameTag") then
					head.ESPNameTag:Destroy()
				end
			end
		end
	end
end


table.insert(ESPConnections, Players.PlayerAdded:Connect(function(plr)
	table.insert(ESPConnections, plr.CharacterAdded:Connect(function(char)
		if ESPEnabled then
			AddESPToCharacter(char, plr.Name)
		end
	end))
end))


AimbotBtn.MouseButton1Click:Connect(function()
	AimbotEnabled = not AimbotEnabled
	AimbotBtn.Text = AimbotEnabled and "Aimbot: On" or "Aimbot: Off"
	aiming = false
end)


ESPBtn.MouseButton1Click:Connect(ToggleESP)


CloseBtn.MouseButton1Click:Connect(function()
	if aimbotConn then aimbotConn:Disconnect() end
	for _, conn in ipairs(ESPConnections) do
		pcall(function() conn:Disconnect() end)
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		local head = plr.Character and plr.Character:FindFirstChild("Head")
		if head and head:FindFirstChild("ESPNameTag") then
			head.ESPNameTag:Destroy()
		end
	end

	ScreenGui:Destroy()
	AimbotEnabled = false
	ESPEnabled = false
end)


local dragging
local dragInput
local dragStart
local startPos

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
	end
end)

TopBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

TopBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
