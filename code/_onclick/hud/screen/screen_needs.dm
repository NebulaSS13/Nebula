
// Yes, these use icon state. Yes, these are terrible. The alternative is duplicating
// a bunch of fairly blobby logic for every click override on these objects.
/obj/screen/food
	name = "nutrition"
	icon = 'icons/mob/screen/styles/nutrition.dmi'
	pixel_w = 8
	icon_state = "nutrition1"
	screen_loc = ui_nutrition_small

/obj/screen/food/handle_click(mob/user, params)
	if(user.nutrition_icon == src)
		switch(icon_state)
			if("nutrition0")
				to_chat(usr, SPAN_WARNING("You are completely stuffed."))
			if("nutrition1")
				to_chat(usr, SPAN_NOTICE("You are not hungry."))
			if("nutrition2")
				to_chat(usr, SPAN_NOTICE("You are a bit peckish."))
			if("nutrition3")
				to_chat(usr, SPAN_WARNING("You are quite hungry."))
			if("nutrition4")
				to_chat(usr, SPAN_DANGER("You are starving!"))

/obj/screen/drink
	name = "hydration"
	icon = 'icons/mob/screen/styles/hydration.dmi'
	icon_state = "hydration1"
	screen_loc = ui_nutrition_small

/obj/screen/drink/handle_click(mob/user, params)
	if(user.hydration_icon == src)
		switch(icon_state)
			if("hydration0")
				to_chat(usr, SPAN_WARNING("You are overhydrated."))
			if("hydration1")
				to_chat(usr, SPAN_NOTICE("You are not thirsty."))
			if("hydration2")
				to_chat(usr, SPAN_NOTICE("You are a bit thirsty."))
			if("hydration3")
				to_chat(usr, SPAN_WARNING("You are quite thirsty."))
			if("hydration4")
				to_chat(usr, SPAN_DANGER("You are dying of thirst!"))

/obj/screen/bodytemp
	name = "body temperature"
	icon = 'icons/mob/screen/styles/status.dmi'
	icon_state = "temp1"
	screen_loc = ui_temp

/obj/screen/bodytemp/handle_click(mob/user, params)
	if(user.bodytemp == src)
		switch(icon_state)
			if("temp4")
				to_chat(usr, SPAN_DANGER("You are being cooked alive!"))
			if("temp3")
				to_chat(usr, SPAN_DANGER("Your body is burning up!"))
			if("temp2")
				to_chat(usr, SPAN_DANGER("You are overheating."))
			if("temp1")
				to_chat(usr, SPAN_WARNING("You are uncomfortably hot."))
			if("temp-4")
				to_chat(usr, SPAN_DANGER("You are being frozen solid!"))
			if("temp-3")
				to_chat(usr, SPAN_DANGER("You are freezing cold!"))
			if("temp-2")
				to_chat(usr, SPAN_WARNING("You are dangerously chilled!"))
			if("temp-1")
				to_chat(usr, SPAN_NOTICE("You are uncomfortably cold."))
			else
				to_chat(usr, SPAN_NOTICE("Your body is at a comfortable temperature."))

/obj/screen/pressure
	name = "pressure"
	icon = 'icons/mob/screen/styles/status.dmi'
	icon_state = "pressure0"
	screen_loc = ui_temp

/obj/screen/pressure/handle_click(mob/user, params)
	if(user.pressure == src)
		switch(icon_state)
			if("pressure2")
				to_chat(usr, SPAN_DANGER("The air pressure here is crushing!"))
			if("pressure1")
				to_chat(usr, SPAN_WARNING("The air pressure here is dangerously high."))
			if("pressure-1")
				to_chat(usr, SPAN_WARNING("The air pressure here is dangerously low."))
			if("pressure-2")
				to_chat(usr, SPAN_DANGER("There is nearly no air pressure here!"))
			else
				to_chat(usr, SPAN_NOTICE("The local air pressure is comfortable."))

/obj/screen/toxins
	name = "toxin"
	icon = 'icons/mob/screen/styles/status.dmi'
	icon_state = "tox0"
	screen_loc = ui_temp

/obj/screen/toxins/handle_click(mob/user, params)
	if(user.toxin == src)
		if(icon_state == "tox0")
			to_chat(usr, SPAN_NOTICE("The air is clear of toxins."))
		else
			to_chat(usr, SPAN_DANGER("The air is eating away at your skin!"))

/obj/screen/oxygen
	name = "oxygen"
	icon = 'icons/mob/screen/styles/status.dmi'
	icon_state = "oxy0"
	screen_loc = ui_temp

/obj/screen/oxygen/handle_click(mob/user, params)
	if(user.oxygen == src)
		if(icon_state == "oxy0")
			to_chat(usr, SPAN_NOTICE("You are breathing easy."))
		else
			to_chat(usr, SPAN_DANGER("You cannot breathe!"))
