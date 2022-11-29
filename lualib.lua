sc = 1
tp = tex.print

function name_place (x, y, name, kwargs)
  tp('\\node ['..kwargs..'] at ('..x..','..y..') ('..name..'){};')
  return 0
end

function trace_big (t)
  random = math.random()
    return string.format('% .2f', random)
end

function trace_small (t)
random = math.random()
    return string.format('% .2f', random)
end

function zig_arrow (xfrom, yfrom, xto, yto)
  local ymid = yto-yfrom
  ymid = ymid/2
  ymid = yfrom + ymid
  tp('\\draw[very thick, ->, -latex] ('..xfrom..','..yfrom..') -- ('..xfrom..', '..ymid..') -- ('..xto..', '..ymid..') -- ('..xto..','..yto..');')
  return 0
end

function simple_node (x, y, text, args)
tp('\\node[align=center, '..args..'] at ('..x..','..y..') {'..text..'};')
return x, y
end

function sn(x,y,text,args)
  return simple_node(x,y,text,args)
end

function west_node (x, y, text)
tp('\\node[minimum width=100, align=left] at ('..x..','..y..') {'..text..'};')
return x, y
end

function ball (x,y, radius, color)
tp('\\shade[ball color='..color..'] ('..x..', '..y..') circle ('..radius..');')
return 0
end

function sigball (x,y,sigma)
local radius = math.sqrt(sigma) / 7
disc(x, y, radius, 'JoCyan')
return x,y
end

function rectangle_at (x, y, a, b, color)
local x1 = x - b/2
local x2 = x - b/2
local x3 = x + b/2
local x4 = x + b/2
local y1 = y - a/2
local y2 = y + a/2
local y3 = y + a/2
local y4 = y - a/2
tp('\\shade[fill=black, left color='..color..', right color='..color..'!40, rounded corners=1pt] ('..x1..', '..y1..') -- ('..x2..', '..y2..') -- ('..x3..', '..y3..')-- ('..x4..', '..y4..')-- ('..x1..', '..y1..');')
return x1, y1, x2, y2, x3, y3, x4, y4
end


function disc (x, y, radius, color)
tp('\\shade[left color='..color..', right color='..color..'!40] ('..x..', '..y..') circle ('..radius..');')
return x, y
end

function node_disc (x, y, radius, color, node)
tp('\\shade[left color='..color..', right color='..color..'!40] ('..x..', '..y..') circle ('..radius..');')
local ynode = y - radius - 0.4
simple_node(x, ynode, node)
return x, y
end

function chopper (x, y, radius, color)
tp('\\centershade[left color='..color..', right color='..color..'!40]('..x..','..y..')(30:180:'..radius..')')
tp('\\centershade[left color='..color..', right color='..color..'!40]('..x..','..y..')(210:360:'..radius..')')
local radius_plussome = radius + 0.2
tp('\\centerdraw[ultra thick, ->, -latex]('..x..','..y..')(60:120:'..radius_plussome..')')
local ynode = y - radius - 0.4
simple_node(x, ynode, 'Chopper')
return x,y
end

function mypath (xylist)
  local out = ''
  local line = ''
  for i, xy in ipairs(xylist) do
    out = out .. line .. '('..xy['x']..','..xy['y']..')'
    print(out)
    line = '- -'
  end
  out = out .. ';'
  return out
end

function control_path(xylist)
  local out = ''
  local x0 = xylist['start']['x']
  local y0 = xylist['start']['y']
  local x1 = xylist['control1']['x']
  local y1 = xylist['control1']['y']
  local x2 = xylist['control2']['x']
  local y2 = xylist['control2']['y']
  local xf = xylist['end']['x']
  local yf = xylist['end']['y']
  local out = out .. '('..x0..','..y0..') ..'
  local out = out .. 'controls ('..x1..','..y1..')'
  local out = out .. 'and ('..x2..','..y2..') .. ('..xf..','..yf..');'
  return out
end

function draw (path, args)
  tp('\\draw['..args..']')
  tp(path)
  return 0
end

function myarrow (path, args)
  tp('\\draw[ultra thick, ->, -latex, '..args..']')
  tp(path)
  return 0
end

