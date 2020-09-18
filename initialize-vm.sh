#!/bin/bash

# Número da VM
VM_NUMBER = $vm_number

# Todos os deploys serão feitos no root
sudo su

# Mudar para a pasta home do root (/root)
cd ~

# Clonar o diretorio
git clone https://github.com/gobrasa/docker-jitsi-meet.git

# Ir para o diretorio docker-jitsi-meet
cd docker-jitsi-meet

# Copiar o .env para a máquina
cp envs/.env$VM_NUMBER .env

# Gerar senhas para a nova máquina
./gen-passwords.sh

# Criar os diretorios de configuração
mkdir -p ~/.jitsi-meet-cfg/{web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

# Dar deploy (ATENÇÃO: NÃO DAR docker-compose down)
docker-compose up -d

# Criar o usuário admin com senha gobrasa2020 para logar o host na sala
docker-compose exec prosody prosodyctl --config /config/prosody.cfg.lua register admin meet.jitsi gobrasa2020

# Copiar o plugin do mod_muc_max_occupants para a pasta de plugins custom
cp ./plugins/mod_muc_max_occupants.lua ~/.jitsi-meet-cfg/prosody/prosody-plugins-custom

# Editar o arquivo de config do prosody para adicionar o plugin e limitar a sala
vim ~/.jitsi-meet-cfg/prosody/config/conf.d/jitsi-meet.cfg.lua

# Adicionar "muc_max_occupants = 28" e modules enabled com muc_access_whitelist como no texto exemplo no arquivo de config

# **************************************************
# Component "conference.meet.example.com" "muc"
#     storage = "none"
#     muc_max_occupants = 3
#     modules_enabled = {
#         "muc_meeting_id";
#         "muc_domain_mapper";
#         "muc_max_occupants";
#         -- "token_verification";
#     }
#     muc_access_whitelist = { 
#         "recorder@meet.example.com";
#         "focus@auth.example.com"; 
#     }
#     admins = { "focus@auth.meet.example.com" }
#     muc_room_locking = false
#     muc_room_default_public_jids = true
# ***************************************************

# Dar stop no server
docker-compose stop

# Reiniciar o server com a nova config
docker-compose up -d
