/obj/item/armblade
	icon_state = "armblade"
	item_state = null
	name = "armblade"
	icon = 'icons/obj/augment.dmi'
	desc = "A handy utility blade for the discerning augmentee. Warranty void if used for cutting."
	base_parry_chance = 30
	sharp = 1
	edge = 1
	attack_verb = list("stabbed", "sliced", "cut")
	origin_tech = @'{"materials":1,"engineering":1,"combat":2}'
	material = /decl/material/solid/metal/steel

/obj/item/armblade/can_take_wear_damage()
	return FALSE

/obj/item/organ/internal/augment/active/simple/armblade
	name = "embedded blade"
	desc = "A sturdy housing for a steel utility blade."
	action_button_name = "Deploy blade"
	icon_state = "armblade"
	allowed_organs = list(BP_AUGMENT_R_ARM, BP_AUGMENT_L_ARM)
	holding = /obj/item/armblade
	//Limited to robolimbs
	augment_flags = AUGMENTATION_MECHANIC
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/armblade/claws
	icon_state = "wolverine"
	name = "combat claws"
	desc = "These do not grow back."
	base_parry_chance = 40
	origin_tech = @'{"materials":2,"engineering":2,"combat":3}'

//Alternate look
/obj/item/organ/internal/augment/active/simple/wolverine
	name = "cyberclaws"
	desc = "An unusual type of cybernetic weaponry, these sharp blades are bound to turn heads."
	action_button_name = "Deploy claws"
	icon_state = "wolverine"
	allowed_organs = list(BP_AUGMENT_R_HAND, BP_AUGMENT_L_HAND)
	holding = /obj/item/armblade/claws
	//Limited to robolimbs
	augment_flags = AUGMENTATION_MECHANIC
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT)
