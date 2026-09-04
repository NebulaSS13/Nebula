/decl/gemstone_cut
	abstract_type          = /decl/gemstone_cut
	var/worth_multiplier   = 1.5
	var/name
	var/desc
	var/adjective
	var/icon
	// Can we cut this cut into a new cut?
	var/can_attempt_cut = FALSE
	// Can we attempt to cut to this cut?
	var/can_be_cut      = TRUE

/decl/gemstone_cut/validate()
	. = ..()
	if(!istext(name))
		. += "invalid or null name"
	if(!istext(desc))
		. += "invalid or null desc"
	if(!istext(adjective))
		. += "invalid or null adjective"
	if(icon)
		if(!check_state_in_icon(ICON_STATE_WORLD, icon))
			. += "missing world state from '[icon]'"
		if(!check_state_in_icon(ICON_STATE_INV, icon))
			. += "missing inventory state from '[icon]'"
		var/decl/item_decoration/gem_set = GET_DECL(/decl/item_decoration/setting)
		var/check_state = "[ICON_STATE_WORLD]-[gem_set.icon_state_modifier]"
		if(!check_state_in_icon(check_state, icon))
			. += "missing state '[check_state]' from '[icon]'"
		check_state = "[ICON_STATE_INV]-[gem_set.icon_state_modifier]"
		if(!check_state_in_icon(check_state, icon))
			. += "missing state '[check_state]' from '[icon]'"
	else
		. += "null or unset icon"

// Subtypes below.
/decl/gemstone_cut/uncut
	name                   = "uncut"
	adjective              = "uncut"
	desc                   = "A rough, uncut gemstone."
	icon                   = 'icons/obj/items/gemstones/uncut.dmi'
	can_attempt_cut        = TRUE
	can_be_cut             = FALSE
	worth_multiplier       = 1

/decl/gemstone_cut/poor
	name                   = "poorly-cut"
	adjective              = "poorly-cut"
	desc                   = "A poorly-cut and uneven gemstone."
	icon                   = 'icons/obj/items/gemstones/poor.dmi'
	worth_multiplier       = 0.5
	can_be_cut             = FALSE

/decl/gemstone_cut/baguette
	name                   = "baguette"
	adjective              = "baguette-cut"
	desc                   = "A square-cut gemstone."
	icon                   = 'icons/obj/items/gemstones/baguette.dmi'

/decl/gemstone_cut/hexagon
	name                   = "hexagon"
	adjective              = "hexagon-cut"
	desc                   = "A hexagon-cut gemstone."
	icon                   = 'icons/obj/items/gemstones/hexagon.dmi'

/decl/gemstone_cut/octagon
	name                   = "octagon"
	adjective              = "octagon-cut"
	desc                   = "An octagon-cut gemstone."
	icon                   = 'icons/obj/items/gemstones/octagon.dmi'

/decl/gemstone_cut/round
	name                   = "round"
	adjective              = "round-cut"
	desc                   = "A round-cut gemstone."
	icon                   = 'icons/obj/items/gemstones/round.dmi'
