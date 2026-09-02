--============================================================
-- 🌍 MANI GLOBE V3
-- SINGLE LOCALSCRIPT
--============================================================

repeat task.wait() until game:IsLoaded()

--============================================================
-- SERVICES
--============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

--============================================================
-- SETTINGS
--============================================================

local GLOBE_RADIUS = 8
local GLOBE_SPEED = 35
local JUMP_POWER = 50

local globeEnabled = false
local cameraEnabled = false

local globeCenter = nil

-- Camera orbit
local cameraYaw = 0
local cameraPitch = math.rad(15)

local cameraDistance = 20
local cameraHeight = 3

local CAMERA_SENSITIVITY = 0.004
local CAMERA_MIN_PITCH = math.rad(-70)
local CAMERA_MAX_PITCH = math.rad(70)

-- Movement
local velocity = Vector3.zero
local targetVelocity = Vector3.zero

-- Rotation
local globeRotation = CFrame.identity

-- Remote update
local UPDATE_INTERVAL = 1 / 15
local updateTimer = 0

--============================================================
-- FIND PROPS
--============================================================

local workspaceCom = workspace:FindFirstChild("WorkspaceCom")

if not workspaceCom then
    warn("❌ WorkspaceCom not found")
    return
end

local propsFolder =
    workspaceCom:FindFirstChild("001_TrafficCones")

if not propsFolder then
    warn("❌ 001_TrafficCones folder not found")
    return
end

local props = {}

