extends Control

onready var buttons: HFlowContainer = $Buttons

var Turn := 1
var GameOver := false
var AiEnabled := true

var Options := {
	"1" : "x",
	"2" : "o"
}
var ArrayWins := [
	[0, 1, 2],
	[0, 3, 6],
	[0, 4, 8],
	[0, 2, 1],
	[0, 6, 3],
	[0, 8, 4],
	[6, 7, 8],
	[6, 8, 7],
	[2, 5, 8],
	[2, 8, 5],
	[1, 4, 7],
	[1, 7, 4],
	[3, 4, 5],
	[3, 5, 4],
	[2, 4, 6],
	[2, 6, 4]
]

var AiPos := []
var OpenSpaces := []
var PlayerPos := []
var Layout = [0, 0, 0, 0, 0, 0, 0, 0, 0]

func getLayout(Cords, args : Array):
	var cords = [Layout[Cords[0]], Layout[Cords[1]], Layout[Cords[2]]]
	if args[1]:
		cords = [Layout[Cords[0]], Layout[Cords[1]], 2]
	if cords == [1, 1, 1] or cords == [2, 2, 2]:
		if args[0] == true:
			for i in Cords:
				buttons.get_child(i).modulate = Color.green
			GameOver = true
			return 1
	else:
		return 0

func PossibleWins(args : Array):
	for i in ArrayWins:
		if getLayout(i, args) >= 1:
			break

func ChangeTurn():
	if Turn == 1:
		Turn = 2
	else:
		Turn = 1

func MatchingArray(a, b, c, d):
	if [a, b, c] == d:
		return 1
	elif [a, c, b] == d:
		return 2
	elif [c, a, b] == d:
		return 3
	elif [c, b, a] == d:
		return 4
	elif [b, a, c] == d:
		return 5
	elif [b, c, a] == d:
		return 6
	else:
		return 0

func AI():
	randomize()
	var Choice = 0
	if OpenSpaces.size() >= 1:
		Choice = OpenSpaces[randi() % OpenSpaces.size()]
	if 4 in OpenSpaces and rand_range(0, 100) >= 50:
		Choice = 4
	if PlayerPos.size() >= 1:
		var FoundMove := false
		var List := []
		for a in PlayerPos:
			if FoundMove:
				break
			for b in PlayerPos:
				if FoundMove:
					break
				if (a != b):
					for c in OpenSpaces:
						if (a != c) and (c != b) and !([c, b, a] in List) and !([b, c, a] in List) and !([a, b, c] in List):
							List.append([a, b, c])
							for d in ArrayWins:
								if MatchingArray(a, b, c, d) >= 1:
									Choice = c
	if AiPos.size() >= 1:
		var FoundMove := false
		var List := []
		for a in AiPos:
			if FoundMove:
				break
			for b in AiPos:
				if FoundMove:
					break
				if (a != b):
					for c in OpenSpaces:
						if (a != c) and (c != b) and !([c, b, a] in List) and !([b, c, a] in List) and !([a, b, c] in List):
							List.append([a, b, c])
							for d in ArrayWins:
								if MatchingArray(a, b, c, d) >= 1:
									Choice = c
									FoundMove = true
									break
	AiPos.append(Choice)
	Clicked(Choice)

func _ready() -> void:
	for i in 9:
		buttons.get_child(i).connect("pressed", self, "Clicked", [i])
		OpenSpaces.append(i)

func Clicked(ID : int):
	var Block = buttons.get_child(ID)
	if Block.text == "" and !GameOver:
		Block.text = Options[str(Turn)]
		Layout[ID] = Turn
		if Turn == 1:
			PlayerPos.append(ID)
		ChangeTurn()
		OpenSpaces.erase(ID)
		PossibleWins([true, false])
		if Turn == 2 and !GameOver:
			if AiEnabled:
				AI()
	else:
		if GameOver or OpenSpaces.size() <= 0:
			get_tree().reload_current_scene()

func _on_Reset_pressed() -> void:
	get_tree().reload_current_scene()
