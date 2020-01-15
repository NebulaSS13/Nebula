/obj/item/chems/food/snacks/fish
	name = "fillet"
	desc = "A fillet of fish."
	icon_state = "fishfillet"
	filling_color = "#ffdefe"
	center_of_mass = "x=17;y=13"
	bitesize = 6
	var/fish_type = "fish"

/obj/item/chems/food/snacks/fish/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)
	name = "[fish_type] [initial(name)]"

// This will remove carp poison etc. Deliberate, meant to be similar to preparing pufferfish.
/obj/item/chems/food/snacks/fish/attackby(var/obj/item/W, var/mob/user)
	if(is_sharp(W) && (locate(/obj/structure/table) in loc))
		var/mob/M = loc
		if(istype(M) && !M.unEquip(src))
			return

		var/toxin_amt = reagents.get_reagent_amount(/datum/reagent/toxin/carpotoxin)
		if(toxin_amt && !prob(user.skill_fail_chance(SKILL_COOKING, 100, SKILL_PROF)))
			reagents.remove_reagent(/datum/reagent/toxin/carpotoxin, toxin_amt)
		user.visible_message("<span class='notice'>\The [user] slices \the [src] into thin strips.</span>")

		var/transfer_amt = Floor(reagents.total_volume * 0.3)
		for(var/i = 1 to 3)
			var/obj/item/chems/food/snacks/sashimi/sashimi = new(get_turf(src), fish_type)
			reagents.trans_to(sashimi, transfer_amt)
		qdel(src)

	else
		..()

/obj/item/chems/food/snacks/fish/poison
	fish_type = "space carp"

/obj/item/chems/food/snacks/fish/poison/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/toxin/carpotoxin, 6)

/obj/item/chems/food/snacks/fish/shark
	fish_type = "shark"

/obj/item/chems/food/snacks/fish/carp
	fish_type = "carp"

/obj/item/chems/food/snacks/fish/octopus
	fish_type = "tako"

/obj/item/chems/food/snacks/fish/mollusc
	name = "meat"
	desc = "Some slimy meat from clams or molluscs."
	fish_type = "mollusc"
	nutriment_type = /datum/reagent/nutriment/slime_meat
