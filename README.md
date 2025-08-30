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
74a63f60df20:/app# ruby ultra_nuclear_crash_test.rb
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
   ✅ Connection 1 created (PID: 2342)
   ✅ Connection 2 created (PID: 2343)
   ✅ Connection 3 created (PID: 2344)
   ✅ Connection 4 created (PID: 2345)
   ✅ Connection 5 created (PID: 2346)
⚠️  Simulating ULTRA-NUCLEAR race conditions...
📤 Simulating streaming response with ULTRA-NUCLEAR precision...
✅ ITERATION 1 completed
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
message type 0x54 arrived from server while idle
message type 0x54 arrived from server while idle
message type 0x44 arrived from server while idle
message type 0x43 arrived from server while idle
message type 0x5a arrived from server while idle
message type 0x54 arrived from server while idle
message type 0x44 arrived from server while idle
message type 0x43 arrived from server while idle
message type 0x5a arrived from server while idle
message type 0x44 arrived from server while idle
   🔄 Thread 1168 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1168 closing connection
message type 0x54 arrived from server while idle
message type 0x44 arrived from server while idle
message type 0x43 arrived from server while idle
message type 0x5a arrived from server while idle
message type 0x54 arrived from server while idle
message type 0x44 arrived from server while idle
message type 0x43 arrived from server while idle
message type 0x5a arrived from server while idle
message type 0x43 arrived from server while idle
   🚨 SENT SIGNAL USR1 during double close!
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
      🧹 Thread 1232 closed connection (1)
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
   🔄 Thread 1240 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1240 closing connection
   🚨 SENT SIGNAL USR1 during double close!
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
      🧹 Thread 1264 closed connection (1)
   🔄 Thread 1184 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1184 closing connection
   🚨 SENT SIGNAL USR1 during double close!
   🚨 SENT SIGNAL USR2 during double close!
   🔄 Thread 1216 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1216 closing connection
   🚨 SENT SIGNAL USR1 during double close!
   🚨 SENT SIGNAL USR2 during double close!
      🚨 SENT SIGNAL USR1 during close attempt!
      🧹 Thread 1272 closed connection (6)
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
another command is already in progress
   ❌ Error in ultra nuclear race condition thread: IOError: stream closed in another thread
   ❌ Error in ultra nuclear race condition thread: IOError: stream closed in another thread
   ❌ Error in ultra nuclear race condition thread: IOError: stream closed in another thread
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
another command is already in progress
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
another command is already in progress
   🔄 Thread 1248 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1248 closing connection
   🚨 SENT SIGNAL USR2 during double close!
   ❌ Error in ultra nuclear race condition thread: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   🔄 Thread 1176 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1176 closing connection
   🚨 SENT SIGNAL USR1 during double close!
   🚨 SENT SIGNAL USR2 during double close!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
   ✅ Created 20 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🧹 Thread 1224 closed connection (2)
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   🔄 Thread 1256 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1256 closing connection
   🚨 SENT SIGNAL USR2 during double close!
      🚨 SENT SIGNAL USR1 during close attempt!
      🧹 Thread 1280 closed connection (1)
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   ❌ Error in ultra nuclear race condition thread: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   🔄 Thread 1192 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1192 closing connection
   🔄 Thread 1208 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1208 closing connection
   🚨 SENT SIGNAL USR2 during double close!
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
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
   ❌ Error in ultra nuclear race condition thread: PG::UnableToSend: PQsendQuery another command is already in progress
another command is already in progress
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   🔄 Thread 1200 executed query on connection
   🚨 DOUBLE CLOSE: Thread 1200 closing connection
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
   ✅ Created 30 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      🚨 SENT SIGNAL USR2 during close attempt!
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
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
      ❌ Error closing connection: PG::ConnectionBad: connection is closed
      🚨 SENT SIGNAL USR1 during close attempt!
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
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 290 corrupted memory mappings
   🚨 SIGNAL USR1 received during race condition!
   💾 Forced garbage collection during signal!
   🗺️  Creating memory mapping corruption...
   ✅ Created 300 corrupted memory mappings
   🚨 SIGNAL USR2 received during double close!
   💾 Created ultra memory pressure during signal!
   💥 Triggering process-level chaos...
      🚨 FORK BOMB 1 created during signal!
