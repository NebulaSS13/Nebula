/mob/living/carbon/human
	var/_eye_colour

// Bespoke getters/setters for stuff that should be handled by general sprite accessory cateories in the future.
// Head hair!
/mob/living/carbon/human/get_hairstyle()
	var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
	return head?.get_sprite_accessory_of_category(/decl/sprite_accessory/hair)

/mob/living/carbon/human/set_hairstyle(var/new_hairstyle, var/skip_update = FALSE)
	if((. = ..()))
		var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
		head.set_sprite_accessory(new_hairstyle, /decl/sprite_accessory/hair, get_hair_colour(), skip_update = TRUE)
		if(!skip_update)
			update_hair()

/mob/living/carbon/human/get_hair_colour()
	var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
	return head?.get_sprite_accessory_value(get_hairstyle())

/mob/living/carbon/human/set_hair_colour(var/new_color, var/skip_update = FALSE)
	if((. = ..()))
		var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
		head.set_sprite_accessory(get_hairstyle(), /decl/sprite_accessory/hair, new_color, skip_update = TRUE)
		if(!skip_update)
			update_hair()

// Facial hair!
/mob/living/carbon/human/get_facial_hairstyle()
	var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
	return head?.get_sprite_accessory_of_category(/decl/sprite_accessory/facial_hair)

/mob/living/carbon/human/set_facial_hairstyle(var/new_facial_hairstyle, var/skip_update = FALSE)
	if((. = ..()))
		var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
		head.set_sprite_accessory(new_facial_hairstyle, /decl/sprite_accessory/facial_hair, get_facial_hair_colour(), skip_update = TRUE)
		if(!skip_update)
			update_hair()

/mob/living/carbon/human/get_facial_hair_colour()
	var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
	return head?.get_sprite_accessory_value(get_facial_hairstyle())

/mob/living/carbon/human/set_facial_hair_colour(var/new_color, var/skip_update = FALSE)
	if((. = ..()))
		var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
		head.set_sprite_accessory(get_facial_hairstyle(), /decl/sprite_accessory/facial_hair, new_color, skip_update = TRUE)
		if(!skip_update)
			update_hair()

// Lips!
/mob/living/carbon/human/get_lip_style()
	var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
	return head?.get_sprite_accessory_of_category(/decl/sprite_accessory/lips)

/mob/living/carbon/human/set_lip_style(var/new_lip_style, var/skip_update = FALSE)
	if((. = ..()))
		var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
		head.set_sprite_accessory(new_lip_style, /decl/sprite_accessory/lips, get_lip_colour(), skip_update = TRUE)
		if(!skip_update)
			update_body()

/mob/living/carbon/human/get_lip_colour()
	var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
	return head?.get_sprite_accessory_value(get_lip_style())

/mob/living/carbon/human/set_lip_colour(var/new_color, var/skip_update = FALSE)
	if((. = ..()))
		var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
		head.set_sprite_accessory(get_lip_style(), /decl/sprite_accessory/lips, new_color, skip_update = TRUE)
		if(!skip_update)
			update_body()

// Eyes! TODO, make these a marking.
/mob/living/carbon/human/get_eye_colour()
	return _eye_colour

/mob/living/carbon/human/set_eye_colour(var/new_color, var/skip_update = FALSE)
	if((. = ..()))
		_eye_colour = new_color
		if(!skip_update)
			update_eyes()
			update_body()
