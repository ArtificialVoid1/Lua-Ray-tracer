--Specular Params
local MAX_RAYS_SPECULAR = 3


--Diffuse params
local Diffuse_Coeficient = 0.4
local Contrast = 0.6

--General Params
local SkyboxIsImage = false

-- math class 
math={}
math.fact = function(b)
    if(b==1)or(b==0) then
        return 1
    end
    local e=1
    for c=b,1,-1 do
        e=e*c
    end
    return e
end

math.pow = function(b,p)
    local e=b
    if(p==0) then
        return 1
    end
    if(p<0) then
        p=p*(-1)
    end
    for c=p,2,-1 do
        e=e*b
    end
    return e
end
math.cos = function(b,p)
    local e=1 
    b = math.correctRadians(b) 
    p=p or 10
    for i=1,p do
        e=e+(math.pow(-1,i)*math.pow(b,2*i)/math.fact(2*i))
    end
    return e
end

math.pi = 3.1415926545358
math.correctRadians = function( value )
    while value > math.pi*2 do
        value = value - math.pi * 2
    end           
    while value < -math.pi*2 do
        value = value + math.pi * 2
    end 
    return value
end


-- geometry class
Geometryf = {}
local sphere = 'x^2+y^2+z^2'

local Vec3 = {}
function Vec3.new(X, Y, Z)
  local Vn3 = {
    x = X,
    y = Y,
    z = Z
  }
  return Vn3
end
function Vec3.NormalSphere(Radius, Point)
  local gradVector = Vec3.new(2*Point.x, 2*Point.y, 2*Point.z)
  local NormalUnit = Vec3.Unit(gradVector)
  return NormalUnit
end
function Vec3.div(V1, V2)
  local Xf = V1.x / V2.x
  local Yf = V1.y / V2.y
  local Zf = V1.z / V2.z
  local NewV = Vec3.new(Xf, Yf, Zf)
  return NewV
end
function Vec3.divInt(V1, intE)
  local Xf = V1.x / intE
  local Yf = V1.y / intE
  local Zf = V1.z / intE
  local NewV = Vec3.new(Xf, Yf, Zf)
  return NewV
end
function Vec3.mag(V)
  local C = (V.x^2 + V.y^2 + V.z^2)^0.5
  return C
end
function Vec3.Unit(V)
  local magn = Vec3.mag(V)
  local newV = Vec3.divInt(V, magn)
  return newV
end
function Vec3.Dot(V1, V2)
  local a = V1.x * V2.x
  local b = V1.y * V2.y
  local c = V1.z * V2.z
  local D = a+b+c
  return D
end
function Vec3.subt(V1, V2)
  local Xf = V1.x - V2.x
  local Yf = V1.y - V2.y
  local Zf = V1.z - V2.z
  local NewV = Vec3.new(Xf, Yf, Zf)
  return NewV
end
function Vec3.subtInt(V1, Int)
  local Xf = V1.x - Int
  local Yf = V1.y - Int
  local Zf = V1.z - Int
  local NewV = Vec3.new(Xf, Yf, Zf)
  return NewV
end
function Vec3.add(V1, V2)
  local Xf = V1.x + V2.x
  local Yf = V1.y + V2.y
  local Zf = V1.z + V2.z
  local NewV = Vec3.new(Xf, Yf, Zf)
  return NewV
end
function Vec3.mult(V1, V2)
  local Xf = V1.x * V2.x
  local Yf = V1.y * V2.y
  local Zf = V1.z * V2.z
  local NewV = Vec3.new(Xf, Yf, Zf)
  return NewV
end
function Vec3.multInt(V1, intE)
  local Xf = V1.x * intE
  local Yf = V1.y * intE
  local Zf = V1.z * intE
  local NewV = Vec3.new(Xf, Yf, Zf)
  return NewV
end

local Color3 = {}
function Color3.new(r, g, b)
  local c3 = {
    R = r,
    G = g,
    B = b
  }
  return c3
end
function Color3.mult(Color1, Color2)
  local ColorR = (Color1.R/255)*(Color2.R/255)
  local ColorG = (Color1.G/255)*(Color2.G/255)
  local ColorB = (Color1.B/255)*(Color2.B/255)
  return Color3.new(ColorR, ColorG, ColorB)
end

local SkyboxColor = Color3.new(100, 100, 100)

function Color3.Lerp(Color1, Color2, t)
  local R = interpolate(Color1.R, Color2.R, t)
  local G = interpolate(Color1.G, Color2.G, t)
  local B = interpolate(Color1.B, Color2.B, t)
  local NewColor = Color3.new(R, G, B)
  return NewColor
end
function Color3.Unit(Color)
  local R = Color.R / 255
  local G = Color.G / 255
  local B = Color.B / 255
  local ColorN = Color3.new(R, G, B)
  return ColorN
end
function Color3.Deunit(Color)
  local R = Color.R * 255
  local G = Color.G * 255
  local B = Color.B * 255
  local ColorN = Color3.new(R, G, B)
  return ColorN
