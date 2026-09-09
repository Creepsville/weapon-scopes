# Security Guide

Comprehensive security features and best practices for the Weapon Scope System.

---

## Security Architecture

### Multi-Layer Security Model

```
┌──────────────────────────────────────────────────────────┐
│ Layer 5: Audit & Logging                                 │
│ - Operation logging                                      │
│ - Suspicious activity detection                          │
│ - Admin action tracking                                  │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│ Layer 4: Rate Limiting & Anti-Abuse                      │
│ - Cooldown enforcement                                   │
│ - Spam prevention                                        │
│ - Request throttling                                     │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│ Layer 3: Business Logic Validation                       │
│ - Weapon support verification                            │
│ - Component compatibility                                │
│ - State consistency checks                               │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│ Layer 2: Resource Validation                             │
│ - Item ownership verification                            │
│ - Tool requirement enforcement                           │
│ - Inventory space checks                                 │
└──────────────────────────────────────────────────────────┘
┌──────────────────────────────────────────────────────────┐
│ Layer 1: Input Validation                                │
│ - Player source validation                               │
│ - Parameter sanitization                                 │
│ - Request format verification                            │
└──────────────────────────────────────────────────────────┘
```

---

## Core Security Features

### 1. Server-Side Validation

**All critical operations are validated server-side.**

```lua
-- Example: Server-side scope attachment validation
RegisterNetEvent('weapon-scopes:server:attachScopeItem', function(scopeItem)
    local source = source
    
    -- Validation Layer 1: Player exists
    if not source or source < 1 then
        LogSuspiciousActivity("Invalid player source", source)
        return
    end
    
    -- Validation Layer 2: Item ownership
    if not Framework.HasItem(source, scopeItem, 1) then
        LogSuspiciousActivity("Item not owned", source, scopeItem)
        Framework.Notify(source, "You don't have this item", "error")
        return
    end
    
    -- Validation Layer 3: Cooldown check
    if not CheckCooldown(source) then
        Framework.Notify(source, "Please wait before using again", "warning")
        return
    end
    
    -- Validation Layer 4: Weapon support
    local weaponHash = GetWeaponFromScopeItem(scopeItem)
    if not IsWeaponSupported(weaponHash) then
        LogSuspiciousActivity("Unsupported weapon", source, weaponHash)
        return
    end
    
    -- All validation passed, proceed with operation
    ProcessScopeAttachment(source, scopeItem)
end)
```

### 2. Cooldown System

**Prevents spam and abuse through rate limiting.**

```lua
Config.Security = {
    enableCooldowns = true,
    cooldownTime = 2000, -- 2 seconds between operations
}
```

**Implementation:**
```lua
local playerCooldowns = {}

function CheckCooldown(source)
    local currentTime = GetGameTimer()
    local lastUse = playerCooldowns[source] or 0
    
    if (currentTime - lastUse) < Config.Security.cooldownTime then
        return false
    end
    
    playerCooldowns[source] = currentTime
    return true
end

function GetRemainingCooldown(source)
    local currentTime = GetGameTimer()
    local lastUse = playerCooldowns[source] or 0
    local remaining = Config.Security.cooldownTime - (currentTime - lastUse)
    
    return math.max(0, remaining)
end
```

### 3. Distance Validation

**Prevents teleportation exploits during operations.**

```lua
Config.Security = {
    validateDistance = true,
    maxDistance = 10.0, -- Maximum movement allowed
}
```

**Implementation:**
```lua
function ValidatePlayerPosition(source, startCoords)
    local ped = GetPlayerPed(source)
    local currentCoords = GetEntityCoords(ped)
    local distance = #(startCoords - currentCoords)
    
    if distance > Config.Security.maxDistance then
        LogSuspiciousActivity("Teleport detected", source, distance)
        return false
    end
    
    return true
end

-- Usage during scope attachment
local startCoords = GetEntityCoords(GetPlayerPed(source))
-- ... perform operation
Wait(100)
if not ValidatePlayerPosition(source, startCoords) then
    return -- Abort operation
end
```

### 4. Item Verification

**Confirms item existence before removal.**

```lua
function SafeRemoveItem(source, item, amount)
    -- Double-check item exists
    if not Framework.HasItem(source, item, amount) then
        LogSuspiciousActivity("Item vanished", source, item)
        return false
    end
    
    -- Attempt removal
    local success = Framework.RemoveItem(source, item, amount)
    
    if not success then
        LogSuspiciousActivity("Item removal failed", source, item)
        return false
    end
    
    return true
end
```

### 5. Component State Validation

**Verifies weapon component state before modifications.**

