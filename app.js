const express = require('express')
const app = express()
app.use(express.json()) // for parsing application/json
app.use(express.urlencoded({ extended: true })) // for parsing application/x-www-form-urlencoded


var compteur = 0
var message = "debut"

app.post('/test_json', function (req, res, next) {
  console.log(req.body)
  res.json(req.body)
})

app.get('/', function (req, res) {
  res.send('Bienvenue sur la plateforme de Gilles :)')
})

for (i = 1; i < 5; i++) {

  app.get('/channel'+i, function (req, res) {
  res.send(message)
})

app.post('/channel'+i, function (req, res) {
  console.log(req.body.message)
  message = req.body.message
  compteur++
  res.send(message)
});
  
}


app.listen(process.env.PORT || 8080, function () {
  console.log('Example app listening on port 8080!')
})
