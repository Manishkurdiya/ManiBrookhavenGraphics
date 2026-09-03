--============================================================
-- 🌍 MANI GLOBE V4
-- SINGLE LOCALSCRIPT
-- Gravity + Ground + 360 Camera + Smart Joystick
--============================================================

repeat task.wait() until game:IsLoaded()

--============================================================
-- SERVICES
--============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

--============================================================
-- SETTINGS
--============================================================

local GlobeEnabled = false
local CameraEnabled = true

local GlobeRadius = 8
local GlobeSpeed = 35
local JumpPower = 55

-- Gravity
local Gravity = workspace.Gravity
local VerticalVelocity = 0

-- Ground
local Grounded = false
local GroundOffset = 0.15

-- Movement
local HorizontalVelocity = Vector3.zero
local TargetVelocity = Vector3.zero

-- Physics tuning
local Acceleration = 8
local AirAcceleration = 3
local GroundFriction = 5

-- Globe
local GlobeCenter = nil
local GlobeRotation = CFrame.identity

--============================================================
-- CAMERA
--============================================================

local CameraYaw = 0
local CameraPitch = math.rad(15)

local CameraDistance = 20
local CameraHeight = 4

local CameraSensitivity = 0.004

local MinPitch = math.rad(-75)
local MaxPitch = math.rad(75)

local CameraSmoothness = 10

--============================================================
-- PROPS
--============================================================

local WorkspaceCom =
    workspace:FindFirstChild("WorkspaceCom")

if not WorkspaceCom then
    warn("❌ WorkspaceCom not found")
    return
end

local PropsFolder =
    WorkspaceCom:FindFirstChild("001_TrafficCones")

if not PropsFolder then
    warn("❌ 001_TrafficCones not found")
    return
end

local Props = {}

--============================================================
-- REFRESH PROPS
--============================================================

local function RefreshProps()

    table.clear(Props)

    for _, Object in ipairs(
        PropsFolder:GetChildren()
    ) do

        if string.find(
            Object.Name,
            Player.Name
        ) then

            if Object:IsA("Model")
                or Object:IsA("BasePart") then

                table.insert(
                    Props,
                    Object
                )

            end

        end

    end

    print(
        "🌍 Player Props:",
        #Props
    )

end

RefreshProps()

--============================================================
-- SPHERE POINTS
--============================================================

local SpherePoints = {

    Vector3.new(0, 1, 0),

    Vector3.new(
        0.707,
        0.55,
        0
    ),

    Vector3.new(
        -0.354,
        0.55,
        0.612
    ),

    Vector3.new(
        -0.354,
        0.55,
        -0.612
    ),

    Vector3.new(
        0.354,
        0.55,
        0.612
    ),

    Vector3.new(
        0.354,
        0.55,
        -0.612
    ),

    Vector3.new(
        1,
        0,
        0
    ),

    Vector3.new(
        0.309,
        0,
        0.951
    ),

    Vector3.new(
        -0.809,
        0,
        0.588
    ),

    Vector3.new(
        -0.809,
        0,
        -0.588
    ),

    Vector3.new(
        0.309,
        0,
        -0.951
    ),

    Vector3.new(
        0.354,
        -0.55,
        0.612
    ),

    Vector3.new(
        -0.354,
        -0.55,
        0.612
    ),

    Vector3.new(
        -0.354,
        -0.55,
        -0.612
    ),

    Vector3.new(
        0,
        -1,
        0
    )
}

for i, Point in ipairs(SpherePoints) do
    SpherePoints[i] = Point.Unit
end

--============================================================
-- PROP ROTATIONS
--============================================================

local PropRotations = {}

for i = 1, 15 do

    PropRotations[i] =
        CFrame.Angles(
            math.rad((i * 47) % 360),
            math.rad((i * 83) % 360),
            math.rad((i * 29) % 360)
        )

end

--============================================================
-- REMOTE
--============================================================

