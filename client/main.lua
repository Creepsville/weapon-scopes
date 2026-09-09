Config = Config or {}

Framework = Framework or {}
Framework.Type = nil
Framework.Object = nil
Framework.Ready = false

local function DetectFramework()
    if Config.Framework ~= 'auto' then
        return Config.Framework:lower()
    end
    
    if GetResourceState(Config.FrameworkSettings.RSG.resourceName) == 'started' then
        return 'rsg'
    elseif GetResourceState(Config.FrameworkSettings.VORP.resourceName) == 'started' then
        return 'vorp'
    else
        return 'standalone'
    end
end

Framework.Type = DetectFramework()

if Framework.Type == 'rsg' then
    if Config.FrameworkSettings.RSG.useExports then
        Citizen.CreateThread(function()
            while not Framework.Object do
                Framework.Object = exports[Config.FrameworkSettings.RSG.exportName]:GetCoreObject()
                if not Framework.Object then Wait(100) end
            end
            Framework.Ready = true
        end)
    end
elseif Framework.Type == 'vorp' then
    if Config.FrameworkSettings.VORP.useExports then
        Citizen.CreateThread(function()
            Framework.Object = exports[Config.FrameworkSettings.VORP.exportName]:GetCore()
            Framework.Ready = true
        end)
    end
elseif Framework.Type == 'standalone' then
    Framework.Ready = true
end

-- Unified Client/Server Notification Function
---@diagnostic disable-next-line: duplicate-set-field
function Framework.Notify(source, message, type, duration)
    type = type or "info"
    duration = duration or 3000

    if not Config.Notifications.enabled then return end

    if IsDuplicityVersion() then
        -- SERVER SIDE
        if Framework.Type == 'rsg' then
            TriggerClientEvent(Config.FrameworkSettings.RSG.events.notify, source, message, type, duration)
        elseif Framework.Type == 'vorp' then
            TriggerClientEvent('vorp:NotifyLeft', source, "Weapon Scopes", message, "generic_textures", "generic_tick", duration)
        else
            TriggerClientEvent('chat:addMessage', source, { args = { "[Scopes]", message } })
        end
    else
        -- CLIENT SIDE
        if Framework.Type == 'rsg' then
            TriggerEvent(Config.FrameworkSettings.RSG.events.notify, message, type, duration)
        elseif Framework.Type == 'vorp' then
            if Framework.Object and Framework.Object.NotifyLeft then
                Framework.Object.NotifyLeft("Weapon Scopes", message, "itemtype_textures", "itemtype_weapons", duration, "COLOR_WHITE")
            else
                TriggerEvent('vorp:NotifyLeft', "Weapon Scopes", message, "generic_textures", "generic_tick", duration)
            end
        else
            SetNotificationTextEntry("STRING")
            AddTextComponentString(message)
            DrawNotification(false, false)
        end
    end
end