repeat
    task.wait()
until game:IsLoaded()

do
    local function isAdonisAC(tab)
        return rawget(tab, "Detected")
            and typeof(rawget(tab, "Detected")) == "function"
            and rawget(tab, "RLocked")
    end

    for _, v in next, getgc(true) do
        if typeof(v) == "table" and isAdonisAC(v) then
            for i, f in next, v do
                if rawequal(i, "Detected") then
                    local old
                    old = hookfunction(f, function(action, info, crash)
                        if rawequal(action, "_") and rawequal(info, "_") and rawequal(crash, false) then
                            return old(action, info, crash)
                        end
                        return task.wait(9e9)
                    end)
                    warn("bypassed")
                    break
                end
            end
        end
    end
end
--Oh
for _, v in pairs(getgc(true)) do
if type(v) == "table" then
local func = rawget(v, "DTXC1")
if type(func) == "function" then
hookfunction(func, function() return end)
break
end
end
end
print("done")
getgenv().CONFIG = {
    Ragebot = {
        Enabled = false,
        RapidFire = false,
        FireRate = 30,
        Prediction = true,
        PredictionAmount = 0.12,
        TeamCheck = false,
        VisibilityCheck = true,
        FOV = 120,
        ShowFOV = true,
        Wallbang = true,
        Tracers = true,
        TracerColor = Color3.fromRGB(255, 0, 0),
        TracerWidth = 1,
        TracerLifetime = 3,
        ShootRange = 15,
        HitRange = 15,
        HitNotify = true,
        AutoReload = true,
        HitSound = true,
        HitColor = Color3.fromRGB(255, 182, 193),
        UseTargetList = false,
        UseWhitelist = false,
        HitNotifyDuration = 5,
        LowHealthCheck = false,
        SelectedHitSound = "skeet",
        FriendCheck = false,
        MaxTarget = 0
    },
    Misc = {
        SpeedEnabled = false,
        SpeedValue = 50,
        JumpPowerEnabled = false,
        JumpPowerValue = 100,
        LoopFOVEnabled = false,
        HideHeadEnabled = false,
        InfStaminaEnabled = false,
        NoFallDmgEnabled = false,
        SpeedConnection = nil,
        FOVConnection = nil,
        JumpPowerConnection = nil,
        NoFallHook = nil,
        InfStaminaHook = nil
    },
    Visualize = {
        ESP = {
            Enabled = false,
            BoxColor = Color3.fromRGB(78, 150, 50),
            OutlineColor = Color3.fromRGB(78, 150, 50),
            TextColor = Color3.fromRGB(255, 255, 255),
            MaxDistance = 1000
        },
        ForcefieldColor = Color3.fromRGB(255, 255, 255),
        ForcefieldTransparency = 0.5,
        LocalForcefieldEnabled = false,
        ArrowEnabled = false,
        ArrowColor = Color3.fromRGB(255, 255, 255),
        ArrowDistance = 80,
        ArrowSize = 16,
        ArrowThickness = 1,
        ArrowAA = false
    }
}

getgenv().Lists = {
    TargetList = {},
    Whitelist = {}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if makefolder then
    makefolder("a")
    makefolder("a/fonts")
end

if not isfile or (isfile and not isfile("a/fonts/main.ttf")) then
    if writefile then
        writefile("a/fonts/main.ttf", game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf"))
    end
end

local font_data = {
    name = "AFont",
    faces = {
        {
            name = "Regular",
            weight = 400,
            style = "normal",
            assetId = getcustomasset and getcustomasset("a/fonts/main.ttf") or ""
        }
    }
}

if writefile and not isfile("a/fonts/main_encoded.ttf") then
    writefile("a/fonts/main_encoded.ttf", game:GetService("HttpService"):JSONEncode(font_data))
end

local AFont = Font.new(getcustomasset and getcustomasset("a/fonts/main_encoded.ttf") or Enum.Font.Gotham, Enum.FontWeight.Regular)
--+ label.TextBounds.Xnotif.box == box thenfromRGB(255, 255, 255)},nextNotif.box.Parent = ScreenGui("%.2f", offsetValue).." ", getgenv().CONFIG.Ragebot.HitColor},= offsetX
local hitNotifications = {}
local notificationYOffset = 5
local MAX_VISIBLE_NOTIFICATIONS = 15

local function createHitNotification(toolName, offsetValue, playerName)
    if not getgenv().CONFIG.Ragebot.HitNotify then return end
    
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("HitNotifications") or Instance.new("ScreenGui")
    ScreenGui.Name = "HitNotifications"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local scrollFrame = ScreenGui:FindFirstChild("NotificationScroll") or Instance.new("ScrollingFrame")
    scrollFrame.Name = "NotificationScroll"
    scrollFrame.Parent = ScreenGui
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.Size = UDim2.new(0, 400, 0, 200)
    scrollFrame.Position = UDim2.new(0, 30, 0, 10)  
    scrollFrame.ScrollingEnabled = false
    scrollFrame.CanvasSize = UDim2.new(0, 400, 0, 0)
    scrollFrame.ScrollBarThickness = 0
    
    local box = Instance.new("Frame")
    box.Parent = scrollFrame
    box.BackgroundColor3 = Color3.new(0, 0, 0)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.AnchorPoint = Vector2.new(0, 0)
    
    local parts = {
        {"Using ", Color3.fromRGB(255, 255, 255)},
        {toolName.." ", getgenv().CONFIG.Ragebot.HitColor},
        {"On ", Color3.fromRGB(255, 255, 255)},
        {string.format("%.2f", offsetValue).." ", getgenv().CONFIG.Ragebot.HitColor},
        {"in the ", Color3.fromRGB(255, 255, 255)},
        {"head ", getgenv().CONFIG.Ragebot.HitColor},
        {"to hit ", Color3.fromRGB(255, 255, 255)},
        {playerName, getgenv().CONFIG.Ragebot.HitColor},
        {"on via cache", Color3.fromRGB(255, 255, 255)},
    }
    
    local offsetX = 8 
    local totalW, maxH = 0, 0
    
    for _, seg in ipairs(parts) do
        local txt, col = seg[1], seg[2]
        local label = Instance.new("TextLabel")
        label.Parent = box
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.TextColor3 = col
        label.FontFace = AFont
        label.TextSize = 10
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Text = txt
        label.AutomaticSize = Enum.AutomaticSize.XY
        label.Position = UDim2.new(0, offsetX, 0, 0)
        offsetX = offsetX + label.TextBounds.X
        totalW = offsetX
        maxH = math.max(maxH, label.TextBounds.Y)
    end
    
    box.Size = UDim2.new(0, totalW + 16, 0, maxH + 8) 
    
    table.insert(hitNotifications, {box = box, createTime = tick()})
    
    local totalHeight = 0
    for i, notif in ipairs(hitNotifications) do
        local yPos = (i - 1) * (notif.box.AbsoluteSize.Y + 5)
        notif.box.Position = UDim2.new(0, 0, 0, yPos)  
        totalHeight = totalHeight + notif.box.AbsoluteSize.Y + 5
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 400, 0, totalHeight)
    
    local function updateScrollFrame()
        local allFrames = {}
        for _, notif in ipairs(hitNotifications) do
            if notif.box and notif.box.Parent then
                table.insert(allFrames, notif)
            end
        end
        
        hitNotifications = allFrames
        
        local visibleCount = math.min(#hitNotifications, MAX_VISIBLE_NOTIFICATIONS)
        scrollFrame.CanvasSize = UDim2.new(0, 400, 0, visibleCount * (box.AbsoluteSize.Y + 5))
        
        for i, notif in ipairs(hitNotifications) do
            local yPos = (i - 1) * (notif.box.AbsoluteSize.Y + 5)
            notif.box.Position = UDim2.new(0, 0, 0, yPos)
            
            if i <= MAX_VISIBLE_NOTIFICATIONS then
                notif.box.Visible = true
            else
                notif.box.Visible = false
            end
        end
    end
    
    updateScrollFrame()
    
    task.delay(getgenv().CONFIG.Ragebot.HitNotifyDuration, function()
        for i, notif in ipairs(hitNotifications) do
            if notif.box == box then
                table.remove(hitNotifications, i)
                box:Destroy()
                break
            end
        end
        
        updateScrollFrame()
    end)
end
local function playHitSound()
    if not getgenv().CONFIG.Ragebot.HitSound then return end
    
    local soundIds = {
        ["skeet"] = "rbxassetid://4817809188",
        ["xp level"] = "rbxassetid://17148249625",
        ["bell"] = "rbxassetid://6534948092"
    }
    
    local soundId = soundIds[getgenv().CONFIG.Ragebot.SelectedHitSound] or soundIds["skeet"]
    
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 0.75
    sound.Parent = Workspace
    sound:Play()
    
    game:GetService("Debris"):AddItem(sound, 0.75)
end

local function getCurrentTool()
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                return tool
            end
        end
    end
    return nil
end

local function autoReload()
    if not getgenv().CONFIG.Ragebot.AutoReload then return end
    
    local tool = getCurrentTool()
    if not tool then return end
    
    local values = tool:FindFirstChild("Values")
    if not values then return end
    
    local ammo = values:FindFirstChild("SERVER_Ammo")
    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return end
    
    if ammo.Value <= 0 and storedAmmo.Value > 0 then
        local args = {
            tick(),
            "KLWE89U0",
            tool
        }
        local GNX_R = ReplicatedStorage:WaitForChild("Events"):WaitForChild("GNX_R")
        GNX_R:FireServer(unpack(args))
    end
end

local function canSeeTarget(targetPart)
    if not getgenv().CONFIG.Ragebot.VisibilityCheck then return true end
    
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return false end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local startPos = localHead.Position
    local endPos = targetPart.Position
    local direction = (endPos - startPos)
    local distance = direction.Magnitude
    
    local raycastResult = Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if humanoid then
                    local targetPlayer = Players:GetPlayerFromCharacter(model)
                    if targetPlayer then
                        return true
                    end
                end
            end
            return false
        end
    end
    
    local secondRaycast = Workspace:Raycast(startPos + direction.Unit * 0.5, direction.Unit * (distance - 0.5), raycastParams)
    if secondRaycast then
        local hitPart = secondRaycast.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if humanoid then
                    local targetPlayer = Players:GetPlayerFromCharacter(model)
                    if targetPlayer then
                        return true
                    end
                end
            end
            return false
        end
    end
    
    return true
end

local function getClosestTarget()
    local closest = nil
    local shortestDistance = math.huge
    local targetCount = 0
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        if getgenv().CONFIG.Ragebot.FriendCheck and LocalPlayer:IsFriendsWith(player.UserId) then
            continue
        end
        
        if getgenv().CONFIG.Ragebot.UseWhitelist and table.find(getgenv().Lists.Whitelist, player.Name) then
            continue
        end
        
        if getgenv().CONFIG.Ragebot.UseTargetList and not table.find(getgenv().Lists.TargetList, player.Name) then
            continue
        end
        
        if getgenv().CONFIG.Ragebot.TeamCheck and player.Team == LocalPlayer.Team then continue end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local head = character:FindFirstChild("Head")
            
            if humanoid and humanoid.Health > 0 and head then
                local hasForcefield = false
                for _, child in pairs(character:GetChildren()) do
                    if child:IsA("ForceField") then
                        hasForcefield = true
                        break
                    end
                end
                
                if hasForcefield then continue end
        
                if getgenv().CONFIG.Ragebot.LowHealthCheck and humanoid.Health < 15 then continue end
                
                local distance = (head.Position - LocalPlayer.Character.Head.Position).Magnitude
                
                if getgenv().CONFIG.Ragebot.MaxTarget > 0 then
                    targetCount = targetCount + 1
                    if targetCount > getgenv().CONFIG.Ragebot.MaxTarget then
                        break
                    end
                end
                
                if distance < shortestDistance then
                    if canSeeTarget(head) then
                        closest = head
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closest
end

local function checkClearPath(startPos, endPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local direction = (endPos - startPos)
    local distance = direction.Magnitude
    
    local raycastResult = Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if not humanoid then
                    return false
                end
            else
                return false
            end
        end
    end
    return true
end
--[[
local cachedBestPositions = {
    shootPos = nil,
    hitPos = nil,
    target = nil
}

local function wallbang()
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return nil end
    
    local target = getClosestTarget()
    if not target then 
        cachedBestPositions.shootPos = nil
        cachedBestPositions.hitPos = nil
        cachedBestPositions.target = nil
        return nil, nil
    end
    
    local startPos = localHead.Position
    local targetPos = target.Position
    
    if not getgenv().CONFIG.Ragebot.Wallbang then
        cachedBestPositions.shootPos = startPos
        cachedBestPositions.hitPos = targetPos
        cachedBestPositions.target = target
        return startPos, targetPos
    end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local direction = targetPos - startPos
    local distance = direction.Magnitude
    local directRay = Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if not directRay then
        cachedBestPositions.shootPos = startPos
        cachedBestPositions.hitPos = targetPos
        cachedBestPositions.target = target
        return startPos, targetPos
    end
    
    if cachedBestPositions.shootPos and cachedBestPositions.target == target then
        local cachedShootDistance = (cachedBestPositions.shootPos - startPos).Magnitude
        local cachedHitDistance = (cachedBestPositions.hitPos - targetPos).Magnitude
        
        if cachedShootDistance <= getgenv().CONFIG.Ragebot.ShootRange and 
           cachedHitDistance <= getgenv().CONFIG.Ragebot.HitRange then
            
            local pathToShoot = checkClearPath(startPos, cachedBestPositions.shootPos)
            local pathToTarget = checkClearPath(cachedBestPositions.shootPos, cachedBestPositions.hitPos)
            
            if pathToShoot and pathToTarget then
                local shootToHitRay = Workspace:Raycast(cachedBestPositions.shootPos, (cachedBestPositions.hitPos - cachedBestPositions.shootPos).Unit * (cachedBestPositions.hitPos - cachedBestPositions.shootPos).Magnitude, raycastParams)
                if not shootToHitRay then
                    return cachedBestPositions.shootPos, cachedBestPositions.hitPos
                end
            end
        end
        cachedBestPositions.shootPos = nil
        cachedBestPositions.hitPos = nil
    end
    
    local bestShootPos = nil
    local bestHitPos = nil
    local bestScore = math.huge
    
    for i = 1, 150 do
        local shootOffset = Vector3.new(
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange),
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange),
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange)
        )
        local shootPos = startPos + shootOffset
        
        local hitOffset = Vector3.new(
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange),
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange),
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange)
        )
        local hitPos = targetPos + hitOffset
        
        local shootDistance = (shootPos - startPos).Magnitude
        local hitDistance = (hitPos - targetPos).Magnitude
        
        if shootDistance <= getgenv().CONFIG.Ragebot.ShootRange and hitDistance <= getgenv().CONFIG.Ragebot.HitRange then
            local pathToShoot = checkClearPath(startPos, shootPos)
            local pathToTarget = checkClearPath(shootPos, hitPos)
            
            if pathToShoot and pathToTarget then
                local shootToHitRay = Workspace:Raycast(shootPos, (hitPos - shootPos).Unit * (hitPos - shootPos).Magnitude, raycastParams)
                if not shootToHitRay then
                    local totalScore = shootDistance + hitDistance
                    
                    if totalScore < bestScore then
                        bestScore = totalScore
                        bestShootPos = shootPos
                        bestHitPos = hitPos
                    end
                end
            end
        end
    end
    
    if not bestShootPos or not bestHitPos then
        local randomY = math.random(-16, -14)
        local bestFallbackScore = math.huge
        local bestFallbackShootPos = nil
        local bestFallbackHitPos = nil
        
        for i = 1, 99 do
            local shootXOffset = math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange)
            local shootZOffset = math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange)
            
            local hitXOffset = math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange)
            local hitZOffset = math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange)
            
            local fallbackShootPos = Vector3.new(startPos.X + shootXOffset, randomY, startPos.Z + shootZOffset)
            local fallbackHitPos = Vector3.new(targetPos.X + hitXOffset, randomY, targetPos.Z + hitZOffset)
            
            local fallbackShootDistance = (fallbackShootPos - startPos).Magnitude
            local fallbackHitDistance = (fallbackHitPos - targetPos).Magnitude
            
            if fallbackShootDistance <= getgenv().CONFIG.Ragebot.ShootRange and 
               fallbackHitDistance <= getgenv().CONFIG.Ragebot.HitRange then
                
                local pathToFallbackShoot = checkClearPath(startPos, fallbackShootPos)
                local pathToFallbackTarget = checkClearPath(fallbackShootPos, fallbackHitPos)
                
                if pathToFallbackShoot and pathToFallbackTarget then
                    local fallbackShootToHitRay = Workspace:Raycast(fallbackShootPos, (fallbackHitPos - fallbackShootPos).Unit * (fallbackHitPos - fallbackShootPos).Magnitude, raycastParams)
                    if not fallbackShootToHitRay then
                        local totalFallbackScore = fallbackShootDistance + fallbackHitDistance
                        
                        if totalFallbackScore < bestFallbackScore then
                            bestFallbackScore = totalFallbackScore
                            bestFallbackShootPos = fallbackShootPos
                            bestFallbackHitPos = fallbackHitPos
                        end
                    end
                end
            end
        end
        
        if bestFallbackShootPos and bestFallbackHitPos then
            cachedBestPositions.shootPos = bestFallbackShootPos
            cachedBestPositions.hitPos = bestFallbackHitPos
            cachedBestPositions.target = target
            
            return bestFallbackShootPos, bestFallbackHitPos
        else
            local clampedShootX = math.clamp(math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange), -getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange)
            local clampedShootZ = math.clamp(math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange), -getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange)
            
            local clampedHitX = math.clamp(math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange), -getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange)
            local clampedHitZ = math.clamp(math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange), -getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange)
            
            local finalFallbackShootPos = Vector3.new(startPos.X + clampedShootX, randomY, startPos.Z + clampedShootZ)
            local finalFallbackHitPos = Vector3.new(targetPos.X + clampedHitX, randomY, targetPos.Z + clampedHitZ)
            
            cachedBestPositions.shootPos = finalFallbackShootPos
            cachedBestPositions.hitPos = finalFallbackHitPos
            cachedBestPositions.target = target
            
            return finalFallbackShootPos, finalFallbackHitPos
        end
    end
    
    cachedBestPositions.shootPos = bestShootPos
    cachedBestPositions.hitPos = bestHitPos
    cachedBestPositions.target = target
    
    return bestShootPos, bestHitPos
end
--]]
--[[
local cachedBestPositions = {
    shootPos = nil,
    hitPos = nil,
    target = nil
}

local function wallbang()
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return nil end
    
    local target = getClosestTarget()
    if not target then 
        cachedBestPositions.shootPos = nil
        cachedBestPositions.hitPos = nil
        cachedBestPositions.target = nil
        return nil, nil
    end
    
    local startPos = localHead.Position
    local targetPos = target.Position
    
    if not getgenv().CONFIG.Ragebot.Wallbang then
        cachedBestPositions.shootPos = startPos
        cachedBestPositions.hitPos = targetPos
        cachedBestPositions.target = target
        return startPos, targetPos
    end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local direction = targetPos - startPos
    local distance = direction.Magnitude
    local directRay = Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if not directRay then
        cachedBestPositions.shootPos = startPos
        cachedBestPositions.hitPos = targetPos
        cachedBestPositions.target = target
        return startPos, targetPos
    end
    
    if cachedBestPositions.shootPos and cachedBestPositions.target == target then
        local cachedShootDistance = (cachedBestPositions.shootPos - startPos).Magnitude
        local cachedHitDistance = (cachedBestPositions.hitPos - targetPos).Magnitude
        
        if cachedShootDistance <= getgenv().CONFIG.Ragebot.ShootRange and 
           cachedHitDistance <= getgenv().CONFIG.Ragebot.HitRange then
            
            local pathToShoot = checkClearPath(startPos, cachedBestPositions.shootPos)
            local pathToTarget = checkClearPath(cachedBestPositions.shootPos, cachedBestPositions.hitPos)
            
            if pathToShoot and pathToTarget then
                local shootToHitRay = Workspace:Raycast(cachedBestPositions.shootPos, (cachedBestPositions.hitPos - cachedBestPositions.shootPos).Unit * (cachedBestPositions.hitPos - cachedBestPositions.shootPos).Magnitude, raycastParams)
                if not shootToHitRay then
                    return cachedBestPositions.shootPos, cachedBestPositions.hitPos
                end
            end
        end
        cachedBestPositions.shootPos = nil
        cachedBestPositions.hitPos = nil
    end
    
    local bestShootPos = nil
    local bestHitPos = nil
    local bestScore = math.huge
    
    for i = 1, 150 do
        local shootOffset = Vector3.new(
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange),
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange),
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange)
        )
        local shootPos = startPos + shootOffset
        
        local hitOffset = Vector3.new(
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange),
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange),
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange)
        )
        local hitPos = targetPos + hitOffset
        
        local shootDistance = (shootPos - startPos).Magnitude
        local hitDistance = (hitPos - targetPos).Magnitude
        
        if shootDistance <= getgenv().CONFIG.Ragebot.ShootRange and hitDistance <= getgenv().CONFIG.Ragebot.HitRange then
            local pathToShoot = checkClearPath(startPos, shootPos)
            local pathToTarget = checkClearPath(shootPos, hitPos)
            
            if pathToShoot and pathToTarget then
                local shootToHitRay = Workspace:Raycast(shootPos, (hitPos - shootPos).Unit * (hitPos - shootPos).Magnitude, raycastParams)
                if not shootToHitRay then
                    local totalScore = shootDistance + hitDistance
                    
                    if totalScore < bestScore then
                        bestScore = totalScore
                        bestShootPos = shootPos
                        bestHitPos = hitPos
                    end
                end
            end
        end
    end
    
    if not bestShootPos or not bestHitPos then
        local undergroundRangeMin = 10
        local undergroundRangeMax = 13
        local bestUndergroundScore = math.huge
        local bestUndergroundShootPos = nil
        local bestUndergroundHitPos = nil
        
        for i = 1, 100 do
            local shootXOffset = math.random(-undergroundRangeMax, undergroundRangeMax)
            local shootZOffset = math.random(-undergroundRangeMax, undergroundRangeMax)
            local shootYOffset = math.random(undergroundRangeMin, undergroundRangeMax)
            
            local hitXOffset = math.random(-undergroundRangeMax, undergroundRangeMax)
            local hitZOffset = math.random(-undergroundRangeMax, undergroundRangeMax)
            local hitYOffset = math.random(undergroundRangeMin, undergroundRangeMax)
            
            local undergroundShootPos = Vector3.new(startPos.X + shootXOffset, -16, startPos.Z + shootZOffset)
            local undergroundHitPos = Vector3.new(targetPos.X + hitXOffset, -16, targetPos.Z + hitZOffset)
            
            local shootDistance = (undergroundShootPos - startPos).Magnitude
            local hitDistance = (undergroundHitPos - targetPos).Magnitude
            
            if shootDistance >= undergroundRangeMin and shootDistance <= undergroundRangeMax and
               hitDistance >= undergroundRangeMin and hitDistance <= undergroundRangeMax then
                
                local pathToShoot = checkClearPath(startPos, undergroundShootPos)
                local pathToTarget = checkClearPath(undergroundShootPos, undergroundHitPos)
                
                if pathToShoot and pathToTarget then
                    local shootToHitRay = Workspace:Raycast(undergroundShootPos, (undergroundHitPos - undergroundShootPos).Unit * (undergroundHitPos - undergroundShootPos).Magnitude, raycastParams)
                    if not shootToHitRay then
                        local totalScore = shootDistance + hitDistance
                        
                        if totalScore < bestUndergroundScore then
                            bestUndergroundScore = totalScore
                            bestUndergroundShootPos = undergroundShootPos
                            bestUndergroundHitPos = undergroundHitPos
                        end
                    end
                end
            end
        end
        
        if bestUndergroundShootPos and bestUndergroundHitPos then
            cachedBestPositions.shootPos = bestUndergroundShootPos
            cachedBestPositions.hitPos = bestUndergroundHitPos
            cachedBestPositions.target = target
            
            return bestUndergroundShootPos, bestUndergroundHitPos
        else
            local fallbackShootY = -math.random(undergroundRangeMin, undergroundRangeMax)
            local fallbackHitY = -math.random(undergroundRangeMin, undergroundRangeMax)
            
            local fallbackShootPos = Vector3.new(startPos.X, startPos.Y + fallbackShootY, startPos.Z)
            local fallbackHitPos = Vector3.new(targetPos.X, targetPos.Y + fallbackHitY, targetPos.Z)
            
            cachedBestPositions.shootPos = fallbackShootPos
            cachedBestPositions.hitPos = fallbackHitPos
            cachedBestPositions.target = target
            
            return fallbackShootPos, fallbackHitPos
        end
    end
    
    cachedBestPositions.shootPos = bestShootPos
    cachedBestPositions.hitPos = bestHitPos
    cachedBestPositions.target = target
    
    return bestShootPos, bestHitPos
