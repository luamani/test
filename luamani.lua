-- luamani@yahoo.com

local class = require'class'

local data = {
contacts = [[
Alice Brown / None / 1231112223
Bob Crown / bob@crowns.com / None
Carlos Drew / carl@drewess.com / 3453334445
Doug Emerty / None / 4564445556
Egan Fair / eg@fairness.com / 5675556667
]],
leads = [[
None / kevin@keith.com / None
Lucy / lucy@liu.com / 3210001112
Mary Middle / mary@middle.com / 3331112223
None / None / 4442223334
None / ole@olson.com / None
]],
registrants = [[
Lucy Liu / lucy@liu.com / None
Doug / doug@emmy.com / 4564445556
Uma Thurman / uma@thurs.com / None
]]
}

local Person = class('Person')
local base = {}

function Person:initialize(name,email,phone)
  self.name = name
  self.email = email
  self.phone = phone
end

function Person:view()
  print(self,self.name,self.email,self.phone)
end

local function read(list)
  local persons = {}
  for line in list:gmatch("[^\n]+") do
    local name,email,phone = line:match("([^/]+)%s/%s([^/]+)%s/%s([^%s]+)")
    persons[#persons + 1] = Person(name,email,phone)
  end
  return persons
end

local function register(person)
  person:view()
  local new = true
  for id,contact in ipairs(base.contacts) do
    if contact.email == person.email and contact.email ~= 'None' then
      if contact.phone ~= 'None' and person.phone == 'None' then
        contact.phone = person.phone
      end
      new = false
    elseif contact.phone == person.phone and contact.phone ~= 'None' then
      if contact.email == 'None' and person.email ~= 'None' then
        contact.email = person.email
      end
      new = false
    end
  end
  for id,contact in ipairs(base.leads) do
    if contact.email == person.email and contact.email ~= 'None' then
      if contact.phone ~= 'None' and person.phone == 'None' then
        contact.phone = person.phone
      end
      if new then
        table.insert(base.contacts,person)
      end
      table.remove(base.leads,id)
      new = false
    elseif contact.phone == person.phone and contact.phone ~= 'None' then
      if contact.email == 'None' and person.email ~= 'None' then
        contact.email = person.email
      end
      if new then
        table.insert(base.contacts,person)
      end
      table.remove(base.leads,id)
      new = false
    end
  end
  if new then
    table.insert(base.contacts,person)
  end
end

for name,list in pairs(data) do
  base[name] = read(list)
end

print('Contacts before webinar')
for id,person in pairs(base.contacts) do
  person:view()
end

print('Leads before webinar')
for id,person in pairs(base.leads) do
  person:view()
end

print('Registrants')
for id,person in pairs(base.registrants) do
  register(person)
end

print('Contacts after webinar')
for id,person in pairs(base.contacts) do
  person:view()
end

print('Leads after webinar')
for id,person in pairs(base.leads) do
  person:view()
end

