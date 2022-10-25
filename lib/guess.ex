defmodule Guess do
  use Application

  def start(_,_) do
    run()
    {:ok,self()}
  end

  def run() do 
    IO.puts("Let's play Guess the number\n")

    IO.gets("Pick a difficult game level (1,2 or 3):")
    |> parser_input()
    |> pickup_number()
    |> play()
  end

  def play(pickup_num) do
    IO.gets("I have my number. What is your guess?\n")
    |> parser_input()
    |> guess(pickup_num, 1)
  end

  def guess(usr_guess, pickup_num, count) when usr_guess > pickup_num do
    IO.gets("Too high. Guess again:\t")
    |> parser_input()
    |> guess(pickup_num, count+ 1)
  end

  def guess(usr_guess, pickup_num, count) when usr_guess < pickup_num do
    IO.gets("Too low. Guess again:\t")
    |> parser_input()
    |> guess(pickup_num, count+ 1)
  end

  def guess(_usr_guess, _pickup_num, count) do
    IO.puts("You got it #{count} guess")
    show_score(count)
  end

  def show_score(guesses) when guesses > 6 do
    IO.puts("Better luck next time")
  end

  def show_score(guesses) do
    {_, msg} = %{1..1 => "You're a mind rider",
      2..4 => "Most impresive",
      3..6 => "You can do better than that"}
    |> Enum.find(fn {range, _} ->
      Enum.member?(range, guesses) 
    end)
    IO.puts(msg)
  end

  def parser_input(:error) do
    IO.puts("Invalid input!!!")
    run()
  end

  def parser_input({num, _}), do: num

  def parser_input(data) do
    data
    |> Integer.parse()
    |> parser_input()
  end 

  def pickup_number(level) do
    level
    |> range()
    |> Enum.random()
  end

  def range(level) do
    case level do
      1 -> 1..10
      2 -> 1..100
      3 -> 1..1000
      _ -> IO.puts("Invalid level!!!")
      run()
    end
  end
end
