# refresco ![Flutter CI](https://github.com/Setti7/refresco/workflows/Flutter%20CI/badge.svg)

## INSTALAÇÂO:

### DEPENDÊNCIAS:
Mongodb rodando na porta 27017.

### BACKEND:
Antes de abrir o app em si, você precisa do servidor rodando localmente. Para isso, clone o
[repositorio do servidor](https://github.com/Setti7/refresco-server) em outro diretório e execute o
comando `npm install`, para instalar as dependências do backend. Depois disso, execute `npm start`.
Pronto o servidor estára rodando e você poderá acessar o dashboard no endereço printado no console.

Copie o endereço de ip printado no console DO ENDPOINT GRAPHQL, você vai precisar dele.

### APP:
Para instalar o app, primeiro instale [flutter](https://flutter.dev/docs/get-started/install).

Agora, vá para o repositório do app, e entre no arquivo
`lib > core > services > api > graphql_api.dart`. Dentro dele você precisa substituir o ip
"http://192.168.15.17:1337/graphql", pelo ip printado no console no passo anterior do end point
graphql.

Para instalar as dependencias do app, execute o comando `flutter pub get` e depois, execute o
comando `flutter run` no terminal, com seu smartphone android conectado ao pc para instalar o apk.

Pronto! Agora quando abrir o app, eles estará conectado. Para criar lojas e produtos vá no
dashboard pelo navegador.
