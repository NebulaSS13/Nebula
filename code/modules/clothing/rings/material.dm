/////////////////////////////////////////
//Material Rings
/obj/item/clothing/ring/material/Initialize()
	. = ..()
	var/decl/material/material = get_primary_material()
	if(material)
		name = "[material.solid_name] ring"
		desc = "A ring made from [material.solid_name]."
		color = material.color

/obj/item/clothing/ring/material/attackby(var/obj/item/S, var/mob/user)
	if(S.sharp)
		var/inscription = sanitize(input("Enter an inscription to engrave.", "Inscription") as null|text)
		if(!user.stat && !user.incapacitated() && user.Adjacent(src) && S.loc == user)
			if(!inscription)
				return
			var/decl/material/material = get_primary_material()
			if(material)
				desc = "A ring made from [material.solid_name]."
			else
				desc = initial(desc)
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
	material_composition = list(/decl/material/solid/wood/walnut = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/ring/material/plastic
	material_composition = list(/decl/material/solid/plastic = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/ring/material/steel
	material_composition = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/ring/material/silver
	material_composition = list(/decl/material/solid/metal/silver = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/ring/material/gold
	material_composition = list(/decl/material/solid/metal/gold = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/ring/material/platinum
	material_composition = list(/decl/material/solid/metal/platinum = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/ring/material/bronze
	material_composition = list(/decl/material/solid/metal/bronze = MATTER_AMOUNT_PRIMARY)
/obj/item/clothing/ring/material/glass
	material_composition = list(/decl/material/solid/glass = MATTER_AMOUNT_PRIMARY)
