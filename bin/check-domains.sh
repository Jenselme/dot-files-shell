#!/usr/bin/env bash

readonly red="\e[0;91m"
readonly blue="\e[0;94m"
readonly expand_bg="\e[K"
readonly blue_bg="\e[0;104m${expand_bg}"
readonly red_bg="\e[0;101m${expand_bg}"
readonly green_bg="\e[0;102m${expand_bg}"
readonly green="\e[0;92m"
readonly white="\e[0;97m"
readonly bold="\e[1m"
readonly uline="\e[4m"
readonly reset="\e[0m"


function ok() {
    echo -e "${green}OK${reset}"
}

function nok() {
    echo -e "${red}NOK${reset}"
}

function main() {
    for domain in "$@"; do
        echo -e "${bold}---- Checking domain ${domain}${reset}"

        echo -n "Redirect to HTTPS: "
        if curl --head --silent "http://${domain}" | grep --silent Location; then
            ok
        else
            nok
        fi

        echo -n "Is reachable with IPv4: "
        if curl -4  --head --silent "https://${domain}" > /dev/null; then
            ok
        else
            nok
        fi

        echo -n "Is reachable with IPv6: "
        if curl -6 --head --silent "https://${domain}" > /dev/null; then
            ok
        else
            nok
        fi

        echo -n "Check HTTP 1.1: "
        if curl --http1.1 --silent "https://${domain}" > /dev/null; then
            ok
        else
            nok
        fi

        echo -n "Check HTTP2: "
        if curl --http2 --silent "https://${domain}" > /dev/null; then
            ok
        else
            nok
        fi

        echo -n "Check not reachable with TLS 1.0: "
        if ! curl --tlsv1.0 --tls-max 1.0 --silent "https://${domain}" > /dev/null; then
            ok
        else
            nok
        fi

        echo -n "Check not reachable with TLS 1.1: "
        if ! curl --tlsv1.1 --tls-max 1.1 --silent "https://${domain}" > /dev/null; then
            ok
        else
            nok
        fi

        echo -n "Check reachable with TLS 1.2: "
        if curl --tlsv1.2 --tls-max 1.2 --silent "https://${domain}" > /dev/null; then
            ok
        else
            nok
        fi

        echo -n "Check not reachable with TLS 1.3: "
        if curl --tlsv1.3 --tls-max 1.3 --silent "https://${domain}" > /dev/null; then
            ok
        else
            nok
        fi

        echo -n "Check that server responds with 200 or 404: "
        status_code=$(curl --write "%{http_code}" --silent --head --output /dev/null "https://${domain}")
        if [[ "${status_code}" == '200' || "${status_code}" == '404' ]]; then
            ok
        else
            nok
        fi

        echo -e ""
    done
}

main "$@"
