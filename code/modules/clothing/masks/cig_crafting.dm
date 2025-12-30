/obj/item/clothing/mask/smokable/cigarette/rolled
	name = "rolled cigarette"
	desc = "A hand rolled cigarette using dried plant matter."
	icon = 'icons/clothing/mask/smokables/cigarette_rollup.dmi'
	type_butt = /obj/item/trash/cigbutt
	chem_volume = 50
	brand = "handrolled"
	var/filter = 0

/obj/item/clothing/mask/smokable/cigarette/rolled/populate_reagents()
	return

/obj/item/clothing/mask/smokable/cigarette/rolled/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(filter)
		. += "\The [src] is capped off at one end with a filter."

/////////// //Ported Straight from TG. I am not sorry. - BloodyMan  //YOU SHOULD BE
//ROLLING//
///////////
/obj/item/paper/cig
	name = "rolling paper"
	desc = "A thin piece of paper used to make smokeables."
	icon = 'icons/obj/items/paperwork/cigarette_paper.dmi'
	icon_state = "cig_paper"
	w_class = ITEM_SIZE_TINY

/obj/item/paper/cig/on_update_icon()
	. = ..()
	icon_state = initial(icon_state)

/obj/item/paper/cig/fancy
	name = "\improper Trident rolling paper"
	desc = "A thin piece of Trident-branded paper used to make fine smokeables."
	icon = 'icons/obj/items/paperwork/cigarette_paper_fancy.dmi'

/obj/item/cigarette_filter
	name = "cigarette filter"
	desc = "A small nub like filter for cigarettes."
	icon = 'icons/obj/items/cigarette_filter.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_TINY

//tobacco sold seperately if you're too snobby to grow it yourself.
/obj/item/food/grown/dried_tobacco
	seed = "tobacco"
	w_class = ITEM_SIZE_TINY

/obj/item/food/grown/dried_tobacco/Initialize(mapload, material_key, skip_plate = FALSE)
	. = ..()
	dry = TRUE
	SetName("dried [name]")
	color = "#a38463"
/obj/item/food/grown/dried_tobacco/bad
	seed = "badtobacco"

/obj/item/food/grown/dried_tobacco/fine
	seed = "finetobacco"

/obj/item/clothing/mask/smokable/cigarette/rolled/attackby(obj/item/used_item, mob/user)
	if(!istype(used_item, /obj/item/cigarette_filter))
		return ..()
	if(filter)
		to_chat(user, "<span class='warning'>[src] already has a filter!</span>")
		return TRUE
	if(lit)
		to_chat(user, "<span class='warning'>[src] is lit already!</span>")
		return TRUE
	if(!user.try_unequip(used_item))
		return TRUE
	to_chat(user, "<span class='notice'>You stick [used_item] into \the [src]</span>")
	filter = 1
	SetName("filtered [name]")
	brand = "[brand] with a filter"
	update_icon()
	qdel(used_item)
	return TRUE
