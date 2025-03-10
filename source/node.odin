package game

import "core:fmt"
import rl "vendor:raylib"

Node_state :: enum {
	None,
	Mouse_over,
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

}

node_mouse_hover :: proc(n: ^Node) -> bool {
	if rl.CheckCollisionRecs(
		rl.Rectangle{n.screen_pos.x - 64, n.screen_pos.y - 64, 128, 128},
		rl.Rectangle{f32(rl.GetMouseX()), f32(rl.GetMouseY()), 10, 10},
	) {
		for link in n.links {
			if link == nil {
				continue
			}

			link.state = .Active_link
		}

		n.state = .Mouse_over
		return true
	} else {
		n.state = .None
		for link in n.links {
			if link == nil {
				continue
			}

			link.state = .None
		}
	}

	return false
}

node_draw :: proc(n: Node) {
	for link in n.links {
		if link == nil {
			continue
		}

		rl.DrawLineEx(n.screen_pos, link.screen_pos, 10, rl.Color{255, 247, 228, 255})
	}

	texture_draw(.Base_Node, n.screen_pos)

	if n.state == .Mouse_over || n.state == .Active_link {
		rl.DrawRectangle(i32(n.screen_pos.x - 10), i32(n.screen_pos.y - 10), 20, 20, rl.GREEN)
	}
}
