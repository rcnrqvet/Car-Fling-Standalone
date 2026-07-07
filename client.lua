local PICKUP_KEY = 47
local PICKUP_DISTANCE = 3.0
local THROW_FORCE = 50.0
local PICKUP_DICT = "missminuteman_1ig_2"
local PICKUP_ANIM = "handsup_enter"
local THROW_DICT = "weapons@projectile@"
local THROW_ANIM = "throw_m_fb_stand"

local isCarryingCar = false
local carriedVehicle = nil

function getClosestVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestVehicle = nil
    local closestDistance = PICKUP_DISTANCE
    
    local handle, vehicle = FindFirstVehicle()
    local success = true
    
    repeat
        if DoesEntityExist(vehicle) then
            local distance = #(playerCoords - GetEntityCoords(vehicle))
            if distance < closestDistance then
                closestVehicle = vehicle
                closestDistance = distance
            end
        end
        success, vehicle = FindNextVehicle(handle)
    until not success
    
    EndFindVehicle(handle)
    return closestVehicle
end

function pickupCar(vehicle)
    if not DoesEntityExist(vehicle) then return end
    
    local playerPed = PlayerPedId()
    
    TaskPlayAnim(playerPed, PICKUP_DICT, PICKUP_ANIM, 8.0, 8.0, -1, 50, 0, false, false, false)
    
    SetEntityAsMissionEntity(vehicle, true, true)
    SetEntityCollision(vehicle, false, false)
    AttachEntityToEntity(vehicle, playerPed, GetPedBoneIndex(playerPed, 0), 0.0, 0.5, 0.8, 0.0, 0.0, 90.0, false, false, false, false, 2, true)
    
    isCarryingCar = true
    carriedVehicle = vehicle
end

function throwCar()
    if not DoesEntityExist(carriedVehicle) then
        isCarryingCar = false
        carriedVehicle = nil
        return
    end
    
    local playerPed = PlayerPedId()
    local forwardVector = GetEntityForwardVector(playerPed)
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    
    DetachEntity(carriedVehicle, true, true)
    SetEntityCollision(carriedVehicle, true, true)
    
    ClearPedTasksImmediately(playerPed)
    
    Citizen.Wait(10)
    
    TaskPlayAnim(playerPed, THROW_DICT, THROW_ANIM, 8.0, 8.0, -1, 0, 0, false, false, false)
    
    Citizen.Wait(250)
    
    SetEntityCoordsNoOffset(carriedVehicle, playerCoords.x + forwardVector.x * 2.5, playerCoords.y + forwardVector.y * 2.5, playerCoords.z, false, false, false)
    SetEntityRotation(carriedVehicle, 0.0, 0.0, playerHeading, 2, true)
    SetEntityVelocity(carriedVehicle, forwardVector.x * THROW_FORCE, forwardVector.y * THROW_FORCE, 0.0)
    SetEntityAngularVelocity(carriedVehicle, 0.0, 10.0, 0.0)
    
    SetEntityAsMissionEntity(carriedVehicle, false, true)
    
    Citizen.Wait(500)
    ClearPedTasks(playerPed)
    
    isCarryingCar = false
    carriedVehicle = nil
end

Citizen.CreateThread(function()
    RequestAnimDict(PICKUP_DICT)
    while not HasAnimDictLoaded(PICKUP_DICT) do
        Citizen.Wait(100)
    end
    
    RequestAnimDict(THROW_DICT)
    while not HasAnimDictLoaded(THROW_DICT) do
        Citizen.Wait(100)
    end
    
    while true do
        Citizen.Wait(0)
        
        if IsControlJustPressed(1, PICKUP_KEY) then
            if not isCarryingCar then
                local nearbyVehicle = getClosestVehicle()
                if nearbyVehicle then
                    pickupCar(nearbyVehicle)
                end
            else
                throwCar()
            end
        end
    end
end)