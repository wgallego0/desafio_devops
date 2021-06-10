#!/bin/bash
  
echo '{"email":"wilton@tester.com.br","comment":"this is alive","content_id":1}' > teste1.json
curl -sv 192.168.1.114:38000/api/comment/new -X POST -H 'Content-Type: application/json' -d @teste1.json
curl -sv --silent 192.168.1.114:38000/api/comment/list/1 |grep 'this is alive' > output1.txt

arquivo="output1.txt"
if [ -s $arquivo ]
then
   echo "teste yes"
else
   echo "teste no"
   exit 1 
fi
