local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIGradient = Instance.new("UIGradient")
local UIStroke = Instance.new("UIStroke")
local TitleLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local ToggleCorner = Instance.new("UICorner")
local ToggleGradient = Instance.new("UIGradient")
local StatusLabel = Instance.new("TextLabel")
local FilterFrame = Instance.new("Frame")
local Filter15MButton = Instance.new("TextButton")
local Filter15MCorner = Instance.new("UICorner")
local Filter20MButton = Instance.new("TextButton")
local Filter20MCorner = Instance.new("UICorner")
local Filter50MButton = Instance.new("TextButton")
local Filter50MCorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0, 20, 0, 200)
MainFrame.BorderSizePixel = 0

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))
}
UIGradient.Parent = MainFrame

UIStroke.Color = Color3.fromRGB(50, 50, 50)
UIStroke.Transparency = 0.5
UIStroke.Thickness = 1
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 10)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Text = "Neon Hub"

ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Size = UDim2.new(0.9, 0, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Text = "Auto-Joiner OFF"
ToggleButton.BorderSizePixel = 0

ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

ToggleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
}
ToggleGradient.Parent = ToggleButton

StatusLabel.Parent = MainFrame
StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.Text = "Status: Idle"

FilterFrame.Parent = MainFrame
FilterFrame.BackgroundTransparency = 1
FilterFrame.Size = UDim2.new(0.9, 0, 0, 50)
FilterFrame.Position = UDim2.new(0.05, 0, 0.5, 0)

Filter15MButton.Parent = FilterFrame
Filter15MButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Filter15MButton.Size = UDim2.new(0.3, 0, 1, 0)
Filter15MButton.Position = UDim2.new(0, 0, 0, 0)
Filter15MButton.Font = Enum.Font.Gotham
Filter15MButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Filter15MButton.TextSize = 14
Filter15MButton.Text = "15M"
Filter15MButton.BorderSizePixel = 0

Filter15MCorner.CornerRadius = UDim.new(0, 6)
Filter15MCorner.Parent = Filter15MButton

Filter20MButton.Parent = FilterFrame
Filter20MButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Filter20MButton.Size = UDim2.new(0.3, 0, 1, 0)
Filter20MButton.Position = UDim2.new(0.35, 0, 0, 0)
Filter20MButton.Font = Enum.Font.Gotham
Filter20MButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Filter20MButton.TextSize = 14
Filter20MButton.Text = "20M"
Filter20MButton.BorderSizePixel = 0

Filter20MCorner.CornerRadius = UDim.new(0, 6)
Filter20MCorner.Parent = Filter20MButton

Filter50MButton.Parent = FilterFrame
Filter50MButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Filter50MButton.Size = UDim2.new(0.3, 0, 1, 0)
Filter50MButton.Position = UDim2.new(0.7, 0, 0, 0)
Filter50MButton.Font = Enum.Font.Gotham
Filter50MButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Filter50MButton.TextSize = 14
Filter50MButton.Text = "50M"
Filter50MButton.BorderSizePixel = 0

Filter50MCorner.CornerRadius = UDim.new(0, 6)
Filter50MCorner.Parent = Filter50MButton

local autoJoinEnabled = false
local currentMinValue = 15000000 -- Default to 15M
local HttpService = game:GetService('HttpService')
local TeleportService = game:GetService('TeleportService')
local Players = game:GetService('Players')
local placeId = game.PlaceId
local selfHostHttpUrl = 'http://localhost:1488/jobs'
local retryDelay = 0.01 -- Délai minimal très réduit
local pollInterval = 0.2 -- Polling réduit mais contrôlé
local player = Players.LocalPlayer
local jobQueue = {}
local attemptedJobs = {} -- Tracker des jobs tentés

local function animateButton(button, isOn)
    local goal = {}
    if isOn then
        goal.BackgroundColor3 = Color3.fromRGB(0, 0, 139)
        ToggleGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 139)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 70))
        }
    else
        goal.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ToggleGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
        }
    end
    goal.Size = UDim2.new(0.92, 0, 0, 52)
    local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
    tween:Play()
    tween.Completed:Wait()
    local resetGoal = {Size = UDim2.new(0.9, 0, 0, 50)}
    TweenService:Create(button, TweenInfo.new(0.1), resetGoal):Play()
