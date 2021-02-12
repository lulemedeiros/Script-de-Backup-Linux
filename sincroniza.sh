#!/bin/bash

# Dependências opcionais para o script são:
# figlet, #dnf install -y figlet
# figlet, #dnf install -y xcowsay
# figlet, #dnf install -y sl

while : ; do

  # Setando variaveis ...
  # Usuário, origem e destino da cópia, local do arquivo de trava
  o_user=$(whoami)
  o_origem=/home/$o_user/
  d_destin=/mnt/BACKUP160/Backup-Linux/$o_user/
  f_lock=/tmp/lockfile

  # O que não copiar setado no arquivo txt
  nao_copiar="nao_copiar.txt" # Neste caso esta no mesmo local do script

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

    #{ # Note o "}" para execução em background, se for rodar em segundo plano descomente a linha - INICIO

      # Começo do código a ser loopado.
      # Seta e desmonta a data.
      sl
      figlet -w 150 Script de Backup do Lule

      ini_bk=`date +'%d/%m/%Y, às %H:%M:%S'`
      echo -e "\n\tO backup foi iniciado em $ini_bk"

      rsync -avzP --delete --exclude-from=$nao_copiar $o_origem $d_destin

      fim_bk=`date +'%d/%m/%Y, às %H:%M:%S'`
      echo -e "\n\tO backup foi iniciado  em $ini_bk"
      echo -e "\tO backup foi concluído em $fim_bk"
      
      segundos=1800 # Setando os segundos para o próximo backup
      let "minutos = $(( $segundos / 60 ))" # Setando os minutos, que são equivalentes aos segundos informados acima divididos por 60

      while [ $segundos -ne 0 ]; do # Entrando no loop do contador para o próximo backup
          
          echo -e "\n\n\tA rotina de backup é executada a cada 30 minutos e faltam \n\t$minutos minutos ou $segundos segundos para o próximo backup.\n\tO último backup foi em: $fim_bk"
          sleep 1m;
          ((segundos=$segundos-60))
          ((minutos=$minutos-1))

      done
      clear

      # Pasta deve estar sincronizada, aguardando próximo loop.
      # Fim do código a ser loopado.
      rm $f_lock # Deletando arquivo da trava

    #} & # Note o "} &" para execução em background, se for rodar em segundo plano descomente a linha - FIM

  else

    segundos=10 # Setando os segundos para o aviso
    while [ $segundos -ne 0 ]; do # Entrando no loop do contador do aviso

        clear
        echo -e "\n\n\tVerifique se já existe um backup ativo se não houver, delete o arquivo de trava."
        echo -e "\n\tSaindo em $segundos segundos."
        sleep 1;
        ((segundos=$segundos-1))
        
    done
    exit 1

  fi

done