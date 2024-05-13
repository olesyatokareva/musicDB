--Создадим триггерную функцию, которая будет присоединять к добавленному имени пользователя '@gmail.com' и записывать результат в поле email.

CREATE FUNCTION email()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
BEGIN
NEW.email = NEW.user_name || '@gmail.com';
RETURN NEW;
END;
$$

--Свяжем ее с таблицей. Срабатывать триггерная функция будет после заполнения строки user_name.

CREATE TRIGGER email_ch
BEFORE INSERT ON users
FOR EACH ROW
EXECUTE PROCEDURE email();
