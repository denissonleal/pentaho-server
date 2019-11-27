# pentaho server

## licença do saiku

gere a licensa no site: https://licensing.meteorite.bi/

e coloque no diretório `license`

## iniciando serviço

```bash
git clone git@github.com:denissonleal/pentaho-server.git
cd pentaho-server
docker build -t="pentaho-server:v1" .
docker run -it --rm -p 8080:8080 pentaho-server:v1
```
