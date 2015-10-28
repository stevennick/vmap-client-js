# VMAP Javascript Client

[![Build Status](https://travis-ci.org/stevennick/vmap-client-js.png)](https://travis-ci.org/stevennick/vmap-client-js)

A javascript client for parsing VMAP document.

## Usage
This library is depend on specialized version of vast-client-js, which support parse VAST documents directly from DOM tree rather than HTTP url.

Before our release become stable, you can get this library from [stevennick/vast-client-js](https://github.com/stevennick/vast-client-js)

```javascript
VMAP.client.get('/test/PlayerTestVMAP.xml', null, function(cb) {
    // Do vmap related operations
    console.log(JSON.stringify(cb));
    var adBreaks = cb.adbreaks;
    for (var index=0; index < adBreaks.length; index++) {
        if (adBreaks[index].isWrapper == false && adBreaks[index].vastAdData != undefined) {
            DMVAST.client.parse(adBreaks[index].vastAdData[1], adBreaks[index].vastAdData[0].baseURI, null, function(vast) {
                // Do vast related operations
                console.log(JSON.stringify(vast));
            });
        }
    }
});
```

### Development & Contributing

Make sure you have executed `npm install` after clone this project. This step is need to exetuce only once.

## Build

After install all required dependencies, type:

> npm run-script bundle

To update binary code.

## Testing

> npm test


