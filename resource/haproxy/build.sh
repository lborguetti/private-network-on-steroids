#!/usr/bin/env nash

import ./lib/map
import ./lib/droplet
import ./lib/template
import ./config/vars

weave_password <= uuidgen | sed "s/-//g"
echo $weave_password > $weave_state_file

droplet_name       = "haproxy"
user_data_template = "resource/haproxy/cloud-config/haproxy.template"
user_data          = "resource/haproxy/cloud-config/haproxy.yaml"
tpl_vars           = (
	("WEAVE_PASSWORD" $weave_password)
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

rm -f $user_data
