local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Gigachad Hub(Revamp)",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "loaded",
   LoadingSubtitle = "by Wesd",
   ShowText = "Chad", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "AmberGlow", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "P", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Tab = Window:CreateTab("R15(FE)", 4483362458) -- Title, Image
local Section = Tab:CreateSection("FE R15 Animations")

local Button = Tab:CreateButton({
   Name = "Tall Guy(Wesd)",
   Callback = function()
   -- tall guy screptttt
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")

local function toggleDefaultAnimate(enabled)
    local animate = character:FindFirstChild("Animate")
    if animate then
        animate.Disabled = not enabled
    end
    if not enabled then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0.2)
        end
    end
end

local function ensureAnimationId(id)
    local strId = tostring(id)
    if #strId >= 15 then return "rbxassetid://" .. strId end
    local success, assets = pcall(game.GetObjects, game, "rbxassetid://" .. strId)
    if success then
        for _, a in ipairs(assets) do
            if a:IsA("Animation") then return a.AnimationId
            elseif a:FindFirstChildWhichIsA("Animation", true) then
                return a:FindFirstChildWhichIsA("Animation", true).AnimationId
            end
        end
    end
    return "rbxassetid://" .. strId
end

local animations = {
    idle = 76622684003043,         
    walk = 71303649590318,         
    headless = 76746775961797,     
    lookAround = 79216795769647,
    chilling = 98248319097752,
    transform = 93875137466223
}

local keybinds = { 
    Headless = "q", 
    LookAround = "e",
    ReEnableDefault = "r", 
    MonsterMode = "f" 
}

local tracks = {}
for name, id in pairs(animations) do
    local animId = ensureAnimationId(id)
    if animId then
        local a = Instance.new("Animation")
        a.AnimationId = animId
        tracks[name] = animator:LoadAnimation(a)
        
        if name == "idle" or name == "walk" then
            tracks[name].Priority = Enum.AnimationPriority.Movement
        elseif name == "transform" then
            tracks[name].Priority = Enum.AnimationPriority.Action
        else
            tracks[name].Priority = Enum.AnimationPriority.Action
        end
    end
end

local isMonster = false          
local isEmoting = false
local currentActive = nil
local idleTime = 0
local defaultWalkSpeed = 16

RunService.RenderStepped:Connect(function(dt)
    if not isMonster or isEmoting then 
        idleTime = 0
        humanoid.WalkSpeed = defaultWalkSpeed
        return 
    end
    
    local speed = humanoid.MoveDirection.Magnitude
    local target = "idle"
    local isRunning = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)

    if speed > 0.1 then
        target = "walk"
        idleTime = 0 
    else
        idleTime = idleTime + dt
        if idleTime >= 5 then
            target = "chilling"
        else
            target = "idle"
        end
    end

    if currentActive ~= target then
        if currentActive and tracks[currentActive] then tracks[currentActive]:Stop(0.5) end
        if tracks[target] then
            tracks[target].Looped = true
            tracks[target]:Play(0.5)
            currentActive = target
        end
    end

    if currentActive == "walk" then
        if isRunning then
            tracks["walk"]:AdjustSpeed(1.5)
            humanoid.WalkSpeed = defaultWalkSpeed * 1.5
        else
            tracks["walk"]:AdjustSpeed(1)
            humanoid.WalkSpeed = defaultWalkSpeed
        end
    else
        humanoid.WalkSpeed = defaultWalkSpeed
    end
end)

local function playOneShot(name)
    if not tracks[name] or isEmoting or not isMonster then return end
    isEmoting = true
    idleTime = 0
    
    if currentActive and tracks[currentActive] then tracks[currentActive]:Stop(0.2) end
    
    local t = tracks[name]
    t.Looped = false 
    t:Play(0.2)
    t.Stopped:Wait()
    
    isEmoting = false
    currentActive = nil 
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local k = input.KeyCode.Name:lower()

    if k == keybinds.MonsterMode then
        if not isMonster then
            isEmoting = true
            toggleDefaultAnimate(false)
            
            local t = tracks["transform"]
            if t then
                t.Looped = false
                t:Play(0.2)
                
                local length = t.Length
                if length == 0 then task.wait() length = t.Length end
                
                task.wait(length / 2)
                
                isMonster = true
                isEmoting = false
                
                t:Stop(0.5)
            else
                isMonster = true
                isEmoting = false
            end
            currentActive = nil
        else
            isEmoting = true
            if currentActive and tracks[currentActive] then tracks[currentActive]:Stop(0.3) end
            
            local t = tracks["transform"]
            if t then
                t.Looped = false
                t:Play(0.1)
                
                local length = t.Length
                if length == 0 then task.wait() length = t.Length end
                
                t.TimePosition = length / 2
                task.wait(length / 2)
                
                t:Stop(0.5)
            end
            
            isMonster = false
            isEmoting = false
            currentActive = nil
            toggleDefaultAnimate(true)
        end
        
    elseif k == keybinds.ReEnableDefault then
        isMonster = false
        idleTime = 0
        if currentActive and tracks[currentActive] then tracks[currentActive]:Stop(0.3) end
        currentActive = nil
        toggleDefaultAnimate(true)

    elseif k == keybinds.Headless and isMonster then
        playOneShot("headless")
        
    elseif k == keybinds.LookAround and isMonster then
        playOneShot("lookAround")
    end
end)
   end,
})

