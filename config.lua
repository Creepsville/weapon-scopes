local REQUIRED_RESOURCE_NAME = "weapon-scopes"
local currentResourceName = GetCurrentResourceName()

if currentResourceName ~= REQUIRED_RESOURCE_NAME then
    error(string.format([[

    ]], REQUIRED_RESOURCE_NAME, currentResourceName))
end

Config = {}

--[[
    Framework Priority (in order):
    1. RSG-Core  - Primary framework with full feature support  
    2. VORP Core - Supported framework with complete legacy functionality
    3. Standalone - Basic command-only mode
    
    Set to 'auto' for automatic detection or specify: 'lxr', 'rsg', 'vorp', 'standalone'
--]]

Config.Framework = 'vorp' -- 'auto', 'rsg', 'vorp', 'standalone'

Config.FrameworkSettings = {

    -- RSG-Core Settings (Primary)
    RSG = {
        enabled = true,
        resourceName = 'rsg-core',
        exportName = 'rsg-core',
        events = {
            playerLoaded = 'RSGCore:Client:OnPlayerLoaded',
            playerUnload = 'RSGCore:Client:OnPlayerUnload',
            notify = 'RSGCore:Client:Notify',
        },
        useExports = true,
    },

    -- VORP Settings (Supported/Legacy)
    VORP = {
        enabled = true,
        resourceName = 'vorp_core',
        inventoryResource = 'vorp_inventory',
        exportName = 'vorp_core',
        events = {
            playerLoaded = 'vorp:SelectedCharacter',
            playerUnload = 'vorp:PlayerForceRespawn',
        },
        useExports = true,
    },

    -- Standalone Settings (Basic)
    Standalone = {
        enabled = true,
        commandsOnly = true,
    }
}

Config.Lang = 'en' -- 'en', 'ru', 'de', 'fr', 'es'

Config.General = {
    -- Enable/Disable Features
    useItems = true,              -- Allow scope attachment via inventory items
    useCommands = true,           -- Allow scope attachment via commands
    closeInventory = true,        -- Auto-close inventory after scope item use
    playAnimation = true,         -- Play animation when attaching/removing scope
    
    -- Admin Settings
    adminCommand = true,          -- Enable admin commands for scope management
    adminGroup = 'admin',         -- Permission group for admin commands
    
    -- Tool Requirements
    requireAttachTool = true,     -- Require special tool to attach scopes
    removeToolAfterUse = false,   -- Consume tool item when attaching scope
    requireToolForRemoval = true, -- Require tool to remove scopes
}

Config.Commands = {
    -- Player Commands (Standalone mode)
    addScope = "addscope",
    removeScope = "removescope",
    
    -- Admin Commands (All modes)
    adminAddScope = "adminscopeadd",
    adminRemoveScope = "adminscoperemove",
}

Config.Animation = {
    enabled = true,
    dict = "mech_inspection@weapons@longarms@rifle_bolt_action@base",
    name = "aim_enter",
    duration = 1500, -- milliseconds
    flag = 0,
}

Config.Items = {
    -- Tool required for attaching/removing scopes
    attachTool = "screwdriver",
    
    -- Scope items (maps weapon to scope item name)
    scopes = {
        -- Repeaters
        WEAPON_REPEATER_WINCHESTER_SHORT = "scopeshortwinchester",
        WEAPON_REPEATER_HENRY_SHORT = "scopeshorthenry",
        WEAPON_REPEATER_EVANS_SHORT = "scopeshortevans",
        WEAPON_REPEATER_CARBINE_SHORT = "scopeshortcarbine",
        
        -- Varmint Rifle
        WEAPON_RIFLE_VARMINT_SHORT = "scopeshortvarmint",
        WEAPON_RIFLE_VARMINT_MEDIUM = "scopemediumvarmint",
        
        -- Bolt Action Rifle
        WEAPON_RIFLE_BOLTACTION_SHORT = "scopeshortboltaction",
        WEAPON_RIFLE_BOLTACTION_MEDIUM = "scopemediumboltaction",
        
        -- Springfield Rifle
        WEAPON_RIFLE_SPRINGFIELD_SHORT = "scopeshortspringfield",
        WEAPON_RIFLE_SPRINGFIELD_MEDIUM = "scopemediumspringfield",
        
        -- Rolling Block Rifle
        WEAPON_SNIPERRIFLE_ROLLINGBLOCK_SHORT = "scopeshortrollingblock",
        WEAPON_SNIPERRIFLE_ROLLINGBLOCK_MEDIUM = "scopemediumrollingblock",
        WEAPON_SNIPERRIFLE_ROLLINGBLOCK_LONG = "scopelongrollingblock",
        
        -- Carcano Rifle
        WEAPON_SNIPERRIFLE_CARCANO_SHORT = "scopeshortcarcano",
        WEAPON_SNIPERRIFLE_CARCANO_MEDIUM = "scopemediumcarcano",
        WEAPON_SNIPERRIFLE_CARCANO_LONG = "scopelongcarcano",
    }
}

