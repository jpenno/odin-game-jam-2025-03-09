package game

import "core:fmt"
import rl "vendor:raylib"

Map :: struct {
	width:  int,
	height: int,
	nodes:  [dynamic]Node,
}

map_init :: proc() -> (m: Map) {
	m.width = 4
	m.height = 3

	m.nodes = make([dynamic]Node, m.width * m.height)
	fmt.printfln("nodes: %v", len(m.nodes))

	off_set: f32 = 50 + 64
	spacing_y: f32 = 128 + 3 * 16
	start_y: f32 = f32(rl.GetScreenHeight()) - off_set

	spacing_x: f32 = 128 + 3 * 16
	start_x: f32 = off_set

	x, y: int

	for &node in m.nodes {
		node = node_init(
			rl.Vector2{start_x + spacing_x * f32(x), start_y - spacing_y * f32(y)},
			[2]int{y, x},
		)

		x += 1
		if x >= m.width {
			x = 0
			y += 1
		}
	}

	m.nodes[0].links = [3]^Node {
		&m.nodes[get_index(0, 1, m.width)],
		&m.nodes[get_index(1, 1, m.width)],
		nil,
	}

	return m
}

map_delete :: proc(m: ^Map) {
	delete(m.nodes)
}

map_update :: proc(dt: f32) {

}

map_draw :: proc(m: Map) {
	rl.ClearBackground(rl.Color{40, 40, 46, 255})

	for n in m.nodes {
		node_draw(n)
	}
}

@(private = "file")
get_index :: proc(x, y, width: int) -> int {
	return (y * width) + x // Indexes
}
