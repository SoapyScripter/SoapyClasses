--[[local admins = {"soapyscripter"}

ListenToEvent("AllMessage_OnClient", function(msg, teamID, playerActor)
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