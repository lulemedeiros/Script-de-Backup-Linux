#!/bin/bash

# Dependências opcionais para o script são:
# figlet, #dnf install -y figlet
# figlet, #dnf install -y xcowsay
# figlet, #dnf install -y sl

clear

# Setando variaveis ...
f_lock=/tmp/lockfile # Local e arquivo de trava, para não rodar outra rotiva de backup se já houver uma ativa

function saindo {

    saindo=3 # Setando os segundos no caso de sair
    while [ $saindo -ne 0 ]; do # Entrando no loop do contador do aviso

        echo -e "\t Finalizando o backup em $saindo segundos. "
        sleep 1;
        ((saindo=$saindo-1))

    done
    echo -e "\n\t Finalizado o script. Bye \n "
    exit 1

}

function backup {

    while : ; do
        # Setando variaveis ...
        o_user=$(whoami)
        o_origem=/home/$o_user/ # Set aqui a origem dos arquivos do backup
        d_destin=/mnt/BACKUP160/Backup-Linux/$o_user/ # Set aqui o destino dos arquivos do backup
        f_lock=/tmp/lockfile # Local e arquivo de trava, para não rodar outra rotiva de backup se já houver uma ativa

        # O que não é para copiar está setado no arquivo txt
        nao_copiar="nao_copiar.txt" # Neste caso o arquivo esta no mesmo local do script de backup

        # Configurações do aviso da vaquinha do comando xcowsay
        conf_xcowsay="--time=4 --cow-size=small --reading-speed=2"

        # Verifica e avisa se a pasta de destino do backup não for encontrada e sai do script encerrando.
        if [ ! -d $d_destin ]; then
            xcowsay $conf_xcowsay " O diretório de destino do backup não foi encontrado! "
            exit 1
        fi

        touch $f_lock # Cria o arquivo de trava

        # Começo do código a ser loopado.
        # Seta e desmonta a data.
        sl # Chama o trem
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

        # Pasta está sincronizada, aguardando próximo loop.
        # Fim do código dentro do loop.
        rm $f_lock # Deletando arquivo da trava

    done

}


if [[ ! -e $f_lock ]]; then

    clear
    echo -e "\n\t Nenhum arquivo de trava encontrado, \n\t Iniciando a rotina de backup. \n "
    backup # Chama a função/rotina de backup

else

    clear
    echo -e "\n
            Atenção, arquivo de trava encontrado em: \n
            $f_lock \n
            Parece que existe uma rotina de backup ativa, 
            convem verificar, também pode ser uma rotina
            mau finalizada.
            \n"

    echo -e " Escolha uma das opções abaixo, '1' para Sim e deletar a \n trava e continuar o backup ou '2' para Não terminando o \n script. \n "

    # Colocando duas opções para o array, Sim e Não
    select op in Sim Não

    do
        clear
        case $op in

            # Dois valores de caso são declarados aqui para correspondência
            "Sim")

                clear
                echo -e "\n\t Você digitou $op, deletando o aquivo de trava "
                rm "$f_lock" # Deletando arquivo da trava
                sleep 2
                echo -e "\t A trava foi deletada, continuando para o backup. "
                sleep 2
                backup
                #break

            ;;

            # Três valores de caso são declarados aqui para correspondência
            "Não")

                clear
                echo -e "\n\t Você digitou $op, o script de backup será finalizado... "
                saindo
                break

            ;;

            # Correspondendo com dados inválidos
            *)

                clear
                echo -e "\n\t Opção inválida, o script de backup será finalizado... "
                saindo
                break

            ;;
        esac

    done

fi
