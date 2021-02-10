/obj/item/firearm_component/receiver/energy/floral
	self_recharge = 1
	max_shots = 10
	combustion = 0
	firemodes = list(
		list(mode_name="induce mutations", projectile_type=/obj/item/projectile/energy/floramut, indicator_color=COLOR_LIME),
		list(mode_name="increase yield", projectile_type=/obj/item/projectile/energy/florayield, indicator_color=COLOR_YELLOW),
		list(mode_name="induce specific mutations", projectile_type=/obj/item/projectile/energy/floramut/gene, indicator_color=COLOR_LIME),
		)
	var/decl/plantgene/gene = null
/*
/obj/item/gun/hand/floragun/add_onmob_charge_meter(image/I)
	I.overlays += mutable_appearance(icon, "[I.icon_state]100", indicator_color)
	return I

/obj/item/gun/hand/floragun/afterattack(obj/target, mob/user, adjacent_flag)
	//allow shooting into adjacent hydrotrays regardless of intent
	if(adjacent_flag && istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		user.visible_message("<span class='danger'>\The [user] fires \the [src] into \the [target]!</span>")
		Fire(target,user)
		return
	..()

/obj/item/gun/hand/floragun/verb/select_gene()
	set name = "Select Gene"
	set category = "Object"
	set src in view(1)

	var/genemask = input("Choose a gene to modify.") as null|anything in SSplants.plant_gene_datums

	if(!genemask)
		return

	gene = SSplants.plant_gene_datums[genemask]

	to_chat(usr, "<span class='info'>You set the [src]'s targeted genetic area to [genemask].</span>")

	return

/obj/item/gun/hand/floragun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/energy/floramut/gene/G = .
	if(istype(G))
		G.gene = gene
*/