// These values were reverse-engineered from Polaris, where they apparently
// took quite a lot of fiddling to get looking nice. Cheers to whoever did that.
/decl/bodytype
	var/list/scaling_adjustments_x = list(
		-0.095,
		-0.055,
		0,
		0.054,
		0.095,
	)
	var/list/scaling_adjustments_y = list(
		-0.085,
		-0.05,
		0,
		0.05,
		0.09,
	)

/decl/bodytype/validate()
	. = ..()

	if(scaling_adjustments_x)
		if(!islist(scaling_adjustments_x))
			. += "non-list value for width scaling modifiers"
		else if(length(scaling_adjustments_x) < 5)
			. += "insufficient scaling values for width scaling."
		else
			for(var/value in scaling_adjustments_x)
				if(!isnum(value))
					. += "non-numeric value in width scaling list: '[isnull(value) ? "NULL" : value]'"

	if(scaling_adjustments_y)
		if(!islist(scaling_adjustments_y))
			. += "non-list value for height scaling modifiers"
		else if(length(scaling_adjustments_y) < 5)
			. += "insufficient scaling values for height scaling."
		else
			for(var/value in scaling_adjustments_y)
				if(!isnum(value))
					. += "non-numeric value in width height list: '[isnull(value) ? "NULL" : value]'"

/mob/living/get_icon_scale_mult()
	. = ..()
	var/decl/bodytype/bodytype = get_bodytype()
	if(!LAZYLEN(appearance_descriptors) || !bodytype)
		return
	var/modify_x = 1
	var/modify_y = 1
	for(var/entry in appearance_descriptors)
		var/datum/appearance_descriptor/descriptor = bodytype.appearance_descriptors[entry]
		var/list/new_scale_info = descriptor.get_mob_scale_adjustments(get_bodytype(), appearance_descriptors[entry])
		if(length(new_scale_info))
			modify_x += new_scale_info[1]
			modify_y += new_scale_info[2]
	.[1] *= modify_x
	.[2] *= modify_y

/datum/appearance_descriptor/build/get_mob_scale_adjustments(decl/bodytype/bodytype, offset_value)
	. = list(0, 0)
	if(offset_value && length(bodytype?.scaling_adjustments_x) >= offset_value)
		.[1] += bodytype.scaling_adjustments_x[offset_value]

/datum/appearance_descriptor/height/get_mob_scale_adjustments(decl/bodytype/bodytype, offset_value)
	. = list(0, 0)
	if(length(bodytype?.scaling_adjustments_y) >= offset_value)
		.[2] += bodytype.scaling_adjustments_y[offset_value]
