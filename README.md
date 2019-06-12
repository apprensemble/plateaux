# plateaux

multi plateaux de jeux

## Test

### Envoie de message

```sh
curl -d '{"message":"blabla et plein de truc sympa"}' -H "Content-Type: application/json" -X POST https://plateaux.herokuapp.com/abande
```

### Lecture du message

```sh
curl -X GET http://plateaux.herokuapp.com/abande
```
