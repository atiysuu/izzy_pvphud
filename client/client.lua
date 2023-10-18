CreateThread(function()
    while true do
        local Player = PlayerPedId()
        local PlayerArmor = GetPedArmour(Player)
        local Health = GetEntityHealth(Player)
        local FullHealth = Health - 100
        local WeaponHash = GetSelectedPedWeapon(Player)

        local ammo = 0

        if(IsPedArmed(Player, 4)) then _, ammo = GetAmmoInClip(Player, WeaponHash) end

        ------- REDUCES THE HEALTH FOR DEFAULT MALE PED -------
        if GetEntityModel(Player) == GetHashKey("mp_f_freemode_01") then
            FullHealth = (Health + 25) - 100
        end

        SendNUIMessage({
            action = "Status",
            Health = FullHealth,
            Armor = PlayerArmor,
            Ammo = ammo,
            Armed = IsPedArmed(Player, 4),
        })

        Wait(100)
    end
end)