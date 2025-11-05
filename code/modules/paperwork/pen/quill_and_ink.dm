/obj/item/pen/fancy/quill
	name              = "quill pen"
	icon              = 'icons/obj/items/pens/pen_quill.dmi'
	sharp             = FALSE
	material          = /decl/material/solid/organic/skin/feathers
	pen_quality       = TOOL_QUALITY_DEFAULT
	max_uses          = 5 // gotta re-ink it often!
	stroke_color      = /decl/material/liquid/pigment/black/ink::color
	stroke_color_name = "inky black"

/obj/item/pen/fancy/quill/Initialize(ml, material_key)
	. = ..()
	set_tool_property(TOOL_PEN, TOOL_PROP_EMPTY_MESSAGE, "out of ink")

/obj/item/pen/fancy/quill/fluid_act(datum/reagents/fluids)
	. = ..()
	if(!IS_PEN(src))
		return // someone made us not a pen, somehow
	var/ink_amount = fluids.has_reagent(/decl/material/liquid/pigment/black/ink)
	if(ink_amount <= 0)
		return
	// be lenient about contamination; it just has to be at least half
	if(!istype(fluids.get_primary_reagent_decl(), /decl/material/liquid/pigment/black/ink))
		return
	var/current_uses = get_tool_property(TOOL_PEN, TOOL_PROP_USES)
	var/const/charges_per_ink = 4 // this many charges per unit of ink
	var/ink_used = CHEMS_QUANTIZE(min((max_uses - current_uses) / charges_per_ink, ink_amount))
	fluids.remove_reagent(/decl/material/liquid/pigment/black/ink, ink_used)
	set_tool_property(TOOL_PEN, TOOL_PROP_USES, max(max_uses, current_uses + (ink_used * charges_per_ink)))
	update_icon()

// ink overlay that fades as we run out of ink
/obj/item/pen/fancy/quill/on_update_icon()
	. = ..()
	var/ink_alpha = 255 * get_tool_property(TOOL_PEN, TOOL_PROP_USES) / max_uses
	if(ink_alpha > 25) // some arbitrary minimum alpha cutoff
		var/image/ink_overlay = overlay_image(icon, "[icon_state]-inked")
		ink_overlay.alpha = ink_alpha
		add_overlay(ink_overlay)

/obj/item/pen/fancy/quill/make_pen_description()
	desc = "A large feather, sharpened and cut to hold ink for scribing."

/obj/item/pen/fancy/quill/goose
	name        = "dire goose quill"
	icon        = 'icons/obj/items/pens/pen_dire_quill.dmi'
	pen_quality = TOOL_QUALITY_BEST
	max_uses    = 10

/obj/item/pen/fancy/quill/goose/make_pen_description()
	desc = "A quill fashioned from a feather of the dire goose makes an excellent writing instrument, as well as a valuable trophy."

// Inkwell
/obj/item/chems/glass/inkwell
	name = "inkwell"
	icon = 'icons/obj/items/inkwell.dmi'
	icon_state = ICON_STATE_WORLD
	desc = "An inkwell used to hold ink. Dip a quill pen into this to re-ink it."
	chem_volume = 30
	/// The minimum amount of ink in the inkwell when populating reagents.
	var/starting_volume_low = 20
	/// The maximum amount of ink in the inkwell when populating reagents.
	var/starting_volume_high = 30

/obj/item/chems/glass/inkwell/get_edible_material_amount(mob/eater)
	return 0

/obj/item/chems/glass/inkwell/get_utensil_food_type()
	return null

/obj/item/chems/glass/inkwell/can_lid()
	return FALSE

/obj/item/chems/glass/inkwell/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/pigment/black/ink, rand(starting_volume_low, starting_volume_high))

/obj/item/chems/glass/inkwell/update_overlays()
	. = ..()
	icon_state = get_world_inventory_state()
	if(locate(/obj/item/pen/fancy/quill) in src)
		add_overlay("[icon_state]-quill")

/obj/item/chems/glass/inkwell/attackby(obj/item/used_item, mob/user)
	if(IS_PEN(used_item) && istype(used_item, /obj/item/pen/fancy/quill))
		var/obj/item/pen/fancy/quill/quill = used_item
		var/current_uses = quill.get_tool_property(TOOL_PEN, TOOL_PROP_USES)
		if(current_uses >= quill.max_uses)
			to_chat(user, SPAN_WARNING("\The [quill] doesn't need any more ink!"))
			return TRUE
		if(reagents?.total_liquid_volume <= 0)
			to_chat(user, SPAN_WARNING("\The [src] is empty!"))
			return TRUE
		to_chat(user, SPAN_NOTICE("You dip \the [quill] into \the [src]."))
		quill.fluid_act(reagents)
		update_icon()
		return TRUE
	return ..()

/obj/item/chems/glass/inkwell/attack_hand(mob/user)
	var/obj/item/pen/fancy/quill/existing_quill = locate(/obj/item/pen/fancy/quill) in src
	if(existing_quill)
		user.put_in_hands(existing_quill)
		to_chat(user, SPAN_NOTICE("You remove \the [existing_quill] from \the [src]."))
		update_icon()
		return TRUE
	return ..()

// This override lets you pick up an inkwell without removing the quill in it first.
/obj/item/chems/glass/inkwell/handle_mouse_drop(atom/over, mob/user, params)
	if(over == user && Adjacent(user) && user.get_empty_hand_slot())
		user.put_in_hands(src)
		return TRUE
	. = ..()

/obj/item/chems/glass/inkwell/receive_mouse_drop(atom/dropping, mob/user, params)
	if(istype(dropping, /obj/item/pen/fancy/quill) && Adjacent(user) && user.Adjacent(dropping))
		var/obj/item/pen/fancy/quill/new_quill = dropping
		var/obj/item/pen/fancy/quill/existing_quill = locate(/obj/item/pen/fancy/quill) in src
		if(existing_quill)
			to_chat(user, SPAN_WARNING("\The [existing_quill] is already in \the [src], \the [new_quill] won't fit!"))
			return TRUE
		to_chat(user, SPAN_NOTICE("You put \the [new_quill] into \the [src]."))
		user.remove_from_mob(new_quill, src)
		update_icon()
		return TRUE
	return ..()

// This subtype starts with a quill.
/obj/item/chems/glass/inkwell/quilled
	icon_state = "quilled_preview"

/obj/item/chems/glass/inkwell/quilled/Initialize(ml, material_key)
	. = ..()
	var/obj/item/new_quill = new /obj/item/pen/fancy/quill(src)
	new_quill.fluid_act(reagents)
	update_icon()