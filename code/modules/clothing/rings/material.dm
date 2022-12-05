/////////////////////////////////////////
//Material Rings
/obj/item/clothing/ring/material
	name = "ring"
	material_alteration = MAT_FLAG_ALTERATION_ALL
	var/inscription

/obj/item/clothing/ring/material/update_material_desc(override_desc)
	. = ..()
	if(length(inscription))
		desc = "[desc] <br>Written on \the [src] is the inscription \"[inscription]\""

/obj/item/clothing/ring/material/attackby(var/obj/item/S, var/mob/user)
	if(S.sharp)
		inscription = sanitize(input("Enter an inscription to engrave.", "Inscription") as null|text)
		if(!user.stat && !user.incapacitated() && user.Adjacent(src) && S.loc == user)
			if(!inscription)
				return
			to_chat(user, SPAN_NOTICE("You carve \"[inscription]\" into \the [src]."))
			update_material_desc()

/obj/item/clothing/ring/material/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["examine"])
		if(istype(user))
			var/mob/living/carbon/human/H = get_recursive_loc_of_type(/mob/living/carbon/human)
			if(H.Adjacent(user))
				user.examinate(src)
				return TOPIC_HANDLED

/obj/item/clothing/ring/material/get_examine_line()
	. = ..()
	. += " <a href='?src=\ref[src];examine=1'>\[View\]</a>"

/obj/item/clothing/ring/material/wood
	material = /decl/material/solid/wood/walnut
/obj/item/clothing/ring/material/plastic
	material = /decl/material/solid/plastic
/obj/item/clothing/ring/material/steel
	material = /decl/material/solid/metal/steel
/obj/item/clothing/ring/material/silver
	material = /decl/material/solid/metal/silver
/obj/item/clothing/ring/material/gold
	material = /decl/material/solid/metal/gold
/obj/item/clothing/ring/material/platinum
	material = /decl/material/solid/metal/platinum
/obj/item/clothing/ring/material/bronze
	material = /decl/material/solid/metal/bronze
/obj/item/clothing/ring/material/glass
	material = /decl/material/solid/glass
