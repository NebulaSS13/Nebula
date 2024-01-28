/*
 * A bunch of Clone implementation for system types, so they're compatible with the
 * Clone() proc used on other datums.
 */

/matrix/GetCloneArgs()
	return list(src) //Matrices handle copies themselves

/image/GetCloneArgs()
	return list(src) //Same for images