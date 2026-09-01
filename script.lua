--============================================================
-- 🌍 MANI GLOBE V2
-- Single LocalScript
-- Rayfield-style GUI
--============================================================

repeat task.wait() until game:IsLoaded()

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

--============================================================
-- CONFIG
--============================================================

local PROPS_FOLDER = "001_TrafficCones"

local globeEnabled = false
local cameraEnabled = false

local globeRadius = 6
local globeSpeed = 35
local jumpPower = 50

local globeCenter
local originalPlayerPosition

local cameraDistance = 18
local cameraHeight = 7

-- Movement smoothing
local currentVelocity = Vector3.zero
local targetVelocity = Vector3.zero

-- Rotation
local globeRotation = CFrame.identity

-- Update limiter
local UPDATE_RATE = 1 / 20
local updateAccumulator = 0

--============================================================
-- FIND FOLDER
--============================================================

local workspaceCom = workspace:FindFirstChild("WorkspaceCom")

if not workspaceCom then
    warn("❌ WorkspaceCom not found")
    return
end

local propsFolder = workspaceCom:FindFirstChild(PROPS_FOLDER)

if not propsFolder then
    warn("❌ 001_TrafficCones not found")
    return
end

--============================================================
-- GET PLAYER PROPS
--============================================================

local props = {}

