extends Control
var matrix:Array[String]
var x:int #Matrix x size
var y:int #Matriz y size
var p:int #Population
var g:int #Generation
const  chars = "abcdefghijklmnopqrstuvwxyz"
var sexMode:int
@export var matrixLabel:Label
@export var outputLable:RichTextLabel


func _on_button_pressed() -> void:
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
		population[i] = Individual.new(x,y)
		population[i].evaluete(matrix)
	_live(1,population)

func _live(generation:int,population:Array[Individual]):
	
	population.sort_custom(sort_by_fitness)
	var  bestFitness:int= population[0].fitness
	var  worstFitness:int = population[p-1].fitness
	outputLable.append_text("Generation: [color=blue]%s[/color]\n"%generation)
	outputLable.append_text("Best Fitness: [color=%s]%s[/color]\n"%["red"if bestFitness>float(x*y)/2 
	else "yellow" if bestFitness != 0 else "green",bestFitness])
	outputLable.append_text("Worst Fitness: [color=%s]%s[/color]\n"%["red"if worstFitness>float(x*y)/2 
	else "yellow" if worstFitness != 0 else "green",worstFitness])
	if  generation>=g:
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
	var cA:Array[bool]=(mother.chromosomes.slice(0,crossLine) 
						+ father.chromosomes.slice(crossLine,matrixSize))
	var cB:Array[bool]=(father.chromosomes.slice(0,crossLine) 
						+ mother.chromosomes.slice(crossLine,matrixSize))
	var randomGenA = int(randf() * matrixSize)
	var randomGenB = int(randf() * matrixSize)
	cA[randomGenA] = !cA[randomGenA] 
	cB[randomGenB] = !cB[randomGenB] 
	var son:Individual = Individual.new(x,y,false,cA)
	var daughter:Individual = Individual.new(x,y,false,cB)
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

func _on_option_button_item_selected(index: int) -> void:
	sexMode = index
	
	$VSplitContainer/Panel2/HBoxContainer/VBoxContainer/Control/Button.disabled = false



class Individual:
	var chromosomes:Array[bool]
	var fitness:int =0
	var _x:int
	var _y:int
	func _init(cx:int,cy:int,
				isRandom:bool=true,newChromosomes:Array[bool]=[]) -> void:
		_x = cx
		_y = cy
		if isRandom or newChromosomes.size()!=cx*cy:
			for i in cy*cx:
				chromosomes.append(randi() % 2==0)
		else :
			for i in cy:
				chromosomes = newChromosomes
	func get_matrix(matrix:Array[String])->Array[String]:
		var trueMatrix:Array[String]=[]
		var xx = _x*2
		for i in _y:
			var row = ""
			var chars = matrix[i]
			var startPos = i*_y
			var chromosomesRow:Array[bool] = chromosomes.slice(startPos,startPos+_x)
			
			for j in _x:
				
				if chromosomesRow[j]:
					row += "_"
				else:
					row+=chars[0]
					chars = chars.substr(1)
			row+=chars
			for j in xx - row.length():
				row += "_"
			trueMatrix.append(row)
		return trueMatrix
	func evaluete(matrix:Array[String]):
		fitness=0
		var trueMatrix:Array[String] = get_matrix(matrix)
		print(trueMatrix)
		for i in _x*2:
			var chars:Dictionary ={}
			for j in _y:
				var theChar:String = trueMatrix[j][i]
				if theChar == "_":
					continue
				if theChar in chars.keys():
					chars[theChar] += 1
					continue
				chars[theChar] =1
			if chars.size()==1:
				fitness+=chars[chars.keys()[0]]
				#fitness+=1
