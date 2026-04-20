local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local Settings = {
    OneHitKill = false,
    GodMode = false,
    KillRadius = 50,
    Language = "English"
}

-- [ DICIONÁRIO DE TRADUÇÃO ] --
local Localization = {
    ["English"] = {
        Win = "💀 TROLLGE MOD MENU 💀",
        Tab1 = "Combat",
        OHK = "One Hit Kill", OHKDesc = "Instantly kills nearby mobs",
        God = "God Mode", GodDesc = "You cannot die",
        Rad = "Kill Radius",
        Tab2 = "Stats",
        User = "Player: ",
        Tab3 = "Settings",
        Lang = "Select Language"
    },
    ["Português Brasil"] = {
        Win = "💀 TROLLGE MENU 💀",
        Tab1 = "Combate",
        OHK = "Matar com 1 Golpe", OHKDesc = "Mata mobs instantaneamente",
        God = "Modo Deus", GodDesc = "Você não morre",
        Rad = "Raio de Morte",
        Tab2 = "Status",
        User = "Jogador: ",
        Tab3 = "Configurações",
        Lang = "Selecionar Idioma"
    },
    ["Español"] = {
        Win = "💀 TROLLGE MENU 💀",
        Tab1 = "Combate",
        OHK = "Matar de un Golpe", OHKDesc = "Mata mobs al instante",
        God = "Modo Dios", GodDesc = "No puedes morir",
        Rad = "Radio de Muerte",
        Tab2 = "Estadísticas",
        User = "Jugador: ",
        Tab3 = "Ajustes",
        Lang = "Seleccionar Idioma"
    }
}

-- [ CRIAÇÃO DA JANELA ] --
local Window = Rayfield:CreateWindow({
    Name = Localization[Settings.Language].Win,
    LoadingTitle = "Trollge Hub",
    LoadingSubtitle = "by Gemini",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- Variáveis das Abas para Tradução em tempo real
local CombatTab = Window:CreateTab(Localization[Settings.Language].Tab1)
local StatsTab = Window:CreateTab(Localization[Settings.Language].Tab2)
local SettingsTab = Window:CreateTab(Localization[Settings.Language].Tab3)

-- [ ABA 1: COMBATE ] --
local OHK_Toggle = CombatTab:CreateToggle({
    Name = Localization[Settings.Language].OHK,
    CurrentValue = false,
    Callback = function(Value) Settings.OneHitKill = Value end,
})

local God_Toggle = CombatTab:CreateToggle({
    Name = Localization[Settings.Language].God,
    CurrentValue = false,
    Callback = function(Value) Settings.GodMode = Value end,
})

local Rad_Slider = CombatTab:CreateSlider({
    Name = Localization[Settings.Language].Rad,
    Range = {10, 150},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value) Settings.KillRadius = Value end,
})

-- [ ABA 2: STATUS ] --
local UserLabel = StatsTab:CreateLabel(Localization[Settings.Language].User .. player.Name)

-- [ ABA 3: CONFIGURAÇÕES ] --
local LangDropdown = SettingsTab:CreateDropdown({
    Name = Localization[Settings.Language].Lang,
    Options = {"English", "Português Brasil", "Español"},
    CurrentOption = {Settings.Language},
    Callback = function(Option)
        local Selected = Option[1]
        Settings.Language = Selected
        local L = Localization[Selected]
        
        -- Atualiza os textos instantaneamente sem fechar o menu!
        OHK_Toggle:Set(L.OHK)
        God_Toggle:Set(L.God)
        Rad_Slider:Set(L.Rad)
        UserLabel:Set(L.User .. player.Name)
        Rayfield:Notify({Title = "Language Changed", Content = "Menu updated to " .. Selected})
    end,
})

-- [ LÓGICA DE COMBATE OTIMIZADA (ANTI-LAG) ] --
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end

    if Settings.GodMode then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end
    
    if Settings.OneHitKill then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            -- Verifica apenas o que está no Workspace principal (muito mais rápido)
            for _, v in ipairs(workspace:GetChildren()) do
                if v:IsA("Model") and v ~= char then
                    local eHum = v:FindFirstChild("Humanoid")
                    local eRoot = v:FindFirstChild("HumanoidRootPart")
                    if eHum and eRoot and eHum.Health > 0 then
                        if (root.Position - eRoot.Position).Magnitude <= Settings.KillRadius then
                            eHum.Health = 0
                        end
                    end
                end
            end
        end
    end
end)
