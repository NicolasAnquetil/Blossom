# Using Blossom

All the snippets below assume `map` is a `BLSMMapElement`, for example:

```smalltalk
map := BLSMMapElement on: (BLSMCoordinate lat: 48.8566 lon: 2.3522) zoom: 13.
```

## Loading options

Blossom was developed on Pharo 14 and depends on [Bloc](https://github.com/pharo-graphics/Bloc) (v2.9.0 a the time).

The baseline defines the groups `Core` (the `Blossom` package) and `Tests` (`Blossom-Tests`).
`default` loads both. To load only the library:

```smalltalk
Metacello new
	baseline: 'Blossom';
	repository: 'github://NicolasAnquetil/Blossom:main/src';
	load: 'Core'.
```

## Navigating

With the mouse: drag to pan, use the wheel to zoom. The point under the cursor stays in place while zooming.

From code:

```smalltalk
map zoomIn; zoomOut.
map zoom: 15.
map centerOn: (BLSMCoordinate lat: 45.764 lon: 4.8357).
map panBy: 100 @ 0.   "pixels"
```

## Markers

```smalltalk
map addMarkerAt: (BLSMCoordinate lat: 48.8584 lon: 2.2945).
```

Markers stay attached to their coordinate when the map is panned or zoomed.

## Choosing a tile server

`BLSMConfiguration` describes a tile server: its URL template, attribution and maximum zoom. Presets:

| Preset | Server |
|---|---|
| `BLSMConfiguration openStreetMap` (the default) | tile.openstreetmap.org |
| `BLSMConfiguration humanitarian` | Humanitarian OSM Team style |
| `BLSMConfiguration openTopoMap` | OpenTopoMap (max zoom 17) |
| `BLSMConfiguration cyclOSM` | CyclOSM |
| `BLSMConfiguration openHistoricalMap` | OpenHistoricalMap (vector tiles) |

`BLSMConfiguration presets` answers them all by display name.

```smalltalk
map configuration: BLSMConfiguration openTopoMap.
```

The attribution shown in the corner of the map follows the configuration.

## Your own server or account

```smalltalk
| config |
config := BLSMConfiguration urlTemplate: 'https://{s}.tile.example.com/{z}/{x}/{y}.png'.
config
	subdomains: #( 'a' 'b' 'c' );
	maxZoom: 18;
	attribution: '© Example contributors';
	userAgent: 'MyApp/1.0 (me@example.com)';
	apiKey: 'my-key'.          "appended as ?apikey=..."
"or: config accessToken: 'my-token'   (sent as Authorization: Bearer ...)"
map configuration: config.
```

The URL template understands `{s}` (subdomain), `{z}`, `{x}` and `{y}`.

## Historical maps

[OpenHistoricalMap](https://www.openhistoricalmap.org) serves vector tiles, which Blossom decodes and draws itself. Choose the year to display:

```smalltalk
map configuration: BLSMConfiguration openHistoricalMap.
map year: 1750.
map year: 1900.
map year: nil.   "every period at once"
```

Only features that existed in that year are drawn.

## Tile usage policy

The public OpenStreetMap servers have a [tile usage policy](https://operations.osmfoundation.org/policies/tiles/): no heavy use, and a User-Agent that identifies your application. Blossom keeps tiles in an in-memory cache and sends `Blossom/0.1 (Pharo OpenStreetMap viewer)` by default. If you build an application on Blossom, set your own `userAgent:`.

