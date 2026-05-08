/obj/item/salvage
	desc = "The remains of an unfortunate device."
	transform_animate_time = 0
	icon = 'icons/obj/modules/module_id.dmi'
	icon_state = ICON_STATE_WORLD
	abstract_type = /obj/item/salvage
	var/work_skill = SKILL_DEVICES
	var/obj/item/salvaged_type
	var/list/repairs_required = list()
	var/do_rotation = TRUE

/obj/item/salvage/Initialize(var/ml, var/path)
	. = ..(ml)
	if(!ispath(salvaged_type, /obj/item))
		return INITIALIZE_HINT_QDEL
	// TODO: grab partial initial matter from the salvage type.
	if(do_rotation)
		icon_rotation = rand(-45, 45)
	name = "[pick("busted", "broken", "shattered", "scrapped")] [salvaged_type::name]"
	w_class = salvaged_type::w_class

	var/list/all_repair_options = get_repair_options()
	var/list/selected_options = list()
	for(var/opt_type in all_repair_options)
		var/decl/salvage_repair_option/opt = RESOLVE_TO_DECL(opt_type)
		if(istype(opt) && prob(opt.selection_prob))
			selected_options += opt
	if(!length(selected_options))
		selected_options += RESOLVE_TO_DECL(pick(all_repair_options))
	for(var/decl/salvage_repair_option/opt in selected_options)
		repairs_required += opt.create_salvage_requirement()

	update_icon()

/obj/item/salvage/proc/get_repair_options()
	return subtypesof(/decl/salvage_repair_option/material_sheet)

/obj/item/salvage/attackby(obj/item/used_item, mob/user)

	// Find an appropriate repair (finished or not)
	var/datum/salvage_repair_requirement/opt
	for(var/datum/salvage_repair_requirement/rep in repairs_required)
		if(!istype(used_item, rep.repair_type))
			continue
		if(istype(used_item, /obj/item/stack/material) && !istype(used_item.material, rep.repair_material))
			continue
		if(!opt || (opt.repair_amount == 0 && rep.repair_amount > 0))
			opt = rep

	// Apply the repair.
	if(opt)
		if(opt.repair_amount <= 0)
			to_chat(user, SPAN_WARNING("\The [src] does not need further repair with \the [used_item]."))
		else if(user.do_skilled((5 + rand(10)) SECONDS, work_skill, src) && !QDELETED(opt) && opt.repair_amount > 0)
			if(istype(used_item, /obj/item/stack))
				var/obj/item/stack/stack = used_item
				var/use_amt = min(opt.repair_amount, stack.get_amount())
				stack.use(use_amt)
				opt.repair_amount -= use_amt
			else if(user.try_unequip(used_item))
				qdel(used_item)
				opt.repair_amount--
			// TODO: transfer material from the donor item to this item.
			check_repair_completion(user)
		return TRUE

	. = ..()

/obj/item/salvage/get_examine_hints(mob/user, distance, infix, suffix)
	. = ..()
	. += SPAN_NOTICE("It requires the following items to be fully repaired:")
	for(var/datum/salvage_repair_requirement/rep in repairs_required)
		if(rep.repair_amount <= 0)
			continue
		var/is_mat_stack = ispath(rep.repair_type, /obj/item/stack/material) && rep.repair_material
		var/obj/item/repair_type = rep.repair_type
		var/repair_thing = is_mat_stack ? atom_info_repository.get_name_for(repair_type, rep.repair_material) : atom_info_repository.get_name_for(repair_type)
		if(ispath(rep.repair_type, /obj/item/stack))
			var/obj/item/stack/stack = rep.repair_type
			repair_thing = rep.repair_amount == 1 ? stack::singular_name : stack::plural_name
			if(is_mat_stack)
				var/decl/material/repair_mat = GET_DECL(rep.repair_material)
				repair_thing = "[repair_mat.solid_name] [repair_thing]"
		else if(rep.repair_amount > 1)
			repair_thing = text_make_plural(repair_thing)
		. += SPAN_NOTICE("- [rep.repair_amount] [repair_thing]")

/obj/item/salvage/proc/check_repair_completion(mob/user)

	for(var/datum/salvage_repair_requirement/rep in repairs_required)
		if(rep.repair_amount > 0)
			if(user)
				to_chat(user, SPAN_NOTICE("You mend some of the damage to \the [src], but further repair is required."))
			return

	var/obj/item/created = new salvaged_type(get_turf(src))
	if(isitem(created))
		if(created.name_prefix)
			created.name_prefix = "[created.name_prefix] [pick("salvaged", "restored", "old", "worn")]" // enormous salvaged pipe wrench
		else
			created.name_prefix = pick("salvaged", "restored", "old", "worn") // salvaged laser rifle
		created.update_name()

	var/atom/created_loc = loc
	qdel(src)

	if(user)
		to_chat(user, SPAN_NOTICE("You finish repairing \the [created]!"))

	if(user && created_loc == user)
		user.put_in_hands(created)
	else
		created.forceMove(created_loc)

/obj/item/salvage/on_update_icon()
	SHOULD_CALL_PARENT(FALSE)
	if(!salvaged_type)
		return
	var/old_name = name
	var/old_desc = desc
	var/old_pixel_x = pixel_x
	var/old_pixel_y = pixel_y
	var/old_plane = plane
	var/old_layer = layer
	appearance = atom_info_repository.get_appearance_of(salvaged_type)
	name = old_name
	desc = old_desc
	pixel_x = old_pixel_x
	pixel_y = old_pixel_y
	plane = old_plane
	layer = old_layer
	update_transform()
