//*****************
//**Cham Jumpsuit**
//*****************

#define CHAMELEON_VERB(TYPE, VERB_NAME)\
##TYPE/verb/change(picked in disguise_choices){ \
	set name = VERB_NAME; \
	set category = "Chameleon Items"; \
	set src in usr; \
	if(usr.incapacitated()) return; \
	if(!ispath(disguise_choices[picked])) return; \
	disguise(disguise_choices[picked], usr); \
	update_clothing_icon(); \
}

/obj/item/proc/disguise(var/newtype, var/mob/user)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(user && CanPhysicallyInteract(user))
		return OnDisguise(atom_info_repository.get_instance_of(newtype), user)
	return FALSE

// Subtypes shall override this, not /disguise()
/obj/item/proc/OnDisguise(var/obj/item/copy, var/mob/user)
	. = istype(copy) && !QDELETED(copy)
	if(.)
		desc                 = copy.desc
		name                 = copy.name
		icon                 = copy.icon
		color                = copy.color
		icon_state           = copy.icon_state
		item_state           = copy.item_state
		body_parts_covered   = copy.body_parts_covered
		sprite_sheets        = copy.sprite_sheets?.Copy()
		flags_inv            = copy.flags_inv
		set_gender(copy.gender) // mostly for plural/neuter, e.g. "some prayer beads" versus "a necklace"

/proc/generate_chameleon_choices(var/basetype)
	. = list()

	var/types = islist(basetype) ? basetype : typesof(basetype)
	var/i = 1 //in case there is a collision with both name AND icon_state
	for(var/typepath in types)
		var/obj/item/I = typepath
		if(initial(I.icon) && initial(I.icon_state) && !(initial(I.item_flags) & ITEM_FLAG_INVALID_FOR_CHAMELEON))
			var/name = initial(I.name)
			if(name in .)
				name += " ([initial(I.icon_state)])"
			if(name in .)
				name += " \[[i++]\]"
			.[name] = typepath
	return sortTim(., /proc/cmp_text_asc)

/obj/item/clothing/pants/chameleon
	name = "grey slacks"
	desc = "Crisp grey slacks. Moderately formal. There's a small dial on the waistband."
	icon = 'icons/clothing/pants/slacks.dmi'
	origin_tech = @'{"esoteric":3}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	var/static/list/disguise_choices

/obj/item/clothing/pants/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		var/static/list/clothing_types = list(
			/obj/item/clothing/pants,
			/obj/item/clothing/skirt
		)
		disguise_choices = generate_chameleon_choices(clothing_types)

CHAMELEON_VERB(/obj/item/clothing/pants/chameleon, "Change Pants Appearance")

/obj/item/clothing/shirt/chameleon
	name = "dress shirt"
	desc = "A crisply pressed white button-up shirt. Somewhat formal. There's a small dial on the cuff."
	icon = 'icons/clothing/shirts/button_up.dmi'
	origin_tech = @'{"esoteric":3}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	var/static/list/disguise_choices

/obj/item/clothing/shirt/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		var/static/list/clothing_types = list(
			/obj/item/clothing/shirt
		)
		disguise_choices = generate_chameleon_choices(clothing_types)

CHAMELEON_VERB(/obj/item/clothing/shirt/chameleon, "Change Shirt Appearance")

//starts off as a jumpsuit
/obj/item/clothing/jumpsuit/chameleon
	name = "jumpsuit"
	icon = 'icons/clothing/jumpsuits/jumpsuit.dmi'
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	origin_tech = @'{"esoteric":3}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	bodytype_equip_flags = null
	var/static/list/disguise_choices

/obj/item/clothing/jumpsuit/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		var/static/list/clothing_types = list(
			/obj/item/clothing/jumpsuit,
			/obj/item/clothing/dress,
			/obj/item/clothing/costume
		)
		disguise_choices = generate_chameleon_choices(clothing_types)

CHAMELEON_VERB(/obj/item/clothing/jumpsuit/chameleon, "Change Jumpsuit Appearance")

//*****************
//**Chameleon Hat**
//*****************

