local bones = require 'client.bones'

local commandName = 'veh'       -- Command to open menu

-- Seats Menu --
local function seatsMenu(veh)
    local menuOptions = {}
    local vehModel = GetEntityModel(veh)
    local seatsCount = GetVehicleModelNumberOfSeats(vehModel)
    for x = -1, (seatsCount - 2) do
        local isFree = IsVehicleSeatFree(veh, x)

        if isFree then
            menuOptions[#menuOptions+1] = {
                label = bones.seats[x],
                icon = 'fas fa-chair',
                args = { seat = x }
            }
        end
    end

    lib.registerMenu({
        id = 'veh_seats_menu',
        title = 'Vehicle Seats',
        position = 'top-right',
        onClose = function(keyPressed)
            if keyPressed == 'Backspace' then
                lib.showMenu('veh_menu')
            end
        end,
        options = menuOptions
    }, function(selected, scrollIndex, args)
        swapSeat(veh, tonumber(args.seat))
    end)
    lib.showMenu('veh_seats_menu')
end
exports('seatsMenu', seatsMenu)

-- Doors Menu --
local function doorsMenu(veh)
    local menuOptions = {}
    local doorsCount = GetNumberOfVehicleDoors(veh)
    for x = 0, (doorsCount - 1) do
        local isDisabled = ((IsVehicleDoorDamaged(veh, x) == false) and (DoesVehicleHaveDoor(veh, x) == 1))

        if not isDisabled then
            menuOptions[#menuOptions+1] = {
                label = bones.doors[x],
                icon = 'fas fa-door-open',
                args = { door = x },
                close = false
            }
        end
    end

    lib.registerMenu({
        id = 'veh_door_menu',
        title = 'Vehicle Doors',
        position = 'top-right',
        onClose = function(keyPressed)
            if keyPressed == 'Backspace' then
                lib.showMenu('veh_menu')
            end
        end,
        options = menuOptions
    }, function(selected, scrollIndex, args)
        toggleDoor(veh, args.door)
    end)
    lib.showMenu('veh_door_menu')
end
exports('doorsMenu', doorsMenu)

-- Windows Menu --
local function windowsMenu(veh)
    local menuOptions = {}
    local doorsCount = GetNumberOfVehicleDoors(veh)
    for x = 0, (doorsCount - 3) do
        local isDisabled = ((IsVehicleDoorDamaged(veh, x) == false) and (DoesVehicleHaveDoor(veh, x) == 1))

        if not isDisabled then
            menuOptions[#menuOptions+1] = {
                label = bones.doors[x],
                icon = 'fas fa-up-down',
                args = { window = x },
                close = false,
            }
        end
    end

    menuOptions[#menuOptions+1] = {
        label = 'Roll Down All Windows',
        icon = 'fas fa-down-long',
        args = { window = 'allDown' },
        close = false,
    }

    menuOptions[#menuOptions+1] = {
        label = 'Roll Up All Windows',
        icon = 'fas fa-up-long',
        args = { window = 'allUp' },
        close = false,
    }


    lib.registerMenu({
        id = 'veh_windows_menu',
        title = 'Vehicle Windows',
        position = 'top-right',
        onClose = function(keyPressed)
            if keyPressed == 'Backspace' then
                lib.showMenu('veh_menu')
            end
        end,
        options = menuOptions
    }, function(selected, scrollIndex, args)
        if args.window == 'allDown' then
            RollDownWindows(veh)
        elseif args.window == 'allUp' then
            rollUpWindows(veh)
        else
            toggleWindow(veh, args.window)
        end
    end)
    lib.showMenu('veh_windows_menu')
end
exports('windowsMenu', windowsMenu)

-- Lights Menu --
local function lightsMenu(veh)
    lib.registerMenu({
        id = 'veh_lights_menu',
        title = 'Vehicle Lights',
        position = 'top-right',
        onClose = function(keyPressed)
            if keyPressed == 'Backspace' then
                lib.showMenu('veh_menu')
            end
        end,
        options = {
            { label = 'Interior Light', args = { type = 'interior' }, close = false },
            { label = 'Toggle Hazards', args = { type = 'hazards' }, close = false  },
        }
    }, function(selected, scrollIndex, args)
        if args.type == 'interior' then
            toggleInteriorLight(veh)
        elseif args.type == 'hazards' then
            toggleHazards(veh)
        end
    end)
    lib.showMenu('veh_lights_menu')
end
exports('lightsMenu', lightsMenu)

-- Vehicle Menu --
local function openVehicleMenu()
    local veh = cache.vehicle

    lib.registerMenu({
        id = 'veh_menu',
        title = 'Vehicle Menu',
        position = 'top-right',
        options = {
            { label = 'Seats', args = { type = 'seats' }, icon = 'fas fa-chair'  },
            { label = 'Doors', args = { type = 'doors' }, icon = 'fas fa-door-open' },
            { label = 'Windows', args = { type = 'windows' }, icon = 'fas fa-up-down',  },
            { label = 'Lights', args = { type = 'lights' }, icon = 'fas fa-lightbulb',  }
        }
    }, function(selected, scrollIndex, args)
        if args.type == 'seats' then
            seatsMenu(veh)
        elseif args.type == 'doors' then
            doorsMenu(veh)
        elseif args.type == 'windows' then
            windowsMenu(veh)
        elseif args.type == 'lights' then
            lightsMenu(veh)
        end
    end)
    lib.showMenu('veh_menu')
end
exports('openMenu', openVehicleMenu)


RegisterCommand(commandName, function()
    if not cache.vehicle then
        lib.notify({ title = 'You\'re not in a vehicle!', type = 'error' })
        return
    end
    openVehicleMenu()
end)