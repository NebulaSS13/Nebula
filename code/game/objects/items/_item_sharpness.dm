/obj/item
	VAR_PROTECTED/sharp = FALSE
	VAR_PROTECTED/edge = FALSE

/obj/item/is_sharp()
	return sharp

/obj/item/has_edge()
	return edge

/obj/item/proc/set_edge(new_edge)
	if(edge != new_edge)
		edge = new_edge
		return TRUE
	return FALSE

/obj/item/proc/set_sharp(new_sharp)
	if(sharp != new_sharp)
		sharp = new_sharp
		return TRUE
	return FALSE