local Button = Tab:CreateButton({
   Name = "Better Movement(Gazer-Ha)",
   Callback = function()
   --fe better movement finales cucked by gaze
--credir too (d.c.h.a.g.t.p) or (died.choked.and.glaze.the.pornstar)
--if you stole it akundisco will lick ur feet and sucks ur toes (i lied, he's not licking ur feet and sucks ur toes.)

--if you stole it i will bang you with big banhammer >;D

RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
Workspace = game:GetService("Workspace")
Coregui = game:GetService("CoreGui")
Players = game:GetService("Players")
Player = Players.LocalPlayer

M = math --if youre_geeked then meth = true end --// (we need to cook)
CF = CFrame
V3 = Vector3
V2 = Vector2
U2 = UDim2
C3 = Color3
ANG = CF.Angles
RAD = M.rad
if M == meth then return end

function load(id)
anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://" .. id
hum = Player.Character:FindFirstChild("Humanoid")
track = hum:LoadAnimation(anim)
track.Priority = Enum.AnimationPriority.Movement
return track end

lastPos, tiltX, tiltY, tiltZ, slopeTilt= V3.zero, 0, 0, 0, 0
currentYaw = 0
isShiftlock = false

char = nil
hum = nil
hrp = nil
tiltAttachment = nil
alignOrientation = nil
animLoop = nil 

screenGui = Instance.new("ScreenGui")
screenGui.Name = "RobloxGui" -- i saw someone did it dont blame me
screenGui.ResetOnSpawn = false
screenGui.Parent = Coregui
shiftLockButton = Instance.new("ImageButton")
shiftLockButton.Name = "buttin"
shiftLockButton.Size = U2.new(0, 60, 0, 60)
shiftLockButton.Position = U2.new(1, -70, 1, -70)
shiftLockButton.BackgroundTransparency = 1
shiftLockButton.Image = "rbxassetid://105987953182009"
shiftLockButton.Active = true
shiftLockButton.Parent = screenGui

function toggleShiftLock()
isShiftlock = not isShiftlock
shiftLockButton.ImageColor3 = isShiftlock and C3.fromRGB(0, 170, 255) or C3.fromRGB(255, 255, 255) 
end

shiftLockButton.MouseButton1Click:Connect(toggleShiftLock)
UserInputService.InputBegan:Connect(function(input, gp)
if gp then return end
if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
toggleShiftLock()
end end)

function lerpAngle(a, b, t)
return a + M.atan2(M.sin(b - a), M.cos(b - a)) * t 
end

function setup(character) 
char = character
hum = char:WaitForChild("Humanoid")
hum.WalkSpeed = 50
hrp = char:WaitForChild("HumanoidRootPart")
lastPos = hrp.Position
currentYaw = RAD(hrp.Orientation.Y)
tiltX, tiltY, tiltZ, slopeTilt = 0, 0, 0, 0
hum.PlatformStand = false
hum.AutoRotate = false

if tiltAttachment then tiltAttachment:Destroy() end
if alignOrientation then alignOrientation:Destroy() end

tiltAttachment = Instance.new("Attachment") --fe Bipassis new method 2016 no virus
tiltAttachment.Name = "TiltAttachment"
tiltAttachment.Parent = hrp

alignOrientation = Instance.new("AlignOrientation")
alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
alignOrientation.Attachment0 = tiltAttachment
alignOrientation.MaxTorque = M.huge
alignOrientation.Responsiveness = 50
alignOrientation.Parent = hrp

task.defer(function()
task.wait(0.05)
for _, part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
if part == hrp then
part.Massless = false
else
if not part.Anchored then part.Massless = true end end end end end)
--wake up its the first of the month
hum:ChangeState(Enum.HumanoidStateType.GettingUp)
end

function init(character)
if animLoop then animLoop:Disconnect() end
humLocal = character:WaitForChild("Humanoid")
if humLocal.RigType == Enum.HumanoidRigType.R6 then
task.spawn(function() 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/NOT-MINE/refs/heads/main/R6%20animation%20custe"))() 
    --credir to someone who made idk lol lemme see..
    --oh, credit to a.i for script and roblox for making the animmim
end) 
return end

--whole anim here
walkTrack= load("83842218823011")
runTrack = load("118320322718866")
sideTrack = load("132218385473651")
backTrack = load("16738337225")
jumpTrack = load("127915306032185")
--ts idle
t1 = load("138665010911335")
t2 = load("140131631438778")
t3 = load("82261197744576")
canJump = true -- false if you fat a lot

animLoop = RunService.Heartbeat:Connect(function()
humNow = character:FindFirstChild("Humanoid")
hrpNow = character:FindFirstChild("HumanoidRootPart")
if not humNow or not hrpNow then return end
moveDir = humNow.MoveDirection
speed = V3.new(hrpNow.AssemblyLinearVelocity.X, 0, hrpNow.AssemblyLinearVelocity.Z).Magnitude
state = humNow:GetState()
--ye
if moveDir.Magnitude == 0 then
    if runTrack then runTrack:Stop(0.2) end
    if walkTrack then walkTrack:Stop(0.2) end
    if sideTrack then sideTrack:Stop(0.2) end
    if backTrack then backTrack:Stop(0.2) end
end

for _, tr in pairs(humNow:GetPlayingAnimationTracks()) do
    if tr.Name == "WalkAnim" or tr.Name == "RunAnim" or tr.Name == "IdleAnim" then tr:Stop(0.1) end
end

if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
    if canJump then if jumpTrack then jumpTrack:Play(0.15) end canJump = false end
    if t1 then t1:Stop(0.1) end if t2 then t2:Stop(0.1) end if t3 then t3:AdjustWeight(0.03) end
    if walkTrack then walkTrack:Stop(0.1) end if runTrack then runTrack:Stop(0.1) end
    if sideTrack then sideTrack:Stop(0.1) end if backTrack then backTrack:Stop(0.1) end
    return
end

if state == Enum.HumanoidStateType.Landed then if jumpTrack then jumpTrack:Stop(0.1) end canJump = true end

if speed > 0.5 then
if t1 then t1:Stop(0.1) end if t2 then t2:Stop(0.1) end if t3 then t3:AdjustWeight(0.05) end
forwardDot = moveDir:Dot(hrpNow.CFrame.LookVector)
rightDot = moveDir:Dot(hrpNow.CFrame.RightVector)        
if M.abs(rightDot) > 0.6 then
if sideTrack and not sideTrack.IsPlaying then sideTrack:Play(0.1) end
if sideTrack then sideTrack:AdjustSpeed(1.5 * (speed/16) * (rightDot >= 0 and -1 or 1)) end
if walkTrack then walkTrack:Stop(0.1) end if runTrack then runTrack:Stop(0.1) end if backTrack then backTrack:Stop(0.1) end
elseif forwardDot <= -0.5 then
if backTrack and not backTrack.IsPlaying then backTrack:Play(0.1) end
if backTrack then backTrack:AdjustSpeed(-1.5 * (speed/16)) end
if walkTrack then walkTrack:Stop(0.1) end if runTrack then runTrack:Stop(0.1) end if sideTrack then sideTrack:Stop(0.1) end
elseif forwardDot >= 0.4 then
if sideTrack then sideTrack:Stop(0.1) end if backTrack then backTrack:Stop(0.1) end
if speed >= 15 then
if walkTrack then walkTrack:Stop(0.1) end
if runTrack and not runTrack.IsPlaying then runTrack:Play(0.1) end
if runTrack then runTrack:AdjustSpeed(0.3 * (speed/15)) end
elseif speed >= 1 then
if runTrack then runTrack:Stop(0.1) end
if walkTrack and not walkTrack.IsPlaying then walkTrack:Play(0.1) end
if walkTrack then walkTrack:AdjustSpeed(1.8 * speed/15) end
end end
            
           else
           
if walkTrack then walkTrack:Stop(0.1) end if runTrack then runTrack:Stop(0.1) end
if sideTrack then sideTrack:Stop(0.1) end if backTrack then backTrack:Stop(0.1) end
if t1 and not t1.IsPlaying then t1:Play(0.1, 0.9, 1) end
if t2 and not t2.IsPlaying then t2:Play(0.1, 0.5, 1) end
if t3 and not t3.IsPlaying then t3:Play(0.08) t3:AdjustWeight(0.06) t3:AdjustSpeed(0) t3.TimePosition = t3.Length * 0.98 end
end end) end

rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
--idiot was hir

 function onHeartbeat(dt)
if not hrp or not hum or not alignOrientation or hum.Health <= 0 then return end
rayParams.FilterDescendantsInstances = {char}
velocity = (hrp.Position - lastPos) / M.max(dt, 1/60)
lastPos = hrp.Position
isSitting = hum.Sit
targetSlope = 0
ray = Workspace:Raycast(hrp.Position, V3.new(0, -10, 0), rayParams)

if ray and ray.Instance and ray.Instance.CanCollide then
    targetSlope = -hrp.CFrame.LookVector:Dot(ray.Normal) * RAD(45) * 1.5
    if isSitting then targetSlope = targetSlope * 2.0 end
end

slopeTilt = slopeTilt + (targetSlope - slopeTilt) * dt * 10
targetX, targetZ = 0, 0
currentMaxTilt = isSitting and RAD(5) or RAD(55)

if V2.new(velocity.X, velocity.Z).Magnitude > 0.1 then
    targetX = -hum.MoveDirection:Dot(hrp.CFrame.LookVector) * currentMaxTilt
    targetZ = -hum.MoveDirection:Dot(hrp.CFrame.RightVector) * currentMaxTilt
end

intensity = M.clamp(velocity.Y / 50, -1, 1)
targetY_Goal = (velocity.Y > 0 and intensity * RAD(35)) or (intensity * RAD(10))
if isSitting then targetY_Goal = targetY_Goal * 2.0 end

tiltX = tiltX + (targetX - tiltX) * dt * 10
tiltY = tiltY + (targetY_Goal - tiltY) * dt * 10
tiltZ = tiltZ + (targetZ - tiltZ) * dt * 10

targetYaw = currentYaw
if isShiftlock then
cam = Workspace.CurrentCamera
if cam then targetYaw = M.atan2(-cam.CFrame.LookVector.X, -cam.CFrame.LookVector.Z) end
elseif hum.MoveDirection.Magnitude > 0.1 then
targetYaw = M.atan2(-hum.MoveDirection.X, -hum.MoveDirection.Z) end
currentYaw = lerpAngle(currentYaw, targetYaw, dt * (isShiftlock and 40 or 10))
alignOrientation.CFrame = ANG(0, currentYaw, 0) * ANG(tiltY + slopeTilt, 0, 0) * ANG(tiltX, 0, tiltZ)
end

Player.CharacterAdded:Connect(function(newChar) setup(newChar) init(newChar) end)
if Player.Character then setup(Player.Character) init(Player.Character) end
RunService.Heartbeat:Connect(onHeartbeat)
   end,
})

local Paragraph = Tab:CreateParagraph({Title = "Changelogs", Content = "Tall Guy, Better Movement, More soon"})

local Tab = Window:CreateTab("Models", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Models to Load in your game")

local Button = Tab:CreateButton({
   Name = "Penis(Requires you to download files in the discord)",
   Callback = function()
   -- penis

























local folderName = "meshes"
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local function getAsset(id)
    if id:find("rbxassetid://") or id:find("http") then return id end
    local cleanId = id:match("([^/]+)$") or id
    local path = folderName .. "/" .. cleanId
    if isfile and isfile(path) then
        return getcustomasset(path)
    end
    return id:find("rbxasset://") and id or "rbxassetid://" .. cleanId
end

local Cock = Instance.new("Model")
Cock.Name = "Cock"
Cock.Parent = char

-- Base bone (anchored to body)
local BaseBone = Instance.new("Bone")
BaseBone.Name = "BaseBone"

-- Middle bone for physics
local MidBone = Instance.new("Bone")
MidBone.Name = "MidBone"
MidBone.Position = Vector3.new(0, -0.4, 0)

-- Tip bone
local TipBone = Instance.new("Bone")
TipBone.Name = "TipBone"
TipBone.Position = Vector3.new(0, -0.4, 0)

local P_C = Instance.new("Part")
P_C.Name = "P_C"
P_C.Size = Vector3.new(1.484, 0.526, 0.539)
P_C.Color = Color3.fromRGB(163, 162, 165)
P_C.Material = Enum.Material.SmoothPlastic
P_C.CanCollide = false
P_C.Massless = false
P_C.CustomPhysicalProperties = PhysicalProperties.new(0.5, 0.3, 0.5, 1, 1)
P_C.Parent = Cock

-- Setup bone hierarchy
BaseBone.Parent = P_C
MidBone.Parent = BaseBone
TipBone.Parent = MidBone

-- Attachments for constraints
local baseAttachment = Instance.new("Attachment")
baseAttachment.Name = "BaseAttachment"
baseAttachment.Position = Vector3.new(0, 0.26, 0)
baseAttachment.Parent = P_C

local midAttachment = Instance.new("Attachment")
midAttachment.Name = "MidAttachment"
midAttachment.Position = Vector3.new(0, -0.14, 0)
midAttachment.Parent = P_C

local tipAttachment = Instance.new("Attachment")
tipAttachment.Name = "TipAttachment"
tipAttachment.Position = Vector3.new(0, -0.54, 0)
tipAttachment.Parent = P_C

local P_C_Mesh = Instance.new("SpecialMesh")
P_C_Mesh.MeshId = getAsset("7093427066")
P_C_Mesh.MeshType = Enum.MeshType.FileMesh
P_C_Mesh.Parent = P_C

-- Bones will control the mesh deformation through constraints

local X_B = Instance.new("Part")
X_B.Name = "X_B"
X_B.Size = Vector3.new(0.447, 0.852, 0.723)
X_B.Color = Color3.fromRGB(234, 184, 146)
X_B.CanCollide = false
X_B.Massless = true
X_B.Parent = P_C

local X_B_Mesh = Instance.new("SpecialMesh")
X_B_Mesh.MeshId = getAsset("afdbbb7cf29f0798d6fa6ff07e08553e")
X_B_Mesh.MeshType = Enum.MeshType.FileMesh
X_B_Mesh.Parent = X_B

local XB_Weld = Instance.new("Weld")
XB_Weld.Part0 = P_C
XB_Weld.Part1 = X_B
XB_Weld.C0 = CFrame.new(0.27, -0.31, 0.12) * CFrame.Angles(math.rad(-20.7), math.rad(-180), math.rad(8.76))
XB_Weld.Parent = X_B

local NewPC = Instance.new("Part")
NewPC.Name = "NewPC"
NewPC.Size = Vector3.new(1.484, 0.526, 0.539)
NewPC.Color = Color3.fromRGB(234, 184, 146)
NewPC.CanCollide = false
NewPC.Massless = true
NewPC.Parent = P_C

local NewPC_Mesh = Instance.new("SpecialMesh")
NewPC_Mesh.MeshId = getAsset("767088ba9f373e77b2f56a757248670f")
NewPC_Mesh.MeshType = Enum.MeshType.FileMesh
NewPC_Mesh.Parent = NewPC

local NewPC_Weld = Instance.new("Weld")
NewPC_Weld.Part0 = P_C
NewPC_Weld.Part1 = NewPC
NewPC_Weld.C0 = CFrame.new(-0.0023, 0, -0.004)
NewPC_Weld.Parent = NewPC

local T = Instance.new("Part")
T.Name = "T"
T.Size = Vector3.new(0.431, 0.383, 0.428)
T.Color = Color3.fromRGB(218, 134, 122)
T.Material = Enum.Material.Glass
T.CanCollide = false
T.Massless = true
T.Parent = P_C

local T_Mesh = Instance.new("SpecialMesh")
T_Mesh.MeshId = getAsset("564d1bf18317a0a46b5a2b0077733b4f")
T_Mesh.MeshType = Enum.MeshType.FileMesh
T_Mesh.Parent = T

local T_Joint = Instance.new("Motor6D")
T_Joint.Name = "NewPC"
T_Joint.Part0 = P_C
T_Joint.Part1 = T
T_Joint.C0 = CFrame.new(-0.711918, 0.040504, 0.005760, -0.994518, 0, -0.104565, 0, 1, 0, 0.104565, 0, -0.994518)
T_Joint.Parent = P_C

local Cum = Instance.new("ParticleEmitter")
Cum.Name = "Cum"
Cum.Texture = "http://www.roblox.com/asset/?id=141285996"
Cum.Rate = 0
Cum.Lifetime = NumberRange.new(3.25)
Cum.Speed = NumberRange.new(1)
Cum.Acceleration = Vector3.new(0, -1, 0)
Cum.Size = NumberSequence.new(0.3)
Cum.EmissionDirection = Enum.NormalId.Bottom
Cum.Parent = T

local root = char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso") or char.HumanoidRootPart
local isR15 = char:FindFirstChild("LowerTorso") ~= nil

-- Different positioning for R6 vs R15
local weldOffset, weldRotation
if isR15 then
    -- R15 positioning (adjust as needed)
    weldOffset = CFrame.new(0, -0.1, -0.8)
    weldRotation = CFrame.Angles(math.rad(20), math.rad(-90), math.rad(0))
else
    -- R6 positioning
    weldOffset = CFrame.new(0.02, -0.97, -0.91)
    weldRotation = CFrame.Angles(math.rad(3.43), math.rad(-90.86), math.rad(10.29))
end

-- Weld base to body
local BodyWeld = Instance.new("Weld")
BodyWeld.Name = "BodyWeld"
BodyWeld.Part0 = root
BodyWeld.Part1 = P_C
BodyWeld.C0 = weldOffset * weldRotation
BodyWeld.Parent = P_C

-- Physics constraints for wobble (more intense)
local ballSocket = Instance.new("BallSocketConstraint")
ballSocket.Name = "MidSocket"
ballSocket.Attachment0 = baseAttachment
ballSocket.Attachment1 = midAttachment
ballSocket.LimitsEnabled = true
ballSocket.UpperAngle = 45  -- Increased from 25
ballSocket.TwistLimitsEnabled = true
ballSocket.TwistUpperAngle = 30  -- Increased from 15
ballSocket.TwistLowerAngle = -30
ballSocket.Parent = P_C

local spring = Instance.new("SpringConstraint")
spring.Name = "MidSpring"
spring.Attachment0 = baseAttachment
spring.Attachment1 = midAttachment
spring.FreeLength = 0.4
spring.Stiffness = 150  -- Reduced from 300 for more wobble
spring.Damping = 15  -- Reduced from 30 for longer wobble
spring.Parent = P_C

local tipSocket = Instance.new("BallSocketConstraint")
tipSocket.Name = "TipSocket"
tipSocket.Attachment0 = midAttachment
tipSocket.Attachment1 = tipAttachment
tipSocket.LimitsEnabled = true
tipSocket.UpperAngle = 35  -- Increased from 20
tipSocket.TwistLimitsEnabled = true
tipSocket.TwistUpperAngle = 25  -- Increased from 10
tipSocket.TwistLowerAngle = -25
tipSocket.Parent = P_C

local tipSpring = Instance.new("SpringConstraint")
tipSpring.Name = "TipSpring"
tipSpring.Attachment0 = midAttachment
tipSpring.Attachment1 = tipAttachment
tipSpring.FreeLength = 0.4
tipSpring.Stiffness = 100  -- Reduced from 200 for more wobble
tipSpring.Damping = 12  -- Reduced from 25 for longer wobble
tipSpring.Parent = P_C

-- Simulate bone influence on mesh deformation
local RunService = game:GetService("RunService")
local originalCFrame = P_C.CFrame

RunService.Heartbeat:Connect(function()
    local velocity = P_C.AssemblyLinearVelocity
    local speed = velocity.Magnitude
    
    -- Apply wobble based on movement
    if speed > 2 then
        local wobbleForce = speed * 0.5
        midAttachment.WorldPosition = midAttachment.WorldPosition + Vector3.new(
            math.sin(tick() * 8) * wobbleForce * 0.01,
            0,
            math.cos(tick() * 8) * wobbleForce * 0.01
        )
    end
end)

local toggle = false
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggle = not toggle
        Cum.Rate = toggle and 58 or 0
    end
end)
   end,
})

local Tab = Window:CreateTab("Scripts", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Scripts")


local Button = Tab:CreateButton({
   Name = "Network Ownership Abuser(@im_partrick)",
   Callback = function()
   --1. rules: it is forbidden to change the credit name, this script was created by @im_patrick you will be charged dcma for changing the credit
--2. rules: changing the code using AI and claiming it as your own is not allowed

if patricknpcpanel then return end; patricknpcpanel = true

local github = "https://raw.githubusercontent.com/randomstring0/fe-source/refs/heads/main/NPC"
local load = loadstring(game:HttpGet(github .. "/module.Luau"))()

saved = loadstring(game:HttpGet(github .. "/table.luau"))()



local save = saved or {}

local g2l = load.G2L
local new = load.create()

local lighting = game:GetService("Lighting")
local tweenservice = game:GetService("TweenService")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local mouse = lp:GetMouse()

local fast = TweenInfo.new(.5, Enum.EasingStyle.Exponential)
local medium = TweenInfo.new(.67)
local slow = TweenInfo.new(.8)

local rad = 150
local currentnpc

local highlight = Instance.new("Highlight")
highlight.Parent = lp
highlight.FillTransparency = 1
highlight.OutlineTransparency = 1

local light = function(adornee, color)
	task.spawn(function()
		highlight.Adornee = adornee
		highlight.OutlineColor = color
		tweenservice:Create(highlight, medium, {OutlineTransparency  = 0}):Play()
		task.wait(.5)
		tweenservice:Create(highlight, medium, {OutlineTransparency  = 1}):Play()
	end)	
end

local isnpc = function(ins)
	local humanoid = ins:FindFirstChildOfClass("Humanoid")
	local player = plrs:GetPlayerFromCharacter(ins)

	if humanoid and not player then
		return ins 
	end

	return nil
end


new:mainbutton(save["1"].title, save["1"].des, function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and partowner(part) then
			local hum = currentnpc:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(save["1"].val)
			end
		else
			light(currentnpc, Color3.fromRGB(255, 0, 0))
		end
	end
end)

new:mainbutton(save["2"].title, save["2"].des, function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and partowner(part) then
			if lp and lp.Character then
				local char = lp.Character
				currentnpc:PivotTo(char:GetPivot())
			end
		else
			light(currentnpc, Color3.fromRGB(255, 0, 0))
		end
	end
end)

new:mainbutton(save["3"].title, save["3"].des, function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part then
			if lp and lp.Character then
				local char = lp.Character
				char:PivotTo(currentnpc:GetPivot())
			end
		else
			light(currentnpc, Color3.fromRGB(255, 0, 0))
		end
	end
end)


local chr, cons
new:maintoggle(save["4"].title, save["4"].des, function(a)
	if a then
		if currentnpc then
			local part = currentnpc:FindFirstChild("HumanoidRootPart")
			if part and partowner(part) then
				if lp and lp.Character then
					chr = lp.Character
					lp.Character = currentnpc
					ws.CurrentCamera.CameraSubject = currentnpc:FindFirstChild("HumanoidRootPart")
					-- idea from sonle
					local move = 0.01
					cons = rs.PreSimulation:Connect(function()
						local hum = lp.Character:FindFirstChildOfClass("Humanoid")
						if lp.Character and hum then
							hum.RootPart.CFrame += vector.create(0,move,0)
							move = -move
						else
							if cons then
								cons:Disconnect()
								cons = nil
							end
						end
					end)
				end
			else
				light(currentnpc, Color3.fromRGB(255, 0, 0))
			end
		end
	else
		if chr then
			lp.Character = chr
			ws.CurrentCamera.CameraSubject = chr.Humanoid
			chr = nil
			if cons then
				cons:Disconnect()
				cons = nil
			end
		end
	end
end)

new:mainbutton(save["5"].title, save["5"].des, function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and partowner(part) then
			if lp and lp.Character then
				local char = lp.Character
				currentnpc:PivotTo(CFrame.new(0, 1000, 0))
			end
		else
			light(currentnpc, Color3.fromRGB(255, 0, 0))
		end
	end
end)

new:mainbutton(save["6"].title, save["6"].des, function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and partowner(part) then
			local hum = currentnpc:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.Sit = not hum.Sit
			end
		else
			light(currentnpc, Color3.fromRGB(255, 0, 0))
		end
	end
end)

new:mainbutton(save["7"].title, save["7"].des, function()
	if currentnpc then
		local part = currentnpc:FindFirstChild("HumanoidRootPart")
		if part and partowner(part) then
			local hum = currentnpc:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(save["7"].val)
			end
		else
			light(currentnpc, Color3.fromRGB(255, 0, 0))
		end
	end
end)

local con, follownpc
follownpc = new:maintoggle(save["8"].title, save["8"].des, function(a)
	if a then
		con = rs.RenderStepped:Connect(function()
			if currentnpc then
				local part = currentnpc:FindFirstChild("HumanoidRootPart")
				if part and partowner(part) then
					local hum = currentnpc:FindFirstChildOfClass("Humanoid")
					if hum then
						local hrp=lp.Character:FindFirstChild("HumanoidRootPart")
						if hrp then
							hum:MoveTo(hrp.Position + Vector3.new(-4,0,0))
						end
					end
				else
					light(currentnpc, Color3.fromRGB(255, 0, 0))
					if con then
						follownpc:swich(false)
						con:Disconnect()
						con = nil
					end
				end
			else
				if con then
					follownpc:swich(false)
					con:Disconnect()
					con = nil
				end
			end
		end)
	else
		if con then
			con:Disconnect()
			con = nil
		end
	end
end)


local con1
new:extratoggle(save["9"].title, function(a)
	if a then
		con1 = rs.Stepped:Connect(function()
			local hrp1 = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if not hrp1 then return end

			local nbp = ws:GetPartBoundsInRadius(hrp1.Position, 13)
			for _, part in pairs(nbp) do
				local model = part:FindFirstAncestorOfClass("Model")
				if model and isnpc(model) then
					local npc = model
					local hrp = npc:FindFirstChild("HumanoidRootPart")
					if hrp and partowner(hrp) and not hrp.Anchored and npc ~= lp.Character then
						local hum = npc:FindFirstChildOfClass("Humanoid")
						if hum then
							hum:ChangeState(save["9"].val)
						end
					end
				end
			end
		end)
	else
		if con1 then
			con1:Disconnect()
			con1 = nil
		end
	end
end)


local con2
new:extratoggle(save["10"].title, function(a)
	if a then
		con2 = rs.Stepped:Connect(function()
			local hrp1 = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if not hrp1 then return end

			local nbp = ws:GetPartBoundsInRadius(hrp1.Position, 13)
			for _, part in pairs(nbp) do
				local model = part:FindFirstAncestorOfClass("Model")
				if model and isnpc(model) then
					local npc = model
					local hrp = npc:FindFirstChild("HumanoidRootPart")
					if hrp and partowner(hrp) and not hrp.Anchored and npc ~= lp.Character then
						local hum = npc:FindFirstChildOfClass("Humanoid")
						if hum then
							hum:ChangeState(save["10"].val)
						end
					end
				end
			end
		end)
	else
		if con2 then
			con2:Disconnect()
			con2 = nil
		end
	end
end)




mouse.Button1Down:Connect(function()
	if clicknpc and mouse.Target and mouse.Target.Parent:FindFirstChild("HumanoidRootPart") then
		if mouse.Target.Parent:FindFirstChild("HumanoidRootPart").Anchored == false then
			if not plrs:GetPlayerFromCharacter(mouse.Target.Parent) then
				if partowner(mouse.Target.Parent:FindFirstChild("HumanoidRootPart")) then
					currentnpc = mouse.Target.Parent
					light(currentnpc, Color3.fromRGB(0, 255, 0))
				else
					light(mouse.Target.Parent, Color3.fromRGB(255, 0, 0))
				end
			end
		else
			light(mouse.Target.Parent, Color3.fromRGB(255, 0, 0))
		end
	end
end)

rs.RenderStepped:Connect(function()
	if sethiddenproperty then
		sethiddenproperty(lp,"SimulationRadius",rad)
	else
		lp.SimulationRadius=rad
	end
end)


return g2l, require;
   end,
})

local Button = Tab:CreateButton({
   Name = "Morph Gui(Client Sided)",
   Callback = function()
   -- Theme Colors
local BLACK = Color3.fromRGB(15, 15, 15)
local DARK_GRAY = Color3.fromRGB(35, 35, 35)
local LIST_BG = Color3.fromRGB(25, 25, 25)
local WHITE = Color3.fromRGB(255, 255, 255)
local RED = Color3.fromRGB(200, 50, 50)
local LIGHT_GREEN = Color3.fromRGB(50, 180, 50)
local BLUE = Color3.fromRGB(50, 100, 200)
local MENU_ALPHA = 0.95

-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService") -- Required for saving
local player = Players.LocalPlayer

-- Variables
local creatorUserId = nil
local creatorThumbnail = ""
local minimized = false
local draggingTitleBar = false
local dragStart, startPos = nil, nil
local savedAvatars = {} -- Storage for saved avatars
local FILE_NAME = "KuramaMorph_Saved.json" -- File name in your Workspace folder

-- Creator Info
local success, result = pcall(function()
    return Players:GetUserIdFromNameAsync("akuramaa_xd")
end)
if success then
    creatorUserId = result
    success, result = pcall(function()
        return Players:GetUserThumbnailAsync(creatorUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if success then
        creatorThumbnail = result
    end
end

-- Cleanup Existing GUI
if CoreGui:FindFirstChild("MorphAvatarByKuramaMod") then 
    CoreGui["MorphAvatarByKuramaMod"]:Destroy() 
end

-- Main GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MorphAvatarByKuramaMod"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.Parent = CoreGui
screenGui.Enabled = true

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(0.5, -100, 0.5, -65)
frame.BackgroundColor3 = BLACK
frame.BackgroundTransparency = 1 - MENU_ALPHA
frame.BorderSizePixel = 0
frame.Active = false
frame.Parent = screenGui
frame.Visible = true
frame.ClipsDescendants = false 

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = frame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundTransparency = 1
titleBar.Parent = frame
titleBar.Active = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Morph Avatar"
title.TextColor3 = WHITE
title.BackgroundTransparency = 1
title.BorderSizePixel = 0
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Username Input
local usernameInput = Instance.new("TextBox")
usernameInput.Size = UDim2.new(1, -20, 0, 30)
usernameInput.Position = UDim2.new(0, 10, 0, 40)
usernameInput.PlaceholderText = "Enter Username"
usernameInput.Font = Enum.Font.Gotham
usernameInput.TextSize = 14
usernameInput.Text = ""
usernameInput.TextColor3 = WHITE
usernameInput.BackgroundColor3 = DARK_GRAY
usernameInput.ClearTextOnFocus = false
usernameInput.TextWrapped = true
usernameInput.Parent = frame
usernameInput.Visible = true

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = usernameInput

-- Buttons Container
local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(1, -20, 0, 35)
btnContainer.Position = UDim2.new(0, 10, 0, 80)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = frame

-- Save Button
local saveBtn = Instance.new("TextButton")
saveBtn.Name = "SaveBtn"
saveBtn.Size = UDim2.new(0.48, 0, 1, 0)
saveBtn.Position = UDim2.new(0, 0, 0, 0)
saveBtn.BackgroundColor3 = BLUE
saveBtn.Text = "Save"
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 14
saveBtn.TextColor3 = WHITE
saveBtn.Parent = btnContainer

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 4)
saveCorner.Parent = saveBtn

-- Saved List Toggle Button
local savedListBtn = Instance.new("TextButton")
savedListBtn.Name = "SavedListBtn"
savedListBtn.Size = UDim2.new(0.48, 0, 1, 0)
savedListBtn.Position = UDim2.new(0.52, 0, 0, 0)
savedListBtn.BackgroundColor3 = DARK_GRAY
savedListBtn.Text = "Saved"
savedListBtn.Font = Enum.Font.GothamBold
savedListBtn.TextSize = 14
savedListBtn.TextColor3 = WHITE
savedListBtn.Parent = btnContainer

local savedListCorner = Instance.new("UICorner")
savedListCorner.CornerRadius = UDim.new(0, 4)
savedListCorner.Parent = savedListBtn

-- Saved List Dropdown
local savedFrame = Instance.new("ScrollingFrame")
savedFrame.Name = "SavedAvatarsFrame"
savedFrame.Size = UDim2.new(1, 0, 0, 150)
savedFrame.Position = UDim2.new(0, 0, 1, 5) 
savedFrame.BackgroundColor3 = BLACK
savedFrame.BackgroundTransparency = 0.1
savedFrame.BorderSizePixel = 0
savedFrame.ScrollBarThickness = 4
savedFrame.Visible = false 
savedFrame.Parent = frame
savedFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
savedFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local savedFrameCorner = Instance.new("UICorner")
savedFrameCorner.CornerRadius = UDim.new(0, 8)
savedFrameCorner.Parent = savedFrame

local savedListLayout = Instance.new("UIListLayout")
savedListLayout.Parent = savedFrame
savedListLayout.SortOrder = Enum.SortOrder.LayoutOrder
savedListLayout.Padding = UDim.new(0, 5)
savedListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local savedPadding = Instance.new("UIPadding")
savedPadding.PaddingTop = UDim.new(0, 10)
savedPadding.PaddingBottom = UDim.new(0, 10)
savedPadding.Parent = savedFrame

-- Window Controls
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "MinimizeButton"
miniBtn.Size = UDim2.new(0, 30, 0, 30)
miniBtn.Position = UDim2.new(1, -60, 0, 0)
miniBtn.Text = "-"
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 16
miniBtn.TextColor3 = WHITE
miniBtn.BackgroundTransparency = 1
miniBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = RED
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = titleBar
closeBtn.ZIndex = 2

-- === FUNCTIONS ===

local function sendNotif(titleT, textT, image)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = titleT,
            Text = textT,
            Duration = 3,
            Icon = image or ""
        })
    end)
end

-- FILE SAVING SYSTEM
local function saveToFile()
    if not writefile then return end -- Check for executor support
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(savedAvatars)
    end)
    if success then
        writefile(FILE_NAME, encoded)
        print("Saved avatars to file.")
    end
end

local function loadFromFile()
    if not isfile or not readfile then return end -- Check for executor support
    if isfile(FILE_NAME) then
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(readfile(FILE_NAME))
        end)
        if success and type(decoded) == "table" then
            savedAvatars = decoded
            print("Loaded avatars from file.")
        end
    end
