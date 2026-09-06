/obj/item/blob_sample
	abstract_type = /obj/item/blob_sample
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_LARGE
	attack_verb = list("smacked", "smashed", "whipped")
	material = /decl/material/solid/organic/plantmatter

/obj/item/blob_sample/get_heat()
	. = max(..(), atom_damage_type == BURN ? 1000 : 0)

/obj/item/blob_sample/tendril
	name = "asteroclast tendril"
	desc = "A tendril removed from an asteroclast. It's entirely lifeless."
	icon = 'mods/content/blob/icons/blob_tendril.dmi'
	var/types_of_tendril = list("solid", "fire")

/obj/item/blob_sample/tendril/Initialize()
	. = ..()
	var/tendril_type = pick(types_of_tendril)
	switch(tendril_type)
		if("solid")
			desc = "An incredibly dense, yet flexible, tendril, removed from an asteroclast."
			set_base_attack_force(10)
			color = COLOR_BRONZE
			origin_tech = @'{"materials":2}'
		if("fire")
			desc = "A tendril removed from an asteroclast. It's hot to the touch."
			atom_damage_type = BURN
			set_base_attack_force(15)
			color = COLOR_AMBER
			origin_tech = @'{"powerstorage":2}'

/obj/item/blob_sample/tendril/afterattack(atom/target, mob/user, proximity)
	. = ..() // ensure we can heat things with it if it's a spicy tendril
	// don't return on parent success, we want to take damage either way
	if(!proximity)
		return
	if(prob(50)) // we only take damage half the time
		return
	set_base_attack_force(get_base_attack_force()-1)
	if(get_base_attack_force() <= 0)
		visible_message(SPAN_NOTICE("\The [src] crumbles apart!"))
		user.drop_from_inventory(src)
		new /obj/effect/decal/cleanable/ash(src.loc)
		qdel(src)

/obj/item/blob_sample/core
	name = "asteroclast nucleus sample"
	desc = "A sample taken from an asteroclast's nucleus. It pulses with energy."
	icon = 'mods/content/blob/icons/blob_core_sample.dmi'
	w_class = ITEM_SIZE_NORMAL
	origin_tech = @'{"materials":4,"wormholes":5,"biotech":7}'

/obj/item/blob_sample/core/aux
	name = "asteroclast auxiliary nucleus sample"
	desc = "A sample taken from an asteroclast's auxiliary nucleus."
	icon = 'mods/content/blob/icons/blob_aux_core_sample.dmi'
	origin_tech = @'{"materials":2,"wormholes":3,"biotech":4}'
