# ETL_customer_retention

### Описание проекта 
ETL для интернет магазина .Необходимо постороить витрину для изучения возвращаемости клиентов и выявить категории товаров ,которые лучше всего удерживают клиентов.
ETL-процесс реализован с помощью оркестратора Airflow.

### Навыки и инструменты
* Airflow DAG
* Python : requests, json, pandas
* SQL : джоины, подзапросы, агрегатные функции 

### Общий вывод
Реализован ETL процесс:
- В рамках этапа Extract:
   - запрос через API на генерацию файлов
   - подключение к хранилищу Amazon S3 и загрузка файлов
- В рамках этапа Transform:
   - преобразование файловых данных в табличный вид
- В рамках этапа Load:
   - загрузка табличных данных в Staging-слой
   - инкрементарная загрузка данных из Staging-слоя в слой витрин

Итоговая витрина для аналитики поможет выявить категории товаров,которые лучше всего удерживают клиентов
