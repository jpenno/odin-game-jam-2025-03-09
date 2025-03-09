package game

import "core:math/linalg"
import rl "vendor:raylib"

Bullet :: struct {
	pos:       rl.Vector2,
	direction: rl.Vector2,
	size:      f32,
	speed:     f32,
	active:    bool,
}

bullet_init :: proc(pos, target: rl.Vector2) -> Bullet {
	return Bullet {
		pos = pos,
		direction = linalg.vector_normalize0(target - pos),
		speed = 700,
		size = 32,
		active = true,
	}
}

bullet_update :: proc(b: ^Bullet, dt: f32) {
	b.pos += b.direction * b.speed * dt

	if b.pos.x + b.size / 2 <= 0 {
		b.active = false
	}
	if b.pos.y + b.size / 2 <= 0 {
		b.active = false
	}
	if b.pos.x - b.size / 2 >= f32(rl.GetScreenWidth()) {
		b.active = false
	}
	if b.pos.y - b.size / 2 >= f32(rl.GetScreenHeight()) {
		b.active = false
	}
}

bullet_draw :: proc(b: Bullet) {
	texture_draw(.Bullet, b.pos)
}
