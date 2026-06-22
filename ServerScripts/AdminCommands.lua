local admins = {"soapyscripter"}

--[[ListenToEvent("AllMessage_OnClient", function(msg, teamID, playerActor)
    if teamID ~= 0 then
        for i, admin in ipairs(admins) do
            if string.lower(playerActor.PlayersName) == string.lower(admin) then
                if msg == "!debug" then

                end
            end
        end
    end
end)
]]--

ListenToEvent("RoundStarted", function()
    for i, player in ipairs(GetPlayerChars()) do
        for i, admin in ipairs(admins) do
            if string.lower(player.PlayersName) == string.lower(admin) then
                for wi=1, 39, 1 do
                    player.WeaponComponent:SetSkinSv(wi, 65)
                end
            end
        end
    end
end)