local function GetRemote(Prop)

    local Remote =
        Prop:FindFirstChild(
            "SetCurrentCFrame"
        )

    if Remote and
        Remote:IsA("RemoteFunction") then

        return Remote

    end

    Remote =
        Prop:FindFirstChild(
            "SetCurrentCFrame",
            true
        )

    if Remote and
        Remote:IsA("RemoteFunction") then

        return Remote

    end

    return nil

end

--============================================================
-- MOVE PROP
--============================================================

local function MoveProp(
    Prop,
    CFrameValue
)

    local Remote =
        GetRemote(Prop)

    if Remote then

        task.spawn(function()

            pcall(function()

                Remote:InvokeServer(
                    CFrameValue
                )

            end)

        end)

    else

        pcall(function()

            if Prop:IsA("Model") then

                Prop:PivotTo(
                    CFrameValue
                )

            elseif Prop:IsA("BasePart") then

                Prop.CFrame =
                    CFrameValue

            end

        end)

    end

end

--============================================================
-- RAYCAST GROUND
--============================================================

local RaycastParams =
    RaycastParams.new()

RaycastParams.FilterType =
    Enum.RaycastFilterType.Exclude

RaycastParams.IgnoreWater = false

local function UpdateGround()

    if not GlobeCenter then
        return
    end

    local IgnoreList = {
        Character
    }

    for _, Prop in ipairs(Props) do
        table.insert(
            IgnoreList,
            Prop
        )
    end

    RaycastParams.FilterDescendantsInstances =
        IgnoreList

    local RayOrigin =
        GlobeCenter +
        Vector3.new(
            0,
            2,
            0
        )

    local RayDirection =
        Vector3.new(
            0,
            -(GlobeRadius + 8),
            0
        )

    local Result =
        workspace:Raycast(
            RayOrigin,
            RayDirection,
            RaycastParams
        )

    if Result then

        local GroundY =
            Result.Position.Y

        local DesiredY =
            GroundY +
            GlobeRadius +
            GroundOffset

        local Difference =
            GlobeCenter.Y -
            DesiredY

        if Difference <= 0.15 then

            GlobeCenter =
                Vector3.new(
                    GlobeCenter.X,
                    DesiredY,
                    GlobeCenter.Z
                )

            Grounded = true

        else

            Grounded = false

        end

    else

        Grounded = false

    end

end

--============================================================
-- BUILD GLOBE
--============================================================

