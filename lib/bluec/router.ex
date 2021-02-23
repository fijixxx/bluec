defmodule Bluec.Router do
  use Plug.Router
  use Plug.ErrorHandler

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome to Bluec")
  end

  get "/v1/gb/today" do
    send_resp(conn, 200, Bluec.Fetcher.today())
  end

  get "/v1/gb/now" do
    send_resp(conn, 200, Bluec.Fetcher.now())
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    send_resp(conn, conn.status, "Something went wrong")
  end
end
