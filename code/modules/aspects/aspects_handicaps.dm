/decl/aspect/handicap
	category = "Handicaps"
	aspect_cost = -1
	aspect_flags = ASPECTS_PHYSICAL

/decl/aspect/handicap/impaired_vision
	name = "Poor Eyesight"
	desc = "Your vision is somewhat impaired, and you need prescription glasses to see clearly."
	incompatible_with = list(/decl/aspect/prosthetic_organ/eyes)

/decl/aspect/handicap/impaired_vision/apply(mob/living/holder)
	. = ..()
	if(.)
		holder.add_genetic_condition(GENE_COND_NEARSIGHTED)
		var/equipped = holder.equip_to_slot_or_del(new /obj/item/clothing/glasses/prescription(holder), slot_glasses_str)
		if(equipped)
			var/obj/item/clothing/glasses/G = holder.get_equipped_item(slot_glasses_str)
			if(istype(G))
				G.prescription = 7

/decl/aspect/handicap/colourblind
	name = "Deuteranopia"
	desc = "You have a type of red-green colour blindness, and cannot properly perceive the colour green."
	incompatible_with = list(
		/decl/aspect/prosthetic_organ/eyes,
		/decl/aspect/handicap/colourblind/protanopia,
		/decl/aspect/handicap/colourblind/tritanopia,
		/decl/aspect/handicap/colourblind/achromatopsia,
	)
	var/client_color = /datum/client_color/deuteranopia

/decl/aspect/handicap/colourblind/apply(mob/living/holder)
	. = ..()
	if(. && ispath(client_color, /datum/client_color))
		holder.add_client_color(client_color)

/decl/aspect/handicap/colourblind/protanopia
	name = "Protanopia"
	desc = "You have a type of red-green colour blindness, and cannot properly perceive the colour red."
	incompatible_with = list(
		/decl/aspect/prosthetic_organ/eyes,
		/decl/aspect/handicap/colourblind/tritanopia,
		/decl/aspect/handicap/colourblind/achromatopsia,
		/decl/aspect/handicap/colourblind
	)
	client_color = /datum/client_color/protanopia

/decl/aspect/handicap/colourblind/tritanopia
	name = "Tritanopia"
	desc = "You have a rare type of colour blindness, and cannot properly perceive the colour blue."
	incompatible_with = list(
		/decl/aspect/prosthetic_organ/eyes,
		/decl/aspect/handicap/colourblind/protanopia,
		/decl/aspect/handicap/colourblind/achromatopsia,
		/decl/aspect/handicap/colourblind
	)
	client_color = /datum/client_color/tritanopia

/decl/aspect/handicap/colourblind/achromatopsia
	name = "Achromatopsia"
	desc = "You have a rare type of colour blindness, and cannot properly perceive colour."
	incompatible_with = list(
		/decl/aspect/prosthetic_organ/eyes,
		/decl/aspect/handicap/colourblind/protanopia,
		/decl/aspect/handicap/colourblind/tritanopia,
		/decl/aspect/handicap/colourblind
	)
	client_color = /datum/client_color/achromatopsia
