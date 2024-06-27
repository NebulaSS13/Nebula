/spell/create_air/tower
	desc = "Allows you to generate a livable atmosphere in the area you are in."
	charge_max = 5

/spell/hand/burning_grip/tower
	desc = "Allows you cause an object to heat up intensly in someone's hand, making them drop it and whatever skin is attached."
	charge_max = 3

/spell/hand/slippery_surface/tower
	desc = "Allows you to slicken a small patch of floor. Anyone without sure-footing will find it hard to stay upright."
	charge_max = 2

/spell/aoe_turf/knock/tower
	charge_max = 2
	hidden_from_codex = TRUE

/spell/aoe_turf/smoke/tower
	charge_max = 2
	hidden_from_codex = TRUE

/spell/aoe_turf/conjure/faithful_hound/tower
	desc = "This spell allows you to summon a singular spectral dog that guards the nearby area. Anyone without the password is barked at or bitten."
	charge_max = 1
	spell_flags = 0

/spell/aoe_turf/conjure/force_portal/tower
	desc = "This spell allows you to summon a force portal. Anything that hits the portal gets sucked inside and is then thrown out when the portal explodes."
	charge_max = 2
	spell_flags = 0

/spell/acid_spray/tower
	desc = "The simplest form of aggressive conjuration: acid spray is quite effective in melting both man and object."
	charge_max = 2

/spell/targeted/heal_target/tower
	desc = "Allows you to heal yourself, or others, for a slight amount."
	charge_max = 2

/spell/targeted/heal_target/major/tower
	charge_max = 1
	spell_flags = INCLUDEUSER | SELECTABLE
	desc = "Allows you to heal others for a great amount."

/spell/targeted/heal_target/area/tower
	desc = "Allows you to heal everyone in an area for minor damage."
	charge_max = 1

/spell/targeted/ethereal_jaunt/tower
	desc = "Allows you to liquefy for a short duration, letting you pass through all dense objects."
	charge_max = 2
	spell_flags = Z2NOCAST | INCLUDEUSER

/spell/aoe_turf/conjure/forcewall/tower
	desc = "A temporary invincible wall for you to summon."
	charge_max = 3

/spell/targeted/equip_item/dyrnwyn/tower
	desc = "This spell allows you to summon a fiery golden sword for a short duration."
	charge_max = 1

/spell/targeted/equip_item/shield/tower
	desc = "This spell allows you to summon a magical shield for a short duration."
	charge_max = 1

/spell/targeted/projectile/dumbfire/fireball/tower
	desc = "Imbue yourself with the power of exploding fire."
	charge_max = 2