extends MarginContainer

func set_text(input:String,response:String):
	if input.empty():
		$Rows/InputHistory.queue_free()
	else:
		$Rows/InputHistory.text = " > " + input
	
	$Rows/Response.text = response
