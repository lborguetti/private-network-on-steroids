import klb/digitalocean/droplet
import klb/digitalocean/ssh_key

fn lib_droplet_create(cfg) {
	# create instance of droplet
	name    <= lib_map_get($cfg, "name")
	size    <= lib_map_get($cfg, "size")
	image   <= lib_map_get($cfg, "image")
	region  <= lib_map_get($cfg, "region")
	droplet <= digitalocean_droplet_new($name, $size, $image, $region)

	# check if ssh-key exists
	ssh_key <= lib_map_get($cfg, "ssh_key")
	key     <= digitalocean_ssh_key_existis($ssh_key)

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
	droplet_info <= digitalocean_droplet_create($droplet)
	droplet_ip   <= echo $droplet_info | jq ""
}
