provider "vultr" {

}

variable "css_snapshot_id" {
    type = string
    validation {
        condition = length(var.css_snapshot_id) > 0
        error_message = "The css_snapshot_id was empty!"
    }
}

variable "ssh_key_ids" {
    type = list(string)
}

resource "vultr_server" "css_server" {
    region_id = "19" # Sydney https://api.vultr.com/v1/regions/list
    plan_id = "202" # 2GB Ram, 55GB SSD, 1 cpu https://api.vultr.com/v1/plans/list?type=vc2
    snapshot_id = var.css_snapshot_id
    hostname = "css-server"
    label = "Counter-Strike Source Server"
    ssh_key_ids = var.ssh_key_ids
    enable_ipv6 = true
    user_data = <<EOCC
# cloud-config
users:
  - name: admin
    groups:
      - users
        sudo
write_files:
  - path: /opt/css/cstrike/cfg/server.cfg
    owner: steam:steam
    permissions: '0644'
    content: |
        echo =========================
        echo executing CS:S Server.cfg
        echo =========================

        hostname "IT Support"

        // set to force players to respawn after death
        mp_forcerespawn 1

        // enable player footstep sounds
        mp_footsteps 1
        sv_footsteps 1

        mp_friendlyfire 1

        sv_forcepreload 1
        sv_lan 0

        deathmatch 0

        sv_alltalk 0
        sv_voiceenable 1

        mp_allowNPCs 1


        sv_rcon_banpenalty 0
        //Number of minutes to ban users who fail rcon authentication
        sv_rcon_maxfailures 10
        // Number of times a user can fail rcon authentication in sv_rcon_minfailuretime before being banned
        sv_rcon_minfailures 5
        // Number of seconds to track failed rcon authentications
        sv_rcon_minfailuretime 30

        bot_add
        bot_quota 8
        bot_difficulty 1
        bot_prefix BOT

        rcon_password "afafafaf"
        sv_password "fafafa"




EOCC
}

terraform {
  experiments = [variable_validation]
}
