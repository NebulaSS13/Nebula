/decl/hud_element
	abstract_type = /decl/hud_element
	/// /obj/screen path to create
	var/elem_type
	/// Index value for /datum/hud; defaults to src.type if null
	var/elem_reference_type
	/// Adds element to hidable list (inventory)
	var/elem_is_hidable      = FALSE
	/// Adds element to hotkey list
	var/elem_is_hotkey       = FALSE
	/// Adds element to aux list (hidden by F12)
	var/elem_is_auxilliary   = TRUE
	/// Updates element icon in mob Life() proc
	var/elem_updates_in_life = FALSE

/decl/hud_element/validate()
	. = ..()
	if(!ispath(elem_type, /obj/screen))
		. += "invalid elem_type ([elem_type || null]))"

/decl/hud_element/Initialize()
	. = ..()
	if(isnull(elem_reference_type))
		elem_reference_type = type
