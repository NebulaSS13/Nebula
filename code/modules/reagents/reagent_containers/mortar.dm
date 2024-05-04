/obj/item/chems/glass/mortar
	name = "mortar"
	desc = "A hard, sturdy bowl used to hold organic matter for crushing."
	icon = 'icons/obj/items/chem/mortar.dmi'
	icon_state = ICON_STATE_WORLD
	volume = 40
	material = /decl/material/solid/stone/basalt
	material_alteration = MAT_FLAG_ALTERATION_ALL

// todo: generalize to use TOOL_PESTLE
/obj/item/chems/glass/mortar/attack_self(mob/user)
	var/list/contained_atoms = get_contained_external_atoms()
	var/obj/item/crushing_item = LAZYACCESS(contained_atoms, 1)
	if(crushing_item)
		crushing_item.dropInto(loc || get_turf(user))
		return TRUE
	return ..()

/obj/item/chems/glass/mortar/attackby(obj/item/using_item, mob/living/user)
	if((. = ..()))
		return
	if(!istype(using_item))
		return FALSE
	if(!CanPhysicallyInteract(user) || !user.check_dexterity(DEXTERITY_HOLD_ITEM))
		return TRUE
	var/list/contained_atoms = get_contained_external_atoms()
	var/obj/item/crushing_item = LAZYACCESS(contained_atoms, 1)
	var/decl/material/attacking_material = using_item.get_material()
	var/decl/material/crushing_material = crushing_item?.get_material()
	var/skill_factor = CLAMP01(1 + 0.3*(user.get_skill_value(SKILL_CHEMISTRY) - SKILL_EXPERT)/(SKILL_EXPERT - SKILL_MIN))
	if(!crushing_item)
		if(!using_item.reagents?.total_volume)
			to_chat(user, SPAN_NOTICE("\The [using_item] is not suitable for grinding."))
			return TRUE
		if(!user.try_unequip(using_item, src))
			return TRUE
		to_chat(user, SPAN_NOTICE("You add \the [using_item] to \the [src] for grinding."))
		return TRUE
	if(using_item.force <= 0 || !attacking_material || !crushing_material)
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
		if(!do_after(user, stamina_to_consume SECONDS))
			to_chat(user, SPAN_NOTICE("You stop grinding \the [crushing_item]."))
			return TRUE
		user.adjust_stamina(-stamina_to_consume)
		crushing_item.reagents.trans_to(src, crushing_item.reagents.total_volume, skill_factor)
		to_chat(user, SPAN_NOTICE("You finish grinding \the [crushing_item] with \the [using_item]."))
	QDEL_NULL(crushing_item)
	return TRUE