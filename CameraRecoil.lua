local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

local SpringModule = require(script.SpringModule)
local Spring = SpringModule.new()

local CameraRecoil = {}

local recoilDecay = 3
local currentRecoil = 0


--working
local function onRenderStepped(dt)
	local camera = workspace.CurrentCamera
	
	-- Linear recoil
	local diff = (currentRecoil * recoilDecay * dt)
	currentRecoil = currentRecoil - diff
	local xRot, yRot, zRot = camera.CFrame:ToEulerAnglesXYZ()
	camera.CFrame = CFrame.new(camera.CFrame.Position) * CFrame.Angles(xRot, yRot, zRot) * CFrame.Angles(-math.rad(diff),0,0)
	
	-- Spring recoil
	Spring:update(dt)
	camera.CFrame *= CFrame.Angles(math.rad(Spring.Position.X),0,0)
end

function CameraRecoil.addLinearRecoil(recoilAmount)
	currentRecoil += recoilAmount
	local camera = workspace.CurrentCamera

	local xRot, yRot, zRot = camera.CFrame:ToEulerAnglesXYZ()
	camera.CFrame = CFrame.new(camera.CFrame.Position) * CFrame.Angles(xRot, yRot, zRot) * CFrame.Angles(math.rad(recoilAmount),0,0)
end

function CameraRecoil.addSpringRecoil(recoilAmount)
	Spring:shove(Vector3.new(recoilAmount,0,0))
	task.delay(1/15 * 0.75, function()
		Spring:shove(Vector3.new(-recoilAmount,0,0))
	end)
end

RunService:BindToRenderStep("CameraRecoil", Enum.RenderPriority.Camera.Value, onRenderStepped)

return CameraRecoil
