#!/usr/bin/env nash

# populates the environment with variables containing the
# environment configuration

droplet_image        = "coreos-stable"
droplet_size         = "512mb"
digitalocean_region  = "nyc3"
droplet_ssh_key      = "devopsfloripa"
droplet_ssh_key_file = "./config/ssh-key.pub"
weave_state_file     = "./config/weave_route.state"
