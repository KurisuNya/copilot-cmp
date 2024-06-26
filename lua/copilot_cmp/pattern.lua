local pattern = {}

local fmt_chars = {
  ["("] = "%(",
  ["["] = "%[",
  ["{"] = "%{",
}

local char_pairs = {
  ["("] = "%)",
  ["["] = "%]",
  ["{"] = "%}",
}

local function count_char(str, char)
  return select(2, string.gsub(str, char, ""))
end

pattern.check_pairs = function(text)
  for char, fmt_char in pairs(fmt_chars) do
    local char_count = count_char(text, fmt_char)
    local pair_count = count_char(text, char_pairs[char])
    if char_count ~= pair_count then
      return false
    end
  end
  return true
end

return pattern
