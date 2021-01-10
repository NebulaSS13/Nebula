/obj/item/gun/energy/laser
	name = "laser carbine"
	desc = "A G40E carbine, designed to kill with concentrated energy blasts."
	icon = 'icons/obj/guns/laser_carbine.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	force = 10
	one_hand_penalty = 2
	bulk = GUN_BULK_RIFLE
	origin_tech = "{'combat':3,'magnets':2}"
	material = /decl/material/solid/metal/steel
	projectile_type = /obj/item/projectile/beam/midlaser

/obj/item/gun/energy/laser/mounted
	self_recharge = 1
	use_external_power = 1
	one_hand_penalty = 0 //just in case
	has_safety = FALSE

/obj/item/gun/energy/laser/practice
	name = "practice laser carbine"
	desc = "A modified version of the HI G40E, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = /obj/item/projectile/beam/practice
	charge_cost = 10 //How much energy is needed to fire.

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

/obj/item/gun/energy/captain
	name = "antique laser gun"
	icon = 'icons/obj/guns/caplaser.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "A rare weapon, handcrafted by a now defunct specialty manufacturer on Luna for a small fortune. It's certainly aged well."
	force = 5
	slot_flags = SLOT_LOWER_BODY //too unusually shaped to fit in a holster
	w_class = ITEM_SIZE_NORMAL
	projectile_type = /obj/item/projectile/beam
	origin_tech = null
	max_shots = 5 //to compensate a bit for self-recharging
	one_hand_penalty = 1 //a little bulky
	self_recharge = 1

/obj/item/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	icon = 'icons/obj/guns/laser_cannon.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':4,'materials':3,'powerstorage':3}"
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	one_hand_penalty = 6 //large and heavy
	w_class = ITEM_SIZE_HUGE
	projectile_type = /obj/item/projectile/beam/heavylaser
	charge_cost = 40
	max_shots = 6
	accuracy = 2
	fire_delay = 20
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/energy/lasercannon/mounted
	name = "mounted laser cannon"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	accuracy = 0 //mounted laser cannons don't need any help, thanks
	one_hand_penalty = 0
	has_safety = FALSE