end

local function applyMorphEffect(character)
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local particleEmitter = Instance.new("ParticleEmitter")
    particleEmitter.Texture = "rbxassetid://243098098"
    particleEmitter.Rate = 50
    particleEmitter.Speed = NumberRange.new(5, 10)
    particleEmitter.Lifetime = NumberRange.new(0.5, 1)
    particleEmitter.SpreadAngle = Vector2.new(360, 360)
    particleEmitter.Color = ColorSequence.new(RED)
    particleEmitter.Parent = rootPart

    local explosion = Instance.new("Explosion")
    explosion.BlastRadius = 5
    explosion.BlastPressure = 0
    explosion.Position = rootPart.Position
    explosion.Visible = true
    explosion.Parent = workspace
    explosion.ExplosionType = Enum.ExplosionType.NoCraters

    task.spawn(function()
        task.wait(2)
        particleEmitter.Enabled = false
        task.wait(1)
        particleEmitter:Destroy()
        explosion:Destroy()
    end)
end

local function findPlayerByName(partialName)
    if not partialName or partialName == "" then return nil end
    local searchName = partialName:lower()
    
    local localPlayer = nil
    for _, v in ipairs(Players:GetPlayers()) do
        local nameLower = v.Name:lower()
        local dNameLower = v.DisplayName:lower()
        
        if nameLower == searchName or dNameLower == searchName then
            return v
        end
        
        if nameLower:sub(1, #searchName) == searchName or dNameLower:sub(1, #searchName) == searchName then
            localPlayer = v
        end
    end
    
    if not localPlayer then
        local success, userId = pcall(function()
            return Players:GetUserIdFromNameAsync(searchName)
        end)
        if success and userId then
            return {UserId = userId, Name = searchName}
        end
    end
    
    return localPlayer
end

local function morphToPlayer(target)
    if not target then 
        sendNotif("Morph Avatar", "No target found!", "")
        return 
    end
    
    local userId = target.UserId or (type(target) == "number" and target or target.UserId)
    local targetName = target.Name or "Unknown"
    
    if userId == player.UserId then
        sendNotif("Morph Avatar", "Cannot morph to yourself!", "")
        return
    end
    
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then return end

    local success, desc = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(userId)
    end)
    
    if success and desc then
        local targetThumbnail = ""
        pcall(function()
            targetThumbnail = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)

        for _, obj in ipairs(character:GetChildren()) do
            if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or
               obj:IsA("Accessory") or obj:IsA("BodyColors") then
                obj:Destroy()
            end
        end
        local head = character:FindFirstChild("Head")
        if head then
            for _, decal in ipairs(head:GetChildren()) do
                if decal:IsA("Decal") then decal:Destroy() end
            end
        end

        pcall(function()
            humanoid:ApplyDescriptionClientServer(desc)
        end)

        applyMorphEffect(character)
        sendNotif("Morph Avatar", "Morphed to " .. targetName, targetThumbnail)
    else
        sendNotif("Morph Avatar", "Failed to load data.", "")
    end
