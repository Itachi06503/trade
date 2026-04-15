-- ==========================================
-- 🗄️ BSS MASTER TABLE DUMPER
-- ==========================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Table_Dumper"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 500, 0, 550)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.Text = " 🗄️ Dumping Raw Module Data..."
header.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 35, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 40)
scroll.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 6
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", scroll)

local function printLine(text, color)
    local lbl = Instance.new("TextLabel", scroll)
    lbl.Size = UDim2.new(1, -10, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(200, 255, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.Text = " " .. tostring(text)
end

-- Dumps a table out visually
local function dumpTable(tbl, indent, depth)
    if depth > 4 then 
        printLine(indent .. "{ Max Depth Reached }", Color3.fromRGB(150, 150, 150))
        return 
    end
    
    for k, v in pairs(tbl) do
        -- Formatting keys based on type
        local keyStr = tostring(k)
        if type(k) == "string" then keyStr = '["' .. keyStr .. '"]' end
        if type(k) == "number" then keyStr = "[" .. keyStr .. "]" end

        if type(v) == "table" then
            printLine(indent .. keyStr .. " = {", Color3.fromRGB(255, 200, 100))
            dumpTable(v, indent .. "    ", depth + 1)
            printLine(indent .. "}", Color3.fromRGB(255, 200, 100))
        elseif type(v) == "string" then
            printLine(indent .. keyStr .. ' = "' .. v .. '"', Color3.fromRGB(150, 255, 150))
        else
            printLine(indent .. keyStr .. " = " .. tostring(v), Color3.fromRGB(200, 200, 255))
        end
    end
end

task.spawn(function()
    printLine("Extracting WaxTypes...", Color3.fromRGB(100, 255, 100))
    local modScript = ReplicatedStorage:FindFirstChild("WaxTypes")
    
    if modScript and modScript:IsA("ModuleScript") then
        local success, data = pcall(require, modScript)
        if success and type(data) == "table" then
            printLine("==================================", Color3.fromRGB(100, 100, 255))
            dumpTable(data, "", 1)
            printLine("==================================", Color3.fromRGB(100, 100, 255))
        else
            printLine("Failed to require WaxTypes module.", Color3.fromRGB(255, 50, 50))
        end
    end
end)