end

-- defining objects in scene--
local Maincamera = {
  Name = "Camera",
  ObjectType = "Camera",
  Position = Vec3.new(0, 0, -1),
  Facing = Vec3.new(0, 0, 1),
  Vfov = 1,--int
  Hfov = 2
}
local Light1 = {
  Name = "Point_Light_1",
  ObjectType = "Light",
  Position = Vec3.new(15, 70, 0),
  brightness = 0.5,
  lightcolor = Color3.new(255,255,255)
}
local Light2 = {
  Name = "Point_Light_1",
  ObjectType = "Light",
  Position = Vec3.new(-25, 60, 0),
  brightness = 0.5,
  lightcolor = Color3.new(255,255,255)
}
local sphere1 = {
  Name = "Sphere1",
  ObjectType = "Sphere",
  Color = Color3.new(255,255,0),
  geometryresult = 1, --radius
  geometry = sphere,
  Position = Vec3.new(1, 0, 4),
  Ref = 0 -- reflectivity
}
local sphere2 = {
  Name = "Sphere2",
  ObjectType = "Sphere",
  Color = Color3.new(255,1,100),
  geometryresult =1.5, --radius
  geometry = sphere,
  Position = Vec3.new(-2, -0.5, 3),
  Ref = 0 -- reflectivity
}
local sphere3 = {
  Name = "Sphere3",
  ObjectType = "Sphere",
  Color = Color3.new(100,100,255),
  geometryresult = 10,
  Position = Vec3.new(0,0,1)
}
local cube1 = {
  Name = "Cube1",
  ObjectType = "Cube",
  Color = Color3.new(50,200,0),
  Position = Vec3.new(-2,0,2),
  Size = Vec3.new(1.5,1.5,1.5),
  Ref = 0
}

-- define the world
local workspace = {
  children = {
    Maincamera,
    sphere2,
    sphere1,
    sphere3
  },
  Lights = {
    Light1,
    Light2
  }
}
-- general functions
function interpolate(A, B, t)
  c = A + (B-A) * t
  return c
end
function dist(V1, V2, degree)
  d = ((V1.x-V2.x)^degree+(V1.y-V2.y)^degree+(V1.z-V2.z)^2)^(1/degree)
  return d
end
function distInt(a, b)
  d = (a^2 + b^2)^0.5
  return d
end
function max(a, b)
  if a > b then
    return a
  else
    return b
  end
end
function Darken(a, b)
  local a = Color3.Unit(a)
  local b = Color3.Unit(b)
  if a.R < b.R then
    R = a.R
  else
    R = b.R
  end

  if a.G < b.G then
    G = a.G
  else
    G = b.G
  end

  if a.B < b.B then
    B = a.B
  else
    B = b.B
  end

  local Color = Color3.new(R, G, B)
  return Color3.Deunit(Color)
end
function Multiply(a, b)
  local a = Color3.Unit(a)
  local b = Color3.Unit(b)

  local R = a.R * b.R
  local G = a.G * b.G
  local B = a.B * b.B
  local c = Color3.new(R, G, B)
  return Color3.Deunit(c)
end
function Lighten(a, b)
  local a = Color3.Unit(a)
  local b = Color3.Unit(b)
  if a.R > b.R then
    R = a.R
  else
    R = b.R
  end

  if a.G > b.G then
    G = a.G
  else
    G = b.G
  end

  if a.B > b.B then
    B = a.B
  else
    B = b.B
  end

  local Color = Color3.new(R, G, B)
  return Color3.Deunit(Color)
  
end

function Reflect(res)

  local dn = Vec3.multInt(res.Normal, 1.1)

  local di = Vec3.subt(res.Position, Maincamera.Position)
  
  local dsX = di.x - 2*dn.x * Vec3.Dot(dn, di)
  local dsY = di.y - 2*dn.y * Vec3.Dot(dn, di) -- get the reflected direction
  local dsZ = di.z - 2*dn.z * Vec3.Dot(dn, di) -- ds = di - 2dn(dn Dot di)
  local ds = Vec3.new(dsX, dsY, dsZ)
  
  
  local outgoingRay = {
    origin = res.Position,
    Direction = ds
  }
  return outgoingRay
end

function SpecularLoop(RayCastResults, inC)

  local specOrigin = Vec3.add(RayCastResults.Position, Vec3.multInt(RayCastResults.Normal, 1))

  local RayCastPerms = Reflect(RayCastResults)
  local specRes = ray(specOrigin, RayCastPerms.Direction)
  local Color = Color3.new(0,0,0)

  if specRes == nil then
    Color = Color3.Lerp(inC, SkyboxColor, 0.2)
  else
    Color = Color3.Lerp(inC, specRes.Color, 1)
  end

  return Color
end

