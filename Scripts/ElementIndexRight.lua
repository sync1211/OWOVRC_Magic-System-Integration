---@diagnostic disable: undefined-global, lowercase-global
--NOTE: Put this into the receiver for RightHandElement
--TODO: Support for left hand


-- Elements
local lightningIndicator = self.parent.children["LightningIndicator"]
local fireIndicator = self.parent.children["FireIndicator"]
local iceIndicator = self.parent.children["IceIndicator"]
local lightIndicator = self.parent.children["LightIndicator"]
local darkIndicator = self.parent.children["DarkIndicator"]
local windIndicator = self.parent.children["WindIndicator"]


-- Index values
local LIGHTNING_ELEMENT_INDEX = 1
local FIRE_ELEMENT_INDEX = 2
local ICE_ELEMENT_INDEX = 3
local LIGHT_ELEMENT_INDEX = 4
local DARK_ELEMENT_INDEX = 5
local WIND_ELEMENT_INDEX = 5



function onReceiveOSC(message, _)
    local arguments = message[2]
    local value = arguments[1].value

    print("=Element update:" .. tonumber(value))

    RefreshElementState(value)
end

function onReceiveNotify(_)
    local elementIndex = tonumber(self.values.text)

    RefreshElementState(elementIndex)
end

function RefreshElementState(elementIndex)
    lightningIndicator.values.x = (elementIndex == LIGHTNING_ELEMENT_INDEX)
    fireIndicator.values.x = (elementIndex == FIRE_ELEMENT_INDEX)
    iceIndicator.values.x = (elementIndex == ICE_ELEMENT_INDEX)
    lightIndicator.values.x = (elementIndex == LIGHT_ELEMENT_INDEX)
    darkIndicator.values.x = (elementIndex == DARK_ELEMENT_INDEX)
    windIndicator.values.x = (elementIndex == WIND_ELEMENT_INDEX)
end