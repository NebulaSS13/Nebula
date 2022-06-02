//the fountain of youth/unyouth

/obj/structure/fountain
	name       = "strange fountain"
	desc       = "The water from the spout is still as if frozen in time, yet the water in the base ripples perpetually."
	icon       = 'icons/obj/fountain.dmi'
	icon_state = "fountain"
	density    = TRUE
	anchored   = TRUE
	unacidable = TRUE
	pixel_x    = -16
	var/used   = FALSE

/obj/structure/fountain/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	light_color = get_random_colour(lower = 190)
	set_light(5, 0.5, light_color)

/obj/structure/fountain/attack_hand(var/mob/user)
	if(user.incapacitated())
		return
	if(!CanPhysicallyInteract(user))
		return
	if(used)
		to_chat(user,  SPAN_WARNING("\The [src] is still and lifeless..."))
		return

	var/mob/living/carbon/human/H = user
	if(!istype(H) || H.isSynthetic())
		to_chat(user, SPAN_WARNING("A feeling of foreboding stills your hand. The fountain is not for your kind."))
		return

	if(alert("As you reach out to touch the fountain, a feeling of doubt overcomes you. Steel yourself and proceed?",,"Yes", "No") == "Yes")
		visible_message("\The [user] touches \the [src].")
		time_dilation(user)
	else
		visible_message("\The [user] retracts their hand suddenly.")

/obj/structure/fountain/proc/time_dilation(var/mob/living/carbon/human/user)
	for(var/mob/living/L in oviewers(7, src))
		L.flash_eyes(3)
		SET_STATUS_MAX(L, STAT_BLURRY, 9)

	visible_message("<span class='warning'>\The [src] erupts in a bright flash of light!</span>")
	playsound(src,'sound/items/time.ogg',100)

	var/direction = rand(1,6)
	if(direction == 1) //become older
		to_chat(user, "<span class='cultannounce'>You touch the fountain. All the memories of your life seem to fade into the distant past as seconds drag like years. You feel the inexplicable sensation of your skin tightening and thinning across your entire body as your muscles degrade and your joints weaken. Time returns to its 'normal' pace. You can only just barely remember touching the fountain.</span>")
		user.became_older = TRUE
		user.change_hair_color(80, 80, 80)
		var/age_holder = round(rand(15,20))
		user.set_age(age_holder)
	else               //become younger
		to_chat(user, "<span class='cultannounce'>You touch the fountain. Everything stops - then reverses. You relive in an instant the events of your life. The fountain, yesterday's lunch, your first love, your first kiss. It all feels as though it just happened moments ago. Then it feels like it never happened at all. Time reverses back into normality and continues its advance. You feel great, but why are you here?</span>")
		user.became_younger = TRUE
		user.set_age(rand(15,17))
	used = TRUE
	desc = "The water flows beautifully from the spout, but the water in the pool does not ripple."

/obj/structure/fountain/mundane
	name                   = "fountain"
	desc                   = "A beautifully constructed fountain."
	icon_state             = "fountain_g"
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	w_class                = ITEM_SIZE_STRUCTURE
	material               = /decl/material/solid/stone/marble 
	used                   = TRUE

/obj/structure/fountain/mundane/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_CLIMBABLE
	setup_reagents(ml)

/obj/structure/fountain/mundane/proc/setup_reagents(var/should_fill = TRUE)
	create_reagents(500)
	if(should_fill)
		reagents.add_reagent(/decl/material/liquid/water, reagents.maximum_volume) //Don't give free water when building one

/obj/structure/fountain/mundane/attack_hand(mob/user)
	return