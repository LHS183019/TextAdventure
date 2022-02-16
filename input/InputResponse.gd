extends MarginContainer

var should_zebra = false

func set_text(input:String,response:String):
	if input.empty():
		$Rows/InputHistory.queue_free()
	else:
		$Rows/InputHistory.bbcode_text = " > " + input
	
	$Rows/Response.bbcode_text = response
	
	if should_zebra == false:
		$Zebra.hide()
	else:
		$Zebra.show()
