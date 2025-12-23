defmodule HomeWeb.Components.PasswordGenerator do
  @moduledoc """
  Component to generate random passwords with configurable options.
  """
  use HomeWeb.Component

  import HomeWeb.Components.Card
  import HomeWeb.Components.Button
  import HomeWeb.Components.Slider
  import HomeWeb.Components.Checkbox

  attr :class, :string, default: nil

  def password_generator(assigns) do
    ~H"""
    <.card class={classes(["w-full", @class])} id="password-generator" phx-hook="PasswordGenerator">
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
              <rect width="18" height="11" x="3" y="11" rx="2" ry="2" />
              <path d="M7 11V7a5 5 0 0 1 10 0v4" />
            </svg>
            Password Generator
          </.card_title>
          <.button variant="ghost" size="sm" class="h-7 px-2 text-xs" data-password-regenerate>
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
              <path d="M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8" />
              <path d="M3 3v5h5" />
              <path d="M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16" />
              <path d="M16 16h5v5" />
            </svg>
            Generate
          </.button>
        </div>
        <.card_description>
          Generate secure random passwords
        </.card_description>
      </.card_header>
      <.card_content>
        <div class="space-y-4">
          <%!-- Password output --%>
          <div class="flex items-center gap-2">
            <div
              class="flex-1 px-3 py-2 rounded-md bg-muted font-mono text-sm break-all min-h-[40px] flex items-center"
              data-password-output
            >
              <span class="text-muted-foreground">Click generate...</span>
            </div>
            <.button variant="outline" size="icon" class="shrink-0" data-password-copy>
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
              >
                <rect width="14" height="14" x="8" y="8" rx="2" ry="2" />
                <path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2" />
              </svg>
              <span class="sr-only">Copy password</span>
            </.button>
          </div>

          <%!-- Length slider --%>
          <div class="space-y-2">
            <div class="flex items-center justify-between">
              <label class="text-xs text-muted-foreground">Length</label>
              <span
                class="text-xs font-mono bg-muted px-2 py-0.5 rounded"
                data-password-length-display
              >
                16
              </span>
            </div>
            <.slider id="password-length" min={8} max={64} step={1} value={16} data-password-length />
          </div>

          <%!-- Character options --%>
          <div class="space-y-2">
            <label class="text-xs text-muted-foreground">Characters</label>
            <div class="grid grid-cols-2 gap-3">
              <label class="flex items-center gap-2 text-sm cursor-pointer">
                <.checkbox name="uppercase" value={true} data-password-option="uppercase" />
                <span>Uppercase (A-Z)</span>
              </label>
              <label class="flex items-center gap-2 text-sm cursor-pointer">
                <.checkbox name="lowercase" value={true} data-password-option="lowercase" />
                <span>Lowercase (a-z)</span>
              </label>
              <label class="flex items-center gap-2 text-sm cursor-pointer">
                <.checkbox name="numbers" value={true} data-password-option="numbers" />
                <span>Numbers (0-9)</span>
              </label>
              <label class="flex items-center gap-2 text-sm cursor-pointer">
                <.checkbox name="symbols" value={true} data-password-option="symbols" />
                <span>Symbols (!@#$)</span>
              </label>
            </div>
          </div>
        </div>
      </.card_content>
    </.card>
    """
  end
end
