require "json"
require_relative "helpers"

# anchor colors from the tokyonight theme
@anchors = {
  black: "#1e2030",
  dark_gray: "#222436",
  gray: "#545c7e",
  light_gray: "#636da6",
  darkest_white: "#c8d3f5",
  darker_white: "#e5e9f0",
  white: "#e9e9ed",
  teal: "#4fd6be",
  off_blue: "#89ddff",
  glacier: "#828bb8",
  blue: "#82aaff",
  red: "#ff757f",
  orange: "#ff966c",
  yellow: "#ffc777",
  green: "#c3e88d",
  purple: "#fca7ea"
}

@anchors.each { |key, val| @anchors[key] = hex2hsl(val) }

tokyonight = JSON.parse(File.read("tokyonight.json"))

File.open("starmap.json", "w") { |f| f.puts(starmap(tokyonight).to_json) }
