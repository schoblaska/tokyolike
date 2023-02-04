# given the tokyonight anchor colors, do we produce the same full theme?

require "json"
require "./helpers"

anchors =
  {
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
  }.map { |k, v| hex2yuv(v) }

template = JSON.parse(File.read("tokyonight.json"))

def apply_template(template, tokyo_anchors, new_anchors)
  new_hash = {}

  template.each do |key, value|
    new_hash[key] = if value.is_a?(Hash)
      apply_template(value, tokyo_anchors, new_anchors)
    elsif value.downcase == "none"
      value
    else
      yuv = hex2yuv(value)
      new_yuv = skew3d(tokyo_anchors, new_anchors, yuv)
      "#" + yuv2hex(*new_yuv)
    end
  end

  new_hash
end

new_theme = apply_template(template, anchors, anchors)

File.open("tokyo_in_tokyo_out.json", "w") { |f| f.puts(new_theme.to_json) }
