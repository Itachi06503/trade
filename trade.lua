-- ==========================================
-- 📖 BSS ROSETTA STONE (Stat ID Decrypter)
-- ==========================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Rosetta_Stone"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.Text = " 📖 Decrypting Game Modules..."
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

-- Modules most likely to contain the mappings
local targetModules = {
    "BeequipTypes", 
    "StatTypes", 
    "ItemTypes", 
    "Types", 
    "StatCache",
    "WaxTypes"
}

-- IDs we are actively hunting for based on your screenshots
local targetIDs = {11, 12, 13, 16}

task.spawn(function()
    printLine("Initiating Deep Module Scan...", Color3.fromRGB(100, 255, 100))
    printLine("Hunting for Stat IDs: 11, 12, 13, 16", Color3.fromRGB(150, 150, 150))
    printLine("--------------------------------", Color3.fromRGB(100, 100, 100))
    
    local foundSomething = false

    for _, moduleName in pairs(targetModules) do
        local modScript = ReplicatedStorage:FindFirstChild(moduleName)
        
        if modScript and modScript:IsA("ModuleScript") then
            printLine("Loading Module: " .. moduleName, Color3.fromRGB(255, 200, 100))
            
            local success, data = pcall(require, modScript)
            
            if success and type(data) == "table" then
                -- Scan top-level tables inside the module
                for key, val in pairs(data) do
                    if type(val) == "table" then
                        
                        -- Check if this table contains any of our target IDs
                        local hasTargetID = false
                        for _, id in ipairs(targetIDs) do
                            if val[id] ~= nil then hasTargetID = true end
                        end
                        
                        if hasTargetID then
                            foundSomething = true
                            printLine("========================", Color3.fromRGB(100, 100, 255))
                            printLine("🎯 FOUND MATCH IN: " .. tostring(key), Color3.fromRGB(50, 255, 50))
                            
                            -- Print out what the table maps the IDs to!
                            for statID, statData in pairs(val) do
                                if type(statID) == "number" and statID <= 30 then
                                    local display = tostring(statData)
                                    if type(statData) == "table" then
                                        -- If it's a table, try to find a Name or Stat string inside it
                                        display = statData.Name or statData.Stat or "{Nested Table}"
                                    end
                                    printLine("  ID [" .. tostring(statID) .. "] = " .. display, Color3.fromRGB(150, 255, 150))
                                end
                            end
                        end
                    end
                end
            else
                printLine("  Could not read module data.", Color3.fromRGB(255, 100, 100))
            end
        end
    end
    
    if not foundSomething then
        printLine("Scan complete. Direct ID matches not found.", Color3.fromRGB(255, 100, 100))
        printLine("Onett might be hiding them in a deeper nested table.", Color3.fromRGB(200, 200, 200))
    else
        printLine("--------------------------------", Color3.fromRGB(100, 100, 100))
        printLine("Scan Complete!", Color3.fromRGB(100, 255, 100))
    end
end)
