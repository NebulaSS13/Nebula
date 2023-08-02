/obj/item/gun/energy/laser
	name = "laser rifle"
	desc = "A laser rifle, designed to kill with concentrated laser blasts."
	icon = 'icons/obj/guns/laser_rifle.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	force = 10
	one_hand_penalty = 2

	accepts_cell_type = /obj/item/cell
	power_supply = /obj/item/cell/high
	charge_cost = 200
	projectile_type = /obj/item/projectile/beam
	origin_tech = "{'combat':2,'magnets':2,'materials':2,'powerstorage':2}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass        = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/energy/laser/mounted
	self_recharge = 1
	use_external_power = 1
	one_hand_penalty = 0 //just in case
	has_safety = FALSE

/obj/item/gun/energy/laser/secure
	req_access = list(list(access_brig, access_bridge))

/obj/item/gun/energy/laser/secure/on_update_icon()
	. = ..()
	add_overlay(mutable_appearance(icon, "[icon_state]_stripe", COLOR_BLUE_GRAY))

//Practice

/obj/item/gun/energy/laser/practice
	name = "practice laser carbine"
	desc = "A practice laser weapon which fires less concentrated energy bolts designed for target shooting."
	projectile_type = /obj/item/projectile/beam/practice

/obj/item/gun/energy/laser/practice/on_update_icon()
	. = ..()
	 add_overlay(mutable_appearance(icon, "[icon_state]_stripe", COLOR_ORANGE))

/obj/item/gun/energy/laser/practice/proc/hacked()
	return projectile_type != /obj/item/projectile/beam/practice

/obj/item/gun/energy/laser/practice/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	if(hacked())
		return NO_EMAG_ACT
	to_chat(user, SPAN_WARNING("You disable the safeties on [src] and crank the output to the lethal levels."))
	desc += " Its safeties are disabled and output is set to dangerous levels."
	projectile_type = /obj/item/projectile/beam
	charge_cost = 20
	max_shots = rand(3,6) //will melt down after those
	return 1

/obj/item/gun/energy/laser/practice/handle_post_fire(atom/movable/firer, atom/target, var/pointblank=0, var/reflex=0)
	..()
	if(hacked())
		max_shots--
		if(!max_shots) //uh hoh gig is up
			to_chat(firer, SPAN_DANGER("\The [src] sizzles in your hands, acrid smoke rising from the firing end!"))
			desc += " The optical pathway is melted and useless."
			projectile_type = null


//Laser cannon

/obj/item/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	icon = 'icons/obj/guns/laser_cannon.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':4,'magnets':4,'materials':3,'powerstorage':3}"
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	one_hand_penalty = 6 //large and heavy
	w_class = ITEM_SIZE_HUGE
	accepts_cell_type = /obj/item/cell/fuel
	power_supply = /obj/item/cell/fuel/high
	charge_cost = 500
	projectile_type = /obj/item/projectile/beam/heavy
	max_shots = 6
	accuracy = 2
	fire_delay = 20
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass       = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver     = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/energy/lasercannon/empty
	power_supply = null

/obj/item/gun/energy/lasercannon/mounted
	name = "mounted laser cannon"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
	accuracy = 0 //mounted laser cannons don't need any help, thanks
	one_hand_penalty = 0
	has_safety = FALSE

//X-ray

/obj/item/gun/energy/xray
	name = "x-ray laser carbine"
	desc = "A high-power laser gun capable of emitting concentrated x-ray blasts, that are able to penetrate laser-resistant armor much more readily than standard photonic beams."
	icon = 'icons/obj/guns/xray.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	origin_tech = "{'combat':5,'magnets':5,'materials':5,'powerstorage':5}"
	projectile_type = /obj/item/projectile/beam/xray
	one_hand_penalty = 2
	w_class = ITEM_SIZE_LARGE
	accepts_cell_type = /obj/item/cell/fuel
	power_supply = /obj/item/cell/fuel/nuclear/high
	charge_cost = 900
	combustion = 0
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass       = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver     = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/gold       = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_PRIMARY
	)

/obj/item/gun/energy/xray/empty
	power_supply = null

/obj/item/gun/energy/xray/sniper
	name = "marksman x-ray rifle"
	desc = "A designated marksman rifle capable of shooting powerful armor-piercing x-ray blasts, this is a weapon to kill from a distance."
	icon = 'icons/obj/guns/xray_sniper.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':4,'magnets':4,'materials':3,'powerstorage':3}"
	projectile_type = /obj/item/projectile/beam/xray/sniper
	one_hand_penalty = 5 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.
	slot_flags = SLOT_BACK
	charge_cost = 40
	accepts_cell_type = /obj/item/cell/fuel
	power_supply = /obj/item/cell/fuel/fusion
	charge_cost = 1000
	fire_delay = 35
	force = 10
	w_class = ITEM_SIZE_HUGE
	accuracy = -2 //shooting at the hip
	scoped_accuracy = 9
	scope_zoom = 2
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass       = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver     = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold       = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/energy/xray/sniper/empty
	power_supply = null

//Antique lasgun

/obj/item/gun/energy/captain
	name = "antique laser gun"
	icon = 'icons/obj/guns/caplaser.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "A rare weapon, looks handcrafted. It's certainly aged well and you're pretty sure it costs a small fortune."
	force = 5
	slot_flags = SLOT_LOWER_BODY //too unusually shaped to fit in a holster
	w_class = ITEM_SIZE_NORMAL
	projectile_type = /obj/item/projectile/beam
	origin_tech = null
	max_shots = 5 //to compensate a bit for self-recharging
	one_hand_penalty = 1 //a little bulky
	self_recharge = 1
	material = null //no recycling antique shit
	matter = list()

/obj/item/gun/energy/captain/get_base_value()
	. = ..() * 200 //now its actually fucking pricy

//Lasertag

/obj/item/gun/energy/lasertag
	name = "laser tag gun"
	icon = 'icons/obj/guns/laser_rifle.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "Standard issue weapon of the Imperial Guard."
	origin_tech = "{'combat':1,'magnets':1}"
	self_recharge = 1
	material = /decl/material/solid/metal/steel
	projectile_type = /obj/item/projectile/beam/lasertag/blue
	var/required_vest
	var/stripe_color = COLOR_WHITE

/obj/item/gun/energy/lasertag/on_update_icon()
	. = ..()
	 add_overlay(mutable_appearance(icon, "[icon_state]_stripe", stripe_color))

/obj/item/gun/energy/lasertag/special_check(var/mob/living/carbon/human/M)
	if(ishuman(M) && !istype(M.get_equipped_item(slot_wear_suit_str), required_vest))
		to_chat(M, SPAN_WARNING("You need to be wearing your laser tag vest!"))
		return FALSE
	return ..()

/obj/item/gun/energy/lasertag/blue
	stripe_color = COLOR_SKY_BLUE
	projectile_type = /obj/item/projectile/beam/lasertag/blue
	required_vest = /obj/item/clothing/suit/bluetag

/obj/item/gun/energy/lasertag/red
	stripe_color = COLOR_RED_LIGHT
	projectile_type = /obj/item/projectile/beam/lasertag/red
	required_vest = /obj/item/clothing/suit/redtag