end

local function animateFilterButton(button)
    local goal = {BackgroundColor3 = Color3.fromRGB(0, 100, 200), Size = UDim2.new(0.32, 0, 1, 0)}
    local tween = TweenService:Create(button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
    tween:Play()
    tween.Completed:Wait()
    local resetGoal = {Size = UDim2.new(0.3, 0, 1, 0)}
    TweenService:Create(button, TweenInfo.new(0.1), resetGoal):Play()
end

local function resetFilterButtons()
    Filter15MButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Filter20MButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Filter50MButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end

local function getMoneyValue(moneyStr)
    local num = tonumber(moneyStr:match('(%d+%.?%d*)')) or 0
    local unit = moneyStr:match('[KMB]') or ''
    local multipliers = { K = 1000, M = 1000000, B = 1000000000 }
    return num * (multipliers[unit] or 1)
end

local function sortJobsByMoney()
    table.sort(jobQueue, function(a, b)
        return getMoneyValue(a.money) > getMoneyValue(b.money)
    end)
end

local function filterJobsByMinValue(jobs)
    local filteredJobs = {}
    for _, job in ipairs(jobs) do
        local moneyValue = getMoneyValue(job.money)
        if moneyValue >= currentMinValue and not attemptedJobs[job.jobid] then
            table.insert(filteredJobs, job)
        end
    end
    return filteredJobs
end

local function findTargetGui()
    for _, gui in ipairs(game:GetService('CoreGui'):GetDescendants()) do
        if gui:IsA('ScreenGui') and gui.Name == 'Orion' then
            return gui
        end
    end
    return nil
end

local function setJobIDText(targetGui, text)
    for _, descendant in ipairs(targetGui:GetDescendants()) do
        if descendant:IsA('TextLabel') and descendant.Text == 'Job-ID Input' then
            local parentFrame = descendant.Parent
            if not parentFrame:IsA('Frame') then continue end
            for _, frameChild in ipairs(parentFrame:GetChildren()) do
                if frameChild:IsA('Frame') then
                    local textBox = frameChild:FindFirstChildOfClass('TextBox')
                    if textBox then
                        textBox.Text = text
                        textBox:CaptureFocus()
                        textBox:ReleaseFocus()
                        return textBox
                    end
                end
            end
        end
    end
    return nil
end

local function clickJoinButton(targetGui)
    for _, descendant in ipairs(targetGui:GetDescendants()) do
        if descendant:IsA('TextLabel') and descendant.Text == 'Join Job-ID' then
            local parentFrame = descendant.Parent
            return parentFrame:FindFirstChildOfClass('TextButton')
        end
    end
    return nil
end

local function bypass10M(job)
    local targetGui = findTargetGui()
    if not targetGui then
        StatusLabel.Text = 'Status: Orion GUI not found'
        return false
    end
    local textBox = setJobIDText(targetGui, job.jobid)
    if not textBox then
        StatusLabel.Text = 'Status: Job-ID TextBox not found'
        return false
    end
    local button = clickJoinButton(targetGui)
    if not button then
        StatusLabel.Text = 'Status: Join button not found'
        return false
    end
    local upConnections = getconnections(button.MouseButton1Up)
    for _, conn in ipairs(upConnections) do
        conn:Fire()
    end
    StatusLabel.Text = 'Status: Bypassing with Job-ID ' .. job.jobid
    return true
end

local function tryJoinNext()
    if not autoJoinEnabled or #jobQueue == 0 then
        StatusLabel.Text = 'Status: Idle or no jobs'
        return
    end
    sortJobsByMoney()
    local job = jobQueue[1]
    attemptedJobs[job.jobid] = true
    StatusLabel.Text = 'Status: Joining ' .. job.jobid .. ' | Money=' .. job.money
    print('Tentative de join : ' .. job.jobid .. ' | Money=' .. job.money)

    if bypass10M(job) then
        table.remove(jobQueue, 1)
    else
        local success, err = pcall(function()
            TeleportService:TeleportToPlaceInstance(placeId, job.jobid, player)
        end)
        if not success then
            StatusLabel.Text = 'Status: Teleport failed - ' .. tostring(err)
            warn('Échec teleport : ' .. tostring(err))
            table.remove(jobQueue, 1)
        end
    end
end

TeleportService.TeleportInitFailed:Connect(function(plr, result, msg)
    if plr ~= player or not autoJoinEnabled then return end
    StatusLabel.Text = 'Status: Teleport failed - ' .. msg
    warn('Teleport échoué : ' .. tostring(result) .. ' - ' .. msg)
    if #jobQueue > 0 then
        table.remove(jobQueue, 1)
    end
end)

local function fetchJobs()
    if not autoJoinEnabled then return end
    StatusLabel.Text = 'Status: Fetching jobs...'
    if #jobQueue == 0 then print('Fetch depuis : ' .. selfHostHttpUrl) end
    local response, success
    local httpRetries = 0
    local maxHttpRetries = 3

    local methods = {
        function()
            if http and http.request then
                local req = http.request({ Url = selfHostHttpUrl, Method = 'GET' })
                if req and req.StatusCode == 200 then
                    return true, req.Body
                end
            end
        end,
        function()
            if syn and syn.request then
                local req = syn.request({ Url = selfHostHttpUrl, Method = 'GET' })
                if req and req.StatusCode == 200 then
                    return true, req.Body
                end
            end
        end,
        function()
            if game and game.HttpGet then
                local ok, res = pcall(function()
                    return game:HttpGet(selfHostHttpUrl)
                end)
                if ok and res then
                    return true, res
                end
            end
        end,
    }

    while httpRetries < maxHttpRetries do
        for _, method in ipairs(methods) do
            local ok, res = method()
            if ok then
                success, response = ok, res
                break
            end
        end
        if success then break end
        httpRetries = httpRetries + 1
        task.wait(retryDelay)
    end

    if not success then
        StatusLabel.Text = 'Status: Failed to connect to server'
        task.wait(0.5)
        return
    end

    local decoded = HttpService:JSONDecode(response)
    if typeof(decoded) == 'table' then
        jobQueue = filterJobsByMinValue(decoded)
        if #jobQueue > 0 then
            tryJoinNext()
        else
            StatusLabel.Text = 'Status: No jobs available above ' .. (currentMinValue / 1000000) .. 'M'
            task.wait(0.5)
        end
    else
        StatusLabel.Text = 'Status: Invalid job data'
        task.wait(0.5)
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    autoJoinEnabled = not autoJoinEnabled
    if autoJoinEnabled then
        ToggleButton.Text = 'Auto-Joiner ON'
        StatusLabel.Text = 'Status: Fetching jobs...'
        animateButton(ToggleButton, true)
        fetchJobs()
    else
        ToggleButton.Text = 'Auto-Joiner OFF'
        StatusLabel.Text = 'Status: Idle'
        animateButton(ToggleButton, false)
    end
end)

Filter15MButton.MouseButton1Click:Connect(function()
    resetFilterButtons()
    currentMinValue = 15000000
    animateFilterButton(Filter15MButton)
    Filter15MButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    if autoJoinEnabled then fetchJobs() end
end)

Filter20MButton.MouseButton1Click:Connect(function()
    resetFilterButtons()
    currentMinValue = 20000000
    animateFilterButton(Filter20MButton)
    Filter20MButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    if autoJoinEnabled then fetchJobs() end
end)

Filter50MButton.MouseButton1Click:Connect(function()
    resetFilterButtons()
    currentMinValue = 50000000
    animateFilterButton(Filter50MButton)
    Filter50MButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    if autoJoinEnabled then fetchJobs() end
end)

task.spawn(function()
    while true do
        if autoJoinEnabled then
            fetchJobs()
        end
        task.wait(pollInterval)
    end
end)