//////////
// Eggs //
//////////

/obj/item/food/egg
	name = "egg"
	desc = "An egg!"
	icon = 'icons/obj/food/eggs/egg.dmi'
	icon_state = ICON_STATE_WORLD
	filling_color = "#fdffd1"
	volume = 10
	center_of_mass = @'{"x":16,"y":13}'
	material = /decl/material/solid/organic/bone/eggshell
	obj_flags = OBJ_FLAG_HOLLOW
	nutriment_amt = 3
	nutriment_type = /decl/material/solid/organic/meat/egg

/obj/item/food/egg/afterattack(obj/O, mob/user, proximity)
	// Don't crack eggs into appliances if you're on help intent.
	if(istype(O,/obj/machinery/microwave))
		return ..()
	if(!(proximity && ATOM_IS_OPEN_CONTAINER(O))) // Must be adjacent and open.
		return
	to_chat(user, "You crack \the [src] into \the [O].")
	reagents.trans_to(O, reagents.total_volume)
	qdel(src)

/obj/item/food/egg/throw_impact(atom/hit_atom)
	..()
	if(QDELETED(src))
		return // Could potentially happen with unscupulous atoms on hitby() throwing again, etc.
	new/obj/effect/decal/cleanable/egg_smudge(src.loc)
	reagents.splash(hit_atom, reagents.total_volume)
	visible_message("<span class='warning'>\The [src] has been squashed!</span>","<span class='warning'>You hear a smack.</span>")
	qdel(src)

/obj/item/food/egg/attackby(obj/item/W, mob/user)
	if(IS_PEN(W))
		var/clr = W.get_tool_property(TOOL_PEN, TOOL_PROP_COLOR_NAME)

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, SPAN_WARNING("The egg refuses to take on this color!"))
			return

		to_chat(usr, SPAN_NOTICE("You color \the [src] [clr]"))
		icon_state = "egg-[clr]"
		return TRUE
	return ..()

/obj/item/food/egg/blue
	icon = 'icons/obj/food/eggs/egg_blue.dmi'

/obj/item/food/egg/green
	icon = 'icons/obj/food/eggs/egg_green.dmi'

/obj/item/food/egg/mime
	icon = 'icons/obj/food/eggs/egg_mime.dmi'

/obj/item/food/egg/orange
	icon = 'icons/obj/food/eggs/egg_orange.dmi'

/obj/item/food/egg/purple
	icon = 'icons/obj/food/eggs/egg_purple.dmi'

/obj/item/food/egg/rainbow
	icon = 'icons/obj/food/eggs/egg_rainbow.dmi'

/obj/item/food/egg/red
	icon = 'icons/obj/food/eggs/egg_red.dmi'

/obj/item/food/egg/yellow
	icon = 'icons/obj/food/eggs/egg_yellow.dmi'

/obj/item/food/egg/lizard
	icon = 'icons/obj/food/eggs/egg_lizard.dmi'

/obj/item/food/egg/lizard/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat/egg, 5)
	if(prob(30))	//extra nutriment
		add_to_reagents(/decl/material/solid/organic/meat, 5)

/obj/item/food/friedegg
	name = "fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	filling_color = "#ffdf78"
	center_of_mass = @'{"x":16,"y":14}'
	bitesize = 1

/obj/item/food/friedegg/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 3)
	add_to_reagents(/decl/material/solid/sodiumchloride,     1)
	add_to_reagents(/decl/material/solid/blackpepper,        1)

/obj/item/food/boiledegg
	name = "boiled egg"
	desc = "A hard boiled egg."
	icon = 'icons/obj/food/eggs/egg.dmi'
	icon_state = ICON_STATE_WORLD
	filling_color = "#ffffff"

/obj/item/food/boiledegg/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 2)

/obj/item/food/omelette
	name = "cheese omelette"
	desc = "Omelette with cheese!"
	icon_state = "omelette"
	plate = /obj/item/plate
	filling_color = "#fff9a8"
	center_of_mass = @'{"x":16,"y":13}'
	bitesize = 1

/obj/item/food/omelette/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 8)

/obj/item/food/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f0f2e4"
	center_of_mass = @'{"x":17,"y":10}'
	bitesize = 1

/obj/item/food/chawanmushi/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 5)