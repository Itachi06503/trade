-- ==========================================
-- 🕯️ BSS WAX INSPECTOR (Targeted Table Cracker)
-- ==========================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Wax_Inspector"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 360, 0, 450)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Draggable = true

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Text = " 🕯️ Inspecting Wax Tables (W)"
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

-- Scan Logic
task.spawn(function()
    local success, statCache = pcall(function()
        return require(ReplicatedStorage:WaitForChild("ClientStatCache")):Get()
    end)
    
    if success and statCache and statCache.Beequips then
        local foundWaxedItems = 0
        
        -- Check all folders (Case, Storage, etc.)
        for folderName, folderData in pairs(statCache.Beequips) do
            if type(folderData) == "table" then
                for index, item in pairs(folderData) do
                    
                    -- Only look at items that have a 'W' (Wax) property
                    if type(item) == "table" and item.W then
                        local itemName = item.T or "Unknown"
                        
                        -- If 'W' is a table, we open it up!
                        if type(item.W) == "table" then
                            foundWaxedItems = foundWaxedItems + 1
                            
                            printLine("========================", Color3.fromRGB(100, 100, 255))
                            printLine("🐝 " .. itemName .. " [" .. folderName .. "]", Color3.fromRGB(255, 200, 100))
                            printLine("Wax Data (W) Contents:", Color3.fromRGB(150, 150, 150))
                            
                            -- Loop through everything inside the 'W' table
                            local waxCount = 0
                            for wKey, wVal in pairs(item.W) do
                                waxCount = waxCount + 1
                                local displayVal = tostring(wVal)
                                if type(wVal) == "table" then displayVal = "{Nested Data}" end
                                
                                printLine("  [" .. tostring(wKey) .. "] = " .. displayVal, Color3.fromRGB(255, 150, 255))
                            end
                            
                            if waxCount == 0 then
                                printLine("  [Table is completely empty]", Color3.fromRGB(100, 100, 100))
                            end
                        end
                        
                    end
                end
            end
        end
        
        if foundWaxedItems == 0 then
            printLine("No Waxed Beequips found in your inventory!", Color3.fromRGB(255, 50, 50))
            printLine("Try waxing an item and running this again.")
        end
    else
        printLine("Failed to read statCache.Beequips", Color3.fromRGB(255, 50, 50))
    end
end)
