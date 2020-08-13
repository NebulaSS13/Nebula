/spell/toggle_armor
	name = "Toggle Armor"
	spell_flags = 0
	charge_max = 10
	school = "Conjuration"
	var/list/armor_pieces
	var/equip = 0
	hud_state = "const_shell"

/spell/toggle_armor/New()
	if(armor_pieces)
		var/list/nlist = list()
		for(var/type in armor_pieces)
			var/obj/item/I = new type(null)
			nlist[I] = armor_pieces[type]
		armor_pieces = nlist
	return ..()

/spell/toggle_armor/proc/drop_piece(var/obj/I)
	if(istype(I.loc, /mob))
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
	armor_pieces = list(/obj/item/clothing/under/color/grey = BP_CHEST,
						/obj/item/clothing/gloves/insulated/cheap = slot_gloves_str,
						/obj/item/clothing/mask/gas = BP_MOUTH,
						/obj/item/clothing/shoes/color/black = slot_shoes_str,
						/obj/item/storage/toolbox/mechanical = BP_R_HAND,
						/obj/item/extinguisher = BP_L_HAND)

/spell/toggle_armor/caretaker
	name = "Toggle Armor (Caretaker)"
	invocation_type = SpI_EMOTE
	invocation = "radiates a holy light"
	armor_pieces = list(/obj/item/clothing/head/caretakerhood = BP_HEAD,
						/obj/item/clothing/suit/caretakercloak = BP_BODY
						)
	hud_state = "caretaker"

/spell/toggle_armor/champion
	name = "Toggle Armor (Champion)"
	invocation_type = SpI_EMOTE
	invocation = "is covered in golden embers for a moment, before they fade"
	armor_pieces = list(/obj/item/clothing/head/champhelm = BP_HEAD,
						/obj/item/clothing/suit/champarmor = BP_BODY
						)
	hud_state = "champion"

/spell/toggle_armor/excalibur
	name = "Toggle Sword"
	invocation_type = SpI_EMOTE
	invocation = "thrusts /his hand forward, and it is enveloped in golden embers!"
	armor_pieces = list(/obj/item/sword/excalibur = BP_R_HAND)
	hud_state = "excalibur"

/spell/toggle_armor/fiend
	name = "Toggle Armor (Fiend)"
	invocation_type = SpI_EMOTE
	invocation = "snaps /his fingers, and /his clothes begin to shift and change"
	armor_pieces = list(/obj/item/clothing/head/fiendhood = BP_HEAD,
						/obj/item/clothing/suit/fiendcowl = BP_BODY
						)
	hud_state = "fiend"

/spell/toggle_armor/fiend/fem
	armor_pieces = list(/obj/item/clothing/head/fiendhood/fem = BP_HEAD,
						/obj/item/clothing/suit/fiendcowl/fem = BP_BODY
						)

/spell/toggle_armor/infiltrator
	name = "Toggle Armor (Infiltrator)"
	invocation_type = SpI_EMOTE
	invocation = "winks. In an instant, /his clothes change dramatically"
	armor_pieces = list(/obj/item/clothing/head/infilhat = BP_HEAD,
						/obj/item/clothing/suit/infilsuit = BP_BODY
						)
	hud_state = "infiltrator"

/spell/toggle_armor/infiltrator/fem
	armor_pieces = list(/obj/item/clothing/head/infilhat/fem = BP_HEAD,
						/obj/item/clothing/suit/infilsuit/fem = BP_BODY
						)

/spell/toggle_armor/infil_items
	name = "Toggle Counterfeit Kit"
	invocation_type = SpI_EMOTE
	invocation = "flicks /his wrists, one at a time"
	armor_pieces = list(/obj/item/stamp/chameleon = BP_L_HAND,
						/obj/item/pen/chameleon = BP_R_HAND)
	hud_state = "forgery"

/spell/toggle_armor/overseer
	name = "Toggle Armor (Overseer)"
	invocation_type = SpI_EMOTE
	invocation = " is enveloped in shadows, before /his form begins to shift rapidly"
	armor_pieces = list(/obj/item/clothing/head/overseerhood = BP_HEAD,
						/obj/item/clothing/suit/straight_jacket/overseercloak = BP_BODY
						)
	hud_state = "overseer"