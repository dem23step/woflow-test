#!/usr/bin/env ruby

require 'net/http'
require 'json'

def fetch_nodes(ids)
  JSON.parse(Net::HTTP.get(URI("https://nodes-on-nodes-challenge.herokuapp.com/nodes/#{ids.join(',')}")))
end

def traverse(result, nodes)
  puts "Current result: #{result}"
  nodes.each do |node|
    puts "Current node: #{node}"
    id, child_nodes_ids = node['id'], node['child_node_ids']

    result[id] ||= 0
    result[id] += 1

    next if child_nodes_ids.empty?

    traverse(result, fetch_nodes(child_nodes_ids))
  end
end

result = {}
traverse(result, fetch_nodes(['089ef556-dfff-4ff2-9733-654645be56fe']))
puts "Final result: #{result}"

puts "Q: What is the total number of unique nodes?"
puts "A: #{result.size}."

most_shared_node_id = ''
most_shared_node_count = 0

result.each do |node_id, share_count|
  next unless most_shared_node_count < share_count

  most_shared_node_id = node_id
  most_shared_node_count = share_count
end

puts "Q: Which node ID is shared the most among all other nodes?"
puts "A: Node id is #{most_shared_node_id} which is shared #{most_shared_node_count} times"
