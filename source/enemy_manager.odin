package game

import rl "vendor:raylib"

Enemy_manager :: struct {
	enemys:      [100]Enemy,
	spawn_timer: Timer,
}

@(private = "file")
enemy_manager: Enemy_manager

enemy_manager_init :: proc() {
	enemy_manager = Enemy_manager {
		spawn_timer = timer_init(1),
	}

	for &e in enemy_manager.enemys {
		e = enemy_init()
	}

	enemy_manager.enemys[0] = enemy_spawn()
}

enemy_manager_update :: proc(player: ^Player, dt: f32) {
	for &e in enemy_manager.enemys {
		enemy_update(&e, player^, dt)
	}

	for &b in player.bullets {
		for &e in enemy_manager.enemys {
			if e.dead {
				continue
			}

			if rl.CheckCollisionCircles(b.pos, b.size / 2, e.pos, e.size / 2) {
				e.dead = true
				b.active = false
			}
		}
	}

	timer_tick(&enemy_manager.spawn_timer, dt)
	if enemy_manager.spawn_timer.state == .DONE {
		spawn()
		timer_reset(&enemy_manager.spawn_timer)
	}
}

enemy_manager_draw :: proc() {
	for e in enemy_manager.enemys {
		enemy_draw(e)
	}
}

@(private = "file")
spawn :: proc() {
	for &e in enemy_manager.enemys {
		if e.dead {
			e = enemy_spawn()
			break
		}
	}
}