end
--]]
local cachedBestPositions = {
    shootPos = nil,
    hitPos = nil,
    target = nil
}

local function wallbang()
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return nil end
    
    local target = getClosestTarget()
    if not target then 
        cachedBestPositions.shootPos = nil
        cachedBestPositions.hitPos = nil
        cachedBestPositions.target = nil
        return nil, nil
    end
    
    local startPos = localHead.Position
    local targetPos = target.Position
    
    if not getgenv().CONFIG.Ragebot.Wallbang then
        cachedBestPositions.shootPos = startPos
        cachedBestPositions.hitPos = targetPos
        cachedBestPositions.target = target
        return startPos, targetPos
    end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local direction = targetPos - startPos
    local distance = direction.Magnitude
    local directRay = Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if not directRay then
        cachedBestPositions.shootPos = startPos
        cachedBestPositions.hitPos = targetPos
        cachedBestPositions.target = target
        return startPos, targetPos
    end
    
    if cachedBestPositions.shootPos and cachedBestPositions.target == target then
        local cachedShootDistance = (cachedBestPositions.shootPos - startPos).Magnitude
        local cachedHitDistance = (cachedBestPositions.hitPos - targetPos).Magnitude
        
        if cachedShootDistance <= getgenv().CONFIG.Ragebot.ShootRange and 
           cachedHitDistance <= getgenv().CONFIG.Ragebot.HitRange then
            
            local pathToShoot = checkClearPath(startPos, cachedBestPositions.shootPos)
            local pathToTarget = checkClearPath(cachedBestPositions.shootPos, cachedBestPositions.hitPos)
            
            if pathToShoot and pathToTarget then
                local shootToHitRay = Workspace:Raycast(cachedBestPositions.shootPos, (cachedBestPositions.hitPos - cachedBestPositions.shootPos).Unit * (cachedBestPositions.hitPos - cachedBestPositions.shootPos).Magnitude, raycastParams)
                if not shootToHitRay then
                    return cachedBestPositions.shootPos, cachedBestPositions.hitPos
                end
            end
        end
        cachedBestPositions.shootPos = nil
        cachedBestPositions.hitPos = nil
    end
    
    local bestShootPos = nil
    local bestHitPos = nil
    local bestScore = math.huge
    
    for i = 1, 100 do
        local shootOffset = Vector3.new(
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange),
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange),
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange)
        )
        local shootPos = startPos + shootOffset
        
        local hitOffset = Vector3.new(
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange),
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange),
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange)
        )
        local hitPos = targetPos + hitOffset
        
        local shootDistance = (shootPos - startPos).Magnitude
        local hitDistance = (hitPos - targetPos).Magnitude
        
        if shootDistance <= getgenv().CONFIG.Ragebot.ShootRange and hitDistance <= getgenv().CONFIG.Ragebot.HitRange then
            local pathToShoot = checkClearPath(startPos, shootPos)
            local pathToTarget = checkClearPath(shootPos, hitPos)
            
            if pathToShoot and pathToTarget then
                local shootToHitRay = Workspace:Raycast(shootPos, (hitPos - shootPos).Unit * (hitPos - shootPos).Magnitude, raycastParams)
                if not shootToHitRay then
                    local totalScore = shootDistance + hitDistance
                    
                    if totalScore < bestScore then
                        bestScore = totalScore
                        bestShootPos = shootPos
                        bestHitPos = hitPos
                    end
                end
            end
        end
    end
    
    if not bestShootPos or not bestHitPos then
        local randomY = math.random(-16, -14)
        local fallbackShootPos = Vector3.new(startPos.X, randomY, startPos.Z)
        local fallbackHitPos = Vector3.new(targetPos.X, randomY, targetPos.Z)
        
        cachedBestPositions.shootPos = fallbackShootPos
        cachedBestPositions.hitPos = fallbackHitPos
        cachedBestPositions.target = target
        
        return fallbackShootPos, fallbackHitPos
    end
    
    cachedBestPositions.shootPos = bestShootPos
    cachedBestPositions.hitPos = bestHitPos
    cachedBestPositions.target = target
    
    return bestShootPos, bestHitPos
end

