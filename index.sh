#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="${1:-config.ini}"

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Erreur: fichier de configuration introuvable: $CONFIG_FILE" >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "Erreur: curl est requis." >&2
  exit 1
fi

trim() {
  local s="$1"
  s="${s#${s%%[![:space:]]*}}"
  s="${s%${s##*[![:space:]]}}"
  printf '%s' "$s"
}

parse_config() {
  local section=""
  local line key value

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="$(trim "$line")"

    [[ -z "$line" ]] && continue
    [[ "$line" =~ ^[\;#] ]] && continue

    if [[ "$line" =~ ^\[(.+)\]$ ]]; then
      section="${BASH_REMATCH[1]}"
      continue
    fi

    [[ "$line" != *=* ]] && continue

    key="$(trim "${line%%=*}")"
    value="$(trim "${line#*=}")"

    case "$section:$key" in
      app:debug)
        DEBUG="$value"
        ;;
      api:user)
        API_USER="$value"
        ;;
      api:pass)
        API_PASS="$value"
        ;;
      domaine:ndd[])
        DOMAINS+=("$value")
        ;;
      domaine:name[])
        NAMES+=("$value")
        ;;
    esac
  done < "$CONFIG_FILE"
}

DEBUG="false"
API_USER=""
API_PASS=""
DOMAINS=()
NAMES=()

parse_config

if [[ -z "$API_USER" || -z "$API_PASS" ]]; then
  echo "Erreur: api.user et api.pass doivent etre renseignes dans $CONFIG_FILE" >&2
  exit 1
fi

if [[ ${#DOMAINS[@]} -eq 0 || ${#NAMES[@]} -eq 0 ]]; then
  echo "Erreur: aucune entree domaine configuree (domaine.ndd[] / domaine.name[])" >&2
  exit 1
fi

if [[ ${#DOMAINS[@]} -ne ${#NAMES[@]} ]]; then
  echo "Erreur: le nombre de domaine.ndd[] et domaine.name[] doit etre identique" >&2
  exit 1
fi

IP="$(curl -fsS --max-time 15 https://api.ipify.org)"
if [[ -z "$IP" ]]; then
  echo "Erreur: impossible de recuperer l'IP publique" >&2
  exit 1
fi

for i in "${!DOMAINS[@]}"; do
  hostname="${NAMES[$i]}.${DOMAINS[$i]}"

  response="$(curl -fsS --max-time 20 \
    --get https://infomaniak.com/nic/update \
    --data-urlencode "hostname=$hostname" \
    --data-urlencode "myip=$IP" \
    --data-urlencode "username=$API_USER" \
    --data-urlencode "password=$API_PASS")"

  if [[ "${DEBUG,,}" == "true" || "$DEBUG" == "1" ]]; then
    echo "[debug] hostname=$hostname ip=$IP"
    echo "[debug] response=$response"
  fi
done
