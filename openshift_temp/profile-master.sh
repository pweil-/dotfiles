#/bin/bash
set -o errexit
set -o nounset
set -o pipefail

master_pid=$1

if [ "${master_pid}" == "" ]; then
  echo "usage:  profile-cluster.sh <master pid>"
  exit 1
fi

openshift=$(which openshift)
smem=$(which smem)
realmem=${REALMEM:-1600M}

tmp=$(mktemp -d -p /tmp profile-cluster.XXXXX)
pprof_cpu_dir="${tmp}/pprof.cpu"
pprof_heap_alloc_dir="${tmp}/pprof.heap.alloc_space"

mkdir ${pprof_cpu_dir}
mkdir ${pprof_heap_alloc_dir}

echo "profiling ${master_pid} pid to ${tmp}"

while true; do
  timestamp=$(date +"%Y%m%d%H%M%S")

  # cpu profile (30s sample)
  go tool pprof -png -output=${pprof_cpu_dir}/pprof.cpu-${timestamp}.png ${openshift} http://127.0.0.1:6060/debug/pprof/profile

  # heap profile (--alloc_space)
  go tool pprof -png -output=${pprof_heap_alloc_dir}/pprof.heap.alloc_space-${timestamp}.png --alloc_space ${openshift} http://127.0.0.1:6060/debug/pprof/heap

  # cpu usage
  ps -p ${master_pid} --no-headers -o %cpu | xargs >> ${tmp}/system.cpu.txt

  # system memory
  sudo smem -R ${realmem} | grep ${master_pid} | grep -v grep | awk '{print $5,$6,$7}' >> ${tmp}/system.memory.txt
done
