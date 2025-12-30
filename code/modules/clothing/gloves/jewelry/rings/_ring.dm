/obj/item/clothing/gloves/ring
	name                     = "ring"
	icon                     = 'icons/clothing/accessories/jewelry/rings/ring_band.dmi'
	desc                     = null
	w_class                  = ITEM_SIZE_TINY
	gender                   = NEUTER
	material                 = /decl/material/solid/metal/silver
	material_alteration      = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_DESC // We handle name manually
	sprite_sheets            = null
	var/use_material_name    = TRUE
	var/can_fit_under_gloves = TRUE
	var/can_inscribe         = TRUE
	var/inscription

/obj/item/clothing/gloves/ring/get_decoration_icon(default_icon, obj/item/thing, on_mob = FALSE)
	if(!on_mob && istype(thing, /obj/item/gemstone))
		return thing.icon
	return ..()

/obj/item/clothing/gloves/ring/update_name()
	var/list/name_comp = list()
	if(name_prefix)
		name_comp += name_prefix
	if(use_material_name)
		var/obj/item/gemstone/gem = locate() in contents
		if(gem)
			name_comp += gem.name
		if(material)
			name_comp += material.adjective_name
	name_comp += base_name || initial(name)
	SetName(jointext(name_comp, " "))

/obj/item/clothing/gloves/ring/set_material(var/new_material)
	. = ..()
	update_desc()

// To avoid clobbering custom loadout descriptions.
/obj/item/clothing/gloves/ring/set_custom_desc(new_desc)
	base_desc = new_desc
	update_desc()

/obj/item/clothing/gloves/ring/proc/update_desc()
	if(istype(material) && (material_alteration & MAT_FLAG_ALTERATION_DESC))
		desc = "A ring made from [material.solid_name]."
	if(inscription)
		desc += "<br>Written on \the [src] is the inscription \"[inscription]\""
	if(base_desc)
		desc = "[base_desc] [desc]"

/obj/item/clothing/gloves/ring/attackby(var/obj/item/used_item, var/mob/user)
	if(can_inscribe && used_item.is_sharp() && user.check_intent(I_FLAG_HELP))
		var/new_inscription = sanitize(input("Enter an inscription to engrave.", "Inscription") as null|text)
		if(user.stat || !user.incapacitated() || !user.Adjacent(src) || used_item.loc != user)
			return TRUE
		if(!new_inscription)
			return TRUE
		to_chat(user, SPAN_WARNING("You carve \"[new_inscription]\" into \the [src]."))
		inscription = new_inscription
		update_desc()
		return TRUE
	return ..()

/obj/item/clothing/gloves/ring/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["examine"])
		if(istype(user))
			var/mob/living/human/H = get_recursive_loc_of_type(/mob/living/human)
			if(H.Adjacent(user))
				user.examine_verb(src)
				return TOPIC_HANDLED
	return ..()

/obj/item/clothing/gloves/ring/get_examine_line()
	. = ..()
	. += " <a href='byond://?src=\ref[src];examine=1'>\[View\]</a>"

// Craftable subtypes.
/obj/item/clothing/gloves/ring/thin
	name_prefix = "thin"
	icon        = 'icons/clothing/accessories/jewelry/rings/ring_band_thin.dmi'

/obj/item/clothing/gloves/ring/thick
	name_prefix = "thick"
	icon        = 'icons/clothing/accessories/jewelry/rings/ring_band_thick.dmi'

/obj/item/clothing/gloves/ring/split
	name_prefix = "split"
	icon        = 'icons/clothing/accessories/jewelry/rings/ring_band_split.dmi'

// Material subtypes for mapping etc.
/obj/item/clothing/gloves/ring/wood
	material = /decl/material/solid/organic/wood/walnut

/obj/item/clothing/gloves/ring/plastic
	material = /decl/material/solid/organic/plastic

/obj/item/clothing/gloves/ring/steel
	material = /decl/material/solid/metal/steel

/obj/item/clothing/gloves/ring/silver
	material = /decl/material/solid/metal/silver

/obj/item/clothing/gloves/ring/gold
	material = /decl/material/solid/metal/gold

/obj/item/clothing/gloves/ring/platinum
	material = /decl/material/solid/metal/platinum

/obj/item/clothing/gloves/ring/bronze
	material = /decl/material/solid/metal/bronze

/obj/item/clothing/gloves/ring/glass
	material = /decl/material/solid/glass

/obj/item/clothing/gloves/ring/random/Initialize(ml, material_key)
	material_key = pick(global.random_jewellery_material_types)
	decorations  = list(pick(global.random_jewellery_gem_types))
	. = ..()
