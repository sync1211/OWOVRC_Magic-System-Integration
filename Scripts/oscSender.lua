---@diagnostic disable: undefined-global, lowercase-global
--NOTE: Put this into the receiver for RightHandElement

local SENSATION_PATH = "/avatar/parameters/OWO/SensationsTrigger/"

local ELEMENT_NAMES = {
    "Lightning",
    "Fire",
    "Ice",
    "Light",
    "Dark",
    "Wind"
}


function onReceiveNotify(sensationName, intensity, elementIndex)
    playOWOSensation(sensationName, intensity, elementIndex)
end


function playOWOSensation(sensationName, intensity, elementIndex)
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