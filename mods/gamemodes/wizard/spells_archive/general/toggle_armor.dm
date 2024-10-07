/spell/toggle_armor
	name = "Toggle Armor"
	requires_wizard_garb = FALSE
	charge_max = 10
	school = "Conjuration"
	var/list/armor_pieces
	var/equip = 0
	ability_icon_state = "const_shell"

/spell/toggle_armor/New()
	if(armor_pieces)
		var/list/nlist = list()
		for(var/type in armor_pieces)
			var/obj/item/I = new type(null)
			nlist[I] = armor_pieces[type]
		armor_pieces = nlist
	return ..()

/spell/toggle_armor/proc/drop_piece(var/obj/I)
	if(ismob(I.loc))
		var/mob/M = I.loc
		M.drop_from_inventory(I)

/spell/toggle_armor/choose_targets()
	return list(holder)

/spell/toggle_armor/cast(var/list/targets, var/mob/user)
	equip = !equip
	name = "[initial(name)] ([equip ? "off" : "on"])"
	if(equip)
		for(var/piece in armor_pieces)
			var/slot = armor_pieces[piece]
			drop_piece(piece)
			user.drop_from_inventory(user.get_equipped_item(slot))
			user.equip_to_slot_if_possible(piece,slot,0,1,1,1)
	else
		for(var/piece in armor_pieces)
			var/obj/item/I = piece
			drop_piece(piece)
			I.forceMove(null)

/spell/toggle_armor/greytide_worldwide
	name = "Greytide Worldwide"
	invocation_type = SpI_EMOTE
	invocation = "screams incoherently!"
	armor_pieces = list(/obj/item/clothing/jumpsuit/grey = slot_w_uniform_str,
						/obj/item/clothing/gloves/insulated/cheap = slot_gloves_str,
						/obj/item/clothing/mask/gas = slot_wear_mask_str,
						/obj/item/clothing/shoes/color/black = slot_shoes_str,
						/obj/item/toolbox/mechanical = BP_R_HAND,
						/obj/item/chems/spray/extinguisher = BP_L_HAND)

/spell/toggle_armor/caretaker
	name = "Toggle Armor (Caretaker)"
	invocation_type = SpI_EMOTE
	invocation = "radiates a holy light"
	armor_pieces = list(/obj/item/clothing/head/caretakerhood = slot_head_str,
						/obj/item/clothing/suit/caretakercloak = slot_wear_suit_str
						)
	ability_icon_state = "caretaker"

/spell/toggle_armor/champion
	name = "Toggle Armor (Champion)"
	invocation_type = SpI_EMOTE
	invocation = "is covered in golden embers for a moment, before they fade"
	armor_pieces = list(/obj/item/clothing/head/champhelm = slot_head_str,
						/obj/item/clothing/suit/champarmor = slot_wear_suit_str
						)
	ability_icon_state = "champion"

/spell/toggle_armor/excalibur
	name = "Toggle Sword"
	invocation_type = SpI_EMOTE
	invocation = "thrusts /his hand forward, and it is enveloped in golden embers!"
	armor_pieces = list(/obj/item/sword/excalibur = BP_R_HAND)
	ability_icon_state = "excalibur"

/spell/toggle_armor/fiend
	name = "Toggle Armor (Fiend)"
	invocation_type = SpI_EMOTE
	invocation = "snaps /his fingers, and /his clothes begin to shift and change"
	armor_pieces = list(/obj/item/clothing/head/fiendhood = slot_head_str,
						/obj/item/clothing/suit/fiendcowl = slot_wear_suit_str
						)
	ability_icon_state = "fiend"

/spell/toggle_armor/fiend/fem
	armor_pieces = list(/obj/item/clothing/head/fiendhood/fem = slot_head_str,
						/obj/item/clothing/suit/fiendcowl/fem = slot_wear_suit_str
						)

/spell/toggle_armor/infiltrator
	name = "Toggle Armor (Infiltrator)"
	invocation_type = SpI_EMOTE
	invocation = "winks. In an instant, /his clothes change dramatically"
	armor_pieces = list(/obj/item/clothing/head/infilhat = slot_head_str,
						/obj/item/clothing/suit/infilsuit = slot_wear_suit_str
						)
	ability_icon_state = "infiltrator"

/spell/toggle_armor/infiltrator/fem
	armor_pieces = list(/obj/item/clothing/head/infilhat/fem = slot_head_str,
						/obj/item/clothing/suit/infilsuit/fem = slot_wear_suit_str
						)

/spell/toggle_armor/infil_items
	name = "Toggle Counterfeit Kit"
	invocation_type = SpI_EMOTE
	invocation = "flicks /his wrists, one at a time"
	armor_pieces = list(/obj/item/stamp/chameleon = BP_L_HAND,
						/obj/item/pen/chameleon = BP_R_HAND)
	ability_icon_state = "forgery"

/spell/toggle_armor/overseer
	name = "Toggle Armor (Overseer)"
	invocation_type = SpI_EMOTE
	invocation = " is enveloped in shadows, before /his form begins to shift rapidly"
	armor_pieces = list(/obj/item/clothing/head/overseerhood = slot_head_str,
						/obj/item/clothing/suit/straight_jacket/overseercloak = slot_wear_suit_str
						)
	ability_icon_state = "overseer"