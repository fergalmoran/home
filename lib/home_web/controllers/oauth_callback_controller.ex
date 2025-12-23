defmodule HomeWeb.OAuthCallbackController do
  @moduledoc """
  Handles OAuth callbacks from providers like GitHub and Google.
  """
  use HomeWeb, :controller

  alias Home.Accounts
  alias HomeWeb.UserAuth

  plug Ueberauth

  @doc """
  Handles the OAuth callback after successful authentication.
  """
  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_attrs = extract_user_info(auth)

    case Accounts.find_or_create_oauth_user(user_attrs) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated with #{provider_name(auth.provider)}.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        errors = format_changeset_errors(changeset)

        conn
        |> put_flash(:error, "Could not authenticate. #{errors}")
        |> redirect(to: ~p"/users/log_in")
    end
  end

  # Handles OAuth failure.
  def callback(%{assigns: %{ueberauth_failure: failure}} = conn, _params) do
    message = extract_failure_message(failure)

    conn
    |> put_flash(:error, "Authentication failed: #{message}")
    |> redirect(to: ~p"/users/log_in")
  end

  # Extract user info from different providers
  defp extract_user_info(%{provider: :github, info: info, uid: uid}) do
    %{
      email: info.email,
      name: info.name || info.nickname,
      avatar_url: info.image,
      provider: :github,
      provider_id: to_string(uid)
    }
  end

  defp extract_user_info(%{provider: :google, info: info, uid: uid}) do
    %{
      email: info.email,
      name: info.name,
      avatar_url: info.image,
      provider: :google,
      provider_id: to_string(uid)
    }
  end

  defp extract_user_info(%{provider: provider, info: info, uid: uid}) do
    %{
      email: info.email,
      name: info.name,
      avatar_url: info.image,
      provider: provider,
      provider_id: to_string(uid)
    }
  end

  defp provider_name(:github), do: "GitHub"
  defp provider_name(:google), do: "Google"
  defp provider_name(provider), do: to_string(provider) |> String.capitalize()

  defp extract_failure_message(%{errors: errors}) do
    errors
    |> Enum.map(fn error -> Map.get(error, :message, "Unknown error") end)
    |> Enum.join(", ")
  end

  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {field, errors} -> "#{field}: #{Enum.join(errors, ", ")}" end)
    |> Enum.join("; ")
  end
end
