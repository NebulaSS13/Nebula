// Permits (drone identification, gun permit, etc)
/obj/item/clothing/permit
	name = "permit"
	desc = "A permit for something."
	icon = 'icons/clothing/accessories/permits.dmi'
	w_class = ITEM_SIZE_TINY
	accessory_slot = ACCESSORY_SLOT_MEDAL
	/// If set, the accents on the ID are set to this color using an overlay.
	var/detail_color = COLOR_GUNMETAL
	/// Each string in this list is an overlay applied to the permit icon. Example: list("goldstripe")
	var/list/extra_details
	/// Set to TRUE when someone names the permit by using it in hand rather than using a labeler. Prevents doing so again.
	var/hand_name_used = FALSE
	/// String. When set, owner is set to this on initialize.
	var/default_owner = null

/obj/item/clothing/permit/Initialize()
	. = ..()
	get_or_create_extension(src, /datum/extension/labels/single)
	if(istext(default_owner))
		set_owner(default_owner, force = TRUE)

/obj/item/clothing/permit/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && detail_color)
		overlay.overlays += overlay_image(overlay.icon, "[overlay.icon_state]-colors", detail_color, RESET_COLOR)
	. = ..()

/obj/item/clothing/permit/on_update_icon()
	. = ..()
	if(detail_color)
		add_overlay(overlay_image(icon, "[icon_state]-colors", detail_color, RESET_COLOR))
	for(var/detail in extra_details)
		add_overlay(overlay_image(icon, "[icon_state]-[detail]", flags = RESET_COLOR))

/obj/item/clothing/permit/attack_self(mob/living/user)
	var/datum/extension/labels/label_ext = get_extension(src, /datum/extension/labels)
	if(length(label_ext.labels))
		to_chat(user, SPAN_WARNING("This permit's integrated labeler can't function if a label is already present. Please remove any existing labels or blockages and try again."))
		return
	if(hand_name_used)
		to_chat(user, SPAN_WARNING("This permit's integrated ink cartridge has already been used. New labels must be applied manually using a hand labeler."))
		return
	var/name_to_use = user.get_authentification_name(if_no_id = null)
	if(!name_to_use)
		to_chat(user, SPAN_WARNING("Unable to link permit with ID card. Please ensure your ID card is in range of the permit and try again."))
		return
	if(alert(user, "Claim this [name] for [name_to_use]? Once you claim it, the name can only be replaced using a hand labeler.", "Claim \the [src]?", "Yes", "No") != "Yes")
		return
	hand_name_used = TRUE
	to_chat(user, SPAN_NOTICE("You claim \the [src] for [name_to_use].")) // must be here so that the label isn't included already
	set_owner(name_to_use)

/obj/item/clothing/permit/proc/set_owner(owner_name, force = FALSE)
	var/datum/extension/labels/label_ext = get_extension(src, /datum/extension/labels)
	if(force)
		label_ext.RemoveAllLabels()
	if(!length(label_ext.labels))
		label_ext.AttachLabel(null, owner_name)

/obj/item/clothing/permit/gun
	name = "weapon permit"
	desc = "A card indicating that the owner is allowed to carry a weapon."
	detail_color = COLOR_NT_RED

/obj/item/clothing/permit/gun/bar
	name = "bar shotgun permit"
	desc = "A card indicating that the owner is allowed to carry a shotgun in the bar."

/obj/item/clothing/permit/gun/planetside
	name = "planetside weapon permit"
	desc = "A card indicating that the owner is allowed to carry a weapon while on the surface."
	detail_color = COLOR_PALE_PINK

/obj/item/clothing/permit/gun/paramedic
	name = "paramedic weapon permit"
	desc = "A card indicating that the owner is allowed to carry a weapon while on EVA retrieval missions."
	detail_color = COLOR_SKY_BLUE

/obj/item/clothing/permit/chaplain
	name = "holy weapon permit"
	desc = "A card indicating that the owner is allowed to carry a weapon for religious rites and purposes."
	detail_color = COLOR_GRAY15

/obj/item/clothing/permit/gun/planetside/exploration
	name = "explorer weapon permit"
	desc = "A card indicating that the owner is allowed to carry weaponry during active exploration missions."