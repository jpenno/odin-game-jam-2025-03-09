package game

import rl "vendor:raylib"

Enemy_manager :: struct {
	enemys:      [100]Enemy,
	spawn_timer: Timer,
	spawn_count: int,
}

@(private = "file")
enemy_manager: Enemy_manager

enemy_manager_init :: proc(spawn_time: f32, spawn_count: int) {
	enemy_manager = Enemy_manager {
		spawn_timer = timer_init(spawn_time),
		spawn_count = spawn_count,
	}

	for &e in enemy_manager.enemys {
		e = enemy_init()
	}

	enemy_manager.enemys[0] = enemy_spawn()
}

enemy_manager_update :: proc(player: ^Player, dt: f32) -> bool {
	for &e in enemy_manager.enemys {
		enemy_update(&e, player^, dt)
	}

	// Bullet collision
	for &b in player.bullets {
		for &e in enemy_manager.enemys {
			if e.dead || !b.active {
				continue
			}

			if rl.CheckCollisionCircles(b.pos, b.size / 2, e.pos, e.size / 2) {
				e.dead = true
				b.active = false

				enemy_manager.spawn_count -= 1
				if enemy_manager.spawn_count <= 0 {
					return true
				}
			}
		}
	}

	timer_tick(&enemy_manager.spawn_timer, dt)
	if enemy_manager.spawn_timer.state == .DONE {
		spawn()
		timer_reset(&enemy_manager.spawn_timer)
	}

	return false
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
