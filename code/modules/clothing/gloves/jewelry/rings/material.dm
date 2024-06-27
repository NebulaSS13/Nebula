/////////////////////////////////////////
//Material Rings
// TODO: Merge this into /obj/item/clothing/gloves/ring?
/obj/item/clothing/gloves/ring/material
	material_alteration = MAT_FLAG_ALTERATION_ALL

/obj/item/clothing/gloves/ring/material/set_material(var/new_material)
	. = ..()
	if(istype(material) && (material_alteration & MAT_FLAG_ALTERATION_DESC))
		desc = "A ring made from [material.solid_name]."

/obj/item/clothing/gloves/ring/material/attackby(var/obj/item/S, var/mob/user)
	if(S.sharp)
		var/inscription = sanitize(input("Enter an inscription to engrave.", "Inscription") as null|text)
		if(!user.stat && !user.incapacitated() && user.Adjacent(src) && S.loc == user)
			if(!inscription)
				return
			desc = "A ring made from [material.solid_name]."
			to_chat(user, "<span class='warning'>You carve \"[inscription]\" into \the [src].</span>")
			desc += "<br>Written on \the [src] is the inscription \"[inscription]\""

/obj/item/clothing/gloves/ring/material/OnTopic(var/mob/user, var/list/href_list)
	if(href_list["examine"])
		if(istype(user))
			var/mob/living/human/H = get_recursive_loc_of_type(/mob/living/human)
			if(H.Adjacent(user))
				user.examinate(src)
				return TOPIC_HANDLED

/obj/item/clothing/gloves/ring/material/get_examine_line()
	. = ..()
	. += " <a href='byond://?src=\ref[src];examine=1'>\[View\]</a>"

/obj/item/clothing/gloves/ring/material/wood
	material = /decl/material/solid/organic/wood/walnut
/obj/item/clothing/gloves/ring/material/plastic
	material = /decl/material/solid/organic/plastic
/obj/item/clothing/gloves/ring/material/steel
	material = /decl/material/solid/metal/steel
/obj/item/clothing/gloves/ring/material/silver
	material = /decl/material/solid/metal/silver
/obj/item/clothing/gloves/ring/material/gold
	material = /decl/material/solid/metal/gold
/obj/item/clothing/gloves/ring/material/platinum
	material = /decl/material/solid/metal/platinum
/obj/item/clothing/gloves/ring/material/bronze
	material = /decl/material/solid/metal/bronze
/obj/item/clothing/gloves/ring/material/glass
	material = /decl/material/solid/glass
