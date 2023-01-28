# given four sets of coordinates in 3d spaces, and another three sets of coordinates in 3d space which represent a transformed version of the first three coordinates in the first four sets, calculate the coordinates of the fourth point (b4) in the second set of coordinates
def colorskew(a1, a2, a3, a4, b1, b2, b3)
  # a1, a2, a3, a4, b1, b2, b3 are arrays of three numbers
  # a1, a2, a3 are the coordinates of the first three points in the first set of coordinates
  # a4 is the coordinates of the fourth point in the first set of coordinates
  # b1, b2, b3 are the coordinates of the first three points in the second set of coordinates
  # b4 is the coordinates of the fourth point in the second set of coordinates
  # b4 is the point we are trying to find
  # b4 = a4 + (b1 - a1) + (b2 - a2) + (b3 - a3)
  # b4 = a4 + (b1 - a1) + (b2 - a2) + (b3 - a3)
  # b4 - a4 = (b1 - a1) + (b2 - a2) + (b3 - a3)
  # b4 - a4 = b1 - a1 + b2 - a2 + b3 - a3
  # b4 - a4 = b1 + b2 + b3 - a1 - a2 - a3
  # b4 = a4 + b1 + b2 + b3 - a1 - a2 - a3
  b4 =
    a4
      .zip(b1, b2, b3)
      .map { |a, b, c, d| a + b + c + d - a1.shift - a2.shift - a3.shift }
  # b4 is the coordinates of the fourth point in the second set of coordinates
  b4
end

# https://www.micro-epsilon.com/service/glossar/Farbabstand.html
def colordist(hex1, hex2)
  r1, g1, b1 = hex2rgb(hex1)
  r2, g2, b2 = hex2rgb(hex2)
  Math.sqrt((r1 - r2)**2 + (g1 - g2)**2 + (b1 - b2)**2)
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

  [h.round(6), s.round(6), l.round(6)]
end

# calculate the distance between two points in 3d space
def dist3d(x1, y1, z1, x2, y2, z2)
  Math.sqrt((x1 - x2)**2 + (y1 - y2)**2 + (z1 - z2)**2)
end

# find the closest three anchors to the given hsl coordinates
def closest_neighbors(h, s, l)
  @anchors.sort_by { |_, anchor_hsl| dist3d(h, s, l, *anchor_hsl) }[0..2]
end

def starmap(hash)
  starhash = {}

  hash.each do |key, value|
    starhash[key] = if value.is_a?(Hash)
      starmap(value)
    elsif value.downcase == "none"
      value
    else
      hsl = hex2hsl(value)
      { hsl: hsl, neighbors: closest_neighbors(*hsl) }
    end
  end

  starhash
end
