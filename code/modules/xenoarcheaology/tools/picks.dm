/obj/item/pick/xeno
	name              = "master xenoarch pickaxe"
	desc              = "A miniature excavation tool for precise digging."
	icon              = 'icons/obj/xenoarchaeology.dmi'
	item_state        = "screwdriver_brown"
	force             = 3
	throwforce        = 0
	attack_verb       = list("stabbed", "jabbed", "spiked", "attacked")
	material          = /decl/material/solid/metal/chromium
	matter            = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY)
	w_class           = ITEM_SIZE_SMALL
	sharp             = 1
	excavation_verb   = "delicately picking"
	excavation_amount = 0
	abstract_type     = obj/item/pick/xeno

/obj/item/pick/xeno/get_initial_tool_qualities()
	return list(TOOL_PICK = TOOL_QUALITY_DEFAULT)

/obj/item/pick/xeno/examine(mob/user)
	. = ..()
	if(IS_PICK(src))
		to_chat(user, "This tool has a [get_tool_property(TOOL_PICK, TOOL_PROP_EXCAVATION_DEPTH) || 0] centimetre excavation depth.")

/obj/item/pick/xeno/brush
	name              = "wire brush"
	icon_state        = "pick_brush"
	slot_flags        = SLOT_EARS
	force             = 1
	attack_verb       = list("prodded", "attacked")
	desc              = "A wood-handled brush with thick metallic wires for clearing away dust and loose scree."
	sharp             = 0
	material          = /decl/material/solid/organic/wood
	matter            = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT)
	excavation_amount = 1
	excavation_sound  = 'sound/weapons/thudswoosh.ogg'
	excavation_verb   = "brushing"

/obj/item/pick/xeno/one_pick
	name              = "2cm pick"
	icon_state        = "pick1"
	excavation_amount = 2
	excavation_sound  = 'sound/items/Screwdriver.ogg'

/obj/item/pick/xeno/two_pick
	name              = "4cm pick"
	icon_state        = "pick2"
	excavation_amount = 4
	excavation_sound  = 'sound/items/Screwdriver.ogg'

/obj/item/pick/xeno/three_pick
	name              = "6cm pick"
	icon_state        = "pick3"
	excavation_amount = 6
	excavation_sound  = 'sound/items/Screwdriver.ogg'

/obj/item/pick/xeno/four_pick
	name              = "8cm pick"
	icon_state        = "pick4"
	excavation_amount = 8
	excavation_sound  = 'sound/items/Screwdriver.ogg'

/obj/item/pick/xeno/five_pick
	name              = "10cm pick"
	icon_state        = "pick5"
	excavation_amount = 10
	excavation_sound  = 'sound/items/Screwdriver.ogg'

/obj/item/pick/xeno/six_pick
	name              = "12cm pick"
	icon_state        = "pick6"
	excavation_amount = 12

/obj/item/pick/xeno/hand
	name              = "hand pickaxe"
	icon_state        = "pick_hand"
	item_state        = "sword0"
	desc              = "A smaller, more precise version of the pickaxe."
	excavation_amount = 30
	excavation_sound  = 'sound/items/Crowbar.ogg'
	excavation_verb   = "clearing"
	material          = /decl/material/solid/metal/chromium
	matter            = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY)
	w_class           = ITEM_SIZE_NORMAL
	force             = 6
	throwforce        = 3

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pack for holding pickaxes

/obj/item/storage/excavation
	name              = "excavation pick set"
	icon              = 'icons/obj/items/storage/excavation.dmi'
	icon_state        = "excavation"
	item_state        = "utility"
	desc              = "A rugged case containing a set of standardized picks used in archaeological digs."
	item_state        = "syringe_kit"
	storage_slots     = 7
	slot_flags        = SLOT_LOWER_BODY
	w_class           = ITEM_SIZE_NORMAL
	can_hold          = list(/obj/item/pick/xeno)
	max_storage_space = 18
	max_w_class       = ITEM_SIZE_NORMAL
	use_to_pickup     = 1
	material          = /decl/material/solid/organic/leather/synth

/obj/item/storage/excavation/WillContain()
	return list(
			/obj/item/pick/xeno/brush,
			/obj/item/pick/xeno/one_pick,
			/obj/item/pick/xeno/two_pick,
			/obj/item/pick/xeno/three_pick,
			/obj/item/pick/xeno/four_pick,
			/obj/item/pick/xeno/five_pick,
			/obj/item/pick/xeno/six_pick
		)

/obj/item/storage/excavation/empty/WillContain()
	return

/obj/item/storage/excavation/handle_item_insertion()
	..()
	sort_picks()

/obj/item/storage/excavation/proc/sort_picks()
	var/list/obj/item/pick/xeno/picksToSort = list()
	for(var/obj/item/pick/xeno/P in src)
		picksToSort += P
		P.forceMove(null)
	while(picksToSort.len)
		var/min = 200 // No pick is bigger than 200
		var/selected = 0
		for(var/i = 1 to picksToSort.len)
			var/obj/item/pick/xeno/current = picksToSort[i]
			var/excav_amount = current.get_tool_property(TOOL_PICK, TOOL_PROP_EXCAVATION_DEPTH)
			if(excav_amount <= min)
				selected = i
				min = excav_amount
		var/obj/item/pick/xeno/smallest = picksToSort[selected]
		smallest.forceMove(src)
		picksToSort -= smallest
	prepare_ui()