end

local function refreshSavedList()
    for _, child in ipairs(savedFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    for i, data in ipairs(savedAvatars) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, -10, 0, 40)
        itemFrame.BackgroundColor3 = LIST_BG
        itemFrame.Parent = savedFrame

        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 6)
        itemCorner.Parent = itemFrame

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 30, 0, 30)
        icon.Position = UDim2.new(0, 5, 0, 5)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
        icon.Parent = itemFrame
        local iconCorner = Instance.new("UICorner")
        iconCorner.CornerRadius = UDim.new(1, 0)
        iconCorner.Parent = icon

        task.spawn(function()
            local t = Players:GetUserThumbnailAsync(data.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            icon.Image = t
        end)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -100, 1, 0)
        nameLbl.Position = UDim2.new(0, 40, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = data.Name
        nameLbl.TextColor3 = WHITE
        nameLbl.Font = Enum.Font.GothamSemibold
        nameLbl.TextSize = 12
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.Parent = itemFrame

        -- Equip Button
        local equipBtn = Instance.new("TextButton")
        equipBtn.Size = UDim2.new(0, 25, 0, 25)
        equipBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
        equipBtn.BackgroundColor3 = LIGHT_GREEN
        equipBtn.Text = "✔"
        equipBtn.TextColor3 = WHITE
        equipBtn.Font = Enum.Font.GothamBold
        equipBtn.Parent = itemFrame
        
        local equipCorner = Instance.new("UICorner")
        equipCorner.CornerRadius = UDim.new(0, 4)
        equipCorner.Parent = equipBtn

        equipBtn.MouseButton1Click:Connect(function()
            morphToPlayer({UserId = data.UserId, Name = data.Name})
        end)

        -- Delete Button
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 25, 0, 25)
        delBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
        delBtn.BackgroundColor3 = RED
        delBtn.Text = "🗑"
        delBtn.TextColor3 = WHITE
        delBtn.Font = Enum.Font.GothamBold
        delBtn.Parent = itemFrame

        local delCorner = Instance.new("UICorner")
        delCorner.CornerRadius = UDim.new(0, 4)
        delCorner.Parent = delBtn

        delBtn.MouseButton1Click:Connect(function()
            table.remove(savedAvatars, i)
            saveToFile() -- Update file on delete
            refreshSavedList()
        end)
    end