ultra_nuclear_crash_test.rb:268: [BUG] Segmentation fault at 0x0000000100000010
ruby 3.4.4 (2025-05-14 revision a38531fd3f) +PRISM [x86_64-linux-musl]

-- Control frame information -----------------------------------------------
c:0003 p:---- s:0013 e:000012 CFUNC  :exec
c:0002 p:0031 s:0008 e:000007 BLOCK  ultra_nuclear_crash_test.rb:268 [FINISH]
c:0001 p:---- s:0003 e:000002 DUMMY  [FINISH]

-- Ruby level backtrace information ----------------------------------------
ultra_nuclear_crash_test.rb:268:in 'block (3 levels) in create_ultra_nuclear_connections'
ultra_nuclear_crash_test.rb:268:in 'exec'

-- Threading information ---------------------------------------------------
Total ractor count: 1
Ruby thread count for this ractor: 5

-- Machine register context ------------------------------------------------
 RIP: 0x00007f6c64b64acd RBP: 0x00007f6c470ea490 RSP: 0x00007f6c2df5c078
 RAX: 0x0000000100000000 RBX: 0x00007f6c4877b5c0 RCX: 0x00007f6c4877b5b0
 RDX: 0x000000000000001f RDI: 0x00007f6c4877b5c0 RSI: 0x0000000000000000
  R8: 0x000000000000001f  R9: 0x00007f6c4877b5c0 R10: 0x000000000fffffff
 R11: 0x0000000000000202 R12: 0x0000000000000200 R13: 0x0000000000000100
 R14: 0x00007f6c46b25370 R15: 0x00007f6c46b25370 EFL: 0x0000000000010206

-- Other runtime information -----------------------------------------------

* Loaded script: ultra_nuclear_crash_test.rb

* Loaded features:

    0 enumerator.so
    1 thread.rb
    2 fiber.so
    3 rational.so
    4 complex.so
    5 ruby2_keywords.rb
    6 /usr/local/lib/ruby/3.4.0/x86_64-linux-musl/enc/encdb.so
    7 /usr/local/lib/ruby/3.4.0/x86_64-linux-musl/enc/trans/transdb.so
    8 /usr/local/lib/ruby/3.4.0/x86_64-linux-musl/rbconfig.rb
    9 /usr/local/lib/ruby/3.4.0/rubygems/compatibility.rb
   10 /usr/local/lib/ruby/3.4.0/rubygems/defaults.rb
   11 /usr/local/lib/ruby/3.4.0/rubygems/deprecate.rb
   12 /usr/local/lib/ruby/3.4.0/rubygems/errors.rb
   13 /usr/local/lib/ruby/3.4.0/rubygems/target_rbconfig.rb
   14 /usr/local/lib/ruby/3.4.0/rubygems/unknown_command_spell_checker.rb
   15 /usr/local/lib/ruby/3.4.0/rubygems/exceptions.rb
   16 /usr/local/lib/ruby/3.4.0/rubygems/basic_specification.rb
   17 /usr/local/lib/ruby/3.4.0/rubygems/stub_specification.rb
   18 /usr/local/lib/ruby/3.4.0/rubygems/platform.rb
   19 /usr/local/lib/ruby/3.4.0/rubygems/specification_record.rb
   20 /usr/local/lib/ruby/3.4.0/rubygems/util/list.rb
   21 /usr/local/lib/ruby/3.4.0/rubygems/version.rb
   22 /usr/local/lib/ruby/3.4.0/rubygems/requirement.rb
   23 /usr/local/lib/ruby/3.4.0/rubygems/specification.rb
SEGV received in SEGV handler
   24 /usr/local/lib/ruby/3.4.0/rubygems/util.rb
   25 /usr/local/lib/ruby/3.4.0/rubygems/dependency.rb
   26 /usr/local/lib/ruby/3.4.0/rubygems/core_ext/kernel_gem.rb
   27 /usr/local/lib/ruby/3.4.0/x86_64-linux-musl/monitor.so
   28 /usr/local/lib/ruby/3.4.0/monitor.rb
   29 /usr/local/lib/ruby/3.4.0/rubygems.rb
   30 /usr/local/lib/ruby/3.4.0/bundled_gems.rb
   31 /usr/local/lib/ruby/3.4.0/rubygems/path_support.rb
Aborted
74a63f60df20:/app# 
```