--[[
    Weapon component hashes for scope attachments
    Format: [WeaponHash] = { componentHash, scopeType }
--]]

Config.WeaponComponents = {
    -- Repeaters (Short Scope: -404520310)
    [`WEAPON_REPEATER_WINCHESTER`] = { component = -404520310, type = "short" },
    [`WEAPON_REPEATER_HENRY`] = { component = -404520310, type = "short" },
    [`WEAPON_REPEATER_EVANS`] = { component = -404520310, type = "short" },
    [`WEAPON_REPEATER_CARBINE`] = { component = -404520310, type = "short" },
    
    -- Varmint Rifle (Medium Scope: -1844750633)
    [`WEAPON_RIFLE_VARMINT`] = { component = -1844750633, type = "medium" },
    
    -- Bolt Action Rifle (Short Scope: -404520310)
    [`WEAPON_RIFLE_BOLTACTION`] = { component = -404520310, type = "short" },
    
    -- Springfield Rifle (Short Scope: -404520310)
    [`WEAPON_RIFLE_SPRINGFIELD`] = { component = -404520310, type = "short" },
    
    -- Rolling Block Rifle (Medium Scope: -1844750633)
    [`WEAPON_SNIPERRIFLE_ROLLINGBLOCK`] = { component = -1844750633, type = "medium" },
    
    -- Carcano Rifle (Long Scope: -1545766277)
    [`WEAPON_SNIPERRIFLE_CARCANO`] = { component = -1545766277, type = "long" },
}

Config.Notifications = {
    enabled = true,
    duration = 4000, -- milliseconds
    
    -- Notification Messages
    messages = {
        noWeapon = "You need to have a weapon equipped",
        noTool = "You need a %s to attach scopes",
        noSpace = "You don't have enough inventory space",
        scopeAttached = "Scope successfully attached",
        scopeRemoved = "Scope successfully removed",
        noScopeAttached = "No scope attached to this weapon",
        invalidWeapon = "This weapon cannot use scopes",
        alreadyHasScope = "This weapon already has a scope",
        adminOnly = "You don't have permission to use this command",
    },
    
    -- Notification Types
    types = {
        success = "success",
        error = "error",
        info = "info",
        warning = "warning",
    }
}

Config.Security = {
    -- Anti-Abuse Settings
    enableCooldowns = true,
    cooldownTime = 2000, -- milliseconds between scope operations
    
    -- Validation
    validateDistance = true,  -- Validate player hasn't teleported during operation
    maxDistance = 10.0,       -- Maximum distance player can move during operation
    
    -- Logging
    enableLogging = true,
    logSuspicious = true,
    logAdminActions = true,
}

Config.Performance = {
    -- Cache Settings
    enableCache = true,
    cacheTimeout = 300000, -- 5 minutes in milliseconds
    
    -- Update Intervals
    weaponCheckInterval = 100, -- milliseconds
    
    -- Optimization
    useNativeOptimizations = true,
}

Config.Debug = false -- Set to true for development debugging (NEVER in production!)

Config.DebugSettings = {
    printFrameworkDetection = true,
    printItemUsage = true,
    printComponentChanges = true,
    printValidation = true,
}