local function createTracer(startPos, endPos)
    if not getgenv().CONFIG.Ragebot.Tracers then return end
    
    local tracerModel = Instance.new("Model")
    tracerModel.Name = "TracerBeam"
    
    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(getgenv().CONFIG.Ragebot.TracerColor)
    beam.Width0 = getgenv().CONFIG.Ragebot.TracerWidth
    beam.Width1 = getgenv().CONFIG.Ragebot.TracerWidth
    beam.Texture = "rbxassetid://7136858729"
    beam.TextureSpeed = 1
    beam.Brightness = 2
    beam.LightEmission = 2
    beam.FaceCamera = true
    
    local a0 = Instance.new("Attachment")
    local a1 = Instance.new("Attachment")
    a0.WorldPosition = startPos
    a1.WorldPosition = endPos
    beam.Attachment0 = a0
    beam.Attachment1 = a1
    
    beam.Parent = tracerModel
    a0.Parent = tracerModel
    a1.Parent = tracerModel
    tracerModel.Parent = Workspace
    
    local tweenInfo = TweenInfo.new(
        getgenv().CONFIG.Ragebot.TracerLifetime,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(beam, tweenInfo, {
        Brightness = 0
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        if tracerModel then 
            tracerModel:Destroy() 
        end
    end)
end

local function RandomString(length)
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, length do
        result = result .. charset:sub(math.random(1, #charset), math.random(1, #charset))
    end
    return result
end

local function shootAtTarget(targetHead)
    if not targetHead then return false end
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return false end
    local tool = getCurrentTool()
    if not tool then return false end
    local values = tool:FindFirstChild("Values")
    local hitMarker = tool:FindFirstChild("Hitmarker")
    if not values or not hitMarker then return false end
    local ammo = values:FindFirstChild("SERVER_Ammo")
    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return false end
    if ammo.Value <= 0 then
        autoReload()
        return false
    end

    local bestShootPos, bestHitPos = wallbang()
    
    if not bestShootPos or not bestHitPos then
        return false
    end
    local hitPosition = bestHitPos
  
    if getgenv().CONFIG.Ragebot.Prediction then
        local velocity = targetHead.Velocity or Vector3.zero
        hitPosition = hitPosition + velocity * getgenv().CONFIG.Ragebot.PredictionAmount
    end

    local hitDirection = (hitPosition - bestShootPos).Unit
    local randomKey = RandomString(30) .. "0"
    local args1 = {tick(), randomKey, tool, "FDS9I83", bestShootPos, {hitDirection}, false}
    local args2 = {"🧈", tool, randomKey, 1, targetHead, hitPosition, hitDirection}
    local events = ReplicatedStorage:WaitForChild("Events")
    local GNX_S = events:WaitForChild("GNX_S")
    local ZFKLF__H = events:WaitForChild("ZFKLF__H")
    local targetPlayer = Players:GetPlayerFromCharacter(targetHead.Parent)
    if targetPlayer then
        createHitNotification(tool.Name, (bestShootPos - localHead.Position).Magnitude, targetPlayer.Name)
        playHitSound()
    end

    
        GNX_S:FireServer(unpack(args1))
        ZFKLF__H:FireServer(unpack(args2))
    

    --ammo.Value = math.max(ammo.Value - 1, 0)
    hitMarker:Fire(targetHead)
    storedAmmo.Value = storedAmmo.Value
    createTracer(bestShootPos, hitPosition)
    return true
end
local lastShotTime = 0

RunService.Heartbeat:Connect(function()
    if not getgenv().CONFIG.Ragebot.Enabled then return end
    if not LocalPlayer.Character then return end
    if not LocalPlayer.Character:FindFirstChild("Head") then return end
    
    local target = getClosestTarget()
    if not target then return end
    
    local currentTime = tick()
    local baseWaitTime = 1 / (getgenv().CONFIG.Ragebot.FireRate * 0.05)
    local WaitTime = 1 / (getgenv().CONFIG.Ragebot.FireRate * 1)
    if getgenv().CONFIG.Ragebot.RapidFire then
        local rapidWaitTime = baseWaitTime * 0.01
        
        if currentTime - lastShotTime >= rapidWaitTime then
            shootAtTarget(target)
            wait(0.25)
            shootAtTarget(target)
            lastShotTime = currentTime
        end
    else
        if currentTime - lastShotTime >= WaitTime then
            shootAtTarget(target)
            lastShotTime = currentTime
        end
    end
end)
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = getgenv().CONFIG.Ragebot.ShowFOV
fovCircle.Radius = getgenv().CONFIG.Ragebot.FOV
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1
fovCircle.Filled = false

RunService.RenderStepped:Connect(function()
    fovCircle.Visible = getgenv().CONFIG.Ragebot.ShowFOV and getgenv().CONFIG.Ragebot.Enabled
    fovCircle.Radius = getgenv().CONFIG.Ragebot.FOV
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)
local function enableSpeed()
    if getgenv().CONFIG.Misc.SpeedConnection then
        getgenv().CONFIG.Misc.SpeedConnection:Disconnect()
        getgenv().CONFIG.Misc.SpeedConnection = nil
    end

    getgenv().CONFIG.Misc.SpeedConnection = game:GetService("RunService").RenderStepped:Connect(function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then return end

        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end

        humanoid.WalkSpeed = getgenv().CONFIG.Misc.SpeedValue
    end)
end

local function disableSpeed()
    if getgenv().CONFIG.Misc.SpeedConnection then
        getgenv().CONFIG.Misc.SpeedConnection:Disconnect()
        getgenv().CONFIG.Misc.SpeedConnection = nil
    end

    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = 16 end
    end
end

local function enableJumpPower()
    if getgenv().CONFIG.Misc.JumpPowerConnection then
        getgenv().CONFIG.Misc.JumpPowerConnection:Disconnect()
        getgenv().CONFIG.Misc.JumpPowerConnection = nil
    end
    
    getgenv().CONFIG.Misc.JumpPowerConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not getgenv().CONFIG.Misc.JumpPowerEnabled then return end
        if not game.Players.LocalPlayer.Character then return end
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, getgenv().CONFIG.Misc.JumpPowerValue, hrp.Velocity.Z)
        end
    end)
end

local function disableJumpPower()
    if getgenv().CONFIG.Misc.JumpPowerConnection then
        getgenv().CONFIG.Misc.JumpPowerConnection:Disconnect()
        getgenv().CONFIG.Misc.JumpPowerConnection = nil
    end
end

local function enableLoopFOV()
    if getgenv().CONFIG.Misc.FOVConnection then
        getgenv().CONFIG.Misc.FOVConnection:Disconnect()
        getgenv().CONFIG.Misc.FOVConnection = nil
    end
    
    getgenv().CONFIG.Misc.FOVConnection = game:GetService("RunService").RenderStepped:Connect(function()
        workspace.CurrentCamera.FieldOfView = 120
    end)
end

local function disableLoopFOV()
    if getgenv().CONFIG.Misc.FOVConnection then
        getgenv().CONFIG.Misc.FOVConnection:Disconnect()
        getgenv().CONFIG.Misc.FOVConnection = nil
    end
end

local runserviceConnection = nil
local originalMotors = {}
local toolTransparencies = {}

local function getCurrentTool()
    local char = game.Players.LocalPlayer.Character
    if not char then return nil end
    
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") then
            return item
        end
    end
    
    return nil
end
--[[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local char = nil
local torso = nil
local originalMotorData = {}
local renderConnection = nil
local tool = nil
local originalCameraCFrame = nil
local originalNamecall = nil

local function hideHeadFE()
    if not game.Players.LocalPlayer.Character then return end
    
    char = game.Players.LocalPlayer.Character
    local humanoid = char:WaitForChild("Humanoid")
    torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    
    if not torso then return end
    
    originalCameraCFrame = workspace.CurrentCamera.CFrame
    
    local camera = workspace.CurrentCamera
    local cameraPosition = camera.CFrame.Position
    local lookUpCFrame = CFrame.new(cameraPosition, cameraPosition + Vector3.new(0, 1, 0))
    camera.CFrame = lookUpCFrame
    
    local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
    tool = char:FindFirstChildWhichIsA("Tool")
    
    local validTools = {}
    
    if not tool and backpack then
        for _, child in pairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                local values = child:FindFirstChild("Values")
                if values then
                    local ammo = values:FindFirstChild("SERVER_Ammo")
                    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
                    
                    if ammo and storedAmmo then
                        table.insert(validTools, child)
                    end
                end
            end
        end
        
        if #validTools > 0 then
            local randomIndex = math.random(1, #validTools)
            tool = validTools[randomIndex]
            tool.Parent = char
        end
    elseif tool then
        local values = tool:FindFirstChild("Values")
        if values then
            local ammo = values:FindFirstChild("SERVER_Ammo")
            local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
            
            if not (ammo and storedAmmo) then
                tool = nil
            end
        end
    end
    
    originalMotorData = {}
    
    for _, descendant in pairs(torso:GetDescendants()) do
        if descendant:IsA("Motor6D") then
            originalMotorData[descendant] = {
                C0 = descendant.C0,
                C1 = descendant.C1
            }
        end
    end
    camera.CFrame = originalCameraCFrame
    
    
    if renderConnection then
        renderConnection:Disconnect()
    end
    
    renderConnection = RunService.RenderStepped:Connect(function()
        if torso and torso.Parent then
            for motor, data in pairs(originalMotorData) do
                if motor and motor.Parent then
                    motor.C0 = data.C0
                    motor.C1 = data.C1
                end
            end
        else
            if renderConnection then
                renderConnection:Disconnect()
                renderConnection = nil
            end
        end
    end)
end
--]]
local function showHeadFE()
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
    
    if hookmetamethod and originalNamecall then
        hookmetamethod(game, "__namecall", originalNamecall)
        originalNamecall = nil
    end
    
    local camera = workspace.CurrentCamera
    if originalCameraCFrame then
        camera.CFrame = originalCameraCFrame
        originalCameraCFrame = nil
    end
    
    if char and tool and tool.Parent == char then
        tool.Parent = game.Players.LocalPlayer.Backpack
    end
    
    for motor, data in pairs(originalMotorData) do
        if motor and motor.Parent then
            motor.C0 = data.C0
            motor.C1 = data.C1
        end
    end
    
    originalMotorData = {}
    char = nil
    torso = nil
    tool = nil
end
--[[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local char = nil
local head = nil
local torso = nil
local animTrack = nil
local originalNamecall = nil
local runserviceConnection = nil

local function hideHeadFE()
    if not game.Players.LocalPlayer.Character then return end
    
    char = game.Players.LocalPlayer.Character
    local humanoid = char:WaitForChild("Humanoid")
    torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    head = char:FindFirstChild("Head")
    
    if not torso or not head then return end
    
    local animator = humanoid:WaitForChild("Animator")
    
    local animationId = 68339848
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animationId
    
    animTrack = animator:LoadAnimation(animation)
    animTrack:Play()
    animTrack:AdjustSpeed(0)
    animTrack.TimePosition = 0
    
    local neck = Instance.new("Motor6D")
    neck.Name = "Neck"
    neck.Part0 = torso
    neck.Part1 = head
    neck.C0 = CFrame.new(0, 0, 0)
    neck.C1 = CFrame.new(0, 0, 0)
    neck.Parent = head
    
    neck.C0 = neck.C0 * CFrame.new(0, -1.5, 2.5)
    
    if hookmetamethod then
        local originalHook
        originalHook = hookmetamethod(game, "__namecall", function(self, ...)
            local methodName = getnamecallmethod()
            
            if tostring(methodName) == "FireServer" then
                if self.Name == "MOVZREP" then
                    local fixedArguments = {
                        {
                            {
                                Vector3.new(-5721.2001953125, 9834.1708984375, 971.5162353515625),
                                Vector3.new(-4181.38818359375, 0.3198874592781067, 11.123311996459961),
                                Vector3.new(0.006237113382667303, 0.9833956360816956, -0.18136750161647797),
                                true,
                                true,
                                true,
                                false
                            },
                            false,
                            false,
                            15.8
                        }
                    }
                    
                    return originalHook(self, table.unpack(fixedArguments))
                end
            end
            
            return originalHook(self, ...)
        end)
        originalNamecall = originalHook
    end
    
    if runserviceConnection then
        runserviceConnection:Disconnect()
    end
end

local function showHeadFE()
    if runserviceConnection then
        runserviceConnection:Disconnect()
        runserviceConnection = nil
    end
    
    if char and head and torso then
        local neck = head:FindFirstChild("Neck")
        if neck then
            neck:Destroy()
            local newNeck = Instance.new("Motor6D")
            newNeck.Name = "Neck"
            newNeck.Part0 = torso
            newNeck.Part1 = head
            newNeck.C0 = CFrame.new(0, 1, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
            newNeck.C1 = CFrame.new(0, -0.5, 0, -1, 0, 0, 0, 0, 1, 0, 1, -0)
            newNeck.Parent = head
        end
    end
    
    if animTrack then
        animTrack:Stop()
        animTrack = nil
    end
    
    if hookmetamethod and originalNamecall then
        hookmetamethod(game, "__namecall", originalNamecall)
        originalNamecall = nil
    end
    
    char = nil
    head = nil
    torso = nil
end
--]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local char = nil
local torso = nil
local originalNeckData = nil
local renderConnection = nil
local tool = nil
local originalCameraCFrame = nil
local originalNamecall = nil
local hookEnabled = false

local function hideHeadFE()
    if not game.Players.LocalPlayer.Character then return end
    
    local player = Players.LocalPlayer
    char = player.Character
    local head = char:WaitForChild("Head")
    torso = char:FindFirstChild("Torso")
    
    if not torso then return end
    
    local neck = torso:FindFirstChild("Neck")
    if neck then
        originalNeckData = {
            Part0 = neck.Part0,
            Part1 = neck.Part1,
            C0 = neck.C0,
            C1 = neck.C1
        }
        
        neck.Part0 = torso
        neck.Part1 = head
        neck.C0 = CFrame.new(0, -0.25, 0) * CFrame.Angles(math.rad(-90), 0, 0)
        neck.C1 = CFrame.new(0, 0.5, 0)
    end
    
    if hookmetamethod and not hookEnabled then
        local originalHook
        originalHook = hookmetamethod(game, "__namecall", function(self, ...)
            local methodName = getnamecallmethod()
            
            if tostring(methodName) == "FireServer" then
                if self.Name == "MOVZREP" then
                    local fixedArguments = {
                        {
                            {
                                Vector3.new(-5721.2001953125, -5, 971.5162353515625),
                                Vector3.new(-4181.38818359375, -6, 11.123311996459961),
                                Vector3.new(0.006237113382667303, -6, -0.18136750161647797),
                                true,
                                true,
                                true,
                                false
                            },
                            false,
                            false,
                            15.8
                        }
                    }
                    
                    return originalHook(self, table.unpack(fixedArguments))
                end
            end
            
            return originalHook(self, ...)
        end)
        originalNamecall = originalHook
        hookEnabled = true
    end
    
    if renderConnection then
        renderConnection:Disconnect()
    end
    
    renderConnection = RunService.RenderStepped:Connect(function()
        if torso and torso.Parent then
            if neck and neck.Parent then
                neck.C0 = CFrame.new(0, -0.25, 0) * CFrame.Angles(math.rad(-90), 0, 0)
            end
        else
            if renderConnection then
                renderConnection:Disconnect()
                renderConnection = nil
            end
        end
    end)
end

local function showHeadFE()
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
    
    if hookmetamethod and originalNamecall then
        hookmetamethod(game, "__namecall", originalNamecall)
        originalNamecall = nil
        hookEnabled = false
    end
    
    if char and torso then
        local neck = torso:FindFirstChild("Neck")
        if neck and originalNeckData then
            neck.Part0 = originalNeckData.Part0
            neck.Part1 = originalNeckData.Part1
            neck.C0 = originalNeckData.C0
            neck.C1 = originalNeckData.C1
        end
    end
    
    originalNeckData = nil
    char = nil
    torso = nil
end
local function enableNoFallDmg()
    if getgenv().CONFIG.Misc.NoFallHook then getgenv().CONFIG.Misc.NoFallHook = nil end
    getgenv().CONFIG.Misc.NoFallHook = hookmetamethod(game, "__namecall", function(self, ...)
        local args = { ... }
        if getnamecallmethod() == "FireServer" and not checkcaller() and args[1] == "FlllD" and args[4] == false then
            args[2] = 0
            args[3] = 0
        end
        return getgenv().CONFIG.Misc.NoFallHook(self, unpack(args))
    end)
end

local function disableNoFallDmg()
    if getgenv().CONFIG.Misc.NoFallHook then getgenv().CONFIG.Misc.NoFallHook = nil end
end

local function enableInfStamina()
    local module
    for i, v in pairs(game:GetService("StarterPlayer").StarterPlayerScripts:GetDescendants()) do
        if v:IsA("ModuleScript") and v.Name == "XIIX" then module = v break end
    end
    if module then
        module = require(module)
        local ac = module["XIIX"]
        local glob = getfenv(ac)["_G"]
        local stamina = getupvalues((getupvalues(glob["S_Check"]))[2])[1]
        if stamina ~= nil then
            getgenv().CONFIG.Misc.InfStaminaHook = hookfunction(stamina, function() return 100, 100 end)
        end
    end
end

local function disableInfStamina()
    if getgenv().CONFIG.Misc.InfStaminaHook then getgenv().CONFIG.Misc.InfStaminaHook = nil end
end

local VisualizeObjects = {}

local function getHealthColor(health, maxHealth)
    local percent = health / maxHealth
    if percent > 0.5 then
        return Color3.fromRGB(50, 255, 50)
    elseif percent > 0.25 then
        return Color3.fromRGB(255, 255, 50)
    else
        return Color3.fromRGB(255, 50, 50)
    end
end

local function calculateDistance(pos1, pos2)
    return math.floor((pos1 - pos2).Magnitude)
end

local function makeVisualize(player)
    if player == LocalPlayer then return end
    
    local function setupVisualize(character)
        if not character then return end
        if VisualizeObjects[player] then return end
        
        local humanoid = character:WaitForChild("Humanoid", 5)
        local root = character:WaitForChild("HumanoidRootPart", 5)
        if not humanoid or not root then return end
        
        local visualizeData = {}
        VisualizeObjects[player] = visualizeData
        
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.new(0, 0, 0)
        highlight.FillTransparency = 1
        highlight.OutlineColor = getgenv().CONFIG.Visualize.ESP.OutlineColor
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = character
        highlight.Enabled = getgenv().CONFIG.Visualize.ESP.Enabled
        
        visualizeData.highlight = highlight
        
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = part
                box.AlwaysOnTop = true
                box.ZIndex = 0
                box.Size = part.Size
                box.Color3 = getgenv().CONFIG.Visualize.ESP.BoxColor
                box.Transparency = 0.9
                box.Visible = getgenv().CONFIG.Visualize.ESP.Enabled
                box.Parent = part
                
                if not visualizeData.boxes then visualizeData.boxes = {} end
                table.insert(visualizeData.boxes, box)
            end
        end
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "VisualizeTag"
        billboard.Adornee = root
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 3.5, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = getgenv().CONFIG.Visualize.ESP.MaxDistance
        billboard.Enabled = getgenv().CONFIG.Visualize.ESP.Enabled
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "VisualizeText"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Position = UDim2.new(0, 0, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = getgenv().CONFIG.Visualize.ESP.TextColor
        textLabel.TextSize = 14
        textLabel.TextStrokeTransparency = 0.5
        textLabel.FontFace = Font.new("rbxassetid://12187371840")
        textLabel.Parent = billboard
        textLabel.Visible = getgenv().CONFIG.Visualize.ESP.Enabled
        
        billboard.Parent = character
        
        visualizeData.billboard = billboard
        visualizeData.textLabel = textLabel
        
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not character or not humanoid or not humanoid.Parent or humanoid.Health <= 0 then
                if visualizeData.highlight then visualizeData.highlight:Destroy() end
                if visualizeData.boxes then
                    for _, box in pairs(visualizeData.boxes) do
                        box:Destroy()
                    end
                end
                if visualizeData.billboard then visualizeData.billboard:Destroy() end
                if connection then connection:Disconnect() end
                VisualizeObjects[player] = nil
                return
            end
            
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local distance = calculateDistance(LocalPlayer.Character.HumanoidRootPart.Position, root.Position)
                if distance > getgenv().CONFIG.Visualize.ESP.MaxDistance then
                    if visualizeData.highlight then visualizeData.highlight.Enabled = false end
                    if visualizeData.billboard then visualizeData.billboard.Enabled = false end
                    if visualizeData.boxes then
                        for _, box in pairs(visualizeData.boxes) do
                            box.Visible = false
                        end
                    end
                else
                    if visualizeData.highlight then visualizeData.highlight.Enabled = getgenv().CONFIG.Visualize.ESP.Enabled end
                    if visualizeData.billboard then visualizeData.billboard.Enabled = getgenv().CONFIG.Visualize.ESP.Enabled end
                    if visualizeData.boxes then
                        for _, box in pairs(visualizeData.boxes) do
                            box.Visible = getgenv().CONFIG.Visualize.ESP.Enabled
                        end
                    end
                end
                
                local healthColor = getHealthColor(humanoid.Health, humanoid.MaxHealth)
                local healthText = tostring(math.floor(humanoid.Health))
                
                if visualizeData.textLabel then
                    visualizeData.textLabel.Text = string.format("%s 丨 %s 丨 %s studs", player.Name, healthText, distance)
                    visualizeData.textLabel.TextColor3 = healthColor
                    visualizeData.textLabel.Visible = getgenv().CONFIG.Visualize.ESP.Enabled
                end
            end
        end)
    end
    
    if player.Character then
        setupVisualize(player.Character)
    end
    
    player.CharacterAdded:Connect(function(character)
        setupVisualize(character)
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    makeVisualize(player)
end

Players.PlayerAdded:Connect(function(player)
    makeVisualize(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if VisualizeObjects[player] then
        local visualizeData = VisualizeObjects[player]
        if visualizeData.highlight then visualizeData.highlight:Destroy() end
        if visualizeData.boxes then
            for _, box in pairs(visualizeData.boxes) do
                box:Destroy()
            end
        end
        if visualizeData.billboard then visualizeData.billboard:Destroy() end
        VisualizeObjects[player] = nil
    end
end)

local bodyPartsForcefield = {}
local originalMaterials = {}
local originalColors = {}
local originalTransparency = {}

local function applyForcefieldToBodyParts()
    if LocalPlayer and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local bodyParts = {
            "Head",
            "Left Arm",
            "Left Leg",
            "Right Arm",
            "Right Leg",
            "Torso",
            "UpperTorso",
            "LowerTorso",
            "LeftUpperArm",
            "LeftLowerArm",
            "RightUpperArm",
            "RightLowerArm",
            "LeftUpperLeg",
            "LeftLowerLeg",
            "RightUpperLeg",
            "RightLowerLeg"
        }
        
        for _, partName in pairs(bodyParts) do
            local part = char:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                if not originalMaterials[part] then
                    originalMaterials[part] = part.Material
                    originalColors[part] = part.Color
                    originalTransparency[part] = part.Transparency
                end
                
                part.Material = Enum.Material.ForceField
                part.Color = getgenv().CONFIG.Visualize.ForcefieldColor
                part.Transparency = getgenv().CONFIG.Visualize.ForcefieldTransparency
                
                bodyPartsForcefield[part] = true
            end
        end
    end
end

local function removeForcefieldFromBodyParts()
    if LocalPlayer and LocalPlayer.Character then
        local char = LocalPlayer.Character
        
        for part, _ in pairs(bodyPartsForcefield) do
            if part and part.Parent == char then
                if originalMaterials[part] then
                    part.Material = originalMaterials[part]
                else
                    part.Material = Enum.Material.Plastic
                end
                
                if originalColors[part] then
                    part.Color = originalColors[part]
                end
                
                if originalTransparency[part] then
                    part.Transparency = originalTransparency[part]
                else
                    part.Transparency = 0
                end
            end
        end
        
        bodyPartsForcefield = {}
        originalMaterials = {}
        originalColors = {}
        originalTransparency = {}
    end
end
--[[
local ArrowIndicators = {}

local function GetRelative(pos, char)
    if not char then return Vector2.new(0,0) end

    local rootP = char.PrimaryPart.Position
    local camP = Camera.CFrame.Position
    local relative = CFrame.new(Vector3.new(rootP.X, camP.Y, rootP.Z), camP):PointToObjectSpace(pos)

    return Vector2.new(relative.X, relative.Z)
end

local function RelativeToCenter(v)
    return Camera.ViewportSize/2 - v
end

local function RotateVect(v, a)
    a = math.rad(a)
    local x = v.x * math.cos(a) - v.y * math.sin(a)
    local y = v.x * math.sin(a) + v.y * math.cos(a)

    return Vector2.new(x, y)
end

local function AntiA(v)
    if (not getgenv().CONFIG.Visualize.ArrowAA) then return v end
    return Vector2.new(math.round(v.x), math.round(v.y))
end

local function DrawTriangleLines(color)
    local line1 = Drawing.new("Line")
    local line2 = Drawing.new("Line")
    local line3 = Drawing.new("Line")
    
    line1.Visible = false
    line2.Visible = false
    line3.Visible = false
    
    line1.Color = color
    line2.Color = color
    line3.Color = color
    
    line1.Thickness = getgenv().CONFIG.Visualize.ArrowThickness
    line2.Thickness = getgenv().CONFIG.Visualize.ArrowThickness
    line3.Thickness = getgenv().CONFIG.Visualize.ArrowThickness
    
    line1.Transparency = 0
    line2.Transparency = 0
    line3.Transparency = 0
    
    return {line1, line2, line3}
end

local function UpdateTriangleLines(lines, pointA, pointB, pointC)
    lines[1].From = pointA
    lines[1].To = pointB
    
    lines[2].From = pointB
    lines[2].To = pointC
    
    lines[3].From = pointC
    lines[3].To = pointA
end

local function ShowArrow(PLAYER)
    local lines = DrawTriangleLines(getgenv().CONFIG.Visualize.ArrowColor)

    local function Update()
        local c
        c = RunService.RenderStepped:Connect(function()
            if PLAYER and PLAYER.Character then
                local CHAR = PLAYER.Character
                local HUM = CHAR:FindFirstChildOfClass("Humanoid")

                if HUM and CHAR.PrimaryPart ~= nil and HUM.Health > 0 then
                    local _,vis = Camera:WorldToViewportPoint(CHAR.PrimaryPart.Position)
                    if vis == false then
                        local rel = GetRelative(CHAR.PrimaryPart.Position, LocalPlayer.Character)
                        local direction = rel.Unit

                        local base  = direction * getgenv().CONFIG.Visualize.ArrowDistance
                        local sideLength = getgenv().CONFIG.Visualize.ArrowSize/2
                        local baseL = base + RotateVect(direction, 90) * sideLength
                        local baseR = base + RotateVect(direction, -90) * sideLength

                        local tip = direction * (getgenv().CONFIG.Visualize.ArrowDistance + getgenv().CONFIG.Visualize.ArrowSize)
                        
                        local pointA = AntiA(RelativeToCenter(baseL))
                        local pointB = AntiA(RelativeToCenter(baseR))
                        local pointC = AntiA(RelativeToCenter(tip))

                        UpdateTriangleLines(lines, pointA, pointB, pointC)
                        
                        lines[1].Visible = true
                        lines[2].Visible = true
                        lines[3].Visible = true

                    else 
                        lines[1].Visible = false
                        lines[2].Visible = false
                        lines[3].Visible = false
                    end
                else 
                    lines[1].Visible = false
                    lines[2].Visible = false
                    lines[3].Visible = false
                end
            else 
                lines[1].Visible = false
                lines[2].Visible = false
                lines[3].Visible = false

                if not PLAYER or not PLAYER.Parent then
                    lines[1]:Remove()
                    lines[2]:Remove()
                    lines[3]:Remove()
                    if c then c:Disconnect() end
                end
            end
        end)
    end

    ArrowIndicators[PLAYER] = {lines = lines, connection = coroutine.wrap(Update)()}
end

local function RemoveArrow(player)
    if ArrowIndicators[player] then
        local indicator = ArrowIndicators[player]
        for _, line in ipairs(indicator.lines) do
            line:Remove()
        end
        ArrowIndicators[player] = nil
    end
end

local function UpdateAllArrows()
    for player, indicator in pairs(ArrowIndicators) do
        RemoveArrow(player)
        if player ~= LocalPlayer and getgenv().CONFIG.Visualize.ArrowEnabled then
            ShowArrow(player)
        end
    end
end

local function SetupArrows()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ShowArrow(player)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            ShowArrow(player)
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        RemoveArrow(player)
    end)
end
--]]
--[[
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/helloxyzcodervisuals/kskldkdkslxococpplwqlwlwkwmnwnwwnwksizixicucyvyegegegwwbwbaxjdkd/refs/heads/main/hi.lua"))()

local window = library:window({name = 'skcc.lua', size = UDim2.new(0, 650, 0, 850)})

local UI = {}
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
        local skeet = CoreGui:FindFirstChild("skeet")
        if skeet and skeet:IsA("ScreenGui") then
            skeet.Enabled = not skeet.Enabled
        end
    end
end)
function UI:CreateElement(type, parent, options)
    local element = nil
    
    if type == "tab" then
        element = parent:tab(options)
    elseif type == "column" then
        element = parent:column(options)
    elseif type == "section" then
        element = parent:section(options)
    elseif type == "toggle" then
        element = parent:addToggle(options)
    elseif type == "slider" then
        element = parent:addSlider(options)
    elseif type == "list" then
        element = parent:addList(options)
    elseif type == "colorpicker" then
        element = parent:addColorpicker(options)
    elseif type == "textbox" then
        element = parent:addTextbox(options)
    elseif type == "button" then
        element = parent:addButton(options)
    end
    
    return element
end

repeat
    task.wait()
until game:IsLoaded()

do
    local function isAdonisAC(tab)
        return rawget(tab, "Detected")
            and typeof(rawget(tab, "Detected")) == "function"
            and rawget(tab, "RLocked")
    end

    for _, v in next, getgc(true) do
        if typeof(v) == "table" and isAdonisAC(v) then
            for i, f in next, v do
                if rawequal(i, "Detected") then
                    local old
                    old = hookfunction(f, function(action, info, crash)
                        if rawequal(action, "_") and rawequal(info, "_") and rawequal(crash, false) then
                            return old(action, info, crash)
                        end
                        return task.wait(9e9)
                    end)
                    warn("bypassed")
                    break
                end
            end
        end
    end
end
for _, v in pairs(getgc(true)) do
if type(v) == "table" then
local func = rawget(v, "DTXC1")
if type(func) == "function" then
hookfunction(func, function() return end)
break
end
end
end
print("done")
getgenv().CONFIG = {
    Ragebot = {
        Enabled = false,
        RapidFire = false,
        FireRate = 30,
        Prediction = true,
        PredictionAmount = 0.12,
        TeamCheck = false,
        VisibilityCheck = true,
        FOV = 120,
        ShowFOV = true,
        Wallbang = true,
        Tracers = true,
        TracerColor = Color3.fromRGB(255, 0, 0),
        TracerWidth = 1,
        TracerLifetime = 3,
        ShootRange = 15,
        HitRange = 15,
        HitNotify = true,
        AutoReload = true,
        HitSound = true,
        HitColor = Color3.fromRGB(255, 182, 193),
        UseTargetList = false,
        UseWhitelist = false,
        HitNotifyDuration = 5,
        LowHealthCheck = false,
        SelectedHitSound = "skeet"
    },
    Misc = {
        SpeedEnabled = false,
        SpeedValue = 50,
        JumpPowerEnabled = false,
        JumpPowerValue = 100,
        LoopFOVEnabled = false,
        HideHeadEnabled = false,
        InfStaminaEnabled = false,
        NoFallDmgEnabled = false,
        SpeedConnection = nil,
        FOVConnection = nil,
        JumpPowerConnection = nil,
        NoFallHook = nil,
        InfStaminaHook = nil
    },
    Visualize = {
        ESP = {
            Enabled = false,
            BoxColor = Color3.fromRGB(78, 150, 50),
            OutlineColor = Color3.fromRGB(78, 150, 50),
            TextColor = Color3.fromRGB(255, 255, 255),
            MaxDistance = 1000
        },
        ForcefieldColor = Color3.fromRGB(255, 255, 255),
        ForcefieldTransparency = 0.5,
        LocalForcefieldEnabled = false,
        ArrowEnabled = false,
        ArrowColor = Color3.fromRGB(255, 255, 255),
        ArrowDistance = 80,
        ArrowSize = 16,
        ArrowThickness = 1,
        ArrowAA = false
    }
}

getgenv().Lists = {
    TargetList = {},
    Whitelist = {}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if makefolder then
    makefolder("a")
    makefolder("a/fonts")
end

if not isfile or (isfile and not isfile("a/fonts/main.ttf")) then
    if writefile then
        writefile("a/fonts/main.ttf", game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf"))
    end
end

local font_data = {
    name = "AFont",
    faces = {
        {
            name = "Regular",
            weight = 400,
            style = "normal",
            assetId = getcustomasset and getcustomasset("a/fonts/main.ttf") or ""
        }
    }
}

if writefile and not isfile("a/fonts/main_encoded.ttf") then
    writefile("a/fonts/main_encoded.ttf", game:GetService("HttpService"):JSONEncode(font_data))
end

local AFont = Font.new(getcustomasset and getcustomasset("a/fonts/main_encoded.ttf") or Enum.Font.Gotham, Enum.FontWeight.Regular)

local hitNotifications = {}
local notificationYOffset = 10

local function createHitNotification(toolName, offsetValue, playerName)
    if not getgenv().CONFIG.Ragebot.HitNotify then return end
    
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("HitNotifications") or Instance.new("ScreenGui")
    ScreenGui.Name = "HitNotifications"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local box = Instance.new("Frame")
    box.Parent = ScreenGui
    box.BackgroundColor3 = Color3.new(0, 0, 0)
    box.BackgroundTransparency = 0.5
    box.BorderSizePixel = 0
    box.AnchorPoint = Vector2.new(0, 0)
    box.Position = UDim2.new(0, 10, 0, -50)
    
    local parts = {
        {"Using ", Color3.fromRGB(255, 255, 255)},
        {toolName.." ", getgenv().CONFIG.Ragebot.HitColor},
        {"On ", Color3.fromRGB(255, 255, 255)},
        {string.format("%.2f", offsetValue).." ", getgenv().CONFIG.Ragebot.HitColor},
        {"in the ", Color3.fromRGB(255, 255, 255)},
        {"head ", getgenv().CONFIG.Ragebot.HitColor},
        {"to hit ", Color3.fromRGB(255, 255, 255)},
        {playerName, getgenv().CONFIG.Ragebot.HitColor},
        {"on via cache", Color3.fromRGB(255, 255, 255)},
    }
    
    local offsetX = 6
    local totalW, maxH = 0, 0
    
    for _, seg in ipairs(parts) do
        local txt, col = seg[1], seg[2]
        local label = Instance.new("TextLabel")
        label.Parent = box
        label.BackgroundTransparency = 1
        label.BorderSizePixel = 0
        label.TextColor3 = col
        label.FontFace = AFont
        label.TextSize = 10
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Text = txt
        label.AutomaticSize = Enum.AutomaticSize.XY
        label.Position = UDim2.new(0, offsetX, 0, 0)
        offsetX = offsetX + label.TextBounds.X
        totalW = offsetX
        maxH = math.max(maxH, label.TextBounds.Y)
    end
    
    box.Size = UDim2.new(0, totalW + 12, 0, maxH + 8)
    
    local notificationIndex = #hitNotifications + 1
    local targetY = notificationYOffset + ((notificationIndex - 1) * (maxH + 8 + 5))
    
    table.insert(hitNotifications, {box = box, index = notificationIndex})
    
    for i, notif in ipairs(hitNotifications) do
        notif.index = i
        notif.box.Position = UDim2.new(0, 10, 0, notificationYOffset + ((i - 1) * (notif.box.AbsoluteSize.Y + 5)))
    end
    
    local slideInTween = TweenService:Create(
        box,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 10, 0, notificationYOffset + ((notificationIndex - 1) * (maxH + 8 + 5)))}
    )
    slideInTween:Play()
    
    task.delay(getgenv().CONFIG.Ragebot.HitNotifyDuration, function()
        for i, notif in ipairs(hitNotifications) do
            if notif.box == box then
                table.remove(hitNotifications, i)
                break
            end
        end
        
        if box then 
            local slideOutTween = TweenService:Create(
                box,
                TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Position = UDim2.new(0, 10, 0, -50)}
            )
            slideOutTween:Play()
            slideOutTween.Completed:Wait()
            box:Destroy() 
        end
        
        for i, notif in ipairs(hitNotifications) do
            notif.box.Position = UDim2.new(0, 10, 0, notificationYOffset + ((i - 1) * (notif.box.AbsoluteSize.Y + 5)))
        end
    end)
end

local function playHitSound()
    if not getgenv().CONFIG.Ragebot.HitSound then return end
    
    local soundIds = {
        ["skeet"] = "rbxassetid://4817809188",
        ["xp level"] = "rbxassetid://17148249625",
        ["bell"] = "rbxassetid://6534948092"
    }
    
    local soundId = soundIds[getgenv().CONFIG.Ragebot.SelectedHitSound] or soundIds["skeet"]
    
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 0.5
    sound.Parent = Workspace
    sound:Play()
    
    game:GetService("Debris"):AddItem(sound, 3)
end

local function getCurrentTool()
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                return tool
            end
        end
    end
    return nil
end

local function autoReload()
    if not getgenv().CONFIG.Ragebot.AutoReload then return end
    
    local tool = getCurrentTool()
    if not tool then return end
    
    local values = tool:FindFirstChild("Values")
    if not values then return end
    
    local ammo = values:FindFirstChild("SERVER_Ammo")
    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return end
    
    if ammo.Value <= 0 and storedAmmo.Value > 0 then
        local args = {
            tick(),
            "KLWE89U0",
            tool
        }
        local GNX_R = ReplicatedStorage:WaitForChild("Events"):WaitForChild("GNX_R")
        GNX_R:FireServer(unpack(args))
    end
end

local function canSeeTarget(targetPart)
    if not getgenv().CONFIG.Ragebot.VisibilityCheck then return true end
    
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return false end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local startPos = localHead.Position
    local endPos = targetPart.Position
    local direction = (endPos - startPos)
    local distance = direction.Magnitude
    
    local raycastResult = Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if humanoid then
                    local targetPlayer = Players:GetPlayerFromCharacter(model)
                    if targetPlayer then
                        return true
                    end
                end
            end
            return false
        end
    end
    
    local secondRaycast = Workspace:Raycast(startPos + direction.Unit * 0.5, direction.Unit * (distance - 0.5), raycastParams)
    if secondRaycast then
        local hitPart = secondRaycast.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if humanoid then
                    local targetPlayer = Players:GetPlayerFromCharacter(model)
                    if targetPlayer then
                        return true
                    end
                end
            end
            return false
        end
    end
    
    return true
end

local function getClosestTarget()
    local closest = nil
    local shortestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        
        if getgenv().CONFIG.Ragebot.UseWhitelist and table.find(getgenv().Lists.Whitelist, player.Name) then
            continue
        end
        
        if getgenv().CONFIG.Ragebot.UseTargetList and not table.find(getgenv().Lists.TargetList, player.Name) then
            continue
        end
        
        if getgenv().CONFIG.Ragebot.TeamCheck and player.Team == LocalPlayer.Team then continue end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            local head = character:FindFirstChild("Head")
            
            if humanoid and humanoid.Health > 0 and head then
                local hasForcefield = false
                for _, child in pairs(character:GetChildren()) do
                    if child:IsA("ForceField") then
                        hasForcefield = true
                        break
                    end
                end
                
                if hasForcefield then continue end
        
                if getgenv().CONFIG.Ragebot.LowHealthCheck and humanoid.Health < 15 then continue end
                
                local distance = (head.Position - LocalPlayer.Character.Head.Position).Magnitude
                if distance < shortestDistance then
                    if canSeeTarget(head) then
                        closest = head
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closest
end

local function checkClearPath(startPos, endPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local direction = (endPos - startPos)
    local distance = direction.Magnitude
    
    local raycastResult = Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart and hitPart.CanCollide then
            local model = hitPart:FindFirstAncestorOfClass("Model")
            if model then
                local humanoid = model:FindFirstChild("Humanoid")
                if not humanoid then
                    return false
                end
            else
                return false
            end
        end
    end
    return true
end

local cachedBestPositions = {
    shootPos = nil,
    hitPos = nil,
    target = nil
}

local function wallbang()
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return nil end
    
    local target = getClosestTarget()
    if not target then 
        cachedBestPositions.shootPos = nil
        cachedBestPositions.hitPos = nil
        cachedBestPositions.target = nil
        return nil, nil
    end
    
    local startPos = localHead.Position
    local targetPos = target.Position
    
    if not getgenv().CONFIG.Ragebot.Wallbang then
        cachedBestPositions.shootPos = startPos
        cachedBestPositions.hitPos = targetPos
        cachedBestPositions.target = target
        return startPos, targetPos
    end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local direction = targetPos - startPos
    local distance = direction.Magnitude
    local directRay = Workspace:Raycast(startPos, direction.Unit * distance, raycastParams)
    
    if not directRay then
        cachedBestPositions.shootPos = startPos
        cachedBestPositions.hitPos = targetPos
        cachedBestPositions.target = target
        return startPos, targetPos
    end
    
    if cachedBestPositions.shootPos and cachedBestPositions.target == target then
        local cachedShootDistance = (cachedBestPositions.shootPos - startPos).Magnitude
        local cachedHitDistance = (cachedBestPositions.hitPos - targetPos).Magnitude
        
        if cachedShootDistance <= getgenv().CONFIG.Ragebot.ShootRange and 
           cachedHitDistance <= getgenv().CONFIG.Ragebot.HitRange then
            
            local pathToShoot = checkClearPath(startPos, cachedBestPositions.shootPos)
            local pathToTarget = checkClearPath(cachedBestPositions.shootPos, cachedBestPositions.hitPos)
            
            if pathToShoot and pathToTarget then
                local shootToHitRay = Workspace:Raycast(cachedBestPositions.shootPos, (cachedBestPositions.hitPos - cachedBestPositions.shootPos).Unit * (cachedBestPositions.hitPos - cachedBestPositions.shootPos).Magnitude, raycastParams)
                if not shootToHitRay then
                    return cachedBestPositions.shootPos, cachedBestPositions.hitPos
                end
            end
        end
        cachedBestPositions.shootPos = nil
        cachedBestPositions.hitPos = nil
    end
    
    local bestShootPos = nil
    local bestHitPos = nil
    local bestScore = math.huge
    
    for i = 1, 150 do
        local shootOffset = Vector3.new(
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange),
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange),
            math.random(-getgenv().CONFIG.Ragebot.ShootRange, getgenv().CONFIG.Ragebot.ShootRange)
        )
        local shootPos = startPos + shootOffset
        
        local hitOffset = Vector3.new(
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange),
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange),
            math.random(-getgenv().CONFIG.Ragebot.HitRange, getgenv().CONFIG.Ragebot.HitRange)
        )
        local hitPos = targetPos + hitOffset
        
        local shootDistance = (shootPos - startPos).Magnitude
        local hitDistance = (hitPos - targetPos).Magnitude
        
        if shootDistance <= getgenv().CONFIG.Ragebot.ShootRange and hitDistance <= getgenv().CONFIG.Ragebot.HitRange then
            local pathToShoot = checkClearPath(startPos, shootPos)
            local pathToTarget = checkClearPath(shootPos, hitPos)
            
            if pathToShoot and pathToTarget then
                local shootToHitRay = Workspace:Raycast(shootPos, (hitPos - shootPos).Unit * (hitPos - shootPos).Magnitude, raycastParams)
                if not shootToHitRay then
                    local totalScore = shootDistance + hitDistance
                    
                    if totalScore < bestScore then
                        bestScore = totalScore
                        bestShootPos = shootPos
                        bestHitPos = hitPos
                    end
                end
            end
        end
    end
    
    if not bestShootPos or not bestHitPos then
        local randomY = math.random(-16, -14)
        local fallbackShootPos = Vector3.new(startPos.X, randomY, startPos.Z)
        local fallbackHitPos = Vector3.new(targetPos.X, randomY, targetPos.Z)
        
        cachedBestPositions.shootPos = fallbackShootPos
        cachedBestPositions.hitPos = fallbackHitPos
        cachedBestPositions.target = target
        
        return fallbackShootPos, fallbackHitPos
    end
    
    cachedBestPositions.shootPos = bestShootPos
    cachedBestPositions.hitPos = bestHitPos
    cachedBestPositions.target = target
    
    return bestShootPos, bestHitPos
end

local function createTracer(startPos, endPos)
    if not getgenv().CONFIG.Ragebot.Tracers then return end
    
    local tracerModel = Instance.new("Model")
    tracerModel.Name = "TracerBeam"
    
    local beam = Instance.new("Beam")
    beam.Color = ColorSequence.new(getgenv().CONFIG.Ragebot.TracerColor)
    beam.Width0 = getgenv().CONFIG.Ragebot.TracerWidth
    beam.Width1 = getgenv().CONFIG.Ragebot.TracerWidth
    beam.Texture = "rbxassetid://7136858729"
    beam.TextureSpeed = 1
    beam.Brightness = 2
    beam.LightEmission = 2
    beam.FaceCamera = true
    
    local a0 = Instance.new("Attachment")
    local a1 = Instance.new("Attachment")
    a0.WorldPosition = startPos
    a1.WorldPosition = endPos
    beam.Attachment0 = a0
    beam.Attachment1 = a1
    
    beam.Parent = tracerModel
    a0.Parent = tracerModel
    a1.Parent = tracerModel
    tracerModel.Parent = Workspace
    
    local tweenInfo = Tweenew(
        getgenv().CONFIG.Ragebot.TracerLifetime,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(beam, tweenInfo, {
        Brightness = 0
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        if tracerModel then 
            tracerModel:Destroy() 
        end
    end)
end

local function RandomString(length)
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = ""
    for i = 1, length do
        result = result .. charset:sub(math.random(1, #charset), math.random(1, #charset))
    end
    return result
end

local function shootAtTarget(targetHead)
    if not targetHead then return false end
    local localHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
    if not localHead then return false end
    local tool = getCurrentTool()
    if not tool then return false end
    local values = tool:FindFirstChild("Values")
    local hitMarker = tool:FindFirstChild("Hitmarker")
    if not values or not hitMarker then return false end
    local ammo = values:FindFirstChild("SERVER_Ammo")
    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return false end
    if ammo.Value <= 0 then
        autoReload()
        return false
    end

    local bestShootPos, bestHitPos = wallbang()
    
    if not bestShootPos or not bestHitPos then
        return false
    end
    local hitPosition = bestHitPos
  
    if getgenv().CONFIG.Ragebot.Prediction then
        local velocity = targetHead.Velocity or Vector3.zero
        hitPosition = hitPosition + velocity * getgenv().CONFIG.Ragebot.PredictionAmount
    end

    local hitDirection = (hitPosition - bestShootPos).Unit
    local randomKey = RandomString(30) .. "0"
    local args1 = {tick(), randomKey, tool, "FDS9I83", bestShootPos, {hitDirection}, false}
    local args2 = {"🧈", tool, randomKey, 1, targetHead, hitPosition, hitDirection}
    local events = ReplicatedStorage:WaitForChild("Events")
    local GNX_S = events:WaitForChild("GNX_S")
    local ZFKLF__H = events:WaitForChild("ZFKLF__H")
    local targetPlayer = Players:GetPlayerFromCharacter(targetHead.Parent)
    if targetPlayer then
        createHitNotification(tool.Name, (bestShootPos - localHead.Position).Magnitude, targetPlayer.Name)
        playHitSound()
    end

    coroutine.wrap(function()
        GNX_S:FireServer(unpack(args1))
        ZFKLF__H:FireServer(unpack(args2))
    end)()

    ammo.Value = math.max(ammo.Value - 1, 0)
    hitMarker:Fire(targetHead)
    storedAmmo.Value = storedAmmo.Value
    createTracer(bestShootPos, hitPosition)
    return true
end

local lastShotTime = 0
RunService.Heartbeat:Connect(function()
    if not getgenv().CONFIG.Ragebot.Enabled then return end
    if not LocalPlayer.Character then return end
    if not LocalPlayer.Character:FindFirstChild("Head") then return end
    
    local target = getClosestTarget()
    if not target then return end
    
    if getgenv().CONFIG.Ragebot.RapidFire then
        while getgenv().CONFIG.Ragebot.RapidFire and getgenv().CONFIG.Ragebot.Enabled and target do
            shootAtTarget(target)
            task.wait()
        end
    else
        local currentTime = tick()
        local waitTime = 1 / (getgenv().CONFIG.Ragebot.FireRate * 1)
        if currentTime - lastShotTime >= waitTime then
            shootAtTarget(target)
            --wait()
            --shootAtTarget(target)
            lastShotTime = currentTime
        end
    end
end)

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = getgenv().CONFIG.Ragebot.ShowFOV
fovCircle.Radius = getgenv().CONFIG.Ragebot.FOV
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1
fovCircle.Filled = false

RunService.RenderStepped:Connect(function()
    fovCircle.Visible = getgenv().CONFIG.Ragebot.ShowFOV and getgenv().CONFIG.Ragebot.Enabled
    fovCircle.Radius = getgenv().CONFIG.Ragebot.FOV
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)
local function enableSpeed()
    if getgenv().CONFIG.Misc.SpeedConnection then
        getgenv().CONFIG.Misc.SpeedConnection:Disconnect()
        getgenv().CONFIG.Misc.SpeedConnection = nil
    end

    getgenv().CONFIG.Misc.SpeedConnection = game:GetService("RunService").RenderStepped:Connect(function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then return end

        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end

        humanoid.WalkSpeed = getgenv().CONFIG.Misc.SpeedValue
    end)
end

local function disableSpeed()
    if getgenv().CONFIG.Misc.SpeedConnection then
        getgenv().CONFIG.Misc.SpeedConnection:Disconnect()
        getgenv().CONFIG.Misc.SpeedConnection = nil
    end

    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = 16 end
    end
end

local function enableJumpPower()
    if getgenv().CONFIG.Misc.JumpPowerConnection then
        getgenv().CONFIG.Misc.JumpPowerConnection:Disconnect()
        getgenv().CONFIG.Misc.JumpPowerConnection = nil
    end
    
    getgenv().CONFIG.Misc.JumpPowerConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not getgenv().CONFIG.Misc.JumpPowerEnabled then return end
        if not game.Players.LocalPlayer.Character then return end
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, getgenv().CONFIG.Misc.JumpPowerValue, hrp.Velocity.Z)
        end
    end)
end

local function disableJumpPower()
    if getgenv().CONFIG.Misc.JumpPowerConnection then
        getgenv().CONFIG.Misc.JumpPowerConnection:Disconnect()
        getgenv().CONFIG.Misc.JumpPowerConnection = nil
    end
end

local function enableLoopFOV()
    if getgenv().CONFIG.Misc.FOVConnection then
        getgenv().CONFIG.Misc.FOVConnection:Disconnect()
        getgenv().CONFIG.Misc.FOVConnection = nil
    end
    
    getgenv().CONFIG.Misc.FOVConnection = game:GetService("RunService").RenderStepped:Connect(function()
        workspace.CurrentCamera.FieldOfView = 120
    end)
end

local function disableLoopFOV()
    if getgenv().CONFIG.Misc.FOVConnection then
        getgenv().CONFIG.Misc.FOVConnection:Disconnect()
        getgenv().CONFIG.Misc.FOVConnection = nil
    end
end

local runserviceConnection = nil
local originalMotors = {}
local toolTransparencies = {}

local function getCurrentTool()
    local char = game.Players.LocalPlayer.Character
    if not char then return nil end
    
    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") then
            return item
        end
    end
    
    return nil
end

local function hideHeadFE()
    if not game.Players.LocalPlayer.Character then return end
    
    local char = game.Players.LocalPlayer.Character
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    
    if not torso then return end
    
    local tool = getCurrentTool()
    if not tool then return end
    
    local values = tool:FindFirstChild("Values")
    if not values then return end
    
    local ammo = values:FindFirstChild("SERVER_Ammo")
    local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
    if not ammo or not storedAmmo then return end
    
    originalMotors = {}
    for _, motor in pairs(torso:GetChildren()) do
        if motor:IsA("Motor6D") then
            originalMotors[motor] = {
                C0 = motor.C0,
                C1 = motor.C1
            }
        end
    end
    
    toolTransparencies = {}
    for _, part in pairs(tool:GetDescendants()) do
        if part:IsA("BasePart") then
            toolTransparencies[part] = part.Transparency
            part.Transparency = 1
        end
    end
    
    if runserviceConnection then
        runserviceConnection:Disconnect()
    end
    
    runserviceConnection = game:GetService("RunService").RenderStepped:Connect(function()
        for motor, original in pairs(originalMotors) do
            if motor and motor.Parent then
                motor.C0 = original.C0
                motor.C1 = original.C1
            end
        end
    end)
end

local function showHeadFE()
    if runserviceConnection then
        runserviceConnection:Disconnect()
        runserviceConnection = nil
    end
    
    for part, transparency in pairs(toolTransparencies) do
        if part and part.Parent then
            part.Transparency = transparency
        end
    end
    toolTransparencies = {}
    
    originalMotors = {}
end

local function enableNoFallDmg()
    if getgenv().CONFIG.Misc.NoFallHook then getgenv().CONFIG.Misc.NoFallHook = nil end
    getgenv().CONFIG.Misc.NoFallHook = hookmetamethod(game, "__namecall", function(self, ...)
        local args = { ... }
        if getnamecallmethod() == "FireServer" and not checkcaller() and args[1] == "FlllD" and args[4] == false then
            args[2] = 0
            args[3] = 0
        end
        return getgenv().CONFIG.Misc.NoFallHook(self, unpack(args))
    end)
end

local function disableNoFallDmg()
    if getgenv().CONFIG.Misc.NoFallHook then getgenv().CONFIG.Misc.NoFallHook = nil end
end
--]]
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/helloxyzcodervisuals/kskldkdkslxococpplwqlwlwkwmnwnwwnwksizixicucyvyegegegwwbwbaxjdkd/refs/heads/main/hi.lua"))()

local window = library:window({name = '<font color="#FFD700">gamesense</font>.cc', size = UDim2.new(0, 650, 0, 850)})

local UI = {}
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
        local skeet = CoreGui:FindFirstChild("skeet")
        if skeet and skeet:IsA("ScreenGui") then
            skeet.Enabled = not skeet.Enabled
        end
    end
end)
function UI:CreateElement(type, parent, options)
    local element = nil
    
    if type == "tab" then
        element = parent:tab(options)
    elseif type == "column" then
        element = parent:column(options)
    elseif type == "section" then
        element = parent:section(options)
    elseif type == "toggle" then
        element = parent:addToggle(options)
    elseif type == "slider" then
        element = parent:addSlider(options)
    elseif type == "list" then
        element = parent:addList(options)
    elseif type == "colorpicker" then
        element = parent:addColorpicker(options)
    elseif type == "textbox" then
        element = parent:addTextbox(options)
    elseif type == "button" then
        element = parent:addButton(options)
    end
    
    return element
end

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local camera = Workspace.CurrentCamera
local local_player = Players.LocalPlayer

getgenv().Legitbot = {
    Enabled = false,
    SilentAim = {
        Enabled = false,
        FOV = 100,
        TeamCheck = true,
        HitPart = "Torso",
        HeadChance = 30,
        Prediction = 0.165
    },
    Tracers = {
        Enabled = true,
        Color = Color3.fromRGB(255, 50, 50),
        Width = 0.3,
        Brightness = 2,
        LightEmission = 1,
        Lifetime = 0.5
    }
}

getgenv().silent_aim_is_targetting = false
getgenv().silent_aim_target = nil
getgenv().aim_position = Vector3.new()

local function createLegitTracer(startPos, endPos)
    if not getgenv().Legitbot.Tracers.Enabled then return end
    
    local beamPart = Instance.new("Part")
    beamPart.Anchored = true
    beamPart.CanCollide = false
    beamPart.Transparency = 1
    beamPart.Size = Vector3.new(0.1, 0.1, 0.1)
    beamPart.Parent = Workspace
    
    local attachment0 = Instance.new("Attachment")
    attachment0.Parent = beamPart
    
    local attachment1 = Instance.new("Attachment")
    attachment1.Parent = beamPart
    
    local beam = Instance.new("Beam")
    beam.Attachment0 = attachment0
    beam.Attachment1 = attachment1
    beam.Color = ColorSequence.new(getgenv().Legitbot.Tracers.Color)
    beam.Width0 = getgenv().Legitbot.Tracers.Width
    beam.Width1 = getgenv().Legitbot.Tracers.Width
    beam.Brightness = getgenv().Legitbot.Tracers.Brightness
    beam.LightEmission = getgenv().Legitbot.Tracers.LightEmission
    beam.Parent = beamPart
    
    local midPoint = (startPos + endPos) / 2
    local lookVector = (endPos - startPos).Unit
    local distance = (startPos - endPos).Magnitude
    
    beamPart.CFrame = CFrame.new(midPoint, midPoint + lookVector) * CFrame.new(0, 0, -distance/2)
    
    attachment0.WorldPosition = startPos
    attachment1.WorldPosition = endPos
    
    task.delay(getgenv().Legitbot.Tracers.Lifetime, function()
        if beamPart and beamPart.Parent then
            beamPart:Destroy()
        end
    end)
end

local function trackGlobalBullets()
    local bfr = workspace.Camera:FindFirstChild("Bullets")
    if not bfr then return end
    
    local function tblt(blt)
        if not blt:IsA("BasePart") then return end
        
        local stp = blt.Position
        local lsp = stp
        local stc = 0
        
        local con
        con = RunService.Heartbeat:Connect(function()
            if not blt or not blt.Parent then
                con:Disconnect()
                if (lsp - stp).Magnitude > 1 then
                    createTracer(stp, lsp)
                end
                return
            end
            
            local cp = blt.Position
            if (cp - lsp).Magnitude < 0.01 then
                stc = stc + 1
                if stc > 3 then
                    con:Disconnect()
                    if (cp - stp).Magnitude > 1 then
                        createTracer(stp, cp)
                    end
                end
            else
                stc = 0
                lsp = cp
            end
        end)
    end
    
    bfr.ChildAdded:Connect(tblt)
    
    for _, v in ipairs(bfr:GetChildren()) do
        tblt(v)
    end
end

local function get_direction(origin, destination)
    return ((destination - origin).Unit * 1000)
end

local function world_to_screen(position)
    local viewport_position, on_screen = camera:WorldToViewportPoint(position)
    return {position = Vector2.new(viewport_position.X, viewport_position.Y), on_screen = on_screen}
end

local function has_character(player)
    return player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

local function is_in_fov(position)
    local screen_pos = world_to_screen(position)
    if not screen_pos.on_screen then return false end
    
    local center = camera.ViewportSize / 2
    local distance = (screen_pos.position - center).Magnitude
    return distance <= getgenv().Legitbot.SilentAim.FOV
end

local function get_closest_player_to_position(target_position)
    local closest_player = nil
    local closest_distance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player == local_player then continue end
        if not has_character(player) then continue end
        
        if getgenv().Legitbot.SilentAim.TeamCheck and player.Team and local_player.Team and player.Team == local_player.Team then
            continue
        end
        
        local character = player.Character
        local humanoid_root_part = character:FindFirstChild("HumanoidRootPart")
        if not humanoid_root_part then continue end
        
        if not is_in_fov(humanoid_root_part.Position) then
            continue
        end
        
        local player_position = humanoid_root_part.Position
        local distance = (target_position - player_position).Magnitude
        
        if distance < closest_distance then
            closest_distance = distance
            closest_player = player
        end
    end
    
    return closest_player
end

local function get_target_part_position(character)
    if not character then return Vector3.new(0, 0, 0) end
    
    local hit_part = getgenv().Legitbot.SilentAim.HitPart
    local head_chance = getgenv().Legitbot.SilentAim.HeadChance
    
    local should_hit_head = math.random(1, 100) <= head_chance
    local target_part_name = should_hit_head and "Head" or hit_part
    
    local target_part = character:FindFirstChild(target_part_name)
    if not target_part and target_part_name == "Head" then
        target_part = character:FindFirstChild("Torso")
    end
    if not target_part then
        target_part = character:FindFirstChild("HumanoidRootPart")
    end
    
    if target_part then
        return target_part.Position
    end
    
    return character:FindFirstChild("HumanoidRootPart").Position
end

RunService.RenderStepped:Connect(function()
    if not getgenv().Legitbot.SilentAim.Enabled then
        getgenv().silent_aim_is_targetting = false
        getgenv().silent_aim_target = nil
        return
    end
    
    local target_position = camera.CFrame.Position + camera.CFrame.LookVector * 100
    local new_target = get_closest_player_to_position(target_position)
    
    getgenv().silent_aim_is_targetting = new_target and true or false
    getgenv().silent_aim_target = new_target or nil
    
    if getgenv().silent_aim_target and has_character(getgenv().silent_aim_target) then
        local character = getgenv().silent_aim_target.Character
        local base_position = get_target_part_position(character)
        
        local velocity = Vector3.new(0, 0, 0)
        local hit_part = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
        if hit_part then
            velocity = hit_part.Velocity
        end
        
        local prediction = getgenv().Legitbot.SilentAim.Prediction
        local predicted_position = base_position + (velocity * prediction)
        getgenv().aim_position = predicted_position
    end
end)

local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = tostring(getnamecallmethod())
    
    if not checkcaller() and getgenv().silent_aim_is_targetting and getgenv().silent_aim_target and self == Workspace and method == "Raycast" then
        local origin = args[1]
        args[2] = get_direction(origin, getgenv().aim_position)
        return __namecall(self, unpack(args))
    end
    
    return __namecall(self, ...)
end)

local tab_legit = UI:CreateElement("tab", window, {name = "legit"})
local column1_legit = UI:CreateElement("column", tab_legit, {fill = true})
local column2_legit = UI:CreateElement("column", tab_legit, {fill = true})

local section_silentaim = UI:CreateElement("section", column1_legit, {name = "Silent Aim"})
UI:CreateElement("toggle", section_silentaim, {name = "enable silent aim", flag = "legit_silentaim", default = false, callback = function(value) getgenv().Legitbot.SilentAim.Enabled = value end})
UI:CreateElement("slider", section_silentaim, {name = "field of view", flag = "legit_fov", min = 10, max = 500, default = 100, suffix = "", callback = function(value) getgenv().Legitbot.SilentAim.FOV = value end})
UI:CreateElement("slider", section_silentaim, {name = "prediction", flag = "legit_prediction", min = 0, max = 0.5, default = 0.165, suffix = "s", callback = function(value) getgenv().Legitbot.SilentAim.Prediction = value end})
UI:CreateElement("toggle", section_silentaim, {name = "team check", flag = "legit_teamcheck", default = true, callback = function(value) getgenv().Legitbot.SilentAim.TeamCheck = value end})
UI:CreateElement("slider", section_silentaim, {name = "head chance", flag = "legit_headchance", min = 0, max = 100, default = 30, suffix = "%", callback = function(value) getgenv().Legitbot.SilentAim.HeadChance = value end})
UI:CreateElement("toggle", section_silentaim, {name = "hit torso", flag = "legit_hittorso", default = true, callback = function(value) 
    if value then
        getgenv().Legitbot.SilentAim.HitPart = "Torso"
    end
end})
UI:CreateElement("toggle", section_silentaim, {name = "hit head", flag = "legit_hithead", default = false, callback = function(value) 
    if value then
        getgenv().Legitbot.SilentAim.HitPart = "Head"
    end
end})

local section_tracers = UI:CreateElement("section", column2_legit, {name = "Tracers"})
UI:CreateElement("toggle", section_tracers, {name = "enable tracers", flag = "legit_tracers", default = true, callback = function(value) getgenv().Legitbot.Tracers.Enabled = value end})
UI:CreateElement("colorpicker", section_tracers, {name = "tracer color", flag = "legit_tracercolor", default = Color3.fromRGB(255, 50, 50), callback = function(value) getgenv().Legitbot.Tracers.Color = value end})
UI:CreateElement("slider", section_tracers, {name = "width", flag = "legit_tracerwidth", min = 0.1, max = 2, default = 0.3, suffix = "", callback = function(value) getgenv().Legitbot.Tracers.Width = value end})
UI:CreateElement("slider", section_tracers, {name = "brightness", flag = "legit_tracerbrightness", min = 0, max = 5, default = 2, suffix = "", callback = function(value) getgenv().Legitbot.Tracers.Brightness = value end})
UI:CreateElement("slider", section_tracers, {name = "light emission", flag = "legit_tracerlight", min = 0, max = 2, default = 1, suffix = "", callback = function(value) getgenv().Legitbot.Tracers.LightEmission = value end})
UI:CreateElement("slider", section_tracers, {name = "lifetime", flag = "legit_tracerlifetime", min = 0.1, max = 2, default = 0.5, suffix = "s", callback = function(value) getgenv().Legitbot.Tracers.Lifetime = value end})

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local local_player = Players.LocalPlayer

getgenv().GunMod = {
    NoRecoil = true,
    NoSpread = true,
    NoEquipTime = true
}

local no_recoil_enabled = getgenv().GunMod.NoRecoil
local no_spread_enabled = getgenv().GunMod.NoSpread
local no_equiptime_enabled = getgenv().GunMod.NoEquipTime

local config_modules_table = {}
local weapon_config_data = {}
local cached_configs = {}
local current_tools = {}
local backpack_tools = {}
local character_tools = {}
local all_configs_array = {}
local gun_config_cache = {}

local function applyNoRecoil()
    if not no_recoil_enabled then return end
    
    local configs_found = {}
    
    for _, config_table in pairs(getgc(true)) do
        if type(config_table) == "table" and rawget(config_table, "Recoil") then
            table.insert(configs_found, config_table)
        end
    end
    
    for _, player_container in ipairs({local_player.Backpack, local_player.Character}) do
        for _, weapon_tool in ipairs(player_container:GetChildren()) do
            if weapon_tool:IsA("Tool") then
                local weapon_config = weapon_tool:FindFirstChild("Config")
                if weapon_config and weapon_config:IsA("ModuleScript") then
                    local config_load_success, config_data_table = pcall(require, weapon_config)
                    if config_load_success and type(config_data_table) == "table" then
                        table.insert(configs_found, config_data_table)
                    end
                end
            end
        end
    end
    
    for _, current_config_data in ipairs(configs_found) do
        local function set_config_value(config_field, field_value)
            if rawget(current_config_data, config_field) then
                rawset(current_config_data, config_field, field_value)
            end
        end

        set_config_value("Recoil", 0)
        set_config_value("RecoilSpeed", 0)
        set_config_value("RecoilDamper", 1)
        set_config_value("RecoilRedution", 1)
        set_config_value("AngleX_Min", 0)
        set_config_value("AngleX_Max", 0)
        set_config_value("AngleY_Min", 0)
        set_config_value("AngleY_Max", 0)
        set_config_value("AngleZ_Min", 0)
        set_config_value("AngleZ_Max", 0)

        if rawget(current_config_data, "AimSettings") and type(current_config_data.AimSettings) == "table" then
            rawset(current_config_data.AimSettings, "RecoilReduction_X", 1)
            rawset(current_config_data.AimSettings, "RecoilReduction_Y", 1)
            rawset(current_config_data.AimSettings, "RecoilReduction_Z", 1)
            rawset(current_config_data.AimSettings, "SpreadReductionP", 1)
        end
    end
end

local function applyNoSpread()
    if not no_spread_enabled then return end
    
    local configs_found = {}
    
    for _, config_table in pairs(getgc(true)) do
        if type(config_table) == "table" and rawget(config_table, "Spread") then
            table.insert(configs_found, config_table)
        end
    end
    
    for _, player_container in ipairs({local_player.Backpack, local_player.Character}) do
        for _, weapon_tool in ipairs(player_container:GetChildren()) do
            if weapon_tool:IsA("Tool") then
                local weapon_config = weapon_tool:FindFirstChild("Config")
                if weapon_config and weapon_config:IsA("ModuleScript") then
                    local config_load_success, config_data_table = pcall(require, weapon_config)
                    if config_load_success and type(config_data_table) == "table" then
                        table.insert(configs_found, config_data_table)
                    end
                end
            end
        end
    end
    
    for _, current_config_data in ipairs(configs_found) do
        if rawget(current_config_data, "Spread") then
            rawset(current_config_data, "Spread", 0)
        end
    end
end

local function applyNoEquipTime()
    if not no_equiptime_enabled then return end
    
    local configs_found = {}
    
    for _, config_table in pairs(getgc(true)) do
        if type(config_table) == "table" and rawget(config_table, "EquipTime") then
            table.insert(configs_found, config_table)
        end
    end
    
    for _, player_container in ipairs({local_player.Backpack, local_player.Character}) do
        for _, weapon_tool in ipairs(player_container:GetChildren()) do
            if weapon_tool:IsA("Tool") then
                local weapon_config = weapon_tool:FindFirstChild("Config")
                if weapon_config and weapon_config:IsA("ModuleScript") then
                    local config_load_success, config_data_table = pcall(require, weapon_config)
                    if config_load_success and type(config_data_table) == "table" then
                        table.insert(configs_found, config_data_table)
                    end
                end
            end
        end
    end
    
    for _, current_config_data in ipairs(configs_found) do
        if rawget(current_config_data, "EquipTime") then
            rawset(current_config_data, "EquipTime", 0)
        end
    end
end

local function applyAllGunMods()
    applyNoRecoil()
    applyNoSpread()
    applyNoEquipTime()
end

local section_gun_mod = UI:CreateElement("section", column1_legit, {name = "Gun Mod"})

UI:CreateElement("toggle", section_gun_mod, {name = "no recoil", flag = "legit_norecoil", default = true, callback = function(value) 
    getgenv().GunMod.NoRecoil = value
    no_recoil_enabled = value
    if value then
        applyNoRecoil()
    end
end})

UI:CreateElement("toggle", section_gun_mod, {name = "no spread", flag = "legit_nospread", default = true, callback = function(value) 
    getgenv().GunMod.NoSpread = value
    no_spread_enabled = value
    if value then
        applyNoSpread()
    end
end})

UI:CreateElement("toggle", section_gun_mod, {name = "no equip time", flag = "legit_noequiptime", default = true, callback = function(value) 
    getgenv().GunMod.NoEquipTime = value
    no_equiptime_enabled = value
    if value then
        applyNoEquipTime()
    end
end})

local_player.CharacterAdded:Connect(function(character)
    task.wait(1)
    if getgenv().GunMod.NoRecoil or getgenv().GunMod.NoSpread or getgenv().GunMod.NoEquipTime then
        applyAllGunMods()
    end
end)

local_player.Backpack.ChildAdded:Connect(function(tool)
    if tool:IsA("Tool") then
        task.wait(0.1)
        if getgenv().GunMod.NoRecoil or getgenv().GunMod.NoSpread or getgenv().GunMod.NoEquipTime then
            applyAllGunMods()
        end
    end
end)

task.spawn(function()
    task.wait(1)
    applyAllGunMods()
end)
task.spawn(function()
    task.wait(0.1)
    trackGlobalBullets()
end)
local tab_rage = UI:CreateElement("tab", window, {name = "rage"})
local column1_rage = UI:CreateElement("column", tab_rage, {fill = true})
local column2_rage = UI:CreateElement("column", tab_rage, {fill = true})

local section_rage_left = UI:CreateElement("section", column1_rage, {name = "ragebot"})
UI:CreateElement("toggle", section_rage_left, {name = "enable", flag = "rage_enable", default = false, callback = function(value) getgenv().CONFIG.Ragebot.Enabled = value end})
UI:CreateElement("toggle", section_rage_left, {name = "rapid fire", flag = "rage_rapidfire", default = false, callback = function(value) getgenv().CONFIG.Ragebot.RapidFire = value end})
UI:CreateElement("toggle", section_rage_left, {name = "hit sound", flag = "rage_hitsound", default = true, callback = function(value) getgenv().CONFIG.Ragebot.HitSound = value end})
UI:CreateElement("toggle", section_rage_left, {name = "auto reload", flag = "rage_autoreload", default = true, callback = function(value) getgenv().CONFIG.Ragebot.AutoReload = value end})
UI:CreateElement("slider", section_rage_left, {name = "fire rate", flag = "rage_firerate", min = 1, max = 1000, default = 30, suffix = " RPS", callback = function(value) getgenv().CONFIG.Ragebot.FireRate = value end})
UI:CreateElement("slider", section_rage_left, {name = "shoot range", flag = "rage_shootrange", min = 1, max = 30, default = 15, suffix = "", callback = function(value) getgenv().CONFIG.Ragebot.ShootRange = value end})
UI:CreateElement("slider", section_rage_left, {name = "hit range", flag = "rage_hitrange", min = 1, max = 30, default = 15, suffix = "", callback = function(value) getgenv().CONFIG.Ragebot.HitRange = value end})
UI:CreateElement("list", section_rage_left, {name = "hit sound", flag = "rage_hitsoundlist", items = {"skeet", "xp level", "bell"}, default = "skeet", callback = function(value) getgenv().CONFIG.Ragebot.SelectedHitSound = value end})

local section_targeting = UI:CreateElement("section", column2_rage, {name = "targeting"})
UI:CreateElement("toggle", section_targeting, {name = "team check", flag = "rage_teamcheck", default = false, callback = function(value) getgenv().CONFIG.Ragebot.TeamCheck = value end})
UI:CreateElement("toggle", section_targeting, {name = "visibility check", flag = "rage_visibilitycheck", default = true, callback = function(value) getgenv().CONFIG.Ragebot.VisibilityCheck = value end})
UI:CreateElement("toggle", section_targeting, {name = "wallbang", flag = "rage_wallbang", default = true, callback = function(value) getgenv().CONFIG.Ragebot.Wallbang = value end})
UI:CreateElement("slider", section_targeting, {name = "fov", flag = "rage_fov", min = 10, max = 360, default = 120, suffix = "", callback = function(value) getgenv().CONFIG.Ragebot.FOV = value end})
UI:CreateElement("toggle", section_targeting, {name = "show fov", flag = "rage_showfov", default = true, callback = function(value) getgenv().CONFIG.Ragebot.ShowFOV = value end})
UI:CreateElement("toggle", section_targeting, {name = "downed check", flag = "rage_downcheck", default = false, callback = function(value) getgenv().CONFIG.Ragebot.LowHealthCheck = value end})
UI:CreateElement("toggle", section_targeting, {name = "friend check", flag = "rage_friendcheck", default = false, callback = function(value) getgenv().CONFIG.Ragebot.FriendCheck = value end})
UI:CreateElement("slider", section_targeting, {name = "max target", flag = "rage_maxtarget", min = 0, max = 20, default = 1, suffix = " players", callback = function(value) getgenv().CONFIG.Ragebot.MaxTarget = value end})
local section_combat_left = UI:CreateElement("section", column1_rage, {name = "aim settings"})
UI:CreateElement("toggle", section_combat_left, {name = "prediction", flag = "rage_prediction", default = true, callback = function(value) getgenv().CONFIG.Ragebot.Prediction = value end})
UI:CreateElement("slider", section_combat_left, {name = "prediction amount", flag = "rage_predictionamount", min = 0.05, max = 0.3, default = 0.12, suffix = "", callback = function(value) getgenv().CONFIG.Ragebot.PredictionAmount = value end})

local section_visuals_left = UI:CreateElement("section", column1_rage, {name = "tracers"})
UI:CreateElement("toggle", section_visuals_left, {name = "tracers", flag = "rage_tracers", default = true, callback = function(value) getgenv().CONFIG.Ragebot.Tracers = value end})
UI:CreateElement("slider", section_visuals_left, {name = "tracer width", flag = "rage_tracerwidth", min = 0.1, max = 5, default = 1, suffix = "witdh", callback = function(value) getgenv().CONFIG.Ragebot.TracerWidth = value end})
UI:CreateElement("slider", section_visuals_left, {name = "tracer lifetime", flag = "rage_tracerlife", min = 0.5, max = 100, default = 3, suffix = "time", callback = function(value) getgenv().CONFIG.Ragebot.TracerLifetime = value end})

local section_visuals_right = UI:CreateElement("section", column2_rage, {name = "colors"})
UI:CreateElement("colorpicker", section_visuals_right, {name = "tracer color", flag = "rage_tracercolor", default = Color3.fromRGB(255, 0, 0), callback = function(value) getgenv().CONFIG.Ragebot.TracerColor = value end})
UI:CreateElement("colorpicker", section_visuals_right, {name = "hit notification color", flag = "rage_hitcolor", default = Color3.fromRGB(255, 182, 193), callback = function(value) getgenv().CONFIG.Ragebot.HitColor = value end})

local section_notify = UI:CreateElement("section", column2_rage, {name = "notifications"})
UI:CreateElement("toggle", section_notify, {name = "hit notify", flag = "rage_hitnotify", default = true, callback = function(value) getgenv().CONFIG.Ragebot.HitNotify = value end})
UI:CreateElement("slider", section_notify, {name = "hit notify duration", flag = "rage_hitduration", min = 1, max = 10, default = 5, suffix = "s", callback = function(value) getgenv().CONFIG.Ragebot.HitNotifyDuration = value end})

local tab_misc = UI:CreateElement("tab", window, {name = "miscellaneous"})
local column1_misc = UI:CreateElement("column", tab_misc, {fill = true})
local column2_misc = UI:CreateElement("column", tab_misc, {fill = true})

local section_movement = UI:CreateElement("section", column1_misc, {name = "movement"})
UI:CreateElement("toggle", section_movement, {name = "speed", flag = "misc_speed", default = false, callback = function(value) getgenv().CONFIG.Misc.SpeedEnabled = value if value then enableSpeed() else disableSpeed() end end})
UI:CreateElement("slider", section_movement, {name = "speed value", flag = "misc_speedvalue", min = 10, max = 200, default = 50, suffix = "", callback = function(value) getgenv().CONFIG.Misc.SpeedValue = value end})
UI:CreateElement("toggle", section_movement, {name = "jump power", flag = "misc_jumpower", default = false, callback = function(value) getgenv().CONFIG.Misc.JumpPowerEnabled = value if value then enableJumpPower() else disableJumpPower() end end})
UI:CreateElement("slider", section_movement, {name = "jump power value", flag = "misc_jumpvalue", min = 50, max = 300, default = 100, suffix = "", callback = function(value) getgenv().CONFIG.Misc.JumpPowerValue = value end})

local section_visual = UI:CreateElement("section", column1_misc, {name = "visual"})
UI:CreateElement("toggle", section_visual, {name = "loop fov", flag = "misc_loopfov", default = false, callback = function(value) getgenv().CONFIG.Misc.LoopFOVEnabled = value if value then enableLoopFOV() else disableLoopFOV() end end})
UI:CreateElement("toggle", section_visual, {name = "hide head", flag = "misc_hidehead", default = false, callback = function(value) getgenv().CONFIG.Misc.HideHeadEnabled = value if value then hideHeadFE() else showHeadFE() end end})

local section_other = UI:CreateElement("section", column2_misc, {name = "other"})
UI:CreateElement("toggle", section_other, {name = "inf stamina", flag = "misc_infstamina", default = false, callback = function(value) getgenv().CONFIG.Misc.InfStaminaEnabled = value if value then enableInfStamina() else disableInfStamina() end end})
UI:CreateElement("toggle", section_other, {name = "no fall damage", flag = "misc_nofall", default = false, callback = function(value) getgenv().CONFIG.Misc.NoFallDmgEnabled = value if value then enableNoFallDmg() else disableNoFallDmg() end end})
local section_chat = UI:CreateElement("section", column2_misc, {name = "chat"})

UI:CreateElement("toggle", section_chat, {name = "enable chat", default = true, callback = function(value)
    if game:GetService("TextChatService"):FindFirstChild("ChatWindowConfiguration") then
        game:GetService("TextChatService").ChatWindowConfiguration.Enabled = value
    end
end})
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local CustomFont = Font.new("rbxassetid://12187371840")

getgenv().ESP_CONFIG = {
    Enabled = false,
    TeamCheck = true,
    MaxDistance = 500,
    FontSize = 13,
    FadeOut = {
        OnDistance = true,
        OnDeath = true,
        OnLeave = true,
    },
    Options = { 
        Teamcheck = true, 
        TeamcheckRGB = Color3.fromRGB(0, 255, 0),
        Friendcheck = true, 
        FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = true, 
        HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Drawing = {
        Chams = {
            Enabled = true,
            Thermal = true,
            FillRGB = Color3.fromRGB(119, 120, 255),
            Fill_Transparency = 80,
            OutlineRGB = Color3.fromRGB(119, 120, 255),
            Outline_Transparency = 80,
            VisibleCheck = true,
        },
        Names = {
            Enabled = true,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Flags = {
            Enabled = false,
        },
        Distances = {
            Enabled = true, 
            Position = "Text",
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Weapons = {
            Enabled = true, 
            WeaponTextRGB = Color3.fromRGB(119, 120, 255),
            Outlined = true,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(255, 255, 255), 
            GradientRGB2 = Color3.fromRGB(119, 120, 255),
        },
        Healthbar = {
            Enabled = true,  
            HealthText = true, 
            Lerp = true, 
            HealthTextRGB = Color3.fromRGB(119, 120, 255),
            Width = 3,
            Gradient = true, 
            GradientRGB1 = Color3.fromRGB(200, 0, 0), 
            GradientRGB2 = Color3.fromRGB(60, 60, 125), 
            GradientRGB3 = Color3.fromRGB(119, 120, 255), 
        },
        Boxes = {
            Animate = true,
            RotationSpeed = 200,
            Gradient = true, 
            GradientRGB1 = Color3.fromRGB(119, 120, 255), 
            GradientRGB2 = Color3.fromRGB(0, 0, 0), 
            GradientFill = true, 
            GradientFillRGB1 = Color3.fromRGB(119, 120, 255), 
            GradientFillRGB2 = Color3.fromRGB(0, 0, 0), 
            Filled = {
                Enabled = true,
                Transparency = 0.65,
                RGB = Color3.fromRGB(0, 0, 0),
            },
            Full = {
                Enabled = true,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Corner = {
                Enabled = true,
                RGB = Color3.fromRGB(255, 255, 255),
            },
        }
    }
}

local ESP_Functions = {}

function ESP_Functions:Create(Class, Properties)
    local _Instance = typeof(Class) == 'string' and Instance.new(Class) or Class
    for Property, Value in pairs(Properties) do
        _Instance[Property] = Value
    end
    return _Instance
end

function ESP_Functions:FadeOutOnDist(element, distance)
    local transparency = math.max(0.1, 1 - (distance / getgenv().ESP_CONFIG.MaxDistance))
    if element:IsA("TextLabel") then
        element.TextTransparency = 1 - transparency
    elseif element:IsA("ImageLabel") then
        element.ImageTransparency = 1 - transparency
    elseif element:IsA("UIStroke") then
        element.Transparency = 1 - transparency
    elseif element:IsA("Frame") then
        element.BackgroundTransparency = 1 - transparency
    elseif element:IsA("Highlight") then
        element.FillTransparency = 1 - transparency
        element.OutlineTransparency = 1 - transparency
    end
end

local ESPScreenGui = ESP_Functions:Create("ScreenGui", {
    Parent = CoreGui,
    Name = "ESPHolder",
    Enabled = getgenv().ESP_CONFIG.Enabled
})

local ESPCache = {}

local function ESP_InitializePlayer(plr)
    if plr == LocalPlayer then return end
    if ESPCache[plr] then return end
    
    local Name = ESP_Functions:Create("TextLabel", {
        Parent = ESPScreenGui,
        Position = UDim2.new(0.5, 0, 0, -11),
        Size = UDim2.new(0, 100, 0, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = CustomFont,
        TextSize = getgenv().ESP_CONFIG.FontSize,
        TextStrokeTransparency = 0,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        RichText = true,
        Visible = false
    })
    
    local Distance = ESP_Functions:Create("TextLabel", {
        Parent = ESPScreenGui,
        Position = UDim2.new(0.5, 0, 0, 11),
        Size = UDim2.new(0, 100, 0, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = CustomFont,
        TextSize = getgenv().ESP_CONFIG.FontSize,
        TextStrokeTransparency = 0,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        RichText = true,
        Visible = false
    })
    
    local Weapon = ESP_Functions:Create("TextLabel", {
        Parent = ESPScreenGui,
        Position = UDim2.new(0.5, 0, 0, 31),
        Size = UDim2.new(0, 100, 0, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = CustomFont,
        TextSize = getgenv().ESP_CONFIG.FontSize,
        TextStrokeTransparency = 0,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        RichText = true,
        Visible = false
    })
    
    local Box = ESP_Functions:Create("Frame", {
        Parent = ESPScreenGui,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.65,
        BorderSizePixel = 0,
        Visible = false
    })
    
    local Gradient1 = ESP_Functions:Create("UIGradient", {
        Parent = Box,
        Enabled = getgenv().ESP_CONFIG.Drawing.Boxes.GradientFill,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, getgenv().ESP_CONFIG.Drawing.Boxes.GradientFillRGB1),
            ColorSequenceKeypoint.new(1, getgenv().ESP_CONFIG.Drawing.Boxes.GradientFillRGB2)
        }
    })
    
    local Outline = ESP_Functions:Create("UIStroke", {
        Parent = Box,
        Enabled = getgenv().ESP_CONFIG.Drawing.Boxes.Gradient,
        Transparency = 0,
        Color = Color3.fromRGB(255, 255, 255),
        LineJoinMode = Enum.LineJoinMode.Miter
    })
    
    local Gradient2 = ESP_Functions:Create("UIGradient", {
        Parent = Outline,
        Enabled = getgenv().ESP_CONFIG.Drawing.Boxes.Gradient,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, getgenv().ESP_CONFIG.Drawing.Boxes.GradientRGB1),
            ColorSequenceKeypoint.new(1, getgenv().ESP_CONFIG.Drawing.Boxes.GradientRGB2)
        }
    })
    
    local Healthbar = ESP_Functions:Create("Frame", {
        Parent = ESPScreenGui,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0,
        Visible = false
    })
    
    local BehindHealthbar = ESP_Functions:Create("Frame", {
        Parent = ESPScreenGui,
        ZIndex = -1,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0,
        Visible = false
    })
    
    local HealthbarGradient = ESP_Functions:Create("UIGradient", {
        Parent = Healthbar,
        Enabled = getgenv().ESP_CONFIG.Drawing.Healthbar.Gradient,
        Rotation = -90,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, getgenv().ESP_CONFIG.Drawing.Healthbar.GradientRGB1),
            ColorSequenceKeypoint.new(0.5, getgenv().ESP_CONFIG.Drawing.Healthbar.GradientRGB2),
            ColorSequenceKeypoint.new(1, getgenv().ESP_CONFIG.Drawing.Healthbar.GradientRGB3)
        }
    })
    
    local HealthText = ESP_Functions:Create("TextLabel", {
        Parent = ESPScreenGui,
        Position = UDim2.new(0.5, 0, 0, 31),
        Size = UDim2.new(0, 100, 0, 20),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = CustomFont,
        TextSize = getgenv().ESP_CONFIG.FontSize,
        TextStrokeTransparency = 0,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        Visible = false
    })
    
    local Chams = ESP_Functions:Create("Highlight", {
        Parent = ESPScreenGui,
        FillTransparency = 1,
        OutlineTransparency = 0,
        OutlineColor = Color3.fromRGB(119, 120, 255),
        DepthMode = "AlwaysOnTop",
        Enabled = false
    })
    
    local WeaponIcon = ESP_Functions:Create("ImageLabel", {
        Parent = ESPScreenGui,
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 40, 0, 40),
        Visible = false
    })
    
    local Gradient3 = ESP_Functions:Create("UIGradient", {
        Parent = WeaponIcon,
        Rotation = -90,
        Enabled = getgenv().ESP_CONFIG.Drawing.Weapons.Gradient,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, getgenv().ESP_CONFIG.Drawing.Weapons.GradientRGB1),
            ColorSequenceKeypoint.new(1, getgenv().ESP_CONFIG.Drawing.Weapons.GradientRGB2)
        }
    })
    
    local CornerParts = {}
    local cornerNames = {"LeftTop", "LeftSide", "RightTop", "RightSide", "BottomSide", "BottomDown", "BottomRightSide", "BottomRightDown"}
    
    for _, name in ipairs(cornerNames) do
        CornerParts[name] = ESP_Functions:Create("Frame", {
            Parent = ESPScreenGui,
            BackgroundColor3 = getgenv().ESP_CONFIG.Drawing.Boxes.Corner.RGB,
            Size = UDim2.new(0, 1, 0, 1),
            Visible = false
        })
    end
    
    local Flags = {}
    for i = 1, 2 do
        Flags[i] = ESP_Functions:Create("TextLabel", {
            Parent = ESPScreenGui,
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.new(0, 100, 0, 20),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = CustomFont,
            TextSize = getgenv().ESP_CONFIG.FontSize,
            TextStrokeTransparency = 0,
            TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
            Visible = false
        })
    end
    
    ESPCache[plr] = {
        Name = Name,
        Distance = Distance,
        Weapon = Weapon,
        Box = Box,
        Gradient1 = Gradient1,
        Outline = Outline,
        Gradient2 = Gradient2,
        Healthbar = Healthbar,
        BehindHealthbar = BehindHealthbar,
        HealthbarGradient = HealthbarGradient,
        HealthText = HealthText,
        Chams = Chams,
        WeaponIcon = WeaponIcon,
        Gradient3 = Gradient3,
        CornerParts = CornerParts,
        Flags = Flags,
        Player = plr,
        Connection = nil
    }
    
    local function HideESP()
        Name.Visible = false
        Distance.Visible = false
        Weapon.Visible = false
        Box.Visible = false
        Healthbar.Visible = false
        BehindHealthbar.Visible = false
        HealthText.Visible = false
        Chams.Enabled = false
        WeaponIcon.Visible = false
        
        for _, corner in pairs(CornerParts) do
            corner.Visible = false
        end
        
        for _, flag in ipairs(Flags) do
            flag.Visible = false
        end
    end
    
    local RotationAngle, Tick = -45, tick()
    
    local connection = RunService.RenderStepped:Connect(function()
        if not getgenv().ESP_CONFIG.Enabled then
            HideESP()
            return
        end
        
        if not plr or not plr.Character then
            HideESP()
            return
        end
        
        local character = plr.Character
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if not hrp or not humanoid or humanoid.Health <= 0 then
            HideESP()
            return
        end
        
        local camera = Workspace.CurrentCamera
        local pos, onScreen = camera:WorldToScreenPoint(hrp.Position)
        local dist = (camera.CFrame.Position - hrp.Position).Magnitude / 3.5714285714
        
        if not onScreen or dist > getgenv().ESP_CONFIG.MaxDistance then
            HideESP()
            return
        end
        
        if getgenv().ESP_CONFIG.TeamCheck and LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then
            HideESP()
            return
        end
        
        local size = hrp.Size.Y
        local scaleFactor = (size * camera.ViewportSize.Y) / (pos.Z * 2)
        local w, h = 3 * scaleFactor, 4.5 * scaleFactor
        
        if getgenv().ESP_CONFIG.FadeOut.OnDistance then
            ESP_Functions:FadeOutOnDist(Box, dist)
            ESP_Functions:FadeOutOnDist(Outline, dist)
            ESP_Functions:FadeOutOnDist(Name, dist)
            ESP_Functions:FadeOutOnDist(Distance, dist)
            ESP_Functions:FadeOutOnDist(Weapon, dist)
            ESP_Functions:FadeOutOnDist(Healthbar, dist)
            ESP_Functions:FadeOutOnDist(BehindHealthbar, dist)
            ESP_Functions:FadeOutOnDist(HealthText, dist)
            ESP_Functions:FadeOutOnDist(WeaponIcon, dist)
            ESP_Functions:FadeOutOnDist(Chams, dist)
            
            for _, corner in pairs(CornerParts) do
                ESP_Functions:FadeOutOnDist(corner, dist)
            end
            
            for _, flag in ipairs(Flags) do
                ESP_Functions:FadeOutOnDist(flag, dist)
            end
        end
        
        Chams.Adornee = character
        Chams.Enabled = getgenv().ESP_CONFIG.Drawing.Chams.Enabled
        Chams.FillColor = getgenv().ESP_CONFIG.Drawing.Chams.FillRGB
        Chams.OutlineColor = getgenv().ESP_CONFIG.Drawing.Chams.OutlineRGB
        
        if getgenv().ESP_CONFIG.Drawing.Chams.Thermal then
            local breathe = math.sin(tick() * 2) * 0.5 + 0.5
            Chams.FillTransparency = getgenv().ESP_CONFIG.Drawing.Chams.Fill_Transparency * breathe * 0.01
            Chams.OutlineTransparency = getgenv().ESP_CONFIG.Drawing.Chams.Outline_Transparency * breathe * 0.01
        end
        
        if getgenv().ESP_CONFIG.Drawing.Chams.VisibleCheck then
            Chams.DepthMode = "Occluded"
        else
            Chams.DepthMode = "AlwaysOnTop"
        end
        
        Box.Position = UDim2.new(0, pos.X - w/2, 0, pos.Y - h/2)
        Box.Size = UDim2.new(0, w, 0, h)
        Box.Visible = getgenv().ESP_CONFIG.Drawing.Boxes.Full.Enabled
        
        if getgenv().ESP_CONFIG.Drawing.Boxes.Filled.Enabled then
            Box.BackgroundTransparency = getgenv().ESP_CONFIG.Drawing.Boxes.Filled.Transparency
        else
            Box.BackgroundTransparency = 1
        end
        
        RotationAngle = RotationAngle + (tick() - Tick) * getgenv().ESP_CONFIG.Drawing.Boxes.RotationSpeed
        if getgenv().ESP_CONFIG.Drawing.Boxes.Animate then
            Gradient1.Rotation = RotationAngle
            Gradient2.Rotation = RotationAngle
        else
            Gradient1.Rotation = -45
            Gradient2.Rotation = -45
        end
        Tick = tick()
        
        if getgenv().ESP_CONFIG.Drawing.Boxes.Corner.Enabled then
            local corners = CornerParts
            corners.LeftTop.Position = UDim2.new(0, pos.X - w/2, 0, pos.Y - h/2)
            corners.LeftTop.Size = UDim2.new(0, w/5, 0, 1)
            corners.LeftTop.Visible = true
            
            corners.LeftSide.Position = UDim2.new(0, pos.X - w/2, 0, pos.Y - h/2)
            corners.LeftSide.Size = UDim2.new(0, 1, 0, h/5)
            corners.LeftSide.Visible = true
            
            corners.RightTop.Position = UDim2.new(0, pos.X + w/2 - w/5, 0, pos.Y - h/2)
            corners.RightTop.Size = UDim2.new(0, w/5, 0, 1)
            corners.RightTop.Visible = true
            
            corners.RightSide.Position = UDim2.new(0, pos.X + w/2 - 1, 0, pos.Y - h/2)
            corners.RightSide.Size = UDim2.new(0, 1, 0, h/5)
            corners.RightSide.Visible = true
            
            corners.BottomSide.Position = UDim2.new(0, pos.X - w/2, 0, pos.Y + h/2 - h/5)
            corners.BottomSide.Size = UDim2.new(0, 1, 0, h/5)
            corners.BottomSide.Visible = true
            
            corners.BottomDown.Position = UDim2.new(0, pos.X - w/2, 0, pos.Y + h/2)
            corners.BottomDown.Size = UDim2.new(0, w/5, 0, 1)
            corners.BottomDown.Visible = true
            
            corners.BottomRightSide.Position = UDim2.new(0, pos.X + w/2 - 1, 0, pos.Y + h/2 - h/5)
            corners.BottomRightSide.Size = UDim2.new(0, 1, 0, h/5)
            corners.BottomRightSide.Visible = true
            
            corners.BottomRightDown.Position = UDim2.new(0, pos.X + w/2 - w/5, 0, pos.Y + h/2)
            corners.BottomRightDown.Size = UDim2.new(0, w/5, 0, 1)
            corners.BottomRightDown.Visible = true
        end
        
        local health = humanoid.Health / humanoid.MaxHealth
        Healthbar.Visible = getgenv().ESP_CONFIG.Drawing.Healthbar.Enabled
        Healthbar.Position = UDim2.new(0, pos.X - w/2 - 6, 0, pos.Y - h/2 + h * (1 - health))
        Healthbar.Size = UDim2.new(0, getgenv().ESP_CONFIG.Drawing.Healthbar.Width, 0, h * health)
        
        BehindHealthbar.Visible = getgenv().ESP_CONFIG.Drawing.Healthbar.Enabled
        BehindHealthbar.Position = UDim2.new(0, pos.X - w/2 - 6, 0, pos.Y - h/2)
        BehindHealthbar.Size = UDim2.new(0, getgenv().ESP_CONFIG.Drawing.Healthbar.Width, 0, h)
        
        if getgenv().ESP_CONFIG.Drawing.Healthbar.HealthText then
            local healthPercentage = math.floor(health * 100)
            HealthText.Position = UDim2.new(0, pos.X - w/2 - 12, 0, pos.Y - h/2 + h * (1 - health/100) + 3)
            HealthText.Text = tostring(healthPercentage)
            HealthText.Visible = humanoid.Health < humanoid.MaxHealth
            
            if getgenv().ESP_CONFIG.Drawing.Healthbar.Lerp then
                local color = health >= 0.75 and Color3.fromRGB(0, 255, 0) 
                    or health >= 0.5 and Color3.fromRGB(255, 255, 0) 
                    or health >= 0.25 and Color3.fromRGB(255, 170, 0) 
                    or Color3.fromRGB(255, 0, 0)
                HealthText.TextColor3 = color
            else
                HealthText.TextColor3 = getgenv().ESP_CONFIG.Drawing.Healthbar.HealthTextRGB
            end
        end
        
        Name.Visible = getgenv().ESP_CONFIG.Drawing.Names.Enabled
        Name.Position = UDim2.new(0, pos.X, 0, pos.Y - h/2 - 9)
        
        if getgenv().ESP_CONFIG.Options.Friendcheck and LocalPlayer:IsFriendsWith(plr.UserId) then
            Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s', 
                getgenv().ESP_CONFIG.Options.FriendcheckRGB.R * 255,
                getgenv().ESP_CONFIG.Options.FriendcheckRGB.G * 255,
                getgenv().ESP_CONFIG.Options.FriendcheckRGB.B * 255,
                plr.Name)
        else
            Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s', 
                255, 0, 0, plr.Name)
        end
        
        if getgenv().ESP_CONFIG.Drawing.Distances.Enabled then
            if getgenv().ESP_CONFIG.Drawing.Distances.Position == "Bottom" then
                Distance.Position = UDim2.new(0, pos.X, 0, pos.Y + h/2 + 7)
                Distance.Text = string.format("%d m", math.floor(dist))
                Distance.Visible = true
            else
                if getgenv().ESP_CONFIG.Options.Friendcheck and LocalPlayer:IsFriendsWith(plr.UserId) then
                    Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s [%d]', 
                        getgenv().ESP_CONFIG.Options.FriendcheckRGB.R * 255,
                        getgenv().ESP_CONFIG.Options.FriendcheckRGB.G * 255,
                        getgenv().ESP_CONFIG.Options.FriendcheckRGB.B * 255,
                        plr.Name, math.floor(dist))
                else
                    Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s [%d]', 
                        255, 0, 0, plr.Name, math.floor(dist))
                end
                Distance.Visible = false
            end
        end
        
        Weapon.Visible = getgenv().ESP_CONFIG.Drawing.Weapons.Enabled
        Weapon.Position = UDim2.new(0, pos.X, 0, pos.Y + h/2 + 18)
        Weapon.Text = "Weapon"
    end)
    
    ESPCache[plr].Connection = connection
