/decl/bodytype/starlight/shadow
	name                = "shadow"
	desc                = "A wound of darkness inflicted upon the world."
	icon_base           = 'icons/mob/human_races/species/shadow/body.dmi'
	icon_deformed       = 'icons/mob/human_races/species/shadow/body.dmi'
	body_flags          = BODY_FLAG_NO_DNA | BODY_FLAG_NO_DEFIB | BODY_FLAG_NO_STASIS
	eye_darksight_range = 8
	uid                 = "bodytype_starlight_shadow"

/decl/blood_type/shadowstuff
	name = "shadowstuff"
	antigen_category = "shadowstuff"
	splatter_name = "shadowstuff"
	splatter_desc = "A puddle of shadowstuff."
	splatter_colour = COLOR_GRAY80

/decl/species/starlight/shadow
	name = "Shadow"
	name_plural = "shadows"
	description = "A being of pure darkness, hates the light and all that comes with it."
	butchery_data = null

	available_bodytypes = list(/decl/bodytype/starlight/shadow)

	unarmed_attacks = list(/decl/natural_attack/claws/strong, /decl/natural_attack/bite/sharp)
	shock_vulnerability = 0

	blood_types = list(
		/decl/blood_type/shadowstuff
	)
	flesh_color = "#aaaaaa"

	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "dissolves into ash..."

	species_flags = SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_EMBED

/decl/species/starlight/shadow/handle_environment_special(var/mob/living/human/H)
	if(H.is_in_stasis() || H.stat == DEAD || H.isSynthetic())
		return
	var/light_amount = 0
	if(isturf(H.loc))
		var/turf/T = H.loc
		light_amount = T.get_lumcount() * 10
	if(light_amount > 2) //if there's enough light, start dying
		H.take_overall_damage(1,1)
	else //heal in the dark
		H.heal_overall_damage(1,1)