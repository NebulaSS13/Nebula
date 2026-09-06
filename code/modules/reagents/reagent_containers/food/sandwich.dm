/obj/item/food/slice/bread/attackby(obj/item/used_item, mob/user)

	if(istype(used_item,/obj/item/shard) || istype(used_item,/obj/item/food))
		var/obj/item/food/csandwich/S = new()
		S.dropInto(loc)
		S.attackby(used_item,user)
		qdel(src)
		return TRUE
	return ..()

/obj/item/food/csandwich
	name = "sandwich"
	desc = "The best thing since sliced bread."
	icon = 'icons/obj/food/baked/bread/slices/plain.dmi'
	plate = /obj/item/plate
	bitesize = 2

	var/list/ingredients = list()

/obj/item/food/csandwich/attackby(obj/item/used_item, mob/user)
	if(!istype(used_item, /obj/item/food) && !istype(used_item, /obj/item/shard))
		return ..()

	var/sandwich_limit = 4
	for(var/obj/item/O in ingredients)
		if(istype(O,/obj/item/food/slice/bread))
			sandwich_limit += 4

	if(src.contents.len > sandwich_limit)
		to_chat(user, "<span class='warning'>If you put anything else on \the [src] it's going to collapse.</span>")
		return TRUE
	if(istype(used_item,/obj/item/shard))
		if(!user.try_unequip(used_item, src))
			return TRUE
		to_chat(user, "<span class='warning'>You hide [used_item] in \the [src].</span>")
		update_icon()
		return TRUE
	else if(istype(used_item,/obj/item/food))
		if(!user.try_unequip(used_item, src))
			return TRUE
		to_chat(user, "<span class='warning'>You layer [used_item] over \the [src].</span>")
		var/obj/item/chems/F = used_item
		F.reagents.trans_to_obj(src, REAGENT_TOTAL_VOLUME(F.reagents))
		ingredients += used_item
		update_icon()
		return TRUE
	return FALSE // This shouldn't ever happen but okay.

/obj/item/food/csandwich/on_update_icon()
	. = ..()

	var/fullname = "" //We need to build this from the contents of the var.
	var/i = 0
	var/image/I
	for(var/obj/item/food/O in ingredients)

		i++
		if(i == 1)
			fullname += "[O.name]"
		else if(i == ingredients.len)
			fullname += " and [O.name]"
		else
			fullname += ", [O.name]"

		I = image(icon, "[icon_state]_filling")
		I.color = O.filling_color
		I.pixel_x = pick(list(-1,0,1))
		I.pixel_y = (i*2)+1
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

	I = image(icon, "[icon_state]_top")
	I.pixel_x = pick(list(-1,0,1))
	I.pixel_y = (ingredients.len * 2)+1
	add_overlay(I)

	SetName(lowertext("[fullname] sandwich"))
	if(length(name) > 80) SetName("[pick(list("absurd","colossal","enormous","ridiculous"))] sandwich")
	w_class = ceil(clamp((ingredients.len/2),2,4))

/obj/item/food/csandwich/Destroy()
	for(var/obj/item/O in ingredients)
		qdel(O)
	return ..()

/obj/item/food/csandwich/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..(user)
	var/obj/item/O = pick(contents)
	. += SPAN_WARNING("You think you can see [O.name] in there.")

/obj/item/food/csandwich/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	var/obj/item/shard = locate() in get_contained_external_atoms() // grab early in case of qdele
	. = ..()
	if(. && target == user)
		//This needs a check for feeding the food to other people, but that could be abusable.
		if(shard)
			to_chat(target, SPAN_DANGER("You lacerate yourself on \a [shard] in \the [src]!"))
			target.take_damage(5) //TODO: Target head if human.
