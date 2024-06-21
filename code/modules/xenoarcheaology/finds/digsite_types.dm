//TODO: Kill this in lieu of some more dynamic system
/decl/xenoarch_digsite
	abstract_type = /decl/xenoarch_digsite
	var/weight = 85      // how likely it is to appear
	var/can_have_anomalies = TRUE // if it can spawn full sized anomaly objects
	var/list/find_types	// find type = weight

/decl/xenoarch_digsite/garden
	can_have_anomalies = FALSE
	find_types = list(
		/decl/archaeological_find/fossil/plant = 100,
		/decl/archaeological_find/fossil/shell = 25,
		/decl/archaeological_find/fossil = 25,
		/decl/archaeological_find/trap = 5
	)

/decl/xenoarch_digsite/animal
	can_have_anomalies = FALSE
	find_types = list(
		/decl/archaeological_find/fossil = 100,
		/decl/archaeological_find/fossil/shell = 50,
		/decl/archaeological_find/fossil/plant = 50,
		/decl/archaeological_find/trap = 25
	)

/decl/xenoarch_digsite/house
	find_types = list(
		/decl/archaeological_find/bowl = 100,
		/decl/archaeological_find/bowl/urn = 100,
		/decl/archaeological_find/cutlery = 100,
		/decl/archaeological_find/statuette = 100,
		/decl/archaeological_find/instrument = 100,
		/decl/archaeological_find/container = 100,
		/decl/archaeological_find/mask = 75,
		/decl/archaeological_find/coin = 75,
		/decl/archaeological_find = 75,
		/decl/archaeological_find/material = 25
	)

/decl/xenoarch_digsite/technical
	find_types = list(
		/decl/archaeological_find/mask = 125,
		/decl/archaeological_find/material = 100,
		/decl/archaeological_find/tank = 100,
		/decl/archaeological_find/beacon = 100,
		/decl/archaeological_find/tool = 100,
		/decl/archaeological_find/parts = 100,
		/decl/archaeological_find = 75,
		/decl/archaeological_find/trap = 50
	)

/decl/xenoarch_digsite/temple
	find_types = list(
		/decl/archaeological_find/statuette = 200,
		/decl/archaeological_find/bowl/urn = 100,
		/decl/archaeological_find/bowl = 100,
		/decl/archaeological_find/knife = 100,
		/decl/archaeological_find/crystal = 100,
		/decl/archaeological_find = 50,
		/decl/archaeological_find/trap = 25,
		/decl/archaeological_find/sword = 10,
		/decl/archaeological_find/material = 10,
		/decl/archaeological_find/mask = 10
	)

/decl/xenoarch_digsite/war
	weight = 75
	find_types = list(
		/decl/archaeological_find/gun = 100,
		/decl/archaeological_find/knife = 100,
		/decl/archaeological_find/laser = 75,
		/decl/archaeological_find/sword = 75,
		/decl/archaeological_find = 50,
		/decl/archaeological_find/mask = 50,
		/decl/archaeological_find/trap = 25,
		/decl/archaeological_find/tool = 25
	)
