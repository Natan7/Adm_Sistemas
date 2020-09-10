#!/bin/bash

mkdir -p /home/administração_sistemas/roteiros/comandos
mkdir -p /home/administração_sistemas/roteiros/scripts
mkdir -p /home/administração_sistemas/roteiros/servicos
mkdir -p /home/administração_sistemas/roteiros/arquivos
mkdir -p /home/administração_sistemas/scripts/usuarios
mkdir -p /home/administração_sistemas/scripts/processos
mkdir -p /home/administração_sistemas/scripts/servicos
mkdir -p /home/administração_sistemas/scripts/backup
mkdir -p /home/administração_sistemas/servicos/firewall
mkdir -p /home/administração_sistemas/servicos/proxy
mkdir -p /home/administração_sistemas/servicos/vpn
mkdir -p /home/administração_sistemas/servicos/web

touch /home/administração_sistemas/roteiros/comandos/básicos
touch /home/administração_sistemas/roteiros/comandos/regras_iptables
touch /home/administração_sistemas/roteiros/scripts/scripts_usuarios
touch /home/administração_sistemas/roteiros/scripts/scripts_backup
touch /home/administração_sistemas/roteiros/servicos/iptables
touch /home/administração_sistemas/roteiros/servicos/dns
touch /home/administração_sistemas/roteiros/servicos/apache
touch /home/administração_sistemas/roteiros/arquivos/permissoes

echo -n > /home/administração_sistemas/scripts/usuarios/cria_multiplos
echo -n > /home/administração_sistemas/scripts/usuarios/cria_em_grupo
echo -n > /home/administração_sistemas/scripts/processos/processos_memoria
echo -n > /home/administração_sistemas/scripts/processos/processos_cpu
echo -n > /home/administração_sistemas/scripts/servicos/adiciona_regra_firewall
echo -n > /home/administração_sistemas/scripts/backup/backup_usuarios

echo -n | cat > /home/administração_sistemas/servicos/firewall/config
echo -n | cat > /home/administração_sistemas/servicos/firewall/config
echo -n | cat > /home/administração_sistemas/servicos/proxy/sites_proibidos
echo -n | cat > /home/administração_sistemas/servicos/vpn/key
echo -n | cat > /home/administração_sistemas/servicos/web/.htaccess

ls -Rla /home/administração_sistemas/

cp -a /home/administração_sistemas/roteiros/scripts/* /home/administração_sistemas/scripts

rename 's/cria_multiplos/cria_usuarios/' /home/administração_sistemas/scripts/usuarios/cria_multiplos

mv /home/administração_sistemas/roteiros/comandos/regras_iptables /home/administração_sistemas/servicos/firewall

cp -a /home/administração_sistemas/scripts/servicos/adiciona_regra_firewall /home/administração_sistemas/servicos/firewall

rm -Rf /home/administração_sistemas/roteiros

mkdir /home/administração_sistemas/teste

touch /home/administração_sistemas/teste/arq{1..3}
touch /home/administração_sistemas/teste/arq10
touch /home/administração_sistemas/teste/sessao{1..3}
touch /home/administração_sistemas/teste/sapo 
touch /home/administração_sistemas/teste/satisfacao

ls /home/administração_sistemas/teste/ | grep '^arq[123]$'

ls /home/administração_sistemas/teste/ | grep '^arq[1]'

ls /home/administração_sistemas/teste/ | grep '^sessao'

ls /home/administração_sistemas/teste/ | grep '1$'

ls /home/administração_sistemas/teste/ | grep '^sessao[13]$'

ls /home/administração_sistemas/teste/ | egrep '^s.*[a-e].*o$'

cd /etc
ls | egrep '^p.*s$'

man cp > /home/administração_sistemas/teste/arq1
man rm >> /home/administração_sistemas/teste/arq1
cat -n /home/administração_sistemas/teste/arq1
man less > /home/administração_sistemas/teste/arq1
cat -n /home/administração_sistemas/teste/arq1

head -n 20 /home/administração_sistemas/teste/arq1
tail -n 11 /home/administração_sistemas/teste/arq1

cat /home/administração_sistemas/teste/arq1 | egrep 'options'
cat /home/administração_sistemas/teste/arq1 | egrep 'options' | wc -l

mkdir /home/administração_sistemas/backup
cp -R /home/administração_sistemas/scripts /home/administração_sistemas/backup
cp -R /home/administração_sistemas/servicos /home/administração_sistemas/backup
cp -a /home/administração_sistemas/teste/*[1o] /home/administração_sistemas/backup

tar --exclude=/home/administração_sistemas/backup/* -cvf /home/administração_sistemas/backup.tar /home/administração_sistemas/backup/    #### verificar

tar -cvzf /home/administração_sistemas/backup.tar.gz /home/administração_sistemas/backup

mkdir /home/administração_sistemas/copia
cp -a /home/administração_sistemas/backup /home/administração_sistemas/copia
rm -Rf /home/administração_sistemas/backup

cd /home/administração_sistemas
tar -xf /home/administração_sistemas/backup.tar.gz

diff /home/administração_sistemas/copia/sapo /home/administração_sistemas/home/administração_sistemas/backup/sapo
