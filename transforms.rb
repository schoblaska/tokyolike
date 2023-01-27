require "json"

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

# https://www.micro-epsilon.com/service/glossar/Farbabstand.html
def colordist(hex1, hex2)
  r1, g1, b1 = hex2rgb(hex1)
  r2, g2, b2 = hex2rgb(hex2)
  Math.sqrt((r1 - r2)**2 + (g1 - g2)**2 + (b1 - b2)**2)
end

def huedist(hex1, hex2)
  h1, _s1, _l1 = hex2hsl(hex1)
  h2, _s2, _l2 = hex2hsl(hex2)
  (h1 - h2).abs
end

def hex2rgb(hex)
  hex.scan(/\w\w/).map { |x| x.hex }
end

def hex2hsl(hex)
  r, g, b = hex2rgb(hex)
  r, g, b = r / 255.0, g / 255.0, b / 255.0
  max = [r, g, b].max
  min = [r, g, b].min
  l = (max + min) / 2.0
  if max == min
    h = s = 0 # achromatic
  else
    d = max - min
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min)
    case max
    when r
      h = (g - b) / d + (g < b ? 6 : 0)
    when g
      h = (b - r) / d + 2
    when b
      h = (r - g) / d + 4
    end
    h /= 6.0
  end

  [h, s, l]
end

def hsl_transforms(hex1, hex2)
  ha, sa, la = hex2hsl(hex1)
  hv, sv, lv = hex2hsl(hex2)

  h = (hv - ha) / ha
  s = (sv - sa) / sa
  l = (lv - la) / la

  return h.round(3), s.round(3), l.round(3)
end

def calculate_transforms(hash, original = nil)
  transforms = {}

  hash.each do |key, value|
    if value.is_a?(Hash)
      transforms[key] = calculate_transforms(value)
    elsif value.downcase == "none"
      transforms[key] = value
    else
      if original
        anchor_name, anchor_hex = original[key][:aname], original[key][:ahex]
      else
        distances =
          @anchors.map do |anchor_name, anchor_hex|
            [anchor_name, anchor_hex, colordist(value, anchor_hex)]
          end

        anchor_name, anchor_hex = distances.min_by { |x| x[2] }[0, 2]
      end

      h, s, l = hsl_transforms(anchor_hex, value)

      transforms[key] = {
        aname: anchor_name,
        ahex: anchor_hex,
        h: h,
        s: s,
        l: l
      }
    end
  end

  transforms
end

tokyonight = JSON.parse(File.read("tokyonight.json"))

moon = calculate_transforms(tokyonight["moon"])
night = calculate_transforms(tokyonight["night"], moon)
storm = calculate_transforms(tokyonight["storm"], moon)
day = calculate_transforms(tokyonight["day"], moon)

File.open("transforms.json", "w") do |f|
  f.puts({ moon: moon, night: night, storm: storm, day: day }.to_json)
end
