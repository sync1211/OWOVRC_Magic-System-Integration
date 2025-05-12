---@diagnostic disable: undefined-global, lowercase-global
--NOTE: Put this into the receiver for SpellIndexLeft
--TODO: Support for left hand

-- Avatar state
local gestureCounter = self.parent.children["GestureIndexLeft"]

-- Spells
local chargeIndicator = self.parent.children["ChargeIndicatorL"]
local sprayIndicator = self.parent.children["SprayIndicatorL"]
local weaponIndicator = self.parent.children["WeaponIndicatorL"]
local auraIndicator = self.parent.children["AuraIndicatorL"]
local castIndicator = self.parent.children["CastIndicatorL"]

-- Index values
local CHARGE_SPELL_INDEX = 1
local SPRAY_SPELL_INDEX = 2
local WEAPON_SPELL_INDEX = 3
local AURA_SPELL_INDEX = 4
local CAST_SPELL_INDEX = 5

function onReceiveOSC(message, _)
    local arguments = message[2]
    local value = tonumber(arguments[1].value)

    print("=Spell update:" .. tonumber(value))

    RefreshSpellState(value)

    --Call UpdateChargeSpellPhases via onReceiveNotify
    self.values.text = value
    gestureCounter:notify("")
end

function onReceiveNotify(_)
    local spellIndex = tonumber(self.values.text)

    RefreshSpellState(spellIndex)
end

function RefreshSpellState(spellIndex)
    chargeIndicator.values.x = (spellIndex == CHARGE_SPELL_INDEX)
    sprayIndicator.values.x = (spellIndex == SPRAY_SPELL_INDEX)
    weaponIndicator.values.x = (spellIndex == WEAPON_SPELL_INDEX)
    auraIndicator.values.x = (spellIndex == AURA_SPELL_INDEX)
    castIndicator.values.x = (spellIndex == CAST_SPELL_INDEX)
end
