local fcRunning = false
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
local cameraRot = nil
local cameraPos = nil
local cameraFov = nil

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local newCamera = workspace.CurrentCamera
	if newCamera then Camera = newCamera end
end)

local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value

local Spring = nil
Spring = {} do
	Spring.__index = Spring
	Spring.new = function(freq, pos)
		local self = setmetatable({}, Spring)
		self.f = freq
		self.p = pos
		self.v = pos * 0
		return self
	end
	function Spring:Update(dt, goal)
		local f = self.f * 2 * math.pi
		local p0 = self.p
		local v0 = self.v
		local offset = goal - p0
		local decay = math.exp(-f * dt)
		local p1 = goal + (v0 * dt - offset * (f * dt + 1)) * decay
		local v1 = (f * dt * (offset * f - v0) + v0) * decay
		self.p = p1
		self.v = v1
		return p1
	end
	function Spring:Reset(pos)
		self.p = pos
		self.v = pos * 0
	end
end

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()

local velSpring = Spring.new(5, Vector3.new())
local panSpring = Spring.new(5, Vector2.new())

local Input = nil
Input = {} do
	local keyboard = {
		W = 0,
		A = 0,
		S = 0,
		D = 0,
		E = 0,
		Q = 0,
		Up = 0,
		Down = 0,
		LeftShift = 0,
	}
	local mouse = {
		Delta = Vector2.new(),
	}
	local PAN_MOUSE_SPEED = Vector2.new(1, 1) * (math.pi / 64)
	local NAV_ADJ_SPEED = 0.75
	local NAV_SHIFT_MUL = 0.25
	local navSpeed = 1
	Input.Vel = function(dt)
		navSpeed = math.clamp(navSpeed + dt * (keyboard.Up - keyboard.Down) * NAV_ADJ_SPEED, 0.01, 4)
		local kKeyboard = Vector3.new(
			keyboard.D - keyboard.A,
			keyboard.E - keyboard.Q,
			keyboard.S - keyboard.W
		) * NAV_KEYBOARD_SPEED
		local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
		return (kKeyboard) * (navSpeed * (shift and NAV_SHIFT_MUL or 1))
	end
	Input.Pan = function(dt)
		local kMouse = mouse.Delta * PAN_MOUSE_SPEED
		mouse.Delta = Vector2.new()
		return kMouse
	end
	do
		local Keypress = function(action, state, input)
			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end
		local MousePan = function(action, state, input)
			local delta = input.Delta
			mouse.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end
		local Zero = function(t)
			for k, v in pairs(t) do
				t[k] = v * 0
			end
		end
		Input.StartCapture = function()
			game:GetService("ContextActionService"):BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
				Enum.KeyCode.W,
				Enum.KeyCode.A,
				Enum.KeyCode.S,
				Enum.KeyCode.D,
				Enum.KeyCode.E,
				Enum.KeyCode.Q,
				Enum.KeyCode.Up,
				Enum.KeyCode.Down
			)
			game:GetService("ContextActionService"):BindActionAtPriority("FreecamMousePan", MousePan, false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
		end
		Input.StopCapture = function()
			navSpeed = 1
			Zero(keyboard)
			Zero(mouse)
			game:GetService("ContextActionService"):UnbindAction("FreecamKeyboard")
			game:GetService("ContextActionService"):UnbindAction("FreecamMousePan")
		end
	end
end

local GetFocusDistance = function(cameraFrame)
	local znear = 0.1
	local viewport = Camera.ViewportSize
	local projy = 2 * math.tan(cameraFov / 2)
	local projx = viewport.x / viewport.y * projy
	local fx = cameraFrame.rightVector
	local fy = cameraFrame.upVector
	local fz = cameraFrame.lookVector
	local minVect = Vector3.new()
	local minDist = 512
	for x = 0, 1, 0.5 do
		for y = 0, 1, 0.5 do
			local cx = (x - 0.5) * projx
			local cy = (y - 0.5) * projy
			local offset = fx * cx - fy * cy + fz
			local origin = cameraFrame.p + offset * znear
			local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit * minDist))
			local dist = (hit - origin).magnitude
			if minDist > dist then
				minDist = dist
				minVect = offset.unit
			end
		end
	end
	return fz:Dot(minVect) * minDist
end

local StepFreecam = function(dt)
	local vel = velSpring:Update(dt, Input.Vel(dt))
	local pan = panSpring:Update(dt, Input.Pan(dt))
	local zoomFactor = math.sqrt(math.tan(math.rad(70 / 2)) / math.tan(math.rad(cameraFov / 2)))
	cameraRot = cameraRot + pan * Vector2.new(0.75, 1) * 8 * (dt / zoomFactor)
	cameraRot = Vector2.new(math.clamp(cameraRot.x, -math.rad(90), math.rad(90)), cameraRot.y%(2 * math.pi))
	local cameraCFrame = CFrame.new(cameraPos) * CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0) * CFrame.new(vel * Vector3.new(1, 1, 1) * 64 * dt)
	cameraPos = cameraCFrame.p
	Camera.CFrame = cameraCFrame
	Camera.Focus = cameraCFrame * CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
	Camera.FieldOfView = cameraFov
end

local PlayerState = nil
PlayerState = {} do
	local mouseBehavior = ""
	local mouseIconEnabled = ""
	local cameraType = ""
	local cameraFocus = ""
	local cameraCFrame = ""
	local cameraFieldOfView = ""
	PlayerState.Push = function()
		cameraFieldOfView = Camera.FieldOfView
		Camera.FieldOfView = 70
		cameraType = Camera.CameraType
		Camera.CameraType = Enum.CameraType.Custom
		cameraCFrame = Camera.CFrame
		cameraFocus = Camera.Focus
		mouseIconEnabled = UserInputService.MouseIconEnabled
		UserInputService.MouseIconEnabled = true
		mouseBehavior = UserInputService.MouseBehavior
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
	PlayerState.Pop = function()
		Camera.FieldOfView = 70
		Camera.CameraType = cameraType
		cameraType = nil
		Camera.CFrame = cameraCFrame
		cameraCFrame = nil
		Camera.Focus = cameraFocus
		cameraFocus = nil
		UserInputService.MouseIconEnabled = mouseIconEnabled
		mouseIconEnabled = nil
		UserInputService.MouseBehavior = mouseBehavior
		mouseBehavior = nil
	end
end

local StopFreecam = function()
	if not fcRunning then return end
	Input.StopCapture()
	game:GetService("RunService"):UnbindFromRenderStep("Freecam")
	PlayerState.Pop()
	workspace.Camera.FieldOfView = 70
	fcRunning = false
end

local StartFreecam = function(pos)
	if fcRunning then StopFreecam() end
	local cameraCFrame = Camera.CFrame
	if pos then cameraCFrame = pos end
	cameraRot = Vector2.new()
	cameraPos = cameraCFrame.p
	cameraFov = Camera.FieldOfView
	velSpring:Reset(Vector3.new())
	panSpring:Reset(Vector2.new())
	PlayerState.Push()
	game:GetService("RunService"):BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
	Input.StartCapture()
	fcRunning = true
end

local UpdateSpeed = function(sp)
	NAV_KEYBOARD_SPEED = Vector3.new(sp, sp, sp)
end

return {
  ["Start"] = StartFreecam,
  ["Stop"] = StopFreecam,
  ["UpdateSpeed"] = UpdateSpeed
}
