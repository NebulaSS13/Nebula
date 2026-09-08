/obj/item/projectile/energy/blob //Not super strong.
	name = "spore"
	icon_state = "declone"
	damage = 3
	armor_penetration = 40
	atom_damage_type = TOX
	pass_flags = PASS_FLAG_TABLE
	fire_sound = 'sound/effects/slime_squish.ogg'
	hitsound_non_mob = 'sound/effects/slime_squish.ogg'
	hitsound = 'sound/effects/slime_squish.ogg'
	chem_volume = 5

/obj/item/projectile/energy/blob/populate_reagents()
	. = ..()
	add_projectile_reagents()

/obj/item/projectile/energy/blob/proc/add_projectile_reagents()
	add_to_reagents(/decl/material/solid/organic/mold, 5)

/obj/item/projectile/energy/blob/on_impact(var/atom/A)
	if(REAGENT_TOTAL_VOLUME(reagents))
		var/datum/effect/effect/system/smoke_spread/chem/transparent/splatter_effect = new
		var/location = get_turf(A)
		splatter_effect.attach(location)
		splatter_effect.set_up(reagents, rand(1, REAGENT_TOTAL_VOLUME(reagents)), 0, location)
		playsound(location, 'sound/effects/slime_squish.ogg', 30, 1, -3)
		splatter_effect.start()
	..()

/obj/item/projectile/energy/blob/freezing
	modifier_type_to_apply = /decl/mob_modifier/chilled
	modifier_duration = 1 MINUTE

/obj/item/projectile/energy/blob/freezing/add_projectile_reagents()
	add_to_reagents(/decl/material/liquid/frostoil, 5)
