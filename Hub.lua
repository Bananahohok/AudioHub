local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Audio Hub: Scanner & Player",
   LoadingTitle = "Loading Tools...",
   LoadingSubtitle = "by Minus",
   ConfigurationSaving = { Enabled = false }
})

-- Variables
local previewSound = Instance.new("Sound")
previewSound.Parent = game.Workspace
previewSound.Name = "Gemini_Preview_Audio"

local Favorites = {}
local InputID = ""

-- TABS
local TabScanner = Window:CreateTab("Scanner", 4483362458)
local TabPlayer = Window:CreateTab("Player", 6023426926)
local TabFavorites = Window:CreateTab("Favorites", 4384403532) -- Star Icon

-- --- FUNCTIONS ---

local function AddToFavorites(name, id)
    if not Favorites[id] then
        Favorites[id] = name
        TabFavorites:CreateButton({
            Name = "🎵 " .. name .. " (ID: " .. id .. ")",
            Callback = function()
                InputID = id
                previewSound:Stop()
                previewSound.SoundId = "rbxassetid://" .. id
                previewSound:Play()
                Rayfield:Notify({Title = "Favorites", Content = "Playing: " .. name, Duration = 3})
            end,
        })
        -- Copy Option for Favorite
        TabFavorites:CreateButton({
            Name = " Copy ID: " .. id,
            Callback = function()
                setclipboard(id)
                Rayfield:Notify({Title = "Copied", Content = "ID copied to clipboard!", Duration = 2})
            end,
        })
        return true
    end
    return false
end

-- --- SCANNER TAB ---
TabScanner:CreateSection("Workspace Scanner")

TabScanner:CreateButton({
   Name = "🔍 Scan & List Sounds",
   Callback = function()
       -- Scans every object in the Workspace
       local found = false
       for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
           if v:IsA("Sound") then
               found = true
               local cleanID = v.SoundId:match("%d+")
               if cleanID then
                   TabScanner:CreateSection("Found: " .. v.Name)
                   
                   -- Play Button
                   TabScanner:CreateButton({
                       Name = " Play: " .. v.Name,
                       Callback = function()
                           previewSound:Stop()
                           previewSound.SoundId = "rbxassetid://" .. cleanID
                           previewSound:Play()
                       end
                   })

                   -- Copy Button
                   TabScanner:CreateButton({
                       Name = " Copy ID",
                       Callback = function()
                           setclipboard(cleanID)
                           Rayfield:Notify({Title = "Success", Content = "ID Copied!", Duration = 2})
                       end
                   })

                   -- Favorite Button
                   TabScanner:CreateButton({
                       Name = " Add to Favorites",
                       Callback = function()
                           local added = AddToFavorites(v.Name, cleanID)
                           if added then
                               Rayfield:Notify({Title = "Favorites", Content = "Added to your list!", Duration = 2})
                           else
                               Rayfield:Notify({Title = "Favorites", Content = "Already in favorites.", Duration = 2})
                           end
                       end
                   })
               end
           end
       end

       if not found then
           Rayfield:Notify({Title = "Scanner", Content = "No sounds found.", Duration = 3})
       end
   end,
})

-- --- PLAYER TAB ---
TabPlayer:CreateSection("Audio Controls")

TabPlayer:CreateInput({
   Name = "Sound ID",
   PlaceholderText = "Paste ID here...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       InputID = Text:match("%d+")
   end,
})

TabPlayer:CreateButton({
   Name = " Play Audio",
   Callback = function()
       if InputID and InputID ~= "" then
           previewSound:Stop()
           previewSound.SoundId = "rbxassetid://" .. InputID
           previewSound:Play()
       end
   end,
})

TabPlayer:CreateButton({
   Name = " Stop Audio",
   Callback = function()
       previewSound:Stop()
   end,
})

TabPlayer:CreateSlider({
   Name = "Volume",
   Range = {0, 10},
   Increment = 0.5,
   Suffix = "Vol",
   CurrentValue = 1,
   Callback = function(Value)
       previewSound.Volume = Value
   end,
})

-- --- FAVORITES TAB ---
TabFavorites:CreateSection("Your Saved Songs")
TabFavorites:CreateLabel("Click a song to play or copy its ID below.")
