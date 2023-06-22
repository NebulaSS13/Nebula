/proc/register_radio_to_controller(source, old_frequency, new_frequency, radio_filter)
	if(old_frequency)
		radio_controller.remove_object(source, old_frequency)
	if(new_frequency)
		return radio_controller.add_object(source, new_frequency, radio_filter)

/proc/unregister_radio_to_controller(source, frequency)
	if(radio_controller)
		radio_controller.remove_object(source, frequency)
