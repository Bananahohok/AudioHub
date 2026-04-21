local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MB: MultiHub",
   LoadingTitle = "Loading Multi-Tools...",
   LoadingSubtitle = "by Minus",
   ConfigurationSaving = { Enabled = false }
})

-- Variables
local previewSound = Instance.new("Sound")
previewSound.Parent = game.Workspace
previewSound.Name = "MB_Preview_Audio"

local Favorites = {}
local InputID = ""
local AutoFarmEnabled = false
local AutoCollectEnabled = false
local AutoOpenEnabled = false
local AutoDeleteEnabled = false

-- --- FUNCTIONS ---

local function IsSafe(object)
    local blacklist = {"Fake", "Honey", "Trap", "Admin", "Test"}
    for _, word in pairs(blacklist) do
        if object.Name:find(word) then return false end
    end
    return true
end

local function AddToFavorites(name, id)
    if not Favorites[id] then
        Favorites[id] = true
        local FavSection = TabFavorites:CreateSection("Audio: " .. name)
        local PlayButton = TabFavorites:CreateButton({
            Name = name .. " (ID: " .. id .. ")",
            Callback = function()
                if Favorites[id] then
                    pcall(function()
                        previewSound:Stop()
                        previewSound.SoundId = "rbxassetid://" .. id
                        previewSound:Play()
                    end)
                end
            end,
        })
        local UnfavButton = TabFavorites:CreateButton({
            Name = "Unfavorite",
            Callback = function()
                if Favorites[id] then
                    Favorites[id] = nil
                    PlayButton:Set("Removed")
                    UnfavButton:Set("Deleted")
                end
            end,
        })
        return true
    end
    return false
end

-- --- TABS ---
local TabScanner = Window:CreateTab("Audio Scanner", 4483362458)
local TabScripts = Window:CreateTab("Scripts", 4483364237)
local TabFun = Window:CreateTab("Fun", 4483362458)
local TabNetwork = Window:CreateTab("Network", 4483345998)
local TabFavorites = Window:CreateTab("Favorites", 4384403532)

-- --- FUN TAB (8 Opções) ---
TabFun:CreateSection("Movement & Stats")

TabFun:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

TabFun:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

TabFun:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
       _G.InfJump = Value
       game:GetService("UserInputService").JumpRequest:Connect(function()
           if _G.InfJump then
               game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
           end
       end)
   end,
})

TabFun:CreateSection("Visuals")

TabFun:CreateButton({
   Name = "Full Brightness",
   Callback = function()
       local Lighting = game:GetService("Lighting")
       Lighting.Brightness = 2
       Lighting.ClockTime = 14
       Lighting.GlobalShadows = false
       Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
   end,
})

TabFun:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
       _G.Noclip = Value
       game:GetService("RunService").Stepped:Connect(function()
           if _G.Noclip then
               for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                   if v:IsA("BasePart") then v.CanCollide = false end
               end
           end
       end)
   end,
})

TabFun:CreateSection("Tools & Admin")

TabFun:CreateButton({
   Name = "Teleport Tool (Click)",
   Callback = function()
       local mouse = game.Players.LocalPlayer:GetMouse()
       local tool = Instance.new("Tool")
       tool.RequiresHandle = false
       tool.Name = "Click TP"
       tool.Activated:Connect(function()
           local pos = mouse.Hit + Vector3.new(0, 3, 0)
           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
       end)
       tool.Parent = game.Players.LocalPlayer.Backpack
   end,
})

TabFun:CreateButton({
   Name = "Fly (Requires Script)",
   Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
   end,
})

TabFun:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
       loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

-- --- SCRIPTS TAB (Com proteção contra erros de memória/assets) ---
TabScripts:CreateSection("Farming")

TabScripts:CreateToggle({
   Name = "Teleport To Chests",
   CurrentValue = false,
   Callback = function(Value)
       AutoFarmEnabled = Value
       if Value then
           local BV = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
           local BG = Instance.new("BodyGyro", game.Players.LocalPlayer.Character.HumanoidRootPart)
           BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
           BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
           while AutoFarmEnabled do
               pcall(function()
                   for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                       if (v.Name:find("Chest") or v.Parent.Name == "chests") and v:IsA("BasePart") then
                           if IsSafe(v) then
                               game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                               wait(0.5)
                           end
                       end
                   end
               end)
               wait(1)
           end
           BV:Destroy()
           BG:Destroy()
       end
   end,
})

TabScripts:CreateToggle({
    Name = "Auto Collect Proximity",
    CurrentValue = false,
    Callback = function(Value)
        AutoCollectEnabled = Value
        while AutoCollectEnabled do
            pcall(function()
                for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if v:IsA("ProximityPrompt") and IsSafe(v.Parent) then
                        fireproximityprompt(v)
                    end
                end
            end)
            wait(0.1)
        end
    end,
})

TabScripts:CreateSection("World & Server")

TabScripts:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        for _, s in pairs(servers) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
            end
        end
    end,
})

TabScripts:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end,
})

-- (As outras abas mantêm a funcionalidade original com proteções adicionadas)
