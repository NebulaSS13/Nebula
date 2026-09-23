/obj/structure/crystal
	name = "crystal formation"
	density = TRUE
	material = /decl/material/solid/gemstone/crystal
	abstract_type = /obj/structure/crystal
	icon = 'icons/obj/structures/crystals/crystal.dmi'
	icon_state = "crystal"
	material_alteration = MAT_FLAG_ALTERATION_ALL
	show_painted = FALSE
	hitsound = "shatter"
	max_health = 20
	alpha = 180

	var/base_state
	var/has_shadow = TRUE

/obj/structure/crystal/drop_dismantled_matter(decl/material/drop_material)

	var/static/shard_matter = null
	if(isnull(shard_matter))
		shard_matter = 0
		var/list/matter_for_product = atom_info_repository.get_matter_for(/obj/item/shard)
		for(var/mat in matter_for_product)
			shard_matter += matter_for_product[mat]

	if(shard_matter == 0)
		return // Avoid div by zero, but also this should never happen.

	var/amount_to_drop = round((matter[drop_material.type] / shard_matter) * RAND_F(0.5, 0.75))
	if(amount_to_drop <= 0)
		return

	for(var/i = 1 to amount_to_drop)
		LAZYADD(., new /obj/item/shard(loc, drop_material?.type))

/obj/structure/crystal/physically_destroyed(skip_qdel)
	visible_message(SPAN_DANGER("\The [src] shatters!"))
	. = ..()

/obj/structure/crystal/proc/get_random_colours()
	return null

/obj/structure/crystal/proc/get_random_states()
	return null

/obj/structure/crystal/Initialize()
	. = ..()

	var/list/possible_states = get_random_states()
	if(length(possible_states))
		base_state = pick(possible_states)
	else
		base_state = icon_state

	var/list/possible_colors = get_random_colours()
	if(length(possible_colors))
		set_color(pick(possible_colors))

	set_light(3, 3, paint_color)
	update_icon()

/obj/structure/crystal/on_update_icon()
	. = ..()
	if(base_state)
		icon_state = base_state
	if(has_shadow)
		add_overlay(overlay_image(icon, "[icon_state]_shadow", COLOR_WHITE, RESET_COLOR))

// Ice crystal!
/obj/structure/crystal/ice
	desc = "A large crystalline ice formation."
	material = /decl/material/liquid/water
	paint_color = "#c4ffff"

/obj/structure/crystal/ice/get_random_colours()
	return null

// Lava crystal!
/obj/structure/crystal/lava
	name = "magma crystal formation"
	desc = "A large crystalline formation found near extreme heat."
	paint_color = "#fccf64"
	material = /decl/material/solid/stone/basalt
	material_alteration = MAT_FLAG_ALTERATION_COLOR

/obj/structure/crystal/lava/get_random_colours()
	var/static/list/crystal_colors = list("#e03131", "#fccf64", "#fccf64")
	return crystal_colors

// Random colourful crystal!
/obj/structure/crystal/random/get_random_colours()
	var/static/list/crystal_colours = list(
		"#ff0000",
		"#ff7f00",
		"#ffff00",
		"#00ff00",
		"#0000ff",
		"#4b0082",
		"#8f00ff"
	)
	return crystal_colours
