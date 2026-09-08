////////////////////////////////////////////////////////////////////////////////
// Large - used for loot spawns
////////////////////////////////////////////////////////////////////////////////

/obj/item/chems/hypospray/autoinjector/large
	name = "large autoinjector"
	desc = "A refined version of the standard autoinjector, allowing greater capacity."
	icon_state = "autoinjector"
	amount_per_transfer_from_this = 15
	chem_volume = 15
	origin_tech = @'{"materials":4,"biotech":5,"engineering":2}'

/obj/item/chems/hypospray/autoinjector/large/empty
	name = "autoinjector"
	detail_color = COLOR_WHITE

/obj/item/chems/hypospray/autoinjector/large/empty/populate_reagents()
	SHOULD_CALL_PARENT(FALSE)
	return