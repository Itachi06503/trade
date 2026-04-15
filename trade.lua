-- ==========================================
-- 🛠️ BSS INVENTORY SCANNER (COMPONENT A)
-- ==========================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- 1. Setup the UI
local GUI_NAME = "BSS_Data_Reader"
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
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
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
header.Text = "🔍 Item GUID Scanner"
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
scanBtn.Text = "SCAN INVENTORY"
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
    itemFrame.Size = UDim2.new(1, -10, 0, 40)
    itemFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Instance.new("UICorner", itemFrame).CornerRadius = UDim.new(0, 4)
    
    local nameLbl = Instance.new("TextLabel", itemFrame)
    nameLbl.Size = UDim2.new(1, -10, 0.5, 0)
    nameLbl.Position = UDim2.new(0, 5, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextSize = 14
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
    guidLbl.Text = "UUID: " .. tostring(guid)
end

scanBtn.MouseButton1Click:Connect(function()
    -- Clear old results
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    scanBtn.Text = "SCANNING..."
    
    -- In BSS, Bequips and Stickers are usually tracked in the player's hidden stat folders.
    -- This looks for standard Value objects storing GUIDs.
    local beequipsFolder = LocalPlayer:FindFirstChild("Beequips")
    local stickersFolder = LocalPlayer:FindFirstChild("Stickers") -- Or wherever the game stores them
    
    local foundItems = 0
    
    if beequipsFolder then
        for _, item in pairs(beequipsFolder:GetChildren()) do
            -- Assuming the Name is the Item ID and the Value holds the UUID string or table
            addListItem("Beequip: " .. item.Name, item.Value or "No-UUID-Found")
            foundItems = foundItems + 1
        end
    end
    
    -- If folders aren't standard, we scan ReplicatedStorage/Player memory (Example placeholder)
    if foundItems == 0 then
        addListItem("System", "Could not locate standard folders. Using fallback...")
        -- You would expand this to tap into Onett's specific Client tables using getgc() if needed
    end
    
    task.wait(0.5)
    scanBtn.Text = "SCAN INVENTORY"
end)
