// Items that provide animal feed.
/datum/storage/haystack
	can_hold = list(/obj/item/food/hay)

// Not actually a food item, but you can eat it if you like.
/obj/item/food/hay
	name                = "handful of hay"
	icon                = 'icons/obj/food/hay.dmi'
	icon_state          = ICON_STATE_WORLD
	material            = /decl/material/solid/organic/plantmatter/grass/dry
	nutriment_amt       = 1
	nutriment_type      = /decl/material/solid/organic/plantmatter/grass
	material_alteration = MAT_FLAG_ALTERATION_COLOR

/obj/item/food/hay/end_throw()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(check_self_destroy)), 1, (TIMER_UNIQUE | TIMER_OVERRIDE) )

/obj/item/food/hay/proc/check_self_destroy()
	if(isturf(loc) && !QDELETED(src))
		physically_destroyed()

/obj/item/food/hay/physically_destroyed()
	new /obj/effect/decal/cleanable/hay(loc)
	. = ..()

/obj/effect/decal/cleanable/hay
	name                = "loose hay"
	desc                = "Some loose hay from a haybale."
	icon                = 'icons/effects/hay.dmi'
	icon_state          = ICON_STATE_WORLD
	color               = /decl/material/solid/organic/plantmatter/grass/dry::color
	sweepable           = TRUE

/obj/effect/decal/cleanable/hay/Initialize(ml, _age)
	for(var/obj/effect/decal/cleanable/hay/hay in loc)
		if(hay != src)
			return INITIALIZE_HINT_QDEL
	return ..()

/obj/structure/haystack
	name                = "haystack"
	desc                = "A pile of dry, prickly hay. Not a great place for storing needles."
	icon                = 'icons/obj/structures/haystack.dmi'
	icon_state          = ICON_STATE_WORLD
	material            = /decl/material/solid/organic/plantmatter/grass/dry
	color               = /decl/material/solid/organic/plantmatter/grass/dry::color
	storage             = /datum/storage/haystack
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	atom_flags          = ATOM_FLAG_CLIMBABLE
	var/const/FOOD_MAX  = 20

/obj/structure/haystack/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	for(var/i = 1 to FOOD_MAX)
		new /obj/item/food/hay(src)
	storage.make_exact_fit()

/obj/structure/haystack/Exited(atom/movable/am, atom/new_loc)
	. = ..()
	if(!QDELETED(src) && !length(contents))
		physically_destroyed()

/obj/structure/haystack/create_matter()
	matter = null // Haystack is almost a dummy item; the matter is the food inside.

/obj/structure/haystack/physically_destroyed(skip_qdel)
	new /obj/effect/decal/cleanable/hay(loc)
	. = ..()

/obj/structure/haystack/bale
	name                = "haybale"
	desc                = "A tight bundle of dry grass, probably set aside as animal feed."
	icon                = 'icons/obj/structures/haybale.dmi'
