local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "AudioHub",
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
local TabFavorites = Window:CreateTab("Favorites", 4384403532)

-- --- FUNCTIONS ---

local function AddToFavorites(name, id)
    if not Favorites[id] then
        Favorites[id] = true
        
        -- Create a section to group the specific audio and its remove button
        local FavSection = TabFavorites:CreateSection("Audio: " .. name)
        
        local PlayButton = TabFavorites:CreateButton({
            Name = "Play: " .. name .. " (ID: " .. id .. ")",
            Callback = function()
                previewSound:Stop()
                previewSound.SoundId = "rbxassetid://" .. id
                previewSound:Play()
            end,
        })

        local RemoveButton = TabFavorites:CreateButton({
            Name = "Remove: " .. name,
            Callback = function()
                Favorites[id] = nil
                PlayButton:Destroy()
                FavSection:Destroy()
                -- Removing the button itself
                -- Some Rayfield versions require a specific cleanup, but Destroy() is the standard.
            end,
        })
        
        -- Store the button in the table so we can track it if needed
        return true
    end
    return false
end

-- --- SCANNER TAB ---
TabScanner:CreateSection("Quick Controls")

-- Stop Button (Always at the top for easy access)
TabScanner:CreateButton({
   Name = " STOP ALL PREVIEWS",
   Callback = function()
       previewSound:Stop()
       Rayfield:Notify({Title = "Audio", Content = "Playback stopped.", Duration = 1.5})
   end,
})

TabScanner:CreateButton({
   Name = "🔍 Scan Workspace Sounds",
   Callback = function()
       local found = false
       for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
           if v:IsA("Sound") then
               found = true
               local cleanID = v.SoundId:match("%d+")
               if cleanID then
                   TabScanner:CreateSection("Audio: " .. v.Name)
                   
                   -- Combined Play & Copy to reduce UI lag
                   TabScanner:CreateButton({
                       Name = " Play & Copy ID: " .. cleanID,
                       Callback = function()
                           previewSound:Stop()
                           previewSound.SoundId = "rbxassetid://" .. cleanID
                           previewSound:Play()
                           setclipboard(cleanID)
                           Rayfield:Notify({Title = "Scanner", Content = "Playing & ID Copied!", Duration = 1.5})
                       end
                   })

                   TabScanner:CreateButton({
                       Name = " Add to Favorites",
                       Callback = function()
                           if AddToFavorites(v.Name, cleanID) then
                               Rayfield:Notify({Title = "Success", Content = "Saved to favorites!", Duration = 1.5})
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
TabPlayer:CreateSection("Manual Player")

TabPlayer:CreateInput({
   Name = "Audio ID",
   PlaceholderText = "Paste ID...",
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
   CurrentValue = 1,
   Callback = function(Value)
       previewSound.Volume = Value
   end,
})

-- --- FAVORITES TAB ---
TabFavorites:CreateSection("Saved Audios")
