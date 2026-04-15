-- ==========================================
-- 👑 BSS MASTER WAX HUB (Live Memory + Simulator)
-- ==========================================
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Master_Wax_Hub"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

-- Mobile Friendly UI Dimensions
local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 320, 0, 440)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
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
header.Text = " 👑 Master Wax Hub & Predictor"
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
displayFrame.Size = UDim2.new(1, -20, 0, 160)
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
infoText.RichText = true
infoText.TextWrapped = true
infoText.Text = "Initializing Live Memory Scan..."

-- Log Area for Simulation
local logScroll = Instance.new("ScrollingFrame", mainFrame)
logScroll.Size = UDim2.new(1, -20, 1, -260)
logScroll.Position = UDim2.new(0, 10, 0, 215)
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
    
    logScroll.CanvasPosition = Vector2.new(0, logScroll.AbsoluteWindowSize.Y + 1000)
end

-- ==========================================
-- 🧠 DYNAMIC DATA DICTIONARY
-- ==========================================
local MasterStats = {
    [11] = "Scanning...",
    [12] = "Scanning...",
    [13] = "Scanning...",
    [16] = "Scanning..."
}

local WaxData = {
    ["Soft Wax"] = { Success = 1.00, Destroy = false, Multiplier = 1.0 },
    ["Hard Wax"] = { Success = 0.60, Destroy = false, Multiplier = 1.5 },
    ["Swirled Wax"] = { Success = 0.50, Destroy = false, Multiplier = 2.0 },
    ["Caustic Wax"] = { Success = 0.25, Destroy = true, Multiplier = 3.0 }
}

local selectedWax = "Soft Wax"
local waxTypesList = {"Soft Wax", "Hard Wax", "Swirled Wax", "Caustic Wax"}
local currentWaxIndex = 1

local function updateDisplay()
    local data = WaxData[selectedWax]
    
    local txt = "🧪 **" .. selectedWax .. "**\n\n"
    txt = txt .. "Success Rate: <font color='rgb(100,255,100)'>" .. (data.Success * 100) .. "%</font>\n"
    
    if data.Destroy then
        txt = txt .. "Risk: <font color='rgb(255,50,50)'>DESTROYS BEEQUIP ON FAIL!</font>\n"
    else
        txt = txt .. "Risk: <font color='rgb(150,150,150)'>Safe (Does not destroy)</font>\n"
    end
    
    txt = txt .. "Power Tier: " .. data.Multiplier .. "x\n\n"
    txt = txt .. "<b>Live Decoded Stats (from RAM):</b>\n"
    txt = txt .. "- " .. tostring(MasterStats[11]) .. "\n"
    txt = txt .. "- " .. tostring(MasterStats[12]) .. "\n"
    txt = txt .. "- " .. tostring(MasterStats[13]) .. "\n"
    txt = txt .. "- " .. tostring(MasterStats[16])
    
    infoText.Text = txt
end

-- Buttons
local btnContainer = Instance.new("Frame", mainFrame)
btnContainer.Size = UDim2.new(1, -20, 0, 30)
btnContainer.Position = UDim2.new(0, 10, 1, -40)
btnContainer.BackgroundTransparency = 1

local selectBtn = Instance.new("TextButton", btnContainer)
selectBtn.Size = UDim2.new(0.48, 0, 1, 0)
selectBtn.Position = UDim2.new(0, 0, 0, 0)
selectBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
selectBtn.Font = Enum.Font.GothamBold
selectBtn.TextSize = 12
selectBtn.Text = "Cycle Wax"
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

selectBtn.MouseButton1Click:Connect(function()
    currentWaxIndex = currentWaxIndex + 1
    if currentWaxIndex > #waxTypesList then currentWaxIndex = 1 end
    selectedWax = waxTypesList[currentWaxIndex]
    updateDisplay()
end)

simBtn.MouseButton1Click:Connect(function()
    local data = WaxData[selectedWax]
    addLog("--- Applying " .. selectedWax .. " ---", Color3.fromRGB(150, 150, 255))
    
    local roll = math.random()
    if roll <= data.Success then
        addLog("✅ SUCCESS! (Rolled " .. math.floor(roll*100) .. "% <= " .. (data.Success*100) .. "%)", Color3.fromRGB(100, 255, 100))
        
        local possibleIDs = {11, 12, 13, 16}
        local randomID = possibleIDs[math.random(1, #possibleIDs)]
        local statName = MasterStats[randomID]
        local baseStat = math.random(1, 5) * data.Multiplier
        
        addLog("🎁 Reward: +" .. baseStat .. "% " .. statName, Color3.fromRGB(255, 200, 100))
    else
        addLog("❌ FAILED! (Rolled " .. math.floor(roll*100) .. "% > " .. (data.Success*100) .. "%)", Color3.fromRGB(255, 100, 100))
        if data.Destroy then
            addLog("💥 BEEQUIP DESTROYED!", Color3.fromRGB(255, 50, 50))
        else
            addLog("💨 No effect.", Color3.fromRGB(150, 150, 150))
        end
    end
end)

-- ==========================================
-- 🔍 LIVE MEMORY EXTRACTION
-- ==========================================
local function extractName(val)
    if type(val) == "string" then return val end
    if type(val) == "table" then return val.Name or val.Stat or val.Type or val.id or tostring(val) end
    return tostring(val)
end

task.spawn(function()
    addLog("🧠 Injecting into Client Memory...", Color3.fromRGB(150, 150, 150))
    updateDisplay()
    
    local memoryDump = getgc(true)
    local found = false
    
    for _, obj in ipairs(memoryDump) do
        if type(obj) == "table" then
            local hasPollen = false
            local hasConvert = false
            
            for _, v in pairs(obj) do
                local strVal = extractName(v)
                if type(strVal) == "string" then
                    local lowerStr = string.lower(strVal)
                    if lowerStr == "pollen" or lowerStr == "red pollen" then hasPollen = true end
                    if string.find(lowerStr, "convert") then hasConvert = true end
                end
            end
            
            if hasPollen and hasConvert then
                found = true
                addLog("🎯 Target Stat Dictionary Acquired!", Color3.fromRGB(50, 255, 50))
                
                -- Update our dictionary dynamically from the game's RAM
                local ids = {11, 12, 13, 16}
                for _, id in ipairs(ids) do
                    local val = rawget(obj, id) or rawget(obj, tostring(id))
                    if val then
                        MasterStats[id] = extractName(val)
                    else
                        MasterStats[id] = "Unknown"
                    end
                end
                break
            end
        end
    end
    
    if not found then
        addLog("⚠️ RAM Scan Failed. Using fallbacks.", Color3.fromRGB(255, 100, 100))
        MasterStats[11] = "White Pollen (Fallback)"
        MasterStats[12] = "Red Pollen (Fallback)"
        MasterStats[13] = "Blue Pollen (Fallback)"
        MasterStats[16] = "Bee Ability Pollen (Fallback)"
    end
    
    updateDisplay()
end)
