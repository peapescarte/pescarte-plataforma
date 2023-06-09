defmodule Storybook.Tags do
  use PhoenixStorybook.Index

  def entry("tag"), do: [icon: {:fa, "book", :thin}]
end
