defmodule HomeWeb.Components.Header do
  @moduledoc """
  Site header component with responsive navigation.
  """
  use HomeWeb.Component

  import HomeWeb.Components.Button
  import HomeWeb.Components.Sheet
  import HomeWeb.Components.Separator

  use Phoenix.VerifiedRoutes,
    endpoint: HomeWeb.Endpoint,
    router: HomeWeb.Router,
    statics: HomeWeb.static_paths()

  attr :class, :string, default: nil
  attr :current_user, :any, default: nil

  def header(assigns) do
    ~H"""
    <header class={
      classes([
        "sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60",
        @class
      ])
    }>
      <div class="container flex items-center px-4 h-14 sm:px-6 lg:px-8">
        <%!-- Logo --%>
        <div class="flex mr-4">
          <a href="/" class="flex items-center mr-6 space-x-2">
            <img src={~p"/images/logo.svg"} width="32" class="w-8 h-8" />
            <span class="font-bold">fergl.ie</span>
          </a>
        </div>

        <%!-- Desktop Navigation --%>
        <nav class="items-center hidden space-x-6 text-sm font-medium md:flex">
          <a href="/" class="transition-colors hover:text-foreground/80 text-foreground">
            Home
          </a>
          <a href="#" class="transition-colors hover:text-foreground/80 text-foreground/60">
            About
          </a>
          <a href="#" class="transition-colors hover:text-foreground/80 text-foreground/60">
            Contact
          </a>
        </nav>

        <div class="flex items-center justify-end flex-1 space-x-2">
          <%!-- Desktop buttons --%>
          <div class="items-center hidden space-x-2 md:flex">
            <%= if @current_user do %>
              <span class="text-sm text-muted-foreground">{@current_user.email}</span>
              <.link href={~p"/users/settings"}>
                <.button variant="ghost" size="sm">Settings</.button>
              </.link>
              <.link href={~p"/users/log_out"} method="delete">
                <.button variant="outline" size="sm">Log out</.button>
              </.link>
            <% else %>
              <.link href={~p"/users/log_in"}>
                <.button variant="ghost" size="sm">Sign In</.button>
              </.link>
              <.link href={~p"/users/register"}>
                <.button size="sm">Get Started</.button>
              </.link>
            <% end %>
          </div>

          <%!-- Mobile menu --%>
          <div class="md:hidden">
            <.sheet>
              <.sheet_trigger target="mobile-menu">
                <.button variant="ghost" size="icon" class="h-9 w-9">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  >
                    <line x1="4" x2="20" y1="12" y2="12" /><line x1="4" x2="20" y1="6" y2="6" /><line
                      x1="4"
                      x2="20"
                      y1="18"
                      y2="18"
                    />
                  </svg>
                  <span class="sr-only">Toggle menu</span>
                </.button>
              </.sheet_trigger>
              <.sheet_content id="mobile-menu" side="right" class="w-[300px] sm:w-[400px]">
                <nav class="flex flex-col mt-8 space-y-4">
                  <a href="/" class="text-lg font-medium">Home</a>
                  <.separator />
                  <a href="#" class="text-lg font-medium text-muted-foreground">About</a>
                  <.separator />
                  <a href="#" class="text-lg font-medium text-muted-foreground">Contact</a>
                  <.separator />
                  <div class="flex flex-col pt-4 space-y-2">
                    <%= if @current_user do %>
                      <span class="text-sm text-muted-foreground text-center pb-2">
                        {@current_user.email}
                      </span>
                      <.link href={~p"/users/settings"}>
                        <.button variant="outline" class="w-full">Settings</.button>
                      </.link>
                      <.link href={~p"/users/log_out"} method="delete">
                        <.button variant="ghost" class="w-full">Log out</.button>
                      </.link>
                    <% else %>
                      <.link href={~p"/users/log_in"}>
                        <.button variant="outline" class="w-full">Sign In</.button>
                      </.link>
                      <.link href={~p"/users/register"}>
                        <.button class="w-full">Get Started</.button>
                      </.link>
                    <% end %>
                  </div>
                </nav>
              </.sheet_content>
            </.sheet>
          </div>
        </div>
      </div>
    </header>
    """
  end
end
