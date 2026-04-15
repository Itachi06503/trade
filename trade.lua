-- ==========================================
-- 🛠️ BSS INVENTORY SCANNER (COMPONENT A - FIXED)
-- ==========================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- 1. Setup the UI
local GUI_NAME = "BSS_Data_Reader_V2"
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
mainFrame.Size = UDim2.new(0, 320, 0, 450)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Header
local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.Text = "🔍 BSS GUID Scanner V2"
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
scanBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Text = "RIP CLIENT MEMORY"
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

-- 2. The Extraction Logic
local function addListItem(displayName, guid)
    local itemFrame = Instance.new("Frame", scrollFrame)
    itemFrame.Size = UDim2.new(1, -10, 0, 45)
    itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 4)
    
    local nameLbl = Instance.new("TextLabel", itemFrame)
    nameLbl.Size = UDim2.new(1, -10, 0.5, 0)
    nameLbl.Position = UDim2.new(0, 5, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Text = displayName
    
    local guidLbl = Instance.new("TextLabel", itemFrame)
    guidLbl.Size = UDim2.new(1, -10, 0.5, 0)
    guidLbl.Position = UDim2.new(0, 5, 0.5, 0)
    guidLbl.BackgroundTransparency = 1
    guidLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    guidLbl.Font = Enum.Font.Code
    guidLbl.TextSize = 10
    guidLbl.TextXAlignment = Enum.TextXAlignment.Left
    guidLbl.Text = "GUID: " .. tostring(guid)
end

scanBtn.MouseButton1Click:Connect(function()
    -- Clear old results
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    scanBtn.Text = "DECRYPTING STAT CACHE..."
    task.wait(0.2)
    
    local foundItems = 0
    
    -- Force require Onett's ClientStatCache module to read the raw tables
    local success, statCache = pcall(function()
        local cacheModule = require(ReplicatedStorage:WaitForChild("ClientStatCache"))
        return cacheModule:Get() -- This dumps the player's entire save file dictionary
    end)
    
    if success and type(statCache) == "table" then
        -- 1. Rip Beequips
        if statCache.Beequips then
            for guid, itemData in pairs(statCache.Beequips) do
                -- ItemData is usually a table containing stats. We extract the visual name.
                local beequipName = "Unknown Beequip"
                if type(itemData) == "table" then
                    beequipName = itemData.BeequipId or itemData.Name or "Custom/Waxed Beequip"
                elseif type(itemData) == "string" then
                    beequipName = itemData
                end
                
                addListItem("🐝 " .. beequipName, guid)
                foundItems = foundItems + 1
            end
        end
        
        -- 2. Rip Stickers
        if statCache.Stickers then
            for guid, stickerData in pairs(statCache.Stickers) do
                local stickerName = "Unknown Sticker"
                if type(stickerData) == "table" then
                    stickerName = stickerData.StickerId or stickerData.Name or "Sticker"
                elseif type(stickerData) == "string" then
                    stickerName = stickerData
                end
                
                addListItem("🏷️ " .. stickerName, guid)
                foundItems = foundItems + 1
            end
        end
    end
    
    if foundItems == 0 then
        addListItem("System Error", "Could not read ClientStatCache. Did Onett patch the module?")
    end
    
    scanBtn.Text = "RIP CLIENT MEMORY"
end)
