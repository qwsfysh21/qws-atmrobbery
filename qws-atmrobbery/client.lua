ESX = exports["es_extended"]:getSharedObject()

local atmRobberyCooldowns = {}

function options()
    return {
        {
            label = "Røv denne ATM",
            icon = 'fa fa-arrow-right',
            onSelect = function()
                TriggerServerEvent("qws_atmrobbery:check_hackerdevice")
            end
        }
    }
end

exports.ox_target:addModel("prop_fleeca_atm", options())

-- Menuen 
lib.registerContext({
    id = "qws_atmrobberyM",
    title = "QWS - ATM ROBBERY!",
    options = {
        {
            title = 'Røv denne atm, og modtag penge!', 
            description = "Modtag mellem 2800 og 8700 DKK,-",
            icon = 'https://cdn.discordapp.com/attachments/1203978985428623411/1252658376953954315/10384161.png?ex=66730486&is=6671b306&hm=93d1e7a9b294faa224562d4db7494f5efe34d6fbeee4246d43db2bd5856097c7&',
            onSelect = function()
                local playerPed = PlayerPedId()
                local playerId = GetPlayerServerId(PlayerId())

                -- Check cooldown
                if atmRobberyCooldowns[playerId] and atmRobberyCooldowns[playerId] > GetGameTimer() then
                    local timeRemaining = math.ceil((atmRobberyCooldowns[playerId] - GetGameTimer()) / 60000)
                    lib.notify({
                        description = 'Vent ' .. timeRemaining .. ' minutter før du prøver igen!',
                        type = 'error'
                    })
                    return
                end

                TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
                
                local success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'easy'}, {'w',})
                if success then
                    TriggerServerEvent("qws_atmrobbery:modtagpenge")
                    lib.notify({
                        description = 'Du modtog dine penge! Tillykke.', 
                        type = 'success'
                    })
                else
                    lib.notify({
                        description = 'Det lykkedes dig ikke! Prøv igen om 5 minutter!',
                        type = "error"
                    })
                    atmRobberyCooldowns[playerId] = GetGameTimer() + (1 * 60000) 
                end              
                ClearPedTasks(playerPed)
            end
        }
    }
})

-- Notifys 
RegisterNetEvent("qws:manglerhackerdevice")
AddEventHandler("qws:manglerhackerdevice", function()
    lib.notify({
        title = "Fejl",
        description = "Du mangler en hackerdevice for at starte røveriet!",
        type = 'error'
    })
end)

RegisterNetEvent("qws:manglerplads_atm")
AddEventHandler("qws:manglerplads_atm", function()
    lib.notify({
        title = "Fejl",
        description = "Du har ikke plads i dit inventory til pengene!",
        type = 'error'
    })
end)

RegisterNetEvent("qws:atmrobberyM")
AddEventHandler("qws:atmrobberyM", function()
    lib.showContext("qws_atmrobberyM")
end)
