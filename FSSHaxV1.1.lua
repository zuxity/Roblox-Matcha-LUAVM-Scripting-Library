-- ============================================================================
-- FSSHaxx V1.1 - FIFA Super Soccer Script
-- Environment: Matcha LuaVM
-- UI Library: INS UI
-- ============================================================================

-- 1. Initialize INS UI Library
-- We use 'or INSui' because Matcha discards chunk return values, 
-- but the library publishes itself globally as INSui.
local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/neaxusxgod-png/INS-ui/main/uilib.min.lua"))() or INSui

-- 2. Create the Main Window
local win = Lib:CreateWindow({
    title        = "FSSHaxx",
    subtitle     = "V1.1",
    size         = Vector2.new(650, 450),
    menuKey      = "p",
    configName   = "fsshaxx_v1",
    configFolder = "FSSHaxx",
    accent       = Color3.fromRGB(46, 204, 113), -- FIFA Green accent
    backgroundEffect = "Off",
    startOpen    = true
})

-- Add the built-in Settings tab (configs, themes, performance)
win:AddSettingsTab("cog")

-- 3. Create Tab and Section
local mainTab = win:Tab("Features", "swords")
local mechanicsSec = mainTab:Section("Match Mechanics", "Left")

-- ============================================================================
-- FEATURE 1: Goalpost Extender (Button)
-- ============================================================================
mechanicsSec:Button("Extend Goalposts", function()
    -- Use pcall to prevent the script from crashing if the workspace path changes
    local success, err = pcall(function()
        local newSize = Vector3.new(99, 99, 99)
        
        -- Modify Away Team Goal
        local awayGoal = game.Workspace.Stadium.Teams.Away.Goal.Hitbox
        awayGoal.Size = newSize
        
        -- Modify Home Team Goal
        local homeGoal = game.Workspace.Stadium.Teams.Home.Goal.Hitbox
        homeGoal.Size = newSize
    end)

    if success then
        Lib:Notify("FSSHaxx", "Goalposts extended successfully!", 3, "success")
    else
        Lib:Notify("FSSHaxx", "Failed: " .. tostring(err), 3, "error")
        warn("Goalpost Extender Error: " .. tostring(err))
    end
end):Tooltip("Makes both goal hitboxes massive (99x99x99).")

-- ============================================================================
-- FEATURE 2: Infinite Stamina (Toggle with Loop)
-- ============================================================================
local staminaEnabled = false

mechanicsSec:Toggle("Infinite Stamina", false, function(on)
    staminaEnabled = on
    
    if on then
        Lib:Notify("FSSHaxx", "Infinite Stamina enabled", 3, "success")
        
        -- Spawn a background thread to continuously apply the effect
        task.spawn(function()
            while staminaEnabled do
                -- Wrapped in pcall to prevent script crash if setgc is unsupported or fails
                pcall(function()
                    setgc({ DelayAfterConsume = 0, RegenRate = 0, RegenAmount = 100000 })
                end)
                
                -- Wait 1 second before next iteration
                task.wait(1)
            end
        end)
    else
        Lib:Notify("FSSHaxx", "Infinite Stamina disabled", 3, "warning")
    end
end):Tooltip("Continuously regenerates stamina using setgc.")

-- ============================================================================
-- Startup Notification
-- ============================================================================
task.wait(1)
Lib:Notify("FSSHaxx", "Loaded successfully. Press 'P' to toggle menu.", 4, "info")