/obj/item/ability/psionic/psiblade
	name = "psychokinetic slash"
	_base_attack_force = 10
	sharp = 1
	edge = 1
	maintain_cost = 1
	icon_state = "psiblade_short"

/obj/item/ability/psionic/psiblade/master
	_base_attack_force = 20
	maintain_cost = 2

/obj/item/ability/psionic/psiblade/master/is_special_cutting_tool(var/high_power)
	return !high_power

/obj/item/ability/psionic/psiblade/master/grand
	_base_attack_force = 30
	maintain_cost = 3
	icon_state = "psiblade_long"

/obj/item/ability/psionic/psiblade/master/grand/paramount
	_base_attack_force = 50
	maintain_cost = 4
	icon_state = "psiblade_long"

/obj/item/ability/psionic/psiblade/master/grand/paramount/is_special_cutting_tool(var/high_power)
	return TRUE