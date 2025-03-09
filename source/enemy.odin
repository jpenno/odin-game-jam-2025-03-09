package game

import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

Enemy :: struct {
	pos:       rl.Vector2,
	direction: rl.Vector2,
	speed:     f32,
	size:      f32,
	dead:      bool,
}

enemy_init :: proc(pos: rl.Vector2 = {0, 0}) -> Enemy {
	return Enemy{pos = pos, dead = true, size = 64, speed = 100}
}

enemy_spawn :: proc() -> (e: Enemy) {
	e = enemy_init()
	e.dead = false
	e.pos.x = -e.size
	e.pos.y = 300

	return e
}

enemy_update :: proc(e: ^Enemy, playre: Player, dt: f32) {
	if e.dead {
		return
	}

	e.direction = linalg.vector_normalize0(e.pos - playre.pos)
	e.pos -= e.direction * e.speed * dt

	if rl.CheckCollisionCircles(e.pos, e.size / 2, playre.pos, playre.size / 2) {
		e.dead = true
		player_take_damage(10)
	}
}

enemy_draw :: proc(e: Enemy) {
	if !e.dead {
		radians := math.atan2(e.direction.x, e.direction.y)
		rotation := -radians * 180 / math.PI
		texture_draw(.Enemy, e.pos, rotation)
	}
}