/obj/item/clothing/head/chameleon
	name = "grey cap"
	desc = "It looks like a plain hat, but upon closer inspection, there's an advanced holographic array installed inside. It seems to have a small dial inside."
	icon = 'icons/clothing/head/softcap.dmi'
	origin_tech = @'{"esoteric":3}'
	body_parts_covered = 0
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	bodytype_equip_flags = null
	var/static/list/disguise_choices

/obj/item/clothing/head/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		disguise_choices = generate_chameleon_choices(/obj/item/clothing/head)

CHAMELEON_VERB(/obj/item/clothing/head/chameleon, "Change Hat/Helmet Appearance")

//******************
//**Chameleon Suit**
//******************

/obj/item/clothing/suit/chameleon
	name = "armor"
	icon = 'icons/clothing/suits/armor/vest.dmi'
	desc = "It appears to be a vest of standard armor, except this is embedded with a hidden holographic cloaker, allowing it to change its appearance, but offering no protection. It seems to have a small dial inside."
	origin_tech = @'{"esoteric":3}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	bodytype_equip_flags = null
	var/static/list/disguise_choices

/obj/item/clothing/suit/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		disguise_choices = generate_chameleon_choices(/obj/item/clothing/suit)

CHAMELEON_VERB(/obj/item/clothing/suit/chameleon, "Change Oversuit Appearance")

//*******************
//**Chameleon Shoes**
//*******************
/obj/item/clothing/shoes/chameleon
	name = "black shoes"
	icon = 'icons/clothing/feet/colored_shoes.dmi'
	desc = "They're comfy black shoes, with clever cloaking technology built-in. It seems to have a small dial on the back of each shoe."
	origin_tech = @'{"esoteric":3}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	bodytype_equip_flags = null
	var/static/list/disguise_choices

/obj/item/clothing/shoes/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		disguise_choices = generate_chameleon_choices(/obj/item/clothing/shoes)

CHAMELEON_VERB(/obj/item/clothing/shoes/chameleon, "Change Footwear Appearance")

//**********************
//**Chameleon Backpack**
//**********************
/obj/item/backpack/chameleon
	name = "backpack"
	desc = "A backpack outfitted with cloaking tech. It seems to have a small dial inside, kept away from the storage."
	origin_tech = @'{"esoteric":3}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	icon = 'icons/obj/items/storage/backpack/backpack.dmi'
	var/static/list/disguise_choices

/obj/item/backpack/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		disguise_choices = generate_chameleon_choices(/obj/item/backpack)

CHAMELEON_VERB(/obj/item/backpack/chameleon, "Change Backpack Appearance")

//********************
//**Chameleon Gloves**
//********************

/obj/item/clothing/gloves/chameleon
	name = "black gloves"
	icon_state = ICON_STATE_WORLD
	color = COLOR_GRAY40
	icon = 'icons/clothing/hands/gloves_generic.dmi'
	desc = "It looks like a pair of gloves, but it seems to have a small dial inside."
	origin_tech = @'{"esoteric":3}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	bodytype_equip_flags = null
	var/static/list/disguise_choices

/obj/item/clothing/gloves/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		disguise_choices = generate_chameleon_choices(/obj/item/clothing/gloves)

CHAMELEON_VERB(/obj/item/clothing/gloves/chameleon, "Change Gloves Appearance")

//******************
//**Chameleon Mask**
//******************

/obj/item/clothing/mask/chameleon
	name = "gas mask"
	icon = 'icons/clothing/mask/gas_mask_full.dmi'
	desc = "It looks like a plain gas mask, but on closer inspection, it seems to have a small dial inside."
	origin_tech = @'{"esoteric":3}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	bodytype_equip_flags = null
	var/static/list/disguise_choices

/obj/item/clothing/mask/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		disguise_choices = generate_chameleon_choices(/obj/item/clothing/mask)

CHAMELEON_VERB(/obj/item/clothing/mask/chameleon, "Change Mask Appearance")

//*********************
//**Chameleon Glasses**
//*********************

/obj/item/clothing/glasses/chameleon
	name = "Optical Meson Scanner"
	icon = 'icons/clothing/eyes/scanner_meson.dmi'
	desc = "It looks like a plain set of mesons, but on closer inspection, it seems to have a small dial inside."
	origin_tech = @'{"esoteric":3}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	bodytype_equip_flags = null
	var/static/list/disguise_choices

