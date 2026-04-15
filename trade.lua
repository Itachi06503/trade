-- ==========================================
-- 🎯 BSS ULTIMATE STAT SNIPER (Zero Spam)
-- ==========================================
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Ultimate_Sniper"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 320, 0, 300)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.Text = " 🎯 Ultimate Stat Sniper"
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
scroll.ScrollBarThickness = 4
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)

local function printLine(text, color)
    local lbl = Instance.new("TextLabel", scroll)
    lbl.Size = UDim2.new(1, -10, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(200, 255, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 14
    lbl.Text = " " .. tostring(text)
end

local function extractName(val)
    if type(val) == "string" then return val end
    if type(val) == "table" then
        return val.Name or val.Stat or val.Type or val.id or tostring(val)
    end
    return tostring(val)
end

task.spawn(function()
    printLine("Hunting for true stat table...", Color3.fromRGB(150, 150, 150))
    local memoryDump = getgc(true)
    local found = false
    
    for _, obj in ipairs(memoryDump) do
        if type(obj) == "table" then
            local hasPollen = false
            local hasConvert = false
            
            -- Scan every value in this table to see if it's the Master Stat Table
            for _, v in pairs(obj) do
                local strVal = extractName(v)
                if type(strVal) == "string" then
                    local lowerStr = string.lower(strVal)
                    if lowerStr == "pollen" or lowerStr == "red pollen" then hasPollen = true end
                    if string.find(lowerStr, "convert") then hasConvert = true end
                end
            end
            
            -- If it has both "Pollen" and "Convert", it is 100% the stat dictionary.
            if hasPollen and hasConvert then
                found = true
                printLine("========================", Color3.fromRGB(100, 100, 255))
                printLine("🎯 TRUE STAT TABLE FOUND!", Color3.fromRGB(50, 255, 50))
                printLine("========================", Color3.fromRGB(100, 100, 255))
                
                -- Extract our target IDs directly
                local ids = {11, 12, 13, 16}
                for _, id in ipairs(ids) do
                    local val = rawget(obj, id) or rawget(obj, tostring(id))
                    if val then
                        printLine("["..id.."] = " .. extractName(val), Color3.fromRGB(255, 200, 100))
                    else
                        printLine("["..id.."] = (Empty/None)", Color3.fromRGB(150, 150, 150))
                    end
                end
                break -- We found the one true table, stop searching!
            end
        end
    end
    
    if not found then
        printLine("Could not find the true stat table.", Color3.fromRGB(255, 50, 50))
    end
end)
