-- ==========================================
-- 🧠 BSS MEMORY SCRAPER (getgc Bruteforce)
-- ==========================================
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Memory_Scraper"
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
header.Text = " 🧠 Scraping Raw Client Memory..."
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
layout.Padding = UDim.new(0, 2)

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

-- The IDs we know exist in the stat table
local targetIDs = {[11] = true, [12] = true, [13] = true, [16] = true}

task.spawn(function()
    printLine("Initiating getgc() Memory Dump...", Color3.fromRGB(100, 255, 100))
    printLine("Hunting for tables containing keys 11, 12, 13, 16...", Color3.fromRGB(150, 150, 150))
    
    local foundCount = 0
    local memoryDump = getgc(true)
    
    for _, obj in ipairs(memoryDump) do
        if type(obj) == "table" then
            -- We are looking for a table that has at least 3 of our target IDs to avoid false positives
            local matchCount = 0
            for id, _ in pairs(targetIDs) do
                if rawget(obj, id) ~= nil then
                    matchCount = matchCount + 1
                end
            end
            
            -- If we find a table with our IDs, it's highly likely the master stat table!
            if matchCount >= 3 then
                foundCount = foundCount + 1
                printLine("==================================", Color3.fromRGB(100, 100, 255))
                printLine("🎯 POTENTIAL MASTER TABLE FOUND IN RAM!", Color3.fromRGB(50, 255, 50))
                
                for k, v in pairs(obj) do
                    -- Only print out numeric keys to keep it clean
                    if type(k) == "number" then
                        local display = tostring(v)
                        if type(v) == "table" then
                            -- Check for a "Name" or "Stat" field inside nested tables
                            display = v.Name or v.Stat or "{Nested Table}"
                        end
                        printLine("  [" .. tostring(k) .. "] = " .. display, Color3.fromRGB(255, 200, 100))
                    end
                end
            end
        end
    end
    
    printLine("--------------------------------", Color3.fromRGB(100, 100, 100))
    if foundCount == 0 then
        printLine("Memory scan complete. 0 matches found.", Color3.fromRGB(255, 50, 50))
    else
        printLine("Memory scan complete! Found " .. foundCount .. " tables.", Color3.fromRGB(100, 255, 100))
    end
end)
