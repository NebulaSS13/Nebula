/datum/codex_entry/baton
	associated_paths = list(/obj/item/baton, /obj/item/baton/loaded)
	mechanics_text = "The baton needs to be turned on to apply the stunning effect. Use it in your hand to toggle it on or off. If your intent is \
	set to 'harm', you will inflict damage when using it, regardless if it is on or not. Each stun reduces the baton's charge, which can be replenished by \
	putting it inside a weapon recharger."
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/energy_sword
	associated_paths = list(/obj/item/energy_blade/sword)
	antag_text = "The energy sword is a very strong melee weapon, capable of severing limbs easily, if they are targeted. It can also has a chance \
	to block projectiles and melee attacks while it is on and being held. The sword can be toggled on or off by using it in your hand. While it is off, \
	it can be concealed in your pocket or bag."
	available_to_map_tech_level = MAP_TECH_LEVEL_SPACE

/datum/codex_entry/spear
	associated_paths = list(/obj/item/bladed/polearm/spear)
	associated_strings = list("spear")
	mechanics_text = "Spears are automatically held with two hands if the other hand is free to do so. Holding with both hands increases damage dealt. \
	<BR><BR>You can start crafting a spear by making cable cuffs and applying them to a rod. After, examining the spear assembly will give details on how to proceed."