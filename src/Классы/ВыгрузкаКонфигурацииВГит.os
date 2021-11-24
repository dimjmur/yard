// ----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------
// Codebase: https://github.com/ArKuznetsov/yard/
// ----------------------------------------------------------

#Использовать v8runner
#Использовать gitrunner
#Использовать tempfiles
#Использовать fs

Перем МенеджерОбработкиДанных;  // ВнешняяОбработкаОбъект - обработка-менеджер, вызвавшая данный обработчик
Перем Идентификатор;            // Строка                 - идентификатор обработчика, заданный обработкой-менеджером
Перем ПараметрыОбработки;       // Структура              - параметры обработки
Перем ГитРепозиторий;           // Объект                 - объект управления репозитарием GIT
Перем Лог;                      // Объект                 - объект записи лога приложения

Перем ВерсияПлатформы;          // Строка                 - маска версии платформы 1С (8.3, 8.3.6 и т.п.)
Перем ПутьККонфигурации;        // Строка                 - путь к файлу конфигурации (CF) для выгрузки
Перем РепозитарийГит;           // Строка                 - путь к репозитарию git
Перем ИмяВеткиГит;              // Строка                 - имя ветки git в которую будет выполняться выгрузка
Перем ИмяАвтора;                // Строка                 - имя автора коммита в git
Перем ПочтаАвтора;              // Строка                 - почта автора коммита в git
Перем ДатаКоммита;              // Строка                 - дата коммита в git в формате POSIX
Перем СообщениеКоммита;         // Строка                 - сообщение коммита в git
Перем База_СтрокаСоединения;    // Строка                 - строка соединения служебной базы 1С
Перем КонвертироватьВФорматЕДТ;	// Булево                 - конвертацировать в формат ЕДТ
Перем ОтносительныйПуть;		// Строка                 - относительный путь к исходникам внутри репозитория
//                          для выполнения выгрузки

Перем НакопленныеДанные;        // Массив(Структура)      - результаты обработки данных

#Область ПрограммныйИнтерфейс

// Функция - признак возможности обработки, принимать входящие данные
// 
// Возвращаемое значение:
//	Булево - Истина - обработка может принимать входящие данные для обработки;
//	         Ложь - обработка не принимает входящие данные;
//
Функция ПринимаетДанные() Экспорт
	
	Возврат Ложь;
	
КонецФункции // ПринимаетДанные()

// Функция - признак возможности обработки, возвращать обработанные данные
// 
// Возвращаемое значение:
//	Булево - Истина - обработка может возвращать обработанные данные;
//	         Ложь - обработка не возвращает данные;
//
Функция ВозвращаетДанные() Экспорт
	
	Возврат Истина;
	
КонецФункции // ВозвращаетДанные()

// Функция - возвращает список параметров обработки
// 
// Возвращаемое значение:
//	Структура                                - структура входящих параметров обработки
//      *Тип                    - Строка         - тип параметра
//      *Обязательный           - Булево         - Истина - параметр обязателен
//      *ЗначениеПоУмолчанию    - Произвольный   - значение параметра по умолчанию
//      *Описание               - Строка         - описание параметра
//
Функция ОписаниеПараметров() Экспорт
	
	Параметры = Новый Структура();
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "ВерсияПлатформы",
	                          "Строка",
	                          Ложь,
	                          "8.3",
	                          "маска версии платформы 1С (8.3, 8.3.6 и т.п.)");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ПутьККонфигурации",
	                          "Строка",
	                          Истина,
	                          "",
	                          "путь к файлу конфигурации (CF) для выгрузки");

	ДобавитьОписаниеПараметра(Параметры,
	                          "РепозитарийГит",
	                          "Строка",
	                          Истина,
	                          "",
	                          "путь к репозитарию git");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ИмяВеткиГит",
	                          "Строка",
	                          Ложь,
	                          "base1c",
	                          "имя ветки git в которую будет выполняться выгрузка");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ИмяАвтора",
	                          "Строка",
	                          Ложь,
	                          "1c",
	                          "имя автора коммита в git");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ПочтаАвтора",
	                          "Строка",
	                          Ложь,
	                          "1c@1c.ru",
	                          "почта автора коммита в git");

	ДобавитьОписаниеПараметра(Параметры,
	                          "ДатаКоммита",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "дата коммита в git в формате POSIX");

	ДобавитьОписаниеПараметра(Параметры,
	                          "СообщениеКоммита",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "сообщение коммита в git");
	
							  
	ДобавитьОписаниеПараметра(Параметры,
	                          "База_СтрокаСоединения",
	                          "Строка",
	                          Ложь,
	                          "",
	                          "строка соединения служебной базы 1С для выполнения выгрузки");
							  
	ДобавитьОписаниеПараметра(Параметры,
							"КонвертироватьВФорматЕДТ",
							"Булево",
							Ложь,
							Ложь,
							"Конвертировать в формат ЕДТ");	
	
	ДобавитьОписаниеПараметра(Параметры,
							"ОтносительныйПуть",
							"Строка",
							Ложь,
							"",
							"Относительный путь исходников внутри репозитория");
	Возврат Параметры;
	
