# TEAMWORK - Topic 04 (SQL DDL)

## Склад команди
Команда: Микола Астаф'єв, Anastasiia Khudych, Maksym Bielik, Vladyslav Kurchyk
Варіант предметної області: Variant 2 — Fitness Center Management
Рівень: Medium

| Учасник            | Роль у команді    | Що зроблено                                                                                           | Артефакти / файли           |
| ------------------ | ----------------- | ----------------------------------------------------------------------------------------------------- | --------------------------- |
| Anastasiia Khudych | Database Designer | Designed `members`, `memberships`, and `fitness_goals` tables and their relationships.               | database schema |
| Микола Астаф'єв    | Database Designer | Designed `trainers`, `specializations`, and `trainer_specializations` tables and their relationships. | database schema |
| Maksym Bielik      | Database Designer | Designed equipment_types, rooms, equipment_items, progress, personal_training, class_equipments            | database schema |
| Vladyslav Kurchyk  | Database Designer | Designed `classes` and `attendance` tables and their relationships.                                   | database schema |

### Контекст теми

* **Створення таблиць**: Розподілено за предметними блоками між усім складом команди:
  * **Anastasiia Khudych**: `members`, `memberships`, `fitness_goals`, кастомні типи ENUM (`membership_type`, `goal_type`).
  * **Mykola Astafiev**: `trainers`, `specializations`, `trainer_specializations`.
  * **Maksym Bielik**: `equipment_types`, `rooms`, `equipment_items`, `progress`, `personal_training`, `class_equipments`, кастомні типи ENUM (`equipment_status`, `session_status`).
  * **Vladyslav Kurchyk**: `classes`, `attendance`.
* **PK / FK та Constraints**: 
  * Кожен учасник описував первинні та зовнішні ключі (у тому числі `ON DELETE CASCADE / RESTRICT / SET NULL`), а також обмеження (`NOT NULL`, `UNIQUE`, `DEFAULT`) у своєму блоці таблиць.
  * Первинні ключі для зв'язуючих таблиць N:M (`trainer_specializations`, `class_equipments`) реалізовано як складені PK (*Composite Keys*).
* **Indexes**: Додано індекси для всіх полів зовнішніх ключів (FK) та часто використовуваних у пошуку/фільтрації атрибутів (реалізовано централізовано в кінці DDL).
* **Порядок секцій у `ddl.sql`**:
  1. `CLEANUP` (`DROP TABLE ... CASCADE` та `DROP TYPE ... CASCADE`).
  2. `ENUMS` (створення всіх перелічуваних типів даних).
  3. `TABLES & CONSTRAINTS` (створення таблиць із внутрішніми PK, FK та обмеженнями у порядку виникнення залежностей).
  4. `INDEXES` (створення індексів після формування всіх таблиць).
* **Перевірка виконання скрипта**: Maksym Bielik (запускав фінальний `ddl.sql`, перевіряв відсутність помилок виконання та переконувався у коректності генерації схеми).

---

### Коротке обґрунтування командного підходу

1. **Як ви розподілили DDL-об'єкти між учасниками**:
   Розподіл відбувся за логічними модулями ER-діаграми: Анастасія відповідала за блок клієнтів та абонементів, Микола — за блок тренерів та їхніх компетенцій, Максим — за облік інвентарю, залів, персональних тренувань та прогресу, а Владислав — за групові заняття та журнал відвідуваності.

2. **Чому обрали саме такий поділ роботи**:
   Це мінімізувало конфлікти під час злиття коду (git merge conflicts) та дозволило кожному учаснику глибоко опрацювати цілісність даних та типи у своїй предметній галузі. Спільні таблиці (наприклад, `class_equipments`) розроблялися суміжно авторами відповідних блоків.

3. **Як перевіряли відповідність DDL вашій ER-діаграмі**:
   Перевірка виконувалася шляхом імпорту згенерованого DDL-скрипта назад у графічний інструмент (dbdiagram.io) та зіставлення отриманої автоматичної діаграми з фінальною схемою DBML, а також звіркою відповідності типів даних (наприклад, `VARCHAR(20)` для телефонів, `DECIMAL(6,2)` для вимірів) та з'єднувальних FK-полів.
