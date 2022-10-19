/obj/structure/take_damage(amount, damage_type = BRUTE, damage_flags = 0, inflicter = null, armor_pen = 0, target_zone = null, quiet = FALSE)
	if(material && material.is_brittle())
		if(!reinf_material)
			amount *= STRUCTURE_BRITTLE_MATERIAL_DAMAGE_MULTIPLIER
		else if(reinf_material.is_brittle())
			amount *= STRUCTURE_BRITTLE_MATERIAL_DAMAGE_MULTIPLIER

	. = ..(amount, damage_type, damage_flags, inflicter, armor_pen, target_zone, quiet)

	if(. > 0 && !quiet)
		show_damage_message(health / max_health)

//#TODO: Might need to eventually handle evironment smash as an attack instead of as a boolean check

/obj/structure/proc/show_damage_message(var/perc)
	if(perc > 0.75)
		return
	if(perc <= 0.25 && last_damage_message < 0.25)
		visible_message(SPAN_DANGER("\The [src] looks like it's about to break!"))
		last_damage_message = 0.25
	else if(perc <= 0.5 && last_damage_message < 0.5)
		visible_message(SPAN_WARNING("\The [src] looks seriously damaged!"))
		last_damage_message = 0.5
	else if(perc <= 0.75 && last_damage_message < 0.75)
		visible_message(SPAN_WARNING("\The [src] is showing some damage!"))
		last_damage_message = 0.75

/obj/structure/physically_destroyed(var/skip_qdel)
	if(..(TRUE))
		return dismantle() //#FIXME: This might not be generic enough?
