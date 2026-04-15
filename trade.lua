-- [[ BSS ADVANCED TRADE UTILITY ]] --
-- Features: Inventory Scanning, Draggable UI, Quick-Swap

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- 1. UTILITY: FINDING THE DATA
-- BSS stores item data in specific tables. This function attempts to find them.
local function getInventoryItems()
    local items = {}
    -- BSS often stores tradeable items in a 'Stickers' or 'Beequips' folder 
    -- located within the Player's 'CoreStats' or 'PlayerGui' trade window.
    local stickerData = LocalPlayer:FindFirstChild("CoreStats") and LocalPlayer.CoreStats:FindFirstChild("Stickers")
    
    if stickerData then
        for _, item in pairs(stickerData:GetChildren()) do
            -- item.Name is the Display Name, item.Value is usually the GUID
            table.insert(items, {Name = item.Name, ID = item.Value})
        end
    else
        -- Fallback: Scanning the Trade UI for loaded item IDs
        local tradeGui = LocalPlayer.PlayerGui:FindFirstChild("TradeGui", true)
        if tradeGui then
            -- This logic would iterate through the UI icons to pull ID metadata
            print("Scanning Trade UI for Item GUIDs...")
        end
    end
    return items
end

-- 2. THE SWAP ENGINE
local TradeRemote = ReplicatedStorage:FindFirstChild("StickerTradeRequest", true)

local function executeSwap(rareID, junkID)
    if not TradeRemote then return end
    
    -- Fast sequence to bypass visual updates
    TradeRemote:FireServer("RemoveItem", rareID)
    task.wait(0.05)
    TradeRemote:FireServer("AddItem", junkID)
    TradeRemote:FireServer("AcceptTrade")
end

-- 3. THE INTERFACE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BSS_Smart_Trade"
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 150)
Main.Position = UDim2.new(0.5, -110, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Main.Draggable = true
Main.Active = true
Main.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "AUTO-SCAN SWAPPER"
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = Main

local RareLabel = Instance.new("TextLabel")
RareLabel.Size = UDim2.new(1, -20, 0, 20)
RareLabel.Position = UDim2.new(0, 10, 0, 35)
RareLabel.Text = "Rare: [None Selected]"
RareLabel.TextColor3 = Color3.new(0.7, 1, 0.7)
RareLabel.BackgroundTransparency = 1
RareLabel.Parent = Main

local JunkLabel = Instance.new("TextLabel")
JunkLabel.Size = UDim2.new(1, -20, 0, 20)
JunkLabel.Position = UDim2.new(0, 10, 0, 55)
JunkLabel.Text = "Junk: [None Selected]"
JunkLabel.TextColor3 = Color3.new(1, 0.7, 0.7)
JunkLabel.BackgroundTransparency = 1
JunkLabel.Parent = Main

local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0, 200, 0, 30)
ScanBtn.Position = UDim2.new(0, 10, 0, 80)
ScanBtn.Text = "SCAN INVENTORY"
ScanBtn.Parent = Main

local ActionBtn = Instance.new("TextButton")
ActionBtn.Size = UDim2.new(0, 200, 0, 30)
ActionBtn.Position = UDim2.new(0, 10, 0, 115)
ActionBtn.Text = "EXECUTE QUICK-SWAP"
ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
ActionBtn.Parent = Main

-- 4. LOGIC CONNECTIONS
local selectedRare = nil
local selectedJunk = nil

ScanBtn.MouseButton1Click:Connect(function()
    local inventory = getInventoryItems()
    if #inventory > 0 then
        -- For this demo, we automatically pick the first and last items
        -- In a full version, this would open a dropdown list
        selectedRare = inventory[1].ID
        selectedJunk = inventory[#inventory].ID
        
        RareLabel.Text = "Rare: " .. inventory[1].Name
        JunkLabel.Text = "Junk: " .. inventory[#inventory].Name
        print("Inventory Scanned. Items Locked.")
    else
        RareLabel.Text = "No items found. Open Trade first!"
    end
end)

ActionBtn.MouseButton1Click:Connect(function()
    if selectedRare and selectedJunk then
        executeSwap(selectedRare, selectedJunk)
    end
end)
