#!/usr/bin/env bash

function iptables_ssh() {
  declare -a IPTABLES='/sbin/iptables'

  local IPS_ACCEPT=('81.23.63.6' '141.0.34.138' '62.49.114.11' '88.208.220.171' '37.191.108.74' '78.109.163.185')

  # Accept local connections
  ${IPTABLES} -A INPUT -p tcp --dport ssh -i lo -j ACCEPT
  # Accept established sessions
  ${IPTABLES} -A INPUT -p tcp --dport ssh -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
  # SSH rules: allowed IPs (Inviqa offices)

  for ip in "${!IPS_ACCEPT[@]}";
  do

    ${IPTABLES} -A INPUT -s ${IPS_ACCEPT[${ip}]} -p tcp --dport ssh -j ACCEPT
  done
  # Drop all others
  ${IPTABLES} -A INPUT -p tcp --dport ssh -j DROP
}

iptables_ssh
