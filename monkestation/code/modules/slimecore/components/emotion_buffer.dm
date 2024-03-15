//This is really just a storage cell for mood messages, also handles some basic responding to emotional events for mobs
/datum/component/emotion_buffer
	var/mob/living/host
	///the buffer of emotional things with there emotion stored like EMOTION_HAPPY = List("Was fed by x")
	var/emotional_buffer = list(
		EMOTION_HAPPY = list(),
		EMOTION_SAD = list(),
		EMOTION_ANGER = list(),
		EMOTION_FUNNY = list(),
		EMOTION_SCARED = list(),
		EMOTION_SUPRISED = list(),
		EMOTION_HUNGRY = list(),
	)

	var/emotional_responses = list(
		EMOTION_HAPPY = list(),
		EMOTION_SAD = list(),
		EMOTION_ANGER = list(),
		EMOTION_FUNNY = list(),
		EMOTION_SCARED = list(),
		EMOTION_SUPRISED = list(),
		EMOTION_HUNGRY = list(),
	)

	var/emotional_heard = list(
		EMOTION_HAPPY = list(),
		EMOTION_SAD = list(),
		EMOTION_ANGER = list(),
		EMOTION_FUNNY = list(),
		EMOTION_SCARED = list(),
		EMOTION_SUPRISED = list(),
		EMOTION_HUNGRY = list(),
	)
/datum/component/emotion_buffer/Initialize(...)
	. = ..()
	host = parent

/datum/component/emotion_buffer/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_EMOTION_STORE, PROC_REF(register_emotional_data))


/datum/component/emotion_buffer/Destroy(force, silent)
	. = ..()
	host = null

/datum/component/emotion_buffer/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_EMOTION_STORE)


/datum/component/emotion_buffer/proc/register_emotional_data(datum/source, atom/from, emotion, emotional_text)
	if(!emotional_buffer[emotion])
		return
	if(from)
		emotional_buffer[emotion] += "[from] [emotional_text]"
	else
		emotional_buffer[emotion] += "[emotional_text]"
