#! /bin/bash

app_id="$1"

# --------------------------------------------------------------------------------------------------------------------------------
# create video streams

for value in {1..100}
do
    uid=$((2000+value))

    curl --request POST \
    --url https://api.agora.io/na/v1/projects/${app_id}/cloud-player/players \
    --header "Authorization: Basic ${agora_token}" \
    --header 'Content-Type: application/json' \
    --data "{
        \"player\": {
            \"streamUrl\": \"https://sol011.github.io/dummy-stream-files/videos-yuv420/${value}-yuv420.mkv\",
            \"channelName\": \"${uid}\",
            \"uid\": ${uid},
            \"idleTimeout\": 60,
            \"name\": \"multichan-poc-${value}-video\"
        }
    }" | grep "id" | awk -F '"id":' '{print $2}' | cut -d "," -f1 | cut -d '"' -f2 &
done

wait

printf "\n"

# --------------------------------------------------------------------------------------------------------------------------------
# create audio streams

current_time=$(date +%s)
# echo "${current_time}"

for value in {1..100}
do
    stream_delay=2
    unset delay
    uid=$((2000+value))
    delay=$((current_time+value*stream_delay))

    curl --request POST \
    --url https://api.agora.io/na/v1/projects/${app_id}/cloud-player/players \
    --header "Authorization: Basic ${agora_token}" \
    --header 'Content-Type: application/json' \
    --data "{
        \"player\": {
            \"streamUrl\": \"https://sol011.github.io/dummy-stream-files/output_2s_opus/${value}.opus\",
            \"channelName\": \"${uid}\",
            \"uid\": ${uid},
            \"idleTimeout\": 60,
            \"name\": \"multichan-poc-${value}-audio\",
            \"playTs\": ${delay}
        }
    }" | grep "id" | awk -F '"id":' '{print $2}' | cut -d "," -f1 | cut -d '"' -f2 &
done

wait

# echo '{"fields":"player.uid,player.id,player.createTs,player.status","player":{"createTs":1669294684,"id":"F3206E951043E3A61704A69EEF98AD46","status":"connecting","uid":2001}}' | awk -F '"id":' '{print $2}' | cut -d "," -f1 | cut -d '"' -f2

