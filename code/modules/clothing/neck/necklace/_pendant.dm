/obj/item/pendant
	name                = "pendant"
	desc                = "A simple pendant."
	icon                = 'icons/clothing/accessories/jewelry/pendants/square.dmi'
	icon_state          = ICON_STATE_WORLD
	abstract_type       = /obj/item/pendant
	material            = /decl/material/solid/metal/silver
	material_alteration = MAT_FLAG_ALTERATION_COLOR // We do manual name/desc handling for the gem.

// I swear we had a proc for this on /obj/item?
/obj/item/pendant/set_material(new_material)
	. = ..()
	if(material)
		desc = "[desc] This one is made of [material.solid_name]."

/obj/item/pendant/update_name()
	var/list/name_comp = get_name_components()
	if(length(name_comp))
		SetName(jointext(name_comp, " "))

/obj/item/pendant/proc/get_name_components()
	. = list()
	if(name_prefix)
		. += name_prefix
	if(material)
		. += material.adjective_name
	. += base_name || initial(name)

/obj/item/pendant/proc/get_pendant_base_state(base_state)
	return base_state

/obj/item/pendant/proc/get_pendant_overlays(base_state)
	base_state = get_pendant_base_state(base_state)
	var/list/overlay_states = list((base_state) = get_color())
	for(var/decl/item_decoration/decoration as anything in decorations)
		overlay_states["[base_state]-[decoration.icon_state_modifier]"] = decoration.resolve_color(src)
	. = list()
	for(var/overlay_state in overlay_states)
		if(check_state_in_icon(overlay_state, icon))
			. += overlay_image(icon, overlay_state, overlay_states[overlay_state], RESET_COLOR)

// Subtypes below.
/obj/item/pendant/prism
	name        = "prism"
	desc        = "A large prism-shaped pendant that hangs from a clasp."
	icon        = 'icons/clothing/accessories/jewelry/pendants/crystal.dmi'
	material    = /decl/material/solid/gemstone/diamond

/obj/item/pendant/frill
	name        = "chain frill"
	icon        = 'icons/clothing/accessories/jewelry/pendants/frill.dmi'
	desc        = "A set of fine chain frills."
