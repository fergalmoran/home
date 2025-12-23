defmodule HomeWeb.Components.IpAddress do
  @moduledoc """
  Component to display the visitor's IP address and geolocation info.
  """
  use HomeWeb.Component

  import HomeWeb.Components.Card
  import HomeWeb.Components.Button

  attr :ip_info, :map,
    required: true,
    doc: "Map containing IP info (ip, city, region, country, etc.)"

  attr :class, :string, default: nil

  def ip_address(assigns) do
    ~H"""
    <.card class={classes(["w-full", @class])}>
      <.card_header class="pb-3">
        <div class="flex items-center justify-between">
          <.card_title class="flex items-center gap-2 text-sm font-medium">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="opacity-70"
            >
              <circle cx="12" cy="12" r="10" />
              <path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20" />
              <path d="M2 12h20" />
            </svg>
            Your Location
          </.card_title>
          <.button
            variant="ghost"
            size="icon"
            class="h-8 w-8"
            phx-click={copy_to_clipboard(@ip_info.ip)}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="14"
              height="14"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <rect width="14" height="14" x="8" y="8" rx="2" ry="2" />
              <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2" />
            </svg>
            <span class="sr-only">Copy IP address</span>
          </.button>
        </div>
        <.card_description>
          <code class="font-mono text-xs">{@ip_info.ip}</code>
        </.card_description>
      </.card_header>
      <.card_content>
        <dl class="grid grid-cols-2 gap-x-4 gap-y-2 text-sm">
          <.info_row :if={@ip_info.city} label="City" value={@ip_info.city} />
          <.info_row :if={@ip_info.region} label="Region" value={@ip_info.region} />
          <.info_row :if={@ip_info.country} label="Country" value={@ip_info.country} />
          <.info_row :if={@ip_info.postal} label="Postal" value={@ip_info.postal} />
          <.info_row :if={@ip_info.timezone} label="Timezone" value={@ip_info.timezone} />
          <.info_row :if={@ip_info.loc} label="Coordinates" value={@ip_info.loc} />
          <div :if={@ip_info.org} class="col-span-2 pt-2 border-t border-border mt-2">
            <dt class="text-muted-foreground text-xs">Organization</dt>
            <dd class="font-medium text-xs mt-0.5 truncate" title={@ip_info.org}>{@ip_info.org}</dd>
          </div>
        </dl>
      </.card_content>
    </.card>
    """
  end

  attr :label, :string, required: true
  attr :value, :string, required: true

  defp info_row(assigns) do
    ~H"""
    <div>
      <dt class="text-muted-foreground text-xs">{@label}</dt>
      <dd class="font-medium">{@value}</dd>
    </div>
    """
  end

  defp copy_to_clipboard(text) do
    JS.dispatch("phx:copy", detail: %{text: text})
  end
end
