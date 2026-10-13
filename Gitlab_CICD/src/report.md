# DO6_CICD

## Part 1.Настройка gitlab-runner

- Поднимаем виртуальную машину Ubuntu Server 24.04 LTS.

![cicd](images/cicd_1.1.png)

- Скачаваем и установливаем на виртуальную машину gitlab-runner.

![cicd](images/cicd_1.2.png)

- Запускаем gitlab-runner и зарегистрируем его для использования в текущем проекте (DO6_CICD).

![cicd](images/cicd_1.3.png)
![cicd](images/cicd_1.4.png)

## Part 2.Сборка

- Пишем этап для CI по сборке приложения из папки code-samples DO.
- В файле .gitlab-ci.yml добавляем этап запуска сборки через мейк файл из папки code-samples.

![cicd](images/cicd_2.1.png)
![cicd](images/cicd_2.2.png)
![cicd](images/cicd_2.3.png)

## Part 3.Тест кодстайла

- Пишем этап для CI, который запускает скрипт кодстайла (clang-format).

![cicd](images/cicd_3.1.png)

- Если кодстайл не прошел, то «зафейли» пайплайн.

![cicd](images/cicd_3.2.png)
![cicd](images/cicd_3.3.png)
![cicd](images/cicd_3.4.png)

- В пайплайне отображаем вывод утилиты clang-format.

![cicd](images/cicd_3.5.png)
![cicd](images/cicd_3.6.png)

## Part 4.Интеграционные тесты

- Для проекта из папки code-samples пишем интеграционные тесты самостоятельно. Тесты могут быть написаны на любом языке (c, bash, python и т.д.) и должны вызывать собранное приложение для проверки его работоспособности на разных случаях.

![cicd](images/cicd_4.1.png)

- Запускаем этот этап автоматически только при условии, если сборка и тест кодстайла прошли успешно.

![cicd](images/cicd_4.2.png)
![cicd](images/cicd_4.3.png)

- Если тесты не прошли, то «зафейлим» пайплайн.
- В пайплайне отображаем вывод, что интеграционные тесты успешно прошли / провалились.

![cicd](images/cicd_4.4.png)
![cicd](images/cicd_4.5.png)

## Part 5.Этап деплоя

- Поднимаем вторую виртуальную машину Ubuntu Server 24.04 LTS.

![cicd](images/cicd_5.1.png)
![cicd](images/cicd_5.2.png)
![cicd](images/cicd_5.3.png)
![cicd](images/cicd_5.4.png)
![cicd](images/cicd_5.5.png)
![cicd](images/cicd_5.6.png)

- Пишем этап для CD, который «разворачивает» проект на другой виртуальной машине.

![cicd](images/cicd_5.7.png)

- Пишем bash-скрипт, который при помощи ssh и scp копирует файлы, полученные после сборки (артефакты), в директорию /usr/local/bin второй виртуальной машины

![cicd](images/cicd_5.8.png)

- Запускаем этот этап вручную при условии, что все предыдущие этапы прошли успешно.

![cicd](images/cicd_5.9.png)
![cicd](images/cicd_5.10.png)
![cicd](images/cicd_5.11.png)

- В результате получаем готовое к работе приложение из папки code-samples (DO) на второй виртуальной машине.

![cicd](images/cicd_5.12.png)