end

local function ESP_RemovePlayer(plr)
    if ESPCache[plr] then
        if ESPCache[plr].Connection then
            ESPCache[plr].Connection:Disconnect()
        end
        
        local elements = ESPCache[plr]
        elements.Name:Destroy()
        elements.Distance:Destroy()
        elements.Weapon:Destroy()
        elements.Box:Destroy()
        elements.Healthbar:Destroy()
        elements.BehindHealthbar:Destroy()
        elements.HealthText:Destroy()
        elements.Chams:Destroy()
        elements.WeaponIcon:Destroy()
        
        for _, corner in pairs(elements.CornerParts) do
            corner:Destroy()
        end
        
        for _, flag in ipairs(elements.Flags) do
            flag:Destroy()
        end
        
        ESPCache[plr] = nil
    end
end

local function ESP_InitializeAll()
    ESPScreenGui.Enabled = getgenv().ESP_CONFIG.Enabled
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ESP_InitializePlayer(player)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        task.wait(1)
        ESP_InitializePlayer(player)
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        ESP_RemovePlayer(player)
    end)
end

local function ESP_Toggle(state)
    getgenv().ESP_CONFIG.Enabled = state
    ESPScreenGui.Enabled = state
    
    if not state then
        for player, data in pairs(ESPCache) do
            ESP_RemovePlayer(player)
        end
    else
        ESP_InitializeAll()
    end
