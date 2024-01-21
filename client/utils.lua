local bones = require 'client.bones'

-- Progressbar Lengths --
local openDoorProgressLength = 1            -- Length of progressbar opening door (seconds)
local swapSeatProgressLength = 1            -- Length of progressbar swapping seats (seconds)

-- Open / Close Doors --
function toggleDoor(veh, doorID)
    local str = (GetVehicleDoorAngleRatio(veh, doorID) > 0.0) and 'Closing' or 'Opening'
    if lib.progressCircle({
        duration = (openDoorProgressLength * 1000),
        position = 'bottom',
        label = ('%s %s...'):format(str, bones.doors[doorID]),
        useWhileDead = false,
        canCancel = true,
        disable = { car = true }
    }) then
        if GetVehicleDoorAngleRatio(veh, doorID) > 0.0 then
            SetVehicleDoorShut(veh, doorID, false)
        else
            SetVehicleDoorOpen(veh, doorID, false, false)
        end
    end
end

-- Roll Up / Down Windows --
function toggleWindow(veh, windowID)
    if not IsVehicleWindowIntact(veh, windowID) then
        RollUpWindow(veh, windowID)
    else
        RollDownWindow(veh, windowID)
    end
end

function rollUpWindows(veh)
    local doorsCount = GetNumberOfVehicleDoors(veh)
    for x = 0, (doorsCount - 3) do
        RollUpWindow(veh, x)
    end
end

-- Toggle Interior Light --
function toggleInteriorLight(veh)
    if IsVehicleInteriorLightOn(veh) then
        SetVehicleInteriorlight(veh, false)
    else
        SetVehicleInteriorlight(veh, true)
    end
end

-- Toggle Hazard Lights --
function toggleHazards(veh)
    if GetVehicleIndicatorLights(veh) == 3 then
        SetVehicleIndicatorLights(veh, 0, false)
        SetVehicleIndicatorLights(veh, 1, false)
    else
        SetVehicleIndicatorLights(veh, 0, true)
        SetVehicleIndicatorLights(veh, 1, true)
    end
end

-- Swap Seats --
function swapSeat(veh, seatID)
    if lib.progressCircle({
        duration = (swapSeatProgressLength * 1000),
        position = 'bottom',
        label = ('Swapping to %s...'):format(bones.seats[seatID]),
        useWhileDead = false,
        canCancel = true,
        disable = { car = true },
        anim = {
            dict = 'anim@veh@low@vigilante@front_ps@enter_exit',
            clip = 'shuffle_seat',
            flag = 16
        },
    }) then
        SetPedIntoVehicle(cache.ped, veh, seatID)
        exports['xt-vehiclemenu']:seatsMenu(veh)
    end
end