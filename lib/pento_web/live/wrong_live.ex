defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       score: 0,
       message: "Make a guess:",
       current_time: time(),
       answer: Enum.random(1..10)
     )}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    {message, answer, score} =
      results(String.to_integer(guess) == socket.assigns.answer, guess, socket)

    {:noreply,
     assign(socket, message: message, score: score, current_time: time(), answer: answer)}
  end

  def render(assigns) do
    ~H"""
    <h1>Your Score: <%= @score %></h1>
    <h2>
      <%= @message %> It's <%= @current_time %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <.link href="#" phx-click="guess" phx-value-number={n}>
          <%= n %>
        </.link>
      <% end %>
    </h2>
    """
  end

  defp time() do
    DateTime.utc_now() |> to_string()
  end

  defp results(false, guess, socket) do
    {"Your guess: #{guess} is wrong. Guess again.", socket.assigns.answer,
     socket.assigns.score - 1}
  end

  defp results(true, guess, socket) do
    {"Your guess: #{guess} is correct! The number is reset, so try again.", Enum.random(1..10),
     socket.assigns.score + 1}
  end
end
