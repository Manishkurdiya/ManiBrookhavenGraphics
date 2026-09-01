--[[
    PRAKASH ANTI BANG GUI
    - Modern Design
    - Ultra Compact
    - PC & Mobile Supported
    - Smooth Animations
    - Minimize/Close Features
]]

local GUI = {
    SelectedPlayers = {},
    TargetDistance = 50,
    Smoothness = 0.5,
    isRunning = false,
    isMinimized = false,
    loopConnection = nil
}

-- Create Modern GUI
local function CreateModernGUI()
    local player = game.Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PrakashAntiBangGUI"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame - MODERN & COMPACT
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 320)  -- Ultra compact
    frame.Position = UDim2.new(0.5, -110, 0.5, -160)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = screenGui
    
    -- Modern Shadow Effect
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.3
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Parent = frame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow
    
    -- Main Corner
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = frame
    
    -- Gradient Overlay
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 28, 35)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 33, 42)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 28, 35))
    })
    gradient.Rotation = 45
    gradient.Parent = frame
    
    -- Glow Border
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.Position = UDim2.new(0, 0, 0, 0)
    border.BackgroundTransparency = 1
    border.BorderSizePixel = 2
    border.BorderColor3 = Color3.fromRGB(255, 180, 50)
    border.ZIndex = 999
    border.Parent = frame
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 12)
    borderCorner.Parent = border
    
    -- Title Bar - MODERN
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 32)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    titleFrame.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
    titleFrame.BackgroundTransparency = 0.1
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleFrame
    
    -- Title Text
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.65, 0, 1, 0)
    title.Position = UDim2.new(0.08, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ PRAKASH"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = titleFrame
    
    -- Subtitle
    local subTitle = Instance.new("TextLabel")
    subTitle.Size = UDim2.new(0.5, 0, 0.6, 0)
    subTitle.Position = UDim2.new(0.08, 0, 0.4, 0)
    subTitle.BackgroundTransparency = 1
    subTitle.Text = "ANTI BANG"
    subTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
    subTitle.TextScaled = true
    subTitle.Font = Enum.Font.Gotham
    subTitle.TextTransparency = 0.5
    subTitle.Parent = titleFrame
    
    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 28, 0, 28)
    minBtn.Position = UDim2.new(0.82, 0, 0.06, 0)
    minBtn.BackgroundTransparency = 1
    minBtn.Text = "─"
    minBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    minBtn.TextScaled = true
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = titleFrame
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(0.90, 0, 0.06, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleFrame
    
    -- Content Frame (visible when not minimized)
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -32)
    content.Position = UDim2.new(0, 0, 0, 32)
    content.BackgroundTransparency = 1
    content.Parent = frame
    
    -- Player List - COMPACT
    local playerBox = Instance.new("ScrollingFrame")
    playerBox.Size = UDim2.new(0.92, 0, 0, 120)
    playerBox.Position = UDim2.new(0.04, 0, 0.02, 0)
    playerBox.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
    playerBox.BackgroundTransparency = 0.3
    playerBox.BorderSizePixel = 1
    playerBox.BorderColor3 = Color3.fromRGB(50, 55, 70)
    playerBox.ScrollBarThickness = 3
    playerBox.Parent = content
    
    local playerBoxCorner = Instance.new("UICorner")
    playerBoxCorner.CornerRadius = UDim.new(0, 6)
    playerBoxCorner.Parent = playerBox
    
    local playerList = Instance.new("UIListLayout")
    playerList.Parent = playerBox
    playerList.Padding = UDim.new(0, 2)
    playerList.SortOrder = Enum.SortOrder.Name
    
    -- Distance Input - MODERN
    local distFrame = Instance.new("Frame")
    distFrame.Size = UDim2.new(0.92, 0, 0, 30)
    distFrame.Position = UDim2.new(0.04, 0, 0.42, 0)
    distFrame.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
    distFrame.BackgroundTransparency = 0.3
    distFrame.BorderSizePixel = 1
    distFrame.BorderColor3 = Color3.fromRGB(50, 55, 70)
    distFrame.Parent = content
    
    local distCorner = Instance.new("UICorner")
    distCorner.CornerRadius = UDim.new(0, 6)
    distCorner.Parent = distFrame
    
    local distIcon = Instance.new("TextLabel")
    distIcon.Size = UDim2.new(0.15, 0, 1, 0)
    distIcon.Position = UDim2.new(0.02, 0, 0, 0)
    distIcon.BackgroundTransparency = 1
    distIcon.Text = "📏"
    distIcon.TextScaled = true
    distIcon.Font = Enum.Font.Gotham
    distIcon.Parent = distFrame
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0.35, 0, 1, 0)
    distLabel.Position = UDim2.new(0.18, 0, 0, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "Dist: 50"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = distFrame
    
    local distSlider = Instance.new("TextBox")
    distSlider.Size = UDim2.new(0.3, 0, 0.8, 0)
    distSlider.Position = UDim2.new(0.65, 0, 0.1, 0)
    distSlider.BackgroundColor3 = Color3.fromRGB(40, 44, 55)
    distSlider.Text = "50"
    distSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    distSlider.PlaceholderText = "0"
    distSlider.ClearTextOnFocus = false
    distSlider.TextScaled = true
    distSlider.Font = Enum.Font.Gotham
    distSlider.Parent = distFrame
    
    local distSliderCorner = Instance.new("UICorner")
    distSliderCorner.CornerRadius = UDim.new(0, 4)
    distSliderCorner.Parent = distSlider
    
    -- Buttons - MODERN
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(0.92, 0, 0, 35)
    btnFrame.Position = UDim2.new(0.04, 0, 0.57, 0)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = content
    
    -- Start Button - GLOW EFFECT
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.46, -3, 1, 0)
    toggleBtn.Position = UDim2.new(0, 0, 0, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
    toggleBtn.Text = "▶ START"
    toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = btnFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleBtn
    
    -- Start Button Glow
    local toggleGlow = Instance.new("Frame")
    toggleGlow.Size = UDim2.new(1, 4, 1, 4)
    toggleGlow.Position = UDim2.new(0, -2, 0, -2)
    toggleGlow.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
    toggleGlow.BackgroundTransparency = 0.5
    toggleGlow.BorderSizePixel = 0
    toggleGlow.ZIndex = 0
    toggleGlow.Parent = toggleBtn
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 10)
    glowCorner.Parent = toggleGlow
    
    -- Clear Button
    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0.46, -3, 1, 0)
    clearBtn.Position = UDim2.new(0.54, 0, 0, 0)
    clearBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    clearBtn.Text = "✖ CLEAR"
    clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearBtn.TextScaled = true
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.Parent = btnFrame
    
    local clearCorner = Instance.new("UICorner")
    clearCorner.CornerRadius = UDim.new(0, 8)
    clearCorner.Parent = clearBtn
    
    -- Refresh Button - MODERN
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0.92, 0, 0, 28)
    refreshBtn.Position = UDim2.new(0.04, 0, 0.72, 0)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(60, 70, 180)
    refreshBtn.Text = "🔄 REFRESH"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.TextScaled = true
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = content
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 8)
    refreshCorner.Parent = refreshBtn
    
    -- Status Bar - MODERN
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(0.92, 0, 0, 24)
    statusFrame.Position = UDim2.new(0.04, 0, 0.84, 0)
    statusFrame.BackgroundColor3 = Color3.fromRGB(30, 33, 42)
    statusFrame.BackgroundTransparency = 0.3
    statusFrame.BorderSizePixel = 1
    statusFrame.BorderColor3 = Color3.fromRGB(50, 55, 70)
    statusFrame.Parent = content
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.7, 0, 1, 0)
    statusLabel.Position = UDim2.new(0.03, 0, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "✅ Ready"
    statusLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = statusFrame
    
    local countLabel = Instance.new("TextLabel")
    countLabel.Size = UDim2.new(0.3, 0, 1, 0)
    countLabel.Position = UDim2.new(0.7, 0, 0, 0)
    countLabel.BackgroundTransparency = 1
    countLabel.Text = "👤 0"
    countLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    countLabel.TextScaled = true
    countLabel.Font = Enum.Font.Gotham
    countLabel.Parent = statusFrame
    
    -- Title Bar Dragging
    local dragging = false
    local dragStart, startPos
    
    titleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    titleFrame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    titleFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return {
        GUI = screenGui,
        Frame = frame,
        Content = content,
        PlayerList = playerBox,
        PlayerListLayout = playerList,
        DistLabel = distLabel,
        DistSlider = distSlider,
        ToggleBtn = toggleBtn,
        ClearBtn = clearBtn,
        RefreshBtn = refreshBtn,
        StatusLabel = statusLabel,
        CountLabel = countLabel,
        MinBtn = minBtn,
        CloseBtn = closeBtn,
        TitleFrame = titleFrame,
        ToggleGlow = toggleGlow
    }
end

-- Update player list
local function UpdatePlayerList(gui, selectedPlayers)
    for _, child in ipairs(gui.PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local players = {}
    local localPlayer = game.Players.LocalPlayer
    
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(players, player)
        end
    end
    
    table.sort(players, function(a, b) return a.Name < b.Name end)
    
    for _, player in ipairs(players) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 22)
        btn.BackgroundColor3 = selectedPlayers[player] and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(40, 44, 55)
        btn.Text = selectedPlayers[player] and "✅ " .. player.Name or "⬜ " .. player.Name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextScaled = true
        btn.Font = Enum.Font.Gotham
        btn.BackgroundTransparency = 0.1
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(50, 55, 70)
        btn.Parent = gui.PlayerList
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if selectedPlayers[player] then
                selectedPlayers[player] = nil
                btn.BackgroundColor3 = Color3.fromRGB(40, 44, 55)
                btn.Text = "⬜ " .. player.Name
            else
                selectedPlayers[player] = true
                btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
                btn.Text = "✅ " .. player.Name
            end
            
            local count = 0
            for _ in pairs(selectedPlayers) do count = count + 1 end
            gui.CountLabel.Text = "👤 " .. count
            gui.StatusLabel.Text = count > 0 and "✅ " .. count .. " selected" or "✅ Ready"
        end)
    end
    
    local count = 0
    for _ in pairs(selectedPlayers) do count = count + 1 end
    gui.CountLabel.Text = "👤 " .. count
    gui.StatusLabel.Text = count > 0 and "✅ " .. count .. " selected" or "✅ Ready"
