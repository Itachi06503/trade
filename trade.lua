-- ==========================================
-- 🔬 BSS DEEP WAX INSPECTOR (Level 3 Scan)
-- ==========================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Deep_Wax"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 380, 0, 500)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Draggable = true

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Text = " 🔬 Deep Wax Stat Scanner"
header.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, 0, 1, -30)
scroll.Position = UDim2.new(0, 0, 0, 30)
scroll.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 2)

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

-- Deep Scan Logic
task.spawn(function()
    local success, statCache = pcall(function()
        return require(ReplicatedStorage:WaitForChild("ClientStatCache")):Get()
    end)
    
    if success and statCache and statCache.Beequips then
        local foundWaxedItems = 0
        
        for folderName, folderData in pairs(statCache.Beequips) do
            if type(folderData) == "table" then
                for index, item in pairs(folderData) do
                    
                    if type(item) == "table" and item.W and type(item.W) == "table" then
                        local itemName = item.T or "Unknown"
                        foundWaxedItems = foundWaxedItems + 1
                        
                        -- Limit to just 2 items to prevent massive lag
                        if foundWaxedItems > 2 then break end 
                        
                        printLine("========================", Color3.fromRGB(100, 100, 255))
                        printLine("🐝 " .. itemName, Color3.fromRGB(255, 200, 100))
                        
                        for slotNum, waxData in pairs(item.W) do
                            printLine("  Slot [" .. tostring(slotNum) .. "]:", Color3.fromRGB(150, 200, 255))
                            
                            if type(waxData) == "table" then
                                -- Open up the nested table!
                                for deepKey, deepVal in pairs(waxData) do
                                    local displayVal = tostring(deepVal)
                                    if type(deepVal) == "table" then displayVal = "{...}" end
                                    printLine("    " .. tostring(deepKey) .. " = " .. displayVal, Color3.fromRGB(150, 255, 150))
                                end
                            else
                                printLine("    Value: " .. tostring(waxData), Color3.fromRGB(255, 150, 150))
                            end
                        end
                    end
                end
            end
        end
        
        if foundWaxedItems == 0 then
            printLine("No Waxed Beequips found!", Color3.fromRGB(255, 50, 50))
        end
    else
        printLine("Failed to read data.", Color3.fromRGB(255, 50, 50))
    end
end)
