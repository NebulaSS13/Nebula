/obj/effect/decal/cleanable/generic
	name               = "clutter"
	desc               = "Someone should clean that up."
	gender             = PLURAL
	icon               = 'icons/obj/objects.dmi'
	icon_state         = "shards"
	sweepable          = TRUE

/obj/effect/decal/cleanable/ash
	name               = "ashes"
	desc               = "Ashes to ashes, dust to dust, and into space."
	gender             = PLURAL
	icon               = 'icons/obj/objects.dmi'
	icon_state         = "ash"
	weather_sensitive  = FALSE
	sweepable          = TRUE
	burnable           = FALSE

/obj/effect/decal/cleanable/ash/attackby(obj/item/used_item, mob/user)
	if(ATOM_IS_OPEN_CONTAINER(used_item))
		if(REAGENTS_FREE_SPACE(used_item.reagents) <= 0)
			to_chat(user, SPAN_WARNING("\The [used_item] is full."))
		else
			used_item.add_to_reagents(/decl/material/solid/carbon/ashes, 20)
			user.visible_message(SPAN_NOTICE("\The [user] carefully scoops \the [src] into \the [used_item]."))
			qdel(src)
		return TRUE
	return ..()

/obj/effect/decal/cleanable/ash/attack_hand(var/mob/user)
	SHOULD_CALL_PARENT(FALSE)
	to_chat(user, SPAN_NOTICE("\The [src] sifts through your fingers."))
	var/turf/F = get_turf(src)
	if (istype(F))
		F.add_dirt(4)
	qdel(src)
	return TRUE

/obj/effect/decal/cleanable/flour
	name                   = "flour"
	desc                   = "It's still good. Four second rule!"
	gender                 = PLURAL
	icon                   = 'icons/effects/effects.dmi'
	icon_state             = "flour"
	use_legacy_persistence = TRUE
	sweepable              = TRUE

/obj/effect/decal/cleanable/cobweb
	name               = "cobweb"
	desc               = "Somebody should remove that."
	layer              = ABOVE_HUMAN_LAYER
	icon               = 'icons/effects/effects.dmi'
	icon_state         = "cobweb1"
	weather_sensitive  = FALSE
	sweepable          = TRUE

/obj/effect/decal/cleanable/molten_item
	name                   = "gooey grey mass"
	desc                   = "It looks like a melted... something."
	icon                   = 'icons/effects/molten_item.dmi'
	icon_state             = "molten"
	use_legacy_persistence = TRUE
	generic_filth          = TRUE
	weather_sensitive      = FALSE

/obj/effect/decal/cleanable/cobweb2
	name               = "cobweb"
	desc               = "Somebody should remove that."
	layer              = ABOVE_HUMAN_LAYER
	icon               = 'icons/effects/effects.dmi'
	icon_state         = "cobweb2"
	weather_sensitive  = FALSE
	sweepable          = TRUE

//Vomit (sorry)
/obj/effect/decal/cleanable/vomit
	name                   = "vomit"
	desc                   = "Gosh, how unpleasant."
	gender                 = PLURAL
	icon                   = 'icons/effects/vomit.dmi'
	icon_state             = "vomit_1"
	use_legacy_persistence = TRUE
	generic_filth          = TRUE
	chem_volume            = 30

/obj/effect/decal/cleanable/vomit/Initialize(ml, _age)
	random_icon_states = icon_states(icon)
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	. = ..()
	if(prob(75))
		set_rotation(pick(90, 180, 270))

/obj/effect/decal/cleanable/vomit/mapped/Initialize(ml, _age)
	. = ..()
	add_to_reagents(/decl/material/liquid/acid/stomach, rand(3,5))
	add_to_reagents(/decl/material/liquid/nutriment, rand(5,8))

/obj/effect/decal/cleanable/vomit/on_update_icon()
	. = ..()
	color = reagents?.get_color()

/obj/effect/decal/cleanable/vomit/Crossed(atom/movable/AM)
	. = ..()
	if(!QDELETED(src) && REAGENT_TOTAL_VOLUME(reagents) >= 1 && isliving(AM))
		var/mob/living/walker = AM
		walker.add_walking_contaminant(reagents, rand(2, 3))

/obj/effect/decal/cleanable/tomato_smudge
	name                   = "tomato smudge"
	desc                   = "It's red."
	icon                   = 'icons/effects/tomatodecal.dmi'
	icon_state             = "tomato_floor1"
	random_icon_states     = list("tomato_floor1", "tomato_floor2", "tomato_floor3")
	use_legacy_persistence = TRUE
	generic_filth          = TRUE

/obj/effect/decal/cleanable/egg_smudge
	name                   = "smashed egg"
	desc                   = "Seems like this one won't hatch."
	icon                   = 'icons/effects/tomatodecal.dmi'
	icon_state             = "smashed_egg1"
	random_icon_states     = list("smashed_egg1", "smashed_egg2", "smashed_egg3")
	use_legacy_persistence = TRUE
	generic_filth          = TRUE

/obj/effect/decal/cleanable/pie_smudge //honk
	name                   = "smashed pie"
	desc                   = "It's pie cream from a cream pie."
	icon                   = 'icons/effects/tomatodecal.dmi'
	icon_state             = "smashed_pie"
	random_icon_states     = list("smashed_pie")
	use_legacy_persistence = TRUE
	generic_filth          = TRUE

/obj/effect/decal/cleanable/fruit_smudge
	name                   = "smudge"
	desc                   = "Some kind of fruit smear."
	icon                   = 'icons/effects/blood.dmi'
	icon_state             = "mfloor1"
	random_icon_states     = list("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7")
	use_legacy_persistence = TRUE
	generic_filth          = TRUE

/obj/effect/decal/cleanable/champagne
	name               = "champagne"
	desc               = "Someone got a bit too excited."
	gender             = PLURAL
	icon               = 'icons/effects/effects.dmi'
	icon_state         = "fchampagne1"
	color              = COLOR_BRASS
	random_icon_states = list("fchampagne1", "fchampagne2", "fchampagne3", "fchampagne4")
