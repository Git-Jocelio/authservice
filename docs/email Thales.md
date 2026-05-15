Olá, tudo bem?



Conforme solicitado, realizamos a criação, configuração e instalação do ambiente de testes para validação de LDAP e Active Directory.



O ambiente foi **instalado e configurado no Proxmox 2**, utilizando a rede privada 192.168.100.1/24, isolada da rede principal da Aussel



O acesso ao ambiente de testes pode ser realizado via RDP (MSTSC), utilizando o IP do Proxmox. Esse acesso direciona diretamente para as máquinas do laboratório, sem acesso ao Proxmox em si.



Observação: o **acesso** é permitido apenas para IPs previamente liberados manualmente no Proxmox.



Acesso ao Ambiente de Testes via MSTSC



Servidor Windows Server 2022 – LAB

IP: 10.10.1.245:3389

Usuário: compbyte\\administrator

Senha: compbyte@2026



**Windows 10 – Máquina Cliente LAB**

**IP: 10.10.1.245:3390**

**Usuário: compbyte\\gluz**

**Senha: @aussel2026**





Testes Realizados



No servidor:



netstat -an | findstr :389

netstat -an | findstr :636



Na máquina cliente:



telnet 192.168.100.30 389

Os testes de conectividade LDAP e acesso remoto via RDP foram realizados com sucesso.





Configurações e Recursos do Ambiente de Testes



**Servidor Windows Server 2022**

Usuário: administrator

Senha: compbyte@2026



Recursos instalados:



Windows Server 2022

Active Directory Domain Services (AD DS)

DNS Server

Domain Controller

Domínio configurado:

compbyte.lab



Unidade Organizacional criada:

T.I



**Usuários criados no Active Directory:**



Carla Almeida (calmeida)

Danilo Silva (dsilva)

Gabriel Luz (gluz)

José Alves (jalves)

Vinicius Gomes (vgomes)

IP do servidor:

192.168.100.30





**Windows 10 – Máquina Cliente LAB**



Hostname:

TS-TESTE-LAB



Domínio:

compbyte.lab



Configuração de Rede:



IP: 192.168.100.40

Máscara: 255.255.255.0

Gateway: 192.168.100.1

DNS: 192.168.100.30

Perfis carregados na máquina:



calmeida

gluz

dsilva

jalves

vgomes

Senha padrão dos usuários:

@aussel2026



PS C:\\Users\\Administrator>

