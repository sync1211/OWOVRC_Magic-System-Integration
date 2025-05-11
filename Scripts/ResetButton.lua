---@diagnostic disable: undefined-global, lowercase-global
--NOTE: Put this into the the button named ResetButton

-- Avatar state
local spellIndexCounter = self.parent.children["SpellIndexRight"]
local elementIndexCounter = self.parent.children["ElementIndexRight"]
local gestureCounter = self.parent.children["GestureIndexRight"]
local afkIndicator = self.parent.children["AFKIndicator"]
local spellCircleIndicator = self.parent.children["SpellCircleIndicator"]

function onValueChanged(valueName)
    if (valueName ~= "x" or self.values.x == 0) then
        return
    end

    print("=RESET")

    -- Reset OSC values
    gestureCounter.values.text = 0
    elementIndexCounter.values.text = 0
    spellIndexCounter.values.text = 0
    afkIndicator.values.x = false
    spellCircleIndicator.values.x = false

    -- Notify other scripts of updates
    elementIndexCounter:notify("")
    spellIndexCounter:notify("")
    gestureCounter:notify("")
end