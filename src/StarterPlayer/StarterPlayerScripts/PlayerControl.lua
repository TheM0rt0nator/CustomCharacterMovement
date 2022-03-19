local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local SharedScripts = ReplicatedStorage.SharedScripts

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

if not player.Character then
	player.CharacterAdded:Wait()
end
local char = player.Character
local hum = player.Character:WaitForChild("Humanoid")

local PlayerModule = require(player.PlayerScripts:WaitForChild("PlayerModule"))
local UserInput = require(SharedScripts:WaitForChild("UserInput"))

local controls = PlayerModule:GetControls()

local PlayerControl = {
	controls = {
		["Keyboard"] = {
			["W"] = {
				direction = Vector2.new(0, 1);
			};
			["A"] = {
				direction = Vector2.new(1, 0);
			};
			["S"] = {
				direction = Vector2.new(0, -1);
			};
			["D"] = {
				direction = Vector2.new(-1, 0);
			};
			["Up"] = {
				direction = Vector2.new(0, 1);
			};
			["Left"] = {
				direction = Vector2.new(1, 0);
			};
			["Down"] = {
				direction = Vector2.new(0, -1);
			};
			["Right"] = {
				direction = Vector2.new(-1, 0);
			};
		}
	};
	currentMoveVector = Vector3.new(0, 0, 0);
}

controls:Disable()

function PlayerControl.moveCharacter()
	hum:Move(PlayerControl.currentMoveVector, true)
end

function PlayerControl.changeSpeed(speed)
	hum.WalkSpeed = speed
end

function PlayerControl.initiateControls()
	RunService:BindToRenderStep("PlayerMovement", 100, PlayerControl.moveCharacter)

	for inputType, inputs in pairs(PlayerControl.controls) do
		for keycode, info in pairs(inputs) do
			UserInput.connectInput(inputType, keycode, function()
				local currentVector = PlayerControl.currentMoveVector
				PlayerControl.currentMoveVector = Vector3.new(currentVector.X - info.direction.X, 0, currentVector.Z - info.direction.Y)
			end, function()
				local currentVector = PlayerControl.currentMoveVector
				PlayerControl.currentMoveVector = Vector3.new(currentVector.X + info.direction.X, 0, currentVector.Z + info.direction.Y)
			end)
		end
	end

	UserInput.connectInput("Keyboard", "LeftShift", function()
		PlayerControl.changeSpeed(30)
	end, function()
		PlayerControl.changeSpeed(16)
	end)

	UserInput.connectInput("Keyboard", "Space", function()
		hum.Jump = true
	end)
end

function PlayerControl.newCharacter(newChar)
	char = newChar
	hum = newChar:WaitForChild("Humanoid")
end

player.CharacterAdded:Connect(PlayerControl.newCharacter)

PlayerControl.initiateControls()

return PlayerControl


