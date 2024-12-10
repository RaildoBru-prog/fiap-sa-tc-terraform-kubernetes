# Imagem base do Node.js
FROM node:14

# Define o diretório de trabalho na imagem
WORKDIR /usr/src/app

# Copia o package.json e instala dependências
COPY package*.json ./
RUN npm install

# Copia o restante dos arquivos do projeto
COPY . .

# Expõe a porta 3000
EXPOSE 3000

# Comando para iniciar a aplicação
CMD ["node", "index.js"]
