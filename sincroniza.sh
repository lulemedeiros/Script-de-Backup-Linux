#!/bin/bash

while : ; do

  # Setando variaveis ...
  # Usuário, origem e destino da cópia
  o_user=$(whoami)
  o_origem=/home/$o_user/
  d_destin=/mnt/BACKUP160/Backup-Linux/$o_user/
  f_lock=/tmp/lockfile

  # O que copiar setado no arquivo txt
  nao_copiar="nao_copiar.txt"

  # Configurações do aviso da vaquinha do comando xcowsay
  conf_xcowsay="--time=4 --cow-size=small --reading-speed=2"

  # Entra em um loop de verificação e avisa se a pasta de destino do backup não for encontrada e sai do script encerrando.
  if [ ! -d $d_destin ]; then
    xcowsay $conf_xcowsay " O diretório de destino do backup não foi encontrado! "
    exit 1
  fi

  # Usa um arquivo de lock para impedir execução simultânea.
  # Caso a execução leve mais do que sessenta segundos.
  if [[ ! -e $f_lock ]]; then

    touch $f_lock

    #{

    # Começo do código a ser loopado.
    # Seta e desmonta a data.
    sl
    figlet -w 150 Script de Backup do Lule
    rsync -avzP --delete --exclude-from=$nao_copiar $o_origem $d_destin


    echo -e "\n\tÚltimo backup foi concluído em `date +'%d/%m/%Y, às %H:%M:%S'`"
    agora=`date +'%d/%m/%Y, às %H:%M:%S'`

    contador=1800 # Setando os segundos para o próximo backup
    while [ $contador -ne 0 ]; do # Entrando no loop do contador para o próximo backup
        
        echo -e "\n\n\tA rotina de backup é executada a cada 30 minutos,\n\tFaltam $contador segundos para o próximo backup.\n\tO último backup foi em: $agora"
        sleep 1m;
        ((contador=$contador-60))

    done
    clear

    # Pasta deve estar sincronizada, aguardando próximo loop.
    # Fim do código a ser loopado.
    rm $f_lock # Deletando arquivo de trava

    #} & # Note o "&" para execução em background.


  else

    contador=10 # Setando os segundos para o aviso
    while [ $contador -ne 0 ]; do # Entrando no loop do contador do aviso

        clear
        echo -e "\n\n\tVerifique se já existe um backup ativo se não houver, delete o arquivo de trava."
        echo -e "\n\tSaindo em $contador segundos."
        sleep 1;
        ((contador=$contador-1))
        
    done
    exit 1

  fi

done