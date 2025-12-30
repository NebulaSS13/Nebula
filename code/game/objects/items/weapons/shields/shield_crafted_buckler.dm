/obj/item/shield/crafted/buckler
	name        = "buckler"
	desc        = "A small, round shield used to block sharp things from entering your body."
	icon        = 'icons/obj/items/shield/buckler_metal.dmi'
	wooden_icon = 'icons/obj/items/shield/buckler_wood.dmi'

/obj/item/shield/crafted/buckler/improvised
	name_prefix = "improvised"

/obj/item/shield/crafted/buckler/handle_shield(mob/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/crafted/buckler/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile/bullet))
		return 0 //No blocking bullets, I'm afraid.
	return base_block_chance
