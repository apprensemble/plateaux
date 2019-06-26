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


app.listen(process.env.PORT || 8080, function () {
  console.log('Example app listening on port 8080!')
})