function cut_xylist (xylist, cut1, cut2)
local x1 = xylist[1]['x']
local x2 = xylist[2]['x']
local y1 = xylist[1]['y']
local y2 = xylist[2]['y']
local length = math.sqrt( (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
local angle = math.atan((y2-y1) / (x2-x1))
local xc1 = x1 + cut1 * math.cos(angle)
local xc2 = x2 - cut2 * math.cos(angle)
if x1<x2 then
local xc1 = x1 - cut1 * math.cos(angle)
local xc2 = x2 + cut2 * math.cos(angle)
end
local yc1 = y1 + cut1 * math.sin(angle)
local yc2 = y2 - cut2 * math.sin(angle)
if y1<y2 then
local yc1 = y1 - cut1 * math.sin(angle)
local yc2 = y2 + cut2 * math.sin(angle)
end
outxylist = {}
outxylist[1] = {x=xc1, y=yc1}
outxylist[2] = {x=xc2, y=yc2}
return outxylist
end

tubeargs = 'left color = JoddCyan, right color = JoddCyan!40'

function tube (xylist, width, args)
local x01 = xylist[1]['x']
local y01 = xylist[1]['y']
local x02 = xylist[2]['x']
local y02 = xylist[2]['y']
local length = math.sqrt( (x02 - x01) * (x02 - x01) + (y02 - y01) * (y02 - y01))
local angle = math.acos( (x02-x01) / length)
local angle2 = math.asin( (x02-x01) / length)
local hw = width / 2
local x1 = x01 - hw * math.sin(angle)
local x2 = x02 - hw * math.sin(angle)
local x3 = x02 + hw * math.sin(angle)
local x4 = x01 + hw * math.sin(angle)
local y1 = y01 + hw * math.cos(angle)
local y2 = y02 + hw * math.cos(angle)
local y3 = y02 - hw * math.cos(angle)
local y4 = y01 - hw * math.cos(angle)
-- tp('\\draw[ultra thick, fill='..color..'] ('..x1..', '..y1..')')
tp('\\shade[ultra thick, '..args..'] ('..x1..', '..y1..')')
tp('-- ('..x2..', '..y2..')')
tp('-- ('..x3..', '..y3..')')
tp('-- ('..x4..', '..y4..');')
return x1, y1, x2, y2, x3, y3, x4, y4
end

function mylaser (xylist, width, args)
  local x01 = xylist[1]['x']
  local y01 = xylist[1]['y']
  local x02 = xylist[2]['x']
  local y02 = xylist[2]['y']
  local x = (x02 + x01) / 2
  local y = (y02 + y01) / 2
  local length = math.sqrt( (x02 - x01) * (x02 - x01) + (y02 - y01) * (y02 - y01))
  local angle = math.acos( (x02-x01) / length)
  local degangle = 180 * angle / math.pi + 90
  local hw = width / 2
  local x1 = x - length/2
  local x2 = x + length/2
  local y1m = y - hw
  local y2p = y + hw
  tp('\\fill[transform canvas={rotate around={'..degangle..':('..x..','..y..')}},')
 tp('path fading=middle, '..args..'] ('..x1..','..y1m..') rectangle ('..x2..','..y2p..');')
return 0
end

function myarc (x, y, phi1, phi2, radius, args)
local x1 = x + radius * math.sin(phi1 * math.pi / 180)
local y1 = y + radius * math.cos(phi1 * math.pi / 180)
local x2 = x + radius * math.sin(phi2 * math.pi / 180)
local y2 = y + radius * math.cos(phi2 * math.pi / 180)
local alpha1 = 90 - phi1
local alpha2 = 90 - phi2
tp('\\draw[ultra thick, '..args..'] ('..x..', '..y..') -- ('..x1..','..y1..')')
tp('arc ('..alpha1..':'..alpha2..':'..radius..')')
tp('-- ('..x..', '..y..');')
return x1, y1, x2, y2
end

function ballchain (path, args)
  tp('\\path[decorate,'..args..', decoration={ markings,')
  tp('mark= between positions 0 and 1 step 4mm')
  tp('with')
  tp('{\\shade[ball color=JoRed] (0,0) circle (2mm) node[font=\\huge] {\\color{white}{-}};}')
  tp('} ]')
  tp(path)
return 0
end

function mylens (x, y, height, radius)
local ytop = y+height
local ybot = y-height
tp('\\pgfmathsetmacro{\\angle}{asin('..height..'/'..radius..')}')
tp('\\draw [left color=JoBlue!60,right color=JoBlue!20]  ('..x..','..ytop..') arc[start angle=180-\\angle,delta angle=2*\\angle,radius='..radius..'] arc[start angle=-\\angle,delta angle=2*\\angle,radius='..radius..'] -- cycle;')
  return 0
end

function test_tube (xpos, ypos, color, width, hight)
  local ytop = ypos + hight/2
  local ybot = ypos - hight/2
  local yfill = ypos + hight/5
  local halfwidth=width/2
  local yradius = 0.5*halfwidth
  local xleft = xpos - width/2
  local xright = xpos + width/2
  tp('\\shade[left color='..color..',right color='..color..'!40]')
  tp('(' .. xleft .. ','.. yfill .. ')--(' .. xleft ..','.. ybot ..') arc (180:360:'..halfwidth..')  -- (' .. xright .. ',' .. yfill ..') arc (0:180:'..halfwidth..' and '..yradius..');')
  tp('\\draw (' .. xpos .. ',' .. ytop .. ') ellipse ('..halfwidth..' and '..yradius..');')
  tp('\\draw['..color..'!30!black!70] ('..xpos..','..yfill..') ellipse ('..halfwidth..' and '..yradius..');')
  tp('\\draw ('.. xleft .. ',' .. ytop ..')--(' .. xleft ..',' .. ybot ..') arc (180:360:'..halfwidth..') --('.. xright ..','.. ybot ..') -- ('.. xright ..',' .. ytop ..');')
  return 0
end

function needle (xpos, ypos, color, width, hight)
  local ytop = ypos + hight/2
  local ybot = ypos - hight/2
  local yneedletip = ypos - hight
  local yfill = ypos + hight/5
  local halfwidth=width/2
  local yradius = 0.5*halfwidth
  local xleft = xpos - width/2
  local xright = xpos + width/2
  tp('\\shade[left color='..color..',right color='..color..'!40]')
  tp('(' .. xleft .. ','.. yfill .. ')--(' .. xleft ..','.. ybot ..')')
  tp('-- ('..xpos..','..yneedletip..') --('..xright..','..ybot..')  -- (' .. xright .. ',' .. yfill ..') arc (0:180:'..halfwidth..' and '..yradius..');')
  tp('\\draw (' .. xpos .. ',' .. ytop .. ') ellipse ('..halfwidth..' and '..yradius..');')
  tp('\\draw['..color..'!30!black!70] ('..xpos..','..yfill..') ellipse ('..halfwidth..' and '..yradius..');')
  tp('\\draw ('.. xleft .. ',' .. ytop ..')--(' .. xleft ..',' .. ybot ..') -- ('..xpos..','..yneedletip..') --('.. xright ..','.. ybot ..') -- ('.. xright ..',' .. ytop ..');')
  return 0
end

function laser (x1, y1, x2, y2, width)
  local y1m = y1 - width/2
  local y2p = y2 + width/2
  text = '\\fill[path fading=middle, JoRed] ('..x1..','..y1m..') rectangle ('..x2..','..y2p..');'
  tp(text)
return x1,y1,x2,y2
end

function colored_rotlaser (x,y,len,width,angle,color)
  local x1 = x-len/2
  local x2 = x+len/2
  local y1 = y
  local y2 = y
  local y1m = y1 - width/2
  local y2p = y2 + width/2
 local text = '\\fill[transform canvas={rotate around={'..angle..':('..x..','..y..')}}, path fading=middle, '..color..'] ('..x1..','..y1m..') rectangle ('..x2..','..y2p..');'
-- tp('fill[transform canvas={rotate around={-35:(0,0)}}, path fading=middle, TumBlue!40] (-3.5, -.2) rectangle (3.5, 0.2);')
  tp(text)
return x1,y1,x2,y2
end

function rotlaser (x,y,len,width,angle)
  return colored_rotlaser(x,y,len,width,angle,'JoRed')
end

-- print(mypath({{x=arrowspace, y=1}, {x=dist, y=1)}}))
