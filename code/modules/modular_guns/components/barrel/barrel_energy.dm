/obj/item/firearm_component/barrel/energy
	var/projectile_type = /obj/item/projectile/beam/practice
	var/charge_cost = 20 //How much energy is needed to fire.

/obj/item/firearm_component/barrel/energy/crossbow
	projectile_type = /obj/item/projectile/energy/bolt

/obj/item/firearm_component/barrel/energy/crossbow/ninja
	projectile_type = /obj/item/projectile/energy/dart

/obj/item/firearm_component/barrel/energy/crossbow/large
	projectile_type = /obj/item/projectile/energy/bolt/large

/obj/item/firearm_component/barrel/energy/sidearm
	projectile_type = /obj/item/projectile/beam/stun

/obj/item/firearm_component/barrel/energy/plasma
	projectile_type = /obj/item/projectile/energy/plasmastun

/obj/item/firearm_component/barrel/energy/incendiary
	projectile_type = /obj/item/projectile/beam/incendiary_laser

/obj/item/firearm_component/barrel/energy/confusion
	projectile_type = /obj/item/projectile/beam/confuseray

/obj/item/firearm_component/barrel/energy/electrolaser
	projectile_type = /obj/item/projectile/beam/stun
	combustion = 0

/obj/item/firearm_component/barrel/energy/plasmacutter
	projectile_type = /obj/item/projectile/beam/plasmacutter

/obj/item/firearm_component/barrel/energy/floral
	projectile_type = /obj/item/projectile/energy/floramut
	charge_cost = 10

/obj/item/firearm_component/barrel/energy/heavy_stun
	projectile_type = /obj/item/projectile/beam/stun/heavy

/obj/item/firearm_component/barrel/energy/laser
	projectile_type = /obj/item/projectile/beam/midlaser

/obj/item/firearm_component/barrel/energy/laser/cannon
	projectile_type = /obj/item/projectile/beam/heavylaser

/obj/item/firearm_component/barrel/energy/laser/antique
	projectile_type = /obj/item/projectile/beam


/obj/item/firearm_component/barrel/energy/laser/practice
	projectile_type = /obj/item/projectile/beam/practice
	charge_cost = 10

/*

/obj/item/gun/energy/laser/secure/on_update_icon()
	. = ..()
	overlays += mutable_appearance(icon, "[icon_state]_stripe", COLOR_BLUE_GRAY)

/obj/item/gun/energy/laser/practice/on_update_icon()
	. = ..()
	overlays += mutable_appearance(icon, "[icon_state]_stripe", COLOR_ORANGE)

/obj/item/gun/energy/laser/practice/proc/hacked()
	return projectile_type != /obj/item/projectile/beam/practice

/obj/item/gun/energy/laser/practice/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	if(hacked())
		return NO_EMAG_ACT
	to_chat(user, "<span class='warning'>You disable the safeties on [src] and crank the output to the lethal levels.</span>")
	desc += " Its safeties are disabled and output is set to dangerous levels."
	projectile_type = /obj/item/projectile/beam/midlaser
	charge_cost = 20
	max_shots = rand(3,6) //will melt down after those
	return 1

/obj/item/gun/energy/laser/practice/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	..()
	if(hacked())
		max_shots--
		if(!max_shots) //uh hoh gig is up
			to_chat(user, "<span class='danger'>\The [src] sizzles in your hands, acrid smoke rising from the firing end!</span>")
			desc += " The optical pathway is melted and useless."
			projectile_type = null
*/
