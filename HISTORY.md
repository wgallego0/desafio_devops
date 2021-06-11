# Tecnologias usadas

* Docker 3.3.3 ( Windows com kernel linux )
* Portainer 2.5.1 ( Orquestrador Docker )
* Container Ubuntu 20.04 ( Homolog deploy 1 )
    * FrameWorks utilizados:
        * Git
        * Curl
        * Python
* Container Ubuntu 20.04 ( Production deploy 2 )
    * FrameWorks utilizados:
        * Git
        * Curl
        * Python

# Máquinas Containers
> * **Homolog_devops**
>     * ubuntu 20.04
>     * ip: 172.17.0.4
>     * Portas ( porta host apontada para container):
>         * 34722:22  ( Porta SSH )
>         * 34780:80  ( Porta Web )
>         * 38000:8000 ( Porta Api )
> 
> * **Production_devops**
>     * ubuntu 20.04
>     * ip: 172.17.0.3
>     * Portas ( porta host apontada para container):
>         * 35722:22  ( Porta SSH )
>         * 35780:80  ( Porta Web )
>         * 38000:8000 ( Porta Api )        
> 
> * **Portainer**
>     * Alpine
>     * ip: 172.17.0.2
>     * Portas ( porta host apontada para container):
>         * 8000:8000 ( Portainer porta web )
>         * 9000:9000 ( Portainer porta de serviço )
> 
> * **Gitlab**
>     * Linux gitlab_ce 5.4.72-microsoft-standard-WSL2
>     * ip: 172.17.0.5
>     * Portas ( porta host apontada para container):
>         * 22:22 ( Porta SSH )    
>         * 443:443 ( Porta SSL)
>         * 80:80  ( Porta web )


# Etapas de automação

* Realizado o teste da api para o entendimento do processo, producer e consumer. Resultados esperados e montagem de lógica para comparativo de teste da pipeline
* Pipilene montada em 2 etapas:
    * Test :
        * Realiza o teste nas duas listagens assim como o código abaixo:
        ```
        #!/bin/bash

            #Monto o Json em arquivo
                echo '{"email":"wilton@tester.com.br","comment":"this is alive","content_id":1}' > teste1.json
            #Envio o post para a API 
                curl -sv 192.168.1.114:38000/api/comment/new -X POST -H 'Content-Type: application/json' -d @teste1.json
            #Valido se a listagem foi recebida com o comentário que postei
                curl -sv --silent 192.168.1.114:38000/api/comment/list/1 |grep 'this is alive' > output1.txt
            #Condicional da lógica
                arquivo="output1.txt"
                if [ -s $arquivo ]
                then
                    echo "teste yes"
                else
                    echo "teste no"
                exit 1 
                fi
        ```

    * Deploy 
        * Realiza o deploy para a máquina de produção se stage de teste bem sucedido.

# Gitlab-ci.yml
    ```
    image: ubuntu:latest
    stages:
    - build
    - test
    - staging

    Teste_api:
    stage: test
    script:
        - echo "Iniciando Stage Testing:"
        - cp -R * /tmp
        - ls -ltr /tmp
        - chmod +x tester1.sh && chmod 777 tester1.sh
        - apt-get update -qq && apt-get install -y -qq curl && apt-get install sshpass -y 
        - sshpass -p Acqwp2012 ssh -o StrictHostKeyChecking=no -p34722 root@192.168.1.114 "/var/www/html/desafio_devops/app/start_api.sh &"
        - ./tester2.sh
        - sshpass -p Acqwp2012 ssh -o StrictHostKeyChecking=no -p34722 root@192.168.1.114 "pkill gunicor"
        - echo "Iniciando Stage Testing:"
        - sshpass -p Acqwp2012 ssh -o StrictHostKeyChecking=no -p34722 root@192.168.1.114 "/var/www/html/desafio_devops/app/start_api.sh &"
        - ./tester1.sh
        - sshpass -p Acqwp2012 ssh -o StrictHostKeyChecking=no -p34722 root@192.168.1.114 "pkill gunicor"

    job_deploy:
    stage: staging
    script:
        - sshpass -p Acqwp2012 scp -o StrictHostKeyChecking=no -p34722 * /app
    ```

