local isToggledMute = false -- トグル状態
local isHoldMute = false    -- 押してる間ミュート

-- 🔧 状態反映
local function ApplyMute()
    if isToggledMute or isHoldMute then
        exports['pma-voice']:overrideProximityCheck(function()
            return false, 0.0
        end)
    else
        exports['pma-voice']:resetProximityCheck()
    end
end

-- 🔁 トグルミュート（M）
local function ToggleMicMute()
    isToggledMute = not isToggledMute

    if isToggledMute then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    else
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end

    ApplyMute()
end

RegisterCommand("togglemic", function()
    ToggleMicMute()
end)

RegisterKeyMapping("togglemic", "マイクのミュート切り替え", "keyboard", "M")

-- ⏱ 押してる間ミュート（Nキー）
RegisterCommand("+holdmute", function()
    isHoldMute = true
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    ApplyMute()
end, false)

RegisterCommand("-holdmute", function()
    isHoldMute = false
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    ApplyMute()
end, false)

RegisterKeyMapping("+holdmute", "押している間だけマイクミュート", "keyboard", "N")

-- 🔴 表示
CreateThread(function()
    while true do
        if isToggledMute or isHoldMute then
            Wait(0)

            SetTextFont(4)
            SetTextScale(0.5, 0.5)
            SetTextColour(255, 0, 0, 200)
            SetTextOutline()
            SetTextEntry("STRING")

            if isHoldMute then
                AddTextComponentString("🔇 MIC MUTED (HOLD)")
            else
                AddTextComponentString("🔇 MIC MUTED")
            end

            DrawText(0.85, 0.90)
        else
            Wait(500)
        end
    end
end)

-- 🔥 リソース停止時に解除
AddEventHandler("onClientResourceStop", function(res)
    if res == GetCurrentResourceName() then
        exports['pma-voice']:resetProximityCheck()
    end
end)