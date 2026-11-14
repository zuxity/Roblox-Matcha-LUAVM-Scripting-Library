
--==================================================
-- KEEPHAXX V1.3
-- INS-ui | Topbar Edition
-- Dynamic Rapid Slash Keybind
--==================================================

local Lib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/neaxusxgod-png/INS-ui/main/uilib.min.lua"
))() or INSui

local Players = game:GetService("Players")

--==================================================
-- THEME
--==================================================

local PURPLE_A = Color3.fromRGB(145, 75, 255)
local PURPLE_B = Color3.fromRGB(205, 115, 255)

--==================================================
-- WINDOW
--==================================================

local win = Lib:CreateWindow({
    title = "KEEPHAXX",
    subtitle = "V1.3 | TELEPORT & COMBAT",

    size = Vector2.new(760, 560),
    menuKey = "p",

    accentA = PURPLE_A,
    accentB = PURPLE_B,

    font = "Proxima",
    opacity = 0.97,
    rounding = 1.5,

    rowLines = true,
    checkboxStyle = true,
    smartFps = true,
    gameInput = true,
    spotlight = false,
})

-- Appearance
Lib:SetLayout("top")
Lib:SetAccent(PURPLE_A, PURPLE_B)
Lib:SetOpacity(0.97)
Lib:SetRounding(1.5)
Lib:SetFont("Proxima")
Lib:SetRowLines(true)
Lib:SetSpotlight(false)

--==================================================
-- MAIN TAB
--==================================================

local mainTab = win:Tab("Main", "home")

--==================================================
-- RAPID SLASH
--==================================================

local combatSec = mainTab:Section(
    "Combat",
    "Left",
    "Hold your selected key to activate Rapid Slash"
)

local rapidSlashCPS = 20
local rsEnabled = false
local rsKeyHeld = false

local rsToggle = combatSec:Toggle(
    "Rapid Slash",
    false,
    function(on)
        rsEnabled = on

        if on then
            Lib:Notify(
                "Rapid Slash",
                "Enabled - hold your selected key",
                2,
                "success"
            )
        else
            Lib:Notify(
                "Rapid Slash",
                "Disabled",
                2,
                "info"
            )
        end
    end
)

rsToggle:SetRisk()
rsToggle:Tooltip(
    "Enable Rapid Slash, then hold your selected key."
)

-- Native INS-ui dynamic keybind
-- Default key: V
-- Click the keybind chip to change it.

rsToggle:AddKeybind("v", "Hold", function(held)
    rsKeyHeld = held
end)

combatSec:Slider(
    "Clicks per second",
    20,
    1,
    1,
    50,
    " CPS",
    function(v)
        rapidSlashCPS = v
    end
):Tooltip("Adjust the click rate from 1 to 50 CPS.")

--==================================================
-- RAPID SLASH LOOP
--==================================================

task.spawn(function()
    local nextClick = 0

    while true do
        local now = os.clock()

        if rsEnabled
            and rsKeyHeld
            and isrbxactive()
            and now >= nextClick
        then
            mouse1click()
            nextClick = now + (1 / rapidSlashCPS)
        end

        task.wait(0.016)
    end
end)

--==================================================
-- TELEPORT FUNCTION
--==================================================

local function teleport(name, pos)
    local char = Players.LocalPlayer.Character

    local hrp = char
        and char:FindFirstChild("HumanoidRootPart")

    if not hrp then
        Lib:Notify(
            "Teleport",
            "No character loaded",
            2,
            "error"
        )
        return
    end

    hrp.CFrame = CFrame.new(
        pos.X,
        pos.Y,
        pos.Z
    )

    Lib:Notify(
        "Teleported",
        name,
        2,
        "success"
    )
end

--==================================================
-- SECTION BUILDER
--==================================================

local function buildSection(
    tab,
    title,
    side,
    info,
    locations,
    risky
)
    local sec = tab:Section(title, side, info)

    for _, entry in ipairs(locations) do
        local btn = sec:Button(
            entry.name,
            function()
                teleport(entry.name, entry.pos)
            end
        )

        if risky or entry.risk then
            btn:SetRisk()
        end
    end

    return sec
end

--==================================================
-- COORDINATES
--==================================================

