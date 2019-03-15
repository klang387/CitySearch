# CitySearch

## Challenge
A JSON file is given containing around 200k entries of city information.

- Display the cities on a scrollable list in alphabetical order (city first, country after)
  - "Denver, US" should appear before, "Sydney, Australia"
  - "Anaheim, US" should appear before "Denver, US"
- Be able to filter the results by a given prefix string, over the city.
- Selecting a city will show a map centered on the coordinates associated with the city.
- Optimize for fast searches, loading time of the app is not so important.
- Database implementations are forbidden

## Data Sample
```
[
  "country":"UA",
  "name":"Hurzuf",
  "_id":707860,
  "coord":[
    "lon":34.283333,
    "lat":44.549999
  ]
]
```

## Approach
### Matching
Using a trie structure for all the city names allows for very fast prefix matching, based on the user's input.  A full set of all the cities is also maintained at all times (after initial trie construction) to avoid needing to process the full trie every time the search parameter is emptied.

However, with such a large data set, when the first character of a new search was entered, there were so many matches, a lag still existed.  To overcome this, another stage of preprocessing was added.  Following trie construction, each letter of the alphabet is prefix-matched with the trie, and the results stored in a dictionary:
```
[Character : AllMatches]
```

This allows for a much more responsive UI.  The upfront, preprocessing cost is about 4 seconds (running on iPhone X), but eliminates the 0.25 - 1 second lag every time the search term is a single character.  Once beyond the first character, the result count is low enough to process the trie matches in real time.

### Mapping
The "City" data model holds the city name, country, and lat/long coordinates.  The initial trie only held characters, to match the city name.  A City property was added to the TrieNode class.  When bulding the tree, the terminating node of a city name gets assigned the corresponding City object.  This way, when finding matches, the City attached to each matching terminating node gets added to the array of results to be returned.  Now with both the name and coordinates easily accessible, the lat/long of the selected city can quickly be fed into the MKMapView to display.

