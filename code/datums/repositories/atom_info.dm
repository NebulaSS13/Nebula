var/repository/atom_info/atom_info_repository = new()

/repository/atom_info
	var/list/matter_cache =         list()
	var/list/combined_worth_cache = list()
	var/list/single_worth_cache =   list()
	var/list/name_cache =           list()

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
		var/matter_list = instance.building_cost()
		if(istype(instance, /obj/item/ammo_magazine) || istype(instance, /obj/item/storage))
			for(var/obj/thing in instance)
				var/list/thing_matter = thing.building_cost()
				for(var/mat in thing_matter)
					matter_cache[mat] += thing_matter[mat] 
		matter_cache[key] = matter_list
	if(!combined_worth_cache[key])
		instance = instance || get_instance_of(path, material, amount)
		combined_worth_cache[key] = instance.get_combined_monetary_worth()
	if(!single_worth_cache[key])
		instance = instance || get_instance_of(path, material, amount)
		single_worth_cache[key] = instance.get_single_monetary_worth()
	if(!name_cache[key])
		instance = instance || get_instance_of(path, material, amount)
		name_cache[key] = instance.name
	if(!QDELETED(instance))
		qdel(instance)

/repository/atom_info/proc/get_matter_for(var/path, var/material, var/amount)
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