local function BuildGlobe()

    RefreshProps()

    if #Props == 0 then

        warn(
            "❌ No props found"
        )

        return

    end

    GlobeCenter =
        HRP.Position

    VerticalVelocity = 0
    Grounded = false

    HorizontalVelocity =
        Vector3.zero

    TargetVelocity =
        Vector3.zero

    GlobeRotation =
        CFrame.identity

    -- Initial ground correction
    UpdateGround()

    -- Player doesn't walk with globe
    Humanoid.WalkSpeed = 0
    Humanoid.JumpPower = 0
    Humanoid.AutoRotate = false

    --========================================================
    -- CREATE PERFECT SPHERE
    --========================================================

    for i, Prop in ipairs(Props) do

        local Point =
            SpherePoints[
                ((i - 1) %
                #SpherePoints) + 1
            ]

        local SurfaceDirection =
            GlobeRotation:
            VectorToWorldSpace(
                Point
            )

        local Position =
            GlobeCenter +
            SurfaceDirection *
            GlobeRadius

        local Look =
            CFrame.lookAt(
                Position,
                GlobeCenter
            )

        if PropRotations[i] then

            Look =
                Look *
                PropRotations[i]

        end

        MoveProp(
            Prop,
            Look
        )

        task.wait(0.04)

    end

end

--============================================================
-- MOVEMENT DIRECTION
--============================================================

local function GetMoveDirection()

    local Move =
        Humanoid.MoveDirection

    if Move.Magnitude < 0.01 then

        return Vector3.zero

    end

    -- Camera vectors
    local Forward =
        Camera.CFrame.LookVector

    local Right =
        Camera.CFrame.RightVector

    -- Flatten
    Forward =
        Vector3.new(
            Forward.X,
            0,
            Forward.Z
        )

    Right =
        Vector3.new(
            Right.X,
            0,
            Right.Z
        )

    if Forward.Magnitude > 0 then
        Forward = Forward.Unit
    end

    if Right.Magnitude > 0 then
        Right = Right.Unit
    end

    -- Mobile joystick direction
    local Direction =
        Right * Move.X +
        Forward * Move.Z

    if Direction.Magnitude > 1 then
        Direction =
            Direction.Unit
    end

    return Direction

end

--============================================================
-- PHYSICS
--============================================================

local function UpdatePhysics(dt)

    if not GlobeEnabled then
        return
    end

    if not GlobeCenter then
        return
    end

    --========================================================
    -- MOVEMENT
    --========================================================

    local Direction =
        GetMoveDirection()

    if Direction.Magnitude > 0.01 then

        TargetVelocity =
            Direction *
            GlobeSpeed

    else

        TargetVelocity =
            Vector3.zero

    end

    --========================================================
    -- ACCELERATION
    --========================================================

    local Accel =
        Grounded
        and Acceleration
        or AirAcceleration

    HorizontalVelocity =
        HorizontalVelocity:Lerp(
            TargetVelocity,
            math.clamp(
                dt * Accel,
                0,
                1
            )
        )

    --========================================================
    -- FRICTION
    --========================================================

    if Direction.Magnitude < 0.01 then

        HorizontalVelocity =
            HorizontalVelocity:Lerp(
                Vector3.zero,
                math.clamp(
                    dt * GroundFriction,
                    0,
                    1
                )
            )

    end

    --========================================================
    -- GRAVITY
    --========================================================

    if not Grounded then

        VerticalVelocity =
            VerticalVelocity -
            Gravity * dt

    else

        -- Prevent tiny downward drift
        if VerticalVelocity < 0 then
            VerticalVelocity = 0
        end

    end

    --========================================================
    -- MOVE
    --========================================================

    GlobeCenter +=
        HorizontalVelocity * dt

    GlobeCenter +=
        Vector3.new(
            0,
            VerticalVelocity * dt,
            0
        )

    --========================================================
    -- GROUND
    --========================================================

    UpdateGround()

    --========================================================
    -- ROLL
    --========================================================

    local Horizontal =
        Vector3.new(
            HorizontalVelocity.X,
            0,
            HorizontalVelocity.Z
        )

    if Horizontal.Magnitude > 0.05 then

        local MoveDirection =
            Horizontal.Unit

        local RollAxis =
            Vector3.new(
                -MoveDirection.Z,
                0,
                MoveDirection.X
            )

        local RollAngle =
            (
                Horizontal.Magnitude /
                math.max(
                    GlobeRadius,
                    0.1
                )
            ) * dt

        GlobeRotation =
            CFrame.fromAxisAngle(
                RollAxis,
                RollAngle
            ) *
            GlobeRotation

    end

end

--============================================================
-- UPDATE PROPS
--============================================================

local function UpdateProps()

    if not GlobeEnabled then
        return
    end

    if not GlobeCenter then
        return
    end

    for i, Prop in ipairs(Props) do

        local Point =
            SpherePoints[
                ((i - 1) %
                #SpherePoints) + 1
            ]

        local Direction =
            GlobeRotation:
            VectorToWorldSpace(
                Point
            )

        local Position =
            GlobeCenter +
            Direction *
            GlobeRadius

        local Look =
            CFrame.lookAt(
                Position,
                GlobeCenter
            )

        if PropRotations[i] then

            Look =
                Look *
                PropRotations[i]

        end

        MoveProp(
            Prop,
            Look
        )

    end

end

--============================================================
-- 360 CAMERA
--============================================================

local function UpdateCamera(dt)

    if not GlobeEnabled then
        return
    end

    if not CameraEnabled then
        return
    end

    if not GlobeCenter then
        return
    end

    Camera.CameraType =
        Enum.CameraType.Scriptable

    local Rotation =
        CFrame.Angles(
            0,
            CameraYaw,
            0
        ) *
        CFrame.Angles(
            CameraPitch,
            0,
            0
        )

    local Offset =
        Rotation *
        Vector3.new(
            0,
            CameraHeight,
            CameraDistance
        )

    local Position =
        GlobeCenter +
        Offset

    local Target =
        GlobeCenter

    local Desired =
        CFrame.lookAt(
            Position,
            Target
        )

    Camera.CFrame =
        Camera.CFrame:Lerp(
            Desired,
            math.clamp(
                dt * CameraSmoothness,
                0,
                1
            )
        )

end

--============================================================
-- TOUCH CAMERA
--============================================================

local TouchDragging = false
local LastTouchPosition = nil

UserInputService.TouchStarted:Connect(
    function(Input, Processed)

        if Processed then
            return
        end

        if not CameraEnabled then
            return
        end

        TouchDragging = true

        LastTouchPosition =
            Input.Position

    end
)

UserInputService.TouchMoved:Connect(
    function(Input)

        if not TouchDragging then
            return
        end

        if not CameraEnabled then
            return
        end

        if not LastTouchPosition then

            LastTouchPosition =
                Input.Position

            return

        end

        local Delta =
            Input.Position -
            LastTouchPosition

        LastTouchPosition =
            Input.Position

        CameraYaw -=
            Delta.X *
            CameraSensitivity

        CameraPitch -=
            Delta.Y *
            CameraSensitivity

        CameraPitch =
            math.clamp(
                CameraPitch,
                MinPitch,
                MaxPitch
            )

    end
)

UserInputService.TouchEnded:Connect(
    function()

        TouchDragging = false
        LastTouchPosition = nil

    end
)

--============================================================
-- MOUSE CAMERA
--============================================================

local MouseDragging = false
local LastMousePosition = nil

UserInputService.InputBegan:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton2 then

            MouseDragging = true

            LastMousePosition =
                UserInputService:GetMouseLocation()

        end

    end
)

UserInputService.InputChanged:Connect(
    function(Input)

        if not MouseDragging then
            return
        end

        if Input.UserInputType ~=
            Enum.UserInputType.MouseMovement then

            return

        end

        local Position =
            UserInputService:GetMouseLocation()

        if LastMousePosition then

            local Delta =
                Position -
                LastMousePosition

            CameraYaw -=
                Delta.X *
                CameraSensitivity

            CameraPitch -=
                Delta.Y *
                CameraSensitivity

            CameraPitch =
                math.clamp(
                    CameraPitch,
                    MinPitch,
                    MaxPitch
                )

        end

        LastMousePosition =
            Position

    end
)

UserInputService.InputEnded:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton2 then

            MouseDragging = false

        end

    end
)

