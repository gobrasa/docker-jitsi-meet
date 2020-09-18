#!/bin/bash

VM_NUMBER = $vm_number

cd 
git clone https://github.com/gobrasa/docker-jitsi-meet.git
cd docker-jitsi-meet
cp envs/.env$VM_NUMBER .env
./gen-passwords.sh
mkdir -p ~/.jitsi-meet-cfg/{web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}
docker-compose up -d
docker-compose exec prosody /bin/bash prosodyctl --config /config/prosody.cfg.lua register admin meet.jitsi gobrasa2020

