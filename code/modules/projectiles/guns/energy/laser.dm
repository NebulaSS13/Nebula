/obj/item/gun/energy/laser
	name = "laser carbine"
	desc = "A laser carbine, designed to kill with concentrated laser blasts."
	icon = 'icons/obj/guns/laser_carbine.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	force = 10

	accepts_cell_type = /obj/item/cell
	power_supply = /obj/item/cell/high
	charge_cost = 100
	projectile_type = /obj/item/projectile/beam

	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass   = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/glass        = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/energy/laser/empty
	starts_loaded = FALSE

/obj/item/gun/energy/laser/secure
	req_access = list(list(access_brig, access_bridge))
	authorized_modes = list(AUTHORIZED)

/obj/item/gun/energy/laser/secure/on_update_icon()
	. = ..()
	add_overlay(mutable_appearance(icon, "[icon_state]_stripe", COLOR_WHITE))

/obj/item/gun/energy/laser/secure/empty
	starts_loaded = FALSE

/obj/item/gun/energy/laser/mounted
	name = "mounted laser carbine"
	self_recharge      = TRUE
	use_external_power = TRUE
	has_safety = FALSE

//Practice

/obj/item/gun/energy/laser/practice
	name = "practice laser rifle"
	desc = "A practice laser weapon which fires less concentrated energy bolts designed for target shooting."

	power_supply = /obj/item/cell
	charge_cost = 10
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
	charge_cost = 100
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

/obj/item/gun/energy/laser/practice/empty
	starts_loaded = FALSE

//Laser cannon

/obj/item/gun/energy/laser/cannon
	name = "laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon = 'icons/obj/guns/laser_cannon.dmi'

	accepts_cell_type = /obj/item/cell/fuel //Too powerful to just "recharge and go pew again"
	power_supply = /obj/item/cell/fuel
	charge_cost = 150
	projectile_type = /obj/item/projectile/beam/heavy
	fire_delay = 10

	matter = list(
		/decl/material/solid/fiberglass    = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/glass         = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/silver  = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/energy/laser/cannon/empty
	starts_loaded = FALSE

/obj/item/gun/energy/laser/cannon/mounted
	name = "mounted laser cannon"
	power_supply = /obj/item/cell/hyper
	self_recharge      = TRUE
	use_external_power = TRUE
	has_safety = FALSE

//X-ray

/obj/item/gun/energy/laser/xray
	name = "x-ray laser carbine"
	desc = "A compact for its capabalities high-power weapon capable of emitting concentrated x-ray beams, that are able to penetrate laser-resistant armor."
	icon = 'icons/obj/guns/xray.dmi'

	accepts_cell_type = /obj/item/cell/fuel
	power_supply = /obj/item/cell/fuel/nuclear
	charge_cost = 350
	projectile_type = /obj/item/projectile/beam/xray

	matter = list(
		/decl/material/solid/fiberglass     = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/glass          = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/silver   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/platinum = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/gas/hydrogen         = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/energy/laser/xray/empty
	starts_loaded = FALSE

//X-RAY, sniper

/obj/item/gun/energy/laser/xray/sniper
	name = "x-ray sniper rifle"
	desc = "A powerful rifle capable of shooting armor-piercing x-ray blasts, commonly used to take down heavy machinery."
	icon = 'icons/obj/guns/xray_sniper.dmi'
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK

	power_supply = /obj/item/cell/fuel/fusion
	charge_cost = 550
	projectile_type = /obj/item/projectile/beam/xray/heavy

	matter = list(
		/decl/material/solid/fiberglass       = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/glass            = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/silver     = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold       = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/platinum   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/gas/hydrogen           = MATTER_AMOUNT_REINFORCEMENT
	)


/obj/item/gun/energy/laser/xray/sniper/empty
	starts_loaded = FALSE

//Antique

/obj/item/gun/energy/laser/captain
	name = "antique laser gun"
	desc = "A rare weapon, looks handcrafted. It's certainly aged well and you're pretty sure it costs a small fortune."
	icon = 'icons/obj/guns/caplaser.dmi'

	accepts_cell_type = null
	power_supply = null
	projectile_type = /obj/item/projectile/beam
	self_recharge = TRUE
	max_shots = 5 //to compensate a bit for self-recharging

	matter = list(
		/decl/material/solid/fiberglass       = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/glass            = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/silver     = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/gold       = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/uranium    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/energy/laser/captain/price()
	. = ..() * 50 //now its actually pricy, antique, handcrafted, basically a treasure

//Larsertag

/obj/item/gun/energy/laser/tag
	name = "lasertag carbine"
	desc = "Standard issue weapon of the Imperial Guard."

	accepts_cell_type = null
	power_supply = null
	projectile_type = /obj/item/projectile/beam/tag
	self_recharge = TRUE
	max_shots = 10

	var/required_vest = /obj/item/clothing/suit/redtag
	var/stripe_color = COLOR_RED_LIGHT

/obj/item/gun/energy/laser/tag/on_update_icon()
	. = ..()
	 add_overlay(mutable_appearance(icon, "[icon_state]_stripe", stripe_color))

/obj/item/gun/energy/laser/tag/special_check(var/mob/living/carbon/human/M)
	if(ishuman(M) && !istype(M.get_equipped_item(slot_wear_suit_str), required_vest))
		to_chat(M, SPAN_WARNING("You need to be wearing your laser tag vest!"))
		return FALSE
	return ..()

/obj/item/gun/energy/laser/tag/blue
	projectile_type = /obj/item/projectile/beam/tag/blue
	required_vest = /obj/item/clothing/suit/bluetag
	stripe_color = COLOR_SKY_BLUE