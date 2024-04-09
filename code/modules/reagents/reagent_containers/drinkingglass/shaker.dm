
/obj/item/chems/drinks/glass2/fitnessflask
	name = "fitness shaker"
	base_name = "shaker"
	desc = "Big enough to contain enough protein to get perfectly swole. Don't mind the bits."
	icon_state = "fitness-cup_black"
	base_icon = "fitness-cup"
	icon = 'icons/obj/drink_glasses/fitness.dmi'
	volume = 100
	material = /decl/material/solid/organic/plastic
	filling_states = @"[10,20,30,40,50,60,70,80,90,100]"
	possible_transfer_amounts = @"[5,10,15,25]"
	rim_pos = null // no fruit slices
	var/lid_color = "black"

/obj/item/chems/drinks/glass2/fitnessflask/Initialize()
	. = ..()
	lid_color = pick("black", "red", "blue")
	update_icon()

/obj/item/chems/drinks/glass2/fitnessflask/on_update_icon()
	..()
	icon_state = "[base_icon]_[lid_color]"

/obj/item/chems/drinks/glass2/fitnessflask/proteinshake
	name = "protein shake"

// This exists to let the name auto-set properly.
/decl/cocktail/proteinshake
	name = "protein shake"
	description = "A revolting slurry of protein and water, fortified with iron."
	hidden_from_codex = TRUE
	ratios = list(
		/decl/material/liquid/nutriment = 2,
		/decl/material/solid/organic/meat = 1,
		/decl/material/liquid/water = 3,
		/decl/material/solid/metal/iron
	)

/obj/item/chems/drinks/glass2/fitnessflask/proteinshake/populate_reagents()
	add_to_reagents(/decl/material/liquid/nutriment,   30)
	add_to_reagents(/decl/material/solid/metal/iron,   10)
	add_to_reagents(/decl/material/solid/organic/meat, 15)
	add_to_reagents(/decl/material/liquid/water,       45)

