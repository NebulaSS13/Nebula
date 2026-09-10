//var/list/mech_decals = (icon_states('icons/mecha/mech_decals.dmi')-list("template", "mask")))

/mob/living/exosuit/premade
	name = "impossible exosuit"
	desc = "It seems to be saying 'please let me die'."
	abstract_type = /mob/living/exosuit/premade
	icon = 'icons/mecha/mecha_preview.dmi'
	icon_state = "preview"
	pixel_x = 0
	pixel_y = 0
	var/decal
	var/decal_blend = BLEND_MULTIPLY

/mob/living/exosuit/premade/Initialize()

	// Reset our mapping helpers.
	default_pixel_x = -8
	default_pixel_y = 0
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	icon = null
	icon_state = null

	for(var/obj/item/mech_component/comp in list(arms, legs, head, body))
		if(decal)
			comp.decal = decal
		if(!isnull(decal_blend))
			comp.decal_blend = decal_blend
		comp.prebuild()

	if(!material)
		material = GET_DECL(/decl/material/solid/metal/steel)

	. = ..()

	spawn_mech_equipment()

/mob/living/exosuit/premade/proc/spawn_mech_equipment()
	install_system(new /obj/item/mech_equipment/light(src), HARDPOINT_HEAD)

/mob/living/exosuit/premade/random
	name = "mismatched exosuit"
	desc = "It seems to have been roughly thrown together and then spray-painted a single colour."

/mob/living/exosuit/premade/random/Initialize(mapload, var/obj/structure/heavy_vehicle_frame/source_frame, var/super_random = FALSE, var/using_boring_colours = FALSE)
	var/list/use_colours
	if(using_boring_colours)
		use_colours = list(
			COLOR_DARK_GRAY,
			COLOR_GRAY40,
			COLOR_DARK_BROWN,
			COLOR_GRAY,
			COLOR_RED_GRAY,
			COLOR_BROWN,
			COLOR_GREEN_GRAY,
			COLOR_BLUE_GRAY,
			COLOR_PURPLE_GRAY,
			COLOR_BEIGE,
			COLOR_PALE_GREEN_GRAY,
			COLOR_PALE_RED_GRAY,
			COLOR_PALE_PURPLE_GRAY,
			COLOR_PALE_BLUE_GRAY,
			COLOR_SILVER,
			COLOR_GRAY80,
			COLOR_OFF_WHITE,
			COLOR_GUNMETAL,
			COLOR_HULL,
			COLOR_TITANIUM,
			COLOR_DARK_GUNMETAL,
			COLOR_BRONZE,
			COLOR_BRASS
		)
	else
		use_colours = list(
			COLOR_NAVY_BLUE,
			COLOR_GREEN,
			COLOR_DARK_GRAY,
			COLOR_MAROON,
			COLOR_PURPLE,
			COLOR_VIOLET,
			COLOR_OLIVE,
			COLOR_BROWN_ORANGE,
			COLOR_DARK_ORANGE,
			COLOR_GRAY40,
			COLOR_SEDONA,
			COLOR_DARK_BROWN,
			COLOR_BLUE,
			COLOR_DEEP_SKY_BLUE,
			COLOR_LIME,
			COLOR_CYAN,
			COLOR_TEAL,
			COLOR_RED,
			COLOR_PINK,
			COLOR_ORANGE,
			COLOR_YELLOW,
			COLOR_GRAY,
			COLOR_RED_GRAY,
			COLOR_BROWN,
			COLOR_GREEN_GRAY,
			COLOR_BLUE_GRAY,
			COLOR_SUN,
			COLOR_PURPLE_GRAY,
			COLOR_BLUE_LIGHT,
			COLOR_RED_LIGHT,
			COLOR_BEIGE,
			COLOR_PALE_GREEN_GRAY,
			COLOR_PALE_RED_GRAY,
			COLOR_PALE_PURPLE_GRAY,
			COLOR_PALE_BLUE_GRAY,
			COLOR_LUMINOL,
			COLOR_SILVER,
			COLOR_GRAY80,
			COLOR_OFF_WHITE,
			COLOR_NT_RED,
			COLOR_BOTTLE_GREEN,
			COLOR_PALE_BTL_GREEN,
			COLOR_GUNMETAL,
			COLOR_MUZZLE_FLASH,
			COLOR_CHESTNUT,
			COLOR_BEASTY_BROWN,
			COLOR_WHEAT,
			COLOR_CYAN_BLUE,
			COLOR_LIGHT_CYAN,
			COLOR_PAKISTAN_GREEN,
			COLOR_HULL,
			COLOR_AMBER,
			COLOR_COMMAND_BLUE,
			COLOR_SKY_BLUE,
			COLOR_PALE_ORANGE,
			COLOR_CIVIE_GREEN,
			COLOR_TITANIUM,
			COLOR_DARK_GUNMETAL,
			COLOR_BRONZE,
			COLOR_BRASS,
			COLOR_INDIGO
		)

	var/mech_colour = super_random ? FALSE : pick(use_colours)
	if(!arms)
		var/armstype = pick(subtypesof(/obj/item/mech_component/manipulators))
		arms = new armstype(src)
		arms.color = mech_colour ? mech_colour : pick(use_colours)
	if(!legs)
		var/legstype = pick(subtypesof(/obj/item/mech_component/propulsion))
		legs = new legstype(src)
		legs.color = mech_colour ? mech_colour : pick(use_colours)
	if(!head)
		var/headtype = pick(subtypesof(/obj/item/mech_component/sensors))
		head = new headtype(src)
		head.color = mech_colour ? mech_colour : pick(use_colours)
	if(!body)
		var/bodytype = pick(subtypesof(/obj/item/mech_component/chassis))
		body = new bodytype(src)
		body.color = mech_colour ? mech_colour : pick(use_colours)
	. = ..()

// Used for spawning/debugging.
/mob/living/exosuit/premade/random/normal

/mob/living/exosuit/premade/random/boring/Initialize(mapload, var/obj/structure/heavy_vehicle_frame/source_frame)
	. = ..(mapload, source_frame, using_boring_colours = TRUE)

/mob/living/exosuit/premade/random/extra/Initialize(mapload, var/obj/structure/heavy_vehicle_frame/source_frame)
	. = ..(mapload, source_frame, super_random = TRUE)

/mob/living/simple_animal/mob_mimic/exosuit
	faction = "killbots"
	ai = /datum/mob_controller/aggressive
	abstract_type = /mob/living/simple_animal/mob_mimic/exosuit
	VAR_PRIVATE/static/alist/_mob_mimic_type_to_mech_overlays = alist()

/mob/living/simple_animal/mob_mimic/exosuit/update_mob_values()
	. = ..()
	SetName("autonomous [name]")
	desc += " This one seems to be running autonomously, with no pilot inside."

/mob/living/simple_animal/mob_mimic/exosuit/prepare_mimic(mob/living/mimic)
	if(!istype(mimic, /mob/living/exosuit))
		return
	var/mob/living/exosuit/mimech = mimic
	mimech.hatch_closed = TRUE
	mimech.power = MECH_POWER_ON
	mimech.update_icon()

/mob/living/simple_animal/mob_mimic/exosuit/handle_additional_mimic(mob/living/mimic)
	_mob_mimic_type_to_mech_overlays[mimic_mob] = mimic.overlays?.Copy()

/mob/living/simple_animal/mob_mimic/exosuit/on_update_icon()
	. = ..()
	cut_overlays()
	if(length(_mob_mimic_type_to_mech_overlays[mimic_mob]))
		set_overlays(_mob_mimic_type_to_mech_overlays[mimic_mob])
	compile_overlays()
