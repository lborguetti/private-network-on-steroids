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
	key     <= digitalocean_ssh_key_exists($ssh_key)

	if len($key) != "0" {
		public_key_file <= lib_map_get($cfg, "public_key_file")

		# import ssh-key file
		digitalocean_ssh_key_import($ssh_key, $public_key_file)
	}

	droplet <= digitalocean_droplet_set_ssh_key($droplet, $ssh_key)

	# set droplet user data
	user_data <= lib_map_get($cfg, "user_data")
	droplet   <= digitalocean_droplet_set_user_data_file($droplet, $user_data)

	# create droplet
	digitalocean_droplet_create($droplet)
}
