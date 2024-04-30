extends Control
var matrix:Array[String]
var x:int #Matrix x size
var y:int #Matriz y size
var p:int #Population
var g:int #Generation
var ga:int #Gasp Amount
var eliteP:float #Elite percentage
var betterMatrix:Array[String]
var topIndv:Array[int]
var worstIndv:Array[int]
var betterFitness:int = -1
var betterIndx:int=-1
const  chars = "abcdefghijklmnopqrstuvwxyz"
var sexMode:int
var startTime:float
signal  endProsses
@export var matrixLabel:Label
@export var outputLabel:RichTextLabel
@export var resultLabel:RichTextLabel


func _on_button_pressed() -> void:
	betterFitness = -1
	betterIndx = -1
	betterMatrix.clear()
	topIndv.clear()
	worstIndv.clear()
	$Div/Panel2/HBoxContainer/VBoxContainer/Control/Button.disabled = true
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
	matrixLabel.text = "Matrix:\n\n"
	for i in matrix:
		matrixLabel.text+=i+"\n"
	var population:Array[Individual]=[]
	outputLabel.clear()
	resultLabel.clear()
	outputLabel.append_text("[color=gray]Start process[/color]\n")
	population.resize(p)
	for i in p:
		population[i] = Individual.new(x,y,_get_random_choromosomes(x*y))
		population[i].evaluete(matrix)
	startTime = Time.get_ticks_msec()
	_live(1,population)

func _live(generation:int,population:Array[Individual]):
	
	population.sort_custom(sort_by_fitness)
	
	worstIndv.append(population[p-1].fitness)
	var  bestFitness:int= population[0].fitness
	topIndv.append(bestFitness)
	
	if bestFitness>betterFitness:
		
		betterFitness = bestFitness
		betterMatrix = population[0].get_matrix(matrix)
		betterIndx = generation
	var  worstFitness:int = population[p-1].fitness
	outputLabel.append_text("Generation: [color=cyan]%s[/color]\n"%generation)
	outputLabel.append_text("Best Fitness: [color=green]%s[/color]\n"%bestFitness)
	outputLabel.append_text("Worst Fitness: [color=red]%s[/color]\n"%worstFitness)
	if  generation>=g:
		emit_signal("endProsses")
		outputLabel.append_text("[color=gray]End process[/color]")
		resultLabel.append_text("Generations: [color=cyan]%s[/color]\n"%g)
		resultLabel.append_text("Best Generation: [color=green]%s[/color]\n"%betterIndx)
		resultLabel.append_text("Best Fitness: [color=green]%s[/color]\n"%topIndv[betterIndx-1])
		resultLabel.append_text("Time: [color=gray]%s[/color] Seconds\n"%((float(Time.get_ticks_msec())-startTime)/1000))
		return
	var elite:int = int(p*eliteP)
	var newPopulation:Array[Individual]=population.slice(0,elite)
	match  sexMode:
		1:
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
			for i in range(elite,p):
				var fatherPi:float = randf()
				var motherPi:float = randf()
				var fatherIndx:int=-1
				var motherIndx:int=-1
				for j in p:
					if  fatherPi<Pi[j]:
						fatherIndx=j
						break
				for j in int(p* eliteP):
					if  motherPi<Pi[j] and j !=fatherIndx:
						motherIndx=j
						break
				newPopulation.append( _get_better_kid(population[motherIndx],
										population[fatherIndx]))
				
		2:
			for i in range(elite,p):
				var fatherA:Individual = population.pick_random()
				var fatherB:Individual = population.pick_random()
				while  fatherB == fatherA:
					fatherB = population.pick_random()
				var motherA:Individual = population.pick_random()
				while motherA == fatherA or motherA == fatherB:
					motherA = population.pick_random()
				var motherB:Individual = population.pick_random()
				while( motherB == fatherA or motherB == fatherB
						or motherB == fatherA):
					motherB= population.pick_random()
				newPopulation.append( _get_better_kid(fatherA if fatherA.fitness > fatherB.fitness else fatherB,
												motherA if motherA.fitness > motherB.fitness else motherB))
		3:
			var Pi:Array[float]=[]
			Pi.resize(p)
			var maxVal:int = 0
			for i in p:
				maxVal+= i+1
			var pastVal=0
			for i in p:
				Pi[i] = float(pastVal+i+1)/maxVal
				pastVal = Pi[i]
			population.reverse()
			for i in range(elite,p):
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
				newPopulation.append( _get_better_kid(population[motherIndx],
										population[fatherIndx]))
	
	_live(generation+1,newPopulation)


func _get_better_kid(mother:Individual,father:Individual):
	var matrixSize=(x*y)
	var crossLine:int = int(randf() * matrixSize)
	var cA:Array[int]=(mother.chromosomes.slice(0,crossLine) 
						+ father.chromosomes.slice(crossLine,matrixSize))
	var cB:Array[int]=(father.chromosomes.slice(0,crossLine) 
						+ mother.chromosomes.slice(crossLine,matrixSize))
	for i in int(matrixSize * 0.05) +1:
		var randomGenA = randi_range(0,matrixSize-1)
		var randomGenB = randi_range(0,matrixSize-1)
		cA[randomGenA] = randi_range(0,ga)
		cB[randomGenB] = randi_range(0,ga)
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

func _on_elite_percentage_value_changed(val: int) -> void:
	eliteP = float(val)/100

func _on_option_button_item_selected(index: int) -> void:
	sexMode = index
	
	$Div/Panel2/HBoxContainer/VBoxContainer/Control/Button.disabled = false
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
				fitness+= int(pow(chars[chars.keys()[0]], 2))
			else:
				var minus = 0
				for i in chars:
					minus+= chars[i]
				fitness-=minus
			if !toContinue:
				break
			indx+=1
		if fitness <0:
			fitness =0


func _on_end_prosses():
	$Window.popup()
	$SubViewport/Control.set_info(matrix,betterMatrix)
	$Div/Panel2/HBoxContainer/VBoxContainer/Control/Button.disabled = false
	$Div/Panel/TC/Graph.set_info(topIndv,worstIndv,betterFitness)



