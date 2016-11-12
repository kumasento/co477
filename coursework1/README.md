# Coursework 1

This document describes the modified code and how to run the experiment mentioned in the write up document.

This directory contains 3 different kinds of matlab code:

1. `run_mnist_gradient.m`: This is the main file for doing experiments. It simply calls functions defined in other files and collects data from snapshot data files to show the result in plot and table.
2. `SolveMNIST_Gradient.m`: This is the main modified file for the MNIST gradient descent algorithm.
3. `golden_section_search.m`, `secant.m`, and `backtracking.m`: This files provide high level abstraction for 3 different line search methods. These functions will return minimisers computed by different algorithms.

In order to reproduce the result referred in the write up, here are the instruction:

```matlab
run_mnist_gradient([max_iter], [run]);
```

`max_iter` is the maximum number of iterations you would like to run, and `run` is a boolean indicates whether to re-run gradient descent or not. If `run` is 0, then this function will simply read cached snapshot data in `tmp/`.

An example:

```matlab
run_mnist_gradient(100, 0);   % This will reproduce the experiment when the maximum numer of iterations is 100
run_mnist_gradient(10000, 0); % This will reproduce the final experiment
```
