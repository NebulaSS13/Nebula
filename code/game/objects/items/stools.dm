//Todo: add leather and cloth for arbitrary coloured stools.
/obj/item/stool
	name                = "stool"
	desc                = "Apply butt."
	icon                = 'icons/obj/stool.dmi'
	icon_state          = ICON_STATE_WORLD
	randpixel           = 0
	w_class             = ITEM_SIZE_HUGE
	material            = DEFAULT_FURNITURE_MATERIAL
	material_alteration = MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_COLOR
	obj_flags           = OBJ_FLAG_SUPPORT_MOB | OBJ_FLAG_ROTATABLE
	_base_attack_force  = 10
	/// The padding extension type for this stool. If null, no extension is created and this stool cannot be padded.
	var/padding_extension_type = /datum/extension/padding
	var/decl/material/initial_padding_material
	var/initial_padding_color

/obj/item/stool/padded
	icon_state = "stool_padded_preview" //set for the map
	initial_padding_material = /decl/material/solid/organic/cloth
	initial_padding_color = "#9d2300"

/obj/item/stool/Initialize()
	. = ..()
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	if(padding_extension_type && initial_padding_material)
		get_or_create_extension(src, padding_extension_type, initial_padding_material, initial_padding_color)
	update_icon()

/obj/item/stool/bar
	name = "bar stool"
	icon = 'icons/obj/bar_stool.dmi'

/obj/item/stool/bar/padded
	icon_state = "bar_stool_padded_preview"
	initial_padding_material = /decl/material/solid/organic/cloth
	initial_padding_color = "#9d2300"

/obj/item/stool/update_name()
	..()
	if(material_alteration & MAT_FLAG_ALTERATION_NAME)
		var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
		var/decl/material/padding_material = padding_extension?.get_padding_material()
		SetName("[padding_material?.adjective_name || material.adjective_name] [base_name || initial(name)]")
	update_desc()

/obj/item/stool/proc/update_desc()
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/decl/material/padding_material = padding_extension?.get_padding_material()
	if(padding_material)
		desc = "A padded stool. Apply butt. It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		desc = "A stool. Apply butt with care. It's made of [material.use_name]."

/obj/item/stool/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/decl/material/padding_material = padding_extension?.get_padding_material()
	if(padding_material)
		add_overlay(overlay_image(icon, "[icon_state]-padding", padding_extension.get_padding_color(), RESET_COLOR|RESET_ALPHA))
	// Strings.
	update_name()

/obj/item/stool/apply_additional_mob_overlays(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	. = ..()
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/decl/material/padding_material = padding_extension?.get_padding_material()
	if(padding_material)
		overlay.add_overlay(overlay_image(icon, "[overlay.icon_state]-padding", padding_extension.get_padding_color(), RESET_COLOR|RESET_ALPHA))

/obj/item/stool/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if (prob(5))
		user.visible_message("<span class='danger'>[user] breaks [src] over [target]'s back!</span>")
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(target)
		dismantle() //This deletes self.

		var/blocked = target.get_blocked_ratio(hit_zone, BRUTE, damage = 20)
		SET_STATUS_MAX(target, STAT_WEAK, (10 * (1 - blocked)))
		target.apply_damage(20, BRUTE, hit_zone, src)
		return 1

	return ..()

/obj/item/stool/explosion_act(severity)
	. = ..()
	if(. && !QDELETED(src) && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(5))))
		physically_destroyed()

/obj/item/stool/proc/dismantle()
	if(material)
		material.create_object(get_turf(src))
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	padding_extension?.remove_padding(do_icon_update = FALSE)
	qdel(src)

/obj/item/stool/attackby(obj/item/used_item, mob/user)
	if(IS_WRENCH(used_item))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		dismantle()
		return TRUE
	return ..()

/obj/item/stool/rustic
	name_prefix = "rustic"
	name        = "stool"
	icon        = 'icons/obj/stool_rustic.dmi'
	material    = /decl/material/solid/organic/wood/walnut
	color       = /decl/material/solid/organic/wood/walnut::color
	// Cannot be padded.
	padding_extension_type = null

/obj/item/stool/rustic/update_desc()
	desc = "A rustic stool carved from wood. It's a little rickety and wobbles under any weight, but it'll do."

//Generated subtypes for mapping porpoises
/obj/item/stool/wood
	material = /decl/material/solid/organic/wood/oak
