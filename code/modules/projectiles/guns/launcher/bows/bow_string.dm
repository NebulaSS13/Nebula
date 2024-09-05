/obj/item/bowstring
	name = "bowstring"
	icon = 'icons/obj/fishing_line.dmi' // works well enough for the time being
	icon_state = ICON_STATE_WORLD
	desc = "A flexible length of material used to string bows."
	material = /decl/material/solid/organic/meat/gut
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_DESC
	max_health = 100
	w_class = ITEM_SIZE_SMALL

/obj/item/bowstring/Initialize()
	. = ..()
	if(material)
		max_health = max(1, round(initial(max_health) * material.tensile_strength))
		current_health = max_health

/obj/item/bowstring/Destroy()
	if(istype(loc, /obj/item/gun/launcher/bow))
		var/obj/item/gun/launcher/bow/bow = loc
		if(bow.string == src)
			bow.remove_string()
	return ..()

#define MAT_COLOR(MAT) \
	material = MAT;\
	color = MAT::color

/obj/item/bowstring/synthetic
	MAT_COLOR(/decl/material/solid/fiberglass)

/obj/item/bowstring/steel
	MAT_COLOR(/decl/material/solid/metal/steel)

/obj/item/bowstring/copper
	MAT_COLOR(/decl/material/solid/metal/copper)
#undef MAT_COLOR