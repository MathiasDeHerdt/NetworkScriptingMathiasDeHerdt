# Examen informatie
voor het examen van Kerst staan al mijn files (Terraform, Ansible, Bash en Powershell) onder de map "!EXAMEN"

# Examen: Terraform en Ansible
Hoe moet ik de scripts runnen?
- **Terraform**
1. in WSL ga naar de folder waar je terraform scripts staan en voer volgende commando's uit:

- terraform init
- terraform validate
- terraform plan -out=Deploy-Win-And-Ubu-VM
- terraform apply Deploy-Win-And-Ubu-VM

- **Ansible**
2. Voor Ansible ga je nu naar de folder waar de Ansible code staat (dir-ansible) en voer volgend commando uit:

- ansible-playbook playbook.yml -i inventory.ini --ask-vault-pass

vault password: mdh

# Examen: Bash en Powershell
**Powershell:**
.\customize_firstrun.ps1


**Bash:**
bash (or sh) customize_firstrun.sh




# Labo's semester 1: Powershell
Opdracht 1 staat allemaal onder DC1, DC2, MS en de csv files staan in intranet.mijnschool.be
Opdracht 2 staat onder !PowershellOpdracht2