/obj/item/clothing/glasses/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		disguise_choices = generate_chameleon_choices(/obj/item/clothing/glasses)

CHAMELEON_VERB(/obj/item/clothing/glasses/chameleon, "Change Glasses Appearance")

//*********************
//**Chameleon Headset**
//*********************

/obj/item/radio/headset/chameleon
	name = "radio headset"
	icon = 'icons/obj/items/device/radio/headsets/headset.dmi'
	desc = "An updated, modular intercom that fits over the head. This one seems to have a small dial on it."
	origin_tech = @'{"esoteric":3}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	var/static/list/disguise_choices

/obj/item/radio/headset/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		disguise_choices = generate_chameleon_choices(/obj/item/radio/headset)

CHAMELEON_VERB(/obj/item/radio/headset/chameleon, "Change Headset Appearance")

//***********************
//**Chameleon Accessory**
//***********************

/obj/item/clothing/chameleon
	name = "tie"
	icon = 'icons/clothing/accessories/ties/tie.dmi'
	desc = "A neosilk clip-on tie. It seems to have a small dial on its back."
	origin_tech = @'{"esoteric":3}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	w_class = ITEM_SIZE_SMALL
	fallback_slot = slot_wear_mask_str
	var/static/list/disguise_choices
	var/static/list/decor_types = list(
		/obj/item/clothing/neck,
		/obj/item/clothing/badge,
		/obj/item/clothing/medal,
		/obj/item/clothing/suspenders,
		/obj/item/clothing/armband,
		/obj/item/clothing/webbing,
		/obj/item/clothing/sensor
	)

/obj/item/clothing/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		disguise_choices = generate_chameleon_choices(get_non_abstract_types(decor_types))

CHAMELEON_VERB(/obj/item/clothing/chameleon, "Change Accessory Appearance")

//*****************
//**Chameleon Gun**
//*****************
/obj/item/gun/energy/chameleon
	name = "chameleon gun"
	desc = "A hologram projector in the shape of a gun. There is a dial on the side to change the gun's disguise."
	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = "revolver"
	w_class = ITEM_SIZE_SMALL
	origin_tech = @'{"combat":2,"materials":2,"esoteric":8}'
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	matter = list()

	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	projectile_type = /obj/item/projectile/chameleon
	charge_meter = 0
	charge_cost = 20 //uses next to no power, since it's just holograms
	max_shots = 50

	var/obj/item/projectile/copy_projectile
	var/static/list/disguise_choices

/obj/item/gun/energy/chameleon/Initialize()
	. = ..()
	if(!disguise_choices)
		disguise_choices = generate_chameleon_choices(/obj/item/gun)

/obj/item/gun/energy/chameleon/consume_next_projectile()
	var/obj/item/projectile/P = ..()
	if(P && ispath(copy_projectile))
		P.SetName(initial(copy_projectile.name))
		P.icon = initial(copy_projectile.icon)
		P.icon_state = initial(copy_projectile.icon_state)
		P.pass_flags = initial(copy_projectile.pass_flags)
		P.hitscan = initial(copy_projectile.hitscan)
		P.step_delay = initial(copy_projectile.step_delay)
		P.muzzle_type = initial(copy_projectile.muzzle_type)
		P.tracer_type = initial(copy_projectile.tracer_type)
		P.impact_type = initial(copy_projectile.impact_type)
	return P

/obj/item/gun/energy/chameleon/OnDisguise(var/obj/item/gun/copy)
	if(!istype(copy))
		return

	flags_inv = copy.flags_inv
	fire_sound = copy.fire_sound
	fire_sound_text = copy.fire_sound_text
	icon = copy.icon

	var/obj/item/gun/energy/E = copy
	if(istype(E))
		copy_projectile = E.projectile_type
		//charge_meter = E.charge_meter //does not work very well with icon_state changes, ATM
	else
		copy_projectile = null
		//charge_meter = 0

CHAMELEON_VERB(/obj/item/gun/energy/chameleon, "Change Gun Appearance")