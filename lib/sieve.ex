defmodule Sieve do
  @moduledoc """
  Module to generate sieve and print out prime numbers
  according to Eratosthene's Prime Sieve Algorithm
  """

  @first_prime 2

  def run(limit) when is_integer(limit) and limit >= @first_prime do
    # Generate the sieve
    sieve = primes(limit)

    # Print out primes in sieve
    sieve
    |> Map.to_list
    |> Enum.sort
    |> Enum.each(fn {i, val} -> if val == true, do: :io.format("~w ", [i]) end)
  end


  defp primes(limit) when is_integer(limit) and limit >= @first_prime do

    # Create primality flag list starting at index 0
    list = List.flatten([false, false], 
                        @first_prime..limit |> Enum.map(fn _ -> true end))

    # Create a sieve in map form, maps work well for large entries
    sieve = list |> Stream.with_index(0) |> Map.new(fn {v,i} -> {i,v} end)

    # Generate indices only to the sqrt of limit.
    # Given limit of 100, indices are to 10
    indices = @first_prime..(Kernel.round(:math.sqrt(limit)))

    # Given indices, flag those that are not prime
    Enum.reduce(indices, sieve, fn i, acc ->
      case Map.get(acc, i) do
        false -> 
          acc
        true -> 
          # 1: generate list of multiples starting at the square of the index, 
          # step every i, to the limit
          non_primes = 
            Stream.iterate(i*i, &(&1 + i)) 
            |> Enum.take_while(&(&1 <= limit))
        
          # 2: Update the sieve acc for each list of non_primes as generated from each i
          Enum.reduce(non_primes, acc, fn i, map ->
            Map.put(map, i, false) # index i not prime
          end)
      end
    end)

  end

end


# Sieve.run(100)
