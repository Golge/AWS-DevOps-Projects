
# ANSIBLE | DOCKER | PERN-APP

This project aims to build a PERN (PostgreSQL | Express | React | Node) app. 

This involved orchestrating the connection of three tiers with dynamic inventory. Key steps included transferring essential folders to designated virtual machines, utilizing community Docker modules for building images, creating networks, and running containers. Integrated Vault for secure access to the Docker Hub account. Additionally, proficiently refactored and maintained playbooks, organizing them into roles to enhance reusability and maintainability. This endeavor showcased a successful integration of Ansible and Docker for streamlined deployment and efficient project management.

===
## Some Info on ANSIBLE VAULT

```bash
ansible-vault create secret.yml
```
### Type any password for creating a cyrpto yml file.
### add vars-file part to the playbook
```bash
ansible-vault view secret.yml
```
### you can view your crypte file using above command
### if you are using a vault file you must run playbook with below command
```bash
ansible-playbook postgres.yml  --ask-vault-pass
```