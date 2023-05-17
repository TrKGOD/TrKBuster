#!/bin/bash

if [ -z "$1" ]; then
  echo "Erro: É necessário fornecer uma wordlist."
  echo "Uso: $0 -w <wordlist> <URL>"
  exit 1
fi

wordlist=""
url=""
while getopts "w:" opt; do
  case $opt in
    w)
      wordlist=$OPTARG
      ;;
    \?)
      echo "Opção inválida: -$OPTARG"
      echo "Uso: $0 -w <wordlist> <URL>"
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))
url=$1

if [ -z "$url" ]; then
  echo "Erro: É necessário fornecer uma URL."
  echo "Uso: $0 -w <wordlist> <URL>"
  exit 1
fi

if [ ! -f "$wordlist" ]; then
  echo "Erro: A wordlist '$wordlist' não existe."
  exit 1
fi
