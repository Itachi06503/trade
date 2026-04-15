-- ==========================================
-- 🔬 BSS ARRAY CRACKER (Item Inspector)
-- ==========================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Array_Cracker"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Draggable = true

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Text = " 🔬 Inspecting Storage Items"
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
    
    if success and statCache and statCache.Beequips and statCache.Beequips.Storage then
        local storageArray = statCache.Beequips.Storage
        local itemCount = 0
        
        for index, itemData in pairs(storageArray) do
            itemCount = itemCount + 1
            if itemCount > 3 then break end -- Only dump the first 3 items so it's easy to read
            
            printLine("========================", Color3.fromRGB(100, 100, 255))
            printLine("ITEM INDEX: [" .. tostring(index) .. "]", Color3.fromRGB(255, 150, 50))
            
            if type(itemData) == "table" then
                -- Print every property inside this specific Beequip
                for key, value in pairs(itemData) do
                    local valStr = tostring(value)
                    if type(value) == "table" then 
                        valStr = "{...}" -- Don't open deeper tables yet, just show keys
                    end
                    printLine("  " .. tostring(key) .. " = " .. valStr, Color3.fromRGB(150, 255, 150))
                end
            end
        end
        
        if itemCount == 0 then
            printLine("Your Storage array is empty! Put a Beequip in it.", Color3.fromRGB(255, 50, 50))
        end
    else
        printLine("Failed to read statCache.Beequips.Storage", Color3.fromRGB(255, 50, 50))
    end
end)
