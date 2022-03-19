local UserInputService = game:GetService("UserInputService")

local UserInput = {
	connections = {};
}

function UserInput.connectInput(inputType, keyCode, beganFunc, endedFunc)
	if not UserInput.connections[inputType] then
		UserInput.connections[inputType] = {}
	end
	if not UserInput.connections[inputType][keyCode] then
		UserInput.connections[inputType][keyCode] = {}
	end
	local beganFunction = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType[inputType] and input.KeyCode == Enum.KeyCode[keyCode] and not gameProcessed then
			if typeof(beganFunc) == "function" then
				beganFunc()
			end
		end
	end)
	table.insert(UserInput.connections[inputType][keyCode], beganFunction)

	local endedFunction = UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType[inputType] and input.KeyCode == Enum.KeyCode[keyCode] and not gameProcessed then
			if typeof(endedFunc) == "function" then
				endedFunc()
			end
		end
	end)
	table.insert(UserInput.connections[inputType][keyCode], endedFunction)
end

function UserInput.disconnectInputs(inputType)
	if UserInput.connections[inputType] then
		for _, connection in pairs(UserInput.connections[inputType]) do
			if typeof(connection) == "RBXScriptConnection" then
				connection:Disconnect()
			end
		end
		UserInput.connections[inputType] = {}
	end
end

return UserInput