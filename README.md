# pfsensebackupxml
Script de Backup de XML Pfsense.
Este script é compatível com todas as versões: v2.2.6 a v2.6.x .

- Procedimentos:
Acesseo o Pfsense, crie um usuario destinado somente para o backup, pode ser o nome "backup" e atribua uma senha e salve.

- Permissões: Edite o usuario criado, clique em "Effective Privileges" e adicione somente a seguinte permissão:
"WebCfg - Diagnostics: Backup & Restore	Allow access to the 'Diagnostics: Backup & Restore' page. (admin privilege)"

Depois salve

- Dentro do Linux, tenha certeza de conter os seguinte pacotes:

curl
wget

- Crie um diretório e baixe o script seguindo os seguinte procedimentos:

mkdir /opt/scripts
cd /opt/scripts
wget https://raw.githubusercontent.com/lucastavarestga/pfsensebackupxml/main/Script_Backup_Pfsense_xml.sh

- Sete a permissão de execução:

chmod +x Script_Backup_Pfsense_xml.sh

- Edite o arquivo Script_Backup_Pfsense_xml.sh e modifique as opções:

LISTE_SRV -> Este corresponde aos endereços completos do servidores Pfsense.
Exemplo:
LISTE_SRV="
https://200.200.200.2:2017
https://201.201.201.2:10443
http://202.202.202.2
"

PFSENSE_USER -> Neste local vai colocar o nome do usuário criado dentro do Pfsense
PFSENSE_PASS -> Neste local vai colocar a senha configurada para o usuario criado para o backup do Pfsense
Exemplo:
PFSENSE_USER='backup'
PFSENSE_PASS='Backup_2023_SalvaVidas_akqKqq2i09290sk'

- Executadas as modificações, efetuei um teste do backup:

sh -x /opt/scripts/Script_Backup_Pfsense_xml.sh

- Após finalizado, verifique a tela, se ocorreram erros "Sempre analise os logs dentro do Linux"

- E verifiquei se o backup foi executado dentro de: "/opt/scripts/conf_backup/cliente1/", pode usar o comando:

ls -lha /opt/scripts/conf_backup/cliente1/

*NOTA: Dentro do diretório "/opt/scripts/conf_backup/cliente1/" háverá um outro diretório com a data da execução do backup, seguindo o padrão "Ano-mes-dia"

Entre dentro deste diretório, e liste os arquivos gerados.

- Abra o arquivo XML e verifiquei se tem conteúdo, e se o backup foi executado corretamente.

Qualquer dúvida, entre em contato sem problemas.

e-mail: lucastavarestga@gmail.com
Linkedin: https://www.linkedin.com/in/lucastavarestga/
