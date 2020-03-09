/obj/item/chems/food/drinks/juicebox
	icon = 'icons/obj/juicebox.dmi'
	icon_state = "juicebox_base"
	name = "juicebox"
	desc = "A small cardboard juicebox. Cheap and flimsy."
	volume = 30
	amount_per_transfer_from_this = 5
	atom_flags = 0
	material = MAT_CARDBOARD

	color = "#ff0000"
	var/primary_color = "#ff0000"
	var/secondary_color = null
	var/logo_color = "#ff00000"
	var/box_style = "basic"

/obj/item/chems/food/drinks/juicebox/proc/set_colors(
	primary,
	secondary=null,
	logo=null,
	style="basic"
)
	primary_color = primary
	secondary_color = secondary
	logo_color = logo
	box_style = style
	update_icon()

/obj/item/chems/food/drinks/juicebox/on_update_icon()
	var/mutable_appearance/new_appearance = new(src)
	new_appearance.appearance_flags = RESET_COLOR
	new_appearance.color = primary_color

	if (secondary_color)
		var/image/secondary = overlay_image(icon, "juicebox_[box_style]", secondary_color, RESET_COLOR)
		new_appearance.overlays += secondary

	var/borderStyle = logo_color == null ? "border" : "border_icon"
	var/border = overlay_image(icon, "juicebox_[box_style]_[borderStyle]", null, RESET_COLOR)
	new_appearance.overlays += border

	if (logo_color)
		var/image/logo = overlay_image(icon, "juicebox_[box_style]_icon", logo_color, RESET_COLOR)
		new_appearance.overlays += logo

	var/open = (atom_flags & ATOM_FLAG_OPEN_CONTAINER) ? "open" : "close"
	var/image/straw = overlay_image(icon, "juicebox_[open]", null, RESET_COLOR)
	new_appearance.overlays += straw

	appearance = new_appearance

/obj/item/chems/food/drinks/juicebox/examine(mob/user, distance)
	. = ..()
	if(atom_flags & ATOM_FLAG_OPEN_CONTAINER)
		to_chat(user, SPAN_NOTICE("It has a straw stuck through the foil seal on top."))
	else
		to_chat(user, SPAN_NOTICE("It has a straw stuck to the side and the foil seal is intact."))

/obj/item/chems/food/drinks/juicebox/open(mob/user)
	playsound(loc,'sound/effects/bonebreak1.ogg', rand(10,50), 1)
	to_chat(user, SPAN_NOTICE("You pull off the straw and stab it into \the [src], perforating the foil!"))
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	update_icon()

/obj/item/chems/food/drinks/juicebox/apple
	name = "apple juicebox"
	desc = "A small cardboard juicebox with a cartoon apple on it."

/obj/item/chems/food/drinks/juicebox/apple/Initialize()
	. = ..()
	set_colors("#ff0000", "#ffff00", "#ff0000", style="stripe")
	reagents.add_reagent(/datum/reagent/drink/juice/apple, 25)

/obj/item/chems/food/drinks/juicebox/orange
	name = "orange juicebox"
	desc = "A small cardboard juicebox with a cartoon orange on it."

/obj/item/chems/food/drinks/juicebox/orange/Initialize()
	. = ..()
	set_colors("#ffff00", "#ff0000", "#ffff00", style="stripe")
	reagents.add_reagent(/datum/reagent/drink/juice/orange, 25)

/obj/item/chems/food/drinks/juicebox/grape
	name = "grape juicebox"
	desc = "A small cardboard juicebox with some cartoon grapes on it."

/obj/item/chems/food/drinks/juicebox/grape/Initialize()
	. = ..()
	set_colors("#ff00ff", "#00ff00", style="stripe")
	reagents.add_reagent(/datum/reagent/drink/juice/grape, 25)

/obj/item/chems/food/drinks/juicebox/random/Initialize()
	. = ..()
	var/primary = get_random_colour()
	var/secondary = pick(4;get_random_colour(), 1;null)
	var/logo = pick(4;get_random_colour(), 1;null)
	set_colors(primary, secondary, logo, style=pick(list("basic", "stripe", "corner")))

/obj/item/chems/food/drinks/juicebox/sensible_random
	name = "Random Juicebox"
	desc = "Juice in a box; who knows what flavor!"

/obj/item/chems/food/drinks/juicebox/sensible_random/proc/juice_it()
	var/datum/reagent/J = pick(subtypesof(/datum/reagent/drink/juice))
	var/datum/reagent/K = pick(subtypesof(/datum/reagent/drink/juice) - J)
	reagents.add_reagent(J, 20)
	reagents.add_reagent(K, 5)
	return reagents.reagent_list

/obj/item/chems/food/drinks/juicebox/sensible_random/Initialize()
	. = ..()
	var/list/chosen_reagents = juice_it()
	var/datum/reagent/J = chosen_reagents[1]
	var/datum/reagent/K = chosen_reagents[2]
	var/splash = pick("teasing", "splash", "hint", "measure", "nip", "slug", "depth", "dash", "sensation", "surge", "squirt", "spritz", "efflux", "gush", "swell")
	desc = "[J.name]; [J.description] This one comes with \an [splash] of [K.name] in a neat box."
	name = "\improper [J.name] and [K.name] juicebox"
	set_colors(J.color, K.color, get_random_colour(simple=TRUE), style=pick(list("stripe", "corner")))