```lua
function ValidateComponentState(source, weaponHash, operation)
    local ped = GetPlayerPed(source)
    local componentHash = Config.WeaponComponents[weaponHash].component
    local hasComponent = HasPedGotWeaponComponent(ped, weaponHash, componentHash)
    
    if operation == 'attach' and hasComponent then
        LogSuspiciousActivity("Component already attached", source, weaponHash)
        return false
    end
    
    if operation == 'remove' and not hasComponent then
        LogSuspiciousActivity("Component not attached", source, weaponHash)
        return false
    end
    
    return true
end
```

---

## 📊 Security Logging

### Log Categories

| Category | Purpose | Log Level |
|----------|---------|-----------|
| **Operational** | Normal operations | INFO |
| **Suspicious** | Unusual activity | WARNING |
| **Security** | Security violations | ERROR |
| **Admin** | Admin actions | INFO |
| **Debug** | Development debugging | DEBUG |

### Logging Implementation

```lua
Config.Security = {
    enableLogging = true,
    logSuspicious = true,
    logAdminActions = true,
}

function Log(category, message, data)
    if not Config.Security.enableLogging then
        return
    end
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logMessage = string.format("[%s] [%s] %s", timestamp, category, message)
    
    if data then
        logMessage = logMessage .. " | Data: " .. json.encode(data)
    end
    
    print(logMessage)
    
    -- Optional: Write to file or external logging system
    if Config.Advanced.externalLogging then
        SendToExternalLogger(category, message, data)
    end
end

function LogSuspiciousActivity(reason, source, ...)
    if not Config.Security.logSuspicious then
        return
    end
    
    local playerIdentifier = GetPlayerIdentifier(source, 0)
    local args = {...}
    
    Log("SUSPICIOUS", reason, {
        player = source,
        identifier = playerIdentifier,
        details = args
    })
    
    -- Optional: Alert admins
    if Config.Security.alertAdmins then
        TriggerEvent('admin:notify', string.format(
            "Suspicious activity: %s by %s (%s)",
            reason, GetPlayerName(source), source
        ))
    end
end

function LogAdminAction(action, admin, target)
    if not Config.Security.logAdminActions then
        return
    end
    
    Log("ADMIN", action, {
        admin = admin,
        adminIdentifier = GetPlayerIdentifier(admin, 0),
        target = target,
        targetIdentifier = GetPlayerIdentifier(target, 0)
    })
end
```

### Log Examples

```lua
-- Operational log
Log("INFO", "Scope attached successfully", {
    player = source,
    weapon = weaponHash,
    scope = scopeType
})

-- Suspicious activity log
LogSuspiciousActivity("Rapid scope attachment attempts", source, {
    attempts = 5,
    timeWindow = 1000
})

-- Admin action log
LogAdminAction("Force scope attachment", adminSource, targetSource)

-- Security violation log
Log("ERROR", "Item duplication attempt detected", {
    player = source,
    item = scopeItem,
    inventory_count = actualCount,
    claimed_count = claimedCount
})
```

---

## 🚨 Threat Mitigation

### Common Exploits & Protections

#### 1. Item Duplication

**Threat:** Players attempting to duplicate scope items.

**Protection:**
```lua
-- Server-side item removal with verification
function SecureItemRemoval(source, item, amount)
    -- Verify item exists BEFORE any client triggers
    local hasItem = Framework.HasItem(source, item, amount)
    if not hasItem then
        LogSuspiciousActivity("Item duplication attempt", source, item)
        return false
    end
    
    -- Remove item immediately
    local removed = Framework.RemoveItem(source, item, amount)
    
    -- Verify removal succeeded
    if not removed then
        LogSuspiciousActivity("Item removal failed", source, item)
        return false
    end
    
    -- Double-check item was actually removed
    Wait(100)
    local stillHasItem = Framework.HasItem(source, item, amount)
    if stillHasItem then
        LogSuspiciousActivity("Item still present after removal", source, item)
        return false
    end
    
    return true
end
```

#### 2. Rapid Spam/Abuse

**Threat:** Players spamming scope attachment commands.

**Protection:**
```lua
-- Enhanced cooldown with progressive penalties
local playerViolations = {}

function EnhancedCooldownCheck(source)
    local currentTime = GetGameTimer()
    local lastUse = playerCooldowns[source] or 0
    local timeSinceLastUse = currentTime - lastUse
    
    if timeSinceLastUse < Config.Security.cooldownTime then
        -- Track violations
        playerViolations[source] = (playerViolations[source] or 0) + 1
        
        if playerViolations[source] >= 5 then
            LogSuspiciousActivity("Excessive cooldown violations", source, {
                violations = playerViolations[source]
            })
            
            -- Optional: Temporary ban
            if Config.Security.autoBan then
                BanPlayer(source, "Scope system abuse", 3600) -- 1 hour
            end
        end
        
        return false
    end
    
    -- Reset violations on successful use
    playerViolations[source] = 0
    playerCooldowns[source] = currentTime
    return true
end
```

