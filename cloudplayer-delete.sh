#! /bin/bash

app_id="$1"
filename="$2"

sort ${filename} > "${filename}-sorted.txt"

while read -r line; do
    player_id=$(echo ${line} | cut -d " " -f3)
    # printf '%s\n' ${player_id}

    curl --request DELETE \
        --url https://api.agora.io/na/v1/projects/${app_id}/cloud-player/players/${player_id} \
        --header "Authorization: Basic ${agora_token}"
        

done < "${filename}-sorted.txt"


