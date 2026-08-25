--[[
╔══════════════════════════════════════════════════════════════╗
║           🔥 ULTIMATE FACE BANG GUI v2.0 🔥                ║
║  Universal FE Troll GUI — Mobile + PC Compatible            ║
║  Drag · Minimize · Face Bang · More                         ║
╚══════════════════════════════════════════════════════════════╝
--]]

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ========== CONFIG ==========
local COLORS = {
    bg = Color3.fromRGB(20, 20, 30),
    titlebar = Color3.fromRGB(35, 35, 50),
    accent = Color3.fromRGB(255, 70, 90),
    accentDark = Color3.fromRGB(200, 50, 70),
    text = Color3.fromRGB(230, 230, 240),
    textDim = Color3.fromRGB(160, 160, 175),
    inputBg = Color3.fromRGB(15, 15, 22),
    btnHover = Color3.fromRGB(255, 90, 110),
    green = Color3.fromRGB(60, 200, 120),
    red = Color3.fromRGB(230, 70, 70),
}

-- ========== GUI BUILDER ==========
local function makeGui()
    local sg = Instance.new("ScreenGui")
    sg.Name = "FaceBangGUI"
    sg.DisplayOrder = 999
    sg.IgnoreGuiInset = true
    sg.ResetOnSpawn = false

    -- Main Frame
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 340, 0, 420)
    main.Position = UDim2.new(0.5, -170, 0.3, 0)
    main.BackgroundColor3 = COLORS.bg
    main.BorderSizePixel = 0
    main.Active = true
    main.Selectable = true
    main.Parent = sg

    -- Drop shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 10, 10)
    shadow.ZIndex = -1
    shadow.Parent = main

    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = main

    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = COLORS.accent
    stroke.Thickness = 1.5
    stroke.Transparency = 0.4
    stroke.Parent = main

    -- ========== TITLE BAR ==========
    local titlebar = Instance.new("Frame")
    titlebar.Name = "TitleBar"
    titlebar.Size = UDim2.new(1, 0, 0, 36)
    titlebar.BackgroundColor3 = COLORS.titlebar
    titlebar.BorderSizePixel = 0
    titlebar.Parent = main
    titlebar.Selectable = true
    titlebar.Active = true

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titlebar

    -- Cover top-left corner rounding
    local topCover = Instance.new("Frame")
    topCover.Size = UDim2.new(1, 0, 0, 8)
    topCover.Position = UDim2.new(0, 0, 0, 28)
    topCover.BackgroundColor3 = COLORS.titlebar
    topCover.BorderSizePixel = 0
    topCover.Parent = titlebar

    -- Title text
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔥 Face Bang GUI"
    title.TextColor3 = COLORS.text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titlebar

    -- Minimize button
    local minBtn = Instance.new("ImageButton")
    minBtn.Name = "MinimizeBtn"
    minBtn.Size = UDim2.new(0, 28, 0, 28)
    minBtn.Position = UDim2.new(1, -34, 0, 4)
    minBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.BackgroundTransparency = 1
    minBtn.Image = "rbxassetid://6031094662"
    minBtn.ImageColor3 = COLORS.textDim
    minBtn.Parent = titlebar

    -- ========== CONTENT AREA ==========
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -16, 1, -44)
    content.Position = UDim2.new(0, 8, 0, 40)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = COLORS.accent
    content.CanvasSize = UDim2.new(0, 0, 0, 400)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Parent = main

    local uiList = Instance.new("UIListLayout")
    uiList.Padding = UDim.new(0, 6)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = content

    -- ========== HELPER: Create Section ==========
    local function createSection(titleText, order)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, 0, 0, 0)
        section.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
        section.BorderSizePixel = 0
        section.AutomaticSize = Enum.AutomaticSize.Y
        section.Parent = content

        local secCorner = Instance.new("UICorner")
        secCorner.CornerRadius = UDim.new(0, 6)
        secCorner.Parent = section

        local secLabel = Instance.new("TextLabel")
        secLabel.Size = UDim2.new(1, -12, 0, 26)
        secLabel.Position = UDim2.new(0, 8, 0, 0)
        secLabel.BackgroundTransparency = 1
        secLabel.Text = titleText
        secLabel.TextColor3 = COLORS.accent
        secLabel.Font = Enum.Font.GothamSemibold
        secLabel.TextSize = 12
        secLabel.TextXAlignment = Enum.TextXAlignment.Left
        secLabel.Parent = section

        local secLine = Instance.new("Frame")
        secLine.Size = UDim2.new(1, -16, 0, 1)
        secLine.Position = UDim2.new(0, 8, 0, 24)
        secLine.BackgroundColor3 = COLORS.accent
        secLine.BackgroundTransparency = 0.7
        secLine.BorderSizePixel = 0
        secLine.Parent = section

        local secContent = Instance.new("Frame")
        secContent.Name = "SectionContent"
        secContent.Size = UDim2.new(1, -12, 0, 0)
        secContent.Position = UDim2.new(0, 6, 0, 30)
        secContent.BackgroundTransparency = 1
        secContent.AutomaticSize = Enum.AutomaticSize.Y
        secContent.Parent = section

        local secList = Instance.new("UIListLayout")
        secList.Padding = UDim.new(0, 5)
        secList.SortOrder = Enum.SortOrder.LayoutOrder
        secList.Parent = secContent

        return section, secContent, secList
    end

    -- ========== HELPER: Create Button ==========
    local function createButton(parent, text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = color or COLORS.accent
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = COLORS.text
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
        btn.AutoButtonColor = false
        btn.Parent = parent

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color and color:Lerp(Color3.fromRGB(255,255,255), 0.15) or COLORS.btnHover}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color or COLORS.accent}):Play()
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- ========== HELPER: Create Input ==========
    local function createInput(parent, placeholder, width)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(width or 1, 0, 0, 34)
        container.BackgroundColor3 = COLORS.inputBg
        container.BorderSizePixel = 0
        container.Parent = parent

        local inpCorner = Instance.new("UICorner")
        inpCorner.CornerRadius = UDim.new(0, 5)
        inpCorner.Parent = container

        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(1, -10, 1, 0)
        inputBox.Position = UDim2.new(0, 5, 0, 0)
        inputBox.BackgroundTransparency = 1
        inputBox.PlaceholderText = placeholder
        inputBox.PlaceholderColor3 = COLORS.textDim
        inputBox.Text = ""
        inputBox.TextColor3 = COLORS.text
        inputBox.Font = Enum.Font.Gotham
        inputBox.TextSize = 13
        inputBox.ClearTextOnFocus = false
        inputBox.Parent = container

        return container, inputBox
    end

    -- ========== HELPER: Create Toggle ==========
    local function createToggle(parent, labelText, default)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 28)
        row.BackgroundTransparency = 1
        row.Parent = parent

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -40, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = COLORS.text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 13
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local toggle = Instance.new("ImageButton")
        toggle.Size = UDim2.new(0, 24, 0, 24)
        toggle.Position = UDim2.new(1, -28, 0.5, -12)
        toggle.BackgroundTransparency = 1
        toggle.Image = "rbxassetid://6035067485"
        toggle.ImageColor3 = default and COLORS.green or COLORS.red
        toggle.Parent = row

        local toggled = default or false
        toggle.MouseButton1Click:Connect(function()
            toggled = not toggled
            toggle.ImageColor3 = toggled and COLORS.green or COLORS.red
        end)

        return toggle, function() return toggled end
    end

    -- ========== SECTION 1: TARGET ==========
    local sec1, sec1Content, sec1List = createSection("🎯 Target Settings")

    local targetInputContainer, targetInput = createInput(sec1Content, "Enter target username...", UDim2.new(0.65, 0))
    targetInputContainer.Size = UDim2.new(1, 0, 0, 34)

    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0.3, -4, 0, 34)
    refreshBtn.Position = UDim2.new(0.7, 4, 0, 0)
    refreshBtn.BackgroundColor3 = COLORS.titlebar
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Text = "🔍 Find"
    refreshBtn.TextColor3 = COLORS.text
    refreshBtn.Font = Enum.Font.GothamSemibold
    refreshBtn.TextSize = 12
    refreshBtn.Parent = targetInputContainer

    local rCorner = Instance.new("UICorner")
    rCorner.CornerRadius = UDim.new(0, 5)
    rCorner.Parent = refreshBtn

    -- ========== SECTION 2: FACE BANG CONTROLS ==========
    local sec2, sec2Content, sec2List = createSection("💥 Face Bang")

    -- Bang type selector
    local typeLabel = Instance.new("TextLabel")
    typeLabel.Size = UDim2.new(1, 0, 0, 20)
    typeLabel.BackgroundTransparency = 1
    typeLabel.Text = "Bang Type:"
    typeLabel.TextColor3 = COLORS.textDim
    typeLabel.Font = Enum.Font.Gotham
    typeLabel.TextSize = 12
    typeLabel.TextXAlignment = Enum.TextXAlignment.Left
    typeLabel.Parent = sec2Content

    local btnRow = Instance.new("Frame")
    btnRow.Size = UDim2.new(1, 0, 0, 30)
    btnRow.BackgroundTransparency = 1
    btnRow.Parent = sec2Content

    local btnRowList = Instance.new("UIListLayout")
    btnRowList.FillDirection = Enum.FillDirection.Horizontal
    btnRowList.Padding = UDim.new(0, 4)
    btnRowList.SortOrder = Enum.SortOrder.LayoutOrder
    btnRowList.Parent = btnRow

    local bangType = "Face"
    local typeBtns = {}

    local function createTypeBtn(name)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 0, 0, 28)
        b.AutomaticSize = Enum.AutomaticSize.X
        b.Padding = UDim.new(0, 12)
        b.BackgroundColor3 = COLORS.titlebar
        b.BorderSizePixel = 0
        b.Text = name
        b.TextColor3 = COLORS.textDim
        b.Font = Enum.Font.GothamSemibold
        b.TextSize = 12
        b.Parent = btnRow

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 4)
        bCorner.Parent = b

        b.MouseButton1Click:Connect(function()
            bangType = name
            for _, tb in pairs(typeBtns) do
                tb.BackgroundColor3 = COLORS.titlebar
                tb.TextColor3 = COLORS.textDim
            end
            b.BackgroundColor3 = COLORS.accent
            b.TextColor3 = COLORS.text
        end)
        return b
    end

    table.insert(typeBtns, createTypeBtn("Face"))
    table.insert(typeBtns, createTypeBtn("Back"))
    table.insert(typeBtns, createTypeBtn("Spawn"))
    typeBtns[1].BackgroundColor3 = COLORS.accent
    typeBtns[1].TextColor3 = COLORS.text

    -- Speed slider label + value
    local speedRow = Instance.new("Frame")
    speedRow.Size = UDim2.new(1, 0, 0, 24)
    speedRow.BackgroundTransparency = 1
    speedRow.Parent = sec2Content

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.5, 0, 1, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: 5"
    speedLabel.TextColor3 = COLORS.text
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 12
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = speedRow

    local speedVal = Instance.new("TextBox")
    speedVal.Size = UDim2.new(0.4, -4, 0, 22)
    speedVal.Position = UDim2.new(0.6, 4, 0, 1)
    speedVal.BackgroundColor3 = COLORS.inputBg
    speedVal.BorderSizePixel = 0
    speedVal.Text = "5"
    speedVal.TextColor3 = COLORS.text
    speedVal.Font = Enum.Font.Gotham
    speedVal.TextSize = 13
    speedVal.ClearTextOnFocus = false
    speedVal.Parent = speedRow

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 4)
    sCorner.Parent = speedVal

    -- Bang / Stop buttons
    local actionRow = Instance.new("Frame")
    actionRow.Size = UDim2.new(1, 0, 0, 34)
    actionRow.BackgroundTransparency = 1
    actionRow.Parent = sec2Content

    local actionList = Instance.new("UIListLayout")
    actionList.FillDirection = Enum.FillDirection.Horizontal
    actionList.Padding = UDim.new(0, 4)
    actionList.SortOrder = Enum.SortOrder.LayoutOrder
    actionList.Parent = actionRow

    local bangBtn = createButton(actionRow, "▶ START BANG", COLORS.green, nil)
    bangBtn.Size = UDim2.new(0.5, -2, 1, 0)

    local stopBtn = createButton(actionRow, "⏹ STOP", COLORS.red, nil)
    stopBtn.Size = UDim2.new(0.5, -2, 1, 0)

    -- ========== SECTION 3: EXTRA FEATURES ==========
    local sec3, sec3Content, sec3List = createSection("⚡ Extra Features")

    local espToggle, getESP = createToggle(sec3Content, "ESP (See players through walls)", false)
    local spinToggle, getSpin = createToggle(sec3Content, "Auto Spin (local)", false)
    local headlessToggle, getHeadless = createToggle(sec3Content, "Headless Mode", false)

    -- ========== SECTION 4: INFO ==========
    local sec4, sec4Content, sec4List = createSection("ℹ️ Status")

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 0, 40)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Ready. Enter a target username and press START."
    statusLabel.TextColor3 = COLORS.textDim
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 12
    statusLabel.TextWrapped = true
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = sec4Content

    -- ========== DRAG FUNCTIONALITY (PC + MOBILE) ==========
    do
        local dragging = false
        local dragStart
        local startPos

        local function updateDrag(input)
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end

        titlebar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        titlebar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or
               input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    updateDrag(input)
                end
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                             input.UserInputType == Enum.UserInputType.Touch) then
                updateDrag(input)
            end
        end)
    end

    -- ========== MINIMIZE TOGGLE ==========
    local minimized = false
    local contentHeight = content.Size.Y.Offset

    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetHeight = minimized and 0 or contentHeight
        local targetContent = minimized and 0 or 1
        TweenService:Create(content, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(1, -16, targetContent, -44), AutomaticSize = Enum.AutomaticSize.None}):Play()
        TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 340, 0, minimized and 36 or 420)}):Play()
        minBtn.ImageColor3 = minimized and COLORS.accent or COLORS.textDim
    end)

    -- ========== CORE LOGIC ==========
    local bangConnection = nil
    local espConnection = nil
    local spinConnection = nil
    local headlessConnection = nil
    local isBanging = false

    local function getTargetCharacter()
        local name = targetInput.Text:gsub("^%s*(.-)%s*$", "%1")
        if name == "" then return nil end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower() == name:lower() or plr.DisplayName:lower() == name:lower() then
                if plr.Character and plr.Character:FindFirstChild("Head") then
                    return plr
                end
            end
        end
        return nil
    end

    local function getHeadCFrame(character)
        if not character then return nil end
        local head = character:FindFirstChild("Head")
        if head then return head.CFrame end
        return nil
    end

    local function getMotor6D(character, name)
        if not character then return nil end
        -- R6 joint
        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if not torso then return nil end
        local joint = torso:FindFirstChild(name)
        if joint and joint:IsA("Motor6D") then return joint end
        -- Check for AnimationConstraint system
        if joint and joint:IsA("AnimationConstraint") then return joint end
        return nil
    end

    local function startBang()
        if isBanging then return end
        local target = getTargetCharacter()
        if not target then
            statusLabel.Text = "❌ Target not found! Check the username."
            return
        end

        local myChar = LocalPlayer.Character
        if not myChar then
            statusLabel.Text = "❌ Your character not loaded."
            return
        end

        local speed = tonumber(speedVal.Text) or 5
        speed = math.clamp(speed, 1, 20)

        isBanging = true
        statusLabel.Text = "💥 BANGING " .. target.DisplayName .. "! (Type: " .. bangType .. ")"

        local time = 0
        bangConnection = RunService.Heartbeat:Connect(function(dt)
            if not isBanging then return end
            if not myChar or not myChar.Parent then
                stopBang()
                return
            end
            if not target.Character or not target.Character:FindFirstChild("Head") then
                stopBang()
                return
            end

            time = time + dt * speed

            -- Get target position based on bang type
            local targetChar = target.Character
            local targetPos
            if bangType == "Face" then
                local th = targetChar:FindFirstChild("Head")
                targetPos = th and th.Position or targetChar.PrimaryPart.Position
            elseif bangType == "Back" then
                local th = targetChar:FindFirstChild("Head")
                if th then
                    targetPos = th.Position - th.CFrame.LookVector * 2
                end
            elseif bangType == "Spawn" then
                local spawns = workspace:FindFirstChild("SpawnLocation")
                if spawns then
                    targetPos = spawns.Position
                else
                    targetPos = Vector3.new(0, 10, 0)
                end
            end

            if not targetPos then return end

            -- Move local player towards target
            local rootPart = myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso")
            if rootPart then
                -- Bobbing motion toward target
                local bobOffset = Vector3.new(
                    math.sin(time * 3) * 1.2,
                    math.abs(math.sin(time * 6)) * 0.6,
                    math.cos(time * 2) * 1.2
                )
                local lookAtTarget = CFrame.lookAt(rootPart.Position, targetPos + bobOffset)
                rootPart.CFrame = lookAtTarget
            end

            -- Neck joint animation (the "bang")
            local neck = getMotor6D(myChar, "Neck")
            if neck and neck:IsA("Motor6D") then
                local angle = math.sin(time * 8) * 0.6
                local angle2 = math.cos(time * 5) * 0.3
                neck.C0 = CFrame.new(0, 1, 0) * CFrame.Angles(angle, angle2, 0)
            elseif neck and neck:IsA("AnimationConstraint") then
                -- For upgraded avatar, we can try setting CFrame of head directly
                local head = myChar:FindFirstChild("Head")
                if head then
                    local offset = CFrame.new(
                        math.sin(time * 8) * 0.5,
                        math.abs(math.sin(time * 6)) * 0.3,
                        math.cos(time * 8) * 0.5
                    )
                    head.CFrame = myChar:FindFirstChild("HumanoidRootPart").CFrame * offset
                end
            end
        end)
    end

    local function stopBang()
        isBanging = false
        if bangConnection then
            bangConnection:Disconnect()
            bangConnection = nil
        end
        -- Reset neck
        local myChar = LocalPlayer.Character
        if myChar then
            local neck = getMotor6D(myChar, "Neck")
            if neck and neck:IsA("Motor6D") then
                neck.C0 = CFrame.new(0, 1, 0) * CFrame.Angles(0, 0, 0)
            end
        end
        statusLabel.Text = "⏹ Stopped. Enter a target to start again."
    end

    -- ========== ESP ==========
    local function toggleESP(enabled)
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        if not enabled then
            -- Remove ESP highlights
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local highlight = plr.Character:FindFirstChildOfClass("Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
            return
        end

        espConnection = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    if not plr.Character:FindFirstChildOfClass("Highlight") then
                        local hl = Instance.new("Highlight")
                        hl.Adornee = plr.Character
                        hl.FillColor = COLORS.accent
                        hl.FillTransparency = 0.5
                        hl.OutlineColor = COLORS.accentDark
                        hl.Parent = plr.Character
                    end
                end
            end
        end)
    end

    -- ========== AUTO SPIN ==========
    local function toggleSpin(enabled)
        if spinConnection then
            spinConnection:Disconnect()
            spinConnection = nil
        end
        if not enabled then return end

        spinConnection = RunService.Heartbeat:Connect(function()
            local myChar = LocalPlayer.Character
            if not myChar then return end
            local root = myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso")
            if root then
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(4), 0)
            end
        end)
    end

    -- ========== HEADLESS ==========
    local function toggleHeadless(enabled)
        if headlessConnection then
            headlessConnection:Disconnect()
            headlessConnection = nil
        end
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local head = myChar:FindFirstChild("Head")
        if head then
            head.Transparency = enabled and 1 or 0
            if enabled then
                -- Make the face accessory transparent too
                for _, child in pairs(head:GetChildren()) do
                    if child:IsA("Accessory") or child:IsA("MeshPart") then
                        child.Transparency = 1
                    end
                end
            else
                for _, child in pairs(head:GetChildren()) do
                    if child:IsA("Accessory") or child:IsA("MeshPart") then
                        child.Transparency = 0
                    end
                end
            end
        end
    end

    -- ========== WIRE BUTTONS ==========
    bangBtn.MouseButton1Click:Connect(startBang)
    stopBtn.MouseButton1Click:Connect(stopBang)

    refreshBtn.MouseButton1Click:Connect(function()
        local t = getTargetCharacter()
        if t then
            statusLabel.Text = "✅ Found: " .. t.DisplayName .. " (" .. t.Name .. ")"
        else
            statusLabel.Text = "❌ User not found in server."
        end
    end)

    -- Toggle watchers
    local espConnToggle = nil
    local spinConnToggle = nil
    local headlessConnToggle = nil

    espToggle.MouseButton1Click:Connect(function()
        wait(0.05)
        toggleESP(getESP())
    end)

    spinToggle.MouseButton1Click:Connect(function()
        wait(0.05)
        toggleSpin(getSpin())
    end)

    headlessToggle.MouseButton1Click:Connect(function()
        wait(0.05)
        toggleHeadless(getHeadless())
    end)

    -- Character added re-applier
    LocalPlayer.CharacterAdded:Connect(function(char)
        if getHeadless() then
            local head = char:WaitForChild("Head", 5)
            if head then
                head.Transparency = 1
                for _, child in pairs(head:GetChildren()) do
                    if child:IsA("Accessory") or child:IsA("MeshPart") then
                        child.Transparency = 1
                    end
                end
            end
        end
        if isBanging then
            stopBang()
        end
        statusLabel.Text = "🔄 Character reset. Re-apply features."
    end)

    return sg
end

-- ========== INJECT GUI ==========
local gui = makeGui()
gui.Parent = (syn and syn.protect_gui and syn.protect_gui(gui)) or (gethui and gethui()) or CoreGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- protect if using Krnl/Synapse/etc
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
    end
end)

-- Notification
local notify = Instance.new("Message")
notify.Text = "🔥 Face Bang GUI Loaded! Drag the titlebar to move. Minimize with [-]."
notify.Parent = game:GetService("CoreGui")

task.delay(4, function()
    pcall(function() notify:Destroy() end)
end)
