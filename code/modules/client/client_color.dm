/datum/client_color
	var/client_color = "" //Any client.color-valid value
	var/priority = 1 //Since only one client.color can be rendered on screen, we take the one with the highest priority value:
	//eg: "Bloody screen" > "goggles color" as the former is much more important
	var/override = FALSE //If set to override we will stop multiplying the moment we get here. NOTE: Priority remains, if your override is on position 4, the other 3 will still have a say.
	var/list/wire_colour_substitutions // used for swapping the names/fonts of colours in the hacking panel.

/mob
	var/list/client_colors = list()



/*
	Adds an instance of color_type to the mob's client_colors list
	color_type - a typepath (subtyped from /datum/client_color)
*/
/mob/proc/has_client_color(color_type)
	if(!ispath(/datum/client_color) || !LAZYLEN(client_colors))
		return FALSE
	for(var/thing in client_colors)
		var/datum/client_color/col = thing
		if(col.type == color_type)
			return TRUE
	return FALSE

/mob/proc/add_client_color(color_type)
	if(!has_client_color(color_type))
		var/datum/client_color/CC = new color_type()
		client_colors |= CC
		sortTim(client_colors, /proc/cmp_clientcolor_priority)
		update_client_color()


/*
	Removes an instance of color_type from the mob's client_colors list
	color_type - a typepath (subtyped from /datum/client_color)
	returns true if instance was found, false otherwise
*/
/mob/proc/remove_client_color(color_type)
	if(!ispath(/datum/client_color))
		return FALSE

	var/result = FALSE
	for(var/cc in client_colors)
		var/datum/client_color/CC = cc
		if(CC.type == color_type)
			result = TRUE
			client_colors -= CC
			qdel(CC)
			break
	update_client_color()
	return result


/*
	Resets the mob's client.color to null, and then sets it to the highest priority
	client_color datum, if one exists
*/
/mob/proc/update_client_color()
	if(!client)
		return
	client.color = null
	if(!client_colors.len)
		return
	var/list/c = list(1,0,0, 0,1,0, 0,0,1) //Star at normal
	for(var/datum/client_color/CC in client_colors)
		//Matrix multiplication newcolor * current
		var/list/current = c.Copy()

		for(var/m = 1; m <= 3; m += 1) //For each row
			for(var/i = 1; i <= 3; i += 1) //go over each column of the second matrix
				var/sum = 0
				for(var/j = 1; j <= 3; j += 1) //multiply each pair
					sum += CC.client_color[(m-1)*3 + j] * current[(j-1)*3 + i]

				c[(m-1)*3 + i] = sum

		if(CC.override)
			break

	animate(client, color = c)
