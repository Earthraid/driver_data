# DriverData

## Installation
User must have Erlang installed to properly run this application
Download and installation instructions can be found at https://www.erlang.org/downloads

## How To
1. unarchive .tgz
2. run `cd driver_data`
3. run `mix escript.build`
4. run `./driver_data <` followed by the path to desired input file. 
Example command with input.txt and driver_data.tgz in the same dir: `tar -xvzf driver_data.tgz && cd driver_data && mix escript.build && ./driver_data < ../input.txt`

```elixir
def deps do
  [
    {:driver_data, "~> 0.1.0"}
  ]
end
```

## The explanation
I built this with the thought process it may need to process 10, 100, or 10 billion records. With that in mind I tried to process the file with as few list iterations as I could.
Using maps to pass between functions can decrease the likelyhood of misordered variables and slightly decrease 
complexity.
The majority of my functions are private which is a common design pattern. Providing a parent function that wraps the behavior of the private functions helps maintain 
separation of concerns between modules.
Pattern matching is used throughout to ensure data is formatted as the function expects.