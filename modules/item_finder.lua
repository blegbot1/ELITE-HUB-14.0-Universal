-- ELITE HUB 14.0 — Item Finder Module
-- Extracted from ELITE_HUB_14.0.lua
local ItemFinderTab = Window:CreateTab("🔍 " .. L("ItemFinder"), 6026568198, "ItemFinder")

local if1 = ItemFinderTab:CreateSection(L("ItemFinder"))
table.insert(Window._translatables, {element = if1, key = "ItemFinder", type = "section", prefix = ""})

local ItemFinderESP = false
ItemFinderTab:CreateToggle({
    Name = "👁️ Item ESP",
    CurrentValue = false,
    Callback = function(value)
        ItemFinderESP = value
        if not value then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:GetAttribute("EliteHubIFESP") then
                    local bb = v:FindFirstChildOfClass("BillboardGui")
                    if bb then bb:Destroy() end
                    v:SetAttribute("EliteHubIFESP", nil)
                end
            end
        end
    end
})

local ItemListFrame = nil
local ItemButtons = {}
local FoundItems = {}

local function tpToItem(index)
    pcall(function()
        local item = FoundItems[index]
        if not item or not item.Parent then return end
        local part = item:FindFirstChild("Handle") or item:FindFirstChildWhichIsA("BasePart")
        if not part then return end
        local ch = player.Character
        if ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end)
end

