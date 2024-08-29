//Todo: add leather and cloth for arbitrary coloured stools.
/obj/item/stool
	name               = "stool"
	desc               = "Apply butt."
	icon               = 'icons/obj/furniture.dmi'
	icon_state         = "stool_preview" //set for the map
	item_state         = "stool"
	randpixel          = 0
	w_class            = ITEM_SIZE_HUGE
	material           = DEFAULT_FURNITURE_MATERIAL
	obj_flags          = OBJ_FLAG_SUPPORT_MOB | OBJ_FLAG_ROTATABLE
	_base_attack_force = 10
	var/base_icon      = "stool"
	var/padding_color
	var/decl/material/padding_material

/obj/item/stool/padded
	icon_state = "stool_padded_preview" //set for the map
	padding_material = /decl/material/solid/organic/cloth
	padding_color = "#9d2300"

/obj/item/stool/Initialize()
	. = ..()
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	if(ispath(padding_material, /decl/material))
		padding_material = GET_DECL(padding_material)
	update_icon()

/obj/item/stool/bar
	name = "bar stool"
	icon_state = "bar_stool_preview" //set for the map
	item_state = "bar_stool"
	base_icon = "bar_stool"

/obj/item/stool/bar/padded
	icon_state = "bar_stool_padded_preview"
	padding_material = /decl/material/solid/organic/cloth
	padding_color = "#9d2300"

/obj/item/stool/on_update_icon()
	. = ..()
	// Prep icon.
	icon_state = ""
	// Base icon.
	var/list/noverlays = list(overlay_image(icon, "[base_icon]_base", get_color(), RESET_COLOR|RESET_ALPHA))
	// Padding overlay.
	if(padding_material)
		noverlays += overlay_image(icon, "[base_icon]_padding", padding_color || padding_material.color)
	set_overlays(noverlays)
	// Strings.
	if(padding_material)
		SetName("[padding_material.solid_name] [initial(name)]") //this is not perfect but it will do for now.
		desc = "A padded stool. Apply butt. It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		SetName("[material.solid_name] [initial(name)]")
		desc = "A stool. Apply butt with care. It's made of [material.use_name]."

/obj/item/stool/proc/add_padding(var/padding_type, var/new_padding_color)
	padding_material = GET_DECL(padding_type)
	padding_color = new_padding_color
	update_icon()

/obj/item/stool/proc/remove_padding()
	if(padding_material)
		var/list/res = padding_material.create_object(get_turf(src))
		if(padding_color)
			for(var/obj/item/thing in res)
				thing.set_color(padding_color)
	padding_material = null
	padding_color = null
	update_icon()

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
	if(padding_material)
		padding_material.create_object(get_turf(src))
	qdel(src)

/obj/item/stool/attackby(obj/item/W, mob/user)
	if(IS_WRENCH(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		dismantle()
		qdel(src)
	else if(istype(W,/obj/item/stack))
		if(padding_material)
			to_chat(user, "\The [src] is already padded.")
			return
		var/obj/item/stack/C = W
		if(C.get_amount() < 1) // How??
			qdel(C)
			return

		var/padding_type
		var/new_padding_color
		if(istype(W, /obj/item/stack/tile) || istype(W, /obj/item/stack/material/bolt))
			padding_type = W.material?.type
			new_padding_color = W.paint_color

		if(padding_type)
			var/decl/material/padding_mat = GET_DECL(padding_type)
			if(!istype(padding_mat) || !(padding_mat.flags & MAT_FLAG_PADDING))
				padding_type = null

		if(!padding_type)
			to_chat(user, "You cannot pad \the [src] with that.")
			return

		C.use(1)
		if(!isturf(src.loc))
			user.drop_from_inventory(src)
			src.dropInto(loc)
		to_chat(user, "You add padding to \the [src].")
		add_padding(padding_type, new_padding_color)
		return

	else if(IS_WIRECUTTER(W))
		if(!padding_material)
			to_chat(user, "\The [src] has no padding to remove.")
			return
		to_chat(user, "You remove the padding from \the [src].")
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		remove_padding()
	else
		..()

//Generated subtypes for mapping porpoises
/obj/item/stool/wood
	material = /decl/material/solid/organic/wood
