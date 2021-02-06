--Reactor Control
local gpu = require('component').gpu
local computer = require('computer')
local pull_e = require('event').pull
local W, H = gpu.getResolution()
local b_color, f_color = gpu.getBackground(), gpu.getForeground()

local tButtons = {
  {
    visible = false,
    X = W-6,
    Y = 0,
    W = 6,
    H = 4,
    color = 0x999999,
    colorDark = 0x888888,
    textColor = 0x444444,
    text = 'Exit',
    action = function()
      gpu.setBackground(b_color)
      gpu.setForeground(f_color)
      gpu.fill(1, 1, W, H, ' ')
      os.exit()
  end
  }
}

local function drawButton(n) -- функция рисования кнопки
  gpu.setBackground(tButtons[n].colorDark) -- задаем цвет кнопки
  gpu.setForeground(tButtons[n].textColor) -- задаем цвет текста
  gpu.fill(tButtons[n].X, tButtons[n].Y, tButtons[n].W, tButtons[n].H, ' ') -- заливаем область
  gpu.setBackground(tButtons[n].color) -- задаем цвет кнопки
  gpu.fill(tButtons[n].X, tButtons[n].Y, tButtons[n].W-1, tButtons[n].H-1, ' ') -- заливаем область
  gpu.set(tButtons[n].X+(tButtons[n].W/2)-(#tButtons[n].text/2), tButtons[n].Y+(tButtons[n].H/2), tButtons[n].text) -- пишем текст по центру
end

local function drawCommandMenu()
    gpu.setBackground(0xaaaaaa)
    gpu.fill(1, 1, W, 3, ' ')
end

local function toggleVisible(n) -- переключение видимости кнопки
  if tButtons[n].visible then -- если кнопка видима
    tButtons[n].visible = false -- отключаем
    gpu.setBackground(b_color) -- берем цвет фона, полученный при старте программы
    gpu.fill(tButtons[n].X, tButtons[n].Y, tButtons[n].W, tButtons[n].H, ' ') -- стираем кнопку
  else -- если кнопка не активна
    tButtons[n].visible = true -- активируем
    drawButton(n) -- запускаем отрисовку
  end
end

local function blink(n) -- мигание кнопки
  tButtons[n].color, tButtons[n].textColor = tButtons[n].textColor, tButtons[n].color -- меняем местами цвета фона и текста
  drawButton(n) -- отрисовываем кнопку
  os.sleep(0.09) -- делаем задержку
  tButtons[n].color, tButtons[n].textColor = tButtons[n].textColor, tButtons[n].color -- меняем цвета обратно
  drawButton(n) -- перерисовываем кнопку
end

gpu.fill(1, 1, W, H, ' ') -- очищаем экран
drawCommandMenu()
for i = 1, #tButtons do
  toggleVisible(i) -- активируем каждую кнопку
end

while true do 
  local tEvent = {pull_e('touch')} -- ждем клика
  for i = 1, #tButtons do -- перебираем все кнопки
    if tButtons[i].visible then -- если кнопка активна
      if tEvent[3] >= tButtons[i].X and tEvent[3] <= tButtons[i].X+tButtons[i].W and tEvent[4] >= tButtons[i].Y and tEvent[4] <= tButtons[i].Y+tButtons[i].H then -- если клик произведен в пределах кнопки
       blink(i) -- мигнуть кнопкой
       tButtons[i].action() -- выполнить назначенный код
       break
      end
    end
  end
end
