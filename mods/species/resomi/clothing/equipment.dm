//Contains resomi-unique clothing, TODO: cloaks and stuff
//cloaks
/obj/item/clothing/suit/storage/hooded/polychromic
	name = "polychromic cloak"
	desc = "Resomi cloak. Seems to be coated with polychrome paint. There is also a sewn hood. DO NOT MIX WITH EMP!"
	icon = 'mods/species/resomi/icons/clothing/exp/suit/polychromic.dmi'
	hoodtype = /obj/item/clothing/head/winterhood/polychromic_hood
	action_button_name = "Toggle Hood"
	slots = 4
	bodytype_restricted = list(BODYTYPE_RESOMI)
	body_parts_covered = SLOT_UPPER_BODY|SLOT_ARMS|SLOT_LOWER_BODY

/obj/item/clothing/suit/storage/hooded/polychromic/verb/change_color()
	set name = "Change Cloak Color"
	set category = "Object"
	set desc = "Change the color of the cloak."
	set src in usr

	if(usr.incapacitated())
		return

	var/new_color = input(usr, "Pick a new color", "Cloak Color", color) as color|null
	if(!new_color || new_color == color || usr.incapacitated())
		return
	color = new_color
	hood.color = color
	hood.update_icon()
	update_icon()

/obj/item/clothing/suit/storage/hooded/polychromic/on_update_icon()
	..()
	MakeHood()
	hood.color = color
	update_clothing_icon()
	hood.update_clothing_icon()

/obj/item/clothing/suit/storage/hooded/polychromic/emp_act()
	color = null
	hood.color = null
	update_icon()

/obj/item/clothing/head/winterhood/polychromic_hood
	name = "hood"
	icon = 'mods/species/resomi/icons/clothing/exp/head/polychromic_hood.dmi'
	bodytype_restricted = list(BODYTYPE_RESOMI)
	desc = "It's hood that covers the head."
	flags_inv = BLOCKHAIR | HIDEEARS
	body_parts_covered = SLOT_HEAD
	canremove = 0


//uniform
/obj/item/clothing/under/resomi
	name = "small jumpsuit"
	desc = "A small jumpsuit. Looks pretty much perfect to fit a resomi."
	icon = 'mods/species/resomi/icons/clothing/exp/under/small_jumpsuit.dmi'
	bodytype_restricted = list(BODYTYPE_RESOMI)

/obj/item/clothing/under/resomi/simple
	name = "small smock"
	icon = 'mods/species/resomi/icons/clothing/exp/under/small_smock.dmi'

/obj/item/clothing/under/resomi/rainbow
	name = "rainbow smock"
	desc = "Why would someone wear this?"
	icon = 'mods/species/resomi/icons/clothing/exp/under/rainbow_smock.dmi'

/obj/item/clothing/under/resomi/engine
	name = "small engineering smock"
	icon = 'mods/species/resomi/icons/clothing/exp/under/engineering_smock.dmi'

/obj/item/clothing/under/resomi/security
	name = "small security smock"
	icon = 'mods/species/resomi/icons/clothing/exp/under/security_smock.dmi'

/obj/item/clothing/under/resomi/medical
	name = "small medical smock"
	icon = 'mods/species/resomi/icons/clothing/exp/under/medical_smock.dmi'

/obj/item/clothing/under/resomi/science
	name = "small science smock"
	icon = 'mods/species/resomi/icons/clothing/exp/under/science_smock.dmi'

/obj/item/clothing/under/resomi/command
	name = "small command uniform"
	icon = 'mods/species/resomi/icons/clothing/exp/under/command_uniform.dmi'

/obj/item/clothing/under/resomi/stylish_command
	name = "small stylish uniform"
	icon = 'mods/species/resomi/icons/clothing/exp/under/stylish_form.dmi'

/obj/item/clothing/under/resomi/gray_utility
	name = "small grey uniform"
	icon = 'mods/species/resomi/icons/clothing/exp/under/gray_utility.dmi'

/obj/item/clothing/under/resomi/black_utility
	name = "small black uniform"
	icon = 'mods/species/resomi/icons/clothing/exp/under/black_utility.dmi'

//Shoes
/obj/item/clothing/shoes/resomi/footwraps
	name = "cloth footwraps"
	desc = "A roll of treated canvas used for wrapping paws"
	icon = 'mods/species/resomi/icons/clothing/exp/feet/footwraps.dmi'
	force = 0
	item_flags = ITEM_FLAG_SILENT
	w_class = ITEM_SIZE_SMALL

