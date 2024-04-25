extends Control
var matrix:Array[String]
var x:int #Matrix x size
var y:int #Matriz y size
var p:int #Population
var g:int #Generation
var ga:int #Gasp Amount
var betterMatrix:Array[String]
var betterFitness:int = -1
const  chars = "abcdefghijklmnopqrstuvwxyz"
var sexMode:int
signal  endProsses
@export var matrixLabel:Label
@export var outputLable:RichTextLabel


func _on_button_pressed() -> void:
	betterFitness = -1
	betterMatrix = []
	$VSplitContainer/Panel2/HBoxContainer/VBoxContainer/Control/Button.disabled = true
	await  get_tree().process_frame
	await  get_tree().process_frame
	await  get_tree().process_frame
	matrix.clear()
	matrix.resize(y)
	for i in y:
		var newString = ""
		var pchars = chars.substr(0,x)
		for j in x:
			var theChar = pchars[randi()%pchars.length()]
			newString+=theChar
			pchars = pchars.replace(theChar,"")
		matrix[i] = newString
	matrixLabel.text = "Matrix\n"
	for i in matrix:
		matrixLabel.text+=i+"\n"
	var population:Array[Individual]=[]
	outputLable.clear()
	population.resize(p)
	for i in p:
		population[i] = Individual.new(x,y,_get_random_choromosomes(x*y))
		population[i].evaluete(matrix)
	_live(1,population)

func _live(generation:int,population:Array[Individual]):
	
	population.sort_custom(sort_by_fitness)
	var  bestFitness:int= population[0].fitness
	if bestFitness>betterFitness:
		betterFitness = bestFitness
		betterMatrix = population[0].get_matrix(matrix)
	var  worstFitness:int = population[p-1].fitness
	outputLable.append_text("Generation: [color=blue]%s[/color]\n"%generation)
	outputLable.append_text("Best Fitness: [color=%s]%s[/color]\n"%["red"if bestFitness>float(x*y)/2 
	else "yellow" if bestFitness != 0 else "green",bestFitness])
	outputLable.append_text("Worst Fitness: [color=%s]%s[/color]\n"%["red"if worstFitness>float(x*y)/2 
	else "yellow" if worstFitness != 0 else "green",worstFitness])
	if  generation>=g:
		emit_signal("endProsses")
		outputLable.append_text(str(population[0].chromosomes)+"\n")
		for i in population[0].get_matrix(matrix):
			outputLable.append_text(str(i)+"\n")
		return
	var newPopulation:Array[Individual]=[]
	newPopulation.resize(p)
	if sexMode ==1:
		var fsum:int=0
		for i in population:
			fsum+=i.fitness
		var Pi:Array[float]=[]
		Pi.resize(p)
		var pastVal:float=0.0
		var div:float = 1.0/float(population.size())
		for i in p:
			var fit = float(population[i].fitness)
			if fit == 0:
				Pi[i] = div + pastVal
			else:
				Pi[i] = float(population[i].fitness)/fsum +pastVal
			pastVal=Pi[i]
		for i in p:
			var fatherPi:float = randf()
			var motherPi:float = randf()
			var fatherIndx:int=-1
			var motherIndx:int=-1
			for j in p:
				if  fatherPi<Pi[j]:
					fatherIndx=j
					break
			for j in p:
				if  motherPi<Pi[j] and j !=fatherIndx:
					motherIndx=j
					break
			newPopulation[i] = _get_better_kid(population[motherIndx],
									population[fatherIndx])
			
	_live(generation+1,newPopulation)
	
func _get_better_kid(mother:Individual,father:Individual):
	var matrixSize=(x*y)
	var crossLine:int = int(randf() * matrixSize)
	var cA:Array[int]=(mother.chromosomes.slice(0,crossLine) 
						+ father.chromosomes.slice(crossLine,matrixSize))
	var cB:Array[int]=(father.chromosomes.slice(0,crossLine) 
						+ mother.chromosomes.slice(crossLine,matrixSize))
	var randomGenA = int(randf() * matrixSize)
	var randomGenB = int(randf() * matrixSize)
	cA[randomGenA] = int(randf() * ga)
	cB[randomGenB] = int(randf() * ga)
	var son:Individual = Individual.new(x,y,cA)
	var daughter:Individual = Individual.new(x,y,cB)
	son.evaluete(matrix)
	daughter.evaluete(matrix)
	return son if son.fitness>daughter.fitness else daughter


func sort_by_fitness(a:Individual,b:Individual):
	return a.fitness>b.fitness

func _on_generations_value_changed(val: int) -> void:
	g=val


func _on_population_value_changed(val: int) -> void:
	p=val

func _on_x_value_changed(val: int) -> void:
	x=val

func _on_y_value_changed(val: int) -> void:
	y=val


func _on_gasp_amount_value_changed(val) -> void:
	ga = val

func _on_option_button_item_selected(index: int) -> void:
	sexMode = index
	
	$VSplitContainer/Panel2/HBoxContainer/VBoxContainer/Control/Button.disabled = false
func _get_random_choromosomes(sz:int) -> Array[int]:
	var theC:Array[int]=[]
	for i in sz:
		theC.append(int(randf() *(ga+1)))
	return theC

class Individual:
	var chromosomes:Array[int]
	var fitness:int =0
	var x:int
	var y:int
	func _init(_x:int,_y:int,_chromosomes:Array[int]=[]) -> void:
		x = _x
		y = _y
		chromosomes = _chromosomes
	func get_matrix(matrix:Array[String])->Array[String]:
		var trueMatrix:Array[String]=[]
		for i in y:
			var row = ""
			var chars = matrix[i]
			var startPos = i*x
			var chromosomesRow:Array[int] = chromosomes.slice(startPos,startPos+x)
			for j in x:
				row += "_".repeat(chromosomesRow[j])+chars[j]
			trueMatrix.append(row)
		return trueMatrix
	func evaluete(matrix:Array[String]):
		fitness=0
		var trueMatrix:Array[String] = get_matrix(matrix)
		var indx:int=0
		while true:
			var toContinue:bool = false
			var chars:Dictionary ={}
			for i in y:
				if trueMatrix[i].length()<=indx:
					continue
				toContinue=true
				var theChar:String = trueMatrix[i][indx]
				if theChar == "_":
					continue
				if theChar in chars.keys():
					chars[theChar] += 1
					continue
				chars[theChar] =1
			if chars.size()==1:
				var amnt = chars[chars.keys()[0]]
				if amnt >1:
					amnt =int( pow(amnt,2))
				fitness+=amnt
			if !toContinue:
				break
			indx+=1


func _on_end_prosses():
	$Window.popup()
	$Window/Control.set_info(matrix,betterMatrix)
	$VSplitContainer/Panel2/HBoxContainer/VBoxContainer/Control/Button.disabled = false