function DiffuseLighting(RayCastResults, ColorFinal)
  local origin = RayCastResults.Position
  local shade = 0
  
  for i, Light in ipairs(workspace.Lights) do
    local ld = Vec3.multInt(Vec3.Unit(Vec3.subt(Light1.Position, origin)), 5)
    local normal = RayCastResults.Normal
    
    ld = Vec3.new(ld.x, -ld.y, ld.z)
    local costheta = Vec3.Dot(normal, ld)
    shade = shade + Light1.brightness * costheta * Diffuse_Coeficient
  end

  
  local shadecolor = Color3.new(shade, shade, shade)
  local shade = Color3.Deunit(shadecolor)

  local shade = Multiply(ColorFinal, shade)
  local ColorFinal = Color3.Lerp(ColorFinal, shade, 0.75)
  
  return ColorFinal
end

function Shadow(Results, Color)

  local Origin = Vec3.add(Results.Position, Vec3.multInt(Results.Normal, -1))
  local ld = Vec3.multInt(Vec3.Unit(Vec3.subt(Light1.Position, Origin)), 5)
  local testforlite = ray(Origin, ld)
  if testforlite ~= nil and testforlite.Instance.ObjectType == "Light" then
    return Color
  else
    return Color3.new(0,0,0)
  end
  
end


function ray(Origin, Direction, Ignore)
  local degree = 3
  local Results = nil
  for i, Obj in ipairs(workspace.children) do
    if Obj.ObjectType == "Sphere" and Obj ~= Ignore then --calculates a ray intersection

      local ObjCenter = Obj.Position -- note: move to seporated function later
      local geometry = Obj.geometry
      local radius = Obj.geometryresult

      local t = Vec3.Dot(Vec3.subt(ObjCenter, Origin), Direction)
      local P = Vec3.add(Origin, Vec3.multInt(Direction, t))
      local Yf = dist(ObjCenter, P, 2)
      local Xf = (radius^degree+ Yf^degree)^(1/degree)
      local t1 = Vec3.add(Origin, Vec3.multInt(Direction, (t-Xf)))
        
      if Yf <= radius then
        Results = {
          Instance = Obj,
          Color = Obj.Color,
          Position = t1,
          Normal = Vec3.NormalSphere(radius, t1)
         }
        return Results
      end
    elseif Obj.ObjectType == "Cube" then
      local ObjCenter = Obj.Position -- note: move to seporated function later

      local t = Vec3.Dot(Vec3.subt(Origin, ObjCenter), Direction)
      local P = Vec3.add(Origin, Vec3.multInt(Direction, t))
      local scale = Obj.Size
      local xScaleDisp = distInt(P.x, ObjCenter.x)
      local yScaleDisp = distInt(P.y, ObjCenter.y)
      local zScaleDisp = distInt(P.z, ObjCenter.z)
      if xScaleDisp <= scale.x and xScaleDisp >= scale.x*-1 and yScaleDisp <= scale.y and yScaleDisp >= scale.y*-1 and zScaleDisp <= scale.z and zScaleDisp >= scale.z*-1 then
        local nd = Vec3.subt(ObjCenter, P)
        local Nor = Vec3.multInt(nd,-1)
        local nR = Vec3.add(ObjCenter, Nor)
        Results = {
          Instance = Obj,
          Color = Obj.Color,
          Position = P,
          Normal = nR
        }
        return Results
      end
    end
  end

  return Results
end

--renderer
local Resolution = 1
local XSize = 700
local YSize = 350
local XDiv = Maincamera.Hfov / XSize
local YDiv = Maincamera.Vfov / YSize
local Xoffset = -1
local Yoffset = -0.5

function CalculatePixelcolor(X, Y)

  local origin = Maincamera.Position
  local FaceX = XDiv * X
  local FaceY = YDiv * Y
  local Direction = Vec3.new((FaceX + Maincamera.Facing.x)+Xoffset, (FaceY + Maincamera.Facing.y)+Yoffset, Maincamera.Facing.z)
  local offsetX = interpolate(origin.x, Direction.x, 3)
  local offsetY = interpolate(origin.y, Direction.y, 3)
  local newOrigin = Vec3.new(offsetX- origin.x, offsetY- origin.y, Direction.z - 0.01)
  
  local Results = ray(newOrigin, Direction)

  if Results == nil then
    local Color = SkyboxColor
    return Color.R, Color.G, Color.B
  else
    local ReturnColor = DiffuseLighting(Results, Results.Color)
    --local ReturnColor = SpecularLoop(Results, ReturnColorD)

    
    return ReturnColor.R, ReturnColor.G, ReturnColor.B
  end
end

function love.load()
  local screen_width, screen_hight = love.graphics.getDimensions()
end



function love.draw()
  for Y=0,YSize, Resolution do
    for X=0,XSize, Resolution do
      local R, G, B = CalculatePixelcolor(X, Y)
      love.graphics.setColor(R, G, B)
      love.graphics.rectangle("fill", X, Y, Resolution, Resolution)
    end
  end
end
