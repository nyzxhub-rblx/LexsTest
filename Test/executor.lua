local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

pcall(function()
    CoreGui.MyExecutorGUI:Destroy()
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyExecutorGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- MAIN
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,450,0,300)
Main.Position = UDim2.new(0.5,-225,0.5,-150)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Instance.new("UICorner", Main)

-- TOPBAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,35)
TopBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
Instance.new("UICorner", TopBar)

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-80,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "Lexs Executor"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- MIN BUTTON
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-35,0,2)
MinBtn.Text = "-"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn)

-- EDITOR HOLDER (ANTI NEMBUS)
local EditorHolder = Instance.new("Frame")
EditorHolder.Size = UDim2.new(1,-20,0,190)
EditorHolder.Position = UDim2.new(0,10,0,50)
EditorHolder.BackgroundColor3 = Color3.fromRGB(35,35,35)
EditorHolder.BorderSizePixel = 0
EditorHolder.ClipsDescendants = true -- FIX UTAMA
EditorHolder.Parent = Main
Instance.new("UICorner", EditorHolder)

-- SCROLL FRAME
local EditorFrame = Instance.new("ScrollingFrame")
EditorFrame.Size = UDim2.new(1,0,1,0)
EditorFrame.CanvasSize = UDim2.new(0,0,0,190)
EditorFrame.ScrollBarThickness = 4
EditorFrame.BackgroundTransparency = 1
EditorFrame.BorderSizePixel = 0
EditorFrame.Parent = EditorHolder

-- TEXTBOX
local ScriptBox = Instance.new("TextBox")
ScriptBox.Size = UDim2.new(1,-10,0,190)
ScriptBox.Position = UDim2.new(0,5,0,5)
ScriptBox.BackgroundTransparency = 1
ScriptBox.MultiLine = true
ScriptBox.ClearTextOnFocus = false
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.TextWrapped = false
ScriptBox.Text = "    "
ScriptBox.PlaceholderText = "    -- paste script here"
ScriptBox.Font = Enum.Font.Code
ScriptBox.TextSize = 14
ScriptBox.TextColor3 = Color3.new(1,1,1)
ScriptBox.Parent = EditorFrame

-- AUTO RESIZE
local function UpdateCanvas()
    local Height = math.max(190, ScriptBox.TextBounds.Y + 30)

    ScriptBox.Size = UDim2.new(1,-10,0,Height)
    EditorFrame.CanvasSize = UDim2.new(0,0,0,Height)
end

ScriptBox:GetPropertyChangedSignal("Text"):Connect(UpdateCanvas)

-- EXECUTE
local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(0.48,0,0,40)
ExecuteBtn.Position = UDim2.new(0.02,0,1,-50)
ExecuteBtn.Text = "EXECUTE"
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 16
ExecuteBtn.TextColor3 = Color3.new(1,1,1)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
ExecuteBtn.Parent = Main
Instance.new("UICorner", ExecuteBtn)

-- CLEAR
local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.48,0,0,40)
ClearBtn.Position = UDim2.new(0.50,0,1,-50)
ClearBtn.Text = "CLEAR ALL"
ClearBtn.Font = Enum.Font.GothamBold
ClearBtn.TextSize = 16
ClearBtn.TextColor3 = Color3.new(1,1,1)
ClearBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
ClearBtn.Parent = Main
Instance.new("UICorner", ClearBtn)

-- FLOAT ICON
local OpenIcon = Instance.new("TextButton")
OpenIcon.Size = UDim2.new(0,50,0,50)
OpenIcon.Position = UDim2.new(0,20,0.5,-25)
OpenIcon.Text = "L"
OpenIcon.Font = Enum.Font.GothamBlack
OpenIcon.TextSize = 24
OpenIcon.TextColor3 = Color3.new(1,1,1)
OpenIcon.BackgroundColor3 = Color3.fromRGB(0,170,255)
OpenIcon.Visible = false
OpenIcon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1,0)
IconCorner.Parent = OpenIcon

-- EXECUTE LOGIC
ExecuteBtn.MouseButton1Click:Connect(function()
    local source = ScriptBox.Text

    if source:gsub("%s","") ~= "" then
        local func, err = loadstring(source)

        if func then
            task.spawn(func)
        else
            warn(err)
        end
    end
end)

-- CLEAR LOGIC
ClearBtn.MouseButton1Click:Connect(function()
    ScriptBox.Text = "    "
    UpdateCanvas()
end)

-- MINIMIZE
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenIcon.Visible = true
end)

OpenIcon.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenIcon.Visible = false
end)

-- DRAG
local function MakeDraggable(frame, handle)
    local dragging = false
    local dragStart
    local startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart

            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

MakeDraggable(Main, TopBar)
MakeDraggable(OpenIcon, OpenIcon)

UpdateCanvas()