КонецФункции // ОписаниеПараметров()

// Функция - Возвращает обработку - менеджер
// 
// Возвращаемое значение:
//	ВнешняяОбработкаОбъект - обработка-менеджер
//
Функция МенеджерОбработкиДанных() Экспорт
	
	Возврат МенеджерОбработкиДанных;
	
КонецФункции // МенеджерОбработкиДанных()

// Процедура - Устанавливает обработку - менеджер
//
// Параметры:
//	НовыйМенеджерОбработкиДанных      - ВнешняяОбработкаОбъект - обработка-менеджер
//
Процедура УстановитьМенеджерОбработкиДанных(Знач НовыйМенеджерОбработкиДанных) Экспорт
	
	МенеджерОбработкиДанных = НовыйМенеджерОбработкиДанных;
	
КонецПроцедуры // УстановитьМенеджерОбработкиДанных()

// Функция - Возвращает идентификатор обработчика
// 
// Возвращаемое значение:
//	Строка - идентификатор обработчика
//
Функция Идентификатор() Экспорт
	
	Возврат Идентификатор;
	
КонецФункции // Идентификатор()

// Процедура - Устанавливает идентификатор обработчика
//
// Параметры:
//	НовыйИдентификатор      - Строка - новый идентификатор обработчика
//
Процедура УстановитьИдентификатор(Знач НовыйИдентификатор) Экспорт
	
	Идентификатор = НовыйИдентификатор;
	
КонецПроцедуры // УстановитьИдентификатор()

// Функция - Возвращает значения параметров обработки
// 
// Возвращаемое значение:
//	Структура - параметры обработки
//
Функция ПараметрыОбработкиДанных() Экспорт
	
	Возврат ПараметрыОбработки;
	
КонецФункции // ПараметрыОбработкиДанных()

