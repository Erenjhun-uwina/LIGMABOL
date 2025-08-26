extends Node

##A singelton class that holds all playerstats
class_name Player_Stats


const initial_essence:float = 60
var max_essesence:float :set = set_max_essence
var essence:float = initial_essence :set = set_essence
var essence_gain_per_claim:float

var needed_essence_to_morph:float

var jump_cost:float = 2
var diving_cost:float = 5

var max_jumps:int = 2
var jumps_remaining:int = max_jumps
var can_jump:bool = true: get = get_can_jump, set = set_can_jump

var dying_duration:float = 1.5

var  max_speed:float = 550
const acceleration:float = 6

var idle:bool = true
var immune = false

var max_abilities:int = 8

var avail_abilities:Array[Ability]
var abilities:Array[Ability]

var _curr_ability_ind:int
var abilities_count:int :get = get_abilites_count

signal _on_set_essence
signal _on_set_dist
signal max_essence_set(value:float)
signal game_over
signal morph_start
signal morph_end
signal morphed
signal dying
signal recover
signal ability_added(ability:Ability)
signal ability_cast(index:int)

var morph_cd_timer:Timer = Timer.new()
var morph_ready:bool
var morph_cd:float
const  morph_cd_decrement_per_morph:float = 2
const  max_morph_cd:float = 50

func _ready():
	add_child(morph_cd_timer)
	morph_cd_timer.one_shot = true

	morph_cd_timer.connect("timeout",
		func():
			morph_ready = true
			morph_end.emit()
	)

func reset_ability_vars():
	avail_abilities = AbilityDefinitions.definitions.duplicate()
	#double it and give it to the next person ahhahahaha
	abilities = []
	_curr_ability_ind = 0

func reset_essence_vars():
	max_essesence = 100
	self.essence = initial_essence
	essence_gain_per_claim = 5
	needed_essence_to_morph = 90

func reset_jump()->void:
	self.can_jump = true
	self.jumps_remaining = max_jumps

func reset_morph_vars():
	morph_cd_timer.stop()
	morph_ready = true
	morph_cd = 10

## resets all the stats to initial val.Used for reloading level
func reset()->void:

	reset_jump()
	reset_essence_vars()
	reset_ability_vars()
	reset_morph_vars()
	self.idle = true
## start morphing if not already morphing
##emits morph_start
func morph()->void:

	if(not morph_ready or avail_abilities.size()<1):
		return
	essence -= 20
	morph_start.emit(morph_cd)
	morph_cd_timer.start(morph_cd)
	morph_ready = false
	morph_cd = clamp(morph_cd+morph_cd_decrement_per_morph,0,max_morph_cd)

func append_ability(title):
	var new_ability = get_avail_ability(title)
	abilities.push_back(new_ability)
	ability_added.emit(new_ability)

func random_avail_abilities_pool():
	var pool = []
	var copy = avail_abilities.duplicate()

	for i in range(3):
		if copy.size()<1 : break
		var ability = copy.pop_at(randi_range(0,copy.size()-1))
		pool.append(ability)

	pool.resize(3)

	return pool

func get_avail_ability(title:String)->Ability:
	for i in range(avail_abilities.size()):
		var ability = avail_abilities[i]

		if (ability.title == title):
			return avail_abilities.pop_at(i)
	return null

func get_abilites_count()->int:
	return abilities.size()

func set_max_essence(value):
	max_essesence = floori(value)
	max_essence_set.emit(max_essesence)

func set_essence(value)->void:
	var new_essence = min(max(0,value),max_essesence)
	check_essence(essence,new_essence)
	essence = new_essence
	emit_signal("_on_set_essence",essence)

## adds a value to essence
func update_essence(val:float)->void:
	self.essence += val

## compares the old and new value of the essence
## emits recover when new val is greater than old val
##	emits dying when new val is less or equal to zero
func check_essence(old_val,new_val)->void:

	if(new_val >= needed_essence_to_morph):
		morph()

	if(new_val > old_val):
		recover.emit()
		return

	if(new_val>0):return
	dying.emit()

## returns true if the player can jump
func get_can_jump()->bool:
	return jumps_remaining > 0 and can_jump

func set_can_jump(val:bool)->void:
	can_jump = val
