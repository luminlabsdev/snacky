# Snackbar

The snackbar object, allows for manipulation of the snackbar.

## Properties

### `BroadcastArea`

The area the snackbar should be broadcasted in.

* **number**

---

### `BroadcastStyle`

The style of the in/out animation is given.

* **number**

---

### `CurrentlyBroadcasting`

A table of all the currently broadcasting elements.

* **{ TextButton }**

## Methods

### `SetStyle`

Sets the style of the snackbar, allowing access to additional properties like text color or font.

#### Parameters

* **properties:** `{ [string]: any }`\
The style properties to which the snackbar should be set to

#### Returns

* **void**

---

### `SetOrder`

Sets the layout order of a snackbar, potentially allowing one to be anchored at any location.

#### Parameters

* **order:** `number`\
The layout order that the snackbar should be at

#### Returns

* **void**

---

### `Broadcast`

Broadcasts the hint to the current user, attempting to broadcast multiple times will not clone the GUI object and will ignore further requests.

#### Parameters

* **broadcastText:** `string`\
The text that should be displayed on the GUI object upon broadcast

* **broadcastTime:** `number?`\
The amount of seconds the snackbar should stay up for, leave this nil for infinite time

* **allowActivation:** `boolean?`\
Allows the snackbar to be interacted with, for only the current broadcast

#### Returns

* [**Broadcast**](/api/broadcast)

---

### `Destroy`

Destroys the snackbar.

#### Returns

* **void**

## Events

### BroadcastStarted

Fires when the broadcast has started (before the in animation plays).

#### Parameters

* **broadcastText:** `string`\
The text that was set for the broadcast

* **broadcastTime:** `string`\
The amount of time the snackbar is set to broadcast for