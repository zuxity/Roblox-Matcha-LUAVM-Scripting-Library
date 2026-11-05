-- Keephaxx V1.1 -- Teleportation Hub (Matcha-safe CFrame fix + spotlight off)
-- Uses only Matcha-safe API: Players.LocalPlayer, Character, FindFirstChild,
-- BasePart.Position / CFrame, Vector3, CFrame (3-arg form only).

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/neaxusxgod-png/INS-ui/main/uilib.min.lua"))() or INSui
local Players = game:GetService("Players")

-- ============ WINDOW ============
local win = Lib:CreateWindow({
    title     = "Keephaxx V1",
    subtitle  = "v1",
    size      = Vector2.new(700, 540),
    menuKey   = "p",
    accent    = Color3.fromRGB(160, 90, 255),
    smartFps  = true,
    search    = "Off",     -- hides the title-bar search box
    gameInput = false,     -- menu holds input while open (default, explicit)
})

-- Fully disable the spotlight: no Ctrl+Space, no palette, no title-bar trigger.
Lib:SetSpotlight(false)

local mainTab = win:Tab("Main", "home")
local mainSec = mainTab:Section("Welcome", "Full")
mainSec:Label("Keephaxx V1 -- Main features coming in v2.")
mainSec:Info("For now, use the Teleportation tab on the left.")

-- ============ TELEPORT HELPER ============
-- MATCHA QUIRK: CFrame.new on this LuaVM only accepts 0, 3, 6, or 12 args.
-- A Vector3 (1-arg) throws "expects 0, 3, 6, or 12 arguments".
-- So we always pass x, y, z as three separate numbers.
local function teleport(name, pos)
    local char = Players.LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        Lib:Notify("Teleport", "No character loaded", 2, "error")
        return
    end
    -- 3-arg CFrame.new -- the form Matcha's emulator actually supports.
    hrp.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
    Lib:Notify("Teleported", name, 2, "success")
end

-- Build a run of buttons from a coordinate list.
local function buildSection(tab, title, side, info, list, risky)
    local sec = tab:Section(title, side, info)
    for _, e in ipairs(list) do
        local btn = sec:Button(e.name, function()
            teleport(e.name, e.pos)
        end)
        if risky or e.risk then btn:SetRisk() end
    end
    return sec
end

-- ============ COORDINATE DATA ============
local criminal = {
    { name = "Wren (Spawn)",   pos = Vector3.new(-556.50, -59.77, -946.08) },
    { name = "Wren (Dungeon)", pos = Vector3.new(  20.31,  91.06, 1286.78) },
    { name = "Thieves Guild",  pos = Vector3.new(1739.77, 314.84, 3907.59) },
}

local castle = {
    { name = "Great Hall",       pos = Vector3.new( -502.84, 167.85, 1478.21), risk = true },
    { name = "Armory",           pos = Vector3.new(  254.53, 124.67, 1238.40), risk = true },
    { name = "Dungeon",          pos = Vector3.new(  161.32, 126.54, 1380.49) },
    { name = "Quarters",         pos = Vector3.new(  175.34,  79.83, 1965.19) },
    { name = "Royal Quarters",   pos = Vector3.new(  327.63,  84.39, 1968.80) },
    { name = "Church / Sanctum", pos = Vector3.new( -678.38,  99.50, 1599.69), risk = true },
    { name = "Throne Room",      pos = Vector3.new(  196.76, 107.75, 1582.86) },
    { name = "Royal Study",      pos = Vector3.new(  400.07,  83.30, 1680.01) },
    { name = "Council Chamber",  pos = Vector3.new(-1048.25,  73.65, 1873.13) },
    { name = "Judgement Hall",   pos = Vector3.new( -137.64, 359.60, 1504.63) },
    { name = "Archives",         pos = Vector3.new( -573.74,  20.50, 2190.85), risk = true },
    { name = "Kitchen",          pos = Vector3.new(-1040.05,  53.81, 2203.76), risk = true },
}

local outside = {
    { name = "Spawn",     pos = Vector3.new(-415.40, -19.45, -908.93) },
    { name = "Duel Ring", pos = Vector3.new(-655.23,  23.38, -568.32) },
    { name = "Gatehouse", pos = Vector3.new(-441.73,  10.37, -569.97) },
}

local hidden = {
    { name = "Quarters (Hidden)", pos = Vector3.new( 175.66, 134.12, 1988.12) },
    { name = "Aldermoor HQ",      pos = Vector3.new(-124.40, 101.49, 2377.45) },
    { name = "Beaumont HQ",       pos = Vector3.new(-124.17, 101.41, 1730.64) },
    { name = "Argent HQ",         pos = Vector3.new(-124.12, 101.44, 1361.21) },
    { name = "Vesper HQ",         pos = Vector3.new(-124.44, 101.51, 2730.47) },
    { name = "Drakemoor HQ",      pos = Vector3.new(-124.18, 101.41, 1018.73) },
    { name = "Harrowgate HQ",     pos = Vector3.new( 120.36, 101.61, 1076.82) },
    { name = "Mercer HQ",         pos = Vector3.new(-123.85, 101.56, 2065.05) },
}

local other = {
    { name = "Baseplate (safezone 1)", pos = Vector3.new(349.58, 314.74, 1421.35) },
    { name = "Baseplate (safezone 2)", pos = Vector3.new(  1.05,   6.89,  816.34) },
}

-- ============ TELEPORTATION TAB ============
local tpTab = win:Tab("Teleportation", "target")

buildSection(tpTab, "Criminal",    "Left",  "criminal-only spots",       criminal, true)
buildSection(tpTab, "Main Castle", "Left",  "starred = criminal target", castle,   false)
buildSection(tpTab, "Outside",     "Right", "spawn / duel / gatehouse",  outside,  false)
buildSection(tpTab, "Hidden",      "Right", "gang hideouts",             hidden,   true)
buildSection(tpTab, "Other",       "Right", "safezones",                 other,    false)

win:AddSettingsTab("cog")
