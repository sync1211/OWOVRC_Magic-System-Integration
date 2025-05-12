---@diagnostic disable: undefined-global, lowercase-global
--NOTE: Put this into the receiver for GestureLeft

-- Avatar state
local spellIndexCounter = self.parent.children["SpellIndexLeft"]
local elementIndexCounter = self.parent.children["ElementIndexLeft"]
local afkIndicator = self.parent.children["AFKIndicator"]
local spellCircleIndicator = self.parent.children["SpellCircleIndicator"]

-- OSC Sender
local oscSender = self.parent.children["oscSender"]


-- Spell phases
local chargeReady = self.parent.children["ChargeReadyL"]
local chargeCharging = self.parent.children["ChargeChargingL"]
local chargeFire = self.parent.children["ChargeFireL"]

local sprayReady = self.parent.children["SprayReadyL"]
local sprayActive = self.parent.children["SprayActiveL"]

local weaponReady = self.parent.children["WeaponReadyL"]
local weaponActive = self.parent.children["WeaponActiveL"]
local weaponFire = self.parent.children["WeaponFireL"]

local auraReady = self.parent.children["AuraReadyL"]
local auraActive = self.parent.children["AuraActiveL"]

local castReady = self.parent.children["CastReadyL"]
local castCharging = self.parent.children["CastChargingL"]
local castFire = self.parent.children["CastFireL"]

-- Keep track when the charge spell starts
local CHARGE_START_TIME = nil

-- Cooldowns
--TODO: Implement me!

-- Parameters
local CHARGE_CHARGE_SECONDS = 2 -- [CHARGE SPELL] Seconds to firing the spell from when the charging started --TODO: Should be 1.8 sec?
local CHARGE_COOLDOWN = 0       -- [CHARGE SPELL] Cooldown --TODO: Implement me!

local WEAPON_COOLDOWN = 0 -- [WEAPON SPELL] Cooldown --TODO: Implement me!

local CAST_CHARGE_SECONDS = 3 -- [CAST SPELL] Seconds to firing from when casting starts
local CAST_COOLDOWN_MS = 0    -- [CAST SPELL] Cooldown --TODO: Implement me!

-- Spell indexes
local CHARGE_SPELL_INDEX = 1
local SPRAY_SPELL_INDEX = 2
local WEAPON_SPELL_INDEX = 3
local AURA_SPELL_INDEX = 4
local CAST_SPELL_INDEX = 5

-- Sensations
local CHARGE_PREPARE_SENSATION = "ChargePrepareLoop"
local CHARGE_FIRE_SENSATION = "ChargeFireR"

local SPRAY_ACTIVE_SENSATION = "SprayActiveLoopR"

local AURA_ACTIVE_SENSATION = "AuraActiveLoop"

local WEAPON_SENSATION = "WeaponActiveLoopR"
local WEAPON_ATTACK_SENSATION = "WeaponAttackR"

local CAST_PREPARE_SENSATION = "CastPrepareLoopR"
local CAST_FIRE_SENSATION = "CastFireR"

local SENSATION_PATH = "/avatar/parameters/OWO/SensationsTrigger/"

local ELEMENT_NAMES = {
    "Lightning",
    "Fire",
    "Ice",
    "Light",
    "Dark",
    "Wind"
}

-- VRC Gestures
local GESTURE_FIST = 1
local GESTURE_HANDOPEN = 2
local GESTURE_FINGERPOINT = 3
local GESTURE_VICTORY = 4
local GESTURE_ROCKNROLL = 5
local GESTURE_HANDGUN = 6
local GESTURE_THUMBSUP = 7

function onReceiveOSC(message, _)
    local arguments = message[2]
    local gesture = tonumber(arguments[1].value)

    print("=Gesture update: " .. tostring(gesture))

    local spellIndex = tonumber(spellIndexCounter.values.text)

    RefreshSpellPhase(spellIndex, gesture)
end

function onReceiveNotify(_)
    local spellIndex = tonumber(spellIndexCounter.values.text)
    local gestureIndex = tonumber(self.values.text)

    RefreshSpellPhase(spellIndex, gestureIndex)
end