end

local tab_visualize = UI:CreateElement("tab", window, {name = "visualize"})
local column1_visualize = UI:CreateElement("column", tab_visualize, {fill = true})
local column2_visualize = UI:CreateElement("column", tab_visualize, {fill = true})

local section_main = UI:CreateElement("section", column1_visualize, {name = "ESP Settings"})
UI:CreateElement("toggle", section_main, {name = "enable esp", flag = "esp_enabled", default = false, callback = function(value) ESP_Toggle(value) end})
UI:CreateElement("toggle", section_main, {name = "team check", flag = "esp_teamcheck", default = true, callback = function(value) getgenv().ESP_CONFIG.TeamCheck = value end})
UI:CreateElement("toggle", section_main, {name = "teamcheck", flag = "esp_teamcheck_option", default = true, callback = function(value) getgenv().ESP_CONFIG.Options.Teamcheck = value end})
UI:CreateElement("toggle", section_main, {name = "friendcheck", flag = "esp_friendcheck", default = true, callback = function(value) getgenv().ESP_CONFIG.Options.Friendcheck = value end})
UI:CreateElement("toggle", section_main, {name = "highlight", flag = "esp_highlight", default = true, callback = function(value) getgenv().ESP_CONFIG.Options.Highlight = value end})
UI:CreateElement("slider", section_main, {name = "max distance", flag = "esp_maxdistance", min = 100, max = 2000, default = 500, suffix = " studs", callback = function(value) getgenv().ESP_CONFIG.MaxDistance = value end})
UI:CreateElement("slider", section_main, {name = "font size", flag = "esp_fontsize", min = 8, max = 20, default = 13, suffix = "", callback = function(value) getgenv().ESP_CONFIG.FontSize = value end})

