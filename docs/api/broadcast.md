# Broadcast

The broadcast object, returned by a broadcast and allows you to configure it

## Methods

### `Cancel`

Cancels the current broadcast which was returned by its parent function. Plays any animations and gets removed from memory, and fires `BroadcastCancelled`.

#### Returns

* **void**

---

## Events

### `BroadcastFinished`

Fires when the broadcast has finished (after the out animation plays).

---

### `BroadcastCancelled`

Fires when the broadcast has been cancelled, [`BroadcastFinished`](#broadcastfinished) will not fire and instead this will when cancelled.