end

local function saveCurrentInput()
    local text = usernameInput.Text
    if text == "" then 
        sendNotif("Save", "Enter a username first!", "")
        return 
    end

    local target = findPlayerByName(text)
    if target then
        for _, v in ipairs(savedAvatars) do
            if v.UserId == target.UserId then
                sendNotif("Save", "User already saved!", "")
                return
            end
        end

        table.insert(savedAvatars, {Name = target.Name, UserId = target.UserId})
        saveToFile() -- Update file on save
        sendNotif("Save", "Saved " .. target.Name, "")
        if savedFrame.Visible then
            refreshSavedList()
        end
    else
        sendNotif("Save", "Player not found!", "")
    end
end

-- === EVENTS ===

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingTitleBar = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingTitleBar = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingTitleBar and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

miniBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame.Size = UDim2.new(0, 200, 0, 30)
        miniBtn.Text = "+"
        usernameInput.Visible = false
        btnContainer.Visible = false
        savedFrame.Visible = false 
    else
        frame.Size = UDim2.new(0, 200, 0, 130)
        miniBtn.Text = "-"
        usernameInput.Visible = true
        btnContainer.Visible = true
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

usernameInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local inputText = usernameInput.Text
        if inputText == "" then return end
        local target = findPlayerByName(inputText)
        if target then
            usernameInput.Text = target.Name or inputText
            morphToPlayer(target)
        else
            sendNotif("Morph Avatar", "Player not found!", "")
        end
    end
end)

saveBtn.MouseButton1Click:Connect(saveCurrentInput)

savedListBtn.MouseButton1Click:Connect(function()
    savedFrame.Visible = not savedFrame.Visible
    if savedFrame.Visible then
        refreshSavedList()
        savedListBtn.BackgroundColor3 = LIGHT_GREEN
    else
        savedListBtn.BackgroundColor3 = DARK_GRAY
    end
end)

-- Initialize
loadFromFile() -- Load Saved Avatars on Startup
sendNotif("Morph Avatar", "Permanent Save Enabled", creatorThumbnail)
   end,
})

