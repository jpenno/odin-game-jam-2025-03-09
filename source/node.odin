package game

import "core:fmt"
import rl "vendor:raylib"

Node :: struct {
	screen_pos: rl.Vector2,
	map_pos:    [2]int,
	links:      [3]^Node,
}

node_init :: proc(s_pos: rl.Vector2, m_pos: [2]int) -> (n: Node) {
	n.screen_pos = s_pos
	n.map_pos = m_pos

	return n
}

node_draw :: proc(n: Node) {
	for link in n.links {
		if link == nil {
			continue
		}

		fmt.printfln("Link: x: %d, y: %d", link.screen_pos.x, link.screen_pos.y)
		rl.DrawLineEx(n.screen_pos, link.screen_pos, 10, rl.Color{255, 247, 228, 255})
	}

	texture_draw(.Base_Node, n.screen_pos)
}