/obj/item/clothing/shoes/resomi/footwraps/socks_resomi
	name = "koishi"
	desc = "Looks like socks but with toe holes and thick sole."
	icon = 'mods/species/resomi/icons/clothing/exp/feet/koishi.dmi'

/obj/item/clothing/shoes/resomi
	name = "small shoes"
	icon = 'mods/species/resomi/icons/clothing/exp/feet/shoes.dmi'
	color = COLOR_GRAY
	bodytype_restricted = list(BODYTYPE_RESOMI)

//Spacesuits

/obj/item/clothing/under/resomi/space
	name       = "small pressure suit"
	desc       = "Thick rubber jumpsuit designed for work in vacuum of space."
	icon       = 'mods/species/resomi/icons/clothing/exp/under/pressure_suit.dmi'
	item_flags         = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = SLOT_UPPER_BODY | SLOT_LOWER_BODY | SLOT_LEGS | SLOT_FEET | SLOT_ARMS | SLOT_HANDS
	cold_protection    = SLOT_UPPER_BODY | SLOT_LOWER_BODY | SLOT_LEGS | SLOT_FEET | SLOT_ARMS | SLOT_HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection         = 0
	max_pressure_protection         = 303
	siemens_coefficient             = 0 //It's rubber, okay?
	var/obj/item/clothing/head/resomi_space/helmet
	action_button_name = "Toggle Helmet"

/obj/item/clothing/under/resomi/space/Initialize()
	. = ..()
	helmet = new()

/obj/item/clothing/under/resomi/space/Destroy()
	qdel(helmet)
	. = ..()

/obj/item/clothing/under/resomi/space/dropped()
	..()
	if(!ishuman(helmet.loc)) return
	var/mob/living/carbon/human/H = helmet.loc
	H.drop_from_inventory(helmet, src)
	playsound(loc,'sound/machines/airlock_heavy.ogg',30)

/obj/item/clothing/under/resomi/space/ui_action_click()
	toggle_helmet()

/obj/item/clothing/under/resomi/space/verb/toggle_helmet()
	set name = "Toggle Helmet"
	set category = "Object"
	set src in usr
	if(!ishuman(usr)) return
	var/mob/living/carbon/human/H = usr
	if(H.incapacitated())  return
	if(H.w_uniform != src) return
	if(H.head == helmet)
		playsound(loc,'sound/machines/airlock_heavy.ogg',     30)
		H.drop_from_inventory(helmet, src)
		return
	if(H.head)
		to_chat(H, SPAN_DANGER("You cannot deploy your helmet while wearing \the [H.head]."))
		return
	if(H.equip_to_slot_if_possible(helmet, slot_head_str))
		helmet.pickup(H)
		playsound(loc,'sound/machines/AirlockClose_heavy.ogg',30)

/obj/item/clothing/head/resomi_space
	name       = "small glass helmet"
	desc       = "Small glass dome made of durable glass alloy. It's wearer surely will have a spectacular view."
	icon       = 'mods/species/resomi/icons/clothing/exp/head/space_dome.dmi'
	bodytype_restricted = list(BODYTYPE_RESOMI)
	item_flags          = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	flags_inv           = HIDEMASK | BLOCKHAIR
	body_parts_covered  = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	cold_protection                 = SLOT_HEAD
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection         = 0
	max_pressure_protection         = 303
	canremove                       = 0

//Voidsuit

/obj/item/clothing/head/helmet/space/void/engineering/resomi
	name = "heavy resomi voidsuit helmet"
	icon = 'mods/species/resomi/icons/clothing/exp/head/heavy.dmi'

	bodytype_restricted = list(BODYTYPE_RESOMI)

/obj/item/clothing/suit/space/void/engineering/resomi
	name = "heavy resomi voidsuit"
	icon = 'mods/species/resomi/icons/clothing/exp/suit/heavy_suit.dmi'

	bodytype_restricted = list(BODYTYPE_RESOMI)

/obj/item/clothing/suit/space/void/engineering/resomi/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/engineering/resomi
	boots  = /obj/item/clothing/shoes/magboots

//Closet, for mapping

/obj/structure/closet/wardrobe/resomi
	name = "resomi equipment locker"
	closet_appearance = /decl/closet_appearance/wardrobe/green

/obj/structure/closet/wardrobe/resomi/Initialize()
	. = ..()
	new /obj/item/clothing/under/resomi/space(src)
	new /obj/item/clothing/under/resomi/space(src)
	new /obj/item/clothing/under/resomi/space(src)
	new /obj/item/clothing/under/resomi/space(src)
