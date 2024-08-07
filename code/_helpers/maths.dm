// min is inclusive, max is exclusive
/proc/Wrap(val, min, max)
	var/d = max - min
	var/t = floor((val - min) / d)
	return val - (t * d)

// Trigonometric functions.
/proc/Csc(x)
	return 1 / sin(x)

/proc/Sec(x)
	return 1 / cos(x)

/proc/Cot(x)
	return 1 / tan(x)

/proc/Atan2(x, y)
	if(!x && !y) return 0
	var/a = arccos(x / sqrt(x*x + y*y))
	return y >= 0 ? a : -a

// Greatest Common Divisor: Euclid's algorithm.
/proc/Gcd(a, b)
	while (1)
		if (!b) return a
		a %= b
		if (!a) return b
		b %= a

// Least Common Multiple. The formula is a consequence of: a*b = LCM*GCD.
/proc/Lcm(a, b)
	return abs(a) * abs(b) / Gcd(a, b)

// Condition checks.
// Returns true if val is from min to max, inclusive.
/proc/IsInRange(val, min, max)
	return (val >= min) && (val <= max)

/proc/IsInteger(x)
	return floor(x) == x

/proc/IsMultiple(x, y)
	return x % y == 0

// Performs a linear interpolation between a and b.
// Note: weight=0 returns a, weight=1 returns b, and weight=0.5 returns the mean of a and b.
/proc/Interpolate(a, b, weight = 0.5)
	return a + (b - a) * weight // Equivalent to: a*(1 - weight) + b*weight

/proc/ToDegrees(radians)
	// 180 / Pi ~ 57.2957795
	return radians * 57.2957795

/proc/ToRadians(degrees)
	// Pi / 180 ~ 0.0174532925
	return degrees * 0.0174532925

// Vector algebra.
/proc/squaredNorm(x, y)
	return x*x + y*y

/proc/norm(x, y)
	return sqrt(squaredNorm(x, y))

/matrix/proc/get_angle()
	return Atan2(b,a)

//Finds the shortest angle that angle A has to change to get to angle B. Aka, whether to move clock or counterclockwise.
/proc/closer_angle_difference(a, b)
	if(!isnum(a) || !isnum(b))
		return
	a = SIMPLIFY_DEGREES(a)
	b = SIMPLIFY_DEGREES(b)
	var/inc = b - a
	if(inc < 0)
		inc += 360
	var/dec = a - b
	if(dec < 0)
		dec += 360
	. = inc > dec ? -dec : inc

// Determines if `mid` is inbetween `start` and  `end`, inclusive. All values are in degrees.
/proc/angle_between_two_angles(start, mid, end)
	end = (end - start) < 0 ? end - start + 360 : end - start
	mid = (mid - start) < 0 ? mid - start + 360 : mid - start
	return mid <= end

#define POLAR_TO_BYOND_X(R,T) ((R) * sin(T))
#define POLAR_TO_BYOND_Y(R,T) ((R) * cos(T))

/proc/polar2turf(x, y, z, angle, distance)
	var/x_offset = POLAR_TO_BYOND_X(distance, angle)
	var/y_offset = POLAR_TO_BYOND_Y(distance, angle)
	return locate(ceil(x + x_offset), ceil(y + y_offset), z)

/proc/get_turf_from_angle(x, y, z, angle, ideal_distance)
	do
		. = polar2turf(x, y, z, angle, ideal_distance)
		ideal_distance -= 1
	while (!. && ideal_distance > 0)
