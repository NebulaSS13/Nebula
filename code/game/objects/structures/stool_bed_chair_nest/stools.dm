//Todo: add leather and cloth for arbitrary coloured stools.
/obj/item/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "stool_preview" //set for the map
	item_state = "stool"
	randpixel = 0
	force = 10
	throwforce = 10
	w_class = ITEM_SIZE_HUGE
	material = DEFAULT_FURNITURE_MATERIAL
	var/base_icon = "stool"
	var/decl/material/padding_material

/obj/item/stool/padded
	icon_state = "stool_padded_preview" //set for the map
	padding_material = /decl/material/solid/carpet

/obj/item/stool/Initialize()
	. = ..()
	if(!istype(material))
		return INITIALIZE_HINT_QDEL
	if(ispath(padding_material, /decl/material))
		padding_material = GET_DECL(padding_material)
	force = round(material.get_blunt_damage()*0.4)
	update_icon()

/obj/item/stool/padded
	padding_material = /decl/material/solid/carpet

/obj/item/stool/bar
	name = "bar stool"
	icon_state = "bar_stool_preview" //set for the map
	item_state = "bar_stool"
	base_icon = "bar_stool"

/obj/item/stool/bar/padded
	icon_state = "bar_stool_padded_preview"
	padding_material = /decl/material/solid/carpet

/obj/item/stool/on_update_icon()
	// Prep icon.
	icon_state = ""
	// Base icon.
	var/list/noverlays = list()
	var/image/I = image(icon, "[base_icon]_base")
	I.color = material.color
	noverlays |= I
	// Padding overlay.
	if(padding_material)
		I =  image(icon, "[base_icon]_padding")
		I.color = padding_material.color
		noverlays += I
	overlays = noverlays
	// Strings.
	if(padding_material)
		SetName("[padding_material.solid_name] [initial(name)]") //this is not perfect but it will do for now.
		desc = "A padded stool. Apply butt. It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		SetName("[material.solid_name] [initial(name)]")
		desc = "A stool. Apply butt with care. It's made of [material.use_name]."

/obj/item/stool/proc/add_padding(var/padding_type)
	padding_material = GET_DECL(padding_type)
	update_icon()

/obj/item/stool/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/item/stool/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if (prob(5))
		user.visible_message("<span class='danger'>[user] breaks [src] over [target]'s back!</span>")
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(target)
		dismantle() //This deletes self.

		var/blocked = target.get_blocked_ratio(hit_zone, BRUTE, damage = 20)
		target.Weaken(10 * (1 - blocked))
		target.apply_damage(20, BRUTE, hit_zone, src)
		return 1

	return ..()

/obj/item/stool/explosion_act(severity)
	. = ..()
	if(. && !QDELETED(src) && (severity == 1 || (severity == 2 && prob(50)) || (severity == 3 && prob(5))))
		physically_destroyed()

/obj/item/stool/proc/dismantle()
	if(material)
		material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
	qdel(src)

/obj/item/stool/attackby(obj/item/W, mob/user)
	if(isWrench(W))
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
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = /decl/material/solid/carpet
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags & MAT_FLAG_PADDING))
				padding_type = "[M.material.type]"
		if(!padding_type)
			to_chat(user, "You cannot pad \the [src] with that.")
			return
		C.use(1)
		if(!istype(src.loc, /turf))
			user.drop_from_inventory(src)
			src.dropInto(loc)
		to_chat(user, "You add padding to \the [src].")
		add_padding(padding_type)
		return
	else if(isWirecutter(W))
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
	material = /decl/material/solid/wood
