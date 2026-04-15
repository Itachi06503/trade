-- ==========================================
-- 📝 BSS SILENT MEMORY EXPORTER
-- ==========================================
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Memory_Exporter"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 400, 0, 150)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.Text = " 📝 Exporting Master Stat Table..."
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

local statusLbl = Instance.new("TextLabel", mainFrame)
statusLbl.Size = UDim2.new(1, -20, 1, -45)
statusLbl.Position = UDim2.new(0, 10, 0, 40)
statusLbl.BackgroundTransparency = 1
statusLbl.TextColor3 = Color3.fromRGB(200, 255, 200)
statusLbl.Font = Enum.Font.Code
statusLbl.TextSize = 14
statusLbl.TextWrapped = true
statusLbl.Text = "Scanning RAM for 'Mark Duration'...\nPlease wait."

-- Function to format a table into a readable string
local function serializeTable(tbl)
    local result = "{\n"
    for k, v in pairs(tbl) do
        local keyStr = type(k) == "number" and "["..k.."]" or '["'..tostring(k)..'"]'
        local valStr = type(v) == "table" and "{...nested data...}" or '"'..tostring(v)..'"'
        result = result .. "  " .. keyStr .. " = " .. valStr .. ",\n"
    end
    return result .. "}\n\n"
end

task.spawn(function()
    local memoryDump = getgc(true)
    local masterOutput = "=== BSS MASTER STAT DUMP ===\n\n"
    local foundMatch = false
    
    for _, obj in ipairs(memoryDump) do
        if type(obj) == "table" then
            local isTargetTable = false
            
            -- Check if this specific table has "Mark Duration" inside it anywhere
            for _, v in pairs(obj) do
                if type(v) == "string" then
                    local lowerV = string.lower(v)
                    if string.find(lowerV, "mark") and string.find(lowerV, "duration") then
                        isTargetTable = true
                    end
                elseif type(v) == "table" then
                    for _, subV in pairs(v) do
                         if type(subV) == "string" then
                             local lowerSubV = string.lower(subV)
                             if string.find(lowerSubV, "mark") and string.find(lowerSubV, "duration") then
                                 isTargetTable = true
                             end
                         end
                    end
                end
            end
            
            -- If it's the right table, format it and add it to our text file
            if isTargetTable then
                foundMatch = true
                masterOutput = masterOutput .. "--- POTENTIAL STAT TABLE FOUND ---\n"
                masterOutput = masterOutput .. serializeTable(obj)
            end
        end
    end
    
    if foundMatch then
        -- Try to copy to clipboard
        pcall(function() setclipboard(masterOutput) end)
        
        -- Try to save to a file in the executor's workspace folder
        local fileSaved = false
        pcall(function() 
            writefile("BSS_Master_Stats.txt", masterOutput) 
            fileSaved = true
        end)
        
        if fileSaved then
            statusLbl.Text = "SUCCESS!\nData copied to clipboard AND saved to 'BSS_Master_Stats.txt' in your executor's workspace folder!"
        else
            statusLbl.Text = "SUCCESS!\nData copied to your clipboard! Open Notepad and press Ctrl+V."
        end
    else
        statusLbl.Text = "Scan finished, but 'Mark Duration' was not found in any readable tables."
        statusLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)
