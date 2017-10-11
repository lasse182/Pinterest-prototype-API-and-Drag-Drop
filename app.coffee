PairModule = require "pair/Pair"
## constants

BOARDS_URL = 'https://api.pinterest.com/v1/me/boards/?access_token=AYr0WrC1RuYEZoIqoF82vaqUXo6cFOq8RSwQtvxEXzFhHoBBiwAAAAA&fields=id%2Cname%2Curl'

## Variables

boards = {}
images = [
	"http://lasseiver.com/images/avatar-01.png", 
	"http://lasseiver.com/images/avatar-02.png",
	"http://lasseiver.com/images/avatar-03.png",
	"http://lasseiver.com/images/avatar-04.png",
	"http://lasseiver.com/images/avatar-05.png",
	"http://lasseiver.com/images/avatar-06.png",
	"http://lasseiver.com/images/avatar-07.png",
	"http://lasseiver.com/images/avatar-08.png",
	"http://lasseiver.com/images/avatar-09.png",
]

dropzone = new Layer
	x: Align.right
	y: Align.top
	backgroundColor: "blue"
	height: Canvas.frame.height
	width: 300

x = 20
y = 50
for image, i in images
	i++
	image = new Layer
		image: image
		x: x
		y: y
	
	
	pair = new PairModule.Pair(image, dropzone)
	pair.enableDragAndDrop()
	pair.onContactDrop (dropped, droptarget) -> 
		sendRequest(dropped.image)
	
	image.draggable.constraints = 
		x: x
		y: y
	image.draggable.overdragScale = 1
	
	x = x+230
	
	if i %% 3 == 0
		x = 20
		y = y + 335
	
request = (url, callback) =>
	r = new XMLHttpRequest
	r.open 'GET', url, true
	r.responseType = 'json'
	r.onreadystatechange = ->
		if(r.status >= 400)
			print "Error #{r.status}"
		if(r.readyState == XMLHttpRequest.DONE && r.status == 200)
			callback(r.response)
	r.send()

sendRequest = (image) =>
	print "send request called.."
	# Post a user
	url = 'https://api.pinterest.com/v1/pins/?access_token=AYr0WrC1RuYEZoIqoF82vaqUXo6cFOq8RSwQtvxEXzFhHoBBiwAAAAA&fields=id%2Clink%2Cnote%2Curl'
	data = "image_url=#{image}&note=from+framer&board=lasse182/Test"
	xhr = new XMLHttpRequest
	xhr.open 'POST', url, true
	xhr.setRequestHeader 'Content-type', 'application/x-www-form-urlencoded'
	
	print data
	
	xhr.onreadystatechange = ->
		print xhr.response
		if xhr.readyState == 4 and xhr.status == '201'
			print xhr.responseText
		else
			print xhr.responseText
		return
	
	xhr.send data
	
getBoards = () =>
	request(BOARDS_URL, (data) =>
		if data
			boards = data.data
			renderBoards()
		else
			"No data for you my friend.."
	)


