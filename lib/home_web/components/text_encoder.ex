defmodule HomeWeb.Components.TextEncoder do
  @moduledoc """
  Component to encode user input strings (HTML or URL encoding).
  """
  use HomeWeb.Component

  import HomeWeb.Components.Card
  import HomeWeb.Components.Button
  import HomeWeb.Components.Switch

  attr :class, :string, default: nil

  def text_encoder(assigns) do
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
              <polyline points="16 18 22 12 16 6" /><polyline points="8 6 2 12 8 18" />
            </svg>
            Text Encoder
          </.card_title>
          <div class="flex items-center gap-2 text-xs">
            <span class="text-muted-foreground" data-mode-label>HTML</span>
            <.switch
              id="encoder-mode-switch"
              class="data-[state=checked]:bg-muted data-[state=unchecked]:bg-muted"
              data-encoder-switch
            />
            <span class="text-muted-foreground">URL</span>
          </div>
        </div>
        <.card_description>
          Encode special characters for HTML or URLs
        </.card_description>
      </.card_header>
      <.card_content>
        <div class="space-y-3" id="text-encoder" phx-hook="TextEncoder">
          <div>
            <label for="encoder-input" class="text-xs text-muted-foreground">Input</label>
            <textarea
              id="encoder-input"
              class="flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 mt-1 font-mono"
              placeholder="Enter text to encode..."
              data-encoder-input
            ></textarea>
          </div>
          <div>
            <div class="flex items-center justify-between">
              <label for="encoder-output" class="text-xs text-muted-foreground">Encoded Output</label>
              <.button variant="ghost" size="sm" class="h-6 px-2 text-xs" data-encoder-copy>
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="12"
                  height="12"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="mr-1"
                >
                  <rect width="14" height="14" x="8" y="8" rx="2" ry="2" />
                  <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2" />
                </svg>
                Copy
              </.button>
            </div>
            <div
              id="encoder-output"
              class="min-h-[80px] w-full rounded-md border border-input bg-muted px-3 py-2 text-sm mt-1 font-mono break-all"
              data-encoder-output
            >
              <span class="text-muted-foreground">Encoded text will appear here...</span>
            </div>
          </div>
        </div>
      </.card_content>
    </.card>
    """
  end
end
