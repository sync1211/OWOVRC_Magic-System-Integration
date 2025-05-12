---@diagnostic disable: undefined-global, lowercase-global
--NOTE: Put this into the the button named ResetButton

-- Avatar state
local spellIndexCounterR = self.parent.children["SpellIndexRight"]
local elementIndexCounterR = self.parent.children["ElementIndexRight"]
local gestureCounterR = self.parent.children["GestureIndexRight"]
local spellIndexCounterL = self.parent.children["SpellIndexLeft"]
local elementIndexCounterL = self.parent.children["ElementIndexLeft"]
local gestureCounterL = self.parent.children["GestureIndexLeft"]
local afkIndicator = self.parent.children["AFKIndicator"]
local spellCircleIndicator = self.parent.children["SpellCircleIndicator"]

function onValueChanged(valueName)
    if (valueName ~= "x" or self.values.x == 0) then
        return
    end

    print("=RESET")

    -- Reset OSC values
    gestureCounterL.values.text = 0
    elementIndexCounterL.values.text = 0
    spellIndexCounterL.values.text = 0

    gestureCounterR.values.text = 0
    elementIndexCounterR.values.text = 0
    spellIndexCounterR.values.text = 0

    afkIndicator.values.x = false
    spellCircleIndicator.values.x = false

    -- Notify other scripts of updates
    elementIndexCounterL:notify("")
    spellIndexCounterL:notify("")
    gestureCounterL:notify("")

    elementIndexCounterR:notify("")
    spellIndexCounterR:notify("")
    gestureCounterR:notify("")
end