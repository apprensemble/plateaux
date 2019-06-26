const express = require('express')
const app = express()
app.use(express.json()) // for parsing application/json
app.use(express.urlencoded({ extended: true })) // for parsing application/x-www-form-urlencoded


  var message1 = "OK1"
  var message2 = "OK2"
  var message3 = "OK3"
  var message4 = "OK4"

app.post('/test_json', function (req, res, next) {
  console.log(req.body)
  res.json(req.body)
})

app.get('/', function (req, res) {
  res.send('Bienvenue sur la plateforme de Gilles :)')
})

app.get('/channel1', function (req, res) {
  console.log(message1)
  res.send(message1)
})

app.post('/channel1', function (req, res) {
  console.log(req.body.message)
  message1 = req.body.message
  console.log(message1)
  res.send(message1)
});

app.get('/channel2', function (req, res) {
  console.log(message2)
  res.send(message2)
})

app.post('/channel2', function (req, res) {
  console.log(req.body.message)
  message2 = req.body.message
  console.log(message2)
  res.send(message2)
});


app.get('/channel3', function (req, res) {
  console.log(message3)
  res.send(message3)
})

app.post('/channel3', function (req, res) {
  console.log(req.body.message)
  message3 = req.body.message
  console.log(message3)
  res.send(message3)
});


app.get('/channel4', function (req, res) {
  console.log(message4)
  res.send(message4)
})

app.post('/channel4', function (req, res) {
  console.log(req.body.message)
  message4 = req.body.message
  console.log(message4)
  res.send(message4)
});


app.listen(process.env.PORT || 8080, function () {
  console.log('Example app listening on port 8080!')
})
