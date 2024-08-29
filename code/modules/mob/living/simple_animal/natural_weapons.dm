/obj/item/natural_weapon
	name = "natural weapons"
	gender = PLURAL
	attack_verb = list("attacked")
	atom_damage_type =  BRUTE
	canremove = FALSE
	obj_flags = OBJ_FLAG_CONDUCTIBLE //for intent of shocking checks, they're right inside the animal
	is_spawnable_type = FALSE
	needs_attack_dexterity = DEXTERITY_NONE
	var/show_in_message   // whether should we show up in attack message, e.g. 'urist has been bit with teeth by carp' vs 'urist has been bit by carp'

/obj/item/natural_weapon/attack_message_name()
	return show_in_message ? ..() : null

/obj/item/natural_weapon/can_embed()
	return FALSE

/obj/item/natural_weapon/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	if(!(. = ..()))
		return
	if(istype(user, /mob/living/simple_animal))
		var/mob/living/simple_animal/animal = user
		animal.apply_attack_effects(target)

/obj/item/natural_weapon/bite
	name = "teeth"
	attack_verb = list("bitten")
	hitsound = 'sound/weapons/bite.ogg'
	_base_attack_force = 10
	sharp = TRUE

/obj/item/natural_weapon/bite/weak
	_base_attack_force = 5
	attack_verb = list("bitten", "nipped")

/obj/item/natural_weapon/bite/mouse
	_base_attack_force = 1
	attack_verb = list("nibbled")
	hitsound = null

/obj/item/natural_weapon/bite/strong
	_base_attack_force = 20

/obj/item/natural_weapon/claws
	name = "claws"
	attack_verb = list("mauled", "clawed", "slashed")
	_base_attack_force = 10
	sharp = TRUE
	edge = TRUE

/obj/item/natural_weapon/claws/strong
	_base_attack_force = 25

/obj/item/natural_weapon/claws/weak
	_base_attack_force = 5
	attack_verb = list("clawed", "scratched")

/obj/item/natural_weapon/hooves
	name = "hooves"
	attack_verb = list("kicked")

/obj/item/natural_weapon/punch
	name = "fists"
	attack_verb = list("punched")
	_base_attack_force = 10

/obj/item/natural_weapon/pincers
	name = "pincers"
	attack_verb = list("snipped", "pinched")

/obj/item/natural_weapon/drone_slicer
	name = "sharpened leg"
	gender = NEUTER
	attack_verb = list("sliced")
	atom_damage_type =  BRUTE
	edge = TRUE
	show_in_message = TRUE

/obj/item/natural_weapon/beak
	name = "beak"
	gender = NEUTER
	attack_verb = list("pecked", "jabbed", "poked")
	sharp = TRUE

/obj/item/natural_weapon/large
	_base_attack_force = 15

/obj/item/natural_weapon/giant
	_base_attack_force = 30