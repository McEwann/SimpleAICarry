-- AI Carry script that allows players to carry AI peds, based on some obfuscated piece of shit
RegisterCommand('carryped', function()
	TriggerEvent('InitCarry')
    end)

carry1 = false
pplayer = PlayerPedId()

function LoadAnimations(anim)
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do
     Citizen.Wait(5)
    end
   end

   function GetPed()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local handle, ped = FindFirstPed()
    local rped = nil
    local Distance2
    repeat
     local pos = GetEntityCoords(ped)
     local distance = GetDistanceBetweenCoords(PlayerCoords, pos, true)
     if PedCheck(ped) and distance < 1.5 and (Distance2 == nil or distance < Distance2) then
      Distance2 = distance
      rped = ped
      SetEntityAsMissionEntity(rped, true, true)
     end
     pedcarry, ped = FindNextPed(handle)
     until not pedcarry
     EndFindPed(handle)
    return rped
   end

   function PedCheck(ped)
    if ped == nil then return false end
    if ped == PlayerPedId() then return false end
    if not DoesEntityExist(ped) then return false end
    if not IsPedOnFoot(ped) then return false end
    if IsEntityDead(ped) and carry1 == false then return false end
    if IsPedHuman(ped) then return false end
    return true
   end

function Combatchecker()
    if carry1 == true then
    while true do
        DisablePlayerFiring(pplayer, true) -- stop ability to fight
        DisableControlAction(0,25,true) -- disable aim
      Citizen.Wait(0)
      if carry1 == false then break end
    end
    end
  end

RegisterNetEvent('InitCarry')
AddEventHandler('InitCarry', function()
 LoadAnimations('nm')
 LoadAnimations('missfinale_c2mcs_1')
 local NearestPed = GetPed()
 if NearestPed then
  if IsEntityAttachedToEntity(NearestPed, GetPlayerPed(PlayerId())) then
   DetachEntity(NearestPed, GetPlayerPed(PlayerId()), true)
   ClearPedTasks(NearestPed)
   ClearPedTasks(GetPlayerPed(PlayerId()))
   SetEntityHealth(NearestPed,300)
   ReviveInjuredPed(NearestPed)
   carry1 = false
  else
   local NearestPed = GetPed()
   TaskPlayAnim(NearestPed, 'nm', 'firemans_carry', 8.0, -1, -1, 1, 1, 0, 0, 0)
   AttachEntityToEntity(NearestPed, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 40269), -0.1, 0.0, 0.1, 25.0, -290.0, -150.0, 1, 1, 0, 1, 0, 1)
   TaskPlayAnim(GetPlayerPed(PlayerId()), 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 1.0, -1, -1, 50, 0, 0, 0, 0)
   carry1 = true
   Combatchecker()
    end
 end
end)