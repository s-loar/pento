defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess: ", answer: Enum.random(1..10), current_time: time())}
  end

  def render(assigns) do
    ~H"""
    <h1>Your Score: <%= @score %></h1>
    <h2>
      <%= @message %> 
      <p>It's <%= @current_time %></p>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
      <% end %>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess} = data, socket) do
    message = "Your guess: #{guess}. " <> if (String.to_integer(guess) == socket.assigns.answer), do: "Correct! The number is reset, so try again.", else: "Wrong. Guess again."
    score = if (String.to_integer(guess) == socket.assigns.answer), do: socket.assigns.score + 1, else: socket.assigns.score - 1
    answer = if (String.to_integer(guess) == socket.assigns.answer), do:  Enum.random(1..10), else: socket.assigns.answer
    current_time = time()

    {:noreply, assign(socket, message: message, score: score, current_time: current_time, answer: answer)}
  end

  defp time() do
    DateTime.utc_now |> to_string
  end
end