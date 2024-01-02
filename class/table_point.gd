## This class is a data container to store different information 
## about where the relationship lines should connect to the columns
class_name TablePoint

const MIDDLE_MARGIN = 10
const END_MARGIN = 10

var attribute_points: Array[Vector2]
var middle_point: Vector2
var end_point: Vector2
var side: Enums.SIDE

func _init(_attribute_points: Array[Vector2], _side: Enums.SIDE):
	self.attribute_points = _attribute_points
	self.side = _side
	
	var attributes_mean: Vector2 = _attribute_points.reduce(func(a: Vector2, b: Vector2): return a+b, Vector2.ZERO) / attribute_points.size()
	
	if _side == Enums.SIDE.LEFT:
		middle_point = attributes_mean + Vector2(-MIDDLE_MARGIN, 0)
		end_point = middle_point + Vector2(-END_MARGIN, 0)
	else:
		middle_point = attributes_mean + Vector2(MIDDLE_MARGIN, 0)
		end_point = middle_point + Vector2(END_MARGIN, 0)
	
