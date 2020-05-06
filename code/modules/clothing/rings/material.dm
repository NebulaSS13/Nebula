/////////////////////////////////////////
//Material Rings
/obj/item/clothing/ring/material
	icon = 'icons/obj/clothing/obj_hands_ring.dmi'
	icon_state = "material"

/obj/item/clothing/ring/material/set_material(var/new_material)
	. = ..()
	if(istype(material))
		name = "[material.name] ring"
		desc = "A ring made from [material.name]."
		color = material.icon_colour

/obj/item/clothing/ring/material/attackby(var/obj/item/S, var/mob/user)
	if(S.sharp)
		var/inscription = sanitize(input("Enter an inscription to engrave.", "Inscription") as null|text)
		if(!user.stat && !user.incapacitated() && user.Adjacent(src) && S.loc == user)
			if(!inscription)
				return
			desc = "A ring made from [material.name]."
			to_chat(user, "<span class='warning'>You carve \"[inscription]\" into \the [src].</span>")
			desc += "<br>Written on \the [src] is the inscription \"[inscription]\""

/obj/item/clothing/ring/material/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["examine"])
		if(istype(user))
			var/mob/living/carbon/human/H = get_holder_of_type(src, /mob/living/carbon/human)
			if(H.Adjacent(user))
				user.examinate(src)
				return TOPIC_HANDLED

/obj/item/clothing/ring/material/get_examine_line()
	. = ..()
	. += " <a href='?src=\ref[src];examine=1'>\[View\]</a>"

/obj/item/clothing/ring/material/wood
	material = MAT_WALNUT
/obj/item/clothing/ring/material/plastic
	material = MAT_PLASTIC
/obj/item/clothing/ring/material/steel
	material = MAT_STEEL
/obj/item/clothing/ring/material/silver
	material = MAT_SILVER
/obj/item/clothing/ring/material/gold
	material = MAT_GOLD
/obj/item/clothing/ring/material/platinum
	material = MAT_PLATINUM
/obj/item/clothing/ring/material/bronze
	material = MAT_BRONZE
/obj/item/clothing/ring/material/glass
	material = MAT_GLASS
