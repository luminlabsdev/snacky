# Snacky

Responsible for creating snackbars.

## Functions

### `new`

Creates a new snackbar

#### Parameters

* **name:** `string`\
The name of the snackbar

* **area:** `BroadcastArea?`\
The location where the snackbar will always be broadcasted to

* **style:** `BroadcastStyle`\
The way that the broadcast is done, either animated or statically

* **tweenTime:** `number?`\
How long both of the tweens are if animations are enabled

* **tweenStyle:** `Enum.EasingStyle?`\
The way that the animation will appear on any broadcast

#### Returns

* **[Snackbar](/api/snackbar)**