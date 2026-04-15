-- ==========================================
-- 🔎 BSS REVERSE STRING HUNTER
-- ==========================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_String_Hunter"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 480, 0, 500)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.Text = " 🔎 Hunting for 'Mark Duration'..."
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
layout.Padding = UDim.new(0, 4)

local function printLine(text, color)
    local lbl = Instance.new("TextLabel", scroll)
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.Text = " " .. tostring(text)
end

local foundCount = 0

-- Recursively scans looking for the target string
local function searchForString(tbl, path, depth, moduleName)
    if depth > 5 then return end 
    
    for k, v in pairs(tbl) do
        -- Check if the value is a string and contains "mark" and "duration"
        if type(v) == "string" then
            local valLower = string.lower(v)
            if string.find(valLower, "mark") and string.find(valLower, "duration") then
                foundCount = foundCount + 1
                printLine("==================================", Color3.fromRGB(100, 100, 255))
                printLine("🎯 STRING FOUND IN: " .. moduleName, Color3.fromRGB(50, 255, 50))
                printLine("Path: " .. path, Color3.fromRGB(150, 150, 150))
                
                -- Print out the exact key and value so we can see the ID!
                local keyStr = tostring(k)
                if type(k) == "number" then keyStr = "[" .. keyStr .. "]" end
                if type(k) == "string" then keyStr = '["' .. keyStr .. '"]' end
                
                printLine("  " .. keyStr .. ' = "' .. tostring(v) .. '"', Color3.fromRGB(255, 200, 100))
            end
        end
        
        -- Dive deeper into nested tables
        if type(v) == "table" then
            searchForString(v, path .. "." .. tostring(k), depth + 1, moduleName)
        end
    end
end

task.spawn(function()
    printLine("Initializing Reverse Search...", Color3.fromRGB(100, 255, 100))
    printLine("Targeting phrases like 'Mark Duration'", Color3.fromRGB(150, 150, 150))
    
    local allModules = ReplicatedStorage:GetChildren()
    local scanned = 0
    
    for _, obj in ipairs(allModules) do
        if obj:IsA("ModuleScript") then
            scanned = scanned + 1
            local success, data = pcall(require, obj)
            
            if success and type(data) == "table" then
                searchForString(data, obj.Name, 1, obj.Name)
            end
        end
    end
    
    printLine("--------------------------------", Color3.fromRGB(100, 100, 100))
    if foundCount == 0 then
        printLine("Scan complete. 0 matches found.", Color3.fromRGB(255, 50, 50))
    else
        printLine("Scan complete! Found " .. foundCount .. " matches.", Color3.fromRGB(100, 255, 100))
    end
end)
