// Wizard
/obj/item/magic_rock/Initialize(ml, material_key)
	LAZYSET(potentials, SPECIES_VOX, /spell/targeted/shapeshift/true_form)
	. = ..()