// Процедура - Устанавливает значения параметров обработки данных
//
// Параметры:
//	НовыеПараметры      - Структура     - значения параметров обработки
//
Процедура УстановитьПараметрыОбработкиДанных(Знач НовыеПараметры) Экспорт
	
	ПараметрыОбработки = НовыеПараметры;
	
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ВерсияПлатформы"      	, ПараметрыОбработки, "8.3");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПутьККонфигурации"    	, ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("РепозитарийГит"       	, ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ИмяВеткиГит"          	, ПараметрыОбработки, "base1c");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ИмяАвтора"            	, ПараметрыОбработки, "1c");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ПочтаАвтора"          	, ПараметрыОбработки, "1c@1c.ru");
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ДатаКоммита"          	, ПараметрыОбработки,
	                                             Служебный.ДатаPOSIX(ТекущаяУниверсальнаяДата()));
	УстановитьПараметрОбработкиДанныхИзСтруктуры("СообщениеКоммита"     	, ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("База_СтрокаСоединения"	, ПараметрыОбработки);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("КонвертироватьВФорматЕДТ"	, ПараметрыОбработки, Ложь);
	УстановитьПараметрОбработкиДанныхИзСтруктуры("ОтносительныйПуть"		, ПараметрыОбработки);

КонецПроцедуры // УстановитьПараметрыОбработкиДанных()

// Функция - Возвращает значение параметра обработки данных
// 
// Параметры:
//	ИмяПараметра      - Строка           - имя получаемого параметра
//
// Возвращаемое значение:
//	Произвольный      - значение параметра
//
Функция ПараметрОбработкиДанных(Знач ИмяПараметра) Экспорт
	
	Если НЕ ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ ПараметрыОбработки.Свойство(ИмяПараметра) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПараметрыОбработки[ИмяПараметра];
	
КонецФункции // ПараметрОбработкиДанных()

// Процедура - Устанавливает значение параметра обработки
//
// Параметры:
//	ИмяПараметра      - Строка           - имя устанавливаемого параметра
//	Значение          - Произвольный     - новое значение параметра
//
Процедура УстановитьПараметрОбработкиДанных(Знач ИмяПараметра, Знач Значение) Экспорт
	
	Если НЕ ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
		ПараметрыОбработки = Новый Структура();
	КонецЕсли;
	
	ПараметрыОбработки.Вставить(ИмяПараметра, Значение);

	Если НЕ ЕстьПеременнаяМодуля(ИмяПараметра) Тогда
		Возврат;
	КонецЕсли;

	Если ВРег(ИмяПараметра) = "ПУТЬККОНФИГУРАЦИИ" Тогда
		ВремФайл = Новый Файл(Значение);
		ПутьККонфигурации = ВремФайл.ПолноеИмя;
	ИначеЕсли ВРег(ИмяПараметра) = "РЕПОЗИТАРИЙГИТ" Тогда
		ВремФайл = Новый Файл(Значение);
		РепозитарийГит = ВремФайл.ПолноеИмя;
	Иначе
		Выполнить(СтрШаблон("%1 = Значение;", ИмяПараметра));
	КонецЕсли;
	
КонецПроцедуры // УстановитьПараметрОбработкиДанных()

// Процедура - устанавливает данные для обработки
//
// Параметры:
//	ВходящиеДанные      - Структура     - значения параметров обработки
//
Процедура УстановитьДанные(Знач ВходящиеДанные) Экспорт
	
КонецПроцедуры // УстановитьДанные()

// Процедура - выполняет обработку данных
//
Процедура ОбработатьДанные() Экспорт

	Распаковщик.ОбеспечитьКаталог(РепозитарийГит);

	ГитРепозиторий.УстановитьРабочийКаталог(РепозитарийГит);

	СлужебныйКаталогГит = Новый Файл(ОбъединитьПути(РепозитарийГит, ".git"));
	МаскаПоискаФайлов = ?(Не КонвертироватьВФорматЕДТ, "*", "src|DT-INF");
	МенеджерВР = Новый МенеджерВременныхФайлов();
	
	Если НЕ СлужебныйКаталогГит.Существует() Тогда
		ГитРепозиторий.Инициализировать();
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ОтносительныйПуть) Тогда
		КаталогВыгрузки = ОбъединитьПути(РепозитарийГит, "src", "cf");
	Иначе
		КаталогВыгрузки = ОбъединитьПути(РепозитарийГит, ОтносительныйПуть);
	КонецЕсли;

	Сообщить(КаталогВыгрузки);

	ВремФайл = Новый Файл(КаталогВыгрузки);
	Если ВремФайл.Существует() Тогда
		ФайлОписания = Новый Файл(ОбъединитьПути(РепозитарийГит, "description.json"));
		ОписаниеВерсии = Новый Структура("Имя, Версия, Дата");
		Если ФайлОписания.Существует() Тогда
			ОписаниеВерсии = Служебный.ОписаниеРелиза(ФайлОписания.ПолноеИмя);
		КонецЕсли;
		
		Лог.Информация("[%1]: Начало удаления файлов версии %2 (%3) конфигурации ""%4"" из репозитария ""%5""",
		               ТипЗнч(ЭтотОбъект),
		               ОписаниеВерсии.Версия,
		               Формат(ОписаниеВерсии.Дата, "ДФ=dd.MM.yyyy; ДП=-"),
		               ОписаниеВерсии.Имя,
		               КаталогВыгрузки);
		Для каждого Маска Из СтрРазделить(МаскаПоискаФайлов, "|") Цикл
			УдалитьФайлы(КаталогВыгрузки, Маска);
		КонецЦикла;	
	КонецЕсли;

	Распаковщик.ОбеспечитьКаталог(КаталогВыгрузки);

	ФайлКонфигурации = Новый Файл(ПутьККонфигурации);
	ФайлОписания = Новый Файл(ОбъединитьПути(ФайлКонфигурации.Путь, "description.json"));
	ОписаниеВерсии = Новый Структура("Имя, Версия, Дата");
	Если ФайлОписания.Существует() Тогда
		ОписаниеВерсии = Служебный.ОписаниеРелиза(ФайлОписания.ПолноеИмя);
	КонецЕсли;
	
	Лог.Информация("[%1]: Начало загрузки версии %2 (%3) конфигурации ""%4"" из файла ""%5""",
	               ТипЗнч(ЭтотОбъект),
	               ОписаниеВерсии.Версия,
				   Формат(ОписаниеВерсии.Дата, "ДФ=dd.MM.yyyy; ДП=-"),
	               ОписаниеВерсии.Имя,
	               ПутьККонфигурации);

	Конфигуратор = Новый УправлениеКонфигуратором();
	Конфигуратор.ИспользоватьВерсиюПлатформы(ВерсияПлатформы);
	Конфигуратор.УстановитьКонтекст(База_СтрокаСоединения, "", "");

	Конфигуратор.ЗагрузитьКонфигурациюИзФайла(ПутьККонфигурации);

	КаталогВыгрузкиИсходников = ?(КонвертироватьВФорматЕДТ, МенеджерВР.СоздатьКаталог("config-src"), КаталогВыгрузки);
	ШаблонТекстаВыгрузки = ?(
		КонвертироватьВФорматЕДТ,
		"[%1]: Начало выгрузки в файлы версии %2 (%3) конфигурации ""%4"" во временный каталог ""%5""",
		"[%1]: Начало выгрузки в файлы версии %2 (%3) конфигурации ""%4"" в репозитарий ""%5"""
	);
	Лог.Информация(ШаблонТекстаВыгрузки,
	               ТипЗнч(ЭтотОбъект),
	               ОписаниеВерсии.Версия,
				   Формат(ОписаниеВерсии.Дата, "ДФ=dd.MM.yyyy; ДП=-"),
	               ОписаниеВерсии.Имя,
	               КаталогВыгрузкиИсходников);
	Конфигуратор.ВыгрузитьКонфигурациюВФайлы(КаталогВыгрузкиИсходников);

	Если ФайлОписания.Существует() Тогда
		НовыйФайлОписания = ОбъединитьПути(РепозитарийГит, "description.json");
		КопироватьФайл(ФайлОписания.ПолноеИмя, НовыйФайлОписания);
	КонецЕсли;

	ФайлДампа = Новый Файл(ОбъединитьПути(КаталогВыгрузкиИсходников, "ConfigDumpInfo.xml"));
	Если ФайлДампа.Существует() Тогда
		УдалитьФайлы(ФайлДампа.ПолноеИмя);
	КонецЕсли;

	Если КонвертироватьВФорматЕДТ Тогда
		Лог.Информация("[%1]: Начало конвертации в формат ЕДТ", ТипЗнч(ЭтотОбъект));	
		ВоркСпейсЕДТ = МенеджерВР.СоздатьКаталог("edt-ws");
		
		Команда = Новый Команда();
		ПараметрыЕНВ = Новый Соответствие();
		ПараметрыЕНВ.Вставить("RING_OPTS", "-Dfile.encoding=UTF-8 -Dosgi.nl=ru -Duser.language=ru");
		Команда.УстановитьПеременныеСреды(ПараметрыЕНВ);
		Команда.УстановитьКоманду("ring");
		Команда.УстановитьКодировкуВывода(КодировкаТекста.UTF8);
		ПараметрыЗапускаЕДТ = Новый Массив();
		ПараметрыЗапускаЕДТ.Добавить("edt workspace import");
		ПараметрыЗапускаЕДТ.Добавить("--configuration-files");
		ПараметрыЗапускаЕДТ.Добавить(КаталогВыгрузкиИсходников);
		ПараметрыЗапускаЕДТ.Добавить("--project-name tmp");
		ПараметрыЗапускаЕДТ.Добавить("--workspace-location");
		ПараметрыЗапускаЕДТ.Добавить(ВоркСпейсЕДТ);

		Команда.ДобавитьПараметры(ПараметрыЗапускаЕДТ);

		КодВозврата = Команда.Исполнить();

		Если КодВозврата <> 0 Тогда
			ВызватьИсключение Команда.ПолучитьВывод();			
		КонецЕсли;

		Для Каждого Маска Из СтрРазделить(МаскаПоискаФайлов, "|") Цикл
			ФайлыКПеремещению = НайтиФайлы(ОбъединитьПути(ВоркСпейсЕДТ, "tmp"), Маска); 
			Для каждого Файл Из ФайлыКПеремещению Цикл

				ФС.КопироватьСодержимоеКаталога(Файл.ПолноеИмя, ОбъединитьПути(КаталогВыгрузки, Файл.Имя));

			КонецЦикла;	
		КонецЦикла;

		МенеджерВР.Удалить();
		
		Лог.Информация("[%1]: Завершена конвертация в формат ЕДТ", ТипЗнч(ЭтотОбъект));	
	КонецЕсли;

	Лог.Информация("[%1]: Начало добавления изменений в индекс Git", ТипЗнч(ЭтотОбъект));

	ГитРепозиторий.ДобавитьФайлВИндекс(".");
	ГитРепозиторий.УстановитьНастройку("user.name", ИмяАвтора);
	ГитРепозиторий.УстановитьНастройку("user.email", ПочтаАвтора);
	ПредставлениеАвтора = ИмяАвтора + " <" + ПочтаАвтора + ">";

	Лог.Информация("[%1]: Начало помещения изменений в Git", ТипЗнч(ЭтотОбъект));

	ГитРепозиторий.Закоммитить(СообщениеКоммита, Истина, , ПредставлениеАвтора, ДатаКоммита, , ДатаКоммита);

	Лог.Информация("[%1]: Помещение изменений в Git завершено", ТипЗнч(ЭтотОбъект));

	ПродолжениеОбработкиДанныхВызовМенеджера(КаталогВыгрузки);

	ЗавершениеОбработкиДанныхВызовМенеджера();

