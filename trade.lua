-- ==========================================
-- 🗺️ BSS RAW MEMORY MAPPER
-- ==========================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local GUI_NAME = "BSS_Memory_Mapper"
pcall(function()
    local target = gethui and gethui() or CoreGui
    if target:FindFirstChild(GUI_NAME) then target[GUI_NAME]:Destroy() end
end)

local sg = Instance.new("ScreenGui", gethui and gethui() or CoreGui)
sg.Name = GUI_NAME

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Draggable = true

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.Text = " 📂 Root Memory Folders"
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
scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local layout = Instance.new("UIListLayout", scroll)

-- The Dump Logic
task.spawn(function()
    local success, statCache = pcall(function()
        return require(ReplicatedStorage:WaitForChild("ClientStatCache")):Get()
    end)
    
    if success and type(statCache) == "table" then
        for key, value in pairs(statCache) do
            local lbl = Instance.new("TextLabel", scroll)
            lbl.Size = UDim2.new(1, -10, 0, 25)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(0, 255, 100)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            -- Prints the Folder Name and what type of data it holds
            lbl.Text = "  " .. tostring(key) .. " [" .. type(value) .. "]"
        end
    else
        local lbl = Instance.new("TextLabel", scroll)
        lbl.Size = UDim2.new(1, 0, 0, 30)
        lbl.TextColor3 = Color3.fromRGB(255, 50, 50)
        lbl.Text = "Failed to read ClientStatCache!"
    end
end)
