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
		var pchars = chars
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
	var  minFitness:int= population[0].fitness
	var  maxFitness:int = population[p-1].fitness
	outputLable.append_text("Generation: [color=blue]%s[/color]\n"%generation)
	outputLable.append_text("Best Fitness: [color=%s]%s[/color]\n"%["red"if minFitness>float(x*y)/2 
	else "yellow" if minFitness != 0 else "green",minFitness])
	outputLable.append_text("Worst Fitness: [color=%s]%s[/color]\n"%["red"if maxFitness>float(x*y)/2 
	else "yellow" if maxFitness != 0 else "green",maxFitness])
	if minFitness == 0 or generation>=g:
		for i in population[0].get_matrix(matrix):
			outputLable.append_text(str(i)+"\n")
		return
	var newPopulation:Array[Individual]=[]
	newPopulation.resize(p)
	if sexMode ==1:
		var fsum:int=0
		for i in population:
			fsum+=i.fitness
			print(randf())
		var Pi:Array[float]=[]
		Pi.resize(p)
		var pastVal:float=0.0
		print("as")
		for i in p:
			Pi[i] = float(population[i].fitness)/fsum +pastVal
			print(Pi[i]-pastVal)
			pastVal=Pi[i]
		
		for i in p:
			var fatherPi:float = randf()
			var motherPi:float = randf()
			
			var fatherIndx:int=-1
			var motherIndx:int=-1
			for j in p:
				if fatherIndx==-1 and fatherPi>Pi[j]:
					fatherIndx=j
				if motherIndx==-1 and motherPi>Pi[j] and j!=fatherIndx:
					motherIndx=j
				if motherIndx !=-1 and motherIndx !=-1:
					break

		#print(fsum)
		
	#_live(generation+1,population)
	
func _get_better_kid(mother:Individual,father:Individual):
	var matrixSize=x*y
	var crossLine:int = int(randf() * matrixSize)
	var cA:Array[bool]=[]
	var cB:Array[bool]=[]
	for i in crossLine:
		pass
	


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
	var chormosomes:Array[bool]
	var fitness:int =0
	var _x:int
	var _y:int
	func _init(cx:int,cy:int,
				isRandom:bool=true,newChromosomes:Array[bool]=[]) -> void:
		_x = cx
		_y = cy
		chormosomes.resize(cy)
		if isRandom or newChromosomes.size()!=cx*cy:
			for i in cy:
				var column:Array[bool]=[]
				column.resize(cx)
				chormosomes[i]=column
				for j in cx:
					column[j] = randi() % 2==0
		else :
			for i in cy:
				chormosomes[i] = newChromosomes.slice(i,i+4)
	func get_matrix(matrix:Array[String])->Array[String]:
		var trueMatrix:Array[String]=[]
		for i in matrix.size():
			var row = matrix[i]
			for j in row.length():
				if chormosomes[i][j]:
					row = row.replace(matrix[i][j],"_"+matrix[i][j])
			trueMatrix.append(row)
		return trueMatrix
	func evaluete(matrix:Array[String]):
		fitness=0
		var trueMatrix = get_matrix(matrix)
		var dicPos:Dictionary={}
		for i in trueMatrix:
			for j in i.length():
				var theChar:String = i[j]
				if theChar =="_":continue
				if theChar in dicPos.keys():
					if not j in dicPos[theChar]:
						dicPos[theChar].append(j)
				else:
					dicPos[theChar] = [j]
		for i in dicPos:
			fitness+=_x-dicPos[i].size()+1
	func mutate():
		pass

