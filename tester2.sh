#!/bin/bash
  
echo '{"email":"wilton@tester.com.br","comment":"this is dead","content_id":1}' > teste2.json
curl -sv 192.168.1.114:38000/api/comment/new -X POST -H 'Content-Type: application/json' -d @teste2.json
curl -sv --silent 192.168.1.114:38000/api/comment/list/2 |grep 'this is dead' > output2.txt

arquivo="output2.txt"
if [ -s $arquivo ]
then
   echo "teste yes"
else
   echo "teste no"
   exit 1 
fi