local Button = Tab:CreateButton({
   Name = "FE Sound Spammer(Scripty)",
   Callback = function()
   --sound thingy

--[[
Made By Scripty#2063
If You Gonna showcase this , make sure to Credit me , do not take that you are owner of the script
This Gui is Undetectable
RespectFilteringEnabled must be false to use it
--]]

local ScreenGui = Instance.new("ScreenGui")
local Draggable = Instance.new("Frame")
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local Time = Instance.new("TextLabel")
local _1E = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local _3E = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local SE = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local Path = Instance.new("TextLabel")
local Top = Instance.new("Frame")
local Top_2 = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local TextLabel = Instance.new("TextLabel")
local Exit = Instance.new("TextButton")
local Minizum = Instance.new("TextButton")
local Stop = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local IY = Instance.new("TextButton")
local UICorner_5 = Instance.new("UICorner")
local TextLabel_2 = Instance.new("TextLabel")
local Wait = Instance.new("TextBox")

--Properties:

ScreenGui.Name = ". Ǥ҉̷҉̵҉̸҉̷҉̵҉̸҉̡҉̡҉̼҉̱҉͎҉͎҉̞҉̼҉̱҉͎҉͎҉̞҉ͤ҉ͬ҉̅҉ͤ҉ͬ"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

Draggable.Name = "Ǥ҉̷҉̵҉̸҉̷҉̵҉̸҉̡҉̡҉̼҉̱҉͎҉͎҉̞҉̼҉̱҉͎҉͎҉̞҉ͤ҉ͬ҉̅҉ͤ҉ͬ."
Draggable.Parent = ScreenGui
Draggable.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Draggable.BackgroundTransparency = 1.000
Draggable.BorderSizePixel = 0
Draggable.Position = UDim2.new(0.35026139, 0, 0.296158612, 0)
Draggable.Size = UDim2.new(0, 438, 0, 277)

Frame.Name = ". . Ǥ҉̷҉̵҉̸҉̷҉̵҉̸҉̡҉̡҉̼҉̱҉͎҉͎҉̞҉̼҉̱҉͎҉͎҉̞҉ͤ҉ͬ҉̅҉ͤ҉ͬ. "
Frame.Parent = Draggable
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 1.000
Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(-0.00133678317, 0, -0.00348037481, 0)
Frame.Size = UDim2.new(0, 438, 0, 277)

Frame_2.Name = " . Ǥ҉̷҉̵҉̸҉̷҉̵҉̸҉̡҉̡҉̼҉̱҉͎҉͎҉̞҉̼҉̱҉͎҉͎҉̞҉ͤ҉ͬ҉̅҉ͤ҉ͬ. "
Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(-0.00133678142, 0, -0.0179207586, 0)
Frame_2.Size = UDim2.new(0, 438, 0, 238)
Frame_2.Active = true
Frame_2.Draggable = true

Time.Name = "Time"
Time.Parent = Frame_2
Time.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Time.BackgroundTransparency = 1.000
Time.Position = UDim2.new(0, 0, 0.0126050422, 0)
Time.Size = UDim2.new(0, 437, 0, 31)
Time.Font = Enum.Font.GothamSemibold
Time.Text = "RespectFilteringEnabled(RFE) : nil"
Time.TextColor3 = Color3.fromRGB(255, 255, 255)
Time.TextScaled = true
Time.TextSize = 14.000
Time.TextWrapped = true

_1E.Name = "1E"
_1E.Parent = Frame_2
_1E.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
_1E.BorderSizePixel = 0
_1E.Position = UDim2.new(0.0182648394, 0, 0.676470578, 0)
_1E.Size = UDim2.new(0, 208, 0, 33)
_1E.Font = Enum.Font.SourceSans
_1E.Text = "Mute Game"
_1E.TextColor3 = Color3.fromRGB(255, 255, 255)
_1E.TextScaled = true
_1E.TextSize = 30.000
_1E.TextWrapped = true

UICorner.Parent = _1E

_3E.Name = "3E"
_3E.Parent = Frame_2
_3E.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
_3E.BorderSizePixel = 0
_3E.Position = UDim2.new(0.0159817357, 0, 0.142857149, 0)
_3E.Size = UDim2.new(0, 209, 0, 33)
_3E.Font = Enum.Font.SourceSans
_3E.Text = "Annoying  Sound"
_3E.TextColor3 = Color3.fromRGB(255, 255, 255)
_3E.TextSize = 30.000
_3E.TextWrapped = true

UICorner_2.Parent = _3E

SE.Name = "SE"
SE.Parent = Frame_2
SE.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SE.BorderSizePixel = 0
SE.Position = UDim2.new(0.509132445, 0, 0.142857149, 0)
SE.Size = UDim2.new(0, 209, 0, 33)
SE.Font = Enum.Font.SourceSans
SE.Text = "Kill Sound Service"
SE.TextColor3 = Color3.fromRGB(255, 255, 255)
SE.TextSize = 30.000
SE.TextWrapped = true

UICorner_3.Parent = SE

Path.Name = "Path"
Path.Parent = Frame_2
Path.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Path.BackgroundTransparency = 1.000
Path.Position = UDim2.new(0.00684931502, 0, 0.815126061, 0)
Path.Size = UDim2.new(0, 435, 0, 44)
Path.Font = Enum.Font.GothamSemibold
Path.Text = "Dev Note : This Script is FE and it only FE when RespectFilteringEnabled(RFE) is disabled , elseif RespectFilteringEnabled(RFE) is true then it only be client , mostly RespectFilteringEnabled(RFE) disabled game are classic game"
Path.TextColor3 = Color3.fromRGB(255, 0, 0)
Path.TextScaled = true
Path.TextSize = 14.000
Path.TextWrapped = true

Top.Name = "Top"
Top.Parent = Frame_2
Top.BackgroundColor3 = Color3.fromRGB(41, 60, 157)
Top.BorderColor3 = Color3.fromRGB(27, 42, 53)
Top.BorderSizePixel = 0
Top.Position = UDim2.new(-0.00133678142, 0, -0.128059402, 0)
Top.Size = UDim2.new(0, 438, 0, 30)
Top_2.Name = "Top"
Top_2.Parent = Top
Top_2.BackgroundColor3 = Color3.fromRGB(30, 45, 118)
Top_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
Top_2.BorderSizePixel = 0
Top_2.Position = UDim2.new(0, 0, 0.967638671, 0)
Top_2.Size = UDim2.new(0, 438, 0, 5)

ImageLabel.Parent = Top
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.Position = UDim2.new(0, 0, 0.0666666701, 0)
ImageLabel.Size = UDim2.new(0, 29, 0, 27)
ImageLabel.Image = "http://www.roblox.com/asset/?id=8798286232"

TextLabel.Parent = ImageLabel
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.Position = UDim2.new(0.997245014, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 397, 0, 30)
TextLabel.Font = Enum.Font.GothamSemibold
TextLabel.Text = "FEAG"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextWrapped = true

Exit.Name = "Exit"
Exit.Parent = Top
Exit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Exit.BackgroundTransparency = 1.000
Exit.Position = UDim2.new(0.924657524, 0, 0, 0)
Exit.Size = UDim2.new(0, 32, 0, 25)
Exit.Font = Enum.Font.GothamSemibold
Exit.Text = "x"
Exit.TextColor3 = Color3.fromRGB(255, 255, 255)
Exit.TextScaled = true
Exit.TextSize = 14.000
Exit.TextWrapped = true

Minizum.Name = "Minizum"
Minizum.Parent = Top
Minizum.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Minizum.BackgroundTransparency = 1.000
Minizum.Position = UDim2.new(0.851598203, 0, 0, 0)
Minizum.Size = UDim2.new(0, 32, 0, 23)
Minizum.Font = Enum.Font.GothamSemibold
Minizum.Text = "_"
Minizum.TextColor3 = Color3.fromRGB(255, 255, 255)
Minizum.TextScaled = true
Minizum.TextSize = 14.000
Minizum.TextWrapped = true

Stop.Name = "Stop"
Stop.Parent = Frame_2
Stop.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Stop.BorderSizePixel = 0
Stop.Position = UDim2.new(0.0182648394, 0, 0.310924381, 0)
Stop.Size = UDim2.new(0, 424, 0, 33)
Stop.Font = Enum.Font.SourceSans
Stop.Text = "Stop"
Stop.TextColor3 = Color3.fromRGB(255, 255, 255)
Stop.TextSize = 30.000
Stop.TextWrapped = true

UICorner_4.Parent = Stop

IY.Name = "IY"
IY.Parent = Frame_2
IY.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
IY.BorderSizePixel = 0
IY.Position = UDim2.new(0.509132445, 0, 0.676470578, 0)
IY.Size = UDim2.new(0, 209, 0, 33)
IY.Font = Enum.Font.SourceSans
IY.Text = "Unmute Game"
IY.TextColor3 = Color3.fromRGB(255, 255, 255)
IY.TextScaled = true
IY.TextSize = 30.000
IY.TextWrapped = true

UICorner_5.Parent = IY

TextLabel_2.Parent = Frame_2
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.Position = UDim2.new(0.0182648394, 0, 0.466386557, 0)
TextLabel_2.Size = UDim2.new(0, 426, 0, 50)
TextLabel_2.Font = Enum.Font.GothamSemibold
TextLabel_2.Text = "Wait Speed       :"
TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.TextSize = 30.000
TextLabel_2.TextWrapped = true
TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left

Wait.Name = "Wait()"
Wait.Parent = Frame_2
Wait.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Wait.BackgroundTransparency = 1.000
Wait.Position = UDim2.new(0.531963468, 0, 0.466386557, 0)
Wait.Size = UDim2.new(0, 199, 0, 50)
Wait.ZIndex = 99999
Wait.ClearTextOnFocus = false
Wait.Font = Enum.Font.GothamSemibold
Wait.Text = "0.5"
Wait.TextColor3 = Color3.fromRGB(255, 255, 255)
Wait.TextSize = 30.000
Wait.TextWrapped = true

--Sound Service:
local notification = Instance.new("Sound")
notification.Parent = game:GetService("SoundService")
notification.SoundId = "rbxassetid://9086208751"
notification.Volume = 5
notification.Name = ". Ǥ҉̷҉̵҉̸҉̷҉̵҉̸҉̡҉̡҉̼҉̱҉͎҉͎҉̞҉̼҉̱҉͎҉͎҉̞҉ͤ҉ͬ҉̅҉ͤ҉ͬ"

--funuction:
Exit.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)
local Mute = false
IY.MouseButton1Click:Connect(function()
	Mute = false
end)

_1E.MouseButton1Click:Connect(function()
	Mute = true
	while Mute == true do 
		wait()
		for _, sound in next, workspace:GetDescendants() do
			if sound:IsA("Sound") then
				sound:Stop()
			end
		end
	end
end)

_3E.MouseButton1Click:Connect(function()
	for _, sound in next, workspace:GetDescendants() do
		if sound:IsA("Sound") then
			sound:Play()
		end
	end
end)

local Active = true
SE.MouseButton1Click:Connect(function()
	Active = true
	while Active == true do
		local StringValue = Wait.Text
		wait(StringValue)
		for _, sound in next, workspace:GetDescendants() do
			if sound:IsA("Sound") then
				sound:Play()
			end
		end
	end
end)

Stop.MouseButton1Click:Connect(function()
	Active = false
end)
--Credit:
notification:Play()
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "FEAG";
	Text = "FEAG Has Been Loaded , Made By Scripty#2063 (gamer14_123)";
	Icon = "";
	Duration = 10; 
	Button1 = "Yes Sir";
})
--Check:
while true do
	wait(0.5)
	local setting = game:GetService("SoundService").RespectFilteringEnabled
	if setting == true then
		Time.TextColor = BrickColor.new(255,0,0)
		Time.Text ="RespectFilteringEnabled(RFE) : true"
	elseif setting == false then
		Time.Text ="RespectFilteringEnabled(RFE) : false"
		Time.TextColor = BrickColor.new(0,255,0)
	end
end
   end,
})


