/decl/material/liquid/ethanol/champagne
	name = "champagne"
	lore_text = "Sparkling wine made from exquisite grape."
	taste_description = "bitter taste"
	color = "#a89410"
	strength = 18

	glass_name = "champagne"
	glass_desc = "Wow, it's bubbling!"
	glass_special = list(DRINK_FIZZ)

/obj/effect/decal/cleanable/champagne
	name = "champagne"
	desc = "Is this a gold?"
	gender = PLURAL
	icon = 'icons/effects/effects.dmi'
	icon_state = "fchampagne1"
	color = COLOR_BRASS
	random_icon_states = list("fchampagne1", "fchampagne2", "fchampagne3", "fchampagne4")

/obj/item/chems/food/drinks/bottle/champagne
	name = "champagne bottle"
	desc = "Sparkling wine made from exquisite grape varieties by the method of secondary fermentation in a bottle. Bubbling."
	icon = 'icons/obj/food.dmi'
	icon_state = "champagne"
	center_of_mass = @"{'x':12,'y':5}"
	atom_flags = 0 //starts closed

	var/opening

/obj/item/chems/food/drinks/bottle/champagne/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/ethanol/champagne, 100)

/obj/item/chems/food/drinks/bottle/champagne/open(mob/user)
	if(ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, SPAN_NOTICE("\The [src] is already open."))
		return

	if(!opening)
		user.visible_message(SPAN_NOTICE("\The [user] tries to open \the [src]!"))
		opening = TRUE
	else
		to_chat(user, SPAN_WARNING("You are already trying to open \the [src]."))
		return

	if(!do_after(user, 3 SECONDS, src))
		if(QDELETED(user) || QDELETED(src))
			return

		user.visible_message(SPAN_NOTICE("\The [user] fails to open \the [src]."))
		opening = FALSE
		return

	playsound(src,'sound/effects/champagne_open.ogg', 100, 1)

	if(!user.skill_check(SKILL_COOKING, SKILL_BASIC))
		sleep(4)
		playsound(src,'sound/effects/champagne_psh.ogg', 100)
		user.visible_message(SPAN_WARNING("\The [user] clumsily pops the cork out of \the [src], wasting fizz and getting foam everywhere."))
		new /obj/effect/decal/cleanable/champagne(get_turf(user))
	else
		user.visible_message(SPAN_NOTICE("\The [user] pops the cork out of \the [src] with a professional flourish."))

	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
