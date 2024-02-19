# batched-promise-all

:flight_departure: zero deps utility for keeping your memory footprint manageable with varying datasets

## Get started

```
yarn add batched-promise-all
npm i batched-promise-all
```

### Usage

```ts
import { batchedPromiseAll } from 'batched-promise-all'

const array = ['a', 'b', 'c', 'd', 'e', 'f', 'g']

const r = await batchedPromiseAll(
  // this will be 4x slower and consume 1/4 of memory compared to the Promise.all(array.map(...))
  array,
  async (item, index) => {
    // your iterator callback-same as you would use for .map method on your array
    await delay()
    return [item, index]
  },
  2 // batch size
)
```

### Why would you use this?

When dealing with big data sets awaiting thousands of promises at once can easily make your node.js process run out of memory-especially if you're running on small instances. Using batched-promise-all you can avoid this easily with a single import.
