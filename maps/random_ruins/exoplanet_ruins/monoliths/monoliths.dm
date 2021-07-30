/datum/map_template/ruin/exoplanet/monolith
	name = "Monolith Ring"
	id = "planetsite_monoliths"
	description = "Bunch of monoliths surrounding an artifact."
	suffixes = list("monoliths/monoliths.dmm")
	cost = 1
	template_flags = TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_ALIEN

/obj/structure/monolith
	name = "monolith"
	desc = "An obviously artifical structure of unknown origin. The symbols '<font face='Shage'>DWNbTX</font>' are engraved on the base."
	icon = 'icons/obj/structures/monolith.dmi'
	icon_state = "jaggy1"
	layer = ABOVE_HUMAN_LAYER
	density = 1
	anchored = 1
	material = /decl/material/solid/metal/aliumium
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	z_flags = ZMM_MANGLE_PLANES
	var/active = 0

/obj/structure/monolith/Initialize()
	. = ..()
	icon_state = "jaggy[rand(1,4)]"
	if(global.using_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E))
			desc += "\nThere are images on it: [E.get_engravings()]"
	update_icon()

/obj/structure/monolith/on_update_icon()
	..()
	overlays.Cut()
	if(active)
		var/image/I = emissive_overlay(icon,"[icon_state]decor")
		I.appearance_flags = RESET_COLOR
		I.color = get_random_colour(0, 150, 255)
		overlays += I
		set_light(2, 0.3, I.color)

	var/turf/exterior/T = get_turf(src)
	if(istype(T))
		var/image/I = overlay_image(icon, "dugin", T.dirt_color, RESET_COLOR)
		overlays += I

/obj/structure/monolith/attack_hand(mob/user)
	visible_message("[user] touches \the [src].")
	if(global.using_map.use_overmap && istype(user,/mob/living/carbon/human))
		var/obj/effect/overmap/visitable/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E))
			var/mob/living/carbon/human/H = user
			if(!H.isSynthetic())
				playsound(src, 'sound/effects/zapbeep.ogg', 100, 1)
				active = 1
				update_icon()
				if(prob(70))
					to_chat(H, "<span class='notice'>As you touch \the [src], you suddenly get a vivid image - [E.get_engravings()]</span>")
				else
					to_chat(H, "<span class='warning'>An overwhelming stream of information invades your mind!</span>")
					var/vision = ""
					for(var/i = 1 to 10)
						vision += pick(E.actors) + " " + pick("killing","dying","gored","expiring","exploding","mauled","burning","flayed","in agony") + ". "
					to_chat(H, "<span class='danger'><font size=2>[uppertext(vision)]</font></span>")
					SET_STATUS_MAX(H, STAT_PARA, 2)
					H.set_hallucination(20, 100)
				return
	to_chat(user, "<span class='notice'>\The [src] is still.</span>")
	return ..()

/turf/simulated/floor/fixed/alium/ruin
	name = "ancient alien plating"
	desc = "This obviously wasn't made for your feet. Looks pretty old."
	initial_gas = null

/turf/simulated/floor/fixed/alium/ruin/Initialize()
	. = ..()
	if(prob(10))
		ChangeTurf(get_base_turf_by_area(src))