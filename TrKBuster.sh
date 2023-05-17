#!/bin/bash

wordlist=""
url=""
verbose=false
user_agent="PriscaAutiste"
output_dir="$HOME/Desktop/diretorios_encontrados"
output_file_prefix="diretorios_encontrados"
output_file_extension=".txt"

usage() {
  echo "Uso: $0 -w <wordlist> -u <URL> [-v]"
  exit 1
}

interrupt() {
  echo "Script interrompido. Resultados parciais salvos em $output_file"
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

mkdir -p "$output_dir"

print_verbose() {
  if [ "$verbose" = true ]; then
    echo "$1"
  fi
}

trap interrupt SIGINT

count=0

while read -r tent; do
  resultado=$(curl -s -o /dev/null -w "%{http_code}" -A "$user_agent" -L "$url/$tent")
  if [ "$resultado" == "200" ]; then
    ((count++))
    echo "Diretório Encontrado: $tent"
    output_file="$output_dir/$output_file_prefix$count$output_file_extension"
    echo "URL alvo: $url" > "$output_file"
    echo "$tent" >> "$output_file"
  elif [ "$resultado" != "301" ]; then
    print_verbose "Tentando: $url/$tent [Código HTTP: $resultado]"
  fi
done < "$wordlist"

if [ $count -eq 0 ]; then
  echo "Nenhum diretório encontrado."
  exit 0
fi

echo "Scan concluído. Foram encontrados $count diretório(s). Resultados salvos em $output_dir."
