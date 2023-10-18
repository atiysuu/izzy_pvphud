local statstable = {}

RegisterServerEvent("allahuekberbismillah")
AddEventHandler("allahuekberbismillah", function()
    src = source
    statstable[src] = {}
    
    for k,v in pairs(GetPlayerIdentifier(src)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            statstable[src].hex = v
        end
    end

    local result = MySQL.Sync.fetchAll('SELECT kills, deaths FROM users WHERE identifier = @identifier', {
        ['@identifier'] = statstable[src].hex
    })

    statstable[src].deaths = result[1].deaths
    statstable[src].kills = result[1].kills
    
    print("[bq_hud] Loaded Player ["..src.."]")
    TriggerClientEvent("rhud:send:info", src, statstable[src])
end)

exports('getPlayerPoints', function(src)
    if statstable[src] then
        return statstable[src]
    else
        return false
    end
end)

RegisterServerEvent('bq:onPlayerDeath')
AddEventHandler('bq:onPlayerDeath', function(data)
    if data.killerServerId == 0 then
        statstable[source].deaths = statstable[source].deaths + 1
        TriggerClientEvent("rhud:send:info", source, statstable[source])
    else
        if statstable[data.killerServerId] == nil then
            print(data.killerServerId, "DATA ERROR", 'There was a problem with your data, please log out.', 5000, "error")
            return
        end

        if statstable[source] == nil then
            print(source, "DATA ERROR", 'There was a problem with your data, please log out.', 5000, "error")
            return
        end        
        statstable[data.killerServerId].kills = statstable[data.killerServerId].kills + 1
        statstable[source].deaths = statstable[source].deaths + 1

        TriggerClientEvent("rhud:send:info", data.killerServerId, statstable[data.killerServerId])
        TriggerClientEvent("rhud:send:info", source, statstable[source])
    end
end)


RegisterServerEvent("bq:ply:jokejoke")
AddEventHandler("bq:ply:jokejoke", function()
    src = source
    if statstable[src] then
        MySQL.Async.execute('UPDATE users SET kills = @newkills WHERE identifier = @identifier', {
            ["@identifier"] = statstable[src].hex,
            ["@newkills"] = statstable[src].kills
        })
        MySQL.Async.execute('UPDATE users SET deaths = @newdeaths WHERE identifier = @identifier', {
            ["@identifier"] = statstable[src].hex,
            ["@newdeaths"] = statstable[src].deaths
        })
    end
end)

AddEventHandler('playerDropped', function (reason)
    src = source
    if statstable[src] then
        MySQL.Async.execute('UPDATE users SET kills = @newkills WHERE identifier = @identifier', {
            ["@identifier"] = statstable[src].hex,
            ["@newkills"] = statstable[src].kills
        })
        MySQL.Async.execute('UPDATE users SET deaths = @newdeaths WHERE identifier = @identifier', {
            ["@identifier"] = statstable[src].hex,
            ["@newdeaths"] = statstable[src].deaths
        })
        statstable[src] = nil
    end
end)
