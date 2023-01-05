defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  alias Pento.Accounts

  def mount(_params, session, socket) do
    {
      :ok, 
    assign(socket, score: 0,
    message: "Make a guess: ", 
    answer: Enum.random(1..10), 
    session_id: session["live_socket_id"])
    }
  end

  def render(assigns) do
    ~H"""
    <h1>Your Score: <%= @score %></h1>
    <h2>
      <%= @message %> 
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
      <% end %>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess} = data, socket) do
    {message, answer, score} = results((String.to_integer(guess) == socket.assigns.answer), guess, socket)

    {:noreply, assign(socket, message: message, score: score, current_time: time, answer: answer)}
  end

  defp time() do
    DateTime.utc_now |> to_string
  end

  defp results(false, guess, socket) do
    {"Your guess: #{guess} is wrong. Guess again.", socket.assigns.answer, socket.assigns.score - 1}
  end

  defp results(true, guess, socket) do
     {"Correct! The number is reset, so try again.", Enum.random(1..10), 0}
  end
end