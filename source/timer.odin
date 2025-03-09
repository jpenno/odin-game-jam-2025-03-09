package game

Timer_state :: enum {
	DONE,
	IN_PORGRESS,
	RESET,
	STOP,
}

Timer :: struct {
	duration: f32,
	time:     f32,
	state:    Timer_state,
}

timer_init :: proc(duration: f32) -> Timer {
	return Timer{duration = duration, time = 0, state = .IN_PORGRESS}
}

timer_reset :: proc(t: ^Timer) {
	t.state = .IN_PORGRESS
	t.time = 0
}

timer_tick :: proc(t: ^Timer, dt: f32) -> bool {
	t.time += dt

	if t.time >= t.duration {
		t.time = 0
		t.state = .DONE
		return true
	}

	return false
}
