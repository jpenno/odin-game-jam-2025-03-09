package game

import rl "vendor:raylib"

Enemy :: struct {
	pos:  rl.Vector2,
	size: f32,
	dead: bool,
}

enemy_init :: proc(pos: rl.Vector2) -> Enemy {
	return Enemy{pos = pos, dead = false, size = 64}
}

enemy_update :: proc(e: ^Enemy, dt: f32) {

}

enemy_draw :: proc(e: Enemy) {
	if !e.dead {
		texture_draw(.Enemy, e.pos)
	}
}
