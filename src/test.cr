#!/usr/bin/env crystal

require "json"
require "tap"

require "./lru-cache"

##======================================================================================================================

# example class, which must implement method `#bytesize`
class TestCacheItem
	property text : String
	
	def initialize (@text)
	end
	def bytesize
		text.bytesize
	end
end

Tap.test "lru-cache" do |t|
	
	t.test "basic" do |t|
		
		cache = LRUCache(TestCacheItem).new
		
		a= TestCacheItem.new "Alpha"
		cache.set "a", a
		
		# existing key
		t.eq cache.get("a"), a
		t.eq cache.get!("a"), a
		
		# non-existing key
		t.is_nil cache.get("b")
		t.raises "key not found" { cache.get!("b") }
	end
	
	t.test "max_items" do |t|
		
		cache = LRUCache(TestCacheItem).new max_items: 3
		
		a = TestCacheItem.new "Alpha"
		b = TestCacheItem.new "Beta"
		g = TestCacheItem.new "Gamma"
		d = TestCacheItem.new "Delta"
		
		cache.set "a", a
		cache.set "b", b
		cache.set "g", g
		t.eq cache.keys, ["a","b","g"]
		
		# adding a 4th key causes the LRU item to be removed
		cache.set "d", d
		t.eq cache.keys, ["b","g","d"]
		
		cache = LRUCache(TestCacheItem).new max_items: 3
		
		cache.set "a", a
		cache.set "b", b
		cache.set "g", g
		t.eq cache.keys, ["a","b","g"]
		
		# access key "a", causing it to be moved to the end
		cache.get "a"
		t.eq cache.keys, ["b","g","a"]
		
		# adding a 4th key causes the LRU item to be removed
		cache.set "d", d
		t.eq cache.keys, ["g","a","d"]
	end
	
	t.test "max_bytes" do |t|
		
		cache = LRUCache(TestCacheItem).new max_bytes: 18
		
		a = TestCacheItem.new "Alpha"
		b = TestCacheItem.new "Beta"
		g = TestCacheItem.new "Gamma"
		d = TestCacheItem.new "Delta"
		
		cache.set "a", a
		cache.set "b", b
		cache.set "g", g
		t.eq cache.keys, ["a","b","g"]
		
		# adding a 4th key causes the LRU item to be removed
		cache.set "d", d
		t.eq cache.keys, ["b","g","d"]
		
		cache = LRUCache(TestCacheItem).new max_bytes: 18
		
		cache.set "a", a
		cache.set "b", b
		cache.set "g", g
		t.eq cache.keys, ["a","b","g"]
		
		# access key "a", causing it to be moved to the end
		cache.get "a"
		t.eq cache.keys, ["b","g","a"]
		
		# adding a 4th key causes the LRU item to be removed
		cache.set "d", d
		t.eq cache.keys, ["g","a","d"]
	end
end