local criminal = {
    {
        name = "Wren (Spawn)",
        pos = Vector3.new(-556.50, -59.77, -946.08)
    },
    {
        name = "Wren (Dungeon)",
        pos = Vector3.new(20.31, 91.06, 1286.78)
    },
    {
        name = "Thieves Guild",
        pos = Vector3.new(1739.77, 314.84, 3907.59)
    },
}

local castle = {
    {
        name = "Great Hall",
        pos = Vector3.new(-502.84, 167.85, 1478.21),
        risk = true
    },
    {
        name = "Armory",
        pos = Vector3.new(254.53, 124.67, 1238.40),
        risk = true
    },
    {
        name = "Dungeon",
        pos = Vector3.new(161.32, 126.54, 1380.49)
    },
    {
        name = "Quarters",
        pos = Vector3.new(175.34, 79.83, 1965.19)
    },
    {
        name = "Royal Quarters",
        pos = Vector3.new(327.63, 84.39, 1968.80)
    },
    {
        name = "Church / Sanctum",
        pos = Vector3.new(-678.38, 99.50, 1599.69),
        risk = true
    },
    {
        name = "Throne Room",
        pos = Vector3.new(196.76, 107.75, 1582.86)
    },
    {
        name = "Royal Study",
        pos = Vector3.new(400.07, 83.30, 1680.01)
    },
    {
        name = "Council Chamber",
        pos = Vector3.new(-1048.25, 73.65, 1873.13)
    },
    {
        name = "Judgement Hall",
        pos = Vector3.new(-137.64, 359.60, 1504.63)
    },
    {
        name = "Archives",
        pos = Vector3.new(-573.74, 20.50, 2190.85),
        risk = true
    },
    {
        name = "Kitchen",
        pos = Vector3.new(-1040.05, 53.81, 2203.76),
        risk = true
    },
}

local outside = {
    {
        name = "Spawn",
        pos = Vector3.new(-415.40, -19.45, -908.93)
    },
    {
        name = "Duel Ring",
        pos = Vector3.new(-655.23, 23.38, -568.32)
    },
    {
        name = "Gatehouse",
        pos = Vector3.new(-441.73, 10.37, -569.97)
    },
}

local hidden = {
    {
        name = "Quarters (Hidden)",
        pos = Vector3.new(175.66, 134.12, 1988.12)
    },
    {
        name = "Aldermoor HQ",
        pos = Vector3.new(-124.40, 101.49, 2377.45)
    },
    {
        name = "Beaumont HQ",
        pos = Vector3.new(-124.17, 101.41, 1730.64)
    },
    {
        name = "Argent HQ",
        pos = Vector3.new(-124.12, 101.44, 1361.21)
    },
    {
        name = "Vesper HQ",
        pos = Vector3.new(-124.44, 101.51, 2730.47)
    },
    {
        name = "Drakemoor HQ",
        pos = Vector3.new(-124.18, 101.41, 1018.73)
    },
    {
        name = "Harrowgate HQ",
        pos = Vector3.new(120.36, 101.61, 1076.82)
    },
    {
        name = "Mercer HQ",
        pos = Vector3.new(-123.85, 101.56, 2065.05)
    },
}

local other = {
    {
        name = "Baseplate (safezone 1)",
        pos = Vector3.new(349.58, 314.74, 1421.35)
    },
    {
        name = "Baseplate (safezone 2)",
        pos = Vector3.new(1.05, 6.89, 816.34)
    },
}

--==================================================
-- TELEPORTATION TAB
--==================================================

local tpTab = win:Tab(
    "Teleportation",
    "location-pin-map"
)

buildSection(
    tpTab,
    "Criminal",
    "Left",
    "Criminal-only locations",
    criminal,
    true
)

buildSection(
    tpTab,
    "Main Castle",
    "Left",
    "Starred locations are risky",
    castle,
    false
)

buildSection(
    tpTab,
    "Outside",
    "Right",
    "Spawn / Duel / Gatehouse",
    outside,
    false
)

buildSection(
    tpTab,
    "Hidden",
    "Right",
    "Gang hideouts",
    hidden,
    true
)

buildSection(
    tpTab,
    "Other",
    "Right",
    "Safezones",
    other,
    false
)

--==================================================
-- SETTINGS
--==================================================

win:AddSettingsTab("cog")

--==================================================
-- INITIALIZATION
--==================================================

Lib:Notify(
    "KEEPHAXX V1.3",
    "Successfully loaded",
    3,
    "success"
)
