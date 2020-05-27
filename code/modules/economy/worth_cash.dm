/obj/item/cash
	name = "cash"
	desc = "Some cold hard cash."
	icon = 'icons/obj/items/money.dmi'
	icon_state = "cash"
	opacity = FALSE
	density = FALSE
	anchored = FALSE
	force = 1
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = ITEM_SIZE_TINY
	var/currency
	var/absolute_worth = 0
	var/can_flip = TRUE // Cooldown tracker for single-coin flips.

/obj/item/cash/Initialize(ml, material_key)
	. = ..()
	appearance_flags |= PIXEL_SCALE
	if(!ispath(currency, /decl/currency))
		currency = GLOB.using_map.default_currency
	if(absolute_worth > 0)
		update_from_worth()

/obj/item/cash/get_base_value()
	. = holographic ? 0 : absolute_worth 

/obj/item/cash/proc/set_currency(var/new_currency)
	currency = new_currency
	update_from_worth()

/obj/item/cash/proc/adjust_worth(var/amt)
	absolute_worth += amt
	if(absolute_worth <= 0)
		qdel(src)
	else
		update_from_worth()

/obj/item/cash/proc/get_worth()
	var/decl/currency/cur = decls_repository.get_decl(currency)
	. = Floor(absolute_worth / cur.absolute_value)

/obj/item/cash/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cash))
		var/obj/item/cash/cash = W
		if(cash.currency != currency)
			to_chat(user, SPAN_WARNING("You can't mix two different currencies, it would be uncivilized."))
			return
		if(user.unEquip(W))
			adjust_worth(cash.absolute_worth)
			var/decl/currency/cur = decls_repository.get_decl(currency)
			to_chat(user, SPAN_NOTICE("You add [cash.get_worth()] [cur.name] to the pile."))
			to_chat(user, SPAN_NOTICE("It holds [get_worth()] [cur.name] now."))
			qdel(W)
		return TRUE
	else if(istype(W, /obj/item/gun/launcher/money))
		var/obj/item/gun/launcher/money/L = W
		L.absorb_cash(src, user)

/obj/item/cash/on_update_icon()
	icon_state = ""
	var/draw_worth = get_worth()
	var/list/adding_notes
	var/decl/currency/cur = decls_repository.get_decl(currency)
	for(var/datum/denomination/denomination in cur.denominations)
		while(draw_worth >= denomination.marked_value)
			draw_worth -= denomination.marked_value
			var/image/banknote = new
			banknote.appearance = denomination.overlay
			banknote.plane = FLOAT_PLANE
			banknote.layer = FLOAT_LAYER
			var/matrix/M = matrix()
			M.Translate(rand(-6, 6), rand(-4, 8))
			if(denomination.rotate_icon)
				M.Turn(pick(-45, -27.5, 0, 0, 0, 0, 0, 0, 0, 27.5, 45))
			banknote.transform = M
			LAZYADD(adding_notes, banknote)
	overlays = adding_notes

/obj/item/cash/proc/update_from_worth()
	var/decl/currency/cur = decls_repository.get_decl(currency)
	matter = list()
	matter[cur.material] = absolute_worth * max(1, round(SHEET_MATERIAL_AMOUNT/10))
	var/current_worth = get_worth()
	if(cur.denominations_by_value["[current_worth]"]) // Single piece.
		var/datum/denomination/denomination = cur.denominations_by_value["[current_worth]"]
		SetName(denomination.name)
		desc = "[initial(desc)] It's worth [current_worth] [current_worth == 1 ? cur.name_singular : cur.name]."
		w_class = ITEM_SIZE_TINY
	else
		SetName("pile of [cur.name]")
		desc = "[initial(desc)] It totals up to [current_worth] [current_worth == 1 ? cur.name_singular : cur.name]."
		w_class = ITEM_SIZE_SMALL
	update_icon()

/obj/item/cash/attack_self(var/mob/user)

	var/decl/currency/cur = decls_repository.get_decl(currency)
	var/current_worth = get_worth()

	// Handle coin flipping. Mostly copied from /obj/item/coin.
	var/datum/denomination/denomination = cur.denominations_by_value["[current_worth]"]
	if(denomination && length(denomination.faces) && alert("Do you wish to divide \the [src], or flip it?", "Flip or Split?", "Flip", "Split") == "Flip")
		if(!can_flip)
			to_chat(user, SPAN_WARNING("\The [src] is already being flipped!"))
			return
		can_flip = FALSE
		playsound(user.loc, 'sound/effects/coin_flip.ogg', 75, 1)
		user.visible_message(SPAN_NOTICE("\The [user] flips \the [src] into the air."))
		sleep(1.5 SECOND)
		if(!QDELETED(user) && !QDELETED(src) && loc == user && get_worth() == current_worth)
			user.visible_message(SPAN_NOTICE("...and catches it, revealing that \the [src] landed on [pick(denomination.faces)]!"))
		can_flip = TRUE
		return TRUE
	// End coin flipping.

	if(QDELETED(src) || get_worth() <= 1 || user.incapacitated() || loc != user)
		return TRUE

	var/amount = input(usr, "How many [cur.name] do you want to take? (0 to [get_worth() - 1])", "Take Money", 20) as num
	amount = round(Clamp(amount, 0, Floor(get_worth() - 1)))

	if(!amount || QDELETED(src) || get_worth() <= 1 || user.incapacitated() || loc != user)
		return TRUE

	amount = Floor(amount * cur.absolute_value)
	adjust_worth(-(amount))
	var/obj/item/cash/cash = new(get_turf(src))
	cash.set_currency(currency)
	cash.adjust_worth(amount)
	user.put_in_hands(cash)

/obj/item/cash/c1
	absolute_worth = 1

/obj/item/cash/c10
	absolute_worth = 10

/obj/item/cash/c20
	absolute_worth = 20

/obj/item/cash/c50
	absolute_worth = 50

/obj/item/cash/c100
	absolute_worth = 100

/obj/item/cash/c200
	absolute_worth = 200

/obj/item/cash/c500
	absolute_worth = 500

/obj/item/cash/c1000
	absolute_worth = 1000

/obj/item/cash/scrip
	currency = /decl/currency/trader
	absolute_worth = 200


/obj/item/cash/scavbucks
	currency = /decl/currency/scav
	absolute_worth = 10

/obj/item/charge_card
	name = "charge card"
	icon = 'icons/obj/items/e_funds.dmi'
	icon_state = "efundcard"
	desc = "A card that holds an amount of money."

	var/loaded_worth = 0
	var/owner_name = "" //So the ATM can set it so the EFTPOS can put a valid name on transactions.
	var/currency

/obj/item/charge_card/Initialize(ml, material_key)
	. = ..()
	appearance_flags |= PIXEL_SCALE
	if(!ispath(currency, /decl/currency))
		currency = GLOB.using_map.default_currency

/obj/item/charge_card/proc/adjust_worth(amt)
	loaded_worth += amt
	if(loaded_worth < 0)
		loaded_worth = 0

/obj/item/charge_card/examine(mob/user, distance)
	. = ..(user)
	if(distance <= 2 || user == loc)
		to_chat(user, SPAN_NOTICE("<b>Owner:</b> [owner_name]."))
		var/decl/currency/cur = decls_repository.get_decl(currency)
		to_chat(user, SPAN_NOTICE("<b>[capitalize(cur.name)]</b> remaining: [Floor(loaded_worth / cur.absolute_value)]."))

/obj/item/charge_card/get_base_value()
	. = holographic ? 0 : loaded_worth

/obj/item/coin/get_base_value()
	. = max((holographic ? 0 : absolute_worth), ..())
