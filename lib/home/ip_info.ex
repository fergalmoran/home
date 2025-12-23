defmodule Home.IpInfo do
  @moduledoc """
  Service to fetch IP geolocation information from ipinfo.io
  """

  @localhost_ips ["127.0.0.1", "::1", "localhost"]

  @doc """
  Fetches IP information from ipinfo.io.
  Returns a map with ip, city, region, country, loc, org, postal, timezone.
  For localhost IPs, fetches the server's public IP info instead.
  """
  def fetch(ip) when ip in @localhost_ips do
    # For localhost, fetch info based on server's public IP
    fetch_public()
  end

  def fetch(ip) do
    url = "https://ipinfo.io/#{ip}/json"

    case Finch.build(:get, url) |> Finch.request(Home.Finch) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} -> {:ok, normalize_response(data)}
          {:error, _} -> {:error, :invalid_json}
        end

      {:ok, %Finch.Response{status: status}} ->
        {:error, {:http_error, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Fetches IP information for the server's public IP.
  """
  def fetch_public do
    url = "https://ipinfo.io/json"

    case Finch.build(:get, url) |> Finch.request(Home.Finch) do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} -> {:ok, normalize_response(data)}
          {:error, _} -> {:error, :invalid_json}
        end

      {:ok, %Finch.Response{status: status}} ->
        {:error, {:http_error, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Fetches IP information, returning default values on error.
  """
  def fetch!(ip) do
    case fetch(ip) do
      {:ok, data} -> data
      {:error, _} -> default_response(ip)
    end
  end

  defp normalize_response(data) do
    %{
      ip: data["ip"],
      city: data["city"],
      region: data["region"],
      country: data["country"],
      loc: data["loc"],
      org: data["org"],
      postal: data["postal"],
      timezone: data["timezone"]
    }
  end

  defp default_response(ip) do
    %{
      ip: ip,
      city: nil,
      region: nil,
      country: nil,
      loc: nil,
      org: nil,
      postal: nil,
      timezone: nil
    }
  end
end
