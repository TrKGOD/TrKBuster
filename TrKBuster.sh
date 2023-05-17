#!/bin/bash

wordlist=""
url=""
verbose=false
user_agent="PriscaAutiste"
output_file="diretorios_encontrados.txt"

usage() {
  echo "Uso: $0 -w <wordlist> -u <URL> [-v]"
  exit 1
}

while getopts "w:u:v" opt; do
  case $opt in
    w)
      wordlist=$OPTARG
      ;;
    u)
      url=$OPTARG
      ;;
    v)
      verbose=true
      ;;
    \?)
      echo "Opção inválida: -$OPTARG"
      usage
      ;;
  esac
done

if [ -z "$wordlist" ] || [ -z "$url" ]; then
  usage
fi

if [ ! -f "$wordlist" ]; then
  echo "Erro: A wordlist '$wordlist' não existe."
  exit 1
fi

print_verbose() {
  if [ "$verbose" = true ]; then
    echo "$1"
  fi
}

while read -r tent; do
  resultado=$(curl -s -o /dev/null -w "%{http_code}" -A "$user_agent" "$url/$tent/")
  if [ "$resultado" == "200" ]; then
    echo "Diretório Encontrado: $tent"
    echo "$tent" >> "$output_file"
  fi
  print_verbose "Tentando: $url/$tent [Código HTTP: $resultado]"
done < "$wordlist"

echo "Resultados salvos em $output_file"
