/datum/unit_test/time
	name = "TIME: Template"
	abstract_type = /datum/unit_test/time

/datum/unit_test/time/shall_validate_sixth_of_june
	name = "TIME: Shall validate 6th of June"

/datum/unit_test/time/shall_validate_sixth_of_june/start_test()
	var/datum/is_date/day/D = new(6, 6)
	if(D.IsValid())
		pass("Validation succeeded")
	else
		fail("Validation failed")
	qdel(D)
	return TRUE

/datum/unit_test/time/shall_not_validate_not_sixth_of_june
	name = "TIME: Shall not validate not-6th of June"

/datum/unit_test/time/shall_not_validate_not_sixth_of_june/start_test()
	var/datum/is_date/day/D = new(1, 1)
	if(D.IsValid())
		fail("Unexpected validation")
	else
		pass("Did not validate")
	qdel(D)
	return TRUE

/datum/unit_test/time/shall_validate_range_that_include_sixth_of_june_start_before_end
	name = "TIME: Shall be able to validate range that include 6th of June - Start before End"

/datum/unit_test/time/shall_validate_range_that_include_sixth_of_june_start_before_end/start_test()
	var/datum/is_date/range/R = new(5, 5, 7, 7)
	if(R.IsValid())
		pass("Validation succeeded")
	else
		fail("Validation failed")
	qdel(R)
	return TRUE

/datum/unit_test/time/shall_validate_range_that_include_sixth_of_june_start_after_end
	name = "TIME: Shall be able to validate range that include 6th of June - Start after End"

/datum/unit_test/time/shall_validate_range_that_include_sixth_of_june_start_after_end/start_test()
	var/datum/is_date/range/R = new(8, 8, 7, 7)
	if(R.IsValid())
		pass("Validation succeeded")
	else
		fail("Validation failed")
	qdel(R)
	return TRUE

/datum/unit_test/time/shall_not_validate_range_that_exclude_sixth_of_june_start_before_end
	name = "TIME: Shall not validate range that exclude 6th of June - Start before End"

/datum/unit_test/time/shall_not_validate_range_that_exclude_sixth_of_june_start_before_end/start_test()
	var/datum/is_date/range/R = new(7, 7, 8, 8)
	if(R.IsValid())
		fail("Unexpected validation")
	else
		pass("Did not validate")
	qdel(R)
	return TRUE

/datum/unit_test/time/shall_not_validate_range_that_exclude_sixth_of_june_start_after_end
	name = "TIME: Shall not validate range that exclude 6th of June - Start after End"

/datum/unit_test/time/shall_not_validate_range_that_exclude_sixth_of_june_start_after_end/start_test()
	var/datum/is_date/range/R = new(7, 7, 5, 5)
	if(R.IsValid())
		fail("Unexpected validation")
	else
		pass("Did not validate")
	qdel(R)
	return TRUE
