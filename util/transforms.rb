# https://www.micro-epsilon.com/service/glossar/Farbabstand.html
def colordist(hex1, hex2)
  r1, g1, b1 = hex2rgb(hex1)
  r2, g2, b2 = hex2rgb(hex2)
  Math.sqrt((r1 - r2)**2 + (g1 - g2)**2 + (b1 - b2)**2)
end

def hex2rgb(hex)
  hex.scan(/../).map { |x| x.hex }
end

# convert hex color into hsl
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

all = File.read("tokyonight.json").scan(/#[0-9a-f]{6}/i).uniq

anchors = {
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
