// Handled elsewhere, do not let them load like vars.
var/global/list/_forbid_field_load = list(
	(nameof(/datum::type)) = TRUE,
	(nameof(/atom::loc))  = TRUE
)
