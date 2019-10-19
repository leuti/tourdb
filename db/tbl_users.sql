-- Add new field for MD5 encrypted user password
-- Field usrPasswd to be removed once tourdb is gone live

ALTER TABLE `tbl_users` ADD `usrPassword` TEXT NOT NULL AFTER `usrPasswd`;