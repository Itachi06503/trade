-- ==========================================
-- 🔎 BSS MAGNIFYING GLASS (Targeted Table Dumper)
-- ==========================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Magnifying_Glass"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Draggable = true

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Text = " 🔎 Beequips Raw Data Dump"
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

-- Dump Logic
task.spawn(function()
    local success, statCache = pcall(function()
        return require(ReplicatedStorage:WaitForChild("ClientStatCache")):Get()
    end)
    
    if success and statCache and statCache.Beequips then
        local itemCount = 0
        
        -- Loop through the Beequips table
        for guid, data in pairs(statCache.Beequips) do
            itemCount = itemCount + 1
            if itemCount > 5 then break end -- Only dump the first 5 to prevent lag
            
            printLine("========================", Color3.fromRGB(100, 100, 255))
            printLine("GUID: " .. tostring(guid), Color3.fromRGB(255, 150, 50))
            
            if type(data) == "table" then
                -- Print every single key and value inside this item
                for k, v in pairs(data) do
                    local valStr = tostring(v)
                    if type(v) == "table" then valStr = "[Nested Table]" end
                    printLine("  [" .. tostring(k) .. "] = " .. valStr, Color3.fromRGB(150, 255, 150))
                end
            else
                printLine("  Data is a: " .. type(data), Color3.fromRGB(255, 100, 100))
                printLine("  Value: " .. tostring(data))
            end
        end
        
        if itemCount == 0 then
            printLine("Beequips table is empty! Do you have any?", Color3.fromRGB(255, 50, 50))
        end
    else
        printLine("Failed to read statCache.Beequips", Color3.fromRGB(255, 50, 50))
    end
end)