#### 3. Unauthorized Scope Attachment

**Threat:** Players triggering scope attachment without proper items.

**Protection:**
```lua
-- Token-based authorization
local operationTokens = {}

function GenerateOperationToken(source)
    local token = math.random(100000, 999999)
    operationTokens[source] = {
        token = token,
        expires = GetGameTimer() + 5000 -- 5 second validity
    }
    return token
end

function ValidateOperationToken(source, token)
    local storedToken = operationTokens[source]
    
    if not storedToken then
        LogSuspiciousActivity("No operation token", source)
        return false
    end
    
    if storedToken.token ~= token then
        LogSuspiciousActivity("Invalid operation token", source)
        return false
    end
    
    if GetGameTimer() > storedToken.expires then
        LogSuspiciousActivity("Expired operation token", source)
        operationTokens[source] = nil
        return false
    end
    
    -- Token is valid, consume it
    operationTokens[source] = nil
    return true
end

-- Usage
RegisterNetEvent('weapon-scopes:server:requestAttachment', function()
    local source = source
    
    -- Generate and send token to client
    local token = GenerateOperationToken(source)
    TriggerClientEvent('weapon-scopes:client:receiveToken', source, token)
end)

RegisterNetEvent('weapon-scopes:server:confirmAttachment', function(token, scopeItem)
    local source = source
    
    -- Validate token
    if not ValidateOperationToken(source, token) then
        return
    end
    
    -- Proceed with attachment
    ProcessScopeAttachment(source, scopeItem)
end)
```

#### 4. Teleportation Exploits

**Threat:** Players teleporting during scope attachment animation.

**Protection:**
```lua
function SecureOperationWithPositionCheck(source, callback)
    local ped = GetPlayerPed(source)
    local startCoords = GetEntityCoords(ped)
    local startTime = GetGameTimer()
    
    -- Execute operation
    local result = callback()
    
    -- Verify position after operation
    local endTime = GetGameTimer()
    local endCoords = GetEntityCoords(ped)
    local distance = #(startCoords - endCoords)
    
    if distance > Config.Security.maxDistance then
        LogSuspiciousActivity("Position change during operation", source, {
            distance = distance,
            duration = endTime - startTime
        })
        
        -- Rollback operation if possible
        return false, "Position validation failed"
    end
    
    return true, result
end

-- Usage
local success, result = SecureOperationWithPositionCheck(source, function()
    return AttachScopeComponent(source, weaponHash)
end)
```

#### 5. Component Hash Manipulation

**Threat:** Players attempting to use invalid component hashes.

**Protection:**
```lua
-- Whitelist valid component hashes
local VALID_COMPONENT_HASHES = {
    [-404520310] = true,  -- Short scope
    [-1844750633] = true, -- Medium scope
    [-1545766277] = true, -- Long scope
}

function ValidateComponentHash(componentHash)
    if not VALID_COMPONENT_HASHES[componentHash] then
        return false
    end
    return true
end

-- Server-side enforcement
RegisterNetEvent('weapon-scopes:server:attachComponent', function(weaponHash, componentHash)
    local source = source
    
    -- Validate component hash
    if not ValidateComponentHash(componentHash) then
        LogSuspiciousActivity("Invalid component hash", source, componentHash)
        BanPlayer(source, "Attempted exploit", 86400) -- 24 hour ban
        return
    end
    
    -- Verify component matches weapon
    local expectedComponent = Config.WeaponComponents[weaponHash].component
    if componentHash ~= expectedComponent then
        LogSuspiciousActivity("Component hash mismatch", source, {
            expected = expectedComponent,
            received = componentHash
        })
        return
    end
    
    -- Proceed with attachment
end)
```

---

## 🔧 Security Configuration

### Security Levels

#### Maximum Security (Hardcore RP Servers)

```lua
Config.Security = {
    enableCooldowns = true,
    cooldownTime = 5000,        -- 5 second cooldown
    validateDistance = true,
    maxDistance = 5.0,          -- Strict movement check
    enableLogging = true,
    logSuspicious = true,
    logAdminActions = true,
    alertAdmins = true,         -- Real-time admin alerts
    autoBan = true,             -- Auto-ban on repeated violations
    requireDoubleValidation = true, -- Extra validation steps
}
```

#### Balanced Security (Standard RP Servers)

```lua
Config.Security = {
    enableCooldowns = true,
    cooldownTime = 2000,        -- 2 second cooldown
    validateDistance = true,
    maxDistance = 10.0,         -- Standard movement check
    enableLogging = true,
    logSuspicious = true,
    logAdminActions = true,
    alertAdmins = false,
    autoBan = false,
    requireDoubleValidation = false,
}
```

#### Minimal Security (Testing/Development)

