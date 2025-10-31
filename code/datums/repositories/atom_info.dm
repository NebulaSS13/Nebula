var/global/repository/atom_info/atom_info_repository = new()

/repository/atom_info
	var/list/matter_cache =         list()
	var/list/combined_worth_cache = list()
	var/list/single_worth_cache =   list()
	var/list/name_cache =           list()
	var/list/description_cache =    list()
	var/list/matter_mult_cache =    list()
	var/list/origin_tech_cache =    list()

/repository/atom_info/proc/create_key_for(var/_path, var/_mat, var/_amount)
	. = "[_path]"
	if(ispath(_path, /obj) && _mat) // only objects take material as an arg
		. = "[.]-[_mat]"
	if(ispath(_path, /obj/item/stack) && !isnull(_amount)) // similarly for stacks and amount
		. = "[.]-[_amount]"

/repository/atom_info/proc/get_instance_of(var/_path, var/_mat, var/_amount)
	if(ispath(_path, /obj/item/stack))
		. = new _path(null, _amount, _mat)
	else if(ispath(_path, /obj))
		. = new _path(null, _mat)
	else
		. = new _path

/repository/atom_info/proc/update_cached_info_for(var/_path, var/_mat, var/_amount, var/key)
	var/atom/instance
	if(!matter_cache[key])
		instance = get_instance_of(_path, _mat, _amount)
		matter_cache[key] = instance.get_contained_matter() || list()
	if(!combined_worth_cache[key])
		instance = instance || get_instance_of(_path, _mat, _amount)
		combined_worth_cache[key] = instance.get_combined_monetary_worth()
	if(!single_worth_cache[key])
		instance = instance || get_instance_of(_path, _mat, _amount)
		single_worth_cache[key] = instance.get_single_monetary_worth()
	if(!name_cache[key])
		instance = instance || get_instance_of(_path, _mat, _amount)
		name_cache[key] = instance.name
	if(!description_cache[key])
		instance = instance || get_instance_of(_path, _mat, _amount)
		description_cache[key] = instance.desc
	if(!matter_mult_cache[key] && ispath(_path, /obj))
		var/obj/obj_instance = instance || get_instance_of(_path, _mat, _amount)
		matter_mult_cache[key] = obj_instance.get_matter_amount_modifier()
	if(!origin_tech_cache[key] && ispath(_path, /obj/item))
		var/obj/item/item_instance = instance || get_instance_of(_path, _mat, _amount)
		origin_tech_cache[key] = cached_json_decode(item_instance.get_origin_tech())
	if(!QDELETED(instance))
		qdel(instance)

/repository/atom_info/proc/get_matter_for(var/_path, var/_mat, var/_amount)
	RETURN_TYPE(/list)
	var/key = create_key_for(_path, _mat, _amount)
	update_cached_info_for(_path, _mat, _amount, key)
	. = matter_cache[key]

/repository/atom_info/proc/get_combined_worth_for(var/_path, var/_mat, var/_amount)
	var/key = create_key_for(_path, _mat, _amount)
	update_cached_info_for(_path, _mat, _amount, key)
	. = combined_worth_cache[key]

/repository/atom_info/proc/get_single_worth_for(var/_path, var/_mat, var/_amount)
	var/key = create_key_for(_path, _mat, _amount)
	update_cached_info_for(_path, _mat, _amount, key)
	. = single_worth_cache[key]

/repository/atom_info/proc/get_name_for(var/_path, var/_mat, var/_amount)
	var/key = create_key_for(_path, _mat, _amount)
	update_cached_info_for(_path, _mat, _amount, key)
	. = name_cache[key]

/repository/atom_info/proc/get_description_for(var/_path, var/_mat, var/_amount)
	var/key = create_key_for(_path, _mat, _amount)
	update_cached_info_for(_path, _mat, _amount, key)
	. = description_cache[key]

/repository/atom_info/proc/get_matter_multiplier_for(var/_path, var/_mat, var/_amount)
	var/key = create_key_for(_path, _mat, _amount)
	update_cached_info_for(_path, _mat, _amount, key)
	. = matter_mult_cache[key]

/repository/atom_info/proc/get_origin_tech_for(var/_path, var/_mat, var/_amount)
	var/key = create_key_for(_path, _mat, _amount)
	update_cached_info_for(_path, _mat, _amount, key)
	. = origin_tech_cache[key]