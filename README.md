# ActionController::Live Segmentation Fault Reproduction Project

## 🎯 Project Overview

This project attempts to reproduce the segmentation fault issue #55132 in `ActionController::Live` related to "double concurrent PG#close" crashes.

### Build Image

```
docker-compose -f ./docker/docker-compose.crash-reproduction.yml up -d --build
```

### Run Image

```
docker exec -it docker-rails-crash-test-1 bash
```

### Ssh'd into the docker container and run
```
ruby crash_test.rb
```

After reproducing the error the code will spit out this:
```
2e31df89eed2:/app# ruby crash_test.rb 
☢️  ULTRA-NUCLEAR CRASH TEST - Maximum Destruction + Kernel Chaos!
====================================================================
Testing ActionController::Live crash reproduction with ULTRA-NUCLEAR pressure

✅ Basic components loaded successfully

🧪 Testing ActionController::Live with ULTRA-NUCLEAR race conditions...

🧪 Creating ultra nuclear test controller...
✅ Ultra nuclear test controller created successfully

⚠️  If a segmentation fault occurs, check for core dumps in /tmp/core_dumps/
⚠️  This test uses KERNEL SIGNALS, MMAP CORRUPTION, FORK BOMBS, and ATTOSECOND timing!
⚠️  THIS IS THE ULTIMATE TEST - IF THIS DOESN'T CRASH, NOTHING WILL!

🔄 Starting ULTRA-NUCLEAR streaming test in thread 1160
⚠️  Setting up ULTRA-NUCLEAR signal handlers for maximum chaos...
🔄 ITERATION 1 - ULTRA-NUCLEAR DESTRUCTION!
☢️  Creating ULTRA-NUCLEAR pressure...
📁 Creating ultra file descriptor pressure...
   🗺️  Creating memory mapping corruption...
   ✅ Created 10 corrupted memory mappings
   ✅ Created 3100 ultra nuclear pressure objects
   ✅ Created 200 file descriptors
   ✅ Created 10 memory mappings
🔌 Creating ULTRA-NUCLEAR PostgreSQL connections...
   ✅ Connection 1 created (PID: 8248)
   ✅ Connection 2 created (PID: 8249)
   ✅ Connection 3 created (PID: 8250)
   ✅ Connection 4 created (PID: 8251)
   ✅ Connection 5 created (PID: 8252)
⚠️  Simulating ULTRA-NUCLEAR race conditions...
📤 Simulating streaming response with ULTRA-NUCLEAR precision...
✅ ITERATION 1 completed
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
message type 0x54 arrived from server while idle
message type 0x44 arrived from server while idle
message type 0x43 arrived from server while idle
message type 0x5a arrived from server while idle
message type 0x54 arrived from server while idle
message type 0x44 arrived from server while idle
message type 0x43 arrived from server while idle
message type 0x5a arrived from server while idle
message type 0x44 arrived from server while idle
message type 0x54 arrived from server while idle
message type 0x54 arrived from server while idle
message type 0x44 arrived from server while idle
message type 0x43 arrived from server while idle
message type 0x5a arrived from server while idle
message type 0x54 arrived from server while idle
message type 0x44 arrived from server while idle
message type 0x43 arrived from server while idle
message type 0x5a arrived from server while idle
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
   🔄 Thread 1232 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1232 closing connection
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
another command is already in progress
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   🔄 Thread 1256 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1256 closing connection
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
      🧹 Thread 1272 closed connection (3)
   🔄 Thread 1168 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1168 closing connection
   🚨 SENT SIGNAL USR1 during double close!
   🔄 Thread 1192 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1192 closing connection
   🚨 SENT SIGNAL USR2 during double close!
   🔄 Thread 1216 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1216 closing connection
   🚨 SENT SIGNAL USR2 during double close!
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
      🧹 Thread 1288 closed connection (1)
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
   ❌ Error in ultra nuclear race condition thread: IOError: stream closed in another thread
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
another command is already in progress
      🧹 Thread 1240 closed connection (6)
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
another command is already in progress
   🔄 Thread 1248 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1248 closing connection
   🔄 Thread 1264 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1264 closing connection
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
   🔄 Thread 1176 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1176 closing connection
   🚨 SENT SIGNAL USR1 during double close!
      🚨 SENT SIGNAL USR2 during close attempt!
   ✅ Created 20 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   🔄 Thread 1200 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1200 closing connection
   🚨 SENT SIGNAL USR1 during double close!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   🔄 Thread 1224 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1224 closing connection
   🚨 SENT SIGNAL USR2 during double close!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   🔄 Thread 1184 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1184 closing connection
   🚨 SENT SIGNAL USR1 during double close!
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
   ✅ Created 30 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   🔄 Thread 1208 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1208 closing connection
   🚨 SENT SIGNAL USR1 during double close!
   🚨 SENT SIGNAL USR2 during double close!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🧹 Thread 1280 closed connection (4)
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   ✅ Created 40 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   ✅ Created 50 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 60 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 70 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 80 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 90 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 100 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 110 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 120 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 130 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 140 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 150 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 160 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 170 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 180 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 190 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 200 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 210 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 220 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 230 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 240 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 250 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 260 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 270 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 280 corrupted memory mappings
   🚨 SIGNAL USR2 received during double close!
   💾 Created ultra memory pressure during signal!
   💥 Triggering process-level chaos...
      🚨 FORK BOMB 1 created during signal!
crash_test.rb:268: [BUG] Segmentation fault at 0x00000000000025f1SEGV received in SEGV handler
SEGV received in SEGV handler

ruby 3.4.4 (2025-05-14 revision a38531fd3f) +PRISM [x86_64-linux-musl]

-- Control frame information -----------------------------------------------
Aborted
2e31df89eed2:/app# 
```