local function refreshProps()

    table.clear(props)

    for _, object in ipairs(propsFolder:GetChildren()) do

        if string.find(object.Name, player.Name) then
            table.insert(props, object)
        end

    end

    print("🌍 Props:", #props)
end

refreshProps()

if #props == 0 then
    warn("❌ No player props found")
end

--============================================================
-- PIVOT
--============================================================

local function getPivot(object)

    if object:IsA("Model") then
        return object:GetPivot()
    end

    if object:IsA("BasePart") then
        return object.CFrame
    end

    return nil
end

--============================================================
-- REMOTE
--============================================================

local function getRemote(object)

    local remote = object:FindFirstChild("SetCurrentCFrame")

    if remote and remote:IsA("RemoteFunction") then
        return remote
    end

    remote = object:FindFirstChild("SetCurrentCFrame", true)

    if remote and remote:IsA("RemoteFunction") then
        return remote
    end

    return nil
end

--============================================================
-- SPHERE DISTRIBUTION
--============================================================

local function createSpherePositions(count)

    local result = {}

    local goldenAngle = math.pi * (3 - math.sqrt(5))

    for i = 1, count do

        local y

        if count == 1 then
            y = 0
        else
            y = 1 - ((i - 1) / (count - 1)) * 2
        end

        local r = math.sqrt(
            math.max(0, 1 - y * y)
        )

        local theta = goldenAngle * i

        local x = math.cos(theta) * r
        local z = math.sin(theta) * r

        table.insert(
            result,
            Vector3.new(x, y, z)
        )

    end

    return result
end

local spherePoints = createSpherePositions(
    math.max(#props, 1)
)

--============================================================
-- STORE OFFSETS
--============================================================

local propOffsets = {}

local function generateOffsets()

    table.clear(propOffsets)

    for i, prop in ipairs(props) do

        local point = spherePoints[i]

        if point then

            propOffsets[i] = {
                direction = point.Unit,

                -- random-looking but deterministic orientation
                rotation = CFrame.Angles(
                    math.rad((i * 37) % 360),
                    math.rad((i * 71) % 360),
                    math.rad((i * 19) % 360)
                )
            }

        end

    end
end

generateOffsets()

--============================================================
-- SET PROP
--============================================================

local function setProp(object, cf)

    local remote = getRemote(object)

    if remote then

        task.spawn(function()

            pcall(function()
                remote:InvokeServer(cf)
            end)

        end)

        return
    end

    -- fallback only if client owns the object
    pcall(function()

        if object:IsA("Model") then
            object:PivotTo(cf)

        elseif object:IsA("BasePart") then
            object.CFrame = cf

        end

    end)

end

--============================================================
-- BUILD GLOBE
--============================================================

local function buildGlobe()

    if #props == 0 then
        refreshProps()
        generateOffsets()
    end

    if #props == 0 then
        return
    end

    globeCenter = hrp.Position

    globeRotation = CFrame.identity

    -- Freeze actual player movement
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.AutoRotate = false

    for i, prop in ipairs(props) do

        local data = propOffsets[i]

        if data then

            local direction =
                data.direction

            local position =
                globeCenter +
                direction * globeRadius

            -- Keep surface objects pointing outward
            local look =
                CFrame.lookAt(
                    position,
                    globeCenter
                )

            local finalCF =
                look * data.rotation

            setProp(prop, finalCF)

        end

        task.wait(0.035)
    end

end

--============================================================
-- UPDATE GLOBE
--============================================================

local function updateGlobe()

    if not globeEnabled then
        return
    end

    if not globeCenter then
        return
    end

    if #props == 0 then
        return
    end

    local move =
        humanoid.MoveDirection

    --========================================================
    -- CAMERA RELATIVE MOVEMENT
    --========================================================

    if move.Magnitude > 0.01 then

        local camForward =
            camera.CFrame.LookVector

        local camRight =
            camera.CFrame.RightVector

        -- Flatten camera vectors
        camForward = Vector3.new(
            camForward.X,
            0,
            camForward.Z
        )

        camRight = Vector3.new(
            camRight.X,
            0,
            camRight.Z
        )

        if camForward.Magnitude > 0 then
            camForward = camForward.Unit
        end

        if camRight.Magnitude > 0 then
            camRight = camRight.Unit
        end

        local desired =
            camForward * (-move.Z) +
            camRight * move.X

        if desired.Magnitude > 0.01 then
            desired = desired.Unit
        end

        targetVelocity =
            desired * globeSpeed

    else

        targetVelocity =
            Vector3.zero

    end

    --========================================================
    -- SMOOTH ACCELERATION
    --========================================================

    currentVelocity =
        currentVelocity:Lerp(
            targetVelocity,
            0.15
        )

    local dt = UPDATE_RATE

    local movement =
        currentVelocity * dt

    globeCenter += movement

    --========================================================
    -- REALISTIC ROLL DIRECTION
    --========================================================

    local flatVelocity =
        Vector3.new(
            currentVelocity.X,
            0,
            currentVelocity.Z
        )

    if flatVelocity.Magnitude > 0.05 then

        local direction =
            flatVelocity.Unit

        local rollAxis =
            Vector3.new(
                direction.Z,
                0,
                -direction.X
            )

        local angularAmount =
            flatVelocity.Magnitude /
            math.max(globeRadius, 0.1)

        globeRotation =
            CFrame.fromAxisAngle(
                rollAxis,
                angularAmount * dt
            ) *
            globeRotation

    end

    --========================================================
    -- UPDATE PROPS
    --========================================================

    for i, prop in ipairs(props) do

        local data =
            propOffsets[i]

        if data then

            local rotated =
                globeRotation:
                VectorToWorldSpace(
                    data.direction
                )

            local position =
                globeCenter +
                rotated * globeRadius

            local look =
                CFrame.lookAt(
                    position,
                    globeCenter
                )

            local finalCF =
                look * data.rotation

            setProp(
                prop,
                finalCF
            )

        end

    end

end

--============================================================
-- CAMERA
--============================================================

local cameraSmooth =
    CFrame.new()

local function updateCamera(dt)

    if not globeEnabled or not cameraEnabled then
        return
    end

    if not globeCenter then
        return
    end

    -- Normal Roblox-like third person camera
    local cameraFocus =
        globeCenter

    local offset =
        Vector3.new(
            0,
            cameraHeight,
            cameraDistance
        )

    local wantedPosition =
        cameraFocus + offset

    local wantedCF =
        CFrame.lookAt(
            wantedPosition,
            cameraFocus
        )

    cameraSmooth =
        cameraSmooth:Lerp(
            wantedCF,
            math.clamp(dt * 8, 0, 1)
        )

    camera.CameraType =
        Enum.CameraType.Scriptable

    camera.CFrame =
        cameraSmooth

end

--============================================================
-- ENABLE GLOBE
--============================================================

local function enableGlobe()

    if globeEnabled then
        return
    end

    refreshProps()
    generateOffsets()

    if #props == 0 then
        return
    end

    globeEnabled = true

    originalPlayerPosition =
        hrp.CFrame

    globeCenter =
        hrp.Position

    currentVelocity =
        Vector3.zero

    targetVelocity =
        Vector3.zero

    buildGlobe()

    print("🌍 Globe enabled")

end

--============================================================
-- DISABLE GLOBE
--============================================================

local function disableGlobe()

    globeEnabled = false

    currentVelocity =
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

    print("🌍 Globe disabled")

end

--============================================================
-- JUMP
--============================================================

local function globeJump()

    if not globeEnabled then
        return
    end

    -- Smooth vertical impulse
    globeCenter +=
        Vector3.new(
            0,
            jumpPower * 0.08,
            0
        )

end

--============================================================
-- RAYFIELD LOAD
--============================================================

local Rayfield

local success, loaded =
    pcall(function()

        return loadstring(
            game:HttpGet(
                "https://sirius.menu/rayfield"
            )
        )()

    end)

if not success or not loaded then

    warn("❌ Rayfield failed")

    return

end

Rayfield = loaded

--============================================================
-- WINDOW
--============================================================

local Window =
    Rayfield:CreateWindow({

        Name = "MANI GLOBE",

        LoadingTitle =
            "MANI GLOBE",

        LoadingSubtitle =
            "15 Prop Rolling System",

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
-- MASTER TOGGLE
--============================================================

GlobeTab:CreateToggle({

    Name = "🌍 Globe Controller",

    CurrentValue = false,

    Flag = "GlobeController",

    Callback = function(value)

        if value then
            enableGlobe()
        else
            disableGlobe()
        end

    end

})

--============================================================
-- CAMERA TOGGLE
--============================================================

GlobeTab:CreateToggle({

    Name = "🎥 Globe Camera",

    CurrentValue = true,

    Flag = "GlobeCamera",

    Callback = function(value)

        cameraEnabled = value

        if not value then

            camera.CameraType =
                Enum.CameraType.Custom

            camera.CameraSubject =
                humanoid

        elseif globeEnabled then

            camera.CameraType =
                Enum.CameraType.Scriptable

        end

    end

})

--============================================================
-- SIZE
--============================================================

GlobeTab:CreateSlider({

    Name = "⚽ Globe Size",

    Range = {
        3,
        15
    },

    Increment = 0.5,

    Suffix = " studs",

    CurrentValue = 6,

    Flag = "GlobeSize",

    Callback = function(value)

        globeRadius = value

        if globeEnabled then
            buildGlobe()
        end

    end

})

--============================================================
-- SPEED
--============================================================

GlobeTab:CreateSlider({

    Name = "🏃 Rolling Speed",

    Range = {
        5,
        120
    },

    Increment = 5,

    Suffix = " studs/s",

    CurrentValue = 35,

    Flag = "GlobeSpeed",

    Callback = function(value)

        globeSpeed = value

    end

})

--============================================================
-- JUMP
--============================================================

GlobeTab:CreateSlider({

    Name = "🚀 Jump Power",

    Range = {
        10,
        100
    },

    Increment = 5,

    Suffix = " power",

    CurrentValue = 50,

    Flag = "JumpPower",

    Callback = function(value)

        jumpPower = value

    end

})

--============================================================
-- CAMERA DISTANCE
--============================================================

GlobeTab:CreateSlider({

    Name = "📷 Camera Distance",

    Range = {
        8,
        40
    },

    Increment = 1,

    Suffix = " studs",

    CurrentValue = 18,

    Flag = "CameraDistance",

    Callback = function(value)

        cameraDistance = value

    end

})

--============================================================
-- CAMERA HEIGHT
--============================================================

GlobeTab:CreateSlider({

    Name = "📐 Camera Height",

    Range = {
        2,
        20
    },

    Increment = 1,

    Suffix = " studs",

    CurrentValue = 7,

    Flag = "CameraHeight",

    Callback = function(value)

        cameraHeight = value

    end

})

--============================================================
-- REBUILD
--============================================================

GlobeTab:CreateButton({

    Name = "🔄 Rebuild Globe",

    Callback = function()

        if globeEnabled then
            buildGlobe()
        else
            refreshProps()
            generateOffsets()
        end

    end

})

--============================================================
-- REFRESH
--============================================================

GlobeTab:CreateButton({

    Name = "🔍 Refresh Props",

    Callback = function()

        refreshProps()
        generateOffsets()

        Rayfield:Notify({

            Title = "🌍 Globe",

            Content =
                "Found " ..
                tostring(#props) ..
                " props.",

            Duration = 3

        })

    end

})

--============================================================
-- RESET
--============================================================

GlobeTab:CreateButton({

    Name = "↩ Reset Camera",

    Callback = function()

        camera.CameraType =
            Enum.CameraType.Custom

        camera.CameraSubject =
            humanoid

        cameraEnabled = false

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

    Title = "🌍 How to use",

    Content =
        "1. Turn Globe Controller ON.\n\n" ..
        "2. Use the normal Roblox mobile joystick.\n\n" ..
        "3. Movement is camera-relative, so the globe can travel in 360° directions.\n\n" ..
        "4. Change Globe Size / Speed / Jump.\n\n" ..
        "5. Globe Camera gives a third-person globe-following view."

})

--============================================================
-- INPUT
--============================================================

UserInputService.JumpRequest:Connect(function()

    if globeEnabled then
        globeJump()
    end

end)

--============================================================
-- MAIN LOOP
--============================================================

RunService.RenderStepped:Connect(function(dt)

    if not globeEnabled then
        return
    end

    updateAccumulator += dt

    -- Keep updates consistent
    if updateAccumulator >= UPDATE_RATE then

        updateAccumulator = 0

        updateGlobe()

    end

    updateCamera(dt)

end)

--============================================================
-- CHARACTER RESPAWN
--============================================================

player.CharacterAdded:Connect(function(newCharacter)

    character = newCharacter

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

end)

--============================================================
-- START
--============================================================

Rayfield:Notify({

    Title = "🌍 MANI GLOBE",

    Content =
        "15-prop globe controller loaded!",

    Duration = 4

})

print("======================================")
print("🌍 MANI GLOBE V2 LOADED")
print("Props:", #props)
print("Camera-relative 360° movement: ON")
print("======================================")
