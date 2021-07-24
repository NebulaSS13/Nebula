//////////
// Eggs //
//////////

/obj/item/chems/food/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	filling_color = "#fdffd1"
	volume = 10
	center_of_mass = @"{'x':16,'y':13}"
	nutriment_amt = 3
	nutriment_type = /decl/material/liquid/nutriment/protein/egg

/obj/item/chems/food/egg/afterattack(obj/O, mob/user, proximity)
	// Don't crack eggs into appliances if you're on help intent.
	if(istype(O,/obj/machinery/microwave))
		return ..()
	if(!(proximity && ATOM_IS_OPEN_CONTAINER(O))) // Must be adjacent and open.
		return
	to_chat(user, "You crack \the [src] into \the [O].")
	reagents.trans_to(O, reagents.total_volume)
	qdel(src)

/obj/item/chems/food/egg/throw_impact(atom/hit_atom)
	..()
	if(QDELETED(src))
		return // Could potentially happen with unscupulous atoms on hitby() throwing again, etc.
	new/obj/effect/decal/cleanable/egg_smudge(src.loc)
	reagents.splash(hit_atom, reagents.total_volume)
	visible_message("<span class='warning'>\The [src] has been squashed!</span>","<span class='warning'>You hear a smack.</span>")
	qdel(src)

/obj/item/chems/food/egg/attackby(obj/item/W, mob/user)
	if(istype( W, /obj/item/pen/crayon ))
		var/obj/item/pen/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, "<span class='notice'>The egg refuses to take on this color!</span>")
			return

		to_chat(usr, "<span class='notice'>You color \the [src] [clr]</span>")
		icon_state = "egg-[clr]"
	else
		..()

/obj/item/chems/food/egg/blue
	icon_state = "egg-blue"

/obj/item/chems/food/egg/green
	icon_state = "egg-green"

/obj/item/chems/food/egg/mime
	icon_state = "egg-mime"

/obj/item/chems/food/egg/orange
	icon_state = "egg-orange"

/obj/item/chems/food/egg/purple
	icon_state = "egg-purple"

/obj/item/chems/food/egg/rainbow
	icon_state = "egg-rainbow"

/obj/item/chems/food/egg/red
	icon_state = "egg-red"

/obj/item/chems/food/egg/yellow
	icon_state = "egg-yellow"

/obj/item/chems/food/egg/lizard/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein/egg, 5)
	if(prob(30))	//extra nutriment
		reagents.add_reagent(/decl/material/liquid/nutriment/protein, 5)

/obj/item/chems/food/friedegg
	name = "fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	filling_color = "#ffdf78"
	center_of_mass = @"{'x':16,'y':14}"
	bitesize = 1

/obj/item/chems/food/friedegg/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 3)
	reagents.add_reagent(/decl/material/solid/mineral/sodiumchloride, 1)
	reagents.add_reagent(/decl/material/solid/blackpepper, 1)

/obj/item/chems/food/boiledegg
	name = "boiled egg"
	desc = "A hard boiled egg."
	icon_state = "egg"
	filling_color = "#ffffff"

/obj/item/chems/food/boiledegg/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 2)

/obj/item/chems/food/omelette
	name = "cheese omelette"
	desc = "Omelette with cheese!"
	icon_state = "omelette"
	trash = /obj/item/trash/plate
	filling_color = "#fff9a8"
	center_of_mass = @"{'x':16,'y':13}"
	bitesize = 1

/obj/item/chems/food/omelette/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 8)

/obj/item/chems/food/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#f0f2e4"
	center_of_mass = @"{'x':17,'y':10}"
	bitesize = 1

/obj/item/chems/food/chawanmushi/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 5)