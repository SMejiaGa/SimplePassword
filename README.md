# SimplePassword

- SimplePassword es una aplicacion para iOS que estoy desarrollando para aplicar conocimientos en el sector mobile.

- La aplicacion se dedica a guardar de forma segura las contraseñas, maneja notificaciones locales,  
usa confirmaciones atraves de la autenticacion con los biometrics que tu dispositivo y 
maneja Keychain para evitar a toda costa la violacion o divulgacion de alguna de estas.

## Arquitectura

### Se utiliza mvvm
- Se hace con el fin de desacoplar totalmente la vista de la logica de negocio.
- Separar cada posible pantalla con un viewmodel permite el soporte individual por pantalla.
## Desarrollo
- No se usan Storyboards
- Las funcionalidades complejas se separan de los viewmodel para ser reutilizadas en todo la aplicacion

## Estructura

- SimplePassword
- - **Scenes**
- - - **Login**
- - - - **LoginViewModel**
- - - - **LoginViewControllerr**
- - - - **LoginViewControllerr.xib**
- - **Commons**
- - - **Security**
- - - - **BiometricsHandler**
- - - - **SecureDataStorage**
- - - - **AccountsStorage**
- - - - **LocalNotifications**
- - - - **Account**
