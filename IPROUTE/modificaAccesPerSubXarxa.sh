#!/bin/bash

NETWORK=""
OPTION=""

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "Modifica acceso por red."
      echo " "
      echo "./modificaAccesPerSubXarxa [options] [arguments]"
      echo " "
      echo "options:"
      echo "-h, --help              Muestra ayuda"
      echo "-n, --network=IP        Especifica una red"
      echo "-op, --option=ACCEPT    Especifica una opción de acceso"
      exit 0
      ;;
    -n| --network)
      shift
      if test $# -gt 0; then
        n=$1
        MASK="${n#*/}"
        if [ "$MASK" == "27" ]; then
            NETWORK=$1
        else
            echo "La mascara ha de ser de /27"
            exit 1
        fi
      else
        echo "No se especificó una red"
        exit 1
      fi
      shift
      ;;
    -op| --option)
      shift
      if test $# -gt 0; then
        if [ "$1" == "ACCEPT" -o "$1" == "DROP" ]; then
            OPTION=$1
        else
            echo "Escoge entre ACCEPT y DROP"
            exit 1
        fi
      else
        echo "No se especificó una red"
        exit 1
      fi
      shift
      ;;
    *)
      break
      ;;
  esac
done

if [ -n "$NETWORK" -a -n "$OPTION" ]; then
    echo "iptables -I FORWARD -s $NETWORK -j $OPTION"
    iptables -I FORWARD -s $NETWORK -j $OPTION
else
    echo "Error leyendo los parámetros."
    echo " "
    echo "./modificaAccesPerSubXarxa [options] [arguments]"
    echo " "
    echo "options:"
    echo "-h, --help              Muestra ayuda"
    echo "-n, --network=IP        Especifica una red"
    echo "-op, --option=ACCEPT    Especifica una opción de acceso"
    exit 1
fi
