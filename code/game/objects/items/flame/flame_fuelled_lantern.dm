/obj/item/flame/fuelled/lantern
	name                = "oil lantern"
	desc                = "An unwieldy oil lantern."
	icon                = 'icons/obj/items/flame/lantern.dmi'
	_base_attack_force  = 10
	attack_verb         = list ("bludgeoned", "bashed", "whack")
	w_class             = ITEM_SIZE_NORMAL
	atom_flags          = ATOM_FLAG_OPEN_CONTAINER
	obj_flags           = OBJ_FLAG_CONDUCTIBLE
	slot_flags          = SLOT_LOWER_BODY
	lit_light_power     = 0.7
	lit_light_range     = 6
	max_fuel            = 60
	_fuel_spend_amt     = (1 / 60) // a full lantern should last an hour
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	material            = /decl/material/solid/metal/copper
	can_manually_light  = FALSE
	sconce_can_hold     = TRUE

/obj/item/flame/fuelled/lantern/get_sconce_overlay()
	. = list(overlay_image(icon, "[icon_state]-sconce", color = color, flags = RESET_COLOR))
	if(lit)
		. += overlay_image(icon, "[icon_state]-sconce-lit", color = lit_light_color, flags = RESET_COLOR)

/obj/item/flame/fuelled/lantern/filled
	start_fuelled = TRUE

/obj/item/flame/fuelled/lantern/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(lit)
		add_overlay(overlay_image(icon, "[icon_state]-over", lit_light_color, flags = RESET_COLOR))

/obj/item/flame/fuelled/lantern/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)
	if(overlay && lit && (slot == slot_belt_str || (slot in global.all_hand_slots)))
		overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]-over", lit_light_color, flags = RESET_COLOR)
	return ..()
