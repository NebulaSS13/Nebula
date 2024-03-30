/obj/item/toy/xmas_cracker
	name = "xmas cracker"
	icon = 'icons/obj/christmas.dmi'
	icon_state = "cracker"
	desc = "Directions for use: Requires two people, one to pull each end."
	material = /decl/material/solid/organic/cardboard
	var/cracked = 0

/obj/item/toy/xmas_cracker/attack(mob/target, mob/user)
	if(!cracked && ishuman(target) && (target.stat == CONSCIOUS) && !target.get_active_held_item() )
		target.visible_message(
			SPAN_NOTICE("\The [user] and \the [target] pop \an [src]! *pop*"),
			SPAN_NOTICE("You pull \an [src] with \the [target]! *pop*"),
			SPAN_NOTICE("You hear a *pop*")
		)
		var/obj/item/paper/Joke = new /obj/item/paper(user.loc)
		Joke.SetName("[pick("awful","terrible","unfunny")] joke")
		Joke.info = pick(list(
			"What did one snowman say to the other?\n\n<i>'Is it me or can you smell carrots?'</i>",
			"Where are santa's helpers educated?\n\n<i>Nowhere, they're ELF-taught.</i>",
			"What happened to the man who stole advent calanders?\n\n<i>He got 25 days.</i>",
			"What does Santa get when he gets stuck in a chimney?\n\n<i>Claus-trophobia.</i>",
			"Where do you find chili beans?\n\n<i>The north pole.</i>",
			"What do you get from eating tree decorations?\n\n<i>Tinsilitis!</i>",
			"What do snowmen wear on their heads?\n\n<i>Ice caps!</i>"
		))
		new /obj/item/clothing/head/festive(target.loc)
		user.update_icon()
		cracked = 1
		icon_state = "cracker1"
		var/obj/item/toy/xmas_cracker/other_half = new /obj/item/toy/xmas_cracker(target)
		other_half.cracked = 1
		other_half.icon_state = "cracker2"
		target.put_in_active_hand(other_half)
		playsound(user, 'sound/effects/snap.ogg', 50, 1)
		return 1
	return ..()

/obj/item/clothing/head/festive
	name = "festive paper hat"
	icon = 'icons/clothing/head/festive.dmi'
	desc = "A crappy paper crown that you are REQUIRED to wear."
	flags_inv = 0
	body_parts_covered = 0
	material = /decl/material/solid/organic/paper
	var/list/permitted_colors = list(COLOR_RED, COLOR_ORANGE, COLOR_YELLOW, COLOR_GREEN, COLOR_BLUE, COLOR_INDIGO, COLOR_VIOLET)

/obj/item/clothing/head/festive/Initialize()
	. = ..()
	color = pick(permitted_colors)

