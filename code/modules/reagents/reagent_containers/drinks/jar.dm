

///jar

/obj/item/chems/drinks/jar
	name = "empty jar"
	desc = "A jar. You're not sure what it's supposed to hold."
	icon_state = "jar"
	item_state = "beaker"
	center_of_mass = @"{'x':15,'y':8}"
	unacidable = 1
	drop_sound = 'sound/foley/bottledrop1.ogg'
	pickup_sound = 'sound/foley/bottlepickup1.ogg'

/obj/item/chems/drinks/jar/on_reagent_change()
	if(LAZYLEN(reagents.reagent_volumes))
		icon_state ="jar_what"
		SetName("jar of something")
		desc = "You can't really tell what this is."
	else
		icon_state = initial(icon_state)
		SetName(initial(name))
		desc = "A jar. You're not sure what it's supposed to hold."
