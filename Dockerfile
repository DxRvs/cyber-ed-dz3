FROM debian:12.7
#1 sources.list.d располагается в /etc/apt
#2 выбрано зеркало http://ftp.ru.debian.org/debian/, зеркал работающих через https в списке нет
#3 добавляем зеркало в debian.list	
RUN echo deb http://ftp.ru.debian.org/debian/ bookworm  main contrib non-free non-free-firmware >  /etc/apt/sources.list.d/debian.list
#4 Выполнить обновление apt-кеша
#5 Обновить все пакеты в контейнере
#6 Установить веб сервер nginx  
#7 Очистить скачанный apt-cache
RUN apt-get update && apt-get install -y  && apt-get install nginx -y && apt-get clean
#8 Удалить содержимое директории /var/www/
RUN rm -rf /var/www/
#9 Создать в директории /var/www/ директорию с именем вашего сайта и папку с картинками (company.com/img)
RUN mkdir -p /var/www/company.com/img
#10 Поместить из папки с докер файлом в директорию /var/www/company.com файл index.html
COPY index.html /var/www/company.com/
#11 Поместить из папки с докер файлом в директорию /var/www/company.com/img файл img.jpg
COPY img.jpg /var/www/company.com/img/
#12 Задать рекурсивно на папку /var/www/company.com права "владельцу - читать, писать, исполнять; группе - читать, исполнять, остальным - только читать"
RUN chmod -R 754 /var/www/company.com
#13 С помощью команды useradd создать пользователя <ваше имя>
RUN adduser dima
#14 С помощью команды groupadd создать группу <ваша фамилия>
RUN groupadd frolov 
#15. С помощью команды usermod поместить пользователя <ваше имя> в группу <ваша фамилия>
RUN usermod -aG frolov dima
#16 Рекурсивно присвоить созданных пользователя и группу на папку /var/www/company.com
RUN chown -R dima:frolov /var/www/company.com
#17 Воспользоваться конструкцией (sed -i 's/ЧТО ЗАМЕНИТЬ/НА ЧТО ЗАМЕНИТЬ/g' имя_файла) и заменить в файле /etc/nginx/sites-enabled/default следующую подстроку (/var/www/html) так, чтобы она соответствовала (/var/www/company.com) (Д)
RUN sed -i 's|/var/www/html|/var/www/company.com|g' /etc/nginx/sites-enabled/default
#18 С помощью команды grep найти в каком файле задается пользователь (user), от которого запускается nginx (К)
# задаётся в файле /etc/nginx/nginx.conf
#19 С помощью команды sed проделать операцию замены пользователя в файле найденном в пункте 17 на вашего пользователя
RUN sed -i 's|www-data|dima|g' /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

