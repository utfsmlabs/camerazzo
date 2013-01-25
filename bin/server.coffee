# Using the Paparazzo.js module

Paparazzo = require '../src/paparazzo'
http = require 'http'
url = require 'url'

# Some hosts I found googling:

# Success
# http://85.105.120.239:1881/mjpg/video.mjpg
# http://94.86.192.168/mjpg/video.mjpg
# http://hg55.no-ip.org/mjpg/video.mjpg

# Server closed connection
# http://ip6d6d7343.static.cbizz.nl/BufferingImage?Type=2&ImageAdr=131072

# Can't find image boundary
# http://61.119.240.67/nphMotionJpeg?Resolution=320x240&Quality=Standard

paparazzo1 = new Paparazzo
    host: '146.83.8.136'
    port: 80
    path: '/mjpg/video.mjpg?camera=1'
paparazzo2 = new Paparazzo
    host: 'honningsvag.axiscam.net'
    port: 80
    path: '/mjpg/video.mjpg?camera=1'
paparazzo3 = new Paparazzo
    host: '205.241.135.70'
    port: 80
    path: '/mjpg/video.mjpg?camera=1'

updatedImage1 = ''
updatedImage2 = ''
updatedImage3 = ''


paparazzo1.on "update", (image) =>
    updatedImage1 = image
    console.log "Downloaded #{image.length} bytes"

paparazzo2.on "update", (image) =>
    updatedImage2 = image
    console.log "Downloaded #{image.length} bytes"

paparazzo3.on "update", (image) =>
    updatedImage3 = image
    console.log "Downloaded #{image.length} bytes"

paparazzo1.on 'error', (error) =>
    console.log "Error: #{error.message}"

paparazzo2.on 'error', (error) =>
    console.log "Error: #{error.message}"

paparazzo3.on 'error', (error) =>
    console.log "Error: #{error.message}"

paparazzo1.start()
paparazzo3.start()
paparazzo2.start()



http.createServer (req, res) ->
    data = ''
    path = url.parse(req.url).pathname
        
    if path == '/camera1' and updatedImage1?
        data = updatedImage1
        console.log "Will serve image of #{data.length} bytes"
    if path == '/camera2' and updatedImage2?
        data = updatedImage2
        console.log "Will serve image of #{data.length} bytes"
    if path == '/camera3' and updatedImage3?
        data = updatedImage3
        console.log "Will serve image of #{data.length} bytes"

    res.writeHead 200,
        'Content-Type': 'image/jpeg'
        'Content-Length': data.length

    res.write data, 'binary'
    res.end()
.listen(3001)