function RefreshSpellPhase(spellIndex, gestureIndex)

    -- Charge
    UpdateChargeSpellPhases(spellIndex, gestureIndex)

    -- Spray
    UpdateSpraySpellPhases(spellIndex, gestureIndex)

    -- Weapon
    UpdateWeaponSpellPhases(spellIndex, gestureIndex)

    -- Aura
    UpdateAuraSpellPhases(spellIndex, gestureIndex)

    -- Cast
    UpdateCastSpellPhases(spellIndex, gestureIndex)
end

function UpdateChargeSpellPhases(spellIndex, gestureIndex)
    local readyPhase = chargeReady.values.x == 1;
    local chargePhase = chargeCharging.values.x == 1;
    local firePhase = chargeFire.values.x == 1;

    chargeReady.values.x = false
    chargeCharging.values.x = false
    chargeFire.values.x = false

    if spellIndex ~= CHARGE_SPELL_INDEX then
        stopOWOSensation(CHARGE_PREPARE_SENSATION)
        stopOWOSensation(CHARGE_FIRE_SENSATION)
        return
    end

    local chargeTimeExceeded = false
    if (CHARGE_START_TIME ~= nil) then
        local chargeSeconds = os.difftime(os.time(), CHARGE_START_TIME)
        chargeTimeExceeded = (chargeSeconds >= CHARGE_CHARGE_SECONDS)
    end

    if (readyPhase and gestureIndex == GESTURE_FIST) then
        -- Charging phase
        chargeCharging.values.x = true
        CHARGE_START_TIME = os.time()

        playOWOSensation(CHARGE_PREPARE_SENSATION, 1.0)
    elseif (chargePhase and gestureIndex ~= GESTURE_FIST) then
        -- Charge abort
        chargeReady.values.x = true
        CHARGE_START_TIME = nil 
    elseif (chargePhase and gestureIndex == GESTURE_FIST and chargeTimeExceeded) then
        -- Fire phase
        chargeFire.values.x = true
        CHARGE_START_TIME = nil

        stopOWOSensation(CHARGE_PREPARE_SENSATION)
        playOWOSensation(CHARGE_FIRE_SENSATION, 1.0)

        --TODO: Cooldown
    else
        -- Ready phase
        chargeReady.values.x = true
    end
end

function UpdateSpraySpellPhases(spellIndex, gestureIndex)
    local afk = afkIndicator.values.x == 1;

    sprayReady.values.x = false
    sprayActive.values.x = false

    if spellIndex ~= SPRAY_SPELL_INDEX then
        stopOWOSensation(SPRAY_ACTIVE_SENSATION)
        return
    end

    if (gestureIndex == GESTURE_HANDOPEN and not afk) then
        -- Fire phase
        sprayActive.values.x = true
        playOWOSensation(SPRAY_ACTIVE_SENSATION, 1.0)
    else
        -- Ready phase
        sprayReady.values.x = true
        playOWOSensation(SPRAY_ACTIVE_SENSATION, 0.25)
    end
end

function UpdateWeaponSpellPhases(spellIndex, gestureIndex)
    local activePhase = weaponActive.values.x == 1
    local spellCircleActive = spellCircleIndicator.values.x == 1

    weaponReady.values.x = false
    weaponActive.values.x = false
    weaponFire.values.x = false

    stopOWOSensation(WEAPON_ATTACK_SENSATION)

    if spellIndex ~= WEAPON_SPELL_INDEX then
        stopOWOSensation(WEAPON_SENSATION)
        stopOWOSensation(WEAPON_ATTACK_SENSATION)
        return
    end

    if (spellCircleActive) then
        -- Ready phase (weapon hidden)
        weaponReady.values.x = true

        stopOWOSensation(WEAPON_SENSATION)
    elseif (gestureIndex == GESTURE_FIST and activePhase) then
        -- Fire phase
        weaponFire.values.x = true

        stopOWOSensation(WEAPON_SENSATION)
        playOWOSensation(WEAPON_ATTACK_SENSATION, 1.0)
        --TODO: Cooldown
    else
        -- Active phase (weapon visible)
        weaponActive.values.x = true

        playOWOSensation(WEAPON_SENSATION, 1.0)
    end
end

