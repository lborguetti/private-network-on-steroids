#!/usr/bin/env nash

import ./lib/map
import ./lib/droplet
import ./lib/template
import ./config/var

droplet_name       = "redis"
user_data_template = "resource/redis/cloud-config/redis.template"
user_data          = "resource/redis/cloud-config/redis.yaml"
tpl_vars           = (
	("WEAVE_ROUTER" $WEAVE_ROUTER)
	("WEAVE_PASSWORD" $WEAVE_PASSWORD)
)

lib_create_file_from_tpl($user_data_template, $tpl_vars, $user_data)

cfg <= lib_map_new()
cfg <= lib_map_add($cfg, "name", $droplet_name)
cfg <= lib_map_add($cfg, "image", $droplet_image)
cfg <= lib_map_add($cfg, "size", $droplet_size)
cfg <= lib_map_add($cfg, "ssh_key", $droplet_ssh_key)
cfg <= lib_map_add($cfg, "user_data", $user_data)
cfg <= lib_map_add($cfg, "region", $digitalocean_region)

lib_droplet_create($cfg)
