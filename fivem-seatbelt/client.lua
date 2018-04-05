
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12)  
        end		  

Citizen.CreateThread(function()
	Citizen.Wait(500)
	while true do
		
		local ped = GetPlayerPed(-1)
		local car = GetVehiclePedIsIn(ped)
		
		if car ~= 0 and IsCar(car) then 
			
			if beltOn then DisableControlAction(0, 75) end
				
			wasInCar = true 
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(car)
			
			if speedBuffer[2] ~= nil and GetEntitySpeedVector(car, true).y > 1.0 and speedBuffer[2] > Cfg.MinSpeed and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[2] * Cfg.DiffTrigger) and not beltOn then
				local co = GetEntityCoords(ped)
				SetEntityCoords(ped, co.x, co.y, co.z - 1.0, true, true, true)
				SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
				Citizen.Wait(1)
				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
			end
				
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(car)
				
			if IsControlJustReleased(0, 311) then
				beltOn = not beltOn				  
				if beltOn then TriggerEvent('chatMessage', 'Turvavyö ^5 kiinni^0.')
				else TriggerEvent('chatMessage', 'Turvavyö ^1 auki^0.') end 
			end
			
		elseif wasInCar then
			wasInCar = false
			beltOn = false
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
		end
		Citizen.Wait(0)
	end
end)
