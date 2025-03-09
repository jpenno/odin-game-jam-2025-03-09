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

enemy_init :: proc(pos: rl.Vector2) -> Enemy {
	return Enemy{pos = pos, dead = false, size = 64, speed = 100}
}

enemy_update :: proc(e: ^Enemy, playre: Player, dt: f32) {
	e.direction = linalg.vector_normalize0(e.pos - playre.pos)
	e.pos -= e.direction * e.speed * dt
}

enemy_draw :: proc(e: Enemy) {
	if !e.dead {
		radians := math.atan2(e.direction.x, e.direction.y)
		rotation := -radians * 180 / math.PI
		texture_draw(.Enemy, e.pos, rotation)
	}
}
