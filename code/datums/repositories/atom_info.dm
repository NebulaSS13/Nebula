var/global/repository/atom_info/atom_info_repository = new()

/repository/atom_info
	var/list/matter_cache =         list()
	var/list/combined_worth_cache = list()
	var/list/single_worth_cache =   list()
	var/list/name_cache =           list()
	var/list/matter_mult_cache =    list()
	var/list/origin_tech_cache =    list()

/repository/atom_info/proc/create_key_for(var/path, var/material, var/amount)
	. = "[path]"
	if(material)
		. = "[.]-[material]"
	if(!isnull(amount))
		. = "[.]-[amount]"

/repository/atom_info/proc/get_instance_of(var/path, var/material, var/amount)
	if(ispath(path, /obj/item/stack))
		. = new path(null, amount, material)
	else if(ispath(path, /obj))
		. = new path(null, material)
	else
		. = new path

/repository/atom_info/proc/update_cached_info_for(var/path, var/material, var/amount, var/key)
	var/atom/instance
	if(!matter_cache[key])
		instance = get_instance_of(path, material, amount)
		matter_cache[key] = instance.get_contained_matter() || list()
	if(!combined_worth_cache[key])
		instance = instance || get_instance_of(path, material, amount)
		combined_worth_cache[key] = instance.get_combined_monetary_worth()
	if(!single_worth_cache[key])
		instance = instance || get_instance_of(path, material, amount)
		single_worth_cache[key] = instance.get_single_monetary_worth()
	if(!name_cache[key])
		instance = instance || get_instance_of(path, material, amount)
		name_cache[key] = instance.name
	if(!matter_mult_cache[key] && ispath(path, /obj))
		var/obj/obj_instance = instance || get_instance_of(path, material, amount)
		matter_mult_cache[key] = obj_instance.get_matter_amount_modifier()
	if(!origin_tech_cache[key] && ispath(path, /obj/item))
		var/obj/item/item_instance = instance || get_instance_of(path, material, amount)
		origin_tech_cache[key] = cached_json_decode(item_instance.get_origin_tech())
	if(!QDELETED(instance))
		qdel(instance)

/repository/atom_info/proc/get_matter_for(var/path, var/material, var/amount)
	RETURN_TYPE(/list)
	var/key = create_key_for(path, material, amount)
	update_cached_info_for(path, material, amount, key)
	. = matter_cache[key]

/repository/atom_info/proc/get_combined_worth_for(var/path, var/material, var/amount)
	var/key = create_key_for(path, material, amount)
	update_cached_info_for(path, material, amount, key)
	. = combined_worth_cache[key]

/repository/atom_info/proc/get_single_worth_for(var/path, var/material, var/amount)
	var/key = create_key_for(path, material, amount)
	update_cached_info_for(path, material, amount, key)
	. = single_worth_cache[key]

/repository/atom_info/proc/get_name_for(var/path, var/material, var/amount)
	var/key = create_key_for(path, material, amount)
	update_cached_info_for(path, material, amount, key)
	. = name_cache[key]

/repository/atom_info/proc/get_matter_multiplier_for(var/path, var/material, var/amount)
	var/key = create_key_for(path, material, amount)
	update_cached_info_for(path, material, amount, key)
	. = matter_mult_cache[key]

/repository/atom_info/proc/get_origin_tech_for(var/path, var/material, var/amount)
	var/key = create_key_for(path, material, amount)
	update_cached_info_for(path, material, amount, key)
	. = origin_tech_cache[key]