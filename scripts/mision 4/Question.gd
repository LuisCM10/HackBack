class_name Question

var textQ : String
var options = []
var answer: int
var time
var restantTime

func _init(text_question: String, option1: String, option2: String, ans: int) -> void:
	self.textQ = text_question
	self.options = [option1, option2]
	self.answer = ans - 1
	self.time = 0
	restantTime = time	

func setTime(value):
	self.time = value
	
func getTime() -> int:
	return self.time

func answerReview(option: int) -> bool:
	if option == answer:
		return true;
	return false
