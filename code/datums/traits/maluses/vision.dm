/decl/trait/malus/impaired_vision
	name = "Poor Eyesight"
	description = "Your vision is somewhat impaired, and you need prescription glasses to see clearly."
	incompatible_with = list(/decl/trait/prosthetic_organ/eyes)
	/// The typepath of the glasses to give the holder.
	var/glasses_type = /obj/item/clothing/glasses/prescription

/decl/trait/malus/impaired_vision/apply_trait(mob/living/holder)
	. = ..()
	if(.)
		holder.add_genetic_condition(GENE_COND_NEARSIGHTED)
		var/equipped = holder.equip_to_slot_or_del(new glasses_type(holder), slot_glasses_str)
		if(equipped)
			var/obj/item/clothing/glasses/G = holder.get_equipped_item(slot_glasses_str)
			if(istype(G))
				G.prescription = 7

/decl/trait/malus/colourblind
	name = "Deuteranopia"
	description = "You have a type of red-green colour blindness, and cannot properly perceive the colour green."
	incompatible_with = list(
		/decl/trait/prosthetic_organ/eyes,
		/decl/trait/malus/colourblind/protanopia,
		/decl/trait/malus/colourblind/tritanopia,
		/decl/trait/malus/colourblind/achromatopsia,
	)
	var/client_color = /datum/client_color/deuteranopia

/decl/trait/malus/colourblind/apply_trait(mob/living/holder)
	. = ..()
	if(. && ispath(client_color, /datum/client_color))
		holder.add_client_color(client_color)

/decl/trait/malus/colourblind/protanopia
	name = "Protanopia"
	description = "You have a type of red-green colour blindness, and cannot properly perceive the colour red."
	incompatible_with = list(
		/decl/trait/prosthetic_organ/eyes,
		/decl/trait/malus/colourblind/tritanopia,
		/decl/trait/malus/colourblind/achromatopsia,
		/decl/trait/malus/colourblind
	)
	client_color = /datum/client_color/protanopia

/decl/trait/malus/colourblind/tritanopia
	name = "Tritanopia"
	description = "You have a rare type of colour blindness, and cannot properly perceive the colour blue."
	incompatible_with = list(
		/decl/trait/prosthetic_organ/eyes,
		/decl/trait/malus/colourblind/protanopia,
		/decl/trait/malus/colourblind/achromatopsia,
		/decl/trait/malus/colourblind
	)
	client_color = /datum/client_color/tritanopia

/decl/trait/malus/colourblind/achromatopsia
	name = "Achromatopsia"
	description = "You have a rare type of colour blindness, and cannot properly perceive colour."
	incompatible_with = list(
		/decl/trait/prosthetic_organ/eyes,
		/decl/trait/malus/colourblind/protanopia,
		/decl/trait/malus/colourblind/tritanopia,
		/decl/trait/malus/colourblind
	)
	client_color = /datum/client_color/achromatopsia
