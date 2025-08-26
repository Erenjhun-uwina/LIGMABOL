extends Resource

class_name Data

const path = "user://saveDat.tres"

@export var best_distance:int = 0

@warning_ignore("shadowed_global_identifier")

static func read():
	if(not ResourceLoader.exists(path)):
		var ins = Data.new().save()
	return load(path)


func save():
	ResourceSaver.save(self,path)
