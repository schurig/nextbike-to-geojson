require 'nokogiri'
require 'json'

def value(object, key)
  return nil if !object.attributes[key]
  object.attributes[key].value
end

def station?(place)
  true if place.attributes['spot'] && place.attributes['spot'].value.to_i == 1
end

def bike?(place)
  true if place.attributes['bike'] && place.attributes['bike'].value.to_i == 1
end

def bike_number(place)
  return nil if !value(place, 'bike_numbers') || value(place, 'bike_numbers').split(',').size > 1
  value(place, 'bike_numbers').split(',')
end

items = []
f = File.open('nextbike.xml')
doc = Nokogiri::XML(f)
doc.search('//country').each do |country|
  country.search('//city').each do |city|
    city.search('//place').each do |place|
      item = {
        type: 'FeatureCollection',
        features: {
          type: 'Feature',
          geometry: {
            type: 'Point',
            coordinates: [
              value(place, 'lat'),
              value(place, 'lng')
            ]
          },
          properties: {
            uid: value(place, 'uid'),
            is_station: station?(place) ? true : false,
            station: {
              uid: value(place, 'uid'),
              number: value(place, 'number'),
              name: value(place, 'name'),
              bikes_count: value(place, 'bikes'),
              bike_numbers: value(place, 'bike_numbers') ? value(place, 'bike_numbers').split(',') : nil,
            },
            is_bike: bike?(place) ? true : false,
            bike: { number: bike_number(place) },
            # city: {
            #   uid: value(city, 'uid'),
            #   name: value(city, 'name'),
            #   latitude: value(city, 'lat'),
            #   longitude: value(city, 'lng'),
            #   zoom: value(city, 'zoom')
            # },
            # country: {
            #   name: value(country, 'country_name'),
            #   code: value(country, 'country'),
            #   domain: value(country, 'domain'),
            #   website: value(country, 'website'),
            #   zoom: value(country, 'zoom')
            # },
            # operator: {
            #   name: value(country, 'name'),
            #   hotline: value(country, 'hotline'),
            #   domain: value(country, 'domain'),
            #   website: value(country, 'website')
            # }
          }
        }
      }

      items.push(item)
    end
  end
end

File.open('output' + '.json', 'w') do |file|
  file.print items.to_json
end
