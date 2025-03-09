package game

import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

Player :: struct {
	pos:   rl.Vector2,
	speed: f32,
}

player_init :: proc(pos: rl.Vector2) -> Player {
	return Player{pos = pos, speed = 300}
}

player_update :: proc(p: ^Player, dt: f32) {
	dir := rl.Vector2{0, 0}

	if rl.IsKeyDown(rl.KeyboardKey.W) || rl.IsKeyDown(rl.KeyboardKey.UP) {
		dir.y = -1
	}
	if rl.IsKeyDown(rl.KeyboardKey.S) || rl.IsKeyDown(rl.KeyboardKey.DOWN) {
		dir.y = 1
	}
	if rl.IsKeyDown(rl.KeyboardKey.A) || rl.IsKeyDown(rl.KeyboardKey.LEFT) {
		dir.x = -1
	}
	if rl.IsKeyDown(rl.KeyboardKey.D) || rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
		dir.x = 1
	}

	dir = linalg.vector_normalize0(dir)
	p.pos += dir * p.speed * dt
}

player_draw :: proc(p: Player) {
	dist := p.pos - rl.GetMousePosition()
	radians := math.atan2(dist.x, dist.y)
	rotation := -radians * 180 / math.PI

	texture_draw(.Player, p.pos, rotation)
}
