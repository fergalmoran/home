defmodule HomeWeb.PageController do
  use HomeWeb, :controller

  def home(conn, _params) do
    ip = conn.remote_ip |> :inet.ntoa() |> to_string()
    ip_info = Home.IpInfo.fetch!(ip)
    render(conn, :home, ip_info: ip_info)
  end
end
