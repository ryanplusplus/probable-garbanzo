local Thread = require "llthreads2".new

local i = 0
local function Worker()
  i = i + 1
  return Thread([[
    os.execute('sleep 1')
    return ]] .. i .. [[
  ]])
end

local function Gui()
  local fl = require 'fltk4lua'

  local window = fl.Window(340, 180, "Hello")
  local box = fl.Box(20, 40, 300, 100, "Hello World!")
  window:end_group()
  window:show()

  return {
    run = function()
      return fl.check()
    end,

    set_text = function(s)
      box.label = s
    end
  }
end

local gui = Gui()
local worker

while gui.run() do
  os.execute('sleep 0.1')

  if not (worker and worker:alive()) then
    if worker then
      local _, result = worker:join()
      gui.set_text(result)
    end
    worker = Worker()
    worker:start()
  end
end
