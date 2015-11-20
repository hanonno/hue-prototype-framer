# This imports all the layers for "hue" into layers
layers = Framer.Importer.load "imported/hue"

# Setup layers
background = layers["background"]
background.opacity = 0

luminosity = layers['luminosity']
controls = layers["brightness"]

# Create a slider to control the brightness
slider = new SliderComponent
	superLayer: controls
	x: 90
	y: 48
	width: 460
	value: 0
	
slider.states.add 
	zero: 
		value: 0
	full: 
		value: 1
		
slider.fill.backgroundColor = "#fff"
slider.backgroundColor = "#000"
		

offButton = layers["icon-zero-brightness"]
offButton.on Events.Click, (event, layer) -> 
	slider.states.switch("full")
	
onButton = layers["icon-full-brightness"]
onButton.on Events.Click, (event, layer) ->
	slider.states.switch("zero")
	
# Create container view for background gradient
canvasView = new Layer
	x:0
	y:0
	width: 640
	height:1136

canvasView.sendToBack()

# Create actual canvas element to draw into
canvasElement = document.createElement("canvas")
canvasElement.setAttribute('width', 640)
canvasElement.setAttribute('height', 1136)
canvasView._element.appendChild(canvasElement);
canvasContext = canvasElement.getContext("2d");

# Create and paint gradient
gradient = canvasContext.createLinearGradient(0,0,0,1136)
gradient.addColorStop(0, "#4cd973");
# gradient.addColorStop(1, "#4cd973");
gradient.addColorStop(1, "#0b9ef9");
canvasContext.fillStyle = gradient;
canvasContext.fillRect(0, 0, 640, 1136);

# Setup light bulb
bulb = new Layer
	superlayer: background
	x: 300
	y: 400
	width: 140
	height: 140
	backgroundColor: "#3c8f8e"
	borderRadius: 100
	borderWidth: 8
	borderColor: "#ddd"
	shadowBlur: 80
	shadowColor: "#333"
bulb.center()

bulb.draggable = true
contentFrame = background.frame
contentFrame.height -= controls.frame.height
bulb.draggable.constraints = contentFrame

# Change the color of the bulb whenever it moves
bulb.on "change:point", () ->
	# Get the pixel value from the gradient in the canvas
	pixel = canvasContext.getImageData(bulb.x + bulb.width / 2, bulb.y + bulb.height / 2, 1, 1).data
	# Convert it to rgba
	color = "rgba(" + pixel[0] + "," + pixel[1] + "," + pixel[2] + ",1)" 
	# Set it if the color is not black (out of bounds)
	if color != "rgba(0,0,0,1)"
		this.backgroundColor = color			
		
	updateBrightness()

# Grow the bulb a little bit while dragged
bulb.on Events.DragStart, (event, layer) -> 
	this.animate 
		properties:
	        scale: 1.2
	        opacity: 0.8
	    time: 0.3

bulb.on Events.DragEnd, (event, layer) -> 
	this.animate 
		properties:
	        scale: 1.0
	        opacity: 1.0
	    time: 0.3
	    
# Adjust the brightness 
brightness = new Layer
	superLayer: bulb
	backgroundColor: "black"
	opacity: 0.0
	width: 140
	height: 140

updateBrightness = () ->	
	luminosity.opacity = slider.value
	brightness.opacity = (slider.value * (bulb.x / background.width) * 0.5)
	
slider.on "change:value", updateBrightness	
	    