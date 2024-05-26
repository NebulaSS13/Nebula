/mob/living/proc/ingest(var/datum/reagents/from, var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
	RAISE_EVENT(/decl/observ/ingested, src, from, target, amount, multiplier, copy)
	. = from.trans_to_holder(target,amount,multiplier,copy)

/mob/living/carbon/ingest(var/datum/reagents/from, var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0) //we kind of 'sneak' a proc in here for ingesting stuff so we can play with it.
	if(last_taste_time + 50 < world.time)
		var/datum/reagents/temp = new(amount, global.temp_reagents_holder) //temporary holder used to analyse what gets transfered.
		from.trans_to_holder(temp, amount, multiplier, 1)
		var/text_output = temp.generate_taste_message(src, from)
		if(text_output != last_taste_text || last_taste_time + 1 MINUTE < world.time) //We dont want to spam the same message over and over again at the person. Give it a bit of a buffer.
			to_chat(src, SPAN_NOTICE("You can taste [text_output].")) //no taste means there are too many tastes and not enough flavor.
			last_taste_time = world.time
			last_taste_text = text_output
	. = ..()

/* what this does:
catalogue the 'taste strength' of each one
calculate text size per text.
*/
/datum/reagents/proc/generate_taste_message(mob/living/taster, datum/reagents/source_holder)

	if(!istype(taster))
		return

	var/minimum_percent
	if(taster.isSynthetic())
		minimum_percent = TASTE_DULL
	else
		var/decl/species/my_species = istype(taster) && taster?.get_species()
		if(my_species)
			// the taste bonus makes it so that sipping a drink lets you taste it better
			// 1u makes it 2x as strong, 2u makes it 1.5x, 5u makes it 1.2x, etc
			minimum_percent = (my_species.taste_sensitivity * clamp(1 + (1/max(total_volume, 1)), 1, 2))
		else
			minimum_percent = TASTE_NORMAL
	minimum_percent = round(TASTE_DEGREE_PROB/minimum_percent)

	var/list/out = list()
	var/list/tastes = list() //descriptor = strength
	if(minimum_percent <= 100)
		for(var/reagent_type in reagent_volumes)
			var/decl/material/R = GET_DECL(reagent_type)
			if(!R.taste_mult)
				continue
			var/decl/material/liquid/nutriment/N = R
			if(istype(N) && LAZYACCESS(reagent_data, reagent_type))
				var/list/taste_data = LAZYACCESS(reagent_data, reagent_type)
				for(var/taste in taste_data)
					if(!istext(taste))
						continue
					if(taste in tastes)
						tastes[taste] += taste_data[taste]
					else
						tastes[taste] = taste_data[taste]
			else
				var/taste_desc = R.taste_description
				var/taste_amount = REAGENT_VOLUME(src, R.type) * R.taste_mult
				if(R.taste_description in tastes)
					tastes[taste_desc] += taste_amount
				else
					tastes[taste_desc] = taste_amount

		var/decl/material/primary_ingredient = get_primary_reagent_decl()
		if(primary_ingredient?.cocktail_ingredient && source_holder?.my_atom)
			for(var/decl/cocktail/cocktail in SSmaterials.get_cocktails_by_primary_ingredient(primary_ingredient.type))
				if(!LAZYLEN(cocktail.tastes))
					continue
				if(!cocktail.matches(source_holder.my_atom))
					continue
				var/cocktail_volume = 0
				for(var/chem in cocktail.ratios)
					cocktail_volume += REAGENT_VOLUME(src, chem)
				for(var/taste_desc in cocktail.tastes)
					tastes[taste_desc] += cocktail.tastes[taste_desc] * cocktail_volume

		//deal with percentages
		var/total_taste = 0
		for(var/taste_desc in tastes)
			total_taste += tastes[taste_desc]
		for(var/taste_desc in tastes)
			var/percent = tastes[taste_desc]/total_taste * 100
			if(percent < minimum_percent)
				continue
			var/intensity_desc = "a hint of"
			if(percent > minimum_percent * 2 || percent == 100)
				intensity_desc = ""
			else if(percent > minimum_percent * 3)
				intensity_desc = "the strong flavor of"
			if(intensity_desc == "")
				out += "[taste_desc]"
			else
				out += "[intensity_desc] [taste_desc]"

	return english_list(out, "something indescribable")
