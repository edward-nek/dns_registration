# dns_registration

Flutter Application for DNS

Тестовое задание на Flutter(стажер)

Нужно создать приложение, которое формирует и отправляет заявку для участие в стажировке как мобильного разработчика на Flutter. Данное приложение является тестовым заданием для проверки необходимых для стажировки навыков. И никаким образом не будет использоваться для коммерческих целей.
Детали.

При запуске пользователь попадает на экран с формой ввода личных данных. На данном шаге нужно ввести фамилию, имя, отчество, e-mail, телефон.
Далее по кнопке "ПОЛУЧИТЬ КЛЮЧ", приложение запрашивает токен через API, используя введенные ранее данные.
После получения токена нужно перейти к форме для регистрации. Где пользователь указывает ссылки на резюме и на репозиторий github с исходным кодом данного задания. После чего отправляет токен, ссылки и контактные данные через второй метод API.

Спецификация API.

URL: https://vacancy.dns-shop.ru/
Описание: https://vacancy.dns-shop.ru/flutter/swagger/index.html

Все поля методов обязательны.
метод: POST /api/candidate/token - возвращает уникальное значение для комбинации входных параметров;

входные данные:
{
  "firstName": "string",
  "lastName": "string",
  "phone": "string",
  "email": "user@example.com"
}

выходные данные:
{
  "code": 0,
  "message": "string",
  "data": "string"
}

метод: POST /api/candidate/summary - отправляет данные для рассмотрения заявки;

headers:
conten-type: application/json
authorization: Bearer <token>

входные данные:
{
  "firstName": "string",
  "lastName": "string",
  "phone": "string",
  "email": "user@example.com",
  "githubProfileUrl": "string",
  "summary": "string"
}

выходные данные:
{
  "code": 0,
  "message": "string"
}

метод: POST /api/candidate/test/summary - тестовая отправка данных, для проверки работоспособности программы, регистрации на участие в данном случае не будет;

headers:
conten-type: application/json
authorization: Bearer <token>

входные данные:
{
  "firstName": "string",
  "surname": "string",
  "patronymic": "string",
  "phone": "string",
  "email": "user@example.com",
  "githubProfileUrl": "string",
  "summary": "string"
}

выходные данные:
{
  "code": 0,
  "message": "string"
}
