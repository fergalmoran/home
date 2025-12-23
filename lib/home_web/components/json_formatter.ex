defmodule HomeWeb.Components.JsonFormatter do
  @moduledoc """
  Component to format and validate JSON strings.
  """
  use HomeWeb.Component

  import HomeWeb.Components.Card
  import HomeWeb.Components.Button

  attr :class, :string, default: nil

  def json_formatter(assigns) do
    ~H"""
    <.card class={classes(["w-full", @class])} id="json-formatter" phx-hook="JsonFormatter">
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
              <path d="M4 22h14a2 2 0 0 0 2-2V7l-5-5H6a2 2 0 0 0-2 2v4" />
              <path d="M14 2v4a2 2 0 0 0 2 2h4" />
              <path d="m5 12-3 3 3 3" />
              <path d="m9 18 3-3-3-3" />
            </svg>
            JSON Formatter
          </.card_title>
          <div class="flex items-center gap-2">
            <.button variant="ghost" size="sm" class="h-7 px-2 text-xs" data-json-clear>
              Clear
            </.button>
            <.button variant="ghost" size="sm" class="h-7 px-2 text-xs" data-json-format>
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
                class="mr-1"
              >
                <path d="M12 3v6" />
                <circle cx="12" cy="12" r="1" />
                <path d="M12 15v6" />
                <path d="M3 12h6" />
                <path d="M15 12h6" />
              </svg>
              Format
            </.button>
          </div>
        </div>
        <.card_description>
          Paste JSON to validate and format with proper indentation
        </.card_description>
      </.card_header>
      <.card_content>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="space-y-2">
            <label class="text-xs text-muted-foreground">Input</label>
            <textarea
              class="flex min-h-[200px] w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 font-mono resize-y"
              placeholder='{"example": "Paste your JSON here..."}'
              spellcheck="false"
              data-json-input
            ></textarea>
          </div>
          <div class="space-y-2">
            <div class="flex items-center justify-between">
              <label class="text-xs text-muted-foreground">Formatted Output</label>
              <.button variant="ghost" size="sm" class="h-6 px-2 text-xs" data-json-copy>
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
              class="min-h-[200px] w-full rounded-md border border-input bg-muted px-3 py-2 text-sm font-mono overflow-auto whitespace-pre-wrap break-all"
              data-json-output
            >
              <span class="text-muted-foreground">Formatted JSON will appear here...</span>
            </div>
          </div>
        </div>
        <div class="mt-3 text-xs text-destructive hidden" data-json-error></div>
        <div class="mt-3 text-xs text-green-600 dark:text-green-400 hidden" data-json-success>
          ✓ Valid JSON
        </div>
      </.card_content>
    </.card>
    """
  end
end
