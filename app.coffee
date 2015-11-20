# This imports all the layers for "hue" into hueLayers4
layers = Framer.Importer.load "imported/hue"

background = layers["background"]
background.opacity = 0
luminosity = layers['luminosity']
controls = layers["brightness"]

bulb1 = layers["bulb-1"]
bulb2 = layers["bulb-2"]

offButton = layers["icon-zero-brightness"]
onButton = layers["icon-full-brightness"]

bulb1.draggable = true
	
canvasView = new Layer
	x:0
	y:0
	width: 640
	height:1136
	
canvasView.sendToBack()

canvasView.style.backgroundColor = "rgba(255,0,0,0.2)"
canvasElement = document.createElement("canvas")
canvasElement.setAttribute('width', 640)
canvasElement.setAttribute('height', 1136)

canvasView._element.appendChild(canvasElement);
canvasContext = canvasElement.getContext("2d");

gradient = canvasContext.createLinearGradient(0,0,640,1136)
gradient.addColorStop(0, "green");
gradient.addColorStop(1, "white");
canvasContext.fillStyle = gradient;
canvasContext.fillRect(0, 0, 640, 1136);

loaded = () ->
# 	canvasContext.fillStyle = "green"
# 	canvasContext.drawImage(image, 0, 0);	
# 	pixel = canvasContext.getImageData(0, 0, 1, 1).data
# 	print pixel[0]
# 	
# 	color = "rgba(" + pixel[0] + "," + pixel[1] + "," + pixel[2] + ",1)" 
	
image = document.createElement("img")
image.setAttribute('src', background.image)

if image.complete 
	loaded()
else
	image.addEventListener('load', loaded())
	
group = new Layer
	superlayer: background
	x: 300
	y: 400
	width: 120
	height: 120
	backgroundColor: "red"
	borderRadius: 100
	borderWidth: 8
	borderColor: "#ddd"
	shadowBlur: 80
	shadowColor: "#333"
group.draggable = true
group.draggable.constraints = background.frame
	
group.on Events.DragMove, (event, layer) ->
	pixel = canvasContext.getImageData(this.x + this.width / 2, this.y + this.height / 2, 1, 1).data
	color = "rgba(" + pixel[0] + "," + pixel[1] + "," + pixel[2] + ",1)" 
	print color
	this.backgroundColor = color


bulb1.on Events.DragStart, (event, layer) -> 
	this.animate 
		properties:
	        scale: 1.2
	        opacity: 0.5
	    time: 0.3
		
bulb1.on Events.DragEnd, (event, layer) -> 
	this.animate 
		properties:
	        scale: 1.0
	        opacity: 1.0
	    time: 0.3
	    
bulb2.on Events.DragStart, (event, layer) -> 
	this.animate 
		properties:
	        scale: 1.2
	        opacity: 0.5
	    time: 0.3
		
bulb2.on Events.DragEnd, (event, layer) -> 
	this.animate 
		properties:
	        scale: 1.0
	        opacity: 1.0
	    time: 0.3
	    

bulb2.draggable = true

bulb1.draggable.constraints = background.frame
bulb2.draggable.constraints = background.frame

slider = new SliderComponent
	superLayer: controls
	x: 90
	y: 48
	width: 460
	value: 0.5
	
slider.states.add 
	zero: 
		value: 0
	full: 
		value: 1
		
slider.fill.backgroundColor = "#fff"
slider.backgroundColor = "#000"
		
slider.on "change:value", (event, layer) ->
	luminosity.opacity = slider.value
	
offButton.on Events.Click, (event, layer) -> 
	slider.states.switch("zero")
	
onButton.on Events.Click, (event, layer) ->
	slider.states.switch("full")
	
