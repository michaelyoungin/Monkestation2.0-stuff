/obj/item/wallframe/slime_pen_controller
	name = "slime pen management frame"
	desc = "Used for building slime pen consoles."
	icon_state = "button"
	result_path = /obj/machinery/slime_pen_controller
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT)
	pixel_shift = 24


/obj/machinery/slime_pen_controller
	name = "slime pen management console"
	desc = "It seems most of the features are locked down, the developers must have been pretty lazy. Can turn the ooze sucker on and off though."

	icon = 'monkestation/code/modules/slimecore/icons/machinery.dmi'
	base_icon_state = "slime_panel"
	icon_state = "slime_panel"

	var/obj/machinery/plumbing/ooze_sucker/linked_sucker
	var/mapping_id

/obj/machinery/slime_pen_controller/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/slime_pen_controller/LateInitialize()
	. = ..()
	locate_machinery()

/obj/machinery/slime_pen_controller/locate_machinery(multitool_connection)
	if(!mapping_id)
		return
	for(var/obj/machinery/plumbing/ooze_sucker/main in GLOB.machines)
		if(main.mapping_id != mapping_id)
			continue
		linked_sucker = main
		main.linked_controller = src
		return

/obj/machinery/slime_pen_controller/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!linked_sucker)
		visible_message(span_notice("[user] fiddles with the [src] toggling the pens ooze sucker."))
	linked_sucker.toggle_state()
