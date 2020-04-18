#!/bin/bash

# Creamos las tablas por cada router
echo "251 T1" >> /etc/iproute2/rt_tables
echo "252 T2" >> /etc/iproute2/rt_tables

IP0=192.168.0.2 # IP de la interfaz eth0
IP1=192.168.1.2 # IP de la interfaz eth1

P1=192.168.0.1 # IP del router de la red 1
P2=192.168.1.1 # IP del router de la red 2

P1_NET=192.168.0.0/24 # IP de la red del router n1
P2_NET=192.168.1.0/24 # IP de la red del router n5

# Configuramos el rutaje en las respectivas tablas"
ip route add $P1_NET dev eth0 src $IP0 table T1
ip route add default via $P1 table T1
ip route add $P2_NET dev eth1 src $IP1 table T2
ip route add default via $P2 table T2

# Configuramos la tabla de rutaje principal
ip route add $P1_NET dev eth0 src $IP0
ip route add $P2_NET dev eth1 src $IP1

# Anyadimos una por defecto por si las moscas
ip route add default via $P1

# Configuramos las tablas para cada interfaz con reglas de rutaje
ip rule add from $IP0 table T1
ip rule add from $IP1 table T2

# Borramos la ruta por defect
ip route del default scope global

# Aplicamos el balanceo finalmente
ip route add default scope global nexthop via $P1 dev eth0 weight $1 nexthop via $P2 dev eth1 weight $2

# Liberamos la cache porque puede que no se apliquen siempre los pesos si la cache tiene rutas pasadas 
ip route flush cache
