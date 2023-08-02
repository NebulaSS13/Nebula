//Pistol

/obj/item/gun/projectile/pistol
	name = "pistol"
	desc = "A rather bleak medium-sized pistol."
	icon = 'icons/obj/guns/pistol.dmi'
	load_method = MAGAZINE
	caliber = CALIBER_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	allowed_magazines = /obj/item/ammo_magazine/pistol

	safety_icon = "safety"
	ammo_indicator = TRUE

	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY)

/obj/item/gun/projectile/pistol/empty
	starts_loaded = FALSE

/obj/item/gun/projectile/pistol/update_base_icon()
	var/base_state = get_world_inventory_state()
	if(!length(ammo_magazine?.stored_ammo) && check_state_in_icon("[base_state]-e", icon))
		icon_state = "[base_state]-e"
	else
		icon_state = base_state

//Holdout pistol

/obj/item/gun/projectile/pistol/holdout
	name = "holdout pistol"
	desc = "A small pocket-sized pistol. Still powerful despite having a rather low caliber."
	icon = 'icons/obj/guns/holdout_pistol.dmi'
	w_class = ITEM_SIZE_SMALL
	caliber = CALIBER_PISTOL_SMALL
	magazine_type = /obj/item/ammo_magazine/pistol/small
	allowed_magazines = /obj/item/ammo_magazine/pistol/small

	accuracy_power = 2

	ammo_indicator = FALSE

/obj/item/gun/projectile/pistol/holdout/empty
	starts_loaded = FALSE

//Silencer

/obj/item/silencer
	name = "silencer"
	desc = "A silencer."
	icon = 'icons/obj/guns/holdout_pistol_silencer.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/steel

/obj/item/gun/projectile/pistol/holdout/attack_hand(mob/user)
	if(!silenced || !user.is_holding_offhand(src) || !user.check_dexterity(DEXTERITY_COMPLEX_TOOLS, TRUE))
		return ..()
	to_chat(user, SPAN_NOTICE("You unscrew \the [silenced] from \the [src]."))
	user.put_in_hands(silenced)
	silenced = initial(silenced)
	w_class = initial(w_class)
	update_icon()
	return TRUE

/obj/item/gun/projectile/pistol/holdout/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/silencer))
		if(src in user.get_held_items()) //if we're not in his hands
			to_chat(user, SPAN_WARNING("You'll need [src] in your hands to do that."))
			return TRUE
		if(user.try_unequip(I, src))
			to_chat(user, SPAN_NOTICE("You screw [I] onto [src]."))
			silenced = I //dodgy?
			w_class = ITEM_SIZE_NORMAL
			update_icon()
		return TRUE
	. = ..()

/obj/item/gun/projectile/pistol/holdout/update_base_icon()
	..()
	if(silenced)
		add_overlay(mutable_appearance(icon, "[get_world_inventory_state()]-silencer"))

/obj/item/gun/projectile/pistol/holdout/get_on_belt_overlay()
	if(silenced && check_state_in_icon("on_belt_silenced", icon))
		return overlay_image(icon, "on_belt_silenced", color)
	return ..()

//Revolver

/obj/item/gun/projectile/revolver
	name = "revolver"
	desc = "A powerful double-action revolver."
	icon = 'icons/obj/guns/revolvers.dmi'
	mag_insert_sound = 'sound/weapons/guns/interaction/rev_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/rev_magout.ogg'
	icon_state = ICON_STATE_WORLD
	handle_casings = CYCLE_CASINGS
	caliber = CALIBER_PISTOL_MAGNUM
	ammo_type = /obj/item/ammo_casing/pistol/magnum
	max_shells = 6

	accuracy_power = 10

	safety_icon = "safety"
	var/chamber_offset = 0 //how many empty chambers in the cylinder until you hit a round

	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY)

/obj/item/gun/projectile/revolver/empty
	starts_loaded = FALSE

/obj/item/gun/projectile/revolver/verb/spin_cylinder()
	set name = "Spin cylinder"
	set desc = "Fun when you're bored out of your skull."
	set category = "Object"

	chamber_offset = 0
	visible_message("<span class='warning'>\The [usr] spins the cylinder of \the [src]!</span>", \
	"<span class='notice'>You hear something metallic spin and click.</span>")
	playsound(src.loc, 'sound/weapons/revolver_spin.ogg', 100, 1)
	loaded = shuffle(loaded)
	if(rand(1,max_shells) > loaded.len)
		chamber_offset = rand(0,max_shells - loaded.len)

/obj/item/gun/projectile/revolver/consume_next_projectile()
	if(chamber_offset)
		chamber_offset--
		return
	return ..()

/obj/item/gun/projectile/revolver/load_ammo(var/obj/item/A, mob/user)
	chamber_offset = 0
	return ..()

/obj/item/gun/projectile/revolver/get_alt_interactions(var/mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/revolver_spin_cylinder)

/decl/interaction_handler/revolver_spin_cylinder
	name = "Spin Cylinder"
	expected_target_type = /obj/item/gun/projectile/revolver

/decl/interaction_handler/revolver_spin_cylinder/invoked(var/atom/target, var/mob/user)
	var/obj/item/gun/projectile/revolver/R = target
	R.spin_cylinder()

//Lasvolver

/obj/item/gun/projectile/revolver/lasvolver
	name = "lasvolver"
	desc = "An inane combination of a lasgun and revolver, 'firing' special one-use flash capsules to produce laser bursts."
	icon = 'icons/obj/guns/lasvolver.dmi'
	fire_sound_text = "pop"
	caliber = CALIBER_PISTOL_LASBULB
	ammo_type = /obj/item/ammo_casing/lasbulb

	screen_shake = 0

	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY, /decl/material/solid/fiberglass   = MATTER_AMOUNT_SECONDARY)

