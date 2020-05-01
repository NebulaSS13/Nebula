/datum/sample_obj/test_container
	var/test_var
	var/test_var_2
	var/test_var_3

/datum/sample_obj/test_container/proc/test_proc()
	return 1

/datum/unit_test/persistence
	var/datum/persistence/serializer/serializer = new()
	template = /datum/unit_test/persistence
	async = 0
	name = "PERSISTENCE template"

/datum/unit_test/persistence/proc/reset_serializer()
	serializer = new /datum/persistence/serializer()

/datum/unit_test/persistence/text_saveable
	name = "PERSISTENCE: Text is saveable by serializer."

/datum/unit_test/persistence/text_saveable/start_test()
	try
		reset_serializer()

		var/S = "Foo!@#$%^&*()-=`1234567890\"''"
		var/correct_sql = "(1,1,'test_var','TEXT',\"[sanitizeSQL(S)]\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Text was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Text is serializing correctly.")
	catch(var/exception/e)
		fail("Text was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/numbers_saveable
	name = "PERSISTENCE: Numbers are saveable by serializer."

/datum/unit_test/persistence/numbers_saveable/start_test()
	try
		reset_serializer()

		var/S = 12345
		var/correct_sql = "(1,1,'test_var','NUM',\"12345\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Number was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Number is serializing correctly.")
	catch(var/exception/e)
		fail("Number was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/nulls_saveable
	name = "PERSISTENCE: Null values are saveable by serializer."

/datum/unit_test/persistence/nulls_saveable/start_test()
	try
		reset_serializer()

		var/S = null
		var/correct_sql = "(1,1,'test_var','NULL',\"\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Null was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Null is serializing correctly.")
	catch(var/exception/e)
		fail("Null was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/objects_saveable
	name = "PERSISTENCE: Objects are saveable by serializer."

/datum/unit_test/persistence/objects_saveable/start_test()
	try
		reset_serializer()

		var/S = new /datum/sample_obj/test_container()
		var/correct_sql = "(1,1,'test_var','OBJ',\"2\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		var/found_var = FALSE
		for(var/insert in serializer.var_inserts)
			if(insert == correct_sql)
				found_var = TRUE
				break
		if(!found_var)
			fail("Object was not saved correctly. Unable to find serialized object in inserts.")
		else
			pass("Object is serializing correctly.")
	catch(var/exception/e)
		fail("Object was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/recursion_saveable
	name = "PERSISTENCE: Recursive Objects are saveable by serializer."

/datum/unit_test/persistence/recursion_saveable/start_test()
	try
		reset_serializer()
		var/correct_sql = "(1,1,'test_var','OBJ',\"1\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = T
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Recursive Object was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Recursive Object is serializing correctly.")
	catch(var/exception/e)
		fail("Recursive Object was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/paths_saveable
	name = "PERSISTENCE: Paths are saveable by serializer."

/datum/unit_test/persistence/paths_saveable/start_test()
	try
		reset_serializer()

		var/S = /datum/sample_obj/test_container
		var/correct_sql = "(1,1,'test_var','PATH',\"/datum/sample_obj/test_container\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Path was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Path is serializing correctly.")
	catch(var/exception/e)
		fail("Path was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/procs_saveable
	name = "PERSISTENCE: Procs are saveable by serializer."

/datum/unit_test/persistence/procs_saveable/start_test()
	try
		reset_serializer()

		var/S = /datum/sample_obj/test_container/proc/test_proc
		var/correct_sql = "(1,1,'test_var','PATH',\"/datum/sample_obj/test_container/proc/test_proc\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Proc was not saved correctly. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else
			pass("Proc is serializing correctly.")
	catch(var/exception/e)
		fail("Proc was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/lists_saveable
	name = "PERSISTENCE: Lists are saveable by serializer."

/datum/unit_test/persistence/lists_saveable/start_test()
	try
		reset_serializer()

		var/S = list("foo")
		var/correct_sql = "(1,1,'test_var','LIST',\"1\",1)"
		var/list_insert = "(1,1,1)"
		var/element_insert = "(1,1,1,\"foo\",'TEXT',\"\",\"NULL\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("List was not saved correctly. Invalid var insert. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else if(serializer.list_inserts[1] != list_insert)
			fail("List was not saved correctly. Invalid list insert. Got '[serializer.list_inserts[1]]' and expected '[list_insert]'.")
		else if(serializer.element_inserts[1] != element_insert)
			fail("List was not saved correctly. Invalid element insert. Got '[serializer.element_inserts[1]]' and expected '[element_insert]'.")
		else
			pass("List is serializing correctly.")
	catch(var/exception/e)
		fail("List was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/dicts_saveable
	name = "PERSISTENCE: Dicts are saveable by serializer."

/datum/unit_test/persistence/dicts_saveable/start_test()
	try
		reset_serializer()

		var/S = list()
		S["foo"] = "bar"
		var/correct_sql = "(1,1,'test_var','LIST',\"1\",1)"
		var/list_insert = "(1,1,1)"
		var/element_insert = "(1,1,1,\"foo\",'TEXT',\"bar\",\"TEXT\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Dict was not saved correctly. Invalid var insert. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else if(serializer.list_inserts[1] != list_insert)
			fail("Dict was not saved correctly. Invalid list insert. Got '[serializer.list_inserts[1]]' and expected '[list_insert]'.")
		else if(serializer.element_inserts[1] != element_insert)
			fail("Dict was not saved correctly. Invalid element insert. Got '[serializer.element_inserts[1]]' and expected '[element_insert]'.")
		else
			pass("Dict is serializing correctly.")
	catch(var/exception/e)
		fail("Dict was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/mixed_list_saveable
	name = "PERSISTENCE: Mixed lists are saveable by serializer."

/datum/unit_test/persistence/mixed_list_saveable/start_test()
	try
		reset_serializer()

		var/S = list("zed")
		S["foo"] = "bar"
		var/correct_sql = "(1,1,'test_var','LIST',\"1\",1)"
		var/element_insert = "(1,1,1,\"zed\",'TEXT',\"\",\"NULL\",1)"
		var/element2_insert = "(2,1,2,\"foo\",'TEXT',\"bar\",\"TEXT\",1)"
		var/datum/sample_obj/test_container/T = new()
		T.test_var = S
		serializer.SerializeThing(T)

		if(serializer.var_inserts[1] != correct_sql)
			fail("Mixed list was not saved correctly. Invalid var insert. Got '[serializer.var_inserts[1]]' and expected '[correct_sql]'.")
		else if(serializer.element_inserts[1] != element_insert)
			fail("Mixed list was not saved correctly. Invalid element insert. Got '[serializer.element_inserts[1]]' and expected '[element_insert]'.")
		else if(serializer.element_inserts[2] != element2_insert)
			fail("Mixed list was not saved correctly. Invalid second element insert. Got '[serializer.element_inserts[2]]' and expected '[element2_insert]'.")
		else
			pass("Mixed list is serializing correctly.")
	catch(var/exception/e)
		fail("Mixed list was not saved correctly. Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/saved_vars_correct
	name = "PERSISTENCE: Datums return the right vars to save."

/datum/unit_test/persistence/saved_vars_correct/start_test()
	var/datum/sample_obj/test_container/sample_datum = new()
	try
		if(sample_datum.get_default_vars() == sample_datum.get_saved_vars())
			fail("Incorrect vars returned. Didn't get back default list. Got back vars: [jointext(sample_datum.get_saved_vars(), ", ")].")
		else
			LAZYADD(GLOB.saved_vars[/datum/sample_obj/test_container], "test_var")
			if("test_var_2" in sample_datum.get_saved_vars())
				fail("Incorrect vars returned. Got 'test_var_2' despite it not being on the whitelist")
			else if(!("test_var" in sample_datum.get_saved_vars()))
				fail("test_var was not in whitelist despite being explicitly added.")
			else
				pass("Correct saved vars returned.")
		GLOB.saved_vars.Remove(/datum/sample_obj/test_container)
	catch(var/exception/e)
		fail("Caught exception on line[e.line] at [e.file] with msg '[e]'.")
	return 1

/datum/unit_test/persistence/vars_never_included
	name = "PERSISTENCE: Datums never return vars as something to save."

/datum/unit_test/persistence/vars_never_included/start_test()
	var/datum/sample_obj/test_container/sample_datum = new()
	if("vars" in sample_datum.get_saved_vars())
		fail("Vars is being serialized! Bad!")
	else
		pass("Vars is not being serialized.")
	return 1

/datum/unit_test/persistence/objs_flatten_correctly
	name = "PERSISTENCE: Objects flatten correctly when using flatten mode of the serializer."

/datum/unit_test/persistence/objs_flatten_correctly/start_test()
	var/correct_json = "/datum/gas_mixture|{\"gas\":{\"oxygen\":1.63698,\"nitrogen\":6.15963,\"chlorine\":38.6105,\"carbon_dioxide\":20.4394},\"temperature\":293.15,\"total_moles\":66.8465}"
	var/datum/gas_mixture/GM = new()
	GM.gas = list("oxygen" = 1.63698, "nitrogen" = 6.15963, "chlorine" = 38.6105, "carbon dioxide" = 20.4394)
	GM.temperature = 293.15
	GM.total_moles = 66.8465

	var/flatten_obj = serializer.FlattenThing(GM)
	if(flatten_obj != correct_json)
		fail("Incorrect flatten object format received. Got '[flatten_obj]' and expected '[correct_json]'.")
	else
		pass("Objects are flattened correctly and to specification.")
	return 1

/datum/unit_test/persistence/objs_inflate_correctly
	name = "PERSISTENCE: Objects return back to expected format when deserialized from flatten mode."

/datum/unit_test/persistence/objs_inflate_correctly/start_test()
	var/correct_json = "{\"gas\":{\"oxygen\":1.63698,\"nitrogen\":6.15963,\"chlorine\":38.6105,\"carbon_dioxide\":20.4394},\"temperature\":293.15,\"total_moles\":66.8465}"
	var/datum/gas_mixture/GM = new()
	GM.gas = list("oxygen" = 1.63698, "nitrogen" = 6.15963, "chlorine" = 38.6105, "carbon dioxide" = 20.4394)
	GM.temperature = 293.15
	GM.total_moles = 66.8465

	var/datum/gas_mixture/inflated_obj = new()
	inflated_obj = serializer.InflateThing(inflated_obj, json_decode(correct_json))
	if(inflated_obj.temperature != GM.temperature)
		fail("Object did not inflate correctly. Temperature mismatch.")
	else if(inflated_obj.total_moles != GM.total_moles)
		fail("Object did not inflate correctly. Total moles mismatch.")
	else if(inflated_obj.gas["oxygen"] != GM.gas["oxygen"])
		fail("Object did not inflate correctly. Oxygen gas amount mismatch.")
	else if(inflated_obj.gas["chlorine"] != GM.gas["chlorine"])
		fail("Object did not inflate correctly. Chlorine gas amount mismatch.")
	else
		pass("Objects are inflated correctly and to specification.")
	return 1