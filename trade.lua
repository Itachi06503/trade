-- ==========================================
-- 🛠️ BSS INVENTORY DEEP SCANNER (V3)
-- ==========================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Data_Reader_V3"
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
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
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
header.Text = "🔍 BSS Deep Inspector V3"
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
scanBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Text = "DEEP SCAN CACHE"
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

-- Functions
local function addListItem(displayName, potential, guid)
    local itemFrame = Instance.new("Frame", scrollFrame)
    itemFrame.Size = UDim2.new(1, -10, 0, 60)
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
    nameLbl.Text = displayName
    
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

-- Deep Search logic to find Names and Potentials inside nested tables
local function searchTable(t)
    local name = "Unknown Item"
    local potential = "Maxed/Unknown"
    
    for k, v in pairs(t) do
        local keyLower = tostring(k):lower()
        if type(v) == "string" or type(v) == "number" then
            if keyLower == "name" or keyLower == "beequipid" or keyLower == "id" then
                name = tostring(v)
            elseif keyLower == "potential" or keyLower == "pot" then
                potential = tostring(v)
            end
        end
    end
    return name, potential
end

scanBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    scanBtn.Text = "DECRYPTING CACHE..."
    task.wait(0.2)
    
    local foundItems = 0
    
    local success, statCache = pcall(function()
        local cacheModule = require(ReplicatedStorage:WaitForChild("ClientStatCache"))
        return cacheModule:Get()
    end)
    
    if success and type(statCache) == "table" then
        if statCache.Beequips then
            -- Loop through whatever structure Onett is using
            for key, data in pairs(statCache.Beequips) do
                if type(data) == "table" then
                    local name, potential = searchTable(data)
                    -- If the key itself is a long string, it's likely the GUID
                    local displayGuid = (type(key) == "string" and #key > 15) and key or "Found inside index: " .. tostring(key)
                    
                    addListItem("🐝 " .. name, potential, displayGuid)
                    foundItems = foundItems + 1
                end
            end
        end
    end
    
    if foundItems == 0 then
        addListItem("System", "N/A", "Could not parse nested tables.")
    end
    
    scanBtn.Text = "DEEP SCAN CACHE"
end)
