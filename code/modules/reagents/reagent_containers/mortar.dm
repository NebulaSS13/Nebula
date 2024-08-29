/obj/item/chems/glass/mortar
	name = "mortar"
	desc = "A hard, sturdy bowl used to hold organic matter for crushing."
	icon = 'icons/obj/items/chem/mortar.dmi'
	icon_state = ICON_STATE_WORLD
	volume = 40
	material = /decl/material/solid/stone/basalt
	material_alteration = MAT_FLAG_ALTERATION_ALL
	storage = /datum/storage/hopper/mortar
	var/grinding = FALSE

// todo: generalize to use TOOL_PESTLE
/obj/item/chems/glass/mortar/attackby(obj/item/using_item, mob/living/user)
	if((. = ..()))
		return
	return try_grind(using_item, user)

/obj/item/chems/glass/mortar/proc/try_grind(obj/item/using_item, mob/living/user)
	if(!istype(using_item))
		return FALSE
	if(!CanPhysicallyInteract(user) || !user.check_dexterity(DEXTERITY_HOLD_ITEM))
		return TRUE
	if(grinding)
		to_chat(user, SPAN_WARNING("Something is already being crushed in \the [src]."))
		return TRUE
	var/list/contained_atoms = get_stored_inventory()
	var/obj/item/crushing_item = LAZYACCESS(contained_atoms, 1)
	var/decl/material/attacking_material = using_item.get_material()
	var/decl/material/crushing_material = crushing_item?.get_material()
	var/skill_factor = CLAMP01(1 + 0.3*(user.get_skill_value(SKILL_CHEMISTRY) - SKILL_EXPERT)/(SKILL_EXPERT - SKILL_MIN))
	if(using_item.get_attack_force(user) <= 0 || !attacking_material || !crushing_material)
		return TRUE
	if(attacking_material.hardness <= crushing_material.hardness)
		to_chat(user, SPAN_NOTICE("\The [using_item] is not hard enough to crush \the [crushing_item]."))
		return TRUE
	if(REAGENTS_FREE_SPACE(reagents) < crushing_item.reagents.total_volume)
		to_chat(user, SPAN_WARNING("\The [src] is too full to grind \the [crushing_item], it'd spill everywhere!"))
		return TRUE
	if(crushing_item.reagents?.total_volume) // if it has no reagents, skip all the fluff and destroy it instantly
		var/stamina_to_consume = max(crushing_item.reagents.total_volume * (1 + user.get_stamina_skill_mod()/2), 5)
		if(stamina_to_consume > 100) // TODO: add user.get_max_stamina()?
			to_chat(user, SPAN_WARNING("\The [crushing_item] is too large for you to grind in \the [src]!"))
			return TRUE
		if(user.get_stamina() < stamina_to_consume)
			to_chat(user, SPAN_WARNING("You are too tired to crush \the [crushing_item], take a break!"))
			return TRUE
		to_chat(user, SPAN_NOTICE("You start grinding \the [crushing_item] with \the [using_item]."))
		grinding = TRUE
		if(!do_after(user, stamina_to_consume SECONDS))
			to_chat(user, SPAN_NOTICE("You stop grinding \the [crushing_item]."))
			grinding = FALSE
			return TRUE
		grinding = FALSE
		if(QDELETED(crushing_item))
			return TRUE // already been ground!
		user.adjust_stamina(-stamina_to_consume)
		crushing_item.reagents.trans_to(src, crushing_item.reagents.total_volume, skill_factor)
		to_chat(user, SPAN_NOTICE("You finish grinding \the [crushing_item] with \the [using_item]."))
	QDEL_NULL(crushing_item)
	// If there's more to crush, try looping
	if(length(get_stored_inventory()) > 0)
		try_grind(using_item, user)
	return TRUE