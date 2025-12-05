# flutter_otp_v1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Comandos para correr en ambiente

# Desarrollo

flutter run \
  --dart-define=ENV=dev \
  --dart-define=API_BASE=https://dev.api.consorcio.cl \
  --dart-define=PUBLIC_KEY_PEM="-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyNGTqmsW76v4pIxHLhyY\nHz+FXx7YTXcZ+Bjw1URBJNSwkpZZoq0Q89Ba+w3QkjbzOuCiNErJR1CO3WtpgOmt\nY+OgF5lp8zvTE9lnEngfrcXZc4N+iT6RiT0IpaMlpc7wjYzCjHOXtxKfzQ3Rd8vx\n6QYqIitQNoKwH/4fyUmzrqMAIXW4QqmHpAT1U8CKCeoLiHwR6DBGfisbJFdFHrl1\njdlQk3/s/O8WvnzOJ+qcB8HIjZCDFjxRGWSOspw3yq/lXnHUJYXoBwnO6mgPlI46\nnUtxgsXU2lYgGE5MXqODjY/y8BzEEaGLRiYtZwwfGhs/pERipgYaxhpOwnmwINsz\ndwIDAQAB\n-----END PUBLIC KEY-----"


# QA / Testing
flutter run \
  --dart-define=ENV=qa \
  --dart-define=API_BASE=https://qa.api.consorcio.cl \
  --dart-define=PUBLIC_KEY_PEM="-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyNGTqmsW76v4pIxHLhyY\nHz+FXx7YTXcZ+Bjw1URBJNSwkpZZoq0Q89Ba+w3QkjbzOuCiNErJR1CO3WtpgOmt\nY+OgF5lp8zvTE9lnEngfrcXZc4N+iT6RiT0IpaMlpc7wjYzCjHOXtxKfzQ3Rd8vx\n6QYqIitQNoKwH/4fyUmzrqMAIXW4QqmHpAT1U8CKCeoLiHwR6DBGfisbJFdFHrl1\njdlQk3/s/O8WvnzOJ+qcB8HIjZCDFjxRGWSOspw3yq/lXnHUJYXoBwnO6mgPlI46\nnUtxgsXU2lYgGE5MXqODjY/y8BzEEaGLRiYtZwwfGhs/pERipgYaxhpOwnmwINsz\ndwIDAQAB\n-----END PUBLIC KEY-----"

# Producción
flutter run --dart-define=ENV=prod --dart-define=API_BASE=https://servicios.bancoconsorcio.cl --dart-define=PUBLIC_KEY_PEM_BASE64="LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUF6N2RFand0Y3pqVWxxMUNjbFFvdwovSmYzbG5ySHYvN0lzU3BpVTdqeGoyaHpzanVXcHp0L2ZoMk4zVEVjVkM3bXp0MDdZdnlmSjZVTnpFMXZMNGRLCldHUUhNUU5mTjNEY0tUdmFFaHRJZTB3MEJMQWVUb2w4d05wRVRaM3ZUL00yQTFybzRwWXVhVHBCbWdSK2dQZVIKeldQSW1lT2JKTmd0T01qM2E3bTV5NndlL0Z1YWt0VVI1dTFNeXd6NTJoMWlJWVZLRWprMkhDSjEwNkhyN3FSUwovZXNueDM5R3NoRjdGWTgxQ1FablgrZ3hxNXNSRUJlZ2N2b1dkYlZYR2oxYkZlWXk3TXFETkJvM3AzZWN1MHdTCnRPc3l0TDVkU0hXdDJJMjJ2TytSQW1SVHUxZWNjd1NnczFLb3diWHJPTUdwVmU2MGZWM2F6YkkzaVJyaGZzY04KTHdJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0t"

# Generar APK

# Producción 
flutter build apk --release --dart-define=ENV=prod --dart-define=API_BASE=https://servicios.bancoconsorcio.cl --dart-define=AES_KEY="KaNdRgUkXp2s5v8y" --dart-define=AES_IV="encryptionBcnsVe" --dart-define=CODIGO_APLICACION=121 --dart-define=CODIGO_CANAL=1 --dart-define=EMPRESA_APLICACION=Interno --dart-define=MODALIDAD=generar --dart-define=PUBLIC_KEY_PEM_BASE64="LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUF6N2RFand0Y3pqVWxxMUNjbFFvdwovSmYzbG5ySHYvN0lzU3BpVTdqeGoyaHpzanVXcHp0L2ZoMk4zVEVjVkM3bXp0MDdZdnlmSjZVTnpFMXZMNGRLCldHUUhNUU5mTjNEY0tUdmFFaHRJZTB3MEJMQWVUb2w4d05wRVRaM3ZUL00yQTFybzRwWXVhVHBCbWdSK2dQZVIKeldQSW1lT2JKTmd0T01qM2E3bTV5NndlL0Z1YWt0VVI1dTFNeXd6NTJoMWlJWVZLRWprMkhDSjEwNkhyN3FSUwovZXNueDM5R3NoRjdGWTgxQ1FablgrZ3hxNXNSRUJlZ2N2b1dkYlZYR2oxYkZlWXk3TXFETkJvM3AzZWN1MHdTCnRPc3l0TDVkU0hXdDJJMjJ2TytSQW1SVHUxZWNjd1NnczFLb3diWHJPTUdwVmU2MGZWM2F6YkkzaVJyaGZzY04KTHdJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0t"

# Instalar apk con ADB
adb install -r build/app/outputs/flutter-apk/app-release.apk