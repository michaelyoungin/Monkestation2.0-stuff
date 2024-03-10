/datum/component/scared_of_item // this runs independantly of ai_controller so we aren't wasting ai process time on this as its a passive check.
	var/range

/datum/component/scared_of_item/Initialize(item_path, range)
	src.range = range

	START_PROCESSING(SSobj, src)

/datum/component/scared_of_item/process(seconds_per_tick)
	var/mob/living/basic/basic_mob = parent

	var/broke = FALSE
	for(var/mob/living/carbon/human/human in oview(range, basic_mob))
		for(var/obj/item/item as anything in human.held_items)
			if(!item)
				continue
			if(item.type != basic_mob.ai_controller.blackboard[BB_BASIC_MOB_SCARED_ITEM])
				continue
			basic_mob.ai_controller.set_blackboard_key(BB_BASIC_MOB_STOP_FLEEING, FALSE)
			broke = TRUE
			break
		if(broke)
			return
	basic_mob.ai_controller.set_blackboard_key(BB_BASIC_MOB_STOP_FLEEING, TRUE)