/obj/item/gun/projectile/revolver/lasvolver/empty
	starts_loaded = FALSE

/obj/item/gun/projectile/revolver/lasvolver/handle_post_fire()
	. = ..()
	playsound(src,'sound/effects/rewind.ogg', 20, 0)

//Capgun

/obj/item/gun/projectile/revolver/capgun
	name = "cap gun"
	desc = "Looks almost like the real thing! Ages 8 and up."
	caliber = CALIBER_CAPS
	ammo_type = /obj/item/ammo_casing/cap
	var/cap = TRUE

/obj/item/gun/projectile/revolver/capgun/on_update_icon()
	. = ..()
	if(cap)
		add_overlay(image(icon, "[icon_state]-toy"))

/obj/item/gun/projectile/revolver/capgun/attackby(obj/item/wirecutters/W, mob/user)
	if(!istype(W) || !cap)
		return ..()
	to_chat(user, "<span class='notice'>You snip off the toy markings off the [src].</span>")
	name = "revolver"
	desc += " Someone snipped off the barrel's toy mark. How dastardly."
	cap = FALSE
	update_icon()
	return 1

//Random pistol

/obj/item/gun/projectile/pistol/random
	name = "pistol"
	icon = 'icons/obj/guns/random_pistol/base.dmi'
	var/decl/gun_look/gun_look
	var/handle_icon
	// ammo and safety offsets were moved to gun_look
	var/static/list/descriptor = list(
		"Shining", "Power", "Instant", "Reliable", "Neo", "Super", "Boom", "Big", "Nitro", "Automatic"
	)
	var/static/list/noun = list(
		"Justice", "Protection", "Defense", "Penetrator", "Compensator", "Police Special", "Combat", "Point & Shoot"
	)

/obj/item/gun/projectile/pistol/random/Initialize()
	var/index = pick(caliber, rand(200,900), "P-[rand(10,99)]")
	desc = "A semi-automatic pistol of unknown origin. The inscription on the side claims the model is '[pick(descriptor)] [pick(noun)] [index]'"
	var/list/styles = decls_repository.get_decls_of_type(/decl/gun_look)
	gun_look = styles[pick(styles)]
	handle_icon = pick(gun_look.handle_icons)
	. = ..()

/obj/item/gun/projectile/pistol/random/update_base_icon()
	..()
	add_overlay(image(gun_look.icon, icon_state))
	add_overlay(image(handle_icon, icon_state))

/obj/item/gun/projectile/pistol/random/get_ammo_indicator()
	return gun_look.adjust_ammo_indicator(..(), get_world_inventory_state())

/obj/item/gun/projectile/pistol/random/get_safety_indicator()
	var/mutable_appearance/safety = mutable_appearance(icon, "safety[safety()]")
	return gun_look.adjust_safety_indicator(safety, get_world_inventory_state())

/decl/gun_look
	var/icon =  'icons/obj/guns/random_pistol/looks/plated.dmi'
	 // offsets for LEDs, base state = x,y
	var/list/ammo_offset = list(
		ICON_STATE_WORLD = list(15, 15),
		ICON_STATE_INV = list(15, 17)
	)
	var/list/safety_offset = list(
		ICON_STATE_WORLD = list(17, 15),
		ICON_STATE_INV = list(17, 17)
	)
	var/list/handle_icons = list(
		'icons/obj/guns/random_pistol/handle/ergonomic.dmi',
		'icons/obj/guns/random_pistol/handle/black.dmi',
		'icons/obj/guns/random_pistol/handle/revolver.dmi'
	)

/decl/gun_look/proc/adjust_ammo_indicator(mutable_appearance/ammo_indicator, base_state)
	ammo_indicator.icon_state = replacetext(ammo_indicator.icon_state, "[base_state]_", "")
	ammo_indicator.pixel_x = ammo_offset[base_state][1]
	ammo_indicator.pixel_y = ammo_offset[base_state][2]
	return ammo_indicator

/decl/gun_look/proc/adjust_safety_indicator(mutable_appearance/safety, base_state)
	safety.pixel_x = safety_offset[base_state][1]
	safety.pixel_y = safety_offset[base_state][2]
	return safety
/decl/gun_look/cover
	icon =  'icons/obj/guns/random_pistol/looks/cover.dmi'
	ammo_offset = list(
		ICON_STATE_WORLD = list(11, 14),
		ICON_STATE_INV = list(8, 15)
	)
	safety_offset = list(
		ICON_STATE_WORLD = list(13, 14),
		ICON_STATE_INV = list(10, 15)
	)

/decl/gun_look/short
	icon =  'icons/obj/guns/random_pistol/looks/short.dmi'
	ammo_offset = list(
		ICON_STATE_WORLD = list(16, 14),
		ICON_STATE_INV = list(16, 15)
	)
	safety_offset = list(
		ICON_STATE_WORLD = list(18, 14),
		ICON_STATE_INV = list(18, 15)
	)

/decl/gun_look/drilled
	icon =  'icons/obj/guns/random_pistol/looks/drilled.dmi'
	ammo_offset = list(
		ICON_STATE_WORLD = list(16, 14),
		ICON_STATE_INV = list(16, 15)
	)
	safety_offset = list(
		ICON_STATE_WORLD = list(18, 14),
		ICON_STATE_INV = list(18, 15)
	)