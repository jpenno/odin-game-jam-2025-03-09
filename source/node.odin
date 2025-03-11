package game

import "core:fmt"
import rl "vendor:raylib"

Node_state :: enum {
	None,
	Mouse_over,
	Selected,
	Active_link,
}

Node :: struct {
	screen_pos: rl.Vector2,
	map_pos:    [2]int,
	links:      [3]^Node,
	state:      Node_state,
}

node_init :: proc(s_pos: rl.Vector2, m_pos: [2]int) -> (n: Node) {
	n.screen_pos = s_pos
	n.map_pos = m_pos
	n.state = .None

	return n
}

node_update :: proc(n: ^Node) {
	if n.state == .Mouse_over || n.state == .Selected {
		links_set(&n.links, .Active_link)
	}
}

node_mouse_hover :: proc(n: ^Node) -> Node_state {
	if rl.CheckCollisionRecs(
		rl.Rectangle{n.screen_pos.x - 64, n.screen_pos.y - 64, 128, 128},
		rl.Rectangle{f32(rl.GetMouseX()), f32(rl.GetMouseY()), 10, 10},
	) {
		links_set(&n.links, .Active_link)
		n.state = .Mouse_over

		if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
			n.state = .Selected
		}

		return n.state
	}

	n.state = .None

	return n.state
}

node_reset_state :: proc(n: ^Node) {
	n.state = .None
}

node_draw :: proc(n: Node) {
	line_color: rl.Color

	switch n.state {
	case .Mouse_over:
		line_color = rl.Color{255, 247, 228, 255}
	case .Active_link, .Selected, .None:
		line_color = rl.Color{108, 86, 113, 255}
	}

	for link in n.links {
		if link == nil {
			continue
		}

		rl.DrawLineEx(n.screen_pos, link.screen_pos, 10, line_color)
	}

	texture_draw(.Base_Node, n.screen_pos)

	switch n.state {
	case .Mouse_over:
		rl.DrawRectangle(i32(n.screen_pos.x - 10), i32(n.screen_pos.y - 10), 20, 20, rl.RED)
	case .Active_link:
		rl.DrawRectangle(i32(n.screen_pos.x - 10), i32(n.screen_pos.y - 10), 20, 20, rl.BLUE)
	case .Selected:
		rl.DrawRectangle(i32(n.screen_pos.x - 10), i32(n.screen_pos.y - 10), 20, 20, rl.GREEN)
	case .None:
	}
}

@(private = "file")
links_set :: proc(links: ^[3]^Node, state: Node_state) {
	for link in links {
		if link == nil {
			continue
		}

		link.state = state
	}
}
