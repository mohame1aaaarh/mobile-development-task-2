# Mini Product Catalog

تطبيق Flutter صغير فيه 3 شاشات: **Login → Products → Product Details**، مبني طبقاً لمتطلبات التاسك (Lifecycle / Navigator / go_router).

## الفكرة
- تسجيل دخول (اسم المستخدم "Guest") يفتح صفحة المنتجات.
- صفحة المنتجات فيها عداد Favorites، وكل منتج له قلب ويفتح صفحة التفاصيل.
- صفحة التفاصيل فيها زر "Add to Cart" ويرجع رسالة تظهر على صفحة المنتجات.
- شاشة المنتجات بتتغير من List إلى Grid لما عرض الشاشة يوصل 600 (MediaQuery).

## هيكل المشروع
```
lib/
├── main.dart            ← التطبيق كامل (go_router شغال + نسخة Navigator معلقة)
└── product_widgets.dart ← ملف المساعد المعطى بالتاسك (ListView / GridView جاهزين)
```

## Routes (go_router)
| Route | الشاشة | ملاحظات |
|---|---|---|
| `/` | LoginPage | |
| `/products?user=Guest` | ProductsPage | query parameter لاسم المستخدم |
| `/details/:name/:price` | DetailsPage | path parameters الاسم والسعر |

- Login → Products: `context.goNamed` (عشان مش يرجع للوجين).
- Products → Details: `context.push` + `await` لاستلام النتيجة.
- Details → خروج: `context.pop("... added to cart")`.

## Lifecycle (Part 1)
كل الصفحات Stateful وتعمل override للـ 5 methods مع print:
`initState` / `didChangeDependencies` / `build` / `deactivate` / `dispose` — وتجربتها موجودة في الكونسول (لقطاتها مرفقة مع التسليم)، وإجابات أسئلة الجزء الأول والرابع في تعليق أعلى `main.dart`.

## التشغيل
```bash
flutter pub get
flutter run -d linux   # أو -d web-server لتجربة resize المتصفح
```
