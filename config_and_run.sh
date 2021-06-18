#!/bin/bash

set -eu

echo "${MC_BANNED_IPS_JSON}" > banned-ips.json

echo "${MC_BANNED_PLAYERS_JSON}" > banned-players.json

cat << EOEULA > eula.txt
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#$(date)
eula=${MC_EULA_ACCEPT}
EOEULA

echo "${MC_OPS_JSON}" > ops.json

cat <<EOPROPS > server.properties
#Minecraft server properties
#$(date)
broadcast-rcon-to-ops=${MC_SERVER_BROADCAST_RCON_TO_OPS}
view-distance=${MC_SERVER_VIEW_DISTANCE}
enable-jmx-monitoring=${MC_SERVER_ENABLE_JMX_MONITORING}
server-ip=${MC_SERVER_SERVER_IP}
resource-pack-prompt=${MC_SERVER_RESOURCE_PACK_PROMPT}
rcon.port=${MC_SERVER_RCON_PORT}
gamemode=${MC_SERVER_GAMEMODE}
server-port=${MC_SERVER_SERVER_PORT}
allow-nether=${MC_SERVER_ALLOW_NETHER}
enable-command-block=${MC_SERVER_ENABLE_COMMAND_BLOCK}
enable-rcon=${MC_SERVER_ENABLE_RCON}
sync-chunk-writes=${MC_SERVER_SYNC_CHUNK_WRITES}
enable-query=${MC_SERVER_ENABLE_QUERY}
op-permission-level=${MC_SERVER_OP_PERMISSION_LEVEL}
prevent-proxy-connections=${MC_SERVER_PREVENT_PROXY_CONNECTIONS}
resource-pack=${MC_SERVER_RESOURCE_PACK}
entity-broadcast-range-percentage=${MC_SERVER_ENTITY_BROADCAST_RANGE_PERCENTAGE}
level-name=${MC_SERVER_LEVEL_NAME}
rcon.password=${MC_SERVER_RCON_PASSWORD}
player-idle-timeout=${MC_SERVER_PLAYER_IDLE_TIMEOUT}
motd=${MC_SERVER_MOTD}
query.port=${MC_SERVER_QUERY_PORT}
force-gamemode=${MC_SERVER_FORCE_GAMEMODE}
rate-limit=${MC_SERVER_RATE_LIMIT}
hardcore=${MC_SERVER_HARDCORE}
white-list=${MC_SERVER_WHITE_LIST}
broadcast-console-to-ops=${MC_SERVER_BROADCAST_CONSOLE_TO_OPS}
pvp=${MC_SERVER_PVP}
spawn-npcs=${MC_SERVER_SPAWN_NPCS}
spawn-animals=${MC_SERVER_SPAWN_ANIMALS}
snooper-enabled=${MC_SERVER_SNOOPER_ENABLED}
difficulty=${MC_SERVER_DIFFICULTY}
function-permission-level=${MC_SERVER_FUNCTION_PERMISSION_LEVEL}
network-compression-threshold=${MC_SERVER_NETWORK_COMPRESSION_THRESHOLD}
text-filtering-config=${MC_SERVER_TEXT_FILTERING_CONFIG}
require-resource-pack=${MC_SERVER_REQUIRE_RESOURCE_PACK}
spawn-monsters=${MC_SERVER_SPAWN_MONSTERS}
max-tick-time=${MC_SERVER_MAX_TICK_TIME}
enforce-whitelist=${MC_SERVER_ENFORCE_WHITELIST}
use-native-transport=${MC_SERVER_USE_NATIVE_TRANSPORT}
max-players=${MC_SERVER_MAX_PLAYERS}
resource-pack-sha1=${MC_SERVER_RESOURCE_PACK_SHA1}
spawn-protection=${MC_SERVER_SPAWN_PROTECTION}
online-mode=${MC_SERVER_ONLINE_MODE}
enable-status=${MC_SERVER_ENABLE_STATUS}
allow-flight=${MC_SERVER_ALLOW_FLIGHT}
max-world-size=${MC_SERVER_MAX_WORLD_SIZE}
EOPROPS

echo "${MC_WHITELIST_JSON}" > whitelist.json

# Start JVM from environment variables
java "${MC_JAVA_OPTS[@]}" -jar server.jar "${MC_OPTS[@]}"
