// var http = require('http');
// var libxmljs = require("libxmljs");

var fs = require('fs'),
    xml2js = require('xml2js');

var features = [];

var xmlParser = new xml2js.Parser();
fs.readFile(__dirname + '/nextbike.xml', function(err, data) {
    xmlParser.parseString(data, function (err, result) {
      markers = JSON.parse(JSON.stringify(result))['markers'];

      // countries
      var countries = markers.country;
      for (var i = countries.length - 1; i >= 0; i--) {
        // country
        var country = countries[i];

        // country.cities
        var cities = country.city;
        for (var i = cities.length - 1; i >= 0; i--) {
          // city
          var city = cities[i];

          // country.city.places
          var places = city.place;
          for (var i = places.length - 1; i >= 0; i--) {
            var place = places[i];
            console.log(place['$'].terminal_type);
          };
        };
      };

    });
});


// config
// var options = {
//   // host: '0.0.0.0',
//   // port: 8080,
//   // path: 'nextbike.xml',
//   host: 'nextbike.net',
//   port: 80,
//   path: '/maps/nextbike-live.xml?domains=fg'
// };

// var getGeoJsonFromXml = function getGeoJsonFromXml(xml) {
//   var xmlDoc = libxmljs.parseXml(xml);

//   console.log(xmlDoc);

//   var countries = xmlDoc.get('//country');
//   console.log(countries);
//   console.log(countries.length);

//   console.log('get GeoJson here...');
// };

// var request = http.request(options, function (res) {
//   var data = '';
//   res.on('data', function (chunk) {
//     data += chunk;
//   });
//   res.on('end', function () {
//     var geoJson = getGeoJsonFromXml(data);
//     console.log(geoJson);
//   });
// });
// request.on('error', function (e) {
//     console.log(e.message);
// });
// request.end();
