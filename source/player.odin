package game

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

Player :: struct {
	pos:       rl.Vector2,
	speed:     f32,
	size:      f32,
	fire_rate: Timer,
	bullets:   [10]Bullet,
}

player_init :: proc(pos: rl.Vector2) -> Player {
	return Player{pos = pos, speed = 300, size = 64, fire_rate = timer_init(1.0)}
}

player_update :: proc(p: ^Player, dt: f32) {
	move(p, dt)
	timer_tick(&p.fire_rate, dt)

	if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
		if p.fire_rate.state == Timer_state.DONE {
			shoot(p, rl.GetMousePosition())
			timer_reset(&p.fire_rate)
		}
	}

	collision(p)
	for &b in p.bullets {
		if b.active {
			bullet_update(&b, dt)
		}
	}
}

player_draw :: proc(p: Player) {
	for b in p.bullets {
		if b.active {
			bullet_draw(b)
		}
	}

	dist := p.pos - rl.GetMousePosition()
	radians := math.atan2(dist.x, dist.y)
	rotation := -radians * 180 / math.PI

	texture_draw(.Player, p.pos, rotation)
}

player_take_damage :: proc(damage: i32) {
	fmt.printfln("player take damage: %d", damage)
}

@(private = "file")
move :: proc(p: ^Player, dt: f32) {
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

@(private = "file")
collision :: proc(p: ^Player) {
	if p.pos.x - p.size / 2 <= 0 {
		p.pos.x = p.size / 2
	}
	if p.pos.y - p.size / 2 <= 0 {
		p.pos.y = p.size / 2
	}
	if p.pos.x + p.size / 2 >= f32(rl.GetScreenWidth()) {
		p.pos.x = f32(rl.GetScreenWidth()) - p.size / 2
	}
	if p.pos.y + p.size / 2 >= f32(rl.GetScreenHeight()) {
		p.pos.y = f32(rl.GetScreenHeight()) - p.size / 2
	}
}

@(private = "file")
shoot :: proc(p: ^Player, target: rl.Vector2) {
	for &b in p.bullets {
		if !b.active {
			b = bullet_init(p.pos, target)
			break
		}
	}
}
