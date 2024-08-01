// Molluscs!
/obj/item/trash/mollusc_shell
	name = "mollusc shell"
	icon = 'icons/obj/molluscs.dmi'
	icon_state = "mollusc_shell"
	desc = "The cracked shell of an unfortunate mollusc."
	material = /decl/material/solid/organic/bone

/obj/item/trash/mollusc_shell/clam
	name = "clamshell"
	icon_state = "clam_shell"

/obj/item/trash/mollusc_shell/barnacle
	name = "barnacle shell"
	icon_state = "barnacle_shell"

/obj/item/mollusc
	name = "mollusc"
	desc = "A small slimy mollusc. Fresh!"
	icon = 'icons/obj/molluscs.dmi'
	icon_state = "mollusc"
	w_class = ITEM_SIZE_TINY
	material = /decl/material/liquid/nutriment/slime_meat
	matter = list(
		/decl/material/solid/organic/bone/fish = MATTER_AMOUNT_SECONDARY,
	)
	var/meat_type = /obj/item/food/butchery/meat/fish/mollusc
	var/shell_type = /obj/item/trash/mollusc_shell

/obj/item/mollusc/barnacle
	name = "barnacle"
	desc = "A hull barnacle, probably freshly scraped off a spaceship."
	icon_state = "barnacle"
	meat_type = /obj/item/food/butchery/meat/fish/mollusc/barnacle
	shell_type = /obj/item/trash/mollusc_shell/barnacle

/obj/item/mollusc/clam
	name = "clam"
	desc = "A free-ranging space clam."
	icon_state = "clam"
	meat_type = /obj/item/food/butchery/meat/fish/mollusc/clam
	shell_type = /obj/item/trash/mollusc_shell/clam

// This is not a space clam...
/obj/item/mollusc/barnacle/fished
	desc = "A squat little barnacle, somehow pried from its perch."
/obj/item/mollusc/clam/fished
	desc = "A regular old bivalve. Full of secrets, probably."

// Subtype to avoid exploiting aquaculture to make infinite pearls.
/obj/item/mollusc/clam/fished/pearl/crack_shell(mob/user)
	. = ..()
	if(prob(10))
		to_chat(user, SPAN_NOTICE("You find a pearl!"))
		var/obj/item/stack/material/lump/pearl = new(get_turf(user), 1, /decl/material/solid/organic/bone/pearl)
		user.put_in_hands(pearl)

/obj/item/mollusc/proc/crack_shell(mob/user)
	playsound(loc, "fracture", 80, 1)
	if(user && loc == user)
		user.drop_from_inventory(src)
	if(meat_type)
		var/obj/item/meat = new meat_type(get_turf(src))
		if(user)
			user.put_in_hands(meat)
	if(shell_type)
		var/obj/item/shell = new shell_type(get_turf(src))
		if(user)
			user.put_in_hands(shell)
	qdel(src)

/obj/item/mollusc/attackby(var/obj/item/thing, var/mob/user)
	if(thing.sharp || thing.edge)
		user.visible_message(SPAN_NOTICE("\The [user] cracks open \the [src] with \the [thing]."))
		crack_shell(user)
		return
	. = ..()
