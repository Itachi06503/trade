-- ==========================================
-- 🤿 BSS RECURSIVE DEEP-DIVER
-- ==========================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Deep_Diver"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 420, 0, 500)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.Text = " 🤿 Recursive Table Scavenger"
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

-- The IDs we are hunting
local targetIDs = {11 = true, 12 = true, 13 = true, 16 = true}

-- Recursive search function
local function recursiveSearch(tbl, path, depth)
    if depth > 5 then return end -- Prevent infinite loops
    
    for k, v in pairs(tbl) do
        local currentPath = path .. "." .. tostring(k)
        
        -- If the key matches one of our target IDs!
        if type(k) == "number" and targetIDs[k] then
            printLine("========================", Color3.fromRGB(100, 100, 255))
            printLine("🎯 FOUND ID ["..tostring(k).."] AT:", Color3.fromRGB(50, 255, 50))
            printLine(currentPath, Color3.fromRGB(150, 150, 150))
            
            if type(v) == "table" then
                for subK, subV in pairs(v) do
                    local displayVal = tostring(subV)
                    if type(subV) == "table" then displayVal = "{...}" end
                    printLine("  " .. tostring(subK) .. " = " .. displayVal, Color3.fromRGB(255, 200, 100))
                end
            else
                printLine("  Value = " .. tostring(v), Color3.fromRGB(255, 200, 100))
            end
        end
        
        -- If the value is a table, dive deeper into it
        if type(v) == "table" then
            recursiveSearch(v, currentPath, depth + 1)
        end
    end
end

task.spawn(function()
    printLine("Initiating Recursive Dive...", Color3.fromRGB(100, 255, 100))
    printLine("Targeting: WaxTypes & StatTypes", Color3.fromRGB(150, 150, 150))
    
    local modulesToCheck = {"WaxTypes", "StatTypes"}
    
    for _, modName in ipairs(modulesToCheck) do
        local modScript = ReplicatedStorage:FindFirstChild(modName)
        if modScript and modScript:IsA("ModuleScript") then
            local success, data = pcall(require, modScript)
            if success and type(data) == "table" then
                recursiveSearch(data, modName, 1)
            end
        end
    end
    printLine("--------------------------------", Color3.fromRGB(100, 100, 100))
    printLine("Dive Complete!", Color3.fromRGB(100, 255, 100))
end)
