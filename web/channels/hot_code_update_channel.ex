defmodule LivecodingWorkspace.HotCodeUpdateChannel do
  use Phoenix.Channel

  @env Mix.env
  def join(_channel, _message, socket) do
    if @env == :dev do
      Application.ensure_started(:fs)
      :fs.subscribe()
    end

    {:ok, socket}
  end

  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, socket) do
    if String.contains?(List.to_string(path), "live_update.js") do
      broadcast! socket, "updated_code", %{ source: File.read!(path) }
    end

    {:noreply, socket}
  end
end
