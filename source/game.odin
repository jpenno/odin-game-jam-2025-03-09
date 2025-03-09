package game

import "core:c"
import "core:fmt"
import "core:log"
import rl "vendor:raylib"

Game :: struct {
	run:        bool,
	player_pos: rl.Vector2,
}

game: Game

init :: proc() {
	game = Game {
		run        = true,
		player_pos = rl.Vector2{100, 100},
	}

	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(1280, 720, "Odin + Raylib on the web")

	init_textures()
}

update :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.GRAY)

	texture_draw(.Player, game.player_pos)

	rl.EndDrawing()

	// Anything allocated using temp allocator is invalid after this.
	free_all(context.temp_allocator)
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
