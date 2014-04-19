
# oxford3k

## Source

[The Oxford 3000™](http://www.oxfordlearnersdictionaries.com/wordlist/english/oxford3000/ox3k_A-B/)

## Usage

`oxford3k` function will return a [promise](https://github.com/kriskowal/q#tutorial).

```coffee
oxford3k = require 'oxford3k'

oxford3k().then (words) ->
  console.log words
.catch (err) ->
  console.log err
```

## Scheme

```javascript
{
  "A-B": [ /* words... */ ],
  "C-D": [ /* words... */ ],
  /* ... */
  "S": [ /* words... */ ],
  /* ... */
}
```

