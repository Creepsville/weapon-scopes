
# ⚙️ Configuration Reference

Complete reference guide for all configuration options in `config.lua`.

---

## 📁 Configuration Structure

```lua
config.lua
├── Server Information      # Branding and server details
├── Framework Settings      # Framework detection and configuration
├── Language Settings       # Localization options
├── General Settings        # Core feature toggles
├── Command Settings        # Command name configuration
├── Animation Settings      # Animation parameters
├── Item Settings           # Scope and tool item names
├── Weapon Components       # Weapon-to-scope mappings
├── Notification Settings   # Message and notification configuration
├── Security Settings       # Anti-cheat and validation
├── Performance Settings    # Optimization options
└── Debug Settings          # Development debugging
```

---

## 🏢 Server Information

Branding and metadata for your server.

```lua

### Options

| Option | Type | Description |
|--------|------|-------------|
| `name` | String | Server display name |
| `tagline` | String | Server tagline/motto |
| `description` | String | Server description |
| `type` | String | Server type/category |
| `access` | String | Access requirements |
| `website` | String | Server website URL |
| `discord` | String | Discord invite link |
| `github` | String | GitHub profile/repository |
| `store` | String | Tebex/store URL |
| `serverListing` | String | Server listing URL |
| `developer` | String | Developer name/credits |
| `tags` | Table | Server category tags |

---

## 🔧 Framework Settings

### Framework Detection

```lua
Config.Framework = 'vorp' -- 'auto', 'lxr', 'rsg', 'vorp', 'standalone'
```

| Value | Description | Use Case |
|-------|-------------|----------|
| `'auto'` | Automatic detection | **Recommended** - Auto-detects framework |
| `'rsg'` | Force RSG-Core | RSG-Core servers only |
| `'vorp'` | Force VORP Core | VORP Core servers only |
| `'standalone'` | Force Standalone | Non-framework servers |


### RSG-Core Settings

```lua
Config.FrameworkSettings.RSG = {
    enabled = true,
    resourceName = 'rsg-core',
    exportName = 'rsg-core',
    events = {
        playerLoaded = 'RSGCore:Client:OnPlayerLoaded',
        playerUnload = 'RSGCore:Client:OnPlayerUnload',
        notify = 'RSGCore:Client:Notify',
    },
    useExports = true,
}
```

### VORP Settings

```lua
Config.FrameworkSettings.VORP = {
    enabled = true,
    resourceName = 'vorp_core',
    inventoryResource = 'vorp_inventory',            -- VORP inventory resource
    exportName = 'vorp_core',
    events = {
        playerLoaded = 'vorp:SelectedCharacter',
        playerUnload = 'vorp:PlayerForceRespawn',
    },
    useExports = true,
}
```

### Standalone Settings

```lua
Config.FrameworkSettings.Standalone = {
    enabled = true,
    commandsOnly = true,                             -- Only commands available
}
```

---

## 🌍 Language Settings

```lua
Config.Lang = 'en' -- 'en', 'ge' (Georgian), 'ru', 'de', 'fr', 'es'
```

### Supported Languages

| Code | Language | Status |
|------|----------|--------|
| `'en'` | English | ✅ Complete |
| `'ge'` | Georgian (ქართული) | ✅ Complete |
| `'ru'` | Russian | 🚧 Planned |
| `'de'` | German | 🚧 Planned |
| `'fr'` | French | 🚧 Planned |
| `'es'` | Spanish | 🚧 Planned |

---

##  General Settings

Core feature configuration.

```lua
Config.General = {
    -- Feature Toggles
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
```

### Options Explained

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `useItems` | Boolean | `true` | Enables item-based scope attachment (requires framework) |
| `useCommands` | Boolean | `true` | Enables command-based scope attachment |
| `closeInventory` | Boolean | `true` | Closes inventory UI after using scope item |
| `playAnimation` | Boolean | `true` | Plays character animation during attachment |
| `adminCommand` | Boolean | `true` | Enables admin override commands |
| `adminGroup` | String | `'admin'` | Permission group for admin commands |
| `requireAttachTool` | Boolean | `true` | Requires screwdriver to attach scopes |
| `removeToolAfterUse` | Boolean | `false` | Consumes screwdriver when attaching (not recommended) |
| `requireToolForRemoval` | Boolean | `true` | Requires screwdriver to remove scopes |

### Configuration Examples

#### Hardcore Realism Mode
```lua
Config.General = {
    useItems = true,
    useCommands = false,           -- No commands, items only
    closeInventory = true,
    playAnimation = true,
    adminCommand = true,
    adminGroup = 'admin',
    requireAttachTool = true,
    removeToolAfterUse = true,     -- Tools are consumed
    requireToolForRemoval = true,
}
```

#### Casual/Easy Mode
```lua
Config.General = {
    useItems = true,
    useCommands = true,
    closeInventory = true,
    playAnimation = false,         -- Instant attachment
    adminCommand = true,
    adminGroup = 'admin',
    requireAttachTool = false,     -- No tool needed
    removeToolAfterUse = false,
    requireToolForRemoval = false, -- No tool for removal
}
```

#### Standalone Server Mode
```lua
Config.General = {
    useItems = false,              -- No inventory system
    useCommands = true,            -- Commands only
    closeInventory = false,
    playAnimation = true,
    adminCommand = true,
    adminGroup = 'admin',
    requireAttachTool = false,     -- No items available
    removeToolAfterUse = false,
    requireToolForRemoval = false,
}
```

---

## 💬 Command Settings

Customize command names.

```lua
Config.Commands = {
    -- Player Commands (Standalone mode)
    addScope = "addscope",
    removeScope = "removescope",
    
    -- Admin Commands (All modes)
    adminAddScope = "adminscopeadd",
    adminRemoveScope = "adminscoperemove",
}
```

### Changing Commands

```lua
-- Example: Change to shorter command names
Config.Commands = {
    addScope = "scope",           -- /scope instead of /addscope
    removeScope = "unscope",      -- /unscope instead of /removescope
    adminAddScope = "ascope",     -- /ascope instead of /adminscopeadd
    adminRemoveScope = "rscope",  -- /rscope instead of /adminscoperemove
}
```

⚠️ **Warning:** Ensure no conflicts with existing commands from other resources!

---

## 🎭 Animation Settings

Configure attachment animations.

```lua
Config.Animation = {
    enabled = true,
    dict = "mech_inspection@weapons@longarms@rifle_bolt_action@base",
    name = "aim_enter",
    duration = 1500, -- milliseconds
    flag = 0,
}
```

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enabled` | Boolean | `true` | Enable/disable animations |
| `dict` | String | See above | Animation dictionary |
| `name` | String | `"aim_enter"` | Animation name |
| `duration` | Integer | `1500` | Animation duration in ms |
| `flag` | Integer | `0` | Animation flags |

### Animation Alternatives

```lua
-- Fast attachment (500ms)
Config.Animation.duration = 500

-- Slow, realistic attachment (3000ms)
Config.Animation.duration = 3000

-- Different animation (crafting style)
Config.Animation = {
    enabled = true,
    dict = "script_re@dealer@table@meat",
    name = "action",
    duration = 2000,
    flag = 0,
}

-- Disable animations
Config.Animation.enabled = false
```

---

## 🔫 Item Settings

Define scope and tool item names.

```lua
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
```

### Customizing Item Names

**Important:** Item names must **exactly match** your framework's item database!

```lua
-- Example: Custom item naming scheme
Config.Items = {
    attachTool = "tool_screwdriver",  -- Match your database
    
    scopes = {
        WEAPON_REPEATER_WINCHESTER_SHORT = "weapon_scope_short_winchester",
        WEAPON_REPEATER_HENRY_SHORT = "weapon_scope_short_henry",
        -- etc...
    }
}
```

### Adding New Scope Items

```lua
-- Add a new scope for a custom weapon
Config.Items.scopes.WEAPON_RIFLE_CUSTOM = "scopecustomrifle"

-- Then add corresponding weapon component (see next section)
```

---

## 🎯 Weapon Components

Maps weapons to their scope component hashes.

```lua
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
```

### Component Hash Reference

| Scope Type | Component Hash | Visual Description |
|------------|----------------|-------------------|
| **Short** | `-404520310` | Small magnification, short tube |
| **Medium** | `-1844750633` | Medium magnification, standard length |
| **Long** | `-1545766277` | High magnification, long tube |

### Adding Custom Weapons

```lua
-- Add a custom weapon with scope support
Config.WeaponComponents[`WEAPON_RIFLE_CUSTOM`] = { 
    component = -404520310,  -- Use appropriate scope hash
    type = "short"            -- Scope type identifier
}

-- Don't forget to add corresponding item!
Config.Items.scopes.WEAPON_RIFLE_CUSTOM_SHORT = "scopecustomrifle"
```

---

## 🔔 Notification Settings

Configure notification messages and behavior.

```lua
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
```

### Customizing Messages

```lua
-- Example: Change message tone
Config.Notifications.messages = {
    noWeapon = "Hold a weapon first, partner!",
    noTool = "You'll need a %s for that job",
    scopeAttached = "Your weapon's ready for long shots!",
    scopeRemoved = "Scope removed and returned to saddlebag",
    -- etc...
}
```

### Notification Duration

```lua
-- Quick notifications (2 seconds)
Config.Notifications.duration = 2000

-- Long notifications (7 seconds)
Config.Notifications.duration = 7000

-- Disable notifications
Config.Notifications.enabled = false
```

---

## 🔒 Security Settings

Anti-abuse and validation configuration.

```lua
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
```

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enableCooldowns` | Boolean | `true` | Prevent spam with cooldown timer |
| `cooldownTime` | Integer | `2000` | Cooldown duration in milliseconds |
| `validateDistance` | Boolean | `true` | Check player position consistency |
| `maxDistance` | Float | `10.0` | Max movement during operation |
| `enableLogging` | Boolean | `true` | Enable server console logging |
| `logSuspicious` | Boolean | `true` | Log suspicious activity |
| `logAdminActions` | Boolean | `true` | Log admin command usage |

### Security Presets

#### Maximum Security (Hardcore RP)
```lua
Config.Security = {
    enableCooldowns = true,
    cooldownTime = 5000,          -- 5 second cooldown
    validateDistance = true,
    maxDistance = 5.0,            -- Strict movement check
    enableLogging = true,
    logSuspicious = true,
    logAdminActions = true,
}
```

#### Relaxed Security (Casual)
```lua
Config.Security = {
    enableCooldowns = true,
    cooldownTime = 1000,          -- 1 second cooldown
    validateDistance = false,     -- No distance checking
    maxDistance = 50.0,
    enableLogging = false,        -- Minimal logging
    logSuspicious = false,
    logAdminActions = true,
}
```

---

## ⚡ Performance Settings

Optimization configuration.

```lua
Config.Performance = {
    -- Cache Settings
    enableCache = true,
    cacheTimeout = 300000, -- 5 minutes in milliseconds
    
    -- Update Intervals
    weaponCheckInterval = 100, -- milliseconds
    
    -- Optimization
    useNativeOptimizations = true,
}
```

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enableCache` | Boolean | `true` | Enable function caching |
| `cacheTimeout` | Integer | `300000` | Cache expiration time (5 min) |
| `weaponCheckInterval` | Integer | `100` | Weapon check frequency |
| `useNativeOptimizations` | Boolean | `true` | Use optimized native calls |

⚠️ **Recommendation:** Keep default values unless experiencing performance issues.

---

## Debug Settings

Development and troubleshooting options.

```lua
Config.Debug = false -- Set to true for development debugging (NEVER in production!)

Config.DebugSettings = {
    printFrameworkDetection = true,
    printItemUsage = true,
    printComponentChanges = true,
    printValidation = true,
}
```

### Debug Options

| Option | Type | Description |
|--------|------|-------------|
| `Config.Debug` | Boolean | Master debug toggle |
| `printFrameworkDetection` | Boolean | Log framework detection |
| `printItemUsage` | Boolean | Log item usage events |
| `printComponentChanges` | Boolean | Log component modifications |
| `printValidation` | Boolean | Log validation checks |

### Enabling Debug Mode

```lua
-- For development/testing only
Config.Debug = true

-- Selective debugging
Config.DebugSettings = {
    printFrameworkDetection = true,  -- Check framework detection
    printItemUsage = false,          -- Ignore item logs
    printComponentChanges = true,    -- Monitor component changes
    printValidation = false,         -- Ignore validation logs
}
```

⚠️ **WARNING:** Never enable debug mode in production! It creates excessive console output.

---

## 📋 Complete Configuration Template

```lua
-- Minimal configuration for quick setup
Config = {}

-- Framework (auto-detect recommended)
Config.Framework = 'auto'

-- General features
Config.General = {
    useItems = true,
    useCommands = true,
    playAnimation = true,
    requireAttachTool = true,
    requireToolForRemoval = true,
}

-- Security (keep defaults)
Config.Security = {
    enableCooldowns = true,
    cooldownTime = 2000,
    validateDistance = true,
    maxDistance = 10.0,
}

-- Customize as needed...
```

---

## 🔧 Configuration Best Practices

### 1. Framework Detection
- ✅ Use `'auto'` for automatic detection
- ✅ Only force framework if auto-detection fails
- ✅ Verify framework resource names match your setup

### 2. Item Configuration
- ✅ Match item names exactly with your database
- ✅ Test items exist before enabling `useItems`
- ✅ Use consistent naming conventions

### 3. Security
- ✅ Keep cooldowns enabled for production
- ✅ Enable logging for audit trails
- ✅ Adjust distance validation for your server style

### 4. Performance
- ✅ Keep default performance settings
- ✅ Only modify if experiencing issues
- ✅ Monitor with `resmon` after changes

### 5. Testing
- ✅ Test configuration changes on dev server first
- ✅ Use debug mode during testing
- ✅ Disable debug before production deployment

---

