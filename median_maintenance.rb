require 'algorithms'
require 'thread'
require 'pry'

input_queue = Queue.new

file_content = File.open("./Median.txt", "r").each_line do |line|
  input_queue.enq line.to_i
end

medians = []

heap_low = Containers::MaxHeap.new
heap_high = Containers::MinHeap.new

def current_median(high, low)
  case
  when high.size > low.size
    high.min
  else
    low.max
  end
end

def balanced_insert(item, low, high)
  if low.size == 0 && high.size == 0
    high.push(item)
    return
  end

  if item > high.min
    high.push(item)
  else
    low.push(item)
  end

  rebalance_trees(low, high)
end

def rebalance_trees(low, high)
  size_difference = (low.size - high.size).abs

  if size_difference > 1
    low.size > high.size ? high.push(low.max!) : low.push(high.min!)
  end
end

while input_queue.size > 0
  input_item = input_queue.deq

  balanced_insert(input_item, heap_low, heap_high)

  medians << current_median(heap_high, heap_low)
end

sum_mod_10000 = medians.inject(:+) % 10000

# puts medians.to_s
puts "The sum of the medians mod 10000 is #{sum_mod_10000}"
