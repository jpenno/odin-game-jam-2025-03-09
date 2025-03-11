package game

import "core:fmt"
import rl "vendor:raylib"

Map :: struct {
	width:         int,
	height:        int,
	nodes:         [dynamic]Node,
	playre_pos:    [2]int,
	selected_node: ^Node,
	start_button:  rl.Rectangle,
}

map_init :: proc() -> (m: Map) {
	m.start_button = rl.Rectangle {
		f32(rl.GetScreenWidth() - 200),
		f32(rl.GetScreenHeight() - 100),
		100,
		50,
	}
	m.playre_pos = [2]int{-1, -1}

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
			[2]int{x, y},
		)

		x += 1
		if x >= m.width {
			x = 0
			y += 1
		}
	}

	// NOTE: set links for nodes
	// row 1
	m.nodes[get_index(0, 0, m.width)].links = [3]^Node {
		&m.nodes[get_index(0, 1, m.width)],
		&m.nodes[get_index(1, 1, m.width)],
		nil,
	}
	m.nodes[get_index(1, 0, m.width)].links = [3]^Node {
		&m.nodes[get_index(0, 1, m.width)],
		&m.nodes[get_index(1, 1, m.width)],
		nil,
	}
	m.nodes[get_index(2, 0, m.width)].links = [3]^Node {
		&m.nodes[get_index(1, 1, m.width)],
		&m.nodes[get_index(3, 1, m.width)],
		nil,
	}
	m.nodes[get_index(3, 0, m.width)].links = [3]^Node {
		&m.nodes[get_index(2, 1, m.width)],
		&m.nodes[get_index(3, 1, m.width)],
		nil,
	}
	// row 2
	m.nodes[get_index(0, 1, m.width)].links = [3]^Node {
		&m.nodes[get_index(0, 2, m.width)],
		nil,
		nil,
	}
	m.nodes[get_index(1, 1, m.width)].links = [3]^Node {
		&m.nodes[get_index(0, 2, m.width)],
		&m.nodes[get_index(2, 2, m.width)],
		nil,
	}
	m.nodes[get_index(2, 1, m.width)].links = [3]^Node {
		&m.nodes[get_index(1, 2, m.width)],
		&m.nodes[get_index(3, 2, m.width)],
		nil,
	}
	m.nodes[get_index(3, 1, m.width)].links = [3]^Node {
		&m.nodes[get_index(2, 2, m.width)],
		&m.nodes[get_index(3, 2, m.width)],
		nil,
	}
	// end of setting links

	return m
}

map_delete :: proc(m: ^Map) {
	delete(m.nodes)
}

map_update :: proc(m: ^Map, dt: f32) -> ^Node {
	if m.selected_node == nil {
		for &node in m.nodes {
			switch node_mouse_hover(&node) {
			case Node_state.Mouse_over:
				break
			case Node_state.Selected:
				if m.playre_pos.y == -1 && node.map_pos.y == 0 {
					m.selected_node = &node
					m.playre_pos = node.map_pos
				}
				break
			case Node_state.Active_link:
			case Node_state.None:
			}
		}
	}

	for &node in m.nodes {
		node_update(&node)
	}

	if rl.IsKeyPressed(rl.KeyboardKey.K) {
		reset_nodes(m)
	}

	if m.selected_node == nil {
		return nil
	}

	if rl.CheckCollisionRecs(
		m.start_button,
		rl.Rectangle{f32(rl.GetMouseX()), f32(rl.GetMouseY()), 10, 10},
	) {
		if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
			fmt.printfln("start game: %v", m.selected_node)
			return m.selected_node
		}
	}

	return nil
}

map_draw :: proc(m: Map) {
	rl.ClearBackground(rl.Color{40, 40, 46, 255})

	for n in m.nodes {
		node_draw(n)
	}

	rl.DrawRectangleRec(m.start_button, rl.GREEN)
}

@(private = "file")
reset_nodes :: proc(m: ^Map) {
	for &node in m.nodes {
		node_reset_state(&node)
	}

	m.selected_node = nil
}

@(private = "file")
get_index :: proc(x, y, width: int) -> int {
	return (y * width) + x // Indexes
}
