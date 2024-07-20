// FLARES

/obj/item/flashlight/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'pull cord, make light'."
	w_class = ITEM_SIZE_TINY
	light_color = "#e58775"
	icon = 'icons/obj/lighting/flare.dmi'
	action_button_name = null //just pull it manually, neckbeard.
	activation_sound = 'sound/effects/flare.ogg'
	flashlight_flags = FLASHLIGHT_SINGLE_USE
	flashlight_range = 5
	flashlight_power = 3
	light_wedge = LIGHT_OMNI
	offset_on_overlay_x = -8

	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500

/obj/item/flashlight/flare/Initialize()
	. = ..()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.v
	update_icon()

/obj/item/flashlight/flare/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/Process()
	if(produce_heat)
		var/turf/T = get_turf(src)
		if(T)
			T.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if (fuel <= 0)
		on = FALSE
	if(!on)
		update_damage()
		set_flashlight()
		update_icon()
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/attack_self(var/mob/user)
	if(fuel <= 0)
		to_chat(user,"<span class='notice'>\The [src] is spent.</span>")
		return 0

	. = ..()

	if(.)
		activate(user)
		update_damage()
		set_flashlight()
		update_icon()
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/get_heat()
	return on ? 500 : 0

/obj/item/flashlight/flare/proc/activate(var/mob/user)
	if(istype(user))
		user.visible_message("<span class='notice'>[user] pulls the cord on \the [src], activating it.</span>", "<span class='notice'>You pull the cord on \the [src], activating it!</span>")

/obj/item/flashlight/flare/proc/update_damage()
	if(on)
		set_base_attack_force(on_damage)
		atom_damage_type = BURN
	else
		set_base_attack_force(get_initial_base_attack_force())
		atom_damage_type = initial(atom_damage_type)

/obj/item/flashlight/flare/on_update_icon()
	var/nofuel = fuel <= 0
	if(nofuel)
		on = FALSE
	. = ..()
	if(nofuel)
		icon_state = "[icon_state]-empty"

/obj/item/flashlight/flare/get_emissive_overlay_color()
	return color
