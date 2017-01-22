# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :exploy, :localhost,
  host: 'localhost',
  port: 22,
  options: [
    silently_accept_hosts: true,
    user_interaction: false,

    disconnectfun: fn(reason) -> IO.inspect(reason) end,
    unexpectedfun: fn(message, peer) -> IO.inspect(message, peer) end,
    ssh_msg_debug_fun: fn(_, _, message, _) -> IO.inspect(message) end
  ],
  deploy_path: '~/'
