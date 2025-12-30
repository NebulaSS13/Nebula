/obj/item/shield/crafted
	slot_flags = SLOT_BACK
	base_block_chance = 60
	throw_speed = 10
	throw_range = 20
	w_class = ITEM_SIZE_HUGE
	origin_tech = @'{"materials":1}'
	abstract_type = /obj/item/shield/crafted
	icon_state = ICON_STATE_WORLD
	attack_verb = list("shoved", "bashed")
	_base_attack_force = 8
	max_health = 250
	material = /decl/material/solid/organic/wood/oak
	material_alteration = MAT_FLAG_ALTERATION_ALL
	var/wooden_icon
	var/decl/material/reinforcement_material = /decl/material/solid/metal/iron

/obj/item/shield/crafted/set_material(new_material)
	. = ..()
	if(wooden_icon)
		if(istype(material, /decl/material/solid/organic/wood))
			set_icon(wooden_icon)
		else
			set_icon(initial(icon))
		update_icon()

/obj/item/shield/crafted/Initialize(ml, material_key, reinf_material_key)
	if(reinf_material_key)
		reinforcement_material = reinf_material_key
	if(ispath(reinforcement_material))
		reinforcement_material = GET_DECL(reinforcement_material)
	LAZYSET(matter, reinforcement_material.type, MATTER_AMOUNT_REINFORCEMENT)
	. = ..()

/obj/item/shield/crafted/on_update_icon()
	. = ..()
	if(istype(reinforcement_material))
		add_overlay(overlay_image(icon, "[icon_state]-reinforcement", reinforcement_material.color, RESET_COLOR))
