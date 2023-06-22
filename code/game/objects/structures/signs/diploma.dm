
///Details used by the diploma plaques for display.
/datum/diploma_details
	///Name of the diploma holder
	var/claimant
	///Signature of the diploma holder
	var/signature
	///Establishment that emitted this diploma
	var/establishment = "Space College"
	///The degree's name
	var/degree = "master's degree in space"
	///The abbreviation of the degree
	var/degree_short = "MD"
	///The title this degree grants
	var/title = "Doctor of Space"
	///The abbreviation of the title granted by the degree
	var/title_short = "Dr."

/datum/diploma_details/PopulateClone(datum/clone)
	var/datum/diploma_details/populated_clone = ..()
	populated_clone.claimant      = claimant
	populated_clone.signature     = signature
	populated_clone.establishment = establishment
	populated_clone.degree        = degree
	populated_clone.degree_short  = degree_short
	populated_clone.title         = title
	populated_clone.title_short   = title_short
	return populated_clone

///Returns a string decribing what's on the diploma.
/datum/diploma_details/proc/get_description_string()
	if(length(claimant))
		. = "A fancy print laminated paper that certifies that its bearer, [title_short][claimant], is indeed \a [title], whom earned \a [degree], and graduated from \the [establishment]."
	else
		. = "A fancy print laminated paper that certifies that its bearer is indeed \a [title], whom earned \a [degree], and graduated from \the [establishment]."

///Returns a string describing what is seen on closer inspection of the diploma.
/datum/diploma_details/proc/get_examine_string()
	if(length(claimant))
		. = "This one is signed [signature], [title_short][claimant] [degree_short]."
	else
		. = "The signature and name are left blank for some reason."

////////////////////////////////////////////////////////
// Diploma Structure
////////////////////////////////////////////////////////

///A display for diploma details
/obj/structure/sign/plaque/diploma
	abstract_type = /obj/structure/sign/plaque/diploma
	name          = "laminated diploma"
	desc          = "A wall-mounted laminated diploma."
	icon          = 'icons/obj/signs/plaques.dmi'
	icon_state    = "goldenplaque"
	material      = /decl/material/solid/wood/maple
	matter        = list(
		/decl/material/solid/glass = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/paper = MATTER_AMOUNT_TRACE,
	)
	parts_type = /obj/item/sign/diploma
	///Details on the diploma this plaque contains. Can be a path on definition, turns into an instance at runtime.
	var/datum/diploma_details/details = /datum/diploma_details

/obj/structure/sign/plaque/diploma/Initialize(ml, _mat, _reinf_mat)
	//Must be done before parent init
	if(ispath(details, /datum/diploma_details))
		details = new details
	. = ..()

/obj/structure/sign/plaque/diploma/update_description()
	desc = details.get_description_string()

/obj/structure/sign/plaque/diploma/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		to_chat(user, details.get_examine_string())

////////////////////////////////////////////////////////
// Diploma Item
////////////////////////////////////////////////////////

///A displayable diploma
/obj/item/sign/diploma
	abstract_type = /obj/item/sign/diploma
	name          = "diploma"
	sign_type     = /obj/structure/sign/plaque/diploma
	material      = /decl/material/solid/wood/maple
	matter        = list(
		/decl/material/solid/glass = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/paper = MATTER_AMOUNT_TRACE,
	)
	///Details on the diploma this plaque contains.  Can be a path on definition, turns into an instance at runtime.
	var/datum/diploma_details/details = /datum/diploma_details

/obj/item/sign/diploma/Initialize(ml, material_key)
	. = ..()
	if(ispath(details, /datum/diploma_details))
		details = new details

/obj/item/sign/diploma/set_sign(var/obj/structure/sign/plaque/diploma/S)
	. = ..()
	if(ispath(S))
		//If it's a path, create the default type of details
		details = null
		SetName(initial(S.name))
		var/detail_path = initial(S.details)
		if(ispath(detail_path, /datum/diploma_details))
			details = new detail_path
	else
		SetName(S.name)
		details = S.details.Clone()
	update_description()

/obj/item/sign/diploma/place_sign(turf/T, direction)
	var/obj/structure/sign/plaque/diploma/D = ..()
	D.details = details.Clone()
	D.update_description()
	return D

/obj/item/sign/diploma/proc/update_description()
	desc = details.get_description_string()

