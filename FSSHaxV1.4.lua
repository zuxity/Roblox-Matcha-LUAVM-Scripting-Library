-- ============================================================================
-- FSSHaxx V1.4 - FIFA Super Soccer Script
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
    subtitle     = "V1.4",
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

-- 3. Create Tab and Sections
local mainTab = win:Tab("Features", "swords")
local mechanicsSec = mainTab:Section("Match Mechanics", "Left")
local goalpostSec = mainTab:Section("Goalpost Controls", "Right")

-- ============================================================================
-- FEATURE 1: Infinite Stamina (Toggle with Loop)
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
-- FEATURE 2: Tackle Hitbox Extender (Toggle)
-- ============================================================================
mechanicsSec:Toggle("Tackle Hitbox Extender", false, function(on)
    -- Use pcall to prevent the script from crashing if the workspace path changes
    local success, err = pcall(function()
        local tackleHitbox = game.Workspace.JailWilly.TackleHitbox
        
        if on then
            -- Apply modded size
            tackleHitbox.Size = Vector3.new(3.59, 8.022, 2.884)
            Lib:Notify("FSSHaxx", "Tackle hitbox extended!", 3, "success")
        else
            -- Revert to original size
            tackleHitbox.Size = Vector3.new(2.57, 5.73, 2.06)
            Lib:Notify("FSSHaxx", "Tackle hitbox reset to default.", 3, "info")
        end
    end)

    if not success then
        Lib:Notify("FSSHaxx", "Failed to modify tackle hitbox: " .. tostring(err), 3, "error")
        warn("Tackle Hitbox Error: " .. tostring(err))
    end
end):Tooltip("Increases the size of the JailWilly tackle hitbox for easier tackles.")

-- ============================================================================
-- FEATURE 3: Dynamic Goalpost Extender
-- ============================================================================

-- Helper function to apply the size safely and avoid code duplication
local function applyGoalpostSize(x, y, z)
    local newSize = Vector3.new(x, y, z)
    
    -- Use pcall to prevent the script from crashing if the workspace path changes
    local success, err = pcall(function()
        local awayGoal = game.Workspace.Stadium.Teams.Away.Goal.Hitbox
        awayGoal.Size = newSize
        
        local homeGoal = game.Workspace.Stadium.Teams.Home.Goal.Hitbox
        homeGoal.Size = newSize
    end)

    if success then
        Lib:Notify("FSSHaxx", "Goalpost size updated to (" .. x .. ", " .. y .. ", " .. z .. ")", 3, "success")
    else
        Lib:Notify("FSSHaxx", "Failed: " .. tostring(err), 3, "error")
        warn("Goalpost Extender Error: " .. tostring(err))
    end
end

-- A. Uniform Slider: Dynamically scales X, Y, and Z together
goalpostSec:Slider("Uniform Size", 99, 1, 1, 200, "", function(v)
    applyGoalpostSize(v, v, v)
end):Tooltip("Dynamically scales X, Y, and Z to the same value instantly.")

-- Visual separator for better UI organization
goalpostSec:Divider("Custom XYZ")

-- B. Three Textboxes for precise X, Y, Z control
local currentX, currentY, currentZ = "99", "99", "99"

goalpostSec:Textbox("Size X", "99", function(text)
    currentX = text
end):Tooltip("Enter exact X dimension")

goalpostSec:Textbox("Size Y", "99", function(text)
    currentY = text
end):Tooltip("Enter exact Y dimension")

goalpostSec:Textbox("Size Z", "99", function(text)
    currentZ = text
end):Tooltip("Enter exact Z dimension")

-- C. Apply Button: Reads the textboxes and applies the custom size
goalpostSec:Button("Apply Custom XYZ", function()
    -- tonumber ensures we convert the string input to a number, defaulting to 99 if invalid
    local x = tonumber(currentX) or 99
    local y = tonumber(currentY) or 99
    local z = tonumber(currentZ) or 99
    
    applyGoalpostSize(x, y, z)
end):Tooltip("Applies the exact X, Y, and Z values from the boxes above.")

-- ============================================================================
-- Startup Notification
-- ============================================================================
task.wait(1)
Lib:Notify("FSSHaxx", "Loaded successfully (V1.4). Press 'P' to toggle menu.", 4, "info")
