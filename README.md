# pfsensebackupxml
## Script de Backup de XML Pfsense.
Este script é compatível com todas as versões: v2.2.6 a v2.6.x .

- Procedimentos:
Acesse o Pfsense, crie um usuario destinado somente para o backup, pode ser o nome "backup" e atribua uma senha e salve.

- Permissões: Edite o usuario criado, clique em "Effective Privileges" e adicione somente a seguinte permissão:
"WebCfg - Diagnostics: Backup & Restore	Allow access to the 'Diagnostics: Backup & Restore' page. (admin privilege)"

Depois salve

- Precisaremos um outro computador com Linux instalado (Debian ou Ubuntu ou CentOS ou etc), pois neste linux que iremos executar os backups via script.

- Dentro do Linux, tenha certeza de conter os seguinte pacotes:

curl e wget

- Para instalar o curl e wget no Debian, Ubuntu, e variantes:

```
apt-get update -y
apt-get install curl wget -y
```

- Para instalar o curl e wget no CentOS e RedHat:

```
yum update -y
yum install curl wget -y
```

- Para instalar o curl e wget no AlmaLinux:

```
dnf update -y
dnf install curl wget -y
```

- Crie um diretório e baixe o script seguindo os seguinte procedimentos:

```
mkdir /opt/scripts 

cd /opt/scripts 

wget https://raw.githubusercontent.com/lucastavarestga/pfsensebackupxml/main/Script_Backup_Pfsense_xml.sh
```

- Sete a permissão de execução:

```
chmod +x Script_Backup_Pfsense_xml.sh
```

- Edite o arquivo Script_Backup_Pfsense_xml.sh e modifique as opções:

LISTE_SRV -> Este corresponde aos endereços completos do servidores Pfsense.

Exemplo:

LISTE_SRV="
https://192.168.1.1:2017
https://192.168.2.1:10443
http://192.168.3.1
"

PFSENSE_USER -> Neste local vai colocar o nome do usuário criado dentro do Pfsense

PFSENSE_PASS -> Neste local vai colocar a senha configurada para o usuario criado para o backup do Pfsense

Exemplo:

PFSENSE_USER='backup'

PFSENSE_PASS='Backup_2023_SalvaVidas_akqKqq2i09290sk'

- Executadas as modificações, efetuei um teste do backup:

```
sh -x /opt/scripts/Script_Backup_Pfsense_xml.sh
```

- Após finalizado, verifique a tela, se ocorreram erros "Sempre analise os logs dentro do Linux"

- Verifique se o backup foi executado dentro de: "/opt/scripts/conf_backup/cliente1/", pode usar o comando:

```
ls -lha /opt/scripts/conf_backup/cliente1/
```

* NOTA: Dentro do diretório "/opt/scripts/conf_backup/cliente1/" háverá um outro diretório com a data da execução do backup, seguindo o padrão "Ano-mes-dia"

Entre neste diretório, e liste os arquivos gerados.

- Abra o arquivo XML e verifiquei se tem conteúdo, e se o backup foi executado corretamente.

Qualquer dúvida, entre em contato sem problemas.

e-mail: lucastavarestga@gmail.com

Linkedin: https://www.linkedin.com/in/lucastavarestga/
