#!/bin/sh
# simple integration test

CFG=/tmp/minetest.conf
MTDIR=/tmp/mt
WORLDDIR=${MTDIR}/worlds/world
WORLDMODSDIR=/tmp/worldmods

cat <<EOF > ${CFG}
 enable_jumpdrive_integration_test = true
EOF

# clone repos for testing
mkdir -p ${WORLDMODSDIR}
rm ${WORLDMODSDIR}/jumpdrive -rf
cp -R . ${WORLDMODSDIR}/jumpdrive
git clone https://github.com/minetest-mods/areas.git ${WORLDMODSDIR}/areas

mkdir -p ${WORLDDIR}
chmod 777 ${MTDIR} -R
docker run --rm -i \
	-v ${CFG}:/etc/minetest/minetest.conf:ro \
	-v ${MTDIR}:/var/lib/minetest/.minetest \
	-v ${WORLDMODSDIR}:/var/lib/minetest/.minetest/worlds/world/worldmods \
	registry.gitlab.com/minetest/minetest/server:5.0.1

test -f ${WORLDDIR}/integration_test.json && exit 0 || exit 1