local section_fade = UI:CreateElement("section", column1_visualize, {name = "Fade Settings"})
UI:CreateElement("toggle", section_fade, {name = "fade on distance", flag = "esp_fade_distance", default = true, callback = function(value) getgenv().ESP_CONFIG.FadeOut.OnDistance = value end})
UI:CreateElement("toggle", section_fade, {name = "fade on death", flag = "esp_fade_death", default = true, callback = function(value) getgenv().ESP_CONFIG.FadeOut.OnDeath = value end})
UI:CreateElement("toggle", section_fade, {name = "fade on leave", flag = "esp_fade_leave", default = true, callback = function(value) getgenv().ESP_CONFIG.FadeOut.OnLeave = value end})

local section_drawing = UI:CreateElement("section", column2_visualize, {name = "Drawing Settings"})
UI:CreateElement("toggle", section_drawing, {name = "chams enabled", flag = "chams_enabled", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Chams.Enabled = value end})
UI:CreateElement("toggle", section_drawing, {name = "thermal chams", flag = "chams_thermal", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Chams.Thermal = value end})
UI:CreateElement("toggle", section_drawing, {name = "visible check", flag = "chams_visible", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Chams.VisibleCheck = value end})
UI:CreateElement("colorpicker", section_drawing, {name = "chams fill color", flag = "chams_fill", default = Color3.fromRGB(119, 120, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Chams.FillRGB = value end})
UI:CreateElement("colorpicker", section_drawing, {name = "chams outline color", flag = "chams_outline", default = Color3.fromRGB(119, 120, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Chams.OutlineRGB = value end})
UI:CreateElement("slider", section_drawing, {name = "chams fill transparency", flag = "chams_fill_trans", min = 0, max = 100, default = 80, suffix = "%", callback = function(value) getgenv().ESP_CONFIG.Drawing.Chams.Fill_Transparency = value end})
UI:CreateElement("slider", section_drawing, {name = "chams outline transparency", flag = "chams_outline_trans", min = 0, max = 100, default = 80, suffix = "%", callback = function(value) getgenv().ESP_CONFIG.Drawing.Chams.Outline_Transparency = value end})

local section_names = UI:CreateElement("section", column2_visualize, {name = "Name Settings"})
UI:CreateElement("toggle", section_names, {name = "names enabled", flag = "names_enabled", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Names.Enabled = value end})
UI:CreateElement("colorpicker", section_names, {name = "name color", flag = "names_color", default = Color3.fromRGB(255, 255, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Names.RGB = value end})

local section_flags = UI:CreateElement("section", column1_visualize, {name = "Flag Settings"})
UI:CreateElement("toggle", section_flags, {name = "flags enabled", flag = "flags_enabled", default = false, callback = function(value) getgenv().ESP_CONFIG.Drawing.Flags.Enabled = value end})

local section_distances = UI:CreateElement("section", column1_visualize, {name = "Distance Settings"})
UI:CreateElement("toggle", section_distances, {name = "distances enabled", flag = "distances_enabled", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Distances.Enabled = value end})
UI:CreateElement("dropdown", section_distances, {name = "distance position", flag = "distances_position", default = "Text", options = {"Text", "Bottom"}, callback = function(value) getgenv().ESP_CONFIG.Drawing.Distances.Position = value end})
UI:CreateElement("colorpicker", section_distances, {name = "distance color", flag = "distances_color", default = Color3.fromRGB(255, 255, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Distances.RGB = value end})

local section_weapons = UI:CreateElement("section", column2_visualize, {name = "Weapon Settings"})
UI:CreateElement("toggle", section_weapons, {name = "weapons enabled", flag = "weapons_enabled", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Weapons.Enabled = value end})
UI:CreateElement("toggle", section_weapons, {name = "weapon outlined", flag = "weapon_outlined", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Weapons.Outlined = value end})
UI:CreateElement("toggle", section_weapons, {name = "weapon gradient", flag = "weapon_gradient", default = false, callback = function(value) getgenv().ESP_CONFIG.Drawing.Weapons.Gradient = value end})
UI:CreateElement("colorpicker", section_weapons, {name = "weapon text color", flag = "weapon_text", default = Color3.fromRGB(119, 120, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Weapons.WeaponTextRGB = value end})
UI:CreateElement("colorpicker", section_weapons, {name = "gradient color 1", flag = "weapon_grad1", default = Color3.fromRGB(255, 255, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Weapons.GradientRGB1 = value end})
UI:CreateElement("colorpicker", section_weapons, {name = "gradient color 2", flag = "weapon_grad2", default = Color3.fromRGB(119, 120, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Weapons.GradientRGB2 = value end})

local section_healthbar = UI:CreateElement("section", column1_visualize, {name = "Healthbar Settings"})
UI:CreateElement("toggle", section_healthbar, {name = "healthbar enabled", flag = "healthbar_enabled", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Healthbar.Enabled = value end})
UI:CreateElement("toggle", section_healthbar, {name = "health text", flag = "health_text", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Healthbar.HealthText = value end})
UI:CreateElement("toggle", section_healthbar, {name = "health lerp", flag = "health_lerp", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Healthbar.Lerp = value end})
UI:CreateElement("toggle", section_healthbar, {name = "health gradient", flag = "health_gradient", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Healthbar.Gradient = value end})
UI:CreateElement("colorpicker", section_healthbar, {name = "health text color", flag = "health_text_color", default = Color3.fromRGB(119, 120, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Healthbar.HealthTextRGB = value end})
UI:CreateElement("colorpicker", section_healthbar, {name = "gradient color 1", flag = "health_grad1", default = Color3.fromRGB(200, 0, 0), callback = function(value) getgenv().ESP_CONFIG.Drawing.Healthbar.GradientRGB1 = value end})
UI:CreateElement("colorpicker", section_healthbar, {name = "gradient color 2", flag = "health_grad2", default = Color3.fromRGB(60, 60, 125), callback = function(value) getgenv().ESP_CONFIG.Drawing.Healthbar.GradientRGB2 = value end})
UI:CreateElement("colorpicker", section_healthbar, {name = "gradient color 3", flag = "health_grad3", default = Color3.fromRGB(119, 120, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Healthbar.GradientRGB3 = value end})
UI:CreateElement("slider", section_healthbar, {name = "healthbar width", flag = "health_width", min = 1, max = 10, default = 3, suffix = " px", callback = function(value) getgenv().ESP_CONFIG.Drawing.Healthbar.Width = value end})

local section_boxes = UI:CreateElement("section", column2_visualize, {name = "Box Settings"})
UI:CreateElement("toggle", section_boxes, {name = "box animate", flag = "box_animate", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.Animate = value end})
UI:CreateElement("toggle", section_boxes, {name = "box gradient", flag = "box_gradient", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.Gradient = value end})
UI:CreateElement("toggle", section_boxes, {name = "box fill gradient", flag = "box_fill_gradient", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.GradientFill = value end})
UI:CreateElement("toggle", section_boxes, {name = "box filled", flag = "box_filled", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.Filled.Enabled = value end})
UI:CreateElement("toggle", section_boxes, {name = "full box", flag = "box_full", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.Full.Enabled = value end})
UI:CreateElement("toggle", section_boxes, {name = "corner box", flag = "box_corner", default = true, callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.Corner.Enabled = value end})
UI:CreateElement("slider", section_boxes, {name = "rotation speed", flag = "box_rotation", min = 0, max = 500, default = 200, suffix = "", callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.RotationSpeed = value end})
UI:CreateElement("slider", section_boxes, {name = "filled transparency", flag = "box_filled_trans", min = 0, max = 100, default = 65, suffix = "%", callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.Filled.Transparency = value end})
UI:CreateElement("colorpicker", section_boxes, {name = "gradient color 1", flag = "box_grad1", default = Color3.fromRGB(119, 120, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.GradientRGB1 = value end})
UI:CreateElement("colorpicker", section_boxes, {name = "gradient color 2", flag = "box_grad2", default = Color3.fromRGB(0, 0, 0), callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.GradientRGB2 = value end})
UI:CreateElement("colorpicker", section_boxes, {name = "fill gradient color 1", flag = "box_fill_grad1", default = Color3.fromRGB(119, 120, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.GradientFillRGB1 = value end})
UI:CreateElement("colorpicker", section_boxes, {name = "fill gradient color 2", flag = "box_fill_grad2", default = Color3.fromRGB(0, 0, 0), callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.GradientFillRGB2 = value end})
UI:CreateElement("colorpicker", section_boxes, {name = "filled color", flag = "box_filled_color", default = Color3.fromRGB(0, 0, 0), callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.Filled.RGB = value end})
UI:CreateElement("colorpicker", section_boxes, {name = "full box color", flag = "box_full_color", default = Color3.fromRGB(255, 255, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.Full.RGB = value end})
UI:CreateElement("colorpicker", section_boxes, {name = "corner box color", flag = "box_corner_color", default = Color3.fromRGB(255, 255, 255), callback = function(value) getgenv().ESP_CONFIG.Drawing.Boxes.Corner.RGB = value end})

local section_options = UI:CreateElement("section", column1_visualize, {name = "Option Colors"})
UI:CreateElement("colorpicker", section_options, {name = "teamcheck color", flag = "teamcheck_color", default = Color3.fromRGB(0, 255, 0), callback = function(value) getgenv().ESP_CONFIG.Options.TeamcheckRGB = value end})
UI:CreateElement("colorpicker", section_options, {name = "friendcheck color", flag = "friendcheck_color", default = Color3.fromRGB(0, 255, 0), callback = function(value) getgenv().ESP_CONFIG.Options.FriendcheckRGB = value end})
UI:CreateElement("colorpicker", section_options, {name = "highlight color", flag = "highlight_color", default = Color3.fromRGB(255, 0, 0), callback = function(value) getgenv().ESP_CONFIG.Options.HighlightRGB = value end})

task.spawn(function()
    task.wait(2)
    ESP_InitializeAll()
end)

print("ESP System Loaded")

local section_forcefield = UI:CreateElement("section", column1_visualize, {name = "forcefield material"})
UI:CreateElement("toggle", section_forcefield, {name = "enable forcefield", flag = "visualize_forcefield_enabled", default = false, callback = function(value)
    getgenv().CONFIG.Visualize.LocalForcefieldEnabled = value
    if value then
        applyForcefieldToBodyParts()
    else
        removeForcefieldFromBodyParts()
    end
end})

UI:CreateElement("slider", section_forcefield, {name = "forcefield transparency", flag = "visualize_forcefield_transparency", min = 0, max = 1, default = 0.5, suffix = "", callback = function(value)
    getgenv().CONFIG.Visualize.ForcefieldTransparency = value
    if getgenv().CONFIG.Visualize.LocalForcefieldEnabled then
        applyForcefieldToBodyParts()
    end
end})

UI:CreateElement("colorpicker", section_forcefield, {name = "forcefield color", flag = "visualize_forcefield_color", default = Color3.fromRGB(255, 255, 255), callback = function(value)
    getgenv().CONFIG.Visualize.ForcefieldColor = value
    if getgenv().CONFIG.Visualize.LocalForcefieldEnabled then
        applyForcefieldToBodyParts()
    end
end})

local Arrow = {
    Enabled = false,
    DistFromCenter = 80,
    TriangleHeight = 16,
    TriangleWidth = 16,
    TriangleTransparency = 0,
    TriangleThickness = 1,
    TriangleColor = Color3.fromRGB(255, 255, 255),
    AntiAliasing = false,
    Players = game:service("Players"),
    Camera = workspace.CurrentCamera,
    RS = game:service("RunService"),
    LocalPlayer = game:service("Players").LocalPlayer,
    ArrowConnections = {},
    ArrowDrawings = {}
}

function Arrow:GetRelative(pos, char)
    if not char then return Vector2.new(0,0) end
    local rootP = char.PrimaryPart.Position
    local camP = Arrow.Camera.CFrame.Position
    local relative = CFrame.new(Vector3.new(rootP.X, camP.Y, rootP.Z), camP):PointToObjectSpace(pos)
    return Vector2.new(relative.X, relative.Z)
end

function Arrow:RelativeToCenter(v)
    return Arrow.Camera.ViewportSize/2 - v
end

function Arrow:RotateVect(v, a)
    a = math.rad(a)
    local x = v.x * math.cos(a) - v.y * math.sin(a)
    local y = v.x * math.sin(a) + v.y * math.cos(a)
    return Vector2.new(x, y)
end

function Arrow:AntiA(v)
    if not Arrow.AntiAliasing then return v end
    return Vector2.new(math.round(v.x), math.round(v.y))
end

function Arrow:DrawTriangleLines(color)
    local line1 = Drawing.new("Line")
    local line2 = Drawing.new("Line")
    local line3 = Drawing.new("Line")
    line1.Visible = false
    line2.Visible = false
    line3.Visible = false
    line1.Color = color
    line2.Color = color
    line3.Color = color
    line1.Thickness = Arrow.TriangleThickness
    line2.Thickness = Arrow.TriangleThickness
    line3.Thickness = Arrow.TriangleThickness
    line1.Transparency = 1-Arrow.TriangleTransparency
    line2.Transparency = 1-Arrow.TriangleTransparency
    line3.Transparency = 1-Arrow.TriangleTransparency
    return {line1, line2, line3}
end

function Arrow:UpdateTriangleLines(lines, pointA, pointB, pointC)
    lines[1].From = pointA
    lines[1].To = pointB
    lines[2].From = pointB
    lines[2].To = pointC
    lines[3].From = pointC
    lines[3].To = pointA
end

function Arrow:ShowArrow(player)
    local lines = Arrow:DrawTriangleLines(Arrow.TriangleColor)
    Arrow.ArrowDrawings[player] = lines
    local function Update()
        local c = Arrow.RS.RenderStepped:Connect(function()
            if not Arrow.ArrowDrawings[player] or not Arrow.Enabled then
                if c then c:Disconnect() end
                return
            end
            if player and player.Character and Arrow.LocalPlayer and Arrow.LocalPlayer.Character then
                local CHAR = player.Character
                local HUM = CHAR:FindFirstChildOfClass("Humanoid")
                if HUM and CHAR.PrimaryPart ~= nil and HUM.Health > 0 then
                    local _,vis = Arrow.Camera:WorldToViewportPoint(CHAR.PrimaryPart.Position)
                    if vis == false then
                        local rel = Arrow:GetRelative(CHAR.PrimaryPart.Position, Arrow.LocalPlayer.Character)
                        local direction = rel.Unit
                        local base = direction * Arrow.DistFromCenter
                        local sideLength = Arrow.TriangleWidth/2
                        local baseL = base + Arrow:RotateVect(direction, 90) * sideLength
                        local baseR = base + Arrow:RotateVect(direction, -90) * sideLength
                        local tip = direction * (Arrow.DistFromCenter + Arrow.TriangleHeight)
                        local pointA = Arrow:AntiA(Arrow:RelativeToCenter(baseL))
                        local pointB = Arrow:AntiA(Arrow:RelativeToCenter(baseR))
                        local pointC = Arrow:AntiA(Arrow:RelativeToCenter(tip))
                        Arrow:UpdateTriangleLines(lines, pointA, pointB, pointC)
                        lines[1].Visible = true
                        lines[2].Visible = true
                        lines[3].Visible = true
                    else 
                        lines[1].Visible = false
                        lines[2].Visible = false
                        lines[3].Visible = false
                    end
                else 
                    lines[1].Visible = false
                    lines[2].Visible = false
                    lines[3].Visible = false
                end
            else 
                lines[1].Visible = false
                lines[2].Visible = false
                lines[3].Visible = false
            end
        end)
    end
    local connection = Update()
    Arrow.ArrowConnections[player] = connection
end

function Arrow:RemoveArrow(player)
    if Arrow.ArrowDrawings[player] then
        local lines = Arrow.ArrowDrawings[player]
        for _, line in ipairs(lines) do
            line.Visible = false
        end
        Arrow.ArrowDrawings[player] = nil
    end
    if Arrow.ArrowConnections[player] then
        Arrow.ArrowConnections[player] = nil
    end
end

function Arrow:UpdateAllArrows()
    if not Arrow.Enabled then return end
    for player, lines in pairs(Arrow.ArrowDrawings) do
        if player and player.Parent and player.Character and Arrow.LocalPlayer and Arrow.LocalPlayer.Character then
            local CHAR = player.Character
            local HUM = CHAR:FindFirstChildOfClass("Humanoid")
            if HUM and CHAR.PrimaryPart ~= nil and HUM.Health > 0 then
                local _,vis = Arrow.Camera:WorldToViewportPoint(CHAR.PrimaryPart.Position)
                if vis == false then
                    local rel = Arrow:GetRelative(CHAR.PrimaryPart.Position, Arrow.LocalPlayer.Character)
                    local direction = rel.Unit
                    local base = direction * Arrow.DistFromCenter
                    local sideLength = Arrow.TriangleWidth/2
                    local baseL = base + Arrow:RotateVect(direction, 90) * sideLength
                    local baseR = base + Arrow:RotateVect(direction, -90) * sideLength
                    local tip = direction * (Arrow.DistFromCenter + Arrow.TriangleHeight)
                    local pointA = Arrow:AntiA(Arrow:RelativeToCenter(baseL))
                    local pointB = Arrow:AntiA(Arrow:RelativeToCenter(baseR))
                    local pointC = Arrow:AntiA(Arrow:RelativeToCenter(tip))
                    Arrow:UpdateTriangleLines(lines, pointA, pointB, pointC)
                    lines[1].Visible = true
                    lines[2].Visible = true
                    lines[3].Visible = true
                else
                    lines[1].Visible = false
                    lines[2].Visible = false
                    lines[3].Visible = false
                end
            else
                lines[1].Visible = false
                lines[2].Visible = false
                lines[3].Visible = false
            end
        else
            lines[1].Visible = false
            lines[2].Visible = false
            lines[3].Visible = false
        end
    end
end

function Arrow:CleanUpArrows()
    for player, lines in pairs(Arrow.ArrowDrawings) do
        if not player or not player.Parent then
            for _, line in ipairs(lines) do
                line.Visible = false
            end
            Arrow.ArrowDrawings[player] = nil
            Arrow.ArrowConnections[player] = nil
        end
    end
end

function Arrow:Init()
    Arrow.ArrowDrawings = {}
    Arrow.ArrowConnections = {}
    for _, player in pairs(Arrow.Players:GetChildren()) do
        if player ~= Arrow.LocalPlayer then
            Arrow:ShowArrow(player)
        end
    end
    Arrow.Players.PlayerAdded:Connect(function(player)
        if player ~= Arrow.LocalPlayer then
            Arrow:ShowArrow(player)
        end
    end)
    Arrow.Players.PlayerRemoving:Connect(function(player)
        Arrow:RemoveArrow(player)
    end)
    Arrow.RS.RenderStepped:Connect(function()
        if Arrow.Enabled then
            Arrow:CleanUpArrows()
            Arrow:UpdateAllArrows()
        end
    end)
end

function Arrow:UpdateSettings()
    for player, lines in pairs(Arrow.ArrowDrawings) do
        if lines and #lines >= 3 then
            lines[1].Color = Arrow.TriangleColor
            lines[2].Color = Arrow.TriangleColor
            lines[3].Color = Arrow.TriangleColor
            lines[1].Thickness = Arrow.TriangleThickness
            lines[2].Thickness = Arrow.TriangleThickness
            lines[3].Thickness = Arrow.TriangleThickness
            lines[1].Transparency = 1-Arrow.TriangleTransparency
            lines[2].Transparency = 1-Arrow.TriangleTransparency
            lines[3].Transparency = 1-Arrow.TriangleTransparency
        end
    end
end

function Arrow:Enable(enabled)
    Arrow.Enabled = enabled
    if enabled then
        Arrow:Init()
    else
        for player, _ in pairs(Arrow.ArrowDrawings) do
            Arrow:RemoveArrow(player)
        end
        Arrow.ArrowDrawings = {}
        Arrow.ArrowConnections = {}
    end
end


local section_arrow = UI:CreateElement("section", column2_visualize, {name = "arrow indicators"})

UI:CreateElement("toggle", section_arrow, {name = "enable arrow indicators", flag = "visualize_arrow_enabled", default = false, callback = function(value)
    Arrow:Enable(value)
end})

UI:CreateElement("colorpicker", section_arrow, {name = "arrow color", flag = "visualize_arrow_color", default = Color3.fromRGB(255, 255, 255), callback = function(value)
    Arrow.TriangleColor = value
    Arrow:UpdateSettings()
end})

UI:CreateElement("slider", section_arrow, {name = "arrow distance", flag = "visualize_arrow_distance", min = 50, max = 200, default = 80, suffix = "", callback = function(value)
    Arrow.DistFromCenter = value
end})

UI:CreateElement("slider", section_arrow, {name = "arrow size", flag = "visualize_arrow_size", min = 8, max = 32, default = 16, suffix = "", callback = function(value)
    Arrow.TriangleHeight = value
    Arrow.TriangleWidth = value
end})

UI:CreateElement("slider", section_arrow, {name = "arrow thickness", flag = "visualize_arrow_thickness", min = 1, max = 5, default = 1, suffix = "", callback = function(value)
    Arrow.TriangleThickness = value
    Arrow:UpdateSettings()
end})

UI:CreateElement("toggle", section_arrow, {name = "anti aliasing", flag = "visualize_arrow_aa", default = false, callback = function(value)
    Arrow.AntiAliasing = value
end})

local tab_lists = UI:CreateElement("tab", window, {name = "lists"})
local column1_lists = UI:CreateElement("column", tab_lists, {fill = true})
local column2_lists = UI:CreateElement("column", tab_lists, {fill = true})

local section_targetlist = UI:CreateElement("section", column1_lists, {name = "target list"})
UI:CreateElement("textbox", section_targetlist, {name = "add to target list", placeholder = "player name", callback = function(text) if text and text ~= "" then table.insert(getgenv().Lists.TargetList, text) end end})
UI:CreateElement("button", section_targetlist, {name = "clear target list", callback = function() getgenv().Lists.TargetList = {} end})

local section_whitelist = UI:CreateElement("section", column2_lists, {name = "whitelist"})
UI:CreateElement("textbox", section_whitelist, {name = "add to whitelist", placeholder = "player name", callback = function(text) if text and text ~= "" then table.insert(getgenv().Lists.Whitelist, text) end end})
UI:CreateElement("button", section_whitelist, {name = "clear whitelist", callback = function() getgenv().Lists.Whitelist = {} end})

local section_controls = UI:CreateElement("section", column1_lists, {name = "controls"})
UI:CreateElement("toggle", section_controls, {name = "use target list", flag = "lists_usetargetlist", default = false, callback = function(value) getgenv().CONFIG.Ragebot.UseTargetList = value end})
UI:CreateElement("toggle", section_controls, {name = "use whitelist", flag = "lists_usewhitelist", default = false, callback = function(value) getgenv().CONFIG.Ragebot.UseWhitelist = value end})
local tab_config = UI:CreateElement("tab", window, {name = "configuration"})
local column1_config = UI:CreateElement("column", tab_config, {fill = true})
local column2_config = UI:CreateElement("column", tab_config, {fill = true})

local section_save = UI:CreateElement("section", column1_config, {name = "save/load"})

UI:CreateElement("button", section_save, {name = "save config", callback = function()
    if writefile then
        local allConfigs = {}
        
        local genv = getgenv()
        for key, value in pairs(genv) do
            if type(value) == "table" then
                allConfigs[key] = value
            elseif type(value) == "Color3" then
                allConfigs[key] = {R = value.R, G = value.G, B = value.B, __type = "Color3"}
            else
                allConfigs[key] = value
            end
        end
        
        allConfigs["Arrow"] = {
            Enabled = Arrow.Enabled,
            DistFromCenter = Arrow.DistFromCenter,
            TriangleHeight = Arrow.TriangleHeight,
            TriangleWidth = Arrow.TriangleWidth,
            TriangleTransparency = Arrow.TriangleTransparency,
            TriangleThickness = Arrow.TriangleThickness,
            TriangleColor = {
                R = Arrow.TriangleColor.R,
                G = Arrow.TriangleColor.G,
                B = Arrow.TriangleColor.B,
                __type = "Color3"
            },
            AntiAliasing = Arrow.AntiAliasing
        }
        
        writefile("aui_config.json", game:GetService("HttpService"):JSONEncode(allConfigs))
        warn("Configuration saved!")
    else
        warn("Writefile not supported")
    end
end})

UI:CreateElement("button", section_save, {name = "load config", callback = function()
    if readfile and isfile and isfile("aui_config.json") then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("aui_config.json"))
        end)
        
        if success and data then
            for key, value in pairs(data) do
                if key == "Arrow" then
                    Arrow.Enabled = value.Enabled
                    Arrow.DistFromCenter = value.DistFromCenter
                    Arrow.TriangleHeight = value.TriangleHeight
                    Arrow.TriangleWidth = value.TriangleWidth
                    Arrow.TriangleTransparency = value.TriangleTransparency
                    Arrow.TriangleThickness = value.TriangleThickness
                    if value.TriangleColor and value.TriangleColor.__type == "Color3" then
                        Arrow.TriangleColor = Color3.fromRGB(value.TriangleColor.R, value.TriangleColor.G, value.TriangleColor.B)
                    end
                    Arrow.AntiAliasing = value.AntiAliasing
                else
                    if type(value) == "table" and value.__type == "Color3" then
                        getgenv()[key] = Color3.fromRGB(value.R, value.G, value.B)
                    else
                        getgenv()[key] = value
                    end
                end
            end
            
            warn("Configuration loaded!")
        else
            warn("Failed to load config")
        end
    else
        warn("Config file not found")
    end
end})

UI:CreateElement("button", section_save, {name = "reset to default", callback = function()
    getgenv().CONFIG = {
        Ragebot = {
            Enabled = false,
            RapidFire = false,
            FireRate = 30,
            Prediction = true,
            PredictionAmount = 0.12,
            TeamCheck = false,
            VisibilityCheck = true,
            FOV = 120,
            ShowFOV = true,
            Wallbang = true,
            Tracers = true,
            TracerColor = Color3.fromRGB(255, 0, 0),
            TracerWidth = 1,
            TracerLifetime = 3,
            ShootRange = 15,
            HitRange = 15,
            HitNotify = true,
            AutoReload = true,
            HitSound = true,
            HitColor = Color3.fromRGB(255, 182, 193),
            UseTargetList = false,
            UseWhitelist = false,
            HitNotifyDuration = 5,
            LowHealthCheck = false,
            SelectedHitSound = "skeet"
        },
        Misc = {
            SpeedEnabled = false,
            SpeedValue = 50,
            JumpPowerEnabled = false,
            JumpPowerValue = 100,
            LoopFOVEnabled = false,
            HideHeadEnabled = false,
            InfStaminaEnabled = false,
            NoFallDmgEnabled = false,
            SpeedConnection = nil,
            FOVConnection = nil,
            JumpPowerConnection = nil,
            NoFallHook = nil,
            InfStaminaHook = nil
        },
        Visualize = {
            ESP = {
                Enabled = false,
                BoxColor = Color3.fromRGB(78, 150, 50),
                OutlineColor = Color3.fromRGB(78, 150, 50),
                TextColor = Color3.fromRGB(255, 255, 255),
                MaxDistance = 1000
            },
            ForcefieldColor = Color3.fromRGB(255, 255, 255),
            ForcefieldTransparency = 0.5,
            LocalForcefieldEnabled = false,
            ArrowEnabled = false,
            ArrowColor = Color3.fromRGB(255, 255, 255),
            ArrowDistance = 80,
            ArrowSize = 16,
            ArrowThickness = 1,
            ArrowAA = false
        }
    }
    
    getgenv().Lists = {
        TargetList = {},
        Whitelist = {}
    }
    
    Arrow.Enabled = false
    Arrow.DistFromCenter = 80
    Arrow.TriangleHeight = 16
    Arrow.TriangleWidth = 16
    Arrow.TriangleTransparency = 0
    Arrow.TriangleThickness = 1
    Arrow.TriangleColor = Color3.fromRGB(255, 255, 255)
    Arrow.AntiAliasing = false
    
    warn("Configuration reset to default!")
end})

local section_manage = UI:CreateElement("section", column2_config, {name = "manage"})

UI:CreateElement("textbox", section_manage, {name = "config name", placeholder = "enter config name", callback = function(text)
    getgenv().currentConfigName = text
end})

UI:CreateElement("button", section_manage, {name = "save as preset", callback = function()
    if writefile and getgenv().currentConfigName then
        local name = getgenv().currentConfigName
        if name ~= "" then
            local allConfigs = {}
            
            local genv = getgenv()
            for key, value in pairs(genv) do
                if type(value) == "table" then
                    allConfigs[key] = value
                elseif type(value) == "Color3" then
                    allConfigs[key] = {R = value.R, G = value.G, B = value.B, __type = "Color3"}
                else
                    allConfigs[key] = value
                end
            end
            
            allConfigs["Arrow"] = {
                Enabled = Arrow.Enabled,
                DistFromCenter = Arrow.DistFromCenter,
                TriangleHeight = Arrow.TriangleHeight,
                TriangleWidth = Arrow.TriangleWidth,
                TriangleTransparency = Arrow.TriangleTransparency,
                TriangleThickness = Arrow.TriangleThickness,
                TriangleColor = {
                    R = Arrow.TriangleColor.R,
                    G = Arrow.TriangleColor.G,
                    B = Arrow.TriangleColor.B,
                    __type = "Color3"
                },
                AntiAliasing = Arrow.AntiAliasing
            }
            
            writefile("aui_preset_" .. name .. ".json", game:GetService("HttpService"):JSONEncode(allConfigs))
            warn("Preset saved as: " .. name)
        end
    end
end})

UI:CreateElement("button", section_manage, {name = "delete preset", callback = function()
    if delfile and getgenv().currentConfigName then
        local name = getgenv().currentConfigName
        if name ~= "" then
            local filename = "aui_preset_" .. name .. ".json"
            if isfile(filename) then
                delfile(filename)
                warn("Preset deleted: " .. name)
            end
        end
    end
end})

local section_list = UI:CreateElement("section", column2_config, {name = "presets list"})

UI:CreateElement("button", section_list, {name = "refresh presets", callback = function()
    local presetButtons = {}
    
    if isfile then
        for _, file in pairs(listfiles("")) do
            if file:find("aui_preset_") and file:find("%.json$") then
                local name = file:match("aui_preset_(.+)%.json")
                local btn = UI:CreateElement("button", section_list, {
                    name = name,
                    callback = function()
                        if readfile then
                            local success, data = pcall(function()
                                return game:GetService("HttpService"):JSONDecode(readfile(file))
                            end)
                            
                            if success and data then
                                for key, value in pairs(data) do
                                    if key == "Arrow" then
                                        Arrow.Enabled = value.Enabled
                                        Arrow.DistFromCenter = value.DistFromCenter
                                        Arrow.TriangleHeight = value.TriangleHeight
                                        Arrow.TriangleWidth = value.TriangleWidth
                                        Arrow.TriangleTransparency = value.TriangleTransparency
                                        Arrow.TriangleThickness = value.TriangleThickness
                                        if value.TriangleColor and value.TriangleColor.__type == "Color3" then
                                            Arrow.TriangleColor = Color3.fromRGB(value.TriangleColor.R, value.TriangleColor.G, value.TriangleColor.B)
                                        end
                                        Arrow.AntiAliasing = value.AntiAliasing
                                    else
                                        if type(value) == "table" and value.__type == "Color3" then
                                            getgenv()[key] = Color3.fromRGB(value.R, value.G, value.B)
                                        else
                                            getgenv()[key] = value
                                        end
                                    end
                                end
                                
                                warn("Preset loaded: " .. name)
                            end
                        end
                    end
                })
                table.insert(presetButtons, btn)
            end
        end
    end
    
    if #presetButtons == 0 then
        warn("No presets found")
    end
end})
local section_lockpick = UI:CreateElement("section", column2_misc, {name = "lockpick"})

local NoFailLockpick_Enabled = false
local lockpickAddedConnection = nil
local RunService = game:GetService("RunService")

UI:CreateElement("toggle", section_lockpick, {name = "no fail lockpick", default = false, callback = function(value)
    _G.LockpickEnabled = value
    NoFailLockpick_Enabled = value
    
    local Player = game:GetService("Players").LocalPlayer
    local PlayerGui = Player:FindFirstChild("PlayerGui")
    if not PlayerGui then return end
    
    if value then
        local function lockpick(gui)
            for _, a in pairs(gui:GetDescendants()) do
                if a:IsA("ImageLabel") and a.Name == "Bar" and a.Parent.Name ~= "Attempts" then
                    local oldsize = a.Size
                    RunService.RenderStepped:Connect(function()
                        if _G.LockpickEnabled then
                            a.Size = UDim2.new(0, 280, 0, 280)
                        else
                            a.Size = oldsize
                        end
                    end)
                end
            end
        end
        
        if lockpickAddedConnection then
            lockpickAddedConnection:Disconnect()
        end
        
        lockpickAddedConnection = PlayerGui.ChildAdded:Connect(function(child)
            if child:IsA("ScreenGui") and child.Name == "LockpickGUI" then
                lockpick(child)
            end
        end)
        
        for _, child in pairs(PlayerGui:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name == "LockpickGUI" then
                lockpick(child)
            end
        end
    else
        if lockpickAddedConnection then
            lockpickAddedConnection:Disconnect()
            lockpickAddedConnection = nil
        end
    end
end})

local SafeESP = {
    Enabled = false,
    Safes = {},
    Visuals = {}
}

function SafeESP:AddSafeESP(model)
    if not model or not model.Parent then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 215, 0)
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Color3.fromRGB(255, 140, 0)
    highlight.OutlineTransparency = 0
    highlight.Adornee = model
    highlight.Parent = model
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SafeESP"
    billboard.Adornee = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 100
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    textLabel.TextSize = 14
    textLabel.FontFace = Font.new("rbxassetid://12187371840")
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Text = model.Name
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0, 20)
    distanceLabel.Position = UDim2.new(0, 0, 0, 20)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distanceLabel.TextSize = 12
    distanceLabel.FontFace = Font.new("rbxassetid://12187371840")
    distanceLabel.TextStrokeTransparency = 0.5
    
    textLabel.Parent = billboard
    distanceLabel.Parent = billboard
    billboard.Parent = model
    
    SafeESP.Safes[model] = true
    SafeESP.Visuals[model] = {highlight = highlight, billboard = billboard, textLabel = textLabel, distanceLabel = distanceLabel}
    
    RunService.Heartbeat:Connect(function()
        if not SafeESP.Enabled or not model.Parent then
            highlight:Destroy()
            billboard:Destroy()
            SafeESP.Safes[model] = nil
            SafeESP.Visuals[model] = nil
            return
        end
        
        local localPlayer = game:GetService("Players").LocalPlayer
        if localPlayer and localPlayer.Character then
            local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and billboard.Adornee then
                local distance = (humanoidRootPart.Position - billboard.Adornee.Position).Magnitude
                distanceLabel.Text = string.format("%d studs", math.floor(distance))
                billboard.Enabled = distance <= 100
            end
        end
    end)
end

function SafeESP:ScanWorkspace()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            if itemName:find("mediumsafe") or itemName:find("smallsafe") then
                if not SafeESP.Safes[item] then
                    SafeESP:AddSafeESP(item)
                end
            end
        end
    end
end

function SafeESP:Enable(value)
    SafeESP.Enabled = value
    
    if value then
        SafeESP:ScanWorkspace()
        
        workspace.DescendantAdded:Connect(function(item)
            if item:IsA("Model") then
                local itemName = item.Name:lower()
                if itemName:find("mediumsafe") or itemName:find("smallsafe") then
                    task.wait(0.1)
                    SafeESP:AddSafeESP(item)
                end
            end
        end)
    else
        for model, visuals in pairs(SafeESP.Visuals) do
            if visuals.highlight then visuals.highlight:Destroy() end
            if visuals.billboard then visuals.billboard:Destroy() end
        end
        SafeESP.Safes = {}
        SafeESP.Visuals = {}
    end
end

local section_safe_esp = UI:CreateElement("section", column1_misc, {name = "safe esp"})

UI:CreateElement("toggle", section_safe_esp, {name = "enable safe esp", default = false, callback = function(value)
    SafeESP:Enable(value)
end})

UI:CreateElement("colorpicker", section_safe_esp, {name = "safe color", default = Color3.fromRGB(255, 215, 0), callback = function(value)
    for model, visuals in pairs(SafeESP.Visuals) do
        if visuals.highlight then
            visuals.highlight.FillColor = value
        end
        if visuals.textLabel then
            visuals.textLabel.TextColor3 = value
        end
    end
end})
local InstantPrompt_Enabled = false

UI:CreateElement("toggle", section_other, {name = "instant prompt", default = false, callback = function(value)
    InstantPrompt_Enabled = value
    
    if value then
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 0
            end
        end
        
        game.DescendantAdded:Connect(function(obj)
            if obj:IsA("ProximityPrompt") then
                task.wait()
                obj.HoldDuration = 0
            end
        end)
    else
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = 1
            end
        end
    end
end})
local AutoDoor_Enabled = false
local doorConnection = nil
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

UI:CreateElement("toggle", section_other, {name = "auto door", default = false, callback = function(value)
    AutoDoor_Enabled = value
    
    if value then
        if doorConnection then
            doorConnection:Disconnect()
        end
        
        doorConnection = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character then return end
            local charRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not charRoot then return end
            
            local Map = workspace:FindFirstChild("Map")
            if not Map then return end
            local Doors = Map:FindFirstChild("Doors")
            if not Doors then return end
            
            local closestDoor = nil
            local closestDistance = 15
            
            for _, door in pairs(Doors:GetChildren()) do
                local knob = door:FindFirstChild("Knob1") or door:FindFirstChild("Knob2")
                if knob then
                    local distance = (knob.Position - charRoot.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestDoor = door
                    end
                end
            end
            
            if closestDoor then
                local knob = closestDoor:FindFirstChild("Knob1") or closestDoor:FindFirstChild("Knob2")
                local events = closestDoor:FindFirstChild("Events")
                local toggleEvent = events and events:FindFirstChild("Toggle")
                
                if knob and toggleEvent then
                    local args = {"Open", knob}
                    toggleEvent:FireServer(unpack(args))
                end
            end
        end)
    else
        if doorConnection then
            doorConnection:Disconnect()
            doorConnection = nil
        end
    end
end})
local section_visuals = UI:CreateElement("section", column1_visualize, {name = "Rich World"})
local RichShaderSettings = {
    Enabled = false,
    Brightness = 0.2,
    Contrast = 0.5,
    Saturation = 1.5,
    TintColor = Color3.fromRGB(255, 200, 150)
}

local colorCorrection = nil

local brightnessSlider = UI:CreateElement("slider", section_visuals, {name = "brightness", min = -1, max = 1, default = 0.2, callback = function(value)
    RichShaderSettings.Brightness = value
    if colorCorrection then
        colorCorrection.Brightness = value
    end
end})

local contrastSlider = UI:CreateElement("slider", section_visuals, {name = "contrast", min = -1, max = 1, default = 0.5, callback = function(value)
    RichShaderSettings.Contrast = value
    if colorCorrection then
        colorCorrection.Contrast = value
    end
end})

local saturationSlider = UI:CreateElement("slider", section_visuals, {name = "saturation", min = 0, max = 2, default = 1.5, callback = function(value)
    RichShaderSettings.Saturation = value
    if colorCorrection then
        colorCorrection.Saturation = value
    end
end})

UI:CreateElement("colorpicker", section_visuals, {name = "tint color", default = Color3.fromRGB(255, 200, 150), callback = function(value)
    RichShaderSettings.TintColor = value
    if colorCorrection then
        colorCorrection.TintColor = value
    end
end})

UI:CreateElement("toggle", section_visuals, {name = "rich shader", default = false, callback = function(value)
    RichShaderSettings.Enabled = value
    
    if value then
        colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Parent = game:GetService("Lighting")
        colorCorrection.Brightness = RichShaderSettings.Brightness
        colorCorrection.Contrast = RichShaderSettings.Contrast
        colorCorrection.Saturation = RichShaderSettings.Saturation
        colorCorrection.TintColor = RichShaderSettings.TintColor
    else
        if colorCorrection then
            colorCorrection:Destroy()
            colorCorrection = nil
        end
    end
end})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local FlyConnection = nil
local FlyEnabled = false
local FlySpeed = 50

local QuickUIFrame = Instance.new("Frame")
QuickUIFrame.Name = "QuickUIFrame"
QuickUIFrame.Size = UDim2.new(0, 80, 0, 30)
QuickUIFrame.Position = UDim2.new(0, 10, 0, 50)
QuickUIFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
QuickUIFrame.BackgroundTransparency = 0.5
QuickUIFrame.BorderSizePixel = 0

local QuickUIText = Instance.new("TextButton")
QuickUIText.Name = "QuickUIText"
QuickUIText.Size = UDim2.new(1, 0, 1, 0)
QuickUIText.BackgroundTransparency = 1
QuickUIText.Text = "FLY OFF"
QuickUIText.TextColor3 = Color3.fromRGB(255, 50, 50)
QuickUIText.Font = Enum.Font.GothamBold
QuickUIText.TextSize = 12
QuickUIText.Parent = QuickUIFrame

local function StartFlying()
    local Char = Player.Character
    if not Char then return end
    
    local Hum = Char:FindFirstChildOfClass("Humanoid")
    local Root = Char:FindFirstChild("HumanoidRootPart")
    if not Hum or not Root then return end
    
    local RagdollEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("__RZDONL")
    RagdollEvent:FireServer("__---r", Vector3.zero, CFrame.new(-4574, 3, -443, 0, 0, 1, 0, 1, 0, -1, 0, 0), false)
    
    for _, child in ipairs(Char:GetDescendants()) do
        if child:IsA("Motor6D") then
            child.Enabled = false
        end
    end
    
    Hum.PlatformStand = true
    Hum:ChangeState(Enum.HumanoidStateType.Freefall)
    
    local Head = Char:FindFirstChild("Head")
    
    local flyMotors = {}
    for _, part in ipairs(Char:GetDescendants()) do
        if part:IsA("BasePart") and part ~= Root then
            local motor = Instance.new("Motor6D")
            motor.Name = "FlyMotor"
            motor.Part0 = Root
            motor.Part1 = part
            motor.C1 = CFrame.new()
            motor.C0 = Root.CFrame:ToObjectSpace(part.CFrame)
            motor.Parent = part
            table.insert(flyMotors, motor)
        end
    end
    
    FlyConnection = RunService.Heartbeat:Connect(function()
        if not FlyEnabled then
            if FlyConnection then
                FlyConnection:Disconnect()
                FlyConnection = nil
            end
            Hum.PlatformStand = false
            Root.Velocity = Vector3.new(0, 0, 0)
            Hum:ChangeState(Enum.HumanoidStateType.Running)
            RagdollEvent:FireServer("__---r", Vector3.zero, CFrame.new(-4574, 3, -443, 0, 0, 1, 0, 1, 0, -1, 0, 0), true)
            
            for _, motor in ipairs(flyMotors) do
                motor:Destroy()
            end
            
            for _, child in ipairs(Char:GetDescendants()) do
                if child:IsA("Motor6D") and child.Name ~= "FlyMotor" then
                    child.Enabled = true
                end
            end
            
            return
        end
        
        if Head then
            for _, sound in ipairs(Head:GetDescendants()) do
                if sound:IsA("Sound") then
                    sound:Destroy()
                end
            end
        end
        
        local Cam = workspace.CurrentCamera
        if not Cam then return end
        
        local cameraLook = Cam.CFrame.LookVector
        local IsMoving = Hum.MoveDirection.Magnitude > 0
        
        local targetLook = Vector3.new(cameraLook.X, cameraLook.Y, cameraLook.Z)
        if targetLook.Magnitude > 0 then
            targetLook = targetLook.Unit
            Root.CFrame = CFrame.new(Root.Position, Root.Position + targetLook)
        end
        
        
        
        if IsMoving then
            local moveVector = Vector3.new(cameraLook.X, cameraLook.Y, cameraLook.Z).Unit
            Root.Velocity = moveVector * FlySpeed
            RagdollEvent:FireServer("__---r", Vector3.zero, CFrame.new(-4574, 3, -443, 0, 0, 1, 0, 1, 0, -1, 0, 0), false)
        else
            Root.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

QuickUIText.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then
        QuickUIText.Text = "FLY ON"
        QuickUIText.TextColor3 = Color3.fromRGB(50, 255, 50)
        StartFlying()
    else
        QuickUIText.Text = "FLY OFF"
        QuickUIText.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

QuickUIFrame.Parent = game:GetService("CoreGui"):FindFirstChild("skeet") or game:GetService("CoreGui")

--local section_movement = UI:CreateElement("section", column1_misc, {name = "movement"})
UI:CreateElement("toggle", section_movement, {name = "fly", flag = "misc_fly", default = false, callback = function(value) 
    FlyEnabled = value 
    QuickUIText.Text = value and "FLY ON" or "FLY OFF"
    QuickUIText.TextColor3 = value and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    if value then 
        StartFlying()
    end
end})
UI:CreateElement("slider", section_movement, {name = "fly speed", flag = "misc_flyspeed", min = 10, max = 200, default = 50, suffix = "", callback = function(value) FlySpeed = value end})
