package game

import "core:c"
import rl "vendor:raylib"

Game :: struct {
	run:    bool,
	player: Player,
}

@(private = "file")
game: Game

init :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(1280, 720, "Odin + Raylib on the web")

	game = Game {
		run    = true,
		player = player_init(rl.Vector2{100, 100}),
	}

	enemy_manager_init()

	init_textures()
}

run :: proc() {
	dt := rl.GetFrameTime()
	update(dt)
	draw()

	// Anything allocated using temp allocator is invalid after this.
	free_all(context.temp_allocator)
}

update :: proc(dt: f32) {
	player_update(&game.player, dt)
	enemy_manager_update(&game.player, dt)
}

draw :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.GRAY)

	enemy_manager_draw()
	player_draw(game.player)

	rl.EndDrawing()
}

// In a web build, this is called when browser changes size. Remove the
// `rl.SetWindowSize` call if you don't want a resizable game.
parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(c.int(w), c.int(h))
}

shutdown :: proc() {
	rl.CloseWindow()
}

should_run :: proc() -> bool {
	when ODIN_OS != .JS {
		// Never run this proc in browser. It contains a 16 ms sleep on web!
		if rl.WindowShouldClose() {
			game.run = false
		}
	}

	return game.run
}
