#!/usr/bin/env nash

import ./lib/map
import ./lib/droplet
import ./lib/template
import ./config/vars

out, status <= test -e $weave_state_file

if $status != "0" {
	print("File %s not found!\n", $weave_state_file)
	exit("127")
}

import ./config/weave_route.state

argslen <= len($ARGS)

if $argslen != "2" {
	droplet_name = "app"
} else {
	droplet_name = $ARGS[1]
}

user_data_template = "resource/app/cloud-config/app.template"
user_data          = "resource/app/cloud-config/app.yaml"
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
cfg <= lib_map_add($cfg, "ssh_key_file", $droplet_ssh_key_file)
cfg <= lib_map_add($cfg, "user_data", $user_data)
cfg <= lib_map_add($cfg, "region", $digitalocean_region)

lib_droplet_create($cfg)

rm -f $user_data
