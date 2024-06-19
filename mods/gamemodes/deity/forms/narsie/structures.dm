/obj/structure/deity/altar/narsie
	name = "altar"
	desc = "A small desk, covered in blood."
	icon_state = "talismanaltar"

//BLOODLETTING STRUCTURE
//A follower can stand here and mumble prayers as they let their blood flow slowly into the structure.
/obj/structure/deity/blood_stone
	name = "bloody stone"
	desc = "A jagged stone covered in the various stages of blood, from dried to fresh."
	icon_state = "blood_stone"
	// TODO: material-based health for deity structures
	current_health = 100 //It's a piece of rock.
	build_cost = 700

/obj/structure/deity/blood_stone/attack_hand(var/mob/user)
	if(!linked_god || !linked_god.is_follower(user, silent = 1) || !ishuman(user))
		return ..()
	var/mob/living/human/H = user
	user.visible_message(
		SPAN_WARNING("\The [user] calmly slices their finger on \the [src], smearing their blood over the black stone."),
		SPAN_WARNING("You slowly slide your finger down one of \the [src]'s sharp edges, smearing your blood over its smooth surface.")
	)
	while(do_after(H, 5 SECONDS, src))
		user.audible_message("\The [user] utters something under their breath.", SPAN_OCCULT("You mutter a dark prayer to your master as you feel the stone eat away at your lifeforce."))
		if(H.should_have_organ(BP_HEART))
			H.drip(5, get_turf(src))
		else
			H.take_damage(5)
		linked_god.adjust_power_min(1, 1)
	return TRUE

/datum/codex_entry/deity/blood_stone
	associated_paths = list(/obj/structure/deity/blood_stone)
	antag_text = "Allows the user to feed blood directly to the aligned deity, granting it power."
	disambiguator = "occult"