КонецПроцедуры // ОбработатьДанные()

Функция РезультатОбработки() Экспорт
	
	Возврат НакопленныеДанные;
	
КонецФункции // РезультатОбработки()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанных() Экспорт
	
	Лог.Информация("[%1]: Завершение обработки данных.", ТипЗнч(ЭтотОбъект));

	ЗавершениеОбработкиДанныхВызовМенеджера();
	
КонецПроцедуры // ЗавершениеОбработкиДанных()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныйПрограммныйИнтерфейс

// Функция - возвращает объект управления логированием
//
// Возвращаемое значение:
//  Объект      - объект управления логированием
//
Функция Лог() Экспорт
	
	Возврат Лог;

КонецФункции // Лог()

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.Опция("v v8version", "", "маска версии платформы 1С (8.3, 8.3.6 и т.п.)")
	       .ТСтрока()
	       .ВОкружении("V8VERSION");

	Команда.Опция("cf cf-path", "", "путь к файлу конфигурации (CF) для выгрузки")
	       .ТСтрока()
	       .ВОкружении("YARD_CF_PATH");

	Команда.Опция("g git-path", "", "путь к репозитарию git")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_PATH");

	Команда.Опция("b git-branch", "base1c", "имя ветки git в которую будет выполняться выгрузка")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_BRANCH");

	Команда.Опция("a git-author", "1c", "имя автора коммита в git")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_AUTHOR");

	Команда.Опция("e git-author-email", "1c@1c.ru", "почта автора коммита в git")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_AUTHOR_EMAIL");

	ДатаКоммита = Служебный.ДатаPOSIX(ТекущаяУниверсальнаяДата());
	Команда.Опция("d git-commit-date", ДатаКоммита, "дата коммита в git в формате POSIX (yyyy-MM-dd HH:mm:ss)")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_COMMIT_DATE");

	Команда.Опция("m git-commit-message", "", "сообщение коммита в git")
	       .ТСтрока()
	       .ВОкружении("YARD_GIT_COMMIT_MESSAGE");
	
		   
	Команда.Опция("C ibconnection", "", "строка подключения к служебной базе 1С для выполнения обновления")
	       .ТСтрока()
	       .ВОкружении("YARD_IB_CONNECTION");

	Команда.Опция("edt convert-to-edt", Ложь, "конвертировать в едт")
			.Флаг();

	Команда.Опция("srp src-relative-path", ОбъединитьПути("src", "cf"), "относительный путь исходников в репозитарии")
			.ТСтрока()
			.ВОкружении("YARD_GIT_SRC_PATH");

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ВыводОтладочнойИнформации = Команда.ЗначениеОпции("verbose");

	ПараметрыПриложения.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	УстановитьПараметрОбработкиДанных("ВерсияПлатформы"      	, Команда.ЗначениеОпции("v8version"));
	УстановитьПараметрОбработкиДанных("ПутьККонфигурации"    	, Команда.ЗначениеОпции("cf-path"));
	УстановитьПараметрОбработкиДанных("РепозитарийГит"       	, Команда.ЗначениеОпции("git-path"));
	УстановитьПараметрОбработкиДанных("ИмяВеткиГит"          	, Команда.ЗначениеОпции("git-branch"));
	УстановитьПараметрОбработкиДанных("ИмяАвтора"            	, Команда.ЗначениеОпции("git-author"));
	УстановитьПараметрОбработкиДанных("ПочтаАвтора"          	, Команда.ЗначениеОпции("git-author-email"));
	УстановитьПараметрОбработкиДанных("ДатаКоммита"          	, Команда.ЗначениеОпции("git-commit-date"));
	УстановитьПараметрОбработкиДанных("СообщениеКоммита"     	, Команда.ЗначениеОпции("git-commit-message"));
	УстановитьПараметрОбработкиДанных("База_СтрокаСоединения"	, Команда.ЗначениеОпции("ibconnection"));
	УстановитьПараметрОбработкиДанных("КонвертироватьВФорматЕДТ", Команда.ЗначениеОпции("convert-to-edt"));
	УстановитьПараметрОбработкиДанных("ОтносительныйПуть"    	, Команда.ЗначениеОпции("src-relative-path"));

	ОбработатьДанные();

КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#Область СлужебныеПроцедурыВызоваМенеджераОбработкиДанных

// Процедура - выполняет действия обработки элемента данных
// и оповещает обработку-менеджер о продолжении обработки элемента
//
//	Параметры:
//		Элемент    - Произвольный     - Элемент данных для продолжения обработки
//
Процедура ПродолжениеОбработкиДанныхВызовМенеджера(Элемент)
	
	Если МенеджерОбработкиДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработкиДанных.ПродолжениеОбработкиДанных(Элемент, Идентификатор);
	
КонецПроцедуры // ПродолжениеОбработкиДанныхВызовМенеджера()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанныхВызовМенеджера()
	
	Если МенеджерОбработкиДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработкиДанных.ЗавершениеОбработкиДанных(Идентификатор);
	
КонецПроцедуры // ЗавершениеОбработкиДанныхВызовМенеджера()

#КонецОбласти // СлужебныеПроцедурыВызоваМенеджераОбработкиДанных

#Область СлужебныеПроцедурыИФункции

// Процедура - добавляет описание параметра обработки
// 
// Параметры:
//     ОписаниеПараметров     - Структура      - структура описаний параметров
//     Параметр               - Строка         - имя параметра
//     Тип                    - Строка         - список возможных типов параметра
//     Обязательный           - Булево         - Истина - параметр обязателен
//     ЗначениеПоУмолчанию    - Произвольный   - значение параметра по умолчанию
//     Описание               - Строка         - описание параметра
//
Процедура ДобавитьОписаниеПараметра(ОписаниеПараметров
	                              , Параметр
	                              , Тип
	                              , Обязательный = Ложь
	                              , ЗначениеПоУмолчанию = Неопределено
	                              , Описание = "")
	
	Если НЕ ТипЗнч(ОписаниеПараметров) = Тип("Структура") Тогда
		ОписаниеПараметров = Новый Структура();
	КонецЕсли;
	
	ОписаниеПараметра = Новый Структура();
	ОписаниеПараметра.Вставить("Тип"                , Тип);
	ОписаниеПараметра.Вставить("Обязательный"       , Обязательный);
	ОписаниеПараметра.Вставить("ЗначениеПоУмолчанию", ЗначениеПоУмолчанию);
	ОписаниеПараметра.Вставить("Описание"           , Описание);
	
	ОписаниеПараметров.Вставить(Параметр, ОписаниеПараметра);
	
