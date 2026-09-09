/obj/item/natural_weapon/claws/drake
	_base_attack_force = 25

/obj/item/natural_weapon/claws/drake/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	if(!(. = ..()))
		return
	var/obj/item/organ/external/limb = target.get_organ(hit_zone)
	if(istype(limb))
		drake_infect_wounds(limb)

/obj/item/natural_weapon/claws/drake/hatchling
	_base_attack_force = 5
	attack_verb = list("clawed", "scratched")

/mob/living/human/grafadreka
	faction = "grafadreka"

/mob/living/human/grafadreka/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/grafadreka::uid
	. = ..()

/mob/living/human/grafadreka/hatchling/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	. = ..()
	set_bodytype(/decl/bodytype/quadruped/grafadreka/hatchling)

/mob/living/simple_animal/mob_mimic/grafadreka
	ai = /datum/mob_controller/aggressive
	mimic_mob = /mob/living/human/grafadreka
	natural_weapon = /obj/item/natural_weapon/claws/drake
	projectiletype = /obj/item/projectile/drake_spit
	projectilesound = /obj/item/projectile/drake_spit::fire_sound

/mob/living/simple_animal/mob_mimic/grafadreka/hatchling
	mimic_mob = /mob/living/human/grafadreka/hatchling
	natural_weapon = /obj/item/natural_weapon/claws/drake/hatchling
	projectiletype = /obj/item/projectile/drake_spit/weak
	projectilesound = /obj/item/projectile/drake_spit/weak::fire_sound
