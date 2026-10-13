#!/bin/bash

# 200: OK
# 201: Created
# 400: Bad Request
# 401: Unauthorized
# 403: Forbidden
# 404: Not Found
# 500: Internal Server Error
# 501: Not Implemented
# 502: Bad Gateway
# 503: Service Unavailable

response_codes=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
methods=("GET" "POST" "PUT" "PATCH" "DELETE")
agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")

for index in 4 3 2 1 0; do
log_file_name="log_file_$((5-$index)).log"
rm -rf $log_file_name
touch "$log_file_name"
    for (( j = 0; j < $((RANDOM%(1000 - 100 + 1)+100)); j++ )); do
    ip="$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256)).$((RANDOM%256))"
    status_code=${response_codes[ $((RANDOM%${#response_codes[@]})) ]}
    http_methods=${methods[ $((RANDOM%${#methods[@]})) ]}
    agent=${agents[ $((RANDOM%${#agents[@]})) ]}
    time_local="$(date -d "today -${index} days" "+%d/%b/%Y:%H:%M:%S %z")"
    
    echo "$ip - - [$time_local] \"$http_methods "index.html" HTTP/1.1\" $status_code - \"$agent\"" >> $log_file_name
    done
done
