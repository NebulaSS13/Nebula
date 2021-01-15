/////////////////////////////////////////
//Material Rings
/obj/item/clothing/ring/material/set_material(var/new_material)
	. = ..()
	if(istype(material))
		name = "[material.solid_name] ring"
		desc = "A ring made from [material.solid_name]."
		color = material.color

/obj/item/clothing/ring/material/attackby(var/obj/item/S, var/mob/user)
	if(S.sharp)
		var/inscription = sanitize(input("Enter an inscription to engrave.", "Inscription") as null|text)
		if(!user.stat && !user.incapacitated() && user.Adjacent(src) && S.loc == user)
			if(!inscription)
				return
			desc = "A ring made from [material.solid_name]."
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
