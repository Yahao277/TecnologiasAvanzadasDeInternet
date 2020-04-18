#!/bin/bash

iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -j MASQUERADE