КонецПроцедуры // ДобавитьОписаниеПараметра()

// Процедура - устанавливает значение переменной модуля с указанным именем
// из значения структуры с тем же именем или значение по умолчанию
// 
// Параметры:
//	ИмяПараметра          - Строка           - имя параметра для установки значения
//	СтруктураПараметров   - Структура        - структуры значений параметров
//	ЗначениеПоУмолчанию   - Произвольный     - значение переменной по умолчанию
//
Процедура УстановитьПараметрОбработкиДанныхИзСтруктуры(Знач ИмяПараметра,
	                                                  Знач СтруктураПараметров,
	                                                  Знач ЗначениеПоУмолчанию = "")

	Если НЕ ЕстьПеременнаяМодуля(ИмяПараметра) Тогда
		Возврат;
	КонецЕсли;

	ЗначениеПараметра = ЗначениеПоУмолчанию;

	Если СтруктураПараметров.Свойство(ИмяПараметра) Тогда
		ЗначениеПараметра = СтруктураПараметров[ИмяПараметра];
	КонецЕсли;

	Выполнить(СтрШаблон("%1 = ЗначениеПараметра;", ИмяПараметра));

КонецПроцедуры // УстановитьПараметрОбработкиДанныхИзСтруктуры()

// Функция - проверяет наличие в текущем модуле переменной с указанным именем
// 
// Параметры:
//	ИмяПеременной      - Строка           - имя переменной для проверки
//
// Возвращаемое значение:
//	Булево      - Истина - переменная существует; Ложь - в противном случае.
//
Функция ЕстьПеременнаяМодуля(Знач ИмяПеременной)

	Попытка
		ЗначениеПеременной = Вычислить(ИмяПеременной);
	Исключение
		Возврат Ложь;
	КонецПопытки;

	Возврат Истина;

КонецФункции // ЕстьПеременнаяМодуля()

#КонецОбласти // СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПриСозданииОбъекта"
//
// Параметры:
//  Менеджер	 - МенеджерОбработкиДанных    - менеджер обработки данных - владелец
// 
// BSLLS:UnusedLocalMethod-off
Процедура ПриСозданииОбъекта(Менеджер = Неопределено)

	УстановитьМенеджерОбработкиДанных(Менеджер);

	Лог = ПараметрыПриложения.Лог();

	ГитРепозиторий = Новый ГитРепозиторий();

	Лог.Информация("[%1]: Инициализирован обработчик", ТипЗнч(ЭтотОбъект));

КонецПроцедуры // ПриСозданииОбъекта()
// BSLLS:UnusedLocalMethod-on

#КонецОбласти // ОбработчикиСобытий
