# Blossom
Blossom is an OpenStreetMap client for Pharo using the Bloc UI.

It was inspired by [https://github.com/fstephany/OSMMaps](https://github.com/fstephany/OSMMaps) and realized by Claude Code.

## Installation

```smalltalk
Metacello new
	baseline: 'Blossom';
	repository: 'github://NicolasAnquetil/Blossom:main/src';
	load.
```

## Quick start

Ready-made examples:

- `BLSMMapElement exampleParisWithMarker`
- `BLSMMapElement exampleTopoMap`: topological map (openTopoMap)
- `BLSMMapElement exampleHistoricalParis`: historical map (Paris in 1750)

Open a map of Paris at zoom level 13 in a new window:

```smalltalk
| map space |
map := BLSMMapElement on: (BLSMCoordinate lat: 48.8566 lon: 2.3522) zoom: 13.
space := BlSpace new.
space extent: 800 @ 600.
space root addChild: map.
space show.
```