/obj/item/sign/diploma/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		to_chat(user, details.get_examine_string())

/obj/item/sign/diploma/attackby(obj/item/pen/W, mob/user)
	if(IS_PEN(W))
		sign_diploma(W, user)
		return TRUE
	return ..()

/obj/item/sign/diploma/proc/sign_diploma(var/obj/item/pen/P, var/mob/user)
	if(length(details.claimant))
		to_chat(user, SPAN_NOTICE("The diploma is already signed!"))
		return
	if(P.do_tool_interaction(TOOL_PEN, user, src, 1 SECONDS, "signing", "signing"))
		var/decl/tool_archetype/pen/parch = GET_DECL(TOOL_PEN)
		var/pen_color = P.get_tool_property(TOOL_PEN, TOOL_PROP_COLOR)
		var/pen_font  = P.get_tool_property(TOOL_PEN, TOOL_PROP_PEN_FONT)
		details.claimant  = parch.get_signature(user, P)
		details.signature = "<font face=\"[pen_font]\" color=[pen_color]><i>[details.claimant]</i></font>"
		update_description()

////////////////////////////////////////////////////////
// Fake Diploma
////////////////////////////////////////////////////////

/datum/diploma_details/fake
	abstract_type = /datum/diploma_details/fake

/datum/diploma_details/fake/get_description_string()
	. = "[..()] You don't recognize the establishment though, and half of latin words they used do not actually exist."

/obj/structure/sign/plaque/diploma/fake
	abstract_type = /obj/structure/sign/plaque/diploma/fake

////////////////////////////////////////////////////////
// Medical Diploma
////////////////////////////////////////////////////////

/datum/diploma_details/medical
	establishment = "Alpha Centauri Medical Academy"
	degree        = "master's degree in medicine"
	degree_short  = "MD"
	title         = "Doctor of Medicine"
	title_short   = "Dr."

/obj/structure/sign/plaque/diploma/medical
	name       = "medical diploma"
	details    = /datum/diploma_details/medical
	parts_type = /obj/item/sign/diploma/medical

/obj/item/sign/diploma/medical //the item grab the details from the structure so don't need to fill anything else
	name      = "medical diploma"
	sign_type = /obj/structure/sign/plaque/diploma/medical

////////////////////////////////////////////////////////
// Fake Medical Diploma
////////////////////////////////////////////////////////

/datum/diploma_details/fake/medical
	establishment = "Arcturus' Trade School"
	degree        = "theoritical master's degree in medicine"
	degree_short  = "MD"
	title         = "Doctor of Medicine"
	title_short   = "Dr."

/obj/structure/sign/plaque/diploma/fake/medical
	name       = "medical diploma"
	details    = /datum/diploma_details/fake/medical
	parts_type = /obj/item/sign/diploma/fake/medical

/obj/item/sign/diploma/fake/medical
	name      = "medical diploma"
	sign_type = /obj/structure/sign/plaque/diploma/fake/medical

////////////////////////////////////////////////////////
// Physics Diploma
////////////////////////////////////////////////////////

/datum/diploma_details/physics
	establishment = "CMa Physics Academy"
	degree        = "master's degree in theoritical physics"
	degree_short  = "PhD"
	title         = "Theoritical Physicist"
	title_short   = "Dr."

/obj/structure/sign/plaque/diploma/physics
	name       = "physics diploma"
	details    = /datum/diploma_details/physics
	parts_type = /obj/item/sign/diploma/physics

/obj/item/sign/diploma/physics
	name      = "physics diploma"
	sign_type = /obj/structure/sign/plaque/diploma/physics

////////////////////////////////////////////////////////
// Fake Science Diploma
////////////////////////////////////////////////////////

/datum/diploma_details/fake/physics
	establishment = "Pollux Academy of Sciences"
	degree        = "theoritical master's degree in theoritical physics"
	degree_short  = "PhD"
	title         = "Theoritical Physicist"
	title_short   = "Dr."

/obj/structure/sign/plaque/diploma/fake/physics
	name       = "physics diploma"
	details    = /datum/diploma_details/fake/physics
	parts_type = /obj/item/sign/diploma/fake/physics

/obj/item/sign/diploma/fake/physics
	name      = "physics diploma"
	sign_type = /obj/structure/sign/plaque/diploma/fake/physics
