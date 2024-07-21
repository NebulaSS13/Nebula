/obj/item/towel
	name = "towel"
	icon = 'icons/obj/items/towel.dmi'
	icon_state = ICON_STATE_WORLD
	item_flags = ITEM_FLAG_IS_BELT
	slot_flags = SLOT_HEAD | SLOT_LOWER_BODY | SLOT_OVER_BODY
	_base_attack_force = 1
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A soft cotton towel."
	material = /decl/material/solid/organic/cloth

/obj/item/towel/Initialize()
	. = ..()
	initialize_reagents()

/obj/item/towel/Destroy()
	if(is_processing)
		STOP_PROCESSING(SSobj, src)
	return ..()

// Slowly dry out.
/obj/item/towel/Process()
	if(reagents?.total_volume)
		reagents.remove_any(max(1, round(reagents.total_volume * 0.05)))
	if(!reagents?.total_volume)
		return PROCESS_KILL

/obj/item/towel/initialize_reagents()
	create_reagents(50)
	. = ..()

/obj/item/towel/on_reagent_change()
	if(!(. = ..()))
		return
	if(reagents?.total_volume)
		SetName("damp [initial(name)]")
		if(!is_processing)
			START_PROCESSING(SSobj, src)
	else
		SetName(initial(name))
		if(is_processing)
			STOP_PROCESSING(SSobj, src)

/obj/item/towel/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(user.a_intent == I_HURT)
		return ..()
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/reagent_space = reagents.maximum_volume - reagents.total_volume
	if(reagent_space <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is too saturated to dry [user == target ? "yourself" : "\the [target]"] off effectively."))
	else
		var/decl/pronouns/G = target.get_pronouns()
		var/datum/reagents/touching_reagents = target.get_contact_reagents()
		if(!touching_reagents?.total_volume)
			to_chat(user, SPAN_WARNING("[user == target ? "You are" : "\The [target] [G.is]"] already dry."))
		else
			user.visible_message(SPAN_NOTICE("\The [user] uses \the [src] to towel [user == target ? G.self : "\the [target]"] dry."))
			touching_reagents.trans_to(src, min(touching_reagents.total_volume, reagent_space))
			playsound(user, 'sound/weapons/towelwipe.ogg', 25, 1)
	return TRUE

/obj/item/towel/attack_self(mob/user)
	if(user.a_intent == I_GRAB)
		lay_out()
		return TRUE
	if(user.a_intent != I_HURT)
		return use_on_mob(user, user)
	return ..()

/obj/item/towel/random/Initialize()
	. = ..()
	set_color(get_random_colour())

/obj/item/towel/gold
	name = "gold towel"
	paint_color = "#ffd700"

/obj/item/towel/red
	name = "red towel"
	paint_color = "#ff0000"

/obj/item/towel/purple
	name = "purple towel"
	paint_color = "#800080"

/obj/item/towel/cyan
	name = "cyan towel"
	paint_color = "#00ffff"

/obj/item/towel/orange
	name = "orange towel"
	paint_color = "#ff8c00"

/obj/item/towel/pink
	name = "pink towel"
	paint_color = "#ff6666"

/obj/item/towel/light_blue
	name = "light blue towel"
	paint_color = "#3fc0ea"

/obj/item/towel/black
	name = "black towel"
	paint_color = "#222222"

/obj/item/towel/brown
	name = "black towel"
	paint_color = "#854636"

/obj/item/towel/fleece // loot from the king of goats. it's a golden towel
	name = "golden fleece"
	desc = "The legendary Golden Fleece of Jason made real."
	_base_attack_force = 1
	attack_verb = list("smote")
	material = /decl/material/solid/metal/gold

/obj/item/towel/verb/lay_out()
	set name = "Lay Out Towel"
	set category = "Object"

	if(usr.incapacitated())
		return

	if(usr.drop_from_inventory(src))
		usr.visible_message(
			SPAN_NOTICE("[usr] lay out \the [src] on the ground."),
			SPAN_NOTICE("You lay out \the [src] on the ground."))
		icon = 'icons/obj/items/towel_flat.dmi'
		pixel_x = 0
		pixel_y = 0
		pixel_z = 0

/obj/item/towel/on_picked_up(mob/user)
	..()
	if(icon != initial(icon))
		icon = initial(icon)
		user.visible_message(
			SPAN_NOTICE("[user] rolled up \the [src]."),
			SPAN_NOTICE("You pick up and fold \the [src]."))
