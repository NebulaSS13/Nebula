/mob/living/carbon/human/get_icon_scale_mult()
	. = ..()
	if(LAZYLEN(descriptors))
		var/modify_x = 1
		var/modify_y = 1
		for(var/entry in descriptors)
			var/datum/mob_descriptor/descriptor = species.descriptors[entry]
			var/list/new_scale_info = descriptor.get_mob_scale_adjustments(descriptors[entry])
			if(length(new_scale_info))
				modify_x += new_scale_info[1]
				modify_y += new_scale_info[2]
		.[1] *= modify_x
		.[2] *= modify_y

/datum/mob_descriptor/height/get_mob_scale_adjustments(var/offset_value)
	. = list(0, 0)
	switch(offset_value)
		if(1)
			.[2] = -0.06
		if(2)
			.[2] = -0.03
		if(4)
			.[2] =  0.03
		if(5)
			.[2] =  0.06

/datum/mob_descriptor/build/get_mob_scale_adjustments(var/offset_value)
	. = list(0, 0)
	switch(offset_value)
		if(1)
			.[1] = -0.06
		if(2)
			.[1] = -0.03
		if(4)
			.[1] =  0.03
		if(5)
			.[1] =  0.06
