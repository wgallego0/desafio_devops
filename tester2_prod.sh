#!/bin/bash
  
echo '{"email":"wilton@tester.com.br","comment":"this is alive","content_id":2}' > teste2.json
curl -sv 192.168.1.114:35800/api/comment/new -X POST -H 'Content-Type: application/json' -d @teste2.json
curl -sv --silent 192.168.1.114:35800/api/comment/list/2 |grep 'this is alive' > output2.txt

arquivo="output2.txt"
if [ -s $arquivo ]
then
   echo "teste yes"
else
   echo "teste no"
   exit 1 
fi
