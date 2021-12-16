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

**ScreenShots**
<img width="304" alt="Screen Shot 2021-12-15 at 10 32 02 PM" src="https://user-images.githubusercontent.com/67339434/146303324-20b80351-bf2d-47f8-b940-f5fc2fd35c92.png">

<img width="373" alt="Screen Shot 2021-12-15 at 10 32 57 PM" src="https://user-images.githubusercontent.com/67339434/146303402-075b59e2-fe3e-4631-bf50-163866e510e8.png">

<img width="364" alt="Screen Shot 2021-12-15 at 10 34 06 PM" src="https://user-images.githubusercontent.com/67339434/146303519-d0e4b8ac-a932-4c5d-83b7-8ac411de18bb.png">

<img width="366" alt="Screen Shot 2021-12-15 at 10 33 47 PM" src="https://user-images.githubusercontent.com/67339434/146303483-19bd7ff1-f6e8-4b6d-a3b6-0268c40bba3d.png">


