-- ==========================================
-- 🛠️ BSS RECURSIVE DEEP SCANNER (V4)
-- ==========================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Data_Reader_V4"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then
        target[GUI_NAME]:Destroy()
    end
end)

local sg = Instance.new("ScreenGui")
sg.Name = GUI_NAME
local success = pcall(function() sg.Parent = gethui() end)
if not success then sg.Parent = CoreGui end

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 360, 0, 480)
mainFrame.Position = UDim2.new(0.5, -180, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.Text = "🧬 BSS Recursive Scanner V4"
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 40, 1, 0)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Scan Button
local scanBtn = Instance.new("TextButton", mainFrame)
scanBtn.Size = UDim2.new(1, -20, 0, 35)
scanBtn.Position = UDim2.new(0, 10, 0, 50)
scanBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Text = "EXECUTE MEMORY SPIDER"
Instance.new("UICorner", scanBtn).CornerRadius = UDim.new(0, 6)

-- Scrolling List
local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(1, -20, 1, -100)
scrollFrame.Position = UDim2.new(0, 10, 0, 95)
scrollFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Render Item to UI
local function addListItem(displayName, potential, guid)
    local itemFrame = Instance.new("Frame", scrollFrame)
    itemFrame.Size = UDim2.new(1, -10, 0, 65)
    itemFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 4)
    
    local nameLbl = Instance.new("TextLabel", itemFrame)
    nameLbl.Size = UDim2.new(1, -10, 0.35, 0)
    nameLbl.Position = UDim2.new(0, 5, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextSize = 14
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Text = "🐝 " .. displayName
    
    local potLbl = Instance.new("TextLabel", itemFrame)
    potLbl.Size = UDim2.new(1, -10, 0.3, 0)
    potLbl.Position = UDim2.new(0, 5, 0.35, 0)
    potLbl.BackgroundTransparency = 1
    potLbl.TextColor3 = Color3.fromRGB(100, 255, 100)
    potLbl.Font = Enum.Font.Gotham
    potLbl.TextSize = 12
    potLbl.TextXAlignment = Enum.TextXAlignment.Left
    potLbl.Text = "⚡ Potential: " .. tostring(potential)

    local guidLbl = Instance.new("TextLabel", itemFrame)
    guidLbl.Size = UDim2.new(1, -10, 0.35, 0)
    guidLbl.Position = UDim2.new(0, 5, 0.65, 0)
    guidLbl.BackgroundTransparency = 1
    guidLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    guidLbl.Font = Enum.Font.Code
    guidLbl.TextSize = 10
    guidLbl.TextXAlignment = Enum.TextXAlignment.Left
    guidLbl.Text = "GUID: " .. tostring(guid)
end

-- ==========================================
-- 🕷️ The Recursive Spider Logic
-- ==========================================
local foundItemsCount = 0

-- This function calls itself over and over until it hits the bottom of a table
local function spiderScan(currentTable, parentKey)
    -- Safety check to prevent infinite loops if Onett has circular references
    if type(currentTable) ~= "table" then return end
    
    -- Check if THIS specific table is a Beequip by looking for common identifying keys
    if currentTable.BeequipId or currentTable.Potential or currentTable.Name then
        
        -- We found one! Extract the exact data points.
        local name = currentTable.BeequipId or currentTable.Name or "Unknown Name"
        local pot = currentTable.Potential or currentTable.Pot or "0"
        
        -- The GUID is usually the key of the parent table, but sometimes stored inside as UUID
        local guid = currentTable.GUID or currentTable.UUID or parentKey or "No-GUID-Found"
        
        -- Filter out useless dummy data (sometimes devs leave blank templates in the code)
        if name ~= "Unknown Name" then
            addListItem(name, pot, guid)
            foundItemsCount = foundItemsCount + 1
        end
        return -- Stop digging in this specific branch, we found the item.
    end
    
    -- If it's not a Beequip, loop through everything inside it and dig deeper
    for key, value in pairs(currentTable) do
        if type(value) == "table" then
            spiderScan(value, key) -- <--- This is the recursive jump
        end
    end
end

scanBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    scanBtn.Text = "SPIDER IS DIGGING..."
    foundItemsCount = 0
    task.wait(0.2)
    
    local success, statCache = pcall(function()
        local cacheModule = require(ReplicatedStorage:WaitForChild("ClientStatCache"))
        return cacheModule:Get()
    end)
    
    if success and type(statCache) == "table" then
        if statCache.Beequips then
            -- We unleash the spider on the Beequips folder. 
            -- It will automatically find the "Storage" folder and dig inside it!
            spiderScan(statCache.Beequips, "Root")
        end
    end
    
    if foundItemsCount == 0 then
        addListItem("System", "N/A", "Spider found nothing. Data might be encrypted.")
    end
    
    scanBtn.Text = "EXECUTE MEMORY SPIDER"
end)
