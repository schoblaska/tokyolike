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
