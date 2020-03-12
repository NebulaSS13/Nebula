/obj/item/psychic_power/psiblade
	name = "psychokinetic slash"
	force = 10
	sharp = 1
	edge = 1
	maintain_cost = 1
	icon_state = "psiblade_short"

/obj/item/psychic_power/psiblade/master
	force = 20
	maintain_cost = 2

/obj/item/psychic_power/psiblade/master/is_special_cutting_tool(var/high_power)
	return !high_power

/obj/item/psychic_power/psiblade/master/grand
	force = 30
	maintain_cost = 3
	icon_state = "psiblade_long"

/obj/item/psychic_power/psiblade/master/grand/paramount
	force = 50
	maintain_cost = 4
	icon_state = "psiblade_long"

/obj/item/psychic_power/psiblade/master/grand/paramount/is_special_cutting_tool(var/high_power)
	return TRUE