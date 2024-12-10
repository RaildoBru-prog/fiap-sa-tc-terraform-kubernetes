// Importa o Express
const express = require('express');

// Cria uma aplicação Express
const app = express();

// Define uma rota GET na raiz '/'
app.get('/', (req, res) => {
    console.log("Acessou")
    res.send('Status up');
});

// Configura a porta para ouvir
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});

