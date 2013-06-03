defmodule POptimize.Optimality do
  @moduledoc """
  Compare vectors of objective values to judge different forms of optimality
  and preference.
  """

  @doc """
  Return a list with the elementwise difference of values in the two lists.
  """
  def diff_vectors(l1, l2) do
    Enum.map Enum.zip(l1, l2), fn {v1, v2} -> (v1 - v2) end
  end

  defp elementwise_comparison_counts_with_diffvector(diffVector, epsilon // 0.0) do
    Enum.reduce diffVector, {0,0,0}, fn(diff, {l1,s,l2}) ->
      cond do
        diff < (-epsilon) -> {l1+1, s,   l2}
        diff > epsilon    -> {l1  , s,   l2+1}
        true              -> {l1  , s+1, l2}
      end
    end
  end

  @doc """
  Count the number of positions where the 1st list has the lowest values,
  the values are equal and where the 2nd list has the lowest values.

  Returns a tuple of these three counts {numLowest1st, numSame, numLowest2nd}
  """
  def elementwise_comparison_counts(l1, l2, epsilon // 0.0) do
    elementwise_comparison_counts_with_diffvector diff_vectors(l1, l2), epsilon
  end

  @doc """
  Compare two vectors of objective values and indicate which is pareto optimal.

  Return -1 if the 1st is pareto optimal, 1 if the 2nd is pareto optimal, and
  returns 0 if none are pareto optimal.

  We assume minimization, i.e. an objective value is better if it is lower. If
  epsilon value is given one objective value needs to be at least epsilon
  lower for the comparison to count towards (epsilon-)optimality.
  """
  def pareto_compare(objectives1, objectives2, epsilon // 0.0) do
    {l1, _, l2} = elementwise_comparison_counts objectives1, objectives2, epsilon
    cond do
      l2 == 0 and l1 > 0  -> -1
      l1 == 0 and l2 > 0  -> 1
      true                -> 0
    end
  end
end