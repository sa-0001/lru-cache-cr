# lru-cache

A simple LRU (least-recently-used) which allows you to define the max. number of items in the hash, or the max size of the items in the hash (by bytesize of the string key and value).  When a new cache item is added, and the items/bytes are exceeded, the cache item which was least recently used (by either `get` or `set`) is deleted.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  lru-cache:
    github: sa-0001/lru-cache-cr
```

## Usage & Examples

```crystal
require "lru-cache"

# limit to X items
cache = LRUCache.new max_items: 10

# limit of X bytes
cache = LRUCache.new max_bytes: 1e9

# key is a String, and val is any class which implements method #bytesize
cache.set "key", %({"a":"b","c":"d"})

# check if key exists
cache.has? "key"

# returns nil if key not found
val = cache.get "key"

# raises exception if key not found
val = cache.get! "key"
```
