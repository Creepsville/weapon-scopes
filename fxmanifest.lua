fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

-- Resource Information
name 'weapon-scopes'
author 'Pulled from another and fixed (Original: Zeus Script)'
description 'Advanced weapon scope system with multi-framework support'
version '2.0.0'

-- Lua Version
lua54 'yes'

-- Shared Configuration
shared_scripts {
    'config.lua',
    'shared/framework.lua'
}

-- Client Scripts (Scope: Weapon component management, animations, UI notifications)
client_scripts {
    'client/main.lua'
}

-- Server Scripts (Scope: Item management, validation, anti-cheat, framework integration)
server_scripts {
    'server/main.lua'
}

-- Dependencies (Optional - Runtime detection used)
-- dependencies {
--     '/rsg-core', -- For RSG-Core
--     '/vorp_core' -- For VORP
-- }

-- Files
files {
    'README.md',
    'docs/**/*'
}