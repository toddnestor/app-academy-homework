require 'byebug'
class Array

  # Monkey patch the Array class and add a my_inject method. If my_inject receives
  # no argument, then use the first element of the array as the default accumulator.

  def my_inject!(accumulator = nil, &prc)
    accumulator ||= shift

    each {|el| accumulator = prc.call(accumulator, el)}
    accumulator
  end

  def my_inject(accumulator = nil, &prc)
    self.dup.my_inject!(accumulator, &prc)
  end
end

# primes(num) returns an array of the first "num" primes.
# You may wish to use an is_prime? helper method.

def is_prime?(num)
  return true if num == 2
  (2..(num ** 0.5)).each {|f| return false if num % f == 0}
end

def primes(num)
  nums = []

  maybe_prime = 2
  until nums.length == num
    nums << maybe_prime if is_prime?(maybe_prime)
    maybe_prime += (maybe_prime == 2 ? 1 : 2 )
  end

  nums
end

# Write a recursive method that returns the first "num" factorial numbers.
# Note that the 1st factorial number is 0!, which equals 1. The 2nd factorial
# is 1!, the 3rd factorial is 2!, etc.

def factorials_rec(num)
  return [1,1].take(num) if num < 3

  factorials = factorials_rec(num-1)
  factorials << factorials.last * (num-1)
end

class Array

  # Write an Array#dups method that will return a hash containing the indices of all
  # duplicate elements. The keys are the duplicate elements; the values are
  # arrays of their indices in ascending order, e.g.
  # [1, 3, 4, 3, 0, 3, 0].dups => { 3 => [1, 3, 5], 0 => [4, 6] }

  def dups
    each_with_index.inject(Hash.new{Array.new}) do |hash, (el, i)|
      hash[el] = hash[el] << i if count(el) > 1
      hash
    end
  end
end

class String

  # Write a String#symmetric_substrings method that returns an array of substrings
  # that are palindromes, e.g. "cool".symmetric_substrings => ["oo"]
  # Only include substrings of length > 1.

  def symmetric_substrings
    subs = []

    (0..length).each do |start|
      (2..length - start).each do |sub_length|
        new_sub = self[start, sub_length]
        subs << new_sub if new_sub.is_palindrome?
      end
    end

    subs
  end

  def is_palindrome?
    self == self.reverse
  end
end

class Array

  # Write an Array#merge_sort method; it should not modify the original array.

  def merge_sort(&prc)
    return self if length <=1

    left = take(length/2)
    right = drop(left.length)

    Array.merge(left.merge_sort(&prc), right.merge_sort(&prc), &prc)
  end

  private
  def self.merge(left, right, &prc)
    return left if right.empty?
    return right if left.empty?

    prc ||= Proc.new {|a,b| a <=> b}

    Array.first_for_merge(left, right, &prc) + Array.merge(left, right, &prc)
  end

  def self.first_for_merge(left, right, &prc)
    [(prc.call(left, right) < 0 ? left.shift : right.shift)]
  end
end