--============================================================
-- JUMP
--============================================================

local function JumpGlobe()

    if not GlobeEnabled then
        return
    end

    if not Grounded then
        return
    end

    VerticalVelocity =
        JumpPower

    Grounded = false

end

UserInputService.JumpRequest:Connect(
    function()

        if GlobeEnabled then
            JumpGlobe()
        end

    end
)

--============================================================
-- ENABLE
--============================================================

local function EnableGlobe()

    if GlobeEnabled then
        return
    end

    GlobeEnabled = true

    BuildGlobe()

end

--============================================================
-- DISABLE
--============================================================

local function DisableGlobe()

    GlobeEnabled = false

    HorizontalVelocity =
        Vector3.zero

    TargetVelocity =
        Vector3.zero

    VerticalVelocity = 0

    Humanoid.WalkSpeed = 16
    Humanoid.JumpPower = 50
    Humanoid.AutoRotate = true

    Camera.CameraType =
        Enum.CameraType.Custom

    Camera.CameraSubject =
        Humanoid

end

--============================================================
-- RAYFIELD
--============================================================

local Rayfield

local Success, Result =
    pcall(function()

        return loadstring(
            game:HttpGet(
                "https://sirius.menu/rayfield"
            )
        )()

    end)

if not Success or not Result then

    warn(
        "❌ Rayfield failed to load"
    )

    return

end

Rayfield = Result

