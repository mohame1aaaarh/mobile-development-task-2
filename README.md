# Mini Product Catalog

A small Flutter app with three screens: Login, Products, and Product Details.
Made for the Mobile Development course (Task 3).

## Features
- Login screen that opens the products page as "Guest"
- Products page with a favorites counter and a heart button on each product
- Layout switches between a list and a grid depending on screen width (600px)
- Details page with an "Add to Cart" button that sends a message back to the products page

## Navigation
Navigation is done with go_router. The old Navigator version is still in
`main.dart`, commented out.

| Route | Screen |
|---|---|
| `/` | Login |
| `/products?user=Guest` | Products |
| `/details/:name/:price` | Details |

## Run
```
flutter pub get
flutter run -d linux
```

## Notes
- Answers to the lifecycle and go_router questions are in the comment at the top of `main.dart`.
- `product_widgets.dart` is the helper file provided with the task.
