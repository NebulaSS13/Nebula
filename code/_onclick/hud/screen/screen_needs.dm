
// Yes, these use icon state. Yes, these are terrible. The alternative is duplicating
// a bunch of fairly blobby logic for every click override on these objects.
/obj/screen/need
	use_supplied_ui_color = TRUE
	use_supplied_ui_alpha = TRUE
	screen_loc = ui_nutrition_small

/obj/screen/need/nutrition
	name = "nutrition"
	icon = 'icons/mob/screen/styles/nutrition.dmi'
	pixel_w = 8
	icon_state = "nutrition1"

/obj/screen/need/nutrition/handle_click(mob/user, params)
	switch(icon_state)
		if("nutrition0")
			to_chat(user, SPAN_WARNING("You are completely stuffed."))
		if("nutrition1")
			to_chat(user, SPAN_NOTICE("You are not hungry."))
		if("nutrition2")
			to_chat(user, SPAN_NOTICE("You are a bit peckish."))
		if("nutrition3")
			to_chat(user, SPAN_WARNING("You are quite hungry."))
		if("nutrition4")
			to_chat(user, SPAN_DANGER("You are starving!"))

/obj/screen/need/nutrition/on_update_icon()
	. = ..()
	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner) || owner.isSynthetic())
		invisibility = INVISIBILITY_ABSTRACT
		return
	invisibility = INVISIBILITY_NONE
	switch(owner.get_nutrition())
		if(450 to INFINITY)
			icon_state = "nutrition0"
		if(350 to 450)
			icon_state = "nutrition1"
		if(250 to 350)
			icon_state = "nutrition2"
		if(150 to 250)
			icon_state = "nutrition3"
		else
			icon_state = "nutrition4"

/obj/screen/need/hydration
	name = "hydration"
	icon = 'icons/mob/screen/styles/hydration.dmi'
	icon_state = "hydration1"

/obj/screen/need/hydration/handle_click(mob/user, params)
	switch(icon_state)
		if("hydration0")
			to_chat(user, SPAN_WARNING("You are overhydrated."))
		if("hydration1")
			to_chat(user, SPAN_NOTICE("You are not thirsty."))
		if("hydration2")
			to_chat(user, SPAN_NOTICE("You are a bit thirsty."))
		if("hydration3")
			to_chat(user, SPAN_WARNING("You are quite thirsty."))
		if("hydration4")
			to_chat(user, SPAN_DANGER("You are dying of thirst!"))

/obj/screen/need/hydration/on_update_icon()
	. = ..()
	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner) || owner.isSynthetic())
		invisibility = INVISIBILITY_ABSTRACT
		return
	invisibility = INVISIBILITY_NONE
	switch(owner.get_hydration())
		if(450 to INFINITY)
			icon_state = "hydration0"
		if(350 to 450)
			icon_state = "hydration1"
		if(250 to 350)
			icon_state = "hydration2"
		if(150 to 250)
			icon_state = "hydration3"
		else
			icon_state = "hydration4"

/obj/screen/need/cell_charge
	name                  = "cell"
	icon_state            = "charge-empty"
	screen_loc            = ui_nutrition

/obj/screen/need/cell_charge/robot
	screen_loc = ui_toxin

/obj/screen/need/cell_charge/on_update_icon()
	. = ..()
	var/mob/living/owner = owner_ref?.resolve()
	if(!istype(owner) || !owner.isSynthetic())
		invisibility = INVISIBILITY_ABSTRACT
		return
	invisibility = INVISIBILITY_NONE
	var/obj/item/cell/cell = owner.get_cell()
	if(cell)
		var/chargeNum = clamp(ceil(cell.percent()/25), 0, 4)	//0-100 maps to 0-4, but give it a paranoid clamp just in case.
		icon_state = "charge[chargeNum]"
	else
		icon_state = "charge-empty"
