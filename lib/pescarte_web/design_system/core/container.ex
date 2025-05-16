defmodule PescarteWeb.DesignSystem.Core.Container do
  @moduledoc """
  Container components for layout management.
  These are core design system components for consistent layout containers.
  """

  use Phoenix.Component

  @doc """
  Renders a responsive container with consistent padding according to the design system.

  ## Examples
      <.container>
        Content goes here
      </.container>

      <.container max_width="max-w-4xl" class="my-8">
        Narrower container with custom margins
      </.container>

  ## Attributes
    * `max_width` - Optional. The maximum width of the container (defaults to max-w-7xl)
    * `class` - Optional. Additional CSS classes to apply
  """
  attr :max_width, :string, default: "max-w-7xl"
  attr :class, :string, default: ""
  attr :rest, :global

  slot :inner_block, required: true

  def container(assigns) do
    ~H"""
    <div class={"container mx-auto px-1 md:px-2 lg:px-3 xl:px-4 #{@max_width} #{@class}"} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a grid container using the 12-column grid system.

  ## Examples
      <.grid>
        <div class="col-span-12 md:col-span-6 lg:col-span-4">Column 1</div>
        <div class="col-span-12 md:col-span-6 lg:col-span-4">Column 2</div>
        <div class="col-span-12 md:col-span-6 lg:col-span-4">Column 3</div>
      </.grid>

      <.grid gap="gap-4" class="mt-8">
        Custom grid with different gap
      </.grid>

  ## Attributes
    * `gap` - Optional. The gap between grid items (defaults to gap-2)
    * `class` - Optional. Additional CSS classes to apply
  """
  attr :gap, :string, default: "gap-2"
  attr :class, :string, default: ""
  attr :rest, :global

  slot :inner_block, required: true

  def grid(assigns) do
    ~H"""
    <div class={"grid grid-cols-12 #{@gap} #{@class}"} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a section with consistent spacing.

  ## Examples
      <.section>
        Section content
      </.section>

      <.section padding="py-16" class="bg-neutral-5">
        Section with custom padding and background
      </.section>

  ## Attributes
    * `padding` - Optional. The padding around the section (defaults to py-8)
    * `class` - Optional. Additional CSS classes to apply
  """
  attr :padding, :string, default: "py-8"
  attr :class, :string, default: ""
  attr :rest, :global

  slot :inner_block, required: true

  def section(assigns) do
    ~H"""
    <section class={"#{@padding} #{@class}"} {@rest}>
      {render_slot(@inner_block)}
    </section>
    """
  end
end
