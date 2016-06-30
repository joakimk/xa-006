# Compiles shader files into window.Shaders in Javascript.

# Could not get brunch to accept a local plugin and we needed this,
# so I wrote it in Elixir instead.

defmodule LivecodingWorkspace.ShaderCompiler do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    compile_all

    Application.ensure_started(:fs)
    :fs.subscribe()

    {:ok, state}
  end

  def handle_info({_pid, {:fs, :file_event}, {path, _event}}, state) do
    if String.contains?(List.to_string(path), shader_path) do
      compile_all
    end

    {:noreply, state}
  end

  defp compile_all do
    { :ok, shaders } = File.ls(shader_path)

    output = "window.Shaders = {};"

    output = output <> (Enum.map(shaders, fn (shader) -> compile(shader) end) |> Enum.join)

    File.write("web/static/js/shaders.js", output)
  end

  defp compile(path) do
    data = "#{shader_path}/#{path}"
      |> File.read!
      |> Base.encode64

    shader_name = path |> Path.basename |> String.replace(".", "_")
    shader_name = Regex.replace(~r/_(.)/, shader_name, fn _, group -> String.upcase(group) end)

    "window.Shaders.#{shader_name} = atob(\"#{data}\");"
  end

  defp shader_path, do: "web/static/shaders"
end
