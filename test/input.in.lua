
#for name, data in pairs(functions) do

function $(name) ($(table.concat(data.args, ", ")))
  return $(data.result)
end

#end

