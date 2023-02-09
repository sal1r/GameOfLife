extends Node2D

var life: TileMap
var buffer: TileMap
var timer = 0
const FPS = 20

func get_nearest_cells_count(x: int, y: int):
	var count = 0
	
	for _x in range(-1, 2):
		for _y in range(-1, 2):
			if _x != 0 or _y != 0:
				if life.get_cell(x + _x, y + _y) != -1:
					count += 1
					
	return count

func life_or_death(x: int, y: int, count: int):
	if life.get_cell(x, y) == -1:
		if count == 3:
			return true
		return false
		
	if count < 2 or count > 3:
		return false
	return true

func copy_tile_map(from: TileMap, to: TileMap):
	to.clear()
	
	for cell in from.get_used_cells():
		to.set_cellv(cell, 0)

func _ready():
	life = get_node("%Life")
	buffer = get_node("%Buffer")
	
func _process(delta):
	timer += delta
	
	if timer >= 1.0 / FPS:
		copy_tile_map(life, buffer)
		
		for x in range(-50, 51):
			for y in range(-50, 51):
				var count = get_nearest_cells_count(x, y)
				var is_life = life_or_death(x, y, count)
				
				if is_life:
					buffer.set_cell(x, y, 0)
				else:
					buffer.set_cell(x, y, -1)

		copy_tile_map(buffer, life)
		
		timer = 0