end

-- Track distance function
local function TrackDistance(selectedPlayers, targetDistance, smoothness)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local activePlayers = {}
    for playerObj, _ in pairs(selectedPlayers) do
        if playerObj and playerObj.Character then
            local rootPart = playerObj.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                table.insert(activePlayers, rootPart)
            end
        end
    end
    
    if #activePlayers == 0 then return end
    
    local avgPos = Vector3.new(0, 0, 0)
    for _, rootPart in ipairs(activePlayers) do
        avgPos = avgPos + rootPart.Position
    end
    avgPos = avgPos / #activePlayers
    
    local currentPos = humanoidRootPart.Position
    local direction = (avgPos - currentPos).Unit
    local currentDistance = (avgPos - currentPos).Magnitude
    
    if currentDistance > targetDistance + 3 or currentDistance < targetDistance - 3 then
        local targetPos = avgPos - direction * targetDistance
        targetPos = Vector3.new(targetPos.X, humanoidRootPart.Position.Y, targetPos.Z)
        local newPos = currentPos:Lerp(targetPos, smoothness)
        humanoidRootPart.CFrame = CFrame.new(newPos, avgPos)
    end
end

-- Main execution
local function Main()
    local selectedPlayers = {}
    local isRunning = false
    local loopConnection = nil
    local isMinimized = false
    
    local gui = CreateModernGUI()
    
    -- Minimize button
    gui.MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            gui.Content.Visible = false
            gui.Frame.Size = UDim2.new(0, 220, 0, 32)
            gui.MinBtn.Text = "□"
            gui.StatusLabel.Text = "⏸ Minimized"
        else
            gui.Content.Visible = true
            gui.Frame.Size = UDim2.new(0, 220, 0, 320)
            gui.MinBtn.Text = "─"
            local count = 0
            for _ in pairs(selectedPlayers) do count = count + 1 end
            gui.StatusLabel.Text = count > 0 and "✅ " .. count .. " selected" or "✅ Ready"
        end
    end)
    
    -- Close button
    gui.CloseBtn.MouseButton1Click:Connect(function()
        if loopConnection then
            loopConnection:Disconnect()
            loopConnection = nil
        end
        gui.GUI:Destroy()
    end)
    
    -- Distance slider
    gui.DistSlider.FocusLost:Connect(function()
        local num = tonumber(gui.DistSlider.Text)
        if num and num > 0 and num < 1000 then
            GUI.TargetDistance = num
            gui.DistLabel.Text = "Dist: " .. num
        else
            gui.DistSlider.Text = tostring(GUI.TargetDistance)
        end
    end)
    
    -- Toggle button
    gui.ToggleBtn.MouseButton1Click:Connect(function()
        local playerCount = 0
        for _ in pairs(selectedPlayers) do
            playerCount = playerCount + 1
        end
        
        if playerCount == 0 then
            gui.StatusLabel.Text = "❌ Select player!"
            gui.StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end
        
        isRunning = not isRunning
        
        if isRunning then
            gui.ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            gui.ToggleBtn.Text = "⏹ STOP"
            gui.ToggleGlow.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            gui.StatusLabel.Text = "🟢 Tracking " .. playerCount
            gui.StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            loopConnection = game:GetService("RunService").Heartbeat:Connect(function()
                TrackDistance(selectedPlayers, GUI.TargetDistance, GUI.Smoothness)
            end)
        else
            gui.ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
            gui.ToggleBtn.Text = "▶ START"
            gui.ToggleGlow.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
            gui.StatusLabel.Text = "⏹ Stopped"
            gui.StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            
            if loopConnection then
                loopConnection:Disconnect()
                loopConnection = nil
            end
        end
    end)
    
    -- Clear button
    gui.ClearBtn.MouseButton1Click:Connect(function()
        for player, _ in pairs(selectedPlayers) do
            selectedPlayers[player] = nil
        end
        UpdatePlayerList(gui, selectedPlayers)
        gui.StatusLabel.Text = "✅ Cleared"
        gui.StatusLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
        
        if isRunning then
            isRunning = false
            gui.ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
             gui.ToggleBtn.Text = "▶ START"
             gui.ToggleGlow.BackgroundColor3 = Color3.fromRGB(0, 220, 100)
            if loopConnection then
                loopConnection:Disconnect()
                loopConnection = nil
            end
        end
    end)
    
    -- Refresh button
    gui.RefreshBtn.MouseButton1Click:Connect(function()
        UpdatePlayerList(gui, selectedPlayers)
        gui.StatusLabel.Text = "🔄 Refreshed!"
        gui.StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    end)
    
    -- Initial population
    UpdatePlayerList(gui, selectedPlayers)
    
    -- Auto-refresh
    game.Players.PlayerAdded:Connect(function()
        UpdatePlayerList(gui, selectedPlayers)
    end)
    
    game.Players.PlayerRemoving:Connect(function(player)
        if selectedPlayers[player] then
            selectedPlayers[player] = nil
            UpdatePlayerList(gui, selectedPlayers)
        end
    end)
end

-- Execute
pcall(Main)
        
