/datum/ai_planning_subtree/simple_find_target/slime

/datum/ai_planning_subtree/simple_find_target/slime/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	if(!controller.blackboard[BB_BASIC_MOB_STOP_FLEEING])
		return