```lua
Config.Security = {
    enableCooldowns = true,
    cooldownTime = 500,         -- 0.5 second cooldown
    validateDistance = false,   -- No position checking
    maxDistance = 100.0,
    enableLogging = false,
    logSuspicious = false,
    logAdminActions = true,
    alertAdmins = false,
    autoBan = false,
    requireDoubleValidation = false,
}
```

---

## Admin Monitoring

### Real-Time Activity Monitoring

```lua
-- Admin monitoring command
RegisterCommand('scopemonitor', function(source, args, rawCommand)
    if not IsPlayerAdmin(source) then
        return
    end
    
    -- Show recent scope operations
    local recentOps = GetRecentOperations(50)
    
    TriggerClientEvent('admin:showScopeMonitor', source, recentOps)
end, false)

-- Track all operations
function TrackOperation(source, operation, data)
    table.insert(operationHistory, {
        timestamp = os.time(),
        player = source,
        identifier = GetPlayerIdentifier(source, 0),
        operation = operation,
        data = data
    })
    
    -- Keep only last 1000 operations
    if #operationHistory > 1000 then
        table.remove(operationHistory, 1)
    end
end
```

### Suspicious Activity Alerts

```lua
-- Real-time alerts to online admins
function AlertAdmins(message, severity)
    local onlineAdmins = GetOnlineAdmins()
    
    for _, admin in ipairs(onlineAdmins) do
        TriggerClientEvent('admin:notification', admin, {
            title = "Security Alert",
            message = message,
            severity = severity,
            timestamp = os.time()
        })
    end
end

-- Usage
function LogSuspiciousActivity(reason, source, data)
    -- ... logging logic ...
    
    if Config.Security.alertAdmins then
        AlertAdmins(string.format(
            "Player %s (%s): %s",
            GetPlayerName(source), source, reason
        ), "warning")
    end
end
```

---

## Security Best Practices

### For Server Administrators

1. ✅ **Enable All Security Features**
   - Keep cooldowns enabled
   - Enable all logging
   - Use distance validation

2. ✅ **Regular Monitoring**
   - Review logs weekly
   - Check for patterns of suspicious activity
   - Monitor admin action logs

3. ✅ **Proper Permissions**
   - Restrict admin commands to trusted staff
   - Use framework permission systems
   - Regular permission audits

4. ✅ **Keep Updated**
   - Update to latest version
   - Review security patches
   - Monitor for new exploits

5. ✅ **Backup Configuration**
   - Regular config backups
   - Document custom settings
   - Test changes on development server

### For Developers

1. ✅ **Server-Side Validation**
   - Never trust client input
   - Validate all parameters
   - Double-check all operations

2. ✅ **Secure Exports**
   - Validate source in exported functions
   - Check permissions for admin exports
   - Log all export usage

3. ✅ **Error Handling**
   - Catch and log all errors
   - Never expose internal errors to clients
   - Fail securely

4. ✅ **Code Review**
   - Review security-critical code
   - Test exploit scenarios
   - Regular security audits

---

## What NOT To Do

### Security Anti-Patterns

❌ **Don't disable cooldowns in production**
```lua
-- BAD
Config.Security.enableCooldowns = false
```

❌ **Don't trust client-side validation alone**
```lua
-- BAD - Client only validation
if HasItem(item) then
    AttachScope() -- No server check
end
```

❌ **Don't expose sensitive functions**
```lua
-- BAD - Unsecured export
exports('RemoveAnyScopeFromAnyPlayer', function(source, target)
    -- No permission check!
    RemoveScope(target)
end)
```

❌ **Don't log sensitive data**
```lua
-- BAD - Logging player identifiers publicly
print("Player " .. identifier .. " used scope")
```

❌ **Don't use predictable tokens**
```lua
-- BAD
local token = source .. "_" .. os.time() -- Predictable
```

---

## Security Checklist

Use this checklist to verify your security configuration:

### Installation Security
- [ ] Resource name is correct (`weapon-scopes`)
- [ ] File permissions are appropriate (755 for directories, 644 for files)
- [ ] No unauthorized modifications to core files
- [ ] Debug mode is disabled in production

### Configuration Security
- [ ] Cooldowns enabled (`enableCooldowns = true`)
- [ ] Appropriate cooldown time (minimum 1000ms)
- [ ] Distance validation enabled for RP servers
- [ ] Logging enabled and configured
- [ ] Suspicious activity logging enabled
- [ ] Admin action logging enabled

### Operational Security
- [ ] Regular log review process established
- [ ] Admin permissions properly configured
- [ ] Framework integration secure
- [ ] Item verification working correctly
- [ ] No unauthorized scope attachments possible

### Monitoring
- [ ] Active monitoring of suspicious activity
- [ ] Admin alerts configured (if desired)
- [ ] Regular audit of operation logs
- [ ] Incident response plan in place

---
