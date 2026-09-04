/decl/forging_step/tool_head_blank
	billet_desc        = "A heavy piece of shaped metal, almost suitable for use as the head of a tool. It still needs some last touches to be made into something useful."
	billet_name        = "tool head blank"
	billet_icon_state  = "tool_head"
	steps              = list(
	/decl/forging_step/product/hoe_head,
	/decl/forging_step/product/shovel_head,
	/decl/forging_step/hammer_head_blank,
	/decl/forging_step/product/chisel_head
	)

/decl/forging_step/hammer_head_blank
	billet_name        = "hammer head blank"
	billet_desc        = "A worked slab of material in the rough shape of a hammer head, only a step from being a finished product."
	steps              = list(
	/decl/forging_step/product/pickaxe_head,
	/decl/forging_step/product/sledge_head,
	/decl/forging_step/product/hammer_head,
	/decl/forging_step/product/forging_hammer_head
	)

/decl/forging_step/product/tongs
	billet_name = "tongs"
	product_type = /obj/item/tongs

/decl/forging_step/product/chisel_head
	billet_name = "chisel head"
	product_type = /obj/item/tool_component/head/chisel

/decl/forging_step/product/hammer_head
	billet_name = "hammer head"
	product_type = /obj/item/tool_component/head/hammer

/decl/forging_step/product/shovel_head
	billet_name = "shovel head"
	product_type = /obj/item/tool_component/head/shovel

/decl/forging_step/product/hoe_head
	billet_name = "hoe head"
	product_type = /obj/item/tool_component/head/hoe

/decl/forging_step/product/handaxe_head
	billet_name = "handaxe head"
	product_type = /obj/item/tool_component/head/handaxe

/decl/forging_step/product/pickaxe_head
	billet_name = "pickaxe head"
	product_type = /obj/item/tool_component/head/pickaxe

/decl/forging_step/product/sledge_head
	billet_name = "sledge head"
	product_type = /obj/item/tool_component/head/sledgehammer

/decl/forging_step/product/forging_hammer_head
	billet_name = "forging hammer head"
	product_type = /obj/item/tool_component/head/forging_hammer

/decl/forging_step/product/nails
	billet_name = "nails"
	product_type = /obj/item/stack/material/nail/twelve

/decl/forging_step/product/barrel_rim
	billet_name = "barrel rim"
	product_type = /obj/item/barrel_rim
