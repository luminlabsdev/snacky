# Snackbar

The snackbar object, allows for manipulation of the snackbar.

## Properties

### BroadcastArea

The area the snackbar should be broadcasted in.

* **number**

---

### BroadcastStyle

The style of the in/out animation is given.

* **number**

---

### BroadcastText

The current broadcast text.

* **string**

---

### CurrentBroadcastCancelled

Whether or not the current broadcast was cancelled.

* **boolean**

---

### CurrentlyBroadcasting

Whether or not the snackbar is currently being broadcasted.

* **boolean**

## Methods

### SetStyle

Sets the style of the snackbar, allowing access to additional properties like text color or font.

#### Parameters

* **properties:** `{ [string]: any }`\
The style properties to which the snackbar should be set to

#### Returns

* **void**

---

### SetOrder

Sets the layout order of a snackbar, potentially allowing one to be anchored at any location.

#### Parameters

* **order:** `number`\
The layout order that the snackbar should be at

#### Returns

* **void**

---

### BindToActivated

Binds a function to activation, which is when the snackbar is clicked by the user.

#### Parameters

* **func:** `(inputType: Enum.UserInputType) -> ()`\
The function that should run on activation

#### Returns

* **void**

---

### UnbindFromActivated

Unbinds the function set to run when activated, if one is set.

#### Returns

* **void**

---

### CancelBroadcast

Cancels the current broadcast if any, which will play the out animation and set neccasary properties regardless of time left to be shown for.

#### Parameters

* **destroy:** `boolean?`\
Whether the snackbar should be destroyed after finishing the animation

#### Returns

* **void**

---

### Broadcast

Broadcasts the hint to the current user, attempting to broadcast multiple times will not clone the GUI object and will ignore further requests.

#### Parameters

* **broadcastText:** `string`\
The text that should be displayed on the GUI object upon broadcast

* **broadcastTime:** `number?`\
The amount of seconds the snackbar should stay up for, leave this nil for infinite time

* **destroyWhenFinished:** `boolean?`\
Whether or not to destroy the hint when it's finished broadcasting, disabled by default

#### Returns

* **void**

---

### Destroy

Destroys the snackbar.

#### Returns

* **void**

## Events

### BroadcastFinished

Fires when the broadcast has finished (before the out animation plays).

---

### BroadcastStarted

Fires when the broadcast has started (before the in animation plays).

#### Parameters

* **broadcastText:** `string`\
The text that was set for the broadcast

* **broadcastTime:** `string`\
The amount of time the snackbar is set to broadcast for

---

### BroadcastCancelled

Fires when the broadcast has been cancelled, [`BroadcastFinished`](#broadcastfinished) will not fire and instead this will when cancelled.