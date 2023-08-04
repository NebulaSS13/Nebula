//Simplified worth/price system as of 2023

//worth is defined only by materials
//(we assume material worth is absolutely defined once and for all by some convention
//or price scanner system according to their uses/properties)
//price is (worth) + human values (guns being pricy, rare items being expensive, etc, fabricated/assembled items)

//This makes more sense than a bajillion of procs and allows more flexible use
//And it's way simpler, just be careful with overrides

/atom/proc/worth()
	. = 0
	if(reagents)
		for(var/a in reagents.reagent_volumes)
			var/decl/material/reg = GET_DECL(a)
			. += reg.get_value() * REAGENT_VOLUME(reagents, a) * REAGENT_WORTH_MULTIPLIER
	for(var/atom/movable/thing in contents)
		. += thing.worth()
	. = max(0, round(.))

/atom/proc/price()
	. = worth()