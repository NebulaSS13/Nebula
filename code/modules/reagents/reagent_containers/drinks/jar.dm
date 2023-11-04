

///jar

/obj/item/chems/drinks/jar
	name = "empty jar"
	desc = "A jar. You're not sure what it's supposed to hold."
	icon_state = "jar"
	item_state = "beaker"
	center_of_mass = @"{'x':15,'y':8}"
	material = /decl/material/solid/glass
	drop_sound = 'sound/foley/bottledrop1.ogg'
	pickup_sound = 'sound/foley/bottlepickup1.ogg'

/obj/item/chems/drinks/jar/update_container_name()
	if(LAZYLEN(reagents?.reagent_volumes))
		SetName("jar of something")
	else
		SetName(initial(name))

/obj/item/chems/drinks/jar/update_container_desc()
	if(LAZYLEN(reagents?.reagent_volumes))
		desc = "You can't really tell what this is."
	else
		desc = "A jar. You're not sure what it's supposed to hold."

/obj/item/chems/drinks/jar/on_update_icon()
	if(LAZYLEN(reagents?.reagent_volumes))
		icon_state = "jar_what"
	else
		icon_state = initial(icon_state)
