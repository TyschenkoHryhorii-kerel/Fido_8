create table if not exists public.students (
  id bigint generated always as identity primary key,
  name_student VARCHAR(50) not null, 
  date_of_birth date not null,
  email text not null,
  telefone integer not null,
  year_of_university_entry integer not null
);

//студенти(представленні в виді тварин, адже мені було впадлу придумувати нормальні імена)
delete from public.students;
insert into public.students (name_student, date_of_birth, email, telefone, year_of_university_entry) 
values ('cat', '2020-02-17', 'cat@gmail.com', '911', '2016');
insert into public.students (name_student, date_of_birth, email, telefone, year_of_university_entry) 
values ('dog', '1991-08-24', 'dog@gmail.com', '811', '2017');
insert into public.students (name_student, date_of_birth, email, telefone, year_of_university_entry) 
values ('rat', '1988-01-01', 'rat@gmail.com', '711', '2018');

alter table public.students enable row level security;

drop policy if exists "public read messages" on public.students;
create policy "public read messages"
  on public.students for select to anon using (true);
  
drop table if exists public.helpingTable cascade;
drop table if exists public.subject cascade;

create table public.subject (
  id bigint generated always as identity primary key,
  name_subject text not null unique,
  description_ text not null,
  count_of_credits integer not null,
  count_of_hours integer not null
);

//табличка предметів, можете трохи розслабитися and посміятися чучуть
insert into public.subject (name_subject, description_, count_of_credits, count_of_hours)
values ('Прикладна прокрастинація', 'Студенти опановують техніки перенесення дедлайнів в власній свідомості, створення ілюзії продуктивності та виконання семестрової роботи за 40 хвилин до її здачі.', 10, 50);

insert into public.subject (name_subject, description_, count_of_credits, count_of_hours)
values ('Прикладна амнезія', 'дослідження вибіркової втрати памʼяті під час запитання викладача', 10, 60);

insert into public.subject (name_subject, description_, count_of_credits, count_of_hours)
values ('Поклоніння whatsapp', 'Молитва єдиному й найзручнішому мессенджеру наукма', 20, 100);

insert into public.subject (name_subject, description_, count_of_credits, count_of_hours)
values ('Програмування', 'бдсм з керелом', 500, 500);

alter table public.subject enable row level security;
drop policy if exists "public read subject" on public.subject;
create policy "public read subject"
  on public.subject for select to anon using (true);

drop table if exists public.helpingTable cascade;

create table public.helpingTable (
  id bigint generated always as identity primary key,
  student_id bigint not null references public.students(id) on delete cascade,
  subject_id bigint not null references public.subject(id) on delete cascade,
  group_number int not null
);


//допоміжна табличка
insert into public.helpingTable (student_id, subject_id, group_number)
select s.id, sub.id, 5
from public.students s, public.subject sub
where s.name_student = 'cat' and sub.name_subject = 'Програмування';

insert into public.helpingTable (student_id, subject_id, group_number)
select s.id, sub.id, 5
from public.students s, public.subject sub
where s.name_student = 'dog' and sub.name_subject = 'Програмування';

insert into public.helpingTable (student_id, subject_id, group_number)
select s.id, sub.id, 3
from public.students s, public.subject sub
where s.name_student = 'rat' and sub.name_subject = 'Прикладна прокрастинація';

alter table public.helpingTable enable row level security;
drop policy if exists "public read help" on public.helpingTable;
create policy "public read help"
  on public.helpingTable for select to anon using (true);

//виводить імена та імейли  студентів 5ї групи з програмування
select s.name_student as "Name", s.email
from public.students s
join public.helpingTable h on h.student_id = s.id
join public.subject sub on sub.id = h.subject_id
where sub.name_subject = 'Програмування'
  and h.group_number = 5;