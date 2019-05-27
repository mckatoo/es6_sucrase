#!/bin/bash

PROJETO=$1
if [ -z "$PROJETO" ]
then
  while [ -z "$PROJETO" ]
  do
    echo "Informe um nome para o projeto:"
    read -r "PROJETO"
  done
fi

mkdir "$PROJETO"
cd "$PROJETO" && mv ../.git . && mv ../.gitignore . && mv ../LICENSE . && mv ../README.md .

# Constroi o package.json sem perguntar parametros, para usar parametros é só tirar o "-y"
yarn init -y

# Instalar modulos em ambiente de desenvolvimento
# typescript é o modulo para node responsavel para tipagem do javascript
# sucrase é responsavel por converter o typescript em javascript porque o browser ou o node não lê arquivo ts e sim js
# nodemon é o módulo responsável por executar o app e monitorar as mudanças reiniciando se necessário
# eslint e módulos relacionados ajudam a identificar erros em tempo de desenvolvimento
yarn add -D sucrase nodemon eslint

# touch .babelrc

# echo '{"presets": ["@babel/preset-env"]}' > .babelrc

# Cria o diretório onde ficaram os codigos-fontes do projeto
mkdir src dist

# Cria o primeiro arquivo para iniciar o projeto
touch src/main.js

# Insere no arquivo package.json após a linha de license dois scripts, um para iniciar o app em modo desenvolvimento e outro para build
sed -i '/"license": "MIT",/a   "scripts": { "dev": "nodemon ./src/main.js", "build": "sucrase ./src -d ./dist --transforms imports" },' package.json

# Cria e preenche o arquivo de configuração do nodemon
touch nodemon.json
echo '{"watch": ["src"], "ext": "js", "execMap": {"js": "sucrase-node src/main.js"}}' > nodemon.json

# Configura o eslint, remove o package-lock.json que é usado pelo npm e instala as dependências com o yarn já que estamos usando o yarn e não o npm
yarn eslint --init && rm package-lock.json && yarn
