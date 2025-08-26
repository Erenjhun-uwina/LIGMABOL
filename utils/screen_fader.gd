extends Node

class_name Screen_fader
@export var color_rect:ColorRect

var in_dur = 0.1
var out_dur = 2.0

signal fade_out_finish
signal fade_in_finish
var tween:Tween


func black_out()->void:
	color_rect.color.a = 1



func fade_in(dur = self.in_dur,delay = 0)->Screen_fader:
	return fade(dur as float,true,delay)

func fade_out(dur = self.out_dur,delay = 0)->Screen_fader:
	return fade(dur as float,false,delay)

func fade(dur:float,is_fade_in = true,delay = 0)->Screen_fader:
	var alpha =  1 if is_fade_in  else 0
	var finish_signal = "fade_in_finish" if is_fade_in else "fade_out_finish"

	tween = create_tween()
	tween.tween_property(color_rect,"color:a",alpha,dur).set_delay(delay)
	tween.tween_callback(Callable(self,"emit_signal").bind(finish_signal))
	return self

func cancel_all()->void:
	if(tween != null):tween.kill()
