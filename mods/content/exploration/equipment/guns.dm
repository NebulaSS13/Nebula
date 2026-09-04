/obj/item/gun/energy/gun/reloadable/phase
	name = "phase carbine"
	desc = "The RayZar EW26 Artemis is a downsized energy weapon, specifically designed for use against wildlife."
	icon = 'mods/content/exploration/icons/phase_carbine.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_BACK|SLOT_LOWER_BODY
	projectile_type = /obj/item/projectile/energy/phase // 50 damage against animals
	one_hand_penalty = 15
	firemodes = null
	indicator_color = COLOR_WHITE
	charge_cost = 35 // ~14 shots

/obj/item/gun/energy/gun/reloadable/phase/pistol
	name = "phase pistol"
	desc = "The RayZar EW15 Apollo is an energy handgun, specifically designed for self-defense against aggressive wildlife."
	icon = 'mods/content/exploration/icons/phase_pistol.dmi'
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_LOWER_BODY|SLOT_HOLSTER
	projectile_type = /obj/item/projectile/energy/phase/light // 40 damage on animals
	one_hand_penalty = 0
	charge_cost = 25 // 20 shots

/obj/item/gun/energy/gun/reloadable/phase/rifle
	name = "phase rifle"
	desc = "The RayZar EW31 Orion is a specialist energy weapon, intended for use against hostile wildlife."
	icon = 'mods/content/exploration/icons/phase_rifle.dmi'
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BACK
	projectile_type = /obj/item/projectile/energy/phase/heavy // 60 damage on animals
	charge_cost = 50 // 10 shots
	accuracy = 15
	one_hand_penalty = 30

/obj/item/gun/energy/gun/reloadable/phase/tranq_rifle
	name = "tranquilizer rifle"
	desc = "A niche RayZar product designed for nonlethal animal control. A specialized emitter disrupts the nervous system of the target, eventually inducing sleep. Only rated for use on wildlife."
	icon = 'mods/content/exploration/icons/tranq_rifle.dmi'
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_BACK
	charge_cost = 25 // 20 shots
	projectile_type = /obj/item/projectile/energy/phase/tranq
	accuracy = 15
	one_hand_penalty = 30

/obj/item/gun/energy/gun/reloadable/phase/tranq_pistol
	name = "tranquilizer pistol"
	desc = "A niche RayZar product designed for nonlethal animal control. A specialized emitter disrupts the nervous system of the target, eventually inducing sleep. Only rated for use on wildlife."
	icon = 'mods/content/exploration/icons/tranq_pistol.dmi'
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_LOWER_BODY|SLOT_HOLSTER
	charge_cost = 15 // ~33 shots
	projectile_type = /obj/item/projectile/energy/phase/tranq/weak
	one_hand_penalty = 0
