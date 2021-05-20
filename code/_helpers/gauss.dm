#define ACCURACY 10000

/**
 * Converts a uniform distributed random number into a normal distributed one
 * since this method produces two random numbers, one is saved for subsequent calls
 * (making the cost negligble for every second call). 
 * * This will return +/- decimals, situated about mean with standard deviation stddev
 * * 68% chance that the number is within 1stddev
 * * 95% chance that the number is within 2stddev
 * * 98% chance that the number is within 3stddev...etc
 */
/proc/gaussian(mean, stddev)
	var/static/gaussian_next
	var/R1
	var/R2
	var/working
	if(gaussian_next != null)
		R1 = gaussian_next
		gaussian_next = null
	else
		do
			R1 = (rand(-ACCURACY, ACCURACY) / ACCURACY)
			R2 = (rand(-ACCURACY, ACCURACY) / ACCURACY)
			working = (R1 * R1) + (R2 * R2)
	
		while(working >= 1 || working == 0)
		working = sqrt(((-2 * log(working)) / working))
		R1 *= working
		gaussian_next = (R2 * working)

	return (mean + (stddev * R1))

#undef ACCURACY
