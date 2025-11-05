// TODO: Make this an actual candle that burns something that produces oxygen as a waste product? That'd be doable now...
/obj/item/oxycandle
	name = "oxygen candle"
	desc = "A steel tube with the words 'OXYGEN - PULL CORD TO IGNITE' stamped on the side.\nA small label reads <span class='warning'>'WARNING: NOT FOR LIGHTING USE. WILL IGNITE FLAMMABLE GASSES'</span>"
	icon = 'icons/obj/items/oxygen_candle.dmi'
	icon_state = "oxycandle"
	item_state = "oxycandle"
	w_class = ITEM_SIZE_SMALL // Should fit into internal's box or maybe pocket
	material = /decl/material/solid/metal/steel
	light_color = "#e58775"
	light_range = 2
	light_power = 1
	action_button_name = null

	var/target_pressure = ONE_ATMOSPHERE
	var/datum/gas_mixture/air_contents = null
	var/candle_volume = 4600
	var/on = 0
	var/activation_sound = 'sound/effects/flare.ogg'
	var/brightness_on = 1 // Moderate-low bright.

/obj/item/oxycandle/Initialize()
	. = ..()
	update_icon()

/obj/item/oxycandle/get_heat()
	return on ? 500 : 0

/obj/item/oxycandle/attack_self(mob/user)
	if(!on)
		to_chat(user, "<span class='notice'>You pull the cord and [src] ignites.</span>")
		on = 1
		update_icon()
		playsound(src.loc, activation_sound, 75, 1)
		air_contents = new /datum/gas_mixture()
		air_contents.total_volume = 200 //liters
		air_contents.temperature = T20C
		var/const/OXYGEN_FRACTION = 1 // separating out the constant so it's clearer why it exists and how to modify it later
		air_contents.adjust_gas(/decl/material/gas/oxygen, OXYGEN_FRACTION * (target_pressure * air_contents.total_volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
		START_PROCESSING(SSprocessing, src)

// Process of Oxygen candles releasing air. Makes 200 volume of oxygen
/obj/item/oxycandle/Process()
	if(!loc)
		return
	var/turf/pos = get_turf(src)
	if(candle_volume <= 0 || !pos || (pos.turf_flags & TURF_IS_WET)) //Now uses turf flags instead of whatever aurora did
		STOP_PROCESSING(SSprocessing, src)
		on = 2
		update_icon()
		update_held_icon()
		SetName("burnt oxygen candle")
		desc += "This tube has exhausted its chemicals."
		return
	if(pos)
		pos.hotspot_expose(1500, 5)
	var/datum/gas_mixture/environment = loc.return_air()
	var/pressure_delta = target_pressure - environment.return_pressure()
	var/output_volume = environment.total_volume * environment.group_multiplier
	var/air_temperature = air_contents.temperature? air_contents.temperature : environment.temperature
	var/transfer_moles = pressure_delta*output_volume/(air_temperature * R_IDEAL_GAS_EQUATION)
	var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
	if (!removed) //Just in case
		return
	environment.merge(removed)
	candle_volume -= 200
	var/const/OXYGEN_FRACTION = 1 // separating out the constant so it's clearer why it exists and how to modify it later
	air_contents.adjust_gas(/decl/material/gas/oxygen, OXYGEN_FRACTION * (target_pressure * air_contents.total_volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature))

/obj/item/oxycandle/on_update_icon()
	. = ..()
	if(on == 1)
		icon_state = "oxycandle_on"
		item_state = icon_state
		set_light(brightness_on)
	else if(on == 2)
		icon_state = "oxycandle_burnt"
		item_state = icon_state
		set_light(0)
	else
		icon_state = "oxycandle"
		item_state = icon_state
		set_light(0)
	update_held_icon()

/obj/item/oxycandle/Destroy()
	QDEL_NULL(air_contents)
	STOP_PROCESSING(SSprocessing, src)
	. = ..()
