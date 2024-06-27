/**********************Miner Lockers**************************/

/obj/structure/closet/secure_closet/miner
	name = "miner's equipment"
	closet_appearance = /decl/closet_appearance/secure_closet/mining
	req_access = list(access_mining)

/obj/structure/closet/secure_closet/miner/WillContain()
	return list(
		new /datum/atom_creator/weighted(list(
				/obj/item/backpack/industrial,
				/obj/item/backpack/satchel/eng
			)),
		/obj/item/radio/headset/headset_cargo,
		/obj/item/clothing/jumpsuit/miner,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/shoes/color/black,
		/obj/item/scanner/gas,
		/obj/item/ore,
		/obj/item/flashlight/lantern,
		/obj/item/tool/shovel,
		/obj/item/tool/pickaxe,
		/obj/item/clothing/glasses/meson
	)


/*****************************Shovel********************************/

// Flags.
/obj/item/stack/flag
	name = "beacon"
	desc = "Some deployable high-visibilty beacons."
	singular_name = "beacon"
	icon_state = "folded"
	amount = 10
	max_amount = 10
	icon = 'icons/obj/items/marking_beacon.dmi'
	z_flags = ZMM_MANGLE_PLANES

	var/upright = FALSE

/obj/item/stack/flag/red
	light_color = COLOR_RED

/obj/item/stack/flag/yellow
	light_color = COLOR_YELLOW

/obj/item/stack/flag/green
	light_color = COLOR_LIME

/obj/item/stack/flag/blue
	light_color = COLOR_BLUE

/obj/item/stack/flag/teal
	light_color = COLOR_TEAL

/obj/item/stack/flag/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/flag/attackby(var/obj/item/W, var/mob/user)
	if(upright)
		return attack_hand_with_interaction_checks(user)
	return ..()

/obj/item/stack/flag/attack_hand(var/mob/user)
	if(!upright)
		return ..()
	knock_down()
	user.visible_message("\The [user] knocks down \the [singular_name].")
	return TRUE

/obj/item/stack/flag/attack_self(var/mob/user)
	var/turf/T = get_turf(src)

	if(!istype(T) || T.is_open())
		to_chat(user, "<span class='warning'>There's no solid surface to plant \the [singular_name] on.</span>")
		return

	for(var/obj/item/stack/flag/F in T)
		if(F.upright)
			to_chat(user, "<span class='warning'>\The [F] is already planted here.</span>")
			return

	if(use(1)) // Don't skip use() checks even if you only need one! Stacks with the amount of 0 are possible, e.g. on synthetics!
		var/obj/item/stack/flag/newflag = new src.type(T, 1)
		newflag.set_up()
		if(T.can_be_dug())
			user.visible_message("\The [user] plants \the [newflag.singular_name] firmly in the ground.")
		else
			user.visible_message("\The [user] attaches \the [newflag.singular_name] firmly to the ground.")

/obj/item/stack/flag/proc/set_up()
	upright = 1
	anchored = TRUE
	update_icon()

/obj/item/stack/flag/on_update_icon()
	. = ..()
	if(upright)
		pixel_x = 0
		pixel_y = 0
		icon_state = "base"
		add_overlay(emissive_overlay(icon = icon, icon_state = "glowbit", color = light_color))
		z_flags |= ZMM_MANGLE_PLANES
		set_light(2, 0.1) // Very dim so the rest of the thingie is barely visible - if the turf is completely dark, you can't see anything on it, no matter what
	else
		pixel_x = rand(-randpixel, randpixel)
		pixel_y = rand(-randpixel, randpixel)
		icon_state = "folded"
		add_overlay(overlay_image(icon, "basebit", light_color))
		z_flags &= ~ZMM_MANGLE_PLANES
		set_light(0)

/obj/item/stack/flag/proc/knock_down()
	upright = 0
	anchored = FALSE
	update_icon()
