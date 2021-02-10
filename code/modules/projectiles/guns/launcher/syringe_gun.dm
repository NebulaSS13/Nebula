/obj/item/syringe_cartridge
	name = "syringe gun cartridge"
	desc = "An impact-triggered compressed gas cartridge that can be fitted to a syringe for rapid injection."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "syringe-cartridge"
	var/icon_flight = "syringe-cartridge-flight" //so it doesn't look so weird when shot
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY | SLOT_EARS
	throwforce = 3
	force = 3
	w_class = ITEM_SIZE_TINY
	var/obj/item/chems/syringe/syringe

/obj/item/syringe_cartridge/on_update_icon()
	underlays.Cut()
	if(syringe)
		underlays += image(syringe.icon, src, syringe.icon_state)
		underlays += syringe.filling

/obj/item/syringe_cartridge/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/chems/syringe) && user.unEquip(I, src))
		syringe = I
		to_chat(user, "<span class='notice'>You carefully insert [syringe] into [src].</span>")
		sharp = 1
		name = "syringe dart"
		update_icon()

/obj/item/syringe_cartridge/attack_self(mob/user)
	if(syringe)
		to_chat(user, "<span class='notice'>You remove [syringe] from [src].</span>")
		user.put_in_hands(syringe)
		syringe = null
		sharp = initial(sharp)
		SetName(initial(name))
		update_icon()

/obj/item/syringe_cartridge/proc/prime()
	//the icon state will revert back when update_icon() is called from throw_impact()
	icon_state = icon_flight
	underlays.Cut()

/obj/item/syringe_cartridge/throw_impact(atom/hit_atom, var/datum/thrownthing/TT)
	..() //handles embedding for us. Should have a decent chance if thrown fast enough
	if(syringe)
		//check speed to see if we hit hard enough to trigger the rapid injection
		//incidentally, this means syringe_cartridges can be used with the pneumatic launcher
		if(TT.speed >= 10 && isliving(hit_atom))
			var/mob/living/L = hit_atom
			//unfortuately we don't know where the dart will actually hit, since that's done by the parent.
			if(L.can_inject(null, ran_zone(TT.target_zone, 30, L)) == CAN_INJECT && syringe.reagents)
				var/reagent_log = syringe.reagents.get_reagents()
				syringe.reagents.trans_to_mob(L, 15, CHEM_INJECT)
				admin_inject_log(TT.thrower? TT.thrower : null, L, src, reagent_log, 15, violent=1)

		syringe.break_syringe(iscarbon(hit_atom)? hit_atom : null)
		syringe.update_icon()

	icon_state = initial(icon_state) //reset icon state
	update_icon()

/obj/item/gun/long/syringe
	name = "syringe gun"
	desc = "A spring loaded rifle designed to fit syringes, designed to incapacitate unruly patients from a distance."
	icon = 'icons/obj/guns/launcher/syringe.dmi'
	material = /decl/material/solid/metal/steel
	barrel = /obj/item/firearm_component/barrel/launcher/syringe
	receiver = /obj/item/firearm_component/receiver/launcher/syringe

/obj/item/gun/long/syringe/rapid
	name = "syringe gun revolver"
	desc = "A modification of the syringe gun design, using a rotating cylinder to store up to five syringes. The spring still needs to be drawn between shots."
	icon = 'icons/obj/guns/launcher/syringe_rapid.dmi'
	receiver = /obj/item/firearm_component/receiver/launcher/syringe/large
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/gun/hand/syringe_disguised
	name = "deluxe electronic cigarette"
	desc = "A premium model eGavana MK3 electronic cigarette, shaped like a cigar."
	icon = 'icons/clothing/mask/smokables/cigarette_electronic_deluxe.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_SMALL
	receiver = /obj/item/firearm_component/receiver/launcher/syringe/hidden
