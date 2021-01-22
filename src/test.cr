#!/usr/bin/env crystal

require "tap"

require "./lru-cache"

##======================================================================================================================

Tap.test "lru-cache" do |t|
	
	t.test "basic" do |t|
		
		cache = LRUCache.new
		
		cache.set "a", {"val" => "Alpha"}
		
		# existing key
		t.eq cache.get("a"), {"val" => "Alpha"}
		t.eq cache.get!("a"), {"val" => "Alpha"}
		
		# non-existing key
		t.is_nil cache.get("b")
		t.raises "key not found" { cache.get!("b") }
	end
	
	t.test "max_items" do |t|
		
		cache = LRUCache.new max_items: 3
		
		cache.set "a", {"val" => "Alpha"}
		cache.set "b", {"val" => "Beta"}
		cache.set "g", {"val" => "Gamma"}
		t.eq cache.keys, ["a","b","g"]
		
		# adding a 4th key causes the LRU item to be removed
		cache.set "d", {"val" => "Delta"}
		t.eq cache.keys, ["b","g","d"]
		
		cache = LRUCache.new max_items: 3
		
		cache.set "a", {"val" => "Alpha"}
		cache.set "b", {"val" => "Beta"}
		cache.set "g", {"val" => "Gamma"}
		t.eq cache.keys, ["a","b","g"]
		
		# access key "a", causing it to be moved to the end
		cache.get "a"
		t.eq cache.keys, ["b","g","a"]
		
		# adding a 4th key causes the LRU item to be removed
		cache.set "d", {"val" => "Delta"}
		t.eq cache.keys, ["g","a","d"]
	end
	
	t.test "max_bytes" do |t|
		
		cache = LRUCache.new max_bytes: 24
		
		cache.set "a", {"val" => "Alpha"}
		cache.set "b", {"val" => "Beta"}
		cache.set "g", {"val" => "Gamma"}
		t.eq cache.keys, ["a","b","g"]
		
		# adding a 4th key causes the LRU item to be removed
		cache.set "d", {"val" => "Delta"}
		t.eq cache.keys, ["b","g","d"]
		
		cache = LRUCache.new max_bytes: 24
		
		cache.set "a", {"val" => "Alpha"}
		cache.set "b", {"val" => "Beta"}
		cache.set "g", {"val" => "Gamma"}
		t.eq cache.keys, ["a","b","g"]
		
		# access key "a", causing it to be moved to the end
		cache.get "a"
		t.eq cache.keys, ["b","g","a"]
		
		# adding a 4th key causes the LRU item to be removed
		cache.set "d", {"val" => "Delta"}
		t.eq cache.keys, ["g","a","d"]
	end
end