local function scanItems()
    for _, btn in ipairs(ItemButtons) do
        pcall(function() btn:Destroy() end)
    end
    ItemButtons = {}
    FoundItems = {}

    local ch = player.Character
    local myPos = ch and ch:FindFirstChild("HumanoidRootPart") and ch.HumanoidRootPart.Position or Vector3.zero

    local function addItem(root, intObj)
        if not root then return end
        local name = root.Name
        if name == "Terrain" or name == "Camera" or name == "SpawnLocation" then return end
        for _, item in ipairs(FoundItems) do
            if item.container == root then return end
        end
        local pos = nil
        local searchRoot = root
        while searchRoot and searchRoot ~= workspace do
            if searchRoot:IsA("BasePart") then
                pos = searchRoot.Position
                root = searchRoot
                break
            elseif searchRoot:IsA("Model") then
                local pp = searchRoot.PrimaryPart or searchRoot:FindFirstChildWhichIsA("BasePart")
                if pp then
                    pos = pp.Position
                    root = searchRoot
                    break
                end
            end
            searchRoot = searchRoot.Parent
        end
        if not pos and intObj then
            local p = intObj.Parent
            if p and p:IsA("BasePart") then pos = p.Position; root = p end
        end
        if pos then
            table.insert(FoundItems, {
                name = name,
                container = root,
                interaction = intObj,
                interactionType = intObj and intObj.ClassName or "Item",
                pos = pos
            })
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("ClickDetector") or obj:IsA("ProximityPrompt") then
                local root = obj
                while root and root.Parent and root.Parent ~= workspace do
                    root = root.Parent
                end
                if not root or root.Parent ~= workspace then root = obj.Parent end
                addItem(root, obj)
            elseif obj:IsA("TouchInterest") then
                local root = obj.Parent
                while root and root.Parent and root.Parent ~= workspace do
                    root = root.Parent
                end
                if not root or root.Parent ~= workspace then root = obj.Parent end
                addItem(root, obj)
            end
        end)
    end

    for _, child in ipairs(workspace:GetChildren()) do
        pcall(function()
            if child:IsA("Model") or child:IsA("Folder") then
                local int = child:FindFirstChildWhichIsA("ClickDetector", true)
                    or child:FindFirstChildWhichIsA("ProximityPrompt", true)
                    or child:FindFirstChildWhichIsA("TouchInterest", true)
                if int then
                    addItem(child, int)
                end
            elseif child:IsA("BasePart") then
                local int = child:FindFirstChildWhichIsA("ClickDetector")
                    or child:FindFirstChildWhichIsA("ProximityPrompt")
                    or child:FindFirstChildWhichIsA("TouchInterest")
                if int then
                    addItem(child, int)
                end
            end
        end)
    end

    table.sort(FoundItems, function(a, b)
        local da = (a.pos - myPos).Magnitude
        local db = (b.pos - myPos).Magnitude
        return da < db
    end)

    for idx, data in ipairs(FoundItems) do
        if ItemListFrame then
            local dist = math.floor((data.pos - myPos).Magnitude)
            local icon = "📦"
            if data.interactionType == "ClickDetector" then icon = "🖱️"
            elseif data.interactionType == "ProximityPrompt" then icon = "⚡"
            end

            local row = Instance.new("TextButton")
            row.Name = "Item_" .. idx
            row.Size = UDim2.new(1, -8, 0, 30)
            row.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
            row.BorderSizePixel = 0
            row.Text = ""
            row.AutoButtonColor = false
            row.LayoutOrder = 1000 + idx
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            local rowStroke = Instance.new("UIStroke")
            rowStroke.Color = Color3.fromRGB(60, 40, 100)
            rowStroke.Thickness = 1
            rowStroke.Transparency = 0.5
            rowStroke.Parent = row

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = row
            nameLabel.Size = UDim2.new(0.55, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 10, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = icon .. " " .. data.name
            nameLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
            nameLabel.TextSize = 11
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            local typeLabel = Instance.new("TextLabel")
            typeLabel.Parent = row
            typeLabel.Size = UDim2.new(0.2, 0, 1, 0)
            typeLabel.Position = UDim2.new(0.55, 0, 0, 0)
            typeLabel.BackgroundTransparency = 1
            typeLabel.Text = data.interactionType
            typeLabel.TextColor3 = Color3.fromRGB(150, 130, 200)
            typeLabel.TextSize = 9
            typeLabel.Font = Enum.Font.GothamMedium

            local distLabel = Instance.new("TextLabel")
            distLabel.Parent = row
            distLabel.Size = UDim2.new(0.12, 0, 1, 0)
            distLabel.Position = UDim2.new(0.75, 0, 0, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = dist .. "m"
            distLabel.TextColor3 = Color3.fromRGB(150, 130, 200)
            distLabel.TextSize = 10
            distLabel.Font = Enum.Font.GothamMedium

            local grabLabel = Instance.new("TextLabel")
            grabLabel.Parent = row
            grabLabel.Size = UDim2.new(0.13, 0, 1, 0)
            grabLabel.Position = UDim2.new(0.87, 0, 0, 0)
            grabLabel.BackgroundTransparency = 1
            grabLabel.Text = "GET →"
            grabLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
            grabLabel.TextSize = 10
            grabLabel.Font = Enum.Font.GothamBold

            row.MouseEnter:Connect(function()
                row.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
                rowStroke.Color = Color3.fromRGB(150, 70, 255)
                rowStroke.Transparency = 0
            end)
            row.MouseLeave:Connect(function()
                row.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
                rowStroke.Color = Color3.fromRGB(60, 40, 100)
                rowStroke.Transparency = 0.5
            end)

            local itemData = data
            row.MouseButton1Click:Connect(function()
                pcall(function()
                    local ch = player.Character
                    if ch then
                        local hrp = ch:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local origCF = hrp.CFrame
                            local itemName = itemData.name

                            hrp.CFrame = CFrame.new(itemData.pos + Vector3.new(0, 400, 0))
                            task.wait(0.05)
                            hrp.CFrame = CFrame.new(itemData.pos + Vector3.new(0, 3, 0))
                            task.wait(0.05)

                            local int = itemData.container:FindFirstChildWhichIsA("ClickDetector", true)
                                or itemData.container:FindFirstChildWhichIsA("ProximityPrompt", true)
                                or itemData.container:FindFirstChildWhichIsA("TouchInterest", true)
                            if int then
                                if int:IsA("ClickDetector") then
                                    fireclickdetector(int)
                                elseif int:IsA("ProximityPrompt") then
                                    fireproximityprompt(int)
                                end
                            end
                            task.wait(0.1)

                            local gotItem = false
                            local bp = player:FindFirstChild("Backpack")
                            if bp then
                                for _, v in ipairs(bp:GetChildren()) do
                                    if v.Name == itemName then gotItem = true; break end
                                end
                            end
                            local ch2 = player.Character
                            if ch2 then
                                for _, v in ipairs(ch2:GetChildren()) do
                                    if v:IsA("Tool") and v.Name == itemName then gotItem = true; break end
                                end
                            end

                            if gotItem then
                                grabLabel.Text = "✓ OK"
                                grabLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                            else
                                grabLabel.Text = "✗ miss"
                                grabLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                            end

                            task.wait(0.3)
                            hrp.CFrame = origCF

                            task.wait(1)
                            grabLabel.Text = "GET →"
                            grabLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
                        end
                    end
                end)
            end)

            row.Parent = ItemListFrame
            table.insert(ItemButtons, row)

            if ItemFinderESP then
                local part = nil
                if data.container:IsA("BasePart") then
                    part = data.container
                elseif data.container:IsA("Model") then
                    part = data.container.PrimaryPart or data.container:FindFirstChildWhichIsA("BasePart")
                end
                if part and not part:GetAttribute("EliteHubIFESP") then
                    local bb = Instance.new("BillboardGui")
                    bb.Size = UDim2.new(0, 120, 0, 20)
                    bb.AlwaysOnTop = true
                    bb.Adornee = part
                    bb.Parent = part
                    local tl = Instance.new("TextLabel")
                    tl.BackgroundTransparency = 1
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.Text = data.name .. " [" .. data.interactionType .. "]"
                    tl.TextColor3 = Color3.fromRGB(255, 200, 50)
                    tl.TextSize = 10
                    tl.Font = Enum.Font.GothamBold
                    tl.TextStrokeTransparency = 0
                    tl.Parent = bb
                    part:SetAttribute("EliteHubIFESP", true)
                end
            end
        end
    end
    return #FoundItems
end

local countLabel = ItemFinderTab:CreateLabel(L("NoItems"))
ItemListFrame = ItemFinderTab._scroll

local function refreshItemList()
    for _, btn in ipairs(ItemButtons) do
        pcall(function() btn:Destroy() end)
    end
    ItemButtons = {}
    local n = scanItems()
    countLabel:Set(L("Found") .. ": " .. tostring(n) .. " " .. L("items"))
end

ItemFinderTab:CreateButton({
    Name = L("Refresh"),
    Callback = function()
        refreshItemList()
    end
})

task.spawn(function()
    task.wait(0.5)
    refreshItemList()
end)
