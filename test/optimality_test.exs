Code.require_file "../test_helper.exs", __FILE__ 

defmodule OptimalityTest do
  use ExUnit.Case

  import POptimize.Optimality

  test "diff_vector subtracts values elementwise" do
    assert diff_vectors([1.0], [0.5]) == [0.5]
    assert diff_vectors([1.0, 2.0], [0.5, 1.0]) == [0.5, 1.0]
  end

  test "elementwise_comparison_counts works with single-element lists" do
    assert elementwise_comparison_counts([1], [0]) == {0, 0, 1}
    assert elementwise_comparison_counts([0], [1]) == {1, 0, 0}
    assert elementwise_comparison_counts([1], [1]) == {0, 1, 0}
  end

  test "elementwise_comparison_counts works with two-element lists" do
    assert elementwise_comparison_counts([1, 1], [0, 0]) == {0, 0, 2}
    assert elementwise_comparison_counts([0, 0], [1, 1]) == {2, 0, 0}
    assert elementwise_comparison_counts([1, 1], [1, 1]) == {0, 2, 0}

    assert elementwise_comparison_counts([1, 0], [1, 1]) == {1, 1, 0}
    assert elementwise_comparison_counts([0, 1], [1, 1]) == {1, 1, 0}

    assert elementwise_comparison_counts([1, 1], [1, 0]) == {0, 1, 1}
    assert elementwise_comparison_counts([1, 1], [0, 1]) == {0, 1, 1}

    assert elementwise_comparison_counts([1, 0], [0, 1]) == {1, 0, 1}
    assert elementwise_comparison_counts([0, 1], [1, 0]) == {1, 0, 1}
  end

  test "pareto optimal comparison finds optimal vector when it is 1st arg" do 
    assert pareto_compare([1.0], [2.0])           == -1
    assert pareto_compare([1.0, 2.0], [2.0, 2.1]) == -1
    assert pareto_compare([2.0, 1.0], [2.1, 1.1]) == -1

    assert pareto_compare([1.0, 2.0], [2.0, 2.0]) == -1
  end 

  test "pareto optimal comparison finds optimal vector when it is 2nd arg" do 
    assert pareto_compare([20.0], [10.0])           == 1
    assert pareto_compare([1.0, 2.0], [-2.0, 1.0])  == 1 
    assert pareto_compare([-2.0, 1.0], [-2.1, 0.9]) == 1

    assert pareto_compare([1.0, 2.0], [0.0, 2.0])   == 1
  end 
end