/obj/machinery/appliance/cooker/oven
	name = "oven"
	desc = "Cookies are ready, dear."
	icon_state = "ovenopen"
	cook_type = "baked"
	appliancetype = OVEN
	food_color = "#a34719"
	can_burn_food = TRUE
	active_power_usage = 6 KILOWATTS
	heating_power = 6000
	//Based on a double deck electric convection oven
	resistance = 10000 // Approx. 4 minutes.
	idle_power_usage = 2 KILOWATTS
	//uses ~30% power to stay warm
	optimal_power = 1.2
	light_x = 2
	max_contents = 5
	use_power = POWER_USE_OFF	//Starts turned off
	var/open = FALSE // Start closed so people don't heat up ovens with the door open

	starts_with = list(
		/obj/item/chems/cooking_container/oven,
		/obj/item/chems/cooking_container/oven,
		/obj/item/chems/cooking_container/oven,
		/obj/item/chems/cooking_container/oven,
		/obj/item/chems/cooking_container/oven
	)

	output_options = list(
		"Pizza" = /obj/item/chems/food/snacks/variable/pizza,
		"Bread" = /obj/item/chems/food/snacks/variable/bread,
		"Pie" = /obj/item/chems/food/snacks/variable/pie,
		"Cake" = /obj/item/chems/food/snacks/variable/cake,
		"Hot Pocket" = /obj/item/chems/food/snacks/variable/pocket,
		"Kebab" = /obj/item/chems/food/snacks/variable/kebab,
		"Waffles" = /obj/item/chems/food/snacks/variable/waffles,
		"Cookie" = /obj/item/chems/food/snacks/variable/cookie,
		"Donut" = /obj/item/chems/food/snacks/variable/donut
	)


/obj/machinery/appliance/cooker/oven/get_mechanics_info()
	return "Control-click this to toggle its power; alt-click this to open/close the door."

/obj/machinery/appliance/cooker/oven/on_update_icon()
	if (!open)
		if (use_power == POWER_USE_OFF)
			icon_state = "ovenclosed_off"
		else
			icon_state = "ovenclosed_on"
	else
		icon_state = "ovenopen"
	..()

/obj/machinery/appliance/cooker/oven/AltClick(var/mob/user)
	try_toggle_door(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

/obj/machinery/appliance/cooker/oven/verb/toggle_door()
	set src in oview(1)
	set category = "Object"
	set name = "Open/close oven door"

	try_toggle_door(usr)

/obj/machinery/appliance/cooker/oven/proc/try_toggle_door(mob/user)
	if (!isliving(user) || isAI(user))
		return

	if (!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES))
		return

	if (!Adjacent(user))
		to_chat(user, "You can't reach the [src] from there, get closer!")
		return

	if (open)
		open = FALSE
		temperature_coefficient = 1
	else
		open = TRUE
		temperature_coefficient = 10
		//When the oven door is opened, oven loses heat faster

	playsound(src, 'sound/machines/hatch_open.ogg', 20, 1)
	update_icon()

/obj/machinery/appliance/cooker/oven/can_insert(var/obj/item/I, var/mob/user)
	if (!open)
		to_chat(user, SPAN_WARNING("You can't put anything in while the door is closed!"))
		return FALSE

	else
		return ..()

/obj/machinery/appliance/cooker/oven/can_remove_items(var/mob/user)
	if (!open)
		to_chat(user, SPAN_WARNING("You can't take anything out while the door is closed!"))
		return FALSE
	return ..()


//Oven has lots of recipes and combine options. The chance for interference is high, so
//If a combine target is set the oven will do it instead of checking recipes
/obj/machinery/appliance/cooker/oven/finish_cooking(var/datum/cooking_item/CI)
	if(CI.combine_target)
		visible_message("<b>[src]</b> pings!")
		combination_cook(CI)
		return
	..()