function UpdateAuraSpellPhases(spellIndex, gestureIndex)
    auraReady.values.x = false
    auraActive.values.x = false

    if spellIndex ~= AURA_SPELL_INDEX then
        stopOWOSensation(AURA_ACTIVE_SENSATION)
        return
    end

    if (gestureIndex == GESTURE_FIST) then
        -- Active phase
        auraActive.values.x = true
        playOWOSensation(AURA_ACTIVE_SENSATION, 1.0)
    else
        -- Ready phase
        auraReady.values.x = true
        stopOWOSensation(AURA_ACTIVE_SENSATION)
    end
end

function UpdateCastSpellPhases(spellIndex, gestureIndex)
    local readyPhase = castReady.values.x == 1
    local chargePhase = castCharging.values.x == 1

    castReady.values.x = false
    castCharging.values.x = false
    castFire.values.x = false

    if spellIndex ~= CAST_SPELL_INDEX then
        stopOWOSensation(CAST_PREPARE_SENSATION)
        stopOWOSensation(CAST_FIRE_SENSATION)
        return
    end

    local chargeFireTimeExceeded = false
    if (CHARGE_START_TIME ~= nil) then
        local chargeSeconds = os.difftime(os.time(), CHARGE_START_TIME)
        chargeFireTimeExceeded = (chargeSeconds >= CAST_CHARGE_SECONDS)
    end

    if (readyPhase and gestureIndex == GESTURE_FIST) then
        -- Casting phase
        castCharging.values.x = true
        CHARGE_START_TIME = os.time() -- Save current time

        playOWOSensation(CAST_PREPARE_SENSATION, 1.0)
    elseif (chargePhase and gestureIndex ~= GESTURE_FIST and not chargeFireTimeExceeded) then
        -- Cast aborted
        castReady.values.x = true
        CHARGE_START_TIME = nil
    elseif (chargePhase and gestureIndex ~= GESTURE_FIST and chargeFireTimeExceeded) then
        -- Fire phase
        castCharging.values.x = false
        castFire.values.x = true
        CHARGE_START_TIME = nil

        stopOWOSensation(CAST_PREPARE_SENSATION)
        playOWOSensation(CAST_FIRE_SENSATION, 1.0)
        --TODO: Wait / Cooldown
    else
        castReady.values.x = true
    end
end

-- Dedicated stop function for easier readability
function stopOWOSensation(name)
    playOWOSensation(name, 0)
end

function playOWOSensation(sensationName, intensity, elementIndex)
    elementIndex = elementIndex or tonumber(elementIndexCounter.values.text)

    if (elementIndex > #ELEMENT_NAMES) then
        print(">ERROR: Failed to send sensation: Element index out of range!")
        print(" ElementIndex:" .. tostring(elementIndex) .. " (known elements: " .. tostring(#ELEMENT_NAMES) .. ")")
        print(" SensationName: " .. sensationName)
        print(" Intensity: " .. tostring(intensity))
        return
    end

    local elementName = ELEMENT_NAMES[elementIndex]
    if (elementName == nil) then

        -- Element is none and intensity is 0 => Stop sensation for all indexes
        if (intensity == 0 and elementIndex == 0) then
            stopElementalOWOSensations(sensationName)
            return
        end

        print(">ERROR: Failed to send sensation: Element name is NIL!")
        print(" ElementName:" .. tostring(elementName))
        print(" ElementIndex:" .. tostring(elementIndex) .. " (known elements: " .. tostring(#ELEMENT_NAMES) .. ")")
        print(" SensationName: " .. sensationName)
        print(" Intensity: " .. tostring(intensity))
        return
    end

    local sensationNameWithElement = sensationName .. "_" .. elementName

    if (intensity > 0) then
        print("Playing sensation '" .. sensationNameWithElement .. "' at " .. tostring(intensity) .. " intensity")
    end

    local oscPath = SENSATION_PATH .. sensationNameWithElement
    sendOSC(oscPath, intensity)
end

function stopElementalOWOSensations(sensationName)
    local elementCount = #ELEMENT_NAMES

    for i=1, elementCount, 1 do
        playOWOSensation(sensationName, 0, i)
    end
end