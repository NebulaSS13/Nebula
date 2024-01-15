/decl/config/num
	abstract_type = /decl/config/num
	config_flags = CONFIG_FLAG_NUM | CONFIG_FLAG_HAS_VALUE
	default_value = 0
	var/min_value = -(INFINITY)
	var/max_value = INFINITY
	var/rounding

/decl/config/num/sanitize_value()
	..()
	value = clamp(value, min_value, max_value)
	if(!isnull(rounding))
		value = round(value, rounding)

/decl/config/num/compare_values(value_one, value_two)
	if(!isnum(value_one) || !isnum(value_two) || !rounding)
		return ..(value_one, value_two)
	return abs(value_one - value_two) < rounding // epsilon compare due to floating point issues