local function refreshProps()

    table.clear(props)

    for _, obj in ipairs(propsFolder:GetChildren()) do

        if string.find(obj.Name, player.Name) then

            if obj:IsA("Model") or obj:IsA("BasePart") then
                table.insert(props, obj)
            end

        end

    end

    print("🌍 Found Props:", #props)

end

refreshProps()

if #props < 15 then
    warn(
        "⚠ Only " ..
        tostring(#props) ..
        " props found. Expected 15."
    )
end

--============================================================
-- REMOTE
--============================================================

local function findRemote(prop)

    local remote =
        prop:FindFirstChild("SetCurrentCFrame")

    if remote and remote:IsA("RemoteFunction") then
        return remote
    end

    remote =
        prop:FindFirstChild(
            "SetCurrentCFrame",
            true
        )

    if remote and remote:IsA("RemoteFunction") then
        return remote
    end

    return nil

end

local function moveProp(prop, cf)

    local remote = findRemote(prop)

    if remote then

        task.spawn(function()

            pcall(function()
                remote:InvokeServer(cf)
            end)

        end)

    else

        pcall(function()

            if prop:IsA("Model") then
                prop:PivotTo(cf)

            elseif prop:IsA("BasePart") then
                prop.CFrame = cf

            end

        end)

    end

end

--============================================================
-- PERFECT 15-POINT GLOBE
--============================================================

-- Manually optimized 15-point spherical distribution.
-- Better visual balance than simple top-to-bottom points.

local SPHERE_POINTS = {

    -- Top
    Vector3.new(0, 1, 0),

    -- Upper ring
    Vector3.new(0.707, 0.55, 0),
    Vector3.new(-0.354, 0.55, 0.612),
    Vector3.new(-0.354, 0.55, -0.612),
    Vector3.new(0.354, 0.55, 0.612),
    Vector3.new(0.354, 0.55, -0.612),

    -- Middle ring
    Vector3.new(1, 0, 0),
    Vector3.new(0.309, 0, 0.951),
    Vector3.new(-0.809, 0, 0.588),
    Vector3.new(-0.809, 0, -0.588),
    Vector3.new(0.309, 0, -0.951),

    -- Lower ring
    Vector3.new(0.354, -0.55, 0.612),
    Vector3.new(-0.354, -0.55, 0.612),
    Vector3.new(-0.354, -0.55, -0.612),

    -- Bottom
    Vector3.new(0, -1, 0)
}

-- Normalize every point
for i, point in ipairs(SPHERE_POINTS) do
    SPHERE_POINTS[i] = point.Unit
end

--============================================================
-- PROP ORIENTATION
--============================================================

local propRotations = {}

for i = 1, 15 do

    propRotations[i] =
        CFrame.Angles(
            math.rad((i * 47) % 360),
            math.rad((i * 83) % 360),
            math.rad((i * 29) % 360)
        )

end

--============================================================
-- PLACE GLOBE
--============================================================

local function placeGlobe()

    if #props == 0 then
        return
    end

    if not globeCenter then
        globeCenter = hrp.Position
    end

    for i, prop in ipairs(props) do

        local point =
            SPHERE_POINTS[
                ((i - 1) % #SPHERE_POINTS) + 1
            ]

        local rotated =
            globeRotation:
            VectorToWorldSpace(point)

        local position =
            globeCenter +
            rotated * GLOBE_RADIUS

        -- Point toward globe center
        local cf =
            CFrame.lookAt(
                position,
                globeCenter
            )

        -- Preserve prop-specific rotation
        if propRotations[i] then
            cf =
                cf *
                propRotations[i]
        end

        moveProp(
            prop,
            cf
        )

    end

end

--============================================================
-- BUILD
--============================================================

local function buildGlobe()

    refreshProps()

    if #props == 0 then
        return
    end

    globeCenter =
        hrp.Position

    globeRotation =
        CFrame.identity

    velocity =
        Vector3.zero

    targetVelocity =
        Vector3.zero

    -- Player stays at current location
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.AutoRotate = false

    placeGlobe()

end

--============================================================
-- CAMERA-RELATIVE MOVEMENT
--============================================================

local function getMovementDirection()

    local move =
        humanoid.MoveDirection

    if move.Magnitude < 0.01 then
        return Vector3.zero
    end

    -- Camera forward/right
    local forward =
        camera.CFrame.LookVector

    local right =
        camera.CFrame.RightVector

    -- Flatten
    forward =
        Vector3.new(
            forward.X,
            0,
            forward.Z
        )

    right =
        Vector3.new(
            right.X,
            0,
            right.Z
        )

    if forward.Magnitude > 0 then
        forward = forward.Unit
    end

    if right.Magnitude > 0 then
        right = right.Unit
    end

    -- Roblox MoveDirection is world-relative.
    -- Convert joystick direction to camera-relative.
    local x =
        move:Dot(right)

    local z =
        move:Dot(forward)

    local direction =
        right * x +
        forward * z

    if direction.Magnitude > 1 then
        direction =
            direction.Unit
    end

    return direction

end

--============================================================
-- ROLL GLOBE
--============================================================

local function updateGlobe(dt)

    if not globeEnabled then
        return
    end

    local direction =
        getMovementDirection()

    if direction.Magnitude > 0.01 then

        targetVelocity =
            direction *
            GLOBE_SPEED

    else

        targetVelocity =
            Vector3.zero

    end

    -- Smooth acceleration
    velocity =
        velocity:Lerp(
            targetVelocity,
            math.clamp(dt * 7, 0, 1)
        )

    -- Move globe
    globeCenter +=
        velocity * dt

    --========================================================
    -- PHYSICS-LIKE ROLL
    --========================================================

    local horizontalVelocity =
        Vector3.new(
            velocity.X,
            0,
            velocity.Z
        )

    if horizontalVelocity.Magnitude > 0.05 then

        local directionUnit =
            horizontalVelocity.Unit

        -- Rolling axis perpendicular to movement
        local axis =
            Vector3.new(
                -directionUnit.Z,
                0,
                directionUnit.X
            )

        local angle =
            horizontalVelocity.Magnitude /
            math.max(GLOBE_RADIUS, 0.1) *
            dt

        globeRotation =
            CFrame.fromAxisAngle(
                axis,
                angle
            ) *
            globeRotation

    end

end

--============================================================
-- 360 CAMERA
--============================================================

local function updateCamera(dt)

    if not globeEnabled or not cameraEnabled then
        return
    end

    if not globeCenter then
        return
    end

    camera.CameraType =
        Enum.CameraType.Scriptable

    -- Full spherical orbit
    local yawCF =
        CFrame.Angles(
            0,
            cameraYaw,
            0
        )

    local pitchCF =
        CFrame.Angles(
            cameraPitch,
            0,
            0
        )

    local rotation =
        yawCF *
        pitchCF

    local offset =
        rotation *
        Vector3.new(
            0,
            cameraHeight,
            cameraDistance
        )

    local position =
        globeCenter +
        offset

    local lookAt =
        globeCenter

    local wanted =
        CFrame.lookAt(
            position,
            lookAt
        )

    camera.CFrame =
        camera.CFrame:Lerp(
            wanted,
            math.clamp(
                dt * 10,
                0,
                1
            )
        )

end

--============================================================
-- TOUCH CAMERA
--============================================================

local draggingCamera = false
local lastTouchPosition = nil

UserInputService.TouchStarted:Connect(
    function(input, processed)

        if processed then
            return
        end

        if not cameraEnabled then
            return
        end

        draggingCamera = true
        lastTouchPosition =
            input.Position

    end
)

UserInputService.TouchMoved:Connect(
    function(input, processed)

        if not draggingCamera then
            return
        end

        if not cameraEnabled then
            return
        end

        if not lastTouchPosition then
            lastTouchPosition =
                input.Position
            return
        end

        local delta =
            input.Position -
            lastTouchPosition

        lastTouchPosition =
            input.Position

        cameraYaw -=
            delta.X *
            CAMERA_SENSITIVITY

        cameraPitch -=
            delta.Y *
            CAMERA_SENSITIVITY

        cameraPitch =
            math.clamp(
                cameraPitch,
                CAMERA_MIN_PITCH,
                CAMERA_MAX_PITCH
            )

    end
)

UserInputService.TouchEnded:Connect(
    function()

        draggingCamera = false
        lastTouchPosition = nil

    end
)

--============================================================
-- MOUSE CAMERA
--============================================================

local mouseDragging = false
local lastMousePosition

UserInputService.InputBegan:Connect(
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton2 then

            mouseDragging = true

            lastMousePosition =
                UserInputService:GetMouseLocation()

        end

    end
)

UserInputService.InputChanged:Connect(
    function(input)

        if not mouseDragging then
            return
        end

        if input.UserInputType ~=
            Enum.UserInputType.MouseMovement then
            return
        end

        local position =
            UserInputService:GetMouseLocation()

        if lastMousePosition then

            local delta =
                position -
                lastMousePosition

            cameraYaw -=
                delta.X *
                CAMERA_SENSITIVITY

            cameraPitch -=
                delta.Y *
                CAMERA_SENSITIVITY

            cameraPitch =
                math.clamp(
                    cameraPitch,
                    CAMERA_MIN_PITCH,
                    CAMERA_MAX_PITCH
                )

        end

        lastMousePosition =
            position

    end
)

UserInputService.InputEnded:Connect(
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton2 then

            mouseDragging = false

        end

    end
)

--============================================================
-- JUMP
--============================================================

local function jumpGlobe()

    if not globeEnabled then
        return
    end

    globeCenter +=
        Vector3.new(
            0,
            JUMP_POWER * 0.12,
            0
        )

end

UserInputService.JumpRequest:Connect(
    function()

        if globeEnabled then
            jumpGlobe()
        end

    end
)

--============================================================
-- ENABLE
--============================================================

local function enableGlobe()

    if globeEnabled then
        return
    end

    globeEnabled = true

    buildGlobe()

end

--============================================================
-- DISABLE
--============================================================

local function disableGlobe()

    globeEnabled = false

    velocity =
        Vector3.zero

    targetVelocity =
        Vector3.zero

    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
    humanoid.AutoRotate = true

    camera.CameraType =
        Enum.CameraType.Custom

    camera.CameraSubject =
        humanoid

end

--============================================================
-- RAYFIELD
--============================================================

local Rayfield

local loaded, result =
    pcall(function()

        return loadstring(
            game:HttpGet(
                "https://sirius.menu/rayfield"
            )
        )()

    end)

if not loaded then
    warn("❌ Rayfield failed to load")
    return
end

Rayfield = result

--============================================================
-- WINDOW
--============================================================

local Window =
    Rayfield:CreateWindow({

        Name = "MANI GLOBE",

        LoadingTitle =
            "MANI GLOBE",

        LoadingSubtitle =
            "15 Prop Globe",

        ConfigurationSaving = {
            Enabled = false
        },

        Discord = {
            Enabled = false
        },

        KeySystem = false

    })

--============================================================
-- GLOBE TAB
--============================================================

local GlobeTab =
    Window:CreateTab(
        "🌍 Globe",
        4483362458
    )

GlobeTab:CreateSection(
    "Globe Controller"
)

--============================================================
-- MASTER
--============================================================

GlobeTab:CreateToggle({

    Name = "🌍 Globe ON / OFF",

    CurrentValue = false,

    Callback = function(value)

        if value then
            enableGlobe()
        else
            disableGlobe()
        end

    end

})

--============================================================
-- CAMERA
--============================================================

GlobeTab:CreateToggle({

    Name = "🎥 360° Globe Camera",

    CurrentValue = true,

    Callback = function(value)

        cameraEnabled =
            value

        if value and globeEnabled then

            camera.CameraType =
                Enum.CameraType.Scriptable

        else

            camera.CameraType =
                Enum.CameraType.Custom

            camera.CameraSubject =
                humanoid

        end

    end

})

--============================================================
-- SIZE
--============================================================

GlobeTab:CreateSlider({

    Name = "⚽ Globe Size",

    Range = {
        4,
        16
    },

    Increment = 0.5,

    Suffix = " studs",

    CurrentValue = 8,

    Callback = function(value)

        GLOBE_RADIUS =
            value

        if globeEnabled then
            placeGlobe()
        end

    end

})

--============================================================
-- SPEED
--============================================================

GlobeTab:CreateSlider({

    Name = "🏃 Globe Speed",

    Range = {
        5,
        150
    },

    Increment = 5,

    Suffix = " studs/s",

    CurrentValue = 35,

    Callback = function(value)

        GLOBE_SPEED =
            value

    end

})

--============================================================
-- JUMP
--============================================================

GlobeTab:CreateSlider({

    Name = "🚀 Jump Power",

    Range = {
        10,
        150
    },

    Increment = 5,

    Suffix = " power",

    CurrentValue = 50,

    Callback = function(value)

        JUMP_POWER =
            value

    end

})

--============================================================
-- CAMERA DISTANCE
--============================================================

GlobeTab:CreateSlider({

    Name = "📷 Camera Distance",

    Range = {
        8,
        50
    },

    Increment = 1,

    Suffix = " studs",

    CurrentValue = 20,

    Callback = function(value)

        cameraDistance =
            value

    end

})

--============================================================
-- CAMERA HEIGHT
--============================================================

GlobeTab:CreateSlider({

    Name = "↕ Camera Height",

    Range = {
        -10,
        20
    },

    Increment = 1,

    Suffix = " studs",

    CurrentValue = 3,

    Callback = function(value)

        cameraHeight =
            value

    end

})

--============================================================
-- CAMERA SENSITIVITY
--============================================================

GlobeTab:CreateSlider({

    Name = "🎮 Camera Sensitivity",

    Range = {
        1,
        10
    },

    Increment = 1,

    Suffix = "x",

    CurrentValue = 4,

    Callback = function(value)

        CAMERA_SENSITIVITY =
            value * 0.001

    end

})

--============================================================
-- REBUILD
--============================================================

GlobeTab:CreateButton({

    Name = "🔄 Rebuild 15-Prop Globe",

    Callback = function()

        refreshProps()

        if #props > 0 then

            generateOffsets = nil

            globeRotation =
                CFrame.identity

            placeGlobe()

            Rayfield:Notify({

                Title = "🌍 Globe",

                Content =
                    tostring(#props) ..
                    " props rebuilt.",

                Duration = 3

            })

        end

    end

})
--============================================================
-- CENTER GLOBE
--============================================================

GlobeTab:CreateButton({

    Name = "🎯 Center Globe",

    Callback = function()

        if globeEnabled then

            globeCenter =
                hrp.Position

            globeRotation =
                CFrame.identity

            placeGlobe()

        end

    end

})

--============================================================
-- RESET CAMERA
--============================================================

GlobeTab:CreateButton({

    Name = "↩ Reset Camera",

    Callback = function()

        cameraYaw = 0
        cameraPitch = math.rad(15)

    end

})

--============================================================
-- INFO TAB
--============================================================

local InfoTab =
    Window:CreateTab(
        "ℹ Info",
        4483362458
    )

InfoTab:CreateSection(
    "Controls"
)

InfoTab:CreateParagraph({

    Title = "🌍 15-Prop Globe",

    Content =
        "• 15 props are distributed around a spherical surface.\n\n" ..
        "• Roblox joystick controls the globe.\n\n" ..
        "• Movement is camera-relative and supports 360° directions.\n\n" ..
        "• Drag the screen to orbit the camera around the globe.\n\n" ..
        "• Globe size, speed and jump are adjustable.\n\n" ..
        "• Globe Camera provides a third-person orbit view."

})
--============================================================
-- MAIN LOOP
--============================================================

RunService.RenderStepped:Connect(
    function(dt)

        if not globeEnabled then
            return
        end

        updateGlobe(dt)

        updateCamera(dt)

        updateTimer += dt

        if updateTimer >= UPDATE_INTERVAL then

            updateTimer = 0

            placeGlobe()

        end

    end
)

--============================================================
-- CHARACTER RESPAWN
--============================================================

player.CharacterAdded:Connect(
    function(newCharacter)

        character =
            newCharacter

        humanoid =
            character:WaitForChild(
                "Humanoid"
            )

        hrp =
            character:WaitForChild(
                "HumanoidRootPart"
            )

        if globeEnabled then

            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid.AutoRotate = false

        end

    end
)

Rayfield:Notify({

    Title = "🌍 MANI GLOBE",

    Content =
        "15-prop 360° globe controller ready!",

    Duration = 4

})

print("======================================")
print("🌍 MANI GLOBE V3")
print("15 PROP SPHERE: READY")
print("360 CAMERA: READY")
print("CAMERA RELATIVE MOVEMENT: READY")
print("======================================")

