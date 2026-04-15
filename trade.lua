-- ==========================================
-- 🔮 BSS ULTIMATE WAX PREDICTOR
-- ==========================================
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Wax_Predictor"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

-- Mobile Friendly UI Dimensions
local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.Text = " 🔮 Wax Predictor & Simulator"
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

-- Data Display Area
local displayFrame = Instance.new("Frame", mainFrame)
displayFrame.Size = UDim2.new(1, -20, 0, 150)
displayFrame.Position = UDim2.new(0, 10, 0, 45)
displayFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", displayFrame).CornerRadius = UDim.new(0, 6)

local infoText = Instance.new("TextLabel", displayFrame)
infoText.Size = UDim2.new(1, -10, 1, -10)
infoText.Position = UDim2.new(0, 5, 0, 5)
infoText.BackgroundTransparency = 1
infoText.TextColor3 = Color3.fromRGB(200, 255, 200)
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.Font = Enum.Font.Code
infoText.TextSize = 13
infoText.TextWrapped = true
infoText.Text = "Select a Wax to see its hidden stats and predict outcomes."

-- Log Area for Simulation
local logScroll = Instance.new("ScrollingFrame", mainFrame)
logScroll.Size = UDim2.new(1, -20, 1, -260)
logScroll.Position = UDim2.new(0, 10, 0, 205)
logScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
logScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
logScroll.ScrollBarThickness = 4
Instance.new("UICorner", logScroll).CornerRadius = UDim.new(0, 6)

local logLayout = Instance.new("UIListLayout", logScroll)
logLayout.Padding = UDim.new(0, 2)

local function addLog(text, color)
    local lbl = Instance.new("TextLabel", logScroll)
    lbl.Size = UDim2.new(1, -10, 0, 18)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.Text = " " .. text
    
    -- Auto-scroll to bottom
    logScroll.CanvasPosition = Vector2.new(0, logScroll.AbsoluteWindowSize.Y + 1000)
end

-- ==========================================
-- 📚 THE MASTER DATA DICTIONARY (What we learned!)
-- ==========================================
local MasterStats = {
    [11] = "White Pollen",
    [12] = "Red Pollen",
    [13] = "Blue Pollen",
    [16] = "Bee Ability Pollen"
}

-- Reconstructing Onett's hidden Wax table
local WaxData = {
    ["Soft Wax"] = { Success = 1.00, Destroy = false, Multiplier = 1.0 },
    ["Hard Wax"] = { Success = 0.60, Destroy = false, Multiplier = 1.5 },
    ["Swirled Wax"] = { Success = 0.50, Destroy = false, Multiplier = 2.0 },
    ["Caustic Wax"] = { Success = 0.25, Destroy = true, Multiplier = 3.0 }
}

local selectedWax = nil

-- Buttons
local btnContainer = Instance.new("Frame", mainFrame)
btnContainer.Size = UDim2.new(1, -20, 0, 30)
btnContainer.Position = UDim2.new(0, 10, 1, -45)
btnContainer.BackgroundTransparency = 1

local selectBtn = Instance.new("TextButton", btnContainer)
selectBtn.Size = UDim2.new(0.48, 0, 1, 0)
selectBtn.Position = UDim2.new(0, 0, 0, 0)
selectBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
selectBtn.Font = Enum.Font.GothamBold
selectBtn.TextSize = 12
selectBtn.Text = "Cycle Wax Type"
Instance.new("UICorner", selectBtn).CornerRadius = UDim.new(0, 6)

local simBtn = Instance.new("TextButton", btnContainer)
simBtn.Size = UDim2.new(0.48, 0, 1, 0)
simBtn.Position = UDim2.new(0.52, 0, 0, 0)
simBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
simBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
simBtn.Font = Enum.Font.GothamBold
simBtn.TextSize = 12
simBtn.Text = "Simulate Roll"
Instance.new("UICorner", simBtn).CornerRadius = UDim.new(0, 6)

local waxTypesList = {"Soft Wax", "Hard Wax", "Swirled Wax", "Caustic Wax"}
local currentWaxIndex = 1

local function updateDisplay()
    selectedWax = waxTypesList[currentWaxIndex]
    local data = WaxData[selectedWax]
    
    local txt = "🧪 **" .. selectedWax .. "**\n\n"
    txt = txt .. "Success Rate: " .. (data.Success * 100) .. "%\n"
    
    if data.Destroy then
        txt = txt .. "Risk: DESTROYS BEEQUIP ON FAIL!\n"
    else
        txt = txt .. "Risk: Safe (Does not destroy)\n"
    end
    
    txt = txt .. "Power Tier: " .. data.Multiplier .. "x\n\n"
    txt = txt .. "Possible Decoded Stats:\n"
    txt = txt .. "- " .. MasterStats[11] .. "\n"
    txt = txt .. "- " .. MasterStats[12] .. "\n"
    txt = txt .. "- " .. MasterStats[13] .. "\n"
    txt = txt .. "- " .. MasterStats[16]
    
    infoText.Text = txt
end

selectBtn.MouseButton1Click:Connect(function()
    currentWaxIndex = currentWaxIndex + 1
    if currentWaxIndex > #waxTypesList then currentWaxIndex = 1 end
    updateDisplay()
end)

simBtn.MouseButton1Click:Connect(function()
    if not selectedWax then return end
    local data = WaxData[selectedWax]
    
    addLog("--- Applying " .. selectedWax .. " ---", Color3.fromRGB(150, 150, 255))
    
    -- Onett's RNG Logic
    local roll = math.random()
    if roll <= data.Success then
        -- Success!
        addLog("✅ SUCCESS! (Rolled " .. math.floor(roll*100) .. "% <= " .. (data.Success*100) .. "%)", Color3.fromRGB(100, 255, 100))
        
        -- Pick a random decoded stat
        local possibleIDs = {11, 12, 13, 16}
        local randomID = possibleIDs[math.random(1, #possibleIDs)]
        local statName = MasterStats[randomID]
        
        -- Generate a percentage based on the wax power (e.g. 0.01 to 0.05 * multiplier)
        local baseStat = math.random(1, 5) * data.Multiplier
        
        addLog("🎁 Reward: +" .. baseStat .. "% " .. statName, Color3.fromRGB(255, 200, 100))
    else
        -- Fail!
        addLog("❌ FAILED! (Rolled " .. math.floor(roll*100) .. "% > " .. (data.Success*100) .. "%)", Color3.fromRGB(255, 100, 100))
        if data.Destroy then
            addLog("💥 BEEQUIP DESTROYED!", Color3.fromRGB(255, 50, 50))
        else
            addLog("💨 No effect.", Color3.fromRGB(150, 150, 150))
        end
    end
end)

-- Initialize
updateDisplay()
