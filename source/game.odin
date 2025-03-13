package game

import "core:c"
import rl "vendor:raylib"

Game_state :: enum {
	Map,
	Playing,
}

Game :: struct {
	run:    bool,
	player: Player,
	state:  Game_state,
	mmap:   Map,
}

@(private = "file")
game: Game

init :: proc() {
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(1280, 720, "Odin + Raylib on the web")

	game = Game {
		run    = true,
		player = player_init(
			rl.Vector2{f32(rl.GetScreenWidth() / 2), f32(rl.GetScreenHeight() / 2)},
		),
		state  = .Map,
		mmap   = map_init(),
	}

	enemy_manager_init(0.1, 20)

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
	switch game.state {
	case .Map:
		node := map_update(&game.mmap, dt)
		if node != nil {
			game.state = .Playing
			enemy_manager_init(node.enemy_spawn_time, node.enemy_count)
		}
	case .Playing:
		game_update(dt)
	}
}

game_update :: proc(dt: f32) {
	player_update(&game.player, dt)

	if enemy_manager_update(&game.player, dt) {
		game.state = .Map
	}
}

draw :: proc() {
	rl.BeginDrawing()

	switch game.state {
	case .Map:
		map_draw(game.mmap)
	case .Playing:
		game_draw()
	}

	rl.EndDrawing()
}

game_draw :: proc() {
	rl.ClearBackground(rl.Color{40, 40, 46, 255})

	enemy_manager_draw()
	player_draw(game.player)
}

// In a web build, this is called when browser changes size. Remove the
// `rl.SetWindowSize` call if you don't want a resizable game.
parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(c.int(w), c.int(h))
}

shutdown :: proc() {
	map_delete(&game.mmap)
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
