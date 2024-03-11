/datum/ai_behavior/basic_melee_attack/try_latch_feed
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION
	terminate_after_action = TRUE

/datum/ai_behavior/basic_melee_attack/try_latch_feed/setup(datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	var/mob/living/basic/basic_mob = controller.pawn
	if(HAS_TRAIT(basic_mob, TRAIT_FEEDING))
		return FALSE
	. = ..()

/datum/ai_behavior/basic_melee_attack/try_latch_feed/finish_action(datum/ai_controller/controller, succeeded, target_key, targeting_strategy_key, hiding_location_key)
	if(succeeded && isliving(controller.blackboard[target_key]))
		var/atom/target = controller.blackboard[target_key]
		var/mob/living/basic/basic_mob = controller.pawn
		if(basic_mob.CanReach(target))
			basic_mob.AddComponent(/datum/component/latch_feeding, target, TOX, 5, 10, FALSE)
	. = ..()

