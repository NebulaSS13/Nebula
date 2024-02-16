/decl/blood_type/ominus
	name = "O-"
	random_weighting = 4

/decl/blood_type/oplus
	name = "O+"
	antigens = list("Rh")
	random_weighting = 36

/decl/blood_type/aminus
	name = "A-"
	antigens = list("A")
	random_weighting = 3

/decl/blood_type/aplus
	name = "A+"
	antigens = list("A", "Rh")
	random_weighting = 28

/decl/blood_type/bminus
	name = "B-"
	antigens = list("B")

/decl/blood_type/bplus
	name = "B+"
	antigens = list("B", "Rh")
	random_weighting = 20

/decl/blood_type/abminus
	name = "AB-"
	antigens = list("A", "B")

/decl/blood_type/abplus
	name = "AB+"
	antigens = list("A", "B", "Rh")
	random_weighting = 5

// Insect blood.
/decl/blood_type/hemolymph

	name = "hemolymph"
	antigen_category = "insect"

	splatter_name = "ichor"
	splatter_desc = "A smear of insect ichor. It smells acrid."
	splatter_colour = "#525252"

// Robo-blood.
/decl/blood_type/coolant

	name = "coolant"
	antigen_category = "machine"

	splatter_name = "coolant"
	splatter_desc = "A smear of machine coolant. It looks discoloured."
	splatter_colour = SYNTH_BLOOD_COLOR

	transfusion_fail_reagent = /decl/material/liquid/acid
