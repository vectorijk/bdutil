# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS-IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file contains environment-variable overrides to be used in conjunction
# with bdutil_env.sh in order to deploy a Hadoop + Flink cluster.
# Usage: ./bdutil deploy -e extensions/flink/flink_env.sh


# In standalone mode, Flink runs the job manager and the task managers (workers)
# on the cluster without using YARN containers. Flink also supports YARN
# deployment which will be implemented in future version of the Flink bdutil plugin.
FLINK_MODE="standalone"

# URIs of tarballs for installation.
FLINK_HADOOP1_TARBALL_URI='gs://beam-flink-tpc-test-1/flink-1.5.0-bin-hadoop27-scala_2.11.tgz'
# Hadoop v2.7 build
FLINK_HADOOP2_TARBALL_URI='gs://beam-flink-tpc-test-1/flink-1.5.0-bin-hadoop27-scala_2.11.tgz'

# Directory on each VM in which to install each package.
FLINK_INSTALL_DIR='/home/hadoop/flink-install'

# Optional JVM arguments to pass
# Flink config entry: env.java.opts:
FLINK_JAVA_OPTS="-DsomeOption=value"

# Heap memory used by the job manager (master) determined by the physical (free) memory of the server
# Flink config entry: jobmanager.heap.mb
FLINK_JOBMANAGER_MEMORY_FRACTION='0.8'

# Heap memory used by the task managers (slaves) determined by the physical (free) memory of the servers
# Flink config entry: taskmanager.heap.mb
FLINK_TASKMANAGER_MEMORY_FRACTION='0.8'

# Number of task slots per task manager (worker)
# ideally set to the number of physical cpus
# if set to 'auto', the number of slots will be determined automatically
# Flink config entry: taskmanager.numberOfTaskSlots
FLINK_TASKMANAGER_SLOTS='auto'

# Default parallelism (number of concurrent actions per task)
# If set to 'auto', this will be determined automatically
# Flink config entry: parallelism.default
FLINK_PARALLELISM='auto'

# The number of buffers for the network stack.
# Flink config entry: taskmanager.network.numberOfBuffers
FLINK_NETWORK_NUM_BUFFERS=2048


COMMAND_GROUPS+=(
  "install_flink:
     extensions/flink/install_flink.sh
  "
  "start_flink:
     extensions/flink/start_flink.sh
  "
)

# Installation of flink on master and workers; then start_flink only on master.
COMMAND_STEPS+=(
  'install_flink,install_flink'
  'start_flink,*'
)
