/obj/item/slide_projector
	name = "slide projector"
	desc = "A handy device capable of showing an enlarged projection of whatever you can fit inside."
	icon = 'icons/obj/items/device/projector.dmi'
	icon_state = "projector0"
	storage = /datum/storage/slide_projector
	material = /decl/material/solid/metal/steel
	var/static/list/projection_types = list(
		/obj/item/photo = /obj/effect/projection/photo,
		/obj/item/paper = /obj/effect/projection/paper,
		/obj/item = /obj/effect/projection
	)
	var/obj/item/current_slide
	var/obj/effect/projection/projection

/obj/item/slide_projector/Destroy()
	current_slide = null
	stop_projecting()
	. = ..()

/obj/item/slide_projector/on_update_icon()
	. = ..()
	icon_state = "projector[!!projection]"

/obj/item/slide_projector/get_mechanics_info()
	. = ..()
	. += "Use in hand to open the interface."

/obj/item/slide_projector/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!current_slide)
		return
	project_at(get_turf(target))

/obj/item/slide_projector/proc/set_slide(obj/item/new_slide)
	current_slide = new_slide
	playsound(loc, 'sound/machines/slide_change.ogg', 50)
	if(projection)
		project_at(get_turf(projection))

/obj/item/slide_projector/proc/check_projections()
	if(!projection)
		return
	if(!(projection in view(7,get_turf(src))))
		stop_projecting()

/obj/item/slide_projector/proc/stop_projecting()
	if(projection)
		QDEL_NULL(projection)
	events_repository.unregister(/decl/observ/moved, src, src, PROC_REF(check_projections))
	update_icon()

/obj/item/slide_projector/proc/project_at(turf/target)
	stop_projecting()
	if(!current_slide)
		return
	var/projection_type
	for(var/T in projection_types)
		if(istype(current_slide, T))
			projection_type = projection_types[T]
			break
	projection = new projection_type(target)
	projection.set_source(current_slide)
	events_repository.register(/decl/observ/moved, src, src, PROC_REF(check_projections))
	update_icon()

/obj/item/slide_projector/attack_self(mob/user)
	interact(user)

/obj/item/slide_projector/interact(mob/user)
	var/data = list()
	if(projection)
		data += "<a href='byond://?src=\ref[src];stop_projector=1'>Disable projector</a>"
	else
		data += "Projector inactive"

	var/table = list("<table><th>#<th>SLIDE<th>SHOW")
	var/i = 1
	for(var/obj/item/I in contents)
		table += "<tr><td>#[i]"
		if(I == current_slide)
			table += "<td><b>[I.name]</b><td>SHOWING"
		else
			table += "<td>[I.name]<td><a href='byond://?src=\ref[src];set_active=[i]'>SHOW</a>"
		i++
	data += jointext(table,null)
	var/datum/browser/popup = new(user, "slides\ref[src]", "Slide Projector")
	popup.set_content(jointext(data, "<br>"))
	popup.open()

/obj/item/slide_projector/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	. = ..()
	if(.)
		return
	if(href_list["stop_projector"])
		if(!projection)
			return TOPIC_HANDLED
		stop_projecting()
		. = TOPIC_REFRESH

	if(href_list["set_active"])
		var/index = text2num(href_list["set_active"])
		if(index < 1 || index > contents.len)
			return TOPIC_HANDLED
		set_slide(contents[index])
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)

/obj/effect/projection
	name = "projected slide"
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
	anchored = TRUE
	simulated = FALSE
	blend_mode = BLEND_ADD
	layer = ABOVE_LIGHTING_LAYER
	plane = ABOVE_LIGHTING_PLANE
	alpha = 100
	var/weakref/source

/obj/effect/projection/on_update_icon()
	add_filter("glow", 1, list(type = "drop_shadow", color = COLOR_WHITE, size = 4, offset = 1,x = 0, y = 0))
	project_icon()

/obj/effect/projection/proc/project_icon()
	var/obj/item/I = source.resolve()
	if(!istype(I))
		qdel(src)
		return
	overlays.Cut()
	var/mutable_appearance/MA = new(I)
	MA.plane = FLOAT_PLANE
	MA.layer = FLOAT_LAYER
	MA.appearance_flags = RESET_ALPHA
	MA.alpha = 170
	MA.pixel_x = 0
	MA.pixel_y = 0
	overlays |= MA

/obj/effect/projection/proc/set_source(obj/item/I)
	source = weakref(I)
	desc = "It's currently showing \the [I]."
	update_icon()

/obj/effect/projection/examine(mob/user, distance)
	. = ..()
	var/obj/item/slide = source.resolve()
	if(!istype(slide))
		qdel(src)
		return
	return slide.examine(user, 1)

/obj/effect/projection/photo
	alpha = 170

/obj/effect/projection/photo/project_icon()
	var/obj/item/photo/slide = source.resolve()
	if(!istype(slide))
		qdel(src)
		return
	icon = slide.img
	transform = matrix()
	transform *= 1 / slide.photo_size
	pixel_x = -32 * round(slide.photo_size/2)
	pixel_y = -32 * round(slide.photo_size/2)

/obj/effect/projection/paper
	alpha = 140

/obj/effect/projection/paper/project_icon()
	var/obj/item/paper/P = source.resolve()
	if(!istype(P))
		qdel(src)
		return
	overlays.Cut()
	if(P.info)
		icon_state = "text[rand(1,3)]"
