/proc/new_guid(var/sequential_id, var/key)
	var/variant_flag = rand(32768, 65535)
	if(key)
		var/datum/uniqueness_generator/id_sequential/sequential_generator = uniqueness_repository.generators[/datum/uniqueness_generator/id_sequential]
		variant_flag = sequential_generator.ids_by_key.Find(key)
	var/timeofday = num2hex(world.timeofday, 8)
	timeofday = "[copytext(timeofday, 1, 5)]-[copytext(timeofday, 5, 9)]"
	var/epoc = num2hex(world.realtime / 10, 8)
	var/variant = num2hex(min(variant_flag, 65535), 4)
	var/sequence = num2hex(sequential_id, 6)
	return "[epoc]-[timeofday]-[num2hex(rand(1, 255))][num2hex(rand(1, 255))]-[variant][sequence][num2hex(rand(1, 255))]"


/proc/guid_to_id(var/guid, var/key)
	return hex2num(copytext(guid,31,37))

/datum/uniqueness_generator/id_sequential/Generate(var/key, var/default_id = 100)
	var/sequential_id = ..(key, default_id)
	return new_guid(sequential_id, key)

