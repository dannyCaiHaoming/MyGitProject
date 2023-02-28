create database if not exists `messageboard`;
use `messageboard`;

drop table if exists `message`;
create table if not exists `message`(
    `message_id` bigint(20) unsigned not null auto_increment,
    `message_user` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
    `message_content` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
    `message_time` datetime not null default current_timestamp,
    primary key(`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;