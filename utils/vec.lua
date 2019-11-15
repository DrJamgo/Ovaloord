function vec2(x, y)
  return {x=x, y=y}
end

function vec2_add(v1, v2)
  return {x=v1.x+v2.x, y=v1.y+v2.y}
end

function vec2_sub(v1, v2)
  return {x=v1.x-v2.x, y=v1.y-v2.y}
end

function vec2_mul(v, s)
  return {x=v.x*s, y=v.y*s}
end

-- returns normalized vector and un-normalized length
function vec2_norm(v, l)
  local l = l or 1
  local length = math.sqrt(v.x*v.x + v.y*v.y)
  local vec = vec2_mul(v, ((length > 0) and (l / length)) or 1)
  return vec, length
end