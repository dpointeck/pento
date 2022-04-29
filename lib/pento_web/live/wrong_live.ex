defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def handle_event("guess",%{"number" => guess}, socket) do
    time = time()
    guess = String.to_integer(guess)
    random_number = socket.assigns.random_number

    message =
      if random_number == guess do
        "Your guess: #{guess}. Right."
      else
        "Your guess: #{guess}. Wrong. Guess again."
      end

    score =
      if guess == random_number do
        socket.assigns.score + 1
      else
        if socket.assigns.score > 0 do
          socket.assigns.score - 1
        else
          socket.assigns.score
        end
      end
    {
      :noreply,
      assign(
        socket,
        time: time,
        message: message,
        score: score,
        guess: guess
      )
    }
  end

  def mount(_params, _session, socket) do
    random_number = Enum.random(1..10)

    {:ok,
     assign(socket, time: time(), message: "Make a guess:", score: 0, random_number: random_number, guess: -1)}
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center mt-12">
      <h1 class="text-5xl font-black">Your score: <%= @score %></h1>
      <h2>Random Number: <%= @random_number %></h2>
      <h2 class= "mt-6 text-3xl">
        <%= @message %>
        It's <%= @time %>
      </h2>
      <h2>
        <span>guess: <%= @guess %></span>
        <div class="flex gap-4 mt-4">
          <%= if @random_number != @guess do %>
            <%= for n <- 1..10 do %>
              <a class="h-[40px] w-[40px] flex items-center justify-center rounded bg-gray-100 transition-colors hover:bg-gray-50" href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
            <% end %>
          <% else %>
            <button>Reset</button>
          <% end %>
        </div>
      </h2>
    </div>
    """
  end
end
