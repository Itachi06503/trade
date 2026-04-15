-- ==========================================
-- 🎯 BSS ID DECODER (Mobile Friendly)
-- ==========================================
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_ID_Decoder"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
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
header.Text = " 🎯 Decoding Stat IDs..."
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
    lbl.TextSize = 13
    lbl.Text = " " .. tostring(text)
end

-- Function to safely extract a readable name from whatever the ID holds
local function extractName(val)
    if type(val) == "string" then return val end
    if type(val) == "table" then
        -- Onett often hides names inside these keys if it's a nested table
        return val.Name or val.Stat or val.StatType or val.Type or val.id or "{Nested Table}"
    end
    return tostring(val)
end

task.spawn(function()
    printLine("Scanning memory for IDs...", Color3.fromRGB(150, 150, 150))
    local memoryDump = getgc(true)
    local tablesFound = 0
    
    for _, obj in ipairs(memoryDump) do
        if type(obj) == "table" then
            -- Does this table have our target IDs?
            local v11 = rawget(obj, 11) or rawget(obj, "11")
            local v12 = rawget(obj, 12) or rawget(obj, "12")
            local v13 = rawget(obj, 13) or rawget(obj, "13")
            local v16 = rawget(obj, 16) or rawget(obj, "16")
            
            if v11 and v12 and v16 then
                local s11 = extractName(v11)
                
                -- FILTER: Make sure this isn't the QuestTypes table!
                if type(s11) == "string" and not string.find(s11, "Quest") and not string.find(s11, "Bear") then
                    tablesFound = tablesFound + 1
                    printLine("========================", Color3.fromRGB(100, 100, 255))
                    printLine("🎯 STAT DICTIONARY FOUND!", Color3.fromRGB(50, 255, 50))
                    printLine("[11] = " .. tostring(s11), Color3.fromRGB(255, 200, 100))
                    printLine("[12] = " .. tostring(extractName(v12)), Color3.fromRGB(255, 200, 100))
                    printLine("[13] = " .. tostring(extractName(v13)), Color3.fromRGB(255, 200, 100))
                    printLine("[16] = " .. tostring(extractName(v16)), Color3.fromRGB(255, 200, 100))
                end
            end
        end
    end
    
    printLine("------------------------", Color3.fromRGB(100, 100, 100))
    if tablesFound == 0 then
        printLine("Could not find matching stat tables.", Color3.fromRGB(255, 50, 50))
    else
        printLine("Scan Complete!", Color3.fromRGB(100, 255, 100))
    end
end)
