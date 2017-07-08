#!/usr/bin/env nash

import klb/digitalocean/droplet
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

droplet_name       = "haproxy"
user_data_template = "resource/haproxy/cloud-config/haproxy.template"
user_data          = "resource/haproxy/cloud-config/haproxy.yaml"

haproxy_cfg        <= cat "config/haproxy.cfg"

tpl_vars           = (
	("WEAVE_ROUTER" $WEAVE_ROUTER)
	("WEAVE_PASSWORD" $WEAVE_PASSWORD)
	("HAPROXY_CFG" $haproxy_cfg)
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

droplet_ip <= digitalocean_droplet_get_ip($droplet_name)

print("You can find your app at: %s", $droplet_ip)

rm -f $user_data