local Button = Tab:CreateButton({
   Name = "Purgatory(Wesd)",
   Callback = function()
   -- // Purgatory Script | Velocity v5 // --
-- // Library: Kavo UI // --
-- // Open Source Version // --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Purgatory | Velocity v5", "Midnight")

-- // Services // --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- // Variables // --
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("OnServerEvents")

local CombatRemote = Remotes:WaitForChild("CombatServer", 5)
local DodgeRemote = Remotes:WaitForChild("DodgeServer", 5)
local VisualRemote = Remotes:WaitForChild("PlrFxRelay", 5) 
local UpgradeRemote = Remotes:WaitForChild("UpgradeSelected", 5)

-- // Settings // --
local Settings = {
    AutoAttack = false,
    AttackDist = 15,
    
    AutoDodge = false,
    DodgeSpeed = 0.1, 
    DodgeID = 5,
    RandomizeDodge = false,
    
    SpeedEnabled = false, 
    WalkSpeed = 50,       
    
    SelectedUpgrade = "Power" -- Default
}

-- // Upgrade List // --
-- Sourced from Game Wiki & Data
local UpgradeList = {
    -- Basic / Common
    "Power",
    "Agility",
    "Vitality",
    "Force",
    "Regeneration",
    
    -- Advanced / Rare
    "Fleetfoot",
    "Perfect Dodge",
    "Shatter",
    "Brute Force",
    "Maestro",
    "Health Pack",
    "Survivor",
    
    -- Legendary
    "Giantslayer",
    "Blackhole",
    "Cataclysm",
    "Reaper",
    "Juggernaut",
    "Second Wind",
    "Assassin",
    
    -- Divine / Special
    "Cleave",
    "Glass Cannon",
    "Turtle",
    "The Force in Reverse"
}

-- // Tabs // --
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Offense")
local DodgeSection = CombatTab:NewSection("Auto Dodge")

local MoveTab = Window:NewTab("Movement")
local MoveSection = MoveTab:NewSection("Speed Logic")

local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Bypass Upgrades")

-- // Functions // --

local function GetClosestEnemy()
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    if not Root then return nil end

    local ClosestDist = Settings.AttackDist
    local ClosestEnemy = nil
    
    local EnemiesFolder = Workspace:FindFirstChild("Enemies")
    if EnemiesFolder then
        for _, Enemy in pairs(EnemiesFolder:GetChildren()) do
            if Enemy:FindFirstChild("HumanoidRootPart") and Enemy:FindFirstChild("Humanoid") then
                if Enemy.Humanoid.Health > 0 then
                    local Dist = (Root.Position - Enemy.HumanoidRootPart.Position).Magnitude
                    if Dist < ClosestDist then
                        ClosestDist = Dist
                        ClosestEnemy = Enemy
                    end
                end
            end
        end
    end
    return ClosestEnemy
end

local function Attack(Target)
    if not CombatRemote then return end
    
    local args = {
        Target.HumanoidRootPart,
        "Melee",
        {
            ["dismantle"] = true, 
            ["riposte"] = false,
            ["backstab"] = true 
        }
    }
    
    pcall(function()
        CombatRemote:FireServer(unpack(args))
    end)
end

-- // Combat UI // --

CombatSection:NewToggle("Kill Aura (OP)", "Instantly kills enemies in range.", function(state)
    Settings.AutoAttack = state
end)

CombatSection:NewSlider("Attack Range", "Range to start killing.", 50, 5, function(value)
    Settings.AttackDist = value
end)

-- // Dodge UI // --

DodgeSection:NewToggle("Auto Dodge", "Enable the dodge loop.", function(state)
    Settings.AutoDodge = state
end)

DodgeSection:NewToggle("Randomize ID", "Cycles random IDs (1-6) automatically.", function(state)
    Settings.RandomizeDodge = state
end)

DodgeSection:NewSlider("Dodge Speed", "How fast to spam (Lower = Faster)", 20, 1, function(value)
    Settings.DodgeSpeed = value / 20 
end)

DodgeSection:NewSlider("Manual ID", "Only used if Randomize is OFF.", 10, 1, function(value)
    Settings.DodgeID = value
end)

-- // Movement UI // --

MoveSection:NewToggle("Enable Speed Loop", "Forces your WalkSpeed constantly.", function(state)
    Settings.SpeedEnabled = state
end)

MoveSection:NewSlider("WalkSpeed Amount", "Set your speed.", 100, 16, function(value)
    Settings.WalkSpeed = value
end)

-- // Misc UI // --

MiscSection:NewDropdown("Select Upgrade", "Choose from the Full Wiki List", UpgradeList, function(currentOption)
    Settings.SelectedUpgrade = currentOption
end)

MiscSection:NewTextBox("Custom Name", "Type a name here to override (e.g. Vampirism)", function(txt)
    if txt and txt ~= "" then
        Settings.SelectedUpgrade = txt
    end
end)

MiscSection:NewButton("Apply Upgrade", "Spam this to force the upgrade.", function()
    if UpgradeRemote then
        -- This fires whatever is currently set in Settings.SelectedUpgrade
        local args = {
            Settings.SelectedUpgrade,
            {},
            1
        }
        UpgradeRemote:FireServer(unpack(args))
    end
end)

MiscSection:NewLabel("Current Selection: Check Console (F9) if unsure")

-- // Loops // --

-- Attack Loop
task.spawn(function()
    while true do
        task.wait() 
        if Settings.AutoAttack then
            local Target = GetClosestEnemy()
            if Target then
                Attack(Target)
            end
        end
    end
end)

-- Dodge Loop
task.spawn(function()
    while true do
        if Settings.AutoDodge then
            pcall(function()
                local currentID = Settings.DodgeID
                if Settings.RandomizeDodge then
                    currentID = math.random(1, 6)
                end

                DodgeRemote:FireServer(currentID)
                
                if VisualRemote then
                    VisualRemote:FireServer("Dash")
                end
            end)
        end
        task.wait(Settings.DodgeSpeed)
    end
end)

-- Speed Loop
RunService.RenderStepped:Connect(function()
    if Settings.SpeedEnabled then
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = Settings.WalkSpeed
            end
        end)
    end
end)
   end,
})

local Button = Tab:CreateButton({
   Name = "Da Strike",
   Callback = function()
   --// Dahood games
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Dahood Games",
    Icon = 0,
    LoadingTitle = "Open source, Safe, Free, Undetected",
    LoadingSubtitle = "by Wesd",
    ShowText = "Capybara hub",
    Theme = "Default",
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "CapybaraHub_DahoodGames"
    }
})

local Tab = Window:CreateTab("Main", 4483362458)
local PriorityTab = Window:CreateTab("Target Priority", 4483362458)

-- Silent Aim Settings
local SilentAimEnabled = false
local PredictionEnabled = false
local PredictionAmount = 0.15
local FOVRadius = 100
local FOVCircleVisible = true
local FOVCircleColor = Color3.fromRGB(255, 255, 255)
local FOVCircleThickness = 1.5

-- Priority Settings
local IgnoreDead = true
local DeadHPThreshold = 0
local IgnoreTeam = false
local WallPriority = false
local PriorityMode = "Closest to Crosshair"

-- Target Bind
local TargetBindKey = Enum.KeyCode.T
local LockedTarget = nil
local TargetBindActive = false

-- Mouse, Camera
local mouse = game.Players.LocalPlayer:GetMouse()
local camera = workspace.CurrentCamera

-- Create FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Radius = FOVRadius
fovCircle.Color = FOVCircleColor
fovCircle.Thickness = FOVCircleThickness
fovCircle.Transparency = 1
fovCircle.Filled = false

-- Highlight Instance
local currentHighlight = nil

-- Update FOV Circle
task.spawn(function()
    while task.wait() do
        fovCircle.Visible = FOVCircleVisible
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y + game:GetService("GuiService"):GetGuiInset().Y)
        fovCircle.Radius = FOVRadius
        fovCircle.Color = FOVCircleColor
        fovCircle.Thickness = FOVCircleThickness
    end
end)

-- Check if Player is Behind Wall
local function IsBehindWall(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    local ray = Ray.new(camera.CFrame.Position, (hrp.Position - camera.CFrame.Position).Unit * (hrp.Position - camera.CFrame.Position).Magnitude)
    local hitPart = workspace:FindPartOnRayWithIgnoreList(ray, {game.Players.LocalPlayer.Character})
    return hitPart and hitPart:IsDescendantOf(char) == false
end

-- Apply Highlight
local function HighlightTarget(player)
    if currentHighlight then
        currentHighlight:Destroy()
        currentHighlight = nil
    end
    if player and player.Character then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = player.Character
        currentHighlight = highlight
    end
end

-- Get Target
local function GetTarget()
    if TargetBindActive and LockedTarget and LockedTarget.Character then
        return LockedTarget
    end

    local candidates = {}
    local visibleCandidates = {}

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                if IgnoreDead and humanoid.Health <= DeadHPThreshold then
                    continue
                end
                if IgnoreTeam and player.Team == game.Players.LocalPlayer.Team then
                    continue
                end
                local pos, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mag = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if mag <= FOVRadius then
                        local behindWall = IsBehindWall(player.Character)
                        table.insert(candidates, {Player = player, Mag = mag, HP = humanoid.Health, Wall = behindWall})
                        if not behindWall then
                            table.insert(visibleCandidates, {Player = player, Mag = mag, HP = humanoid.Health, Wall = behindWall})
                        end
                    end
                end
            end
        end
    end

    local listToUse = (WallPriority and #visibleCandidates > 0) and visibleCandidates or candidates
    if #listToUse == 0 then return nil end

    if PriorityMode == "Closest to Crosshair" then
        table.sort(listToUse, function(a, b) return a.Mag < b.Mag end)
    elseif PriorityMode == "Lowest HP" then
        table.sort(listToUse, function(a, b) return a.HP < b.HP end)
    elseif PriorityMode == "Highest HP" then
        table.sort(listToUse, function(a, b) return a.HP > b.HP end)
    end

    return listToUse[1].Player
end

-- Keybind Handling
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == TargetBindKey then
        if not TargetBindActive then
            local potentialTarget = GetTarget()
            if potentialTarget then
                LockedTarget = potentialTarget
                TargetBindActive = true
            end
        else
            LockedTarget = nil
            TargetBindActive = false
        end
    end
end)

-- Silent Aim Loop
task.spawn(function()
    while task.wait() do
        if SilentAimEnabled then
            local target = GetTarget()
            HighlightTarget(target)
            if target then
                local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local coords = hrp.Position
                    if PredictionEnabled then
                        coords = coords + (hrp.Velocity * PredictionAmount)
                    end
                    game:GetService("ReplicatedStorage"):WaitForChild("MAINEVENT"):FireServer("MOUSE", coords)
                end
            end
        else
            HighlightTarget(nil)
        end
    end
end)

-- UI Controls
Tab:CreateToggle({
    Name = "Enable Silent Aim",
    CurrentValue = false,
    Callback = function(val) SilentAimEnabled = val end
})

Tab:CreateToggle({
    Name = "Enable Prediction",
    CurrentValue = false,
    Callback = function(val) PredictionEnabled = val end
})

Tab:CreateSlider({
    Name = "Prediction Amount",
    Range = {0, 1},
    Increment = 0.01,
    Suffix = "s",
    CurrentValue = PredictionAmount,
    Callback = function(val) PredictionAmount = val end
})

Tab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = true,
    Callback = function(val) FOVCircleVisible = val end
})

Tab:CreateSlider({
    Name = "FOV Radius",
    Range = {50, 500},
    Increment = 1,
    Suffix = "px",
    CurrentValue = FOVRadius,
    Callback = function(val) FOVRadius = val end
})

PriorityTab:CreateToggle({
    Name = "Ignore Dead Players",
    CurrentValue = true,
    Callback = function(val) IgnoreDead = val end
})

PriorityTab:CreateSlider({
    Name = "Dead HP Threshold",
    Range = {0, 100},
    Increment = 1,
    Suffix = "hp",
    CurrentValue = DeadHPThreshold,
    Callback = function(val) DeadHPThreshold = val end
})

PriorityTab:CreateToggle({
    Name = "Ignore Teammates",
    CurrentValue = false,
    Callback = function(val) IgnoreTeam = val end
})

PriorityTab:CreateToggle({
    Name = "Wall Priority",
    CurrentValue = false,
    Callback = function(val) WallPriority = val end
})

