/datum/map_template/ruin/exoplanet/monolith
	name = "Monolith Ring"
	description = "Bunch of monoliths surrounding an artifact."
	suffixes = list("monoliths/monoliths.dmm")
	cost = 1
	template_flags = TEMPLATE_FLAG_NO_RUINS
	template_tags = TEMPLATE_TAG_ALIEN

/obj/structure/monolith
	name = "monolith"
	desc = "An obviously artifical structure of unknown origin. The symbols '<font face='Shage'>DWNbTX</font>' are engraved on the base."
	icon = 'icons/obj/structures/monolith.dmi'
	icon_state = "jaggy1"
	layer = ABOVE_HUMAN_LAYER
	density = TRUE
	anchored = TRUE
	material = /decl/material/solid/metal/aliumium
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	var/active = 0

/obj/structure/monolith/Initialize()
	. = ..()
	icon_state = "jaggy[rand(1,4)]"
	var/datum/planetoid_data/E = loc ? SSmapping.planetoid_data_by_z[z] : null
	if(istype(E))
		desc += "\nThere are images on it: [E.engraving_generator.generate_engraving_text()]"
	update_icon()

/obj/structure/monolith/on_update_icon()
	..()
	if(active)
		var/image/I = emissive_overlay(icon,"[icon_state]decor")
		I.appearance_flags = RESET_COLOR
		I.color = get_random_colour(0, 150, 255)
		z_flags |= ZMM_MANGLE_PLANES
		add_overlay(I)
		set_light(2, 0.3, I.color)
	else
		z_flags &= ~ZMM_MANGLE_PLANES

	var/turf/T = get_turf(src)
	if(istype(T))
		var/soil_color = T.get_soil_color()
		if(soil_color)
			var/image/I = overlay_image(icon, "dugin", soil_color, RESET_COLOR)
			add_overlay(I)

/obj/structure/monolith/attack_hand(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	visible_message("\The [user] touches \the [src].")

	if(!ishuman(user))
		to_chat(user, SPAN_NOTICE("\The [src] is still."))
		return TRUE

	var/datum/planetoid_data/E = SSmapping.planetoid_data_by_z[z]
	if(!istype(E))
		to_chat(user, SPAN_NOTICE("\The [src] is still."))
		return TRUE

	var/mob/living/human/H = user
	if(H.isSynthetic())
		to_chat(user, SPAN_NOTICE("\The [src] is still."))
		return TRUE

	playsound(src, 'sound/effects/zapbeep.ogg', 100, 1)
	active = 1
	update_icon()
	if(prob(70))
		to_chat(user, SPAN_NOTICE("As you touch \the [src], you suddenly get a vivid image - [E.engraving_generator.generate_engraving_text()]"))
		return TRUE

	to_chat(user, SPAN_DANGER("An overwhelming stream of information invades your mind!"))
	to_chat(user, SPAN_DANGER("<font size=2>[uppertext(E.engraving_generator.generate_violent_vision_text())]</font>"))
	SET_STATUS_MAX(user, STAT_PARA, 2)
	H.set_hallucination(20, 100)
	return TRUE

/turf/floor/fixed/alium/ruin
	name = "ancient alien plating"
	desc = "This obviously wasn't made for your feet. Looks pretty old."
	initial_gas = null

/obj/abstract/landmark/random_base_turf
	name = "random chance base turf"
	var/turf_prob = 10

/obj/abstract/landmark/random_base_turf/Initialize()
	..()
	if(isturf(loc) && prob(turf_prob))
		var/turf/my_turf = loc
		my_turf.ChangeTurf(get_base_turf_by_area(src))
	return INITIALIZE_HINT_QDEL
