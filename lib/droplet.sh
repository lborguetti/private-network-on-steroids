#!/usr/bin/env nash

import klb/digitalocean/ssh_key
import klb/digitalocean/droplet
import ./lib/map

fn lib_droplet_create(cfg) {
	# create instance of droplet
	name    <= lib_map_get($cfg, "name")
	size    <= lib_map_get($cfg, "size")
	image   <= lib_map_get($cfg, "image")
	region  <= lib_map_get($cfg, "region")
	droplet <= digitalocean_droplet_new($name, $size, $image, $region)

	# check if ssh-key exists
	ssh_key <= lib_map_get($cfg, "ssh_key")
	key_id  <= digitalocean_ssh_key_exists($ssh_key)

	if $key_id == "" {
		ssh_key_file <= lib_map_get($cfg, "ssh_key_file")

		# import ssh-key file
		key_info, err <= digitalocean_ssh_key_import($ssh_key, $ssh_key_file)

		if $err != "" {
			print("Could not import ssh key: %s", $err)
			exit("1")
		}

		key_id <= echo $key_info | jq ".[].id"
	}

	droplet <= digitalocean_droplet_set_ssh_key($droplet, $key_id)

	# set droplet user data
	user_data <= lib_map_get($cfg, "user_data")
	droplet   <= digitalocean_droplet_set_user_data_file($droplet, $user_data)

	# create droplet
	droplet_info, err <= digitalocean_droplet_create($droplet)

	if $err != "" {
		print("Could not create droplet: %s", $err)

		return "", $err
	}
}