PriorityTab:CreateDropdown({
    Name = "Priority Mode",
    Options = {"Closest to Crosshair", "Lowest HP", "Highest HP"},
    CurrentOption = {PriorityMode},
    Callback = function(opt) PriorityMode = opt[1] end
})

PriorityTab:CreateLabel("Target Bind Key: T (toggle lock on current target)")

Tab:CreateButton({
    Name = "Unload Script",
    Callback = function()
        if currentHighlight then currentHighlight:Destroy() end
        fovCircle:Remove()
        Rayfield:Destroy()
        script:Destroy()
    end
})

   end,
})

local Button = Tab:CreateButton({
   Name = "Inventory Viewer",
   Callback = function()
   
--// services
local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local players = game:GetService("Players")

--// config
local lp = players.LocalPlayer
if not lp then return end

local CONFIG = {
	distance = 16,
	scrollSpeed = 20,
	animTime = 0.3,
	platforms = {
		PC = {"rbxassetid://10688463768", Color3.fromRGB(80, 140, 220)},
		Mobile = {"rbxassetid://10688464303", Color3.fromRGB(80, 220, 120)},
		Console = {"rbxassetid://10688463319", Color3.fromRGB(220, 80, 80)},
		Unknown = {"", Color3.fromRGB(150, 150, 150)}
	}
}

--// 'secret' state management
_G.BillboardState = {
	enabled = true,
	uis = {}, -- { [Player]: { gui, root, main, currentState, tweens } }
	activeScroller = nil
}

--// functions
local function getPlayerPlatform(player)
	local platform = "Unknown"
	if player.GameplayPaused then platform = "Mobile" end
	if uis:GetPlatform() == Enum.Platform.Windows and player == lp then platform = "PC" end
	return platform
end

local function animate(state, direction)
	if state.tweens then
		for _, t in ipairs(state.tweens) do t:Cancel() end
	end
	state.tweens = {}

	local transparencyGoal, sizeGoal
	if direction == "in" then
		transparencyGoal, sizeGoal = 0.2, UDim2.fromScale(1, 1)
	else
		transparencyGoal, sizeGoal = 1, UDim2.fromScale(0.8, 0.8)
	end
	
	local transparencyTween = ts:Create(state.main, TweenInfo.new(CONFIG.animTime, Enum.EasingStyle.Quint), {BackgroundTransparency = transparencyGoal})
	local sizeTween = ts:Create(state.root, TweenInfo.new(CONFIG.animTime, Enum.EasingStyle.Quint), {Size = sizeGoal})

	table.insert(state.tweens, transparencyTween)
	table.insert(state.tweens, sizeTween)
	
	transparencyTween:Play()
	sizeTween:Play()
	
	return sizeTween
end

local function createElements(player)
	local state = { currentState = "hidden", tweens = {} }
	
	state.gui = Instance.new("BillboardGui")
	state.gui.Name, state.gui.AlwaysOnTop = "PlayerInfo", true
	state.gui.Size, state.gui.StudsOffset = UDim2.fromOffset(200, 80), Vector3.new(0, 2.2, 0)

	state.root = Instance.new("Frame", state.gui)
	state.root.Name, state.root.BackgroundTransparency = "Root", 1
	state.root.ClipsDescendants, state.root.AnchorPoint = true, Vector2.new(0.5, 0.5)
	state.root.Position, state.root.Size = UDim2.fromScale(0.5, 0.5), UDim2.fromScale(0.8, 0.8)

	state.main = Instance.new("Frame", state.root)
	state.main.Name, state.main.Size = "Main", UDim2.fromScale(1, 1)
	state.main.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
	state.main.Active, state.main.BackgroundTransparency = true, 1
	Instance.new("UICorner", state.main).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", state.main).Color = Color3.fromRGB(10, 11, 13)

	local platformIcon = Instance.new("ImageLabel", state.main)
	platformIcon.Name, platformIcon.Size = "PlatformIcon", UDim2.fromOffset(14, 14)
	platformIcon.Position, platformIcon.BackgroundTransparency = UDim2.new(0, 4, 0, 4), 1

	local healthBar = Instance.new("Frame", state.main)
	healthBar.Name = "HealthBar"
	-- FIX: Positioned at the top center
	healthBar.Size = UDim2.new(0.8, 0, 0, 8)
	healthBar.Position = UDim2.new(0.5, 0, 0, 4)
	healthBar.AnchorPoint = Vector2.new(0.5, 0)
	healthBar.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
	Instance.new("UICorner", healthBar).CornerRadius = UDim.new(1, 0)
	
	local healthFill = Instance.new("Frame", healthBar)
	healthFill.Name, healthFill.Size = "Fill", UDim2.fromScale(1, 1)
	healthFill.BackgroundColor3 = Color3.fromRGB(80, 220, 120)
	Instance.new("UICorner", healthFill).CornerRadius = UDim.new(1, 0)
	
	local scroller = Instance.new("ScrollingFrame", state.main)
	scroller.Name = "Backpack"
	-- FIX: Adjusted to fit below the new healthbar position
	scroller.Size = UDim2.new(1, -10, 1, -18)
	scroller.Position = UDim2.new(0.5, 0, 1, -4)
	scroller.AnchorPoint = Vector2.new(0.5, 1)
	scroller.BackgroundTransparency, scroller.BorderSizePixel = 1, 0
	scroller.ScrollBarThickness, scroller.AutomaticCanvasSize = 4, Enum.AutomaticSize.Y
	scroller.MouseEnter:Connect(function() _G.BillboardState.activeScroller = scroller end)
	scroller.MouseLeave:Connect(function() _G.BillboardState.activeScroller = nil end)

	local grid = Instance.new("UIGridLayout", scroller)
	grid.CellSize, grid.CellPadding = UDim2.fromOffset(28, 28), UDim2.fromOffset(4, 4)
	grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
	
	local tooltip = Instance.new("TextLabel", scroller)
	tooltip.Name, tooltip.Size = "Tooltip", UDim2.new(1, 0, 0, 20)
	tooltip.Position, tooltip.BackgroundColor3 = UDim2.new(0, 0, 1, 22), Color3.fromRGB(10, 11, 13)
	tooltip.Font, tooltip.TextColor3, tooltip.TextSize = Enum.Font.SourceSans, Color3.new(1, 1, 1), 14
	tooltip.Visible = false
	Instance.new("UICorner", tooltip).CornerRadius = UDim.new(0, 4)
	
	_G.BillboardState.uis[player] = state
	return state
end

local function updateUI(player, char)
	if not _G.BillboardState.enabled then return end
	local state = _G.BillboardState.uis[player]
	if not (state and state.gui) then return end
	
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		local health = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
		local fill = state.main.HealthBar.Fill
		fill.Size = UDim2.fromScale(health, 1)
		fill.BackgroundColor3 = Color3.fromHSV(0.33 * health, 0.7, 0.8)
	end
	
	local pData = CONFIG.platforms[getPlayerPlatform(player)]
	local pIcon = state.main.PlatformIcon
	pIcon.Image, pIcon.ImageColor3 = pData[1], pData[2]

	local scroller = state.main.Backpack
	local tooltip = scroller.Tooltip
	for _, child in scroller:GetChildren() do
		if child:IsA("ImageButton") then child:Destroy() end
	end
	
	for _, tool in player.Backpack:GetChildren() do
		if tool:IsA("Tool") then
			local icon = Instance.new("ImageButton", scroller)
			icon.Size, icon.BackgroundTransparency, icon.Image = UDim2.fromScale(1, 1), 1, tool.TextureId
			icon.MouseEnter:Connect(function() tooltip.Text, tooltip.Visible, tooltip.Parent = tool.Name, true, icon end)
			icon.MouseLeave:Connect(function() tooltip.Visible, tooltip.Parent = false, scroller end)
			icon.MouseButton1Click:Connect(function() tool:Clone().Parent = lp.Backpack end)
		end
	end
end

--// main loop
rs.Heartbeat:Connect(function()
	if not _G.BillboardState.enabled then return end
	local localChar = lp.Character
	if not (localChar and localChar.PrimaryPart) then return end
	local localPos = localChar.PrimaryPart.Position
	
	for _, player in players:GetPlayers() do
		if player == lp then continue end
		
		local state = _G.BillboardState.uis[player] or createElements(player)
		local char = player.Character

		if char and char.PrimaryPart and char:FindFirstChild("Head") then
			local dist = (localPos - char.PrimaryPart.Position).Magnitude
			
			if dist <= CONFIG.distance and state.currentState == "hidden" then
				state.currentState = "visible"
				state.gui.Adornee = char.Head
				state.gui.Parent = char.Head
				animate(state, "in")
			elseif dist > CONFIG.distance and state.currentState == "visible" then
				state.currentState = "hidden"
				local tween = animate(state, "out")
				tween.Completed:Wait()
				if state.currentState == "hidden" then state.gui.Parent = nil end
			end

			if state.currentState == "visible" then updateUI(player, char) end
		elseif state.currentState == "visible" then
			state.currentState = "hidden"
			state.gui.Parent = nil
		end
	end
end)

--// controller & cleanup
uis.InputChanged:Connect(function(input)
	if not _G.BillboardState.enabled or not _G.BillboardState.activeScroller then return end
	if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.Gamepad1_Thumbstick2 then
		local scroller = _G.BillboardState.activeScroller
		scroller.CanvasPosition -= Vector2.new(0, input.Position.Y * CONFIG.scrollSpeed)
	end
end)

players.PlayerRemoving:Connect(function(player)
	if _G.BillboardState.uis[player] then
		_G.BillboardState.uis[player].gui:Destroy()
		_G.BillboardState.uis[player] = nil
	end
end)

lp.Chatted:Connect(function(msg)
	if msg == "#FreeSchlep" and _G.BillboardState.enabled then
		_G.BillboardState.enabled = false
		for _, state in pairs(_G.BillboardState.uis) do state.gui:Destroy() end
		_G.BillboardState.uis = {}
	end
end)

   end,
})

local Tab = Window:CreateTab("Hubs", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Script Hubs")

local Button = Tab:CreateButton({
   Name = "Orca Hub",
   Callback = function()
   
loadstring(
  game:HttpGetAsync("https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua")
)()

   end,
})

local Button = Tab:CreateButton({
   Name = "IY